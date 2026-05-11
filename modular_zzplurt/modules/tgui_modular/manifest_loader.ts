import fs from 'node:fs';
import { createRequire } from 'node:module';
import path from 'node:path';

import type { ModularTguiPatch } from './patches';
import type { ModularTguiOverride } from './plugin';

const require = createRequire(import.meta.url);
const MANIFEST_EXTENSIONS = ['.tgui.ts', '.tgui.tsx', '.tgui.js', '.tgui.jsx'];
const IGNORED_DIRECTORIES = new Set([
	'.cache',
	'.generated',
	'.git',
	'node_modules',
]);

export type ModularTguiScanRoot = {
	/**
	 * Directory to scan, relative to modular_zzplurt/modules/tgui_modular unless
	 * absolute.
	 */
	path: string;

	/**
	 * When true, scans every child directory. When false, scans only this exact
	 * directory.
	 */
	recursive?: boolean;
};

export type ModularTguiManifest = {
	modularTgui?: true;
	overrides?: ModularTguiOverride[];
	patches?: ModularTguiPatch[];
};

export type LoadedModularTguiOverride = ModularTguiOverride & {
	sourceRoot: string;
};

export type LoadedModularTguiEntry =
	| {
		kind: 'override';
		override: LoadedModularTguiOverride;
	}
	| {
		kind: 'patch';
		patch: ModularTguiPatch;
	};

export type LoadedModularTguiDefinitions = {
	entries: LoadedModularTguiEntry[];
	overrides: LoadedModularTguiOverride[];
	patches: ModularTguiPatch[];
};

export const block = (
	strings: TemplateStringsArray,
	...values: unknown[]
) => {
	const source = String.raw({ raw: strings.raw }, ...values)
		.replaceAll('\\`', '`')
		.replaceAll('\\${', '${')
		.replace(/^\n/, '');
	const lines = source.split('\n');
	if (lines.at(-1)?.trim().length === 0) {
		lines.pop();
	}
	const indentedLines = lines.filter((line) => line.trim().length > 0);
	if (indentedLines.length === 0) {
		return '';
	}

	const commonTabs = Math.min(
		...indentedLines.map((line) => line.match(/^\t*/)?.[0].length ?? 0),
	);

	return lines
		.map((line) => {
			if (line.trim().length === 0) {
				return '';
			}

			return line.slice(Math.min(commonTabs, line.match(/^\t*/)?.[0].length ?? 0));
		})
		.join('\n');
};

export function loadModularTguiDefinitions(
	moduleRoot: string,
	baseManifest: {
		overrides?: ModularTguiOverride[];
		patches?: ModularTguiPatch[];
		scanRoots?: ModularTguiScanRoot[];
	},
): LoadedModularTguiDefinitions {
	const definitions: LoadedModularTguiDefinitions = {
		entries: [],
		overrides: toLoadedOverrides(baseManifest.overrides ?? [], moduleRoot),
		patches: [...(baseManifest.patches ?? [])],
	};
	definitions.entries.push(...toEntries(definitions.overrides, definitions.patches));

	for (const scanRoot of baseManifest.scanRoots ?? []) {
		const scanRootPath = resolveScanRoot(moduleRoot, scanRoot.path);
		validateDirectory(scanRootPath, scanRoot.path);

		for (const manifestPath of discoverManifestFiles(
			scanRootPath,
			scanRoot.recursive ?? false,
		)) {
			const manifest = loadManifestFile(manifestPath);
			const sourceRoot = path.dirname(manifestPath);
			const loadedOverrides = toLoadedOverrides(
				manifest.overrides ?? [],
				sourceRoot,
			);
			const loadedPatches = manifest.patches ?? [];

			definitions.overrides.push(...loadedOverrides);
			definitions.patches.push(...loadedPatches);
			definitions.entries.push(...toEntries(loadedOverrides, loadedPatches));
		}
	}

	return definitions;
}

function toLoadedOverrides(
	overrides: ModularTguiOverride[],
	sourceRoot: string,
) {
	return overrides.map((override) => ({
		...override,
		sourceRoot,
	}));
}

function toEntries(
	overrides: LoadedModularTguiOverride[],
	patches: ModularTguiPatch[],
) {
	return [
		...overrides.map((override) => ({
			kind: 'override' as const,
			override,
		})),
		...patches.map((patch) => ({
			kind: 'patch' as const,
			patch,
		})),
	];
}

function resolveScanRoot(moduleRoot: string, scanRoot: string) {
	if (path.isAbsolute(scanRoot)) {
		return scanRoot;
	}

	return path.resolve(moduleRoot, scanRoot);
}

function validateDirectory(directoryPath: string, scanRoot: string) {
	if (!fs.existsSync(directoryPath)) {
		throw new Error(
			`ModularTguiOverlayPlugin: Scan root '${scanRoot}' does not exist: ${directoryPath}`,
		);
	}

	if (!fs.statSync(directoryPath).isDirectory()) {
		throw new Error(
			`ModularTguiOverlayPlugin: Scan root '${scanRoot}' is not a directory: ${directoryPath}`,
		);
	}
}

function discoverManifestFiles(directoryPath: string, recursive: boolean) {
	const manifestFiles: string[] = [];
	const entries = fs
		.readdirSync(directoryPath, { withFileTypes: true })
		.sort((left, right) => left.name.localeCompare(right.name));

	for (const entry of entries) {
		const entryPath = path.join(directoryPath, entry.name);

		if (entry.isFile() && isManifestFile(entry.name)) {
			manifestFiles.push(entryPath);
		}
	}

	for (const entry of entries) {
		const entryPath = path.join(directoryPath, entry.name);

		if (
			recursive &&
			entry.isDirectory() &&
			!IGNORED_DIRECTORIES.has(entry.name)
		) {
			manifestFiles.push(...discoverManifestFiles(entryPath, recursive));
		}
	}

	return manifestFiles;
}

function isManifestFile(fileName: string) {
	return MANIFEST_EXTENSIONS.some((extension) => fileName.endsWith(extension));
}

function loadManifestFile(manifestPath: string): Required<ModularTguiManifest> {
	const manifest = require(manifestPath) as ModularTguiManifest;

	if (manifest.modularTgui !== true) {
		throw new Error(
			`ModularTguiOverlayPlugin: ${manifestPath} must export 'modularTgui = true' to be scanned.`,
		);
	}

	return {
		modularTgui: true,
		overrides: manifest.overrides ?? [],
		patches: manifest.patches ?? [],
	};
}
