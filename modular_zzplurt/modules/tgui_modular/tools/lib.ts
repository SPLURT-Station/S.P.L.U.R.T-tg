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
	const inferredOperation = inferAstPatchOperation(
		options.upstreamSource,
		options.localSource,
		target,
	);
	const manifestPath = path.resolve(outputDir, `${slugTarget(target)}.tgui.ts`);
	const importPath = toImportPath(
		path.relative(outputDir, path.resolve(options.moduleRoot, 'index')),
	);

	if (inferredOperation) {
		fs.mkdirSync(outputDir, { recursive: true });
		fs.writeFileSync(
			manifestPath,
			renderPatchManifest({
				importPath,
				operation: inferredOperation,
				target,
			}),
		);

		return {
			changed: true,
			manifestPath,
			operation: inferredOperation,
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
		} else if (override.operation) {
			definitions.entries.push({
				kind: 'patch',
				patch: {
					operations: [override.operation],
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
	operation: ModularTguiPatchOperation;
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
		indent(renderObject(options.operation), 3),
		'\t\t],',
		'\t},',
		'];',
		'',
	].join('\n');
}

function inferAstPatchOperation(
	upstreamSource: string,
	localSource: string,
	target: string,
) {
	const importOperation = inferAstAddImport(upstreamSource, localSource);

	if (
		importOperation &&
		applyPatchOperations(upstreamSource, [importOperation], target) === localSource
	) {
		return importOperation;
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
