import { describe, expect, test } from 'bun:test';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';

import { loadModularTguiDefinitions } from '../manifest_loader';
import {
	createOverrideFromSources,
	generateFinalSource,
	migrateModifiedTguiFiles,
	type ToolPaths,
} from './lib';

function makeWorkspace() {
	const repoRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'tgui-tools-'));
	const moduleRoot = path.join(repoRoot, 'modular_zzplurt/modules/tgui_modular');
	const tguiRoot = path.join(repoRoot, 'tgui');

	fs.mkdirSync(moduleRoot, { recursive: true });
	fs.mkdirSync(tguiRoot, { recursive: true });

	return {
		moduleRoot,
		repoRoot,
		tguiRoot,
	} satisfies ToolPaths;
}

describe('modular tgui tools', () => {
	test('creates a whole-file override manifest and replacement file', () => {
		const paths = makeWorkspace();
		const outputDir = path.join(paths.repoRoot, 'modular_zzplurt/tgui/example');
		const upstreamSource = Array.from(
			{ length: 70 },
			(_, index) => `export const value${index} = ${index};`,
		).join('\n');
		const localSource = Array.from(
			{ length: 70 },
			(_, index) => `export const changed${index} = ${index};`,
		).join('\n');
		const result = createOverrideFromSources({
			localSource,
			moduleRoot: paths.moduleRoot,
			outputDir,
			target: 'packages/tgui/interfaces/Panel.tsx',
			upstreamSource,
		});

		expect(result.changed).toBe(true);
		expect(result.strategy).toBe('whole-file-override');
		expect(result.warnings).toHaveLength(1);
		expect(fs.readFileSync(result.replacementPath!, 'utf8')).toBe(localSource);
		expect(fs.readFileSync(result.manifestPath!, 'utf8')).toContain(
			"target: 'packages/tgui/interfaces/Panel.tsx'",
		);
	});

	test('creates an AST patch when a safe import change can be inferred', () => {
		const paths = makeWorkspace();
		const outputDir = path.join(paths.repoRoot, 'modular_zzplurt/tgui/example');
		const result = createOverrideFromSources({
			localSource: [
				"import {",
				"  Box,",
				"  Button,",
				"} from 'tgui-core/components';",
				'',
				'export const value = Box;',
				'',
			].join('\n'),
			moduleRoot: paths.moduleRoot,
			outputDir,
			target: 'packages/tgui/interfaces/Panel.tsx',
			upstreamSource: [
				"import {",
				"  Box,",
				"} from 'tgui-core/components';",
				'',
				'export const value = Box;',
				'',
			].join('\n'),
		});

		expect(result.strategy).toBe('ast-patch');
		expect(result.replacementPath).toBeUndefined();
		expect(fs.readFileSync(result.manifestPath!, 'utf8')).toContain(
			"kind: \"ast-add-import\"",
		);
	});

	test('creates a replace-all patch when one repeated line change can be inferred', () => {
		const paths = makeWorkspace();
		const outputDir = path.join(paths.repoRoot, 'modular_zzplurt/tgui/example');
		const result = createOverrideFromSources({
			localSource: [
				'<a href="https://downstream.example">',
				'Other line',
				'<a href="https://downstream.example">',
				'',
			].join('\n'),
			moduleRoot: paths.moduleRoot,
			outputDir,
			target: 'packages/tgui/interfaces/Rules.tsx',
			upstreamSource: [
				'<a href="https://upstream.example">',
				'Other line',
				'<a href="https://upstream.example">',
				'',
			].join('\n'),
		});

		expect(result.strategy).toBe('ast-patch');
		expect(result.replacementPath).toBeUndefined();
		expect(fs.readFileSync(result.manifestPath!, 'utf8')).toContain(
			"kind: \"replace-all\"",
		);
	});

	test('creates a patch for a single inserted line hunk', () => {
		const paths = makeWorkspace();
		const outputDir = path.join(paths.repoRoot, 'modular_zzplurt/tgui/example');
		const result = createOverrideFromSources({
			localSource: ['const first = true;', 'const second = true;', ''].join('\n'),
			moduleRoot: paths.moduleRoot,
			outputDir,
			target: 'packages/tgui/interfaces/Panel.tsx',
			upstreamSource: ['const first = true;', ''].join('\n'),
		});

		expect(result.strategy).toBe('ast-patch');
		expect(result.replacementPath).toBeUndefined();
		expect(fs.readFileSync(result.manifestPath!, 'utf8')).toContain(
			"kind: \"insert\"",
		);
	});

	test('allows large additive hunks without allowing broad rewrites', () => {
		const paths = makeWorkspace();
		const outputDir = path.join(paths.repoRoot, 'modular_zzplurt/tgui/example');
		const insertedLines = Array.from(
			{ length: 120 },
			(_, index) => `  <Button key="${index}">Action ${index}</Button>`,
		);
		const additiveResult = createOverrideFromSources({
			localSource: [
				'export function Panel() {',
				'  return <Box />;',
				...insertedLines,
				'}',
				'',
			].join('\n'),
			moduleRoot: paths.moduleRoot,
			outputDir,
			target: 'packages/tgui/interfaces/Panel.tsx',
			upstreamSource: [
				'export function Panel() {',
				'  return <Box />;',
				'}',
				'',
			].join('\n'),
		});

		const rewriteResult = createOverrideFromSources({
			localSource: Array.from(
				{ length: 90 },
				(_, index) => `export const changed${index} = ${index};`,
			).join('\n'),
			moduleRoot: paths.moduleRoot,
			outputDir,
			target: 'packages/tgui/interfaces/RewrittenPanel.tsx',
			upstreamSource: Array.from(
				{ length: 90 },
				(_, index) => `export const value${index} = ${index};`,
			).join('\n'),
		});

		expect(additiveResult.strategy).toBe('ast-patch');
		expect(additiveResult.replacementPath).toBeUndefined();
		expect(fs.readFileSync(additiveResult.manifestPath!, 'utf8')).toContain(
			"kind: \"insert\"",
		);
		expect(rewriteResult.strategy).toBe('whole-file-override');
		expect(rewriteResult.replacementPath).toBeDefined();
	});

	test('creates patches for independent line replacements', () => {
		const paths = makeWorkspace();
		const outputDir = path.join(paths.repoRoot, 'modular_zzplurt/tgui/example');
		const result = createOverrideFromSources({
			localSource: ['const first = 2;', 'const second = 3;', ''].join('\n'),
			moduleRoot: paths.moduleRoot,
			outputDir,
			target: 'packages/tgui/interfaces/Panel.tsx',
			upstreamSource: ['const first = 1;', 'const second = 1;', ''].join('\n'),
		});

		expect(result.strategy).toBe('ast-patch');
		expect(result.replacementPath).toBeUndefined();
		expect(fs.readFileSync(result.manifestPath!, 'utf8')).toContain(
			"kind: \"replace-all\"",
		);
	});

	test('generates final source from an override definition', () => {
		const paths = makeWorkspace();
		const outputDir = path.join(paths.repoRoot, 'modular_zzplurt/tgui/example');
		const upstreamSource = Array.from(
			{ length: 70 },
			(_, index) => `export const value${index} = ${index};`,
		).join('\n');
		const localSource = Array.from(
			{ length: 70 },
			(_, index) => `export const changed${index} = ${index};`,
		).join('\n');

		createOverrideFromSources({
			localSource,
			moduleRoot: paths.moduleRoot,
			outputDir,
			target: 'packages/tgui/interfaces/Panel.tsx',
			upstreamSource,
		});

		const definitions = loadModularTguiDefinitions(paths.moduleRoot, {
			scanRoots: [{ path: '../../tgui/example', recursive: true }],
		});
		const result = generateFinalSource({
			baseSource: upstreamSource,
			definitions,
			moduleRoot: paths.moduleRoot,
			target: 'packages/tgui/interfaces/Panel.tsx',
			tguiRoot: paths.tguiRoot,
		});

		expect(result.sourceKind).toBe('override');
		expect(result.source).toBe(localSource);
	});

	test('generates final source by composing multiple patches in load order', () => {
		const paths = makeWorkspace();
		const definitions = {
			entries: [
				{
					kind: 'patch' as const,
					patch: {
						target: 'packages/tgui/interfaces/Panel.tsx',
						operations: [
							{
								kind: 'replace' as const,
								anchor: 'const first = false;',
								content: 'const first = true;',
							},
						],
					},
				},
				{
					kind: 'patch' as const,
					patch: {
						target: 'packages/tgui/interfaces/Panel.tsx',
						operations: [
							{
								kind: 'replace' as const,
								anchor: 'const second = false;',
								content: 'const second = true;',
							},
						],
					},
				},
			],
			overrides: [],
			patches: [],
		};
		const result = generateFinalSource({
			baseSource: [
				'const first = false;',
				'const second = false;',
				'',
			].join('\n'),
			definitions,
			moduleRoot: paths.moduleRoot,
			target: 'packages/tgui/interfaces/Panel.tsx',
			tguiRoot: paths.tguiRoot,
		});

		expect(result.source).toBe(
			['const first = true;', 'const second = true;', ''].join('\n'),
		);
	});

	test('migrates a modified local file into an override and restores upstream source', async () => {
		const paths = makeWorkspace();
		const target = 'packages/tgui/interfaces/Panel.tsx';
		const targetPath = path.join(paths.tguiRoot, target);
		const outputDir = path.join(paths.repoRoot, 'modular_zzplurt/tgui/example');

		fs.mkdirSync(path.dirname(targetPath), { recursive: true });
		fs.mkdirSync(
			path.join(paths.repoRoot, 'modular_zzplurt/tgui/unsorted-autogenned'),
			{ recursive: true },
		);
		fs.writeFileSync(targetPath, 'export const value = 2;\n');

		await migrateModifiedTguiFiles({
			outputDir,
			paths,
			targets: [target],
			upstreamSources: {
				[target]: 'export const value = 1;\n',
			},
		});

		expect(fs.readFileSync(targetPath, 'utf8')).toBe('export const value = 1;\n');

		const definitions = loadModularTguiDefinitions(paths.moduleRoot, {
			scanRoots: [{ path: '../../tgui/example', recursive: true }],
		});
		const finalSource = generateFinalSource({
			baseSource: fs.readFileSync(targetPath, 'utf8'),
			definitions,
			moduleRoot: paths.moduleRoot,
			target,
			tguiRoot: paths.tguiRoot,
		}).source;

		expect(finalSource).toBe('export const value = 2;\n');
	});
});
