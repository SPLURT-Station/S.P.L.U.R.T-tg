import fs from 'node:fs';
import path from 'node:path';

import type { Compiler, RspackPluginInstance } from '@rspack/core';

import { overrides, patches, scanRoots } from './manifest';
import {
	loadModularTguiDefinitions,
	type LoadedModularTguiOverride,
	type LoadedModularTguiEntry,
} from './manifest_loader';
import {
	applyPatchOperations,
	generatedPathForTarget,
	type ModularTguiPatch,
} from './patches';

const PLUGIN_NAME = 'ModularTguiOverlayPlugin';
const RESOLVE_EXTENSIONS = ['.tsx', '.ts', '.js', '.jsx'];
const INDEX_FILENAMES = RESOLVE_EXTENSIONS.map((extension) => `index${extension}`);

export type ModularTguiOverride = {
	/**
	 * Path to the upstream tgui file, relative to the tgui/ directory.
	 */
	target: string;

	/**
	 * Path to the replacement file, relative to this module directory.
	 */
	replacement: string;
};

type ResolvedOverride = {
	target: string;
	targetPath: string;
	replacementPath: string;
	generatedPath: string;
};

type ResolvedPatch = {
	target: string;
	targetPath: string;
	generatedPath: string;
	patch: ModularTguiPatch;
};

type ResolvedEntry =
	| ({
		kind: 'override';
	} & ResolvedOverride)
	| ({
		kind: 'patch';
	} & ResolvedPatch);

class ModularTguiOverlayPlugin implements RspackPluginInstance {
	private readonly dependencyRoot: string;
	private readonly overridesByTarget: Map<string, string>;
	private readonly entries: ResolvedEntry[];
	private readonly generatedRoot: string;
	private readonly tguiRoot: string;

	constructor(
		tguiRoot: string,
		dependencyRoot: string,
		generatedRoot: string,
		entries: ResolvedEntry[],
	) {
		this.dependencyRoot = dependencyRoot;
		this.entries = entries;
		this.generatedRoot = generatedRoot;
		this.tguiRoot = tguiRoot;
		this.overridesByTarget = new Map(
			entries.map((entry) => [entry.target, entry.generatedPath]),
		);
	}

	apply(compiler: Compiler) {
		const emitPatchedSources = () => this.emitPatchedSources();

		compiler.hooks.beforeRun.tap(PLUGIN_NAME, emitPatchedSources);
		compiler.hooks.watchRun.tap(PLUGIN_NAME, emitPatchedSources);

		compiler.hooks.normalModuleFactory.tap(PLUGIN_NAME, (normalModuleFactory) => {
			normalModuleFactory.hooks.beforeResolve.tap(PLUGIN_NAME, (resolveData) => {
				if (
					isInsidePath(resolveData.context, this.generatedRoot) &&
					isBareModuleRequest(resolveData.request)
				) {
					const dependencyRequest = resolveDependencyRequest(
						this.dependencyRoot,
						resolveData.request,
					);

					if (dependencyRequest) {
						resolveData.request = dependencyRequest;
					} else {
						resolveData.context = this.dependencyRoot;
					}
				}

				const replacement = this.findReplacement(
					resolveData.context,
					resolveData.request,
				);

				if (replacement) {
					resolveData.request = replacement;
				}
			});
		});
	}

	private emitPatchedSources() {
		const generatedSources = new Map<string, string>();

		for (const entry of this.entries) {
			if (entry.kind === 'override') {
				generatedSources.set(
					entry.target,
					fs.readFileSync(entry.replacementPath, 'utf8'),
				);
				continue;
			}

			const source =
				generatedSources.get(entry.target) ??
				fs.readFileSync(entry.targetPath, 'utf8');
			const patchedSource = applyPatchOperations(
				source,
				entry.patch.operations,
				entry.patch.target,
			);

			generatedSources.set(entry.target, patchedSource);
		}

		for (const entry of this.entries) {
			const source = generatedSources.get(entry.target);

			if (source === undefined) {
				continue;
			}

			fs.mkdirSync(path.dirname(entry.generatedPath), { recursive: true });
			fs.writeFileSync(entry.generatedPath, source);
		}
	}

	private findReplacement(context: string, request: string) {
		return findOverrideReplacement(
			context,
			request,
			this.overridesByTarget,
			this.tguiRoot,
			this.generatedRoot,
		);
	}
}

export function findOverrideReplacement(
	context: string,
	request: string,
	overridesByTarget: Map<string, string>,
	tguiRoot?: string,
	generatedRoot?: string,
) {
	const requestPath = resolveRequestPath(context, request, tguiRoot, generatedRoot);

	if (!requestPath) {
		return undefined;
	}

	for (const candidate of getResolutionCandidates(requestPath)) {
		const replacement = overridesByTarget.get(normalizePath(candidate));
		if (replacement) {
			return replacement;
		}
	}

	return resolveGeneratedFallback(context, request, tguiRoot, generatedRoot);
}

function resolveRequestPath(
	context: string,
	request: string,
	tguiRoot?: string,
	generatedRoot?: string,
) {
	if (request.startsWith('.')) {
		const resolvedRequest = path.resolve(context, request);
		return toOriginalPathIfGenerated(resolvedRequest, tguiRoot, generatedRoot);
	}

	if (path.isAbsolute(request)) {
		return request;
	}

	if (tguiRoot) {
		const aliasPath = resolveTguiAliasRequest(tguiRoot, request);
		if (aliasPath) {
			return aliasPath;
		}
	}

	return null;
}

function resolveGeneratedFallback(
	context: string,
	request: string,
	tguiRoot?: string,
	generatedRoot?: string,
) {
	if (!request.startsWith('.') || !tguiRoot || !generatedRoot) {
		return undefined;
	}

	const generatedRequestPath = path.resolve(context, request);

	if (!isInsidePath(generatedRequestPath, generatedRoot)) {
		return undefined;
	}

	const originalRequestPath = toOriginalPathIfGenerated(
		generatedRequestPath,
		tguiRoot,
		generatedRoot,
	);

	return originalRequestPath;
}

function toOriginalPathIfGenerated(
	requestPath: string,
	tguiRoot?: string,
	generatedRoot?: string,
) {
	if (!tguiRoot || !generatedRoot || !isInsidePath(requestPath, generatedRoot)) {
		return requestPath;
	}

	return path.resolve(tguiRoot, path.relative(generatedRoot, requestPath));
}

function resolveTguiAliasRequest(tguiRoot: string, request: string) {
	const aliases = [
		['tgui-dev-server', 'packages/tgui-dev-server'],
		['tgui-panel', 'packages/tgui-panel'],
		['tgui-say', 'packages/tgui-say'],
		['tgui', 'packages/tgui'],
	] as const;

	for (const [alias, target] of aliases) {
		if (request === alias || request.startsWith(`${alias}/`)) {
			const rest = request === alias ? '' : request.slice(alias.length + 1);
			return path.resolve(tguiRoot, target, rest);
		}
	}

	return undefined;
}

export function createModularTguiPlugins(tguiRoot = path.resolve()) {
	const moduleRoot = path.resolve(import.meta.dirname);
	const dependencyRoot = resolveDependencyRoot(tguiRoot);
	const generatedRoot = path.resolve(
		dependencyRoot,
		'.cache/tgui_modular',
	);
	const definitions = loadModularTguiDefinitions(moduleRoot, {
		overrides,
		patches,
		scanRoots,
	});
	const resolvedEntries = resolveEntries(
		tguiRoot,
		generatedRoot,
		definitions.entries,
	);

	if (resolvedEntries.length === 0) {
		return [];
	}

	return [
		new ModularTguiOverlayPlugin(
			tguiRoot,
			dependencyRoot,
			generatedRoot,
			resolvedEntries,
		),
	];
}

function resolveEntries(
	tguiRoot: string,
	generatedRoot: string,
	entryList: LoadedModularTguiEntry[],
) {
	return entryList.map((entry) => {
		if (entry.kind === 'patch') {
			return {
				kind: 'patch',
				...resolvePatch(tguiRoot, generatedRoot, entry.patch),
			} satisfies ResolvedEntry;
		}

		return {
			kind: 'override',
			...resolveOverride(tguiRoot, generatedRoot, entry.override),
		} satisfies ResolvedEntry;
	});
}

function resolveOverride(
	tguiRoot: string,
	generatedRoot: string,
	override: LoadedModularTguiOverride,
) {
		const targetPath = path.resolve(tguiRoot, override.target);
		const replacementPath = path.resolve(
			override.sourceRoot,
			override.replacement,
		);
		const generatedPath = generatedPathForTarget(generatedRoot, override.target);

		validateFile(targetPath, `Override target '${override.target}'`);
		validateFile(replacementPath, `Override replacement '${override.replacement}'`);

		return {
			target: normalizePath(targetPath),
			targetPath,
			replacementPath,
			generatedPath,
		};
}

function resolvePatch(
	tguiRoot: string,
	generatedRoot: string,
	patch: ModularTguiPatch,
) {
		const targetPath = path.resolve(tguiRoot, patch.target);
		const generatedPath = generatedPathForTarget(generatedRoot, patch.target);

		validateFile(targetPath, `Patch target '${patch.target}'`);

		return {
			target: normalizePath(targetPath),
			targetPath,
			generatedPath,
			patch,
		};
}

function validateFile(filePath: string, label: string) {
	if (!fs.existsSync(filePath)) {
		throw new Error(`${PLUGIN_NAME}: ${label} does not exist: ${filePath}`);
	}
}

function getResolutionCandidates(requestPath: string) {
	const extension = path.extname(requestPath);

	if (extension) {
		return [requestPath];
	}

	return [
		...RESOLVE_EXTENSIONS.map((extension) => `${requestPath}${extension}`),
		...INDEX_FILENAMES.map((filename) => path.join(requestPath, filename)),
	];
}

function normalizePath(filePath: string) {
	return path.normalize(filePath);
}

function isInsidePath(filePath: string, parentPath: string) {
	const relativePath = path.relative(parentPath, filePath);

	return !relativePath.startsWith('..') && !path.isAbsolute(relativePath);
}

function isBareModuleRequest(request: string) {
	return !request.startsWith('.') && !path.isAbsolute(request);
}

function resolveDependencyRoot(tguiRoot: string) {
	const bunDependencyRoot = path.resolve(tguiRoot, 'node_modules/.bun/node_modules');

	if (fs.existsSync(bunDependencyRoot)) {
		return bunDependencyRoot;
	}

	return path.resolve(tguiRoot, 'node_modules');
}

function resolveDependencyRequest(dependencyRoot: string, request: string) {
	if (!isReactDependencyRequest(request)) {
		return undefined;
	}

	return path.resolve(dependencyRoot, request);
}

function isReactDependencyRequest(request: string) {
	return (
		request === 'react' ||
		request.startsWith('react/') ||
		request === 'react-dom' ||
		request.startsWith('react-dom/')
	);
}
