import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';

import { overrides, patches, scanRoots } from '../manifest';
import {
	loadModularTguiDefinitions,
	type LoadedModularTguiDefinitions,
} from '../manifest_loader';
import {
	applyPatchOperations,
	type ModularTguiPatch,
	type ModularTguiPatchOperation,
} from '../patches';

const MIN_INFERRED_REPLACE_LINE_CAP = 24;
const MAX_INFERRED_DELETE_LINES = 80;
const MAX_INFERRED_INSERT_LINES = 260;
const MAX_INFERRED_REPLACE_ADDED_LINES = 160;
const MAX_INFERRED_REPLACE_REMOVED_LINES = 80;
const REPLACE_LINE_CAP_FILE_FRACTION = 0.12;
const MAX_INFERRED_LINE_REPLACEMENTS = 20;

export type ToolPaths = {
	moduleRoot: string;
	repoRoot: string;
	tguiRoot: string;
};

export type CreateOverrideOptions = {
	localSource: string;
	moduleRoot: string;
	outputDir: string;
	target: string;
	upstreamSource: string;
};

export type CreateOverrideResult = {
	changed: boolean;
	manifestPath?: string;
	operation?: ModularTguiPatchOperation;
	operations?: ModularTguiPatchOperation[];
	replacement?: string;
	replacementPath?: string;
	strategy?: 'ast-patch' | 'whole-file-override';
	target: string;
	warnings: string[];
};

export type GenerateFinalOptions = {
	baseSource?: string;
	definitions: LoadedModularTguiDefinitions;
	moduleRoot: string;
	target: string;
	tguiRoot: string;
};

export type GenerateFinalResult = {
	source: string;
	sourceKind: 'local' | 'override' | 'patch';
	target: string;
};

export type MigrateOptions = {
	outputDir: string;
	paths: ToolPaths;
	targets?: string[];
	upstreamRef?: string;
	upstreamSources?: Record<string, string>;
	upstreamUrl?: string;
};

export type MigrateResult = {
	migrated: string[];
	skipped: string[];
};

export function getDefaultToolPaths(): ToolPaths {
	const moduleRoot = path.resolve(import.meta.dirname, '..');
	const repoRoot = path.resolve(moduleRoot, '../../..');

	return {
		moduleRoot,
		repoRoot,
		tguiRoot: path.resolve(repoRoot, 'tgui'),
	};
}

export function loadConfiguredDefinitions(moduleRoot: string) {
	return loadModularTguiDefinitions(moduleRoot, {
		overrides,
		patches,
		scanRoots,
	});
}

export function normalizeTguiTarget(target: string) {
	const normalizedTarget = target.replaceAll('\\', '/');
	const withoutLeadingSlash = normalizedTarget.replace(/^\/+/, '');

	if (withoutLeadingSlash.startsWith('tgui/')) {
		return withoutLeadingSlash.slice('tgui/'.length);
	}

	return withoutLeadingSlash;
}

export function createOverrideFromSources(options: CreateOverrideOptions) {
	const target = normalizeTguiTarget(options.target);

	if (options.localSource === options.upstreamSource) {
		return {
			changed: false,
			target,
			warnings: [],
		} satisfies CreateOverrideResult;
	}

	const outputDir = path.resolve(options.outputDir);
	const inferredOperations = inferPatchOperations(
		options.upstreamSource,
		options.localSource,
		target,
	);
	const manifestPath = path.resolve(outputDir, `${slugTarget(target)}.tgui.ts`);
	const importPath = toImportPath(
		path.relative(outputDir, path.resolve(options.moduleRoot, 'index')),
	);

	if (inferredOperations) {
		fs.mkdirSync(outputDir, { recursive: true });
		fs.writeFileSync(
			manifestPath,
			renderPatchManifest({
				importPath,
				operations: inferredOperations,
				target,
			}),
		);

		return {
			changed: true,
			manifestPath,
			operation: inferredOperations[0],
			operations: inferredOperations,
			strategy: 'ast-patch',
			target,
			warnings: [],
		} satisfies CreateOverrideResult;
	}

	const replacement = path.join('overrides', target);
	const replacementPath = path.resolve(outputDir, replacement);

	fs.mkdirSync(path.dirname(replacementPath), { recursive: true });
	fs.writeFileSync(replacementPath, options.localSource);
	fs.writeFileSync(
		manifestPath,
		renderOverrideManifest({
			importPath,
			replacement: toPosixPath(replacement),
			target,
		}),
	);

	return {
		changed: true,
		manifestPath,
		replacement: toPosixPath(replacement),
		replacementPath,
		strategy: 'whole-file-override',
		target,
		warnings: [
			`Could not infer a safe AST patch for ${target}; wrote a whole-file override instead.`,
		],
	} satisfies CreateOverrideResult;
}

export function generateFinalSource(options: GenerateFinalOptions) {
	const target = normalizeTguiTarget(options.target);
	const targetPath = path.resolve(options.tguiRoot, target);
	const baseSource =
		options.baseSource ?? fs.readFileSync(targetPath, 'utf8');
	let source = baseSource;
	let sourceKind: GenerateFinalResult['sourceKind'] = 'local';

	for (const entry of options.definitions.entries) {
		if (entry.kind === 'override') {
			if (normalizeTguiTarget(entry.override.target) !== target) {
				continue;
			}

			source = fs.readFileSync(
				path.resolve(entry.override.sourceRoot, entry.override.replacement),
				'utf8',
			);
			sourceKind = 'override';
			continue;
		}

		if (normalizeTguiTarget(entry.patch.target) !== target) {
			continue;
		}

		source = applyPatchOperations(source, entry.patch.operations, target);
		sourceKind = 'patch';
	}

	return {
		source,
		sourceKind,
		target,
	} satisfies GenerateFinalResult;
}

export async function readUpstreamSource(options: {
	paths: ToolPaths;
	target: string;
	upstreamRef?: string;
	upstreamUrl?: string;
}) {
	const target = normalizeTguiTarget(options.target);

	if (options.upstreamUrl) {
		const response = await fetch(upstreamRawUrl(options.upstreamUrl, target));
		if (!response.ok) {
			throw new Error(
				`Failed to fetch upstream file ${target}: ${response.status} ${response.statusText}`,
			);
		}

		return response.text();
	}

	const upstreamRef = options.upstreamRef ?? detectUpstreamRef(options.paths.repoRoot);
	return readGitFile(options.paths.repoRoot, upstreamRef, `tgui/${target}`);
}

export function listModifiedTguiFiles(paths: ToolPaths, upstreamRef?: string) {
	const ref = upstreamRef ?? detectUpstreamRef(paths.repoRoot);
	const diff = spawnText([
		'git',
		'diff',
		'--name-only',
		'--diff-filter=M',
		ref,
		'--',
		'tgui',
	], paths.repoRoot);

	return diff
		.split('\n')
		.filter(Boolean)
		.filter((filePath) => /\.(tsx?|jsx?)$/.test(filePath))
		.map((filePath) => normalizeTguiTarget(filePath));
}

export async function migrateModifiedTguiFiles(options: MigrateOptions) {
	const targets = options.targets?.map(normalizeTguiTarget) ??
		listModifiedTguiFiles(options.paths, options.upstreamRef);
	const migrated: string[] = [];
	const skipped: string[] = [];

	for (const target of targets) {
		const targetPath = path.resolve(options.paths.tguiRoot, target);
		const localSource = fs.readFileSync(targetPath, 'utf8');
		const tempDir = fs.mkdtempSync(path.join(os.tmpdir(), 'tgui-modular-migrate-'));
		const tempPath = path.join(tempDir, target.replace(/[^a-zA-Z0-9.]+/g, '_'));
		fs.writeFileSync(tempPath, localSource);
		const upstreamSource = options.upstreamSources?.[target] ??
			await readUpstreamSource({
				paths: options.paths,
				target,
				upstreamRef: options.upstreamRef,
				upstreamUrl: options.upstreamUrl,
			});
		const override = createOverrideFromSources({
			localSource,
			moduleRoot: options.paths.moduleRoot,
			outputDir: options.outputDir,
			target,
			upstreamSource,
		});

		if (!override.changed) {
			skipped.push(target);
			continue;
		}

		fs.writeFileSync(targetPath, upstreamSource);

		const definitions = loadConfiguredDefinitions(options.paths.moduleRoot);
		if (override.replacement) {
			definitions.entries.push({
				kind: 'override',
				override: {
					replacement: override.replacement,
					sourceRoot: options.outputDir,
					target,
				},
			});
		} else if (override.operations ?? override.operation) {
			definitions.entries.push({
				kind: 'patch',
				patch: {
					operations: override.operations ?? [override.operation!],
					target,
				},
			});
		}
		const finalSource = generateFinalSource({
			baseSource: upstreamSource,
			definitions,
			moduleRoot: options.paths.moduleRoot,
			target,
			tguiRoot: options.paths.tguiRoot,
		}).source;

		if (finalSource !== localSource) {
			fs.writeFileSync(targetPath, localSource);
			if (override.manifestPath) {
				fs.rmSync(override.manifestPath, { force: true });
			}
			if (override.replacementPath) {
				fs.rmSync(override.replacementPath, { force: true });
			}
			fs.rmSync(tempDir, { force: true, recursive: true });
			throw new Error(`Generated override did not reproduce ${target}`);
		}

		fs.rmSync(tempDir, { force: true, recursive: true });
		migrated.push(target);
	}

	return {
		migrated,
		skipped,
	} satisfies MigrateResult;
}

export function parseArgs(args: string[]) {
	const parsed: Record<string, string | boolean | string[]> = {
		_: [],
	};

	for (let index = 0; index < args.length; index++) {
		const arg = args[index];

		if (!arg.startsWith('--')) {
			(parsed._ as string[]).push(arg);
			continue;
		}

		const key = arg.slice(2);
		const next = args[index + 1];

		if (!next || next.startsWith('--')) {
			parsed[key] = true;
			continue;
		}

		parsed[key] = next;
		index++;
	}

	return parsed;
}

export function requireStringArg(
	args: Record<string, string | boolean | string[]>,
	name: string,
) {
	const value = args[name];

	if (typeof value !== 'string' || value.length === 0) {
		throw new Error(`Missing required --${name}`);
	}

	return value;
}

export function optionalStringArg(
	args: Record<string, string | boolean | string[]>,
	name: string,
) {
	const value = args[name];

	return typeof value === 'string' ? value : undefined;
}

function renderOverrideManifest(options: {
	importPath: string;
	replacement: string;
	target: string;
}) {
	return [
		`import type { ModularTguiOverride } from '${options.importPath}';`,
		'',
		'export const modularTgui = true;',
		'',
		'export const overrides: ModularTguiOverride[] = [',
		'\t{',
		`\t\ttarget: '${options.target}',`,
		`\t\treplacement: '${options.replacement}',`,
		'\t},',
		'];',
		'',
		'export const patches = [];',
		'',
	].join('\n');
}

function renderPatchManifest(options: {
	importPath: string;
	operations: ModularTguiPatchOperation[];
	target: string;
}) {
	return [
		`import type { ModularTguiPatch } from '${options.importPath}';`,
		'',
		'export const modularTgui = true;',
		'',
		'export const overrides = [];',
		'',
		'export const patches: ModularTguiPatch[] = [',
		'\t{',
		`\t\ttarget: '${options.target}',`,
		'\t\toperations: [',
		...options.operations.map((operation) => `${indent(renderObject(operation), 3)},`),
		'\t\t],',
		'\t},',
		'];',
		'',
	].join('\n');
}

function inferPatchOperations(
	upstreamSource: string,
	localSource: string,
	target: string,
) {
	const importOperation = inferAstAddImport(upstreamSource, localSource);

	if (
		importOperation &&
		operationsReproduce(upstreamSource, localSource, [importOperation], target)
	) {
		return [importOperation];
	}

	const lineReplaceOperation = inferRepeatedLineReplace(upstreamSource, localSource);

	if (
		lineReplaceOperation &&
		operationsReproduce(upstreamSource, localSource, [lineReplaceOperation], target)
	) {
		return [lineReplaceOperation];
	}

	const lineReplaceOperations = inferIndependentLineReplacements(
		upstreamSource,
		localSource,
	);

	if (
		lineReplaceOperations &&
		operationsReproduce(upstreamSource, localSource, lineReplaceOperations, target)
	) {
		return lineReplaceOperations;
	}

	const lineHunkOperation = inferSingleLineHunk(upstreamSource, localSource);

	if (
		lineHunkOperation &&
		operationsReproduce(upstreamSource, localSource, [lineHunkOperation], target)
	) {
		return [lineHunkOperation];
	}

	const lineHunkOperations = inferLineHunks(upstreamSource, localSource);

	if (
		lineHunkOperations &&
		operationsReproduce(upstreamSource, localSource, lineHunkOperations, target)
	) {
		return lineHunkOperations;
	}

	return undefined;
}

function operationsReproduce(
	upstreamSource: string,
	localSource: string,
	operations: ModularTguiPatchOperation[],
	target: string,
) {
	try {
		return applyPatchOperations(upstreamSource, operations, target) === localSource;
	} catch {
		return false;
	}
}

function inferRepeatedLineReplace(upstreamSource: string, localSource: string) {
	const upstreamLines = upstreamSource.split('\n');
	const localLines = localSource.split('\n');

	if (upstreamLines.length !== localLines.length) {
		return undefined;
	}

	const replacements = new Map<string, string>();

	for (let index = 0; index < upstreamLines.length; index++) {
		const upstreamLine = upstreamLines[index];
		const localLine = localLines[index];

		if (upstreamLine === localLine) {
			continue;
		}

		const existing = replacements.get(upstreamLine);

		if (upstreamLine.length === 0) {
			return undefined;
		}

		if (existing !== undefined && existing !== localLine) {
			return undefined;
		}

		replacements.set(upstreamLine, localLine);
	}

	if (replacements.size !== 1) {
		return undefined;
	}

	const [[anchor, content]] = replacements;

	return {
		kind: 'replace-all',
		anchor,
		content,
		expectedOccurrences: countOccurrences(upstreamSource, anchor),
	} satisfies ModularTguiPatchOperation;
}

function inferIndependentLineReplacements(
	upstreamSource: string,
	localSource: string,
) {
	const upstreamLines = upstreamSource.split('\n');
	const localLines = localSource.split('\n');

	if (upstreamLines.length !== localLines.length) {
		return undefined;
	}

	const replacements = new Map<string, string>();

	for (let index = 0; index < upstreamLines.length; index++) {
		const upstreamLine = upstreamLines[index];
		const localLine = localLines[index];

		if (upstreamLine === localLine) {
			continue;
		}

		const existing = replacements.get(upstreamLine);

		if (existing !== undefined && existing !== localLine) {
			return undefined;
		}

		replacements.set(upstreamLine, localLine);
	}

	if (
		replacements.size < 2 ||
		replacements.size > MAX_INFERRED_LINE_REPLACEMENTS
	) {
		return undefined;
	}

	return [...replacements].map(([anchor, content]) => {
		return {
			kind: 'replace-all',
			anchor,
			content,
			expectedOccurrences: countOccurrences(upstreamSource, anchor),
		} satisfies ModularTguiPatchOperation;
	});
}

function inferSingleLineHunk(upstreamSource: string, localSource: string) {
	const upstreamLines = upstreamSource.split('\n');
	const localLines = localSource.split('\n');
	let start = 0;

	while (
		start < upstreamLines.length &&
		start < localLines.length &&
		upstreamLines[start] === localLines[start]
	) {
		start++;
	}

	let upstreamEnd = upstreamLines.length;
	let localEnd = localLines.length;

	while (
		upstreamEnd > start &&
		localEnd > start &&
		upstreamLines[upstreamEnd - 1] === localLines[localEnd - 1]
	) {
		upstreamEnd--;
		localEnd--;
	}

	const removedLines = upstreamLines.slice(start, upstreamEnd);
	const addedLines = localLines.slice(start, localEnd);

	return inferLineHunkOperation(
		upstreamLines,
		start,
		upstreamEnd,
		removedLines,
		addedLines,
		upstreamSource,
	);
}

function inferLineHunks(upstreamSource: string, localSource: string) {
	const upstreamLines = upstreamSource.split('\n');
	const localLines = localSource.split('\n');
	const matches = findLineMatches(upstreamLines, localLines);
	const operations: ModularTguiPatchOperation[] = [];
	let upstreamIndex = 0;
	let localIndex = 0;

	for (const [matchedUpstreamIndex, matchedLocalIndex] of [
		...matches,
		[upstreamLines.length, localLines.length] as const,
	]) {
		const removedLines = upstreamLines.slice(upstreamIndex, matchedUpstreamIndex);
		const addedLines = localLines.slice(localIndex, matchedLocalIndex);

		if (removedLines.length > 0 || addedLines.length > 0) {
			const operation = inferLineHunkOperation(
				upstreamLines,
				upstreamIndex,
				matchedUpstreamIndex,
				removedLines,
				addedLines,
				upstreamSource,
			);

			if (!operation) {
				return undefined;
			}

			operations.push(operation);
		}

		upstreamIndex = matchedUpstreamIndex + 1;
		localIndex = matchedLocalIndex + 1;
	}

	if (
		operations.length < 2 ||
		operations.length > MAX_INFERRED_LINE_REPLACEMENTS
	) {
		return undefined;
	}

	return operations;
}

function inferLineHunkOperation(
	upstreamLines: string[],
	start: number,
	upstreamEnd: number,
	removedLines: string[],
	addedLines: string[],
	upstreamSource: string,
) {
	if (removedLines.length === 0 && addedLines.length === 0) {
		return undefined;
	}

	if (!lineHunkWithinDynamicCap(upstreamLines, removedLines, addedLines)) {
		return undefined;
	}

	if (removedLines.length === 0) {
		const content = addedLines.join('\n');

		if (start > 0) {
			const anchor = upstreamLines[start - 1];

			if (anchor.length > 0 && countOccurrences(upstreamSource, anchor) === 1) {
				return {
					kind: 'insert',
					anchor,
					position: 'after',
					content: `\n${content}`,
					expectedOccurrences: 1,
				} satisfies ModularTguiPatchOperation;
			}
		}

		const anchor = upstreamLines[start];

		if (anchor?.length > 0 && countOccurrences(upstreamSource, anchor) === 1) {
			return {
				kind: 'insert',
				anchor,
				position: 'before',
				content: `${content}\n`,
				expectedOccurrences: 1,
			} satisfies ModularTguiPatchOperation;
		}

		if (start > 0) {
			const contextualInsert = inferContextualInsert(
				upstreamLines,
				start,
				addedLines,
				upstreamSource,
			);

			if (contextualInsert) {
				return contextualInsert;
			}
		}

		return undefined;
	}

	if (addedLines.length === 0) {
		const anchor = removedLines.join('\n');
		const hasFollowingLine = upstreamEnd < upstreamLines.length;
		const deleteAnchor = hasFollowingLine ? `${anchor}\n` : anchor;

		if (
			removedLines.every((line) => line.length === 0) ||
			countOccurrences(upstreamSource, deleteAnchor) !== 1
		) {
			const contextualDelete = inferContextualChange(
				upstreamLines,
				start,
				upstreamEnd,
				[],
				upstreamSource,
			);

			if (contextualDelete) {
				return contextualDelete;
			}
		}

		if (deleteAnchor.length === 0) {
			return undefined;
		}

		return {
			kind: 'replace',
			anchor: deleteAnchor,
			content: '',
			expectedOccurrences: countOccurrences(upstreamSource, deleteAnchor),
		} satisfies ModularTguiPatchOperation;
	}

	const anchor = removedLines.join('\n');

	if (anchor.length === 0) {
		const contextualReplace = inferContextualChange(
			upstreamLines,
			start,
			upstreamEnd,
			addedLines,
			upstreamSource,
		);

		if (contextualReplace) {
			return contextualReplace;
		}

		return undefined;
	}

	if (countOccurrences(upstreamSource, anchor) !== 1) {
		const contextualReplace = inferContextualChange(
			upstreamLines,
			start,
			upstreamEnd,
			addedLines,
			upstreamSource,
		);

		if (contextualReplace) {
			return contextualReplace;
		}
	}

	return {
		kind: 'replace',
		anchor,
		content: addedLines.join('\n'),
		expectedOccurrences: countOccurrences(upstreamSource, anchor),
	} satisfies ModularTguiPatchOperation;
}

function lineHunkWithinDynamicCap(
	upstreamLines: string[],
	removedLines: string[],
	addedLines: string[],
) {
	if (removedLines.length === 0) {
		return addedLines.length <= MAX_INFERRED_INSERT_LINES;
	}

	if (addedLines.length === 0) {
		return removedLines.length <= MAX_INFERRED_DELETE_LINES;
	}

	const fileScaledReplaceCap = Math.ceil(
		upstreamLines.length * REPLACE_LINE_CAP_FILE_FRACTION,
	);
	const replaceRemovedCap = Math.max(
		MIN_INFERRED_REPLACE_LINE_CAP,
		Math.min(MAX_INFERRED_REPLACE_REMOVED_LINES, fileScaledReplaceCap),
	);

	return (
		removedLines.length <= replaceRemovedCap &&
		addedLines.length <= MAX_INFERRED_REPLACE_ADDED_LINES
	);
}

function findLineMatches(upstreamLines: string[], localLines: string[]) {
	const width = localLines.length + 1;
	const lengths = new Uint32Array((upstreamLines.length + 1) * width);

	for (let upstreamIndex = upstreamLines.length - 1; upstreamIndex >= 0; upstreamIndex--) {
		for (let localIndex = localLines.length - 1; localIndex >= 0; localIndex--) {
			const offset = upstreamIndex * width + localIndex;

			if (upstreamLines[upstreamIndex] === localLines[localIndex]) {
				lengths[offset] = lengths[(upstreamIndex + 1) * width + localIndex + 1] + 1;
			} else {
				lengths[offset] = Math.max(
					lengths[(upstreamIndex + 1) * width + localIndex],
					lengths[upstreamIndex * width + localIndex + 1],
				);
			}
		}
	}

	const matches: Array<readonly [number, number]> = [];
	let upstreamIndex = 0;
	let localIndex = 0;

	while (upstreamIndex < upstreamLines.length && localIndex < localLines.length) {
		if (upstreamLines[upstreamIndex] === localLines[localIndex]) {
			matches.push([upstreamIndex, localIndex]);
			upstreamIndex++;
			localIndex++;
		} else if (
			lengths[(upstreamIndex + 1) * width + localIndex] >=
				lengths[upstreamIndex * width + localIndex + 1]
		) {
			upstreamIndex++;
		} else {
			localIndex++;
		}
	}

	return matches;
}

function inferContextualInsert(
	upstreamLines: string[],
	start: number,
	addedLines: string[],
	upstreamSource: string,
) {
	for (let beforeCount = 1; beforeCount <= 8; beforeCount++) {
		const beforeStart = start - beforeCount;

		if (beforeStart < 0) {
			break;
		}

		for (let afterCount = 0; afterCount <= 8; afterCount++) {
			const afterEnd = start + afterCount;

			if (afterEnd > upstreamLines.length) {
				break;
			}

			const beforeLines = upstreamLines.slice(beforeStart, start);
			const afterLines = upstreamLines.slice(start, afterEnd);
			const anchor = [...beforeLines, ...afterLines].join('\n');
			const content = [...beforeLines, ...addedLines, ...afterLines].join('\n');

			if (
				anchor.length > 0 &&
				countOccurrences(upstreamSource, anchor) === 1
			) {
				return {
					kind: 'replace',
					anchor,
					content,
					expectedOccurrences: 1,
				} satisfies ModularTguiPatchOperation;
			}
		}
	}

	return undefined;
}

function inferContextualChange(
	upstreamLines: string[],
	start: number,
	upstreamEnd: number,
	addedLines: string[],
	upstreamSource: string,
) {
	for (let beforeCount = 1; beforeCount <= 8; beforeCount++) {
		const beforeStart = start - beforeCount;

		if (beforeStart < 0) {
			break;
		}

		for (let afterCount = 1; afterCount <= 8; afterCount++) {
			const afterEnd = upstreamEnd + afterCount;

			if (afterEnd > upstreamLines.length) {
				break;
			}

			const beforeLines = upstreamLines.slice(beforeStart, start);
			const removedLines = upstreamLines.slice(start, upstreamEnd);
			const afterLines = upstreamLines.slice(upstreamEnd, afterEnd);
			const anchor = [...beforeLines, ...removedLines, ...afterLines].join('\n');
			const content = [...beforeLines, ...addedLines, ...afterLines].join('\n');

			if (
				anchor.length > 0 &&
				countOccurrences(upstreamSource, anchor) === 1
			) {
				return {
					kind: 'replace',
					anchor,
					content,
					expectedOccurrences: 1,
				} satisfies ModularTguiPatchOperation;
			}
		}
	}

	return undefined;
}

function inferAstAddImport(upstreamSource: string, localSource: string) {
	const upstreamImports = readNamedImports(upstreamSource);
	const localImports = readNamedImports(localSource);

	for (const localImport of localImports) {
		const upstreamImport = upstreamImports.find(
			(candidate) =>
				candidate.module === localImport.module &&
				candidate.typeOnly === localImport.typeOnly,
		);

		if (!upstreamImport) {
			continue;
		}

		const addedImports = localImport.imports.filter(
			(importName) => !upstreamImport.imports.includes(importName),
		);

		if (addedImports.length === 0) {
			continue;
		}

		return {
			kind: 'ast-add-import',
			module: localImport.module,
			imports: addedImports,
			...(localImport.typeOnly ? { typeOnly: true } : {}),
		} satisfies ModularTguiPatchOperation;
	}

	return undefined;
}

function readNamedImports(source: string) {
	const imports: Array<{
		imports: string[];
		module: string;
		typeOnly: boolean;
	}> = [];
	const importPattern =
		/import\s+(type\s+)?{(?<imports>[^}]+)}\s+from\s+['"](?<module>[^'"]+)['"]/g;

	for (const match of source.matchAll(importPattern)) {
		const importNames = match.groups?.imports
			.split(',')
			.map((importName) =>
				importName
					.replace(/\s+as\s+\w+$/, '')
					.replace(/^type\s+/, '')
					.trim(),
			)
			.filter(Boolean) ?? [];
		const module = match.groups?.module;

		if (!module || importNames.length === 0) {
			continue;
		}

		imports.push({
			imports: importNames,
			module,
			typeOnly: !!match[1],
		});
	}

	return imports;
}

function countOccurrences(source: string, anchor: string) {
	if (anchor.length === 0) {
		return 0;
	}

	let count = 0;
	let index = source.indexOf(anchor);

	while (index !== -1) {
		count++;
		index = source.indexOf(anchor, index + anchor.length);
	}

	return count;
}

function renderObject(value: unknown): string {
	if (Array.isArray(value)) {
		if (value.length === 0) {
			return '[]';
		}

		return [
			'[',
			...value.map((item) => `${indent(renderObject(item), 1)},`),
			']',
		].join('\n');
	}

	if (value && typeof value === 'object') {
		const entries = Object.entries(value);
		if (entries.length === 0) {
			return '{}';
		}

		return [
			'{',
			...entries.map(([key, entryValue]) => {
				return `${'\t'}${key}: ${renderObject(entryValue).replaceAll('\n', '\n\t')},`;
			}),
			'}',
		].join('\n');
	}

	return JSON.stringify(value);
}

function indent(source: string, level: number) {
	const indentation = '\t'.repeat(level);

	return source
		.split('\n')
		.map((line) => `${indentation}${line}`)
		.join('\n');
}

function slugTarget(target: string) {
	return target
		.replace(/^packages\/tgui\//, '')
		.replace(/\.[^.]+$/, '')
		.replace(/[^a-zA-Z0-9]+/g, '_')
		.replace(/^_+|_+$/g, '')
		.toLowerCase();
}

function toImportPath(importPath: string) {
	const posixPath = toPosixPath(importPath).replace(/\.[^.]+$/, '');

	if (posixPath.startsWith('.')) {
		return posixPath;
	}

	return `./${posixPath}`;
}

function toPosixPath(filePath: string) {
	return filePath.split(path.sep).join('/');
}

function readGitFile(repoRoot: string, ref: string, repoPath: string) {
	return spawnText(['git', 'show', `${ref}:${repoPath}`], repoRoot);
}

function detectUpstreamRef(repoRoot: string) {
	const candidates = ['upstream/master', 'upstream/main', 'origin/master', 'origin/main'];

	for (const candidate of candidates) {
		const result = Bun.spawnSync({
			cmd: ['git', 'rev-parse', '--verify', candidate],
			cwd: repoRoot,
			stderr: 'pipe',
			stdout: 'pipe',
		});

		if (result.exitCode === 0) {
			return candidate;
		}
	}

	throw new Error('Could not detect upstream ref. Pass --upstream-ref.');
}

function spawnText(cmd: string[], cwd: string) {
	const result = Bun.spawnSync({
		cmd,
		cwd,
		stderr: 'pipe',
		stdout: 'pipe',
	});

	if (result.exitCode !== 0) {
		throw new Error(result.stderr.toString() || `${cmd.join(' ')} failed`);
	}

	return result.stdout.toString();
}

function upstreamRawUrl(upstreamUrl: string, target: string) {
	if (upstreamUrl.includes('raw.githubusercontent.com')) {
		return `${upstreamUrl.replace(/\/$/, '')}/tgui/${target}`;
	}

	const match = upstreamUrl.match(
		/^https:\/\/github\.com\/([^/]+)\/([^/]+)(?:\/tree\/([^/]+))?/,
	);

	if (!match) {
		return `${upstreamUrl.replace(/\/$/, '')}/tgui/${target}`;
	}

	const [, owner, repo, branch = 'master'] = match;
	return `https://raw.githubusercontent.com/${owner}/${repo}/${branch}/tgui/${target}`;
}
