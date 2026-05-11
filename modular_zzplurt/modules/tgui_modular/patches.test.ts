import { describe, expect, test } from 'bun:test';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';

import { loadModularTguiDefinitions } from './manifest_loader';
import { applyPatchOperations } from './patches';
import { findOverrideReplacement } from './plugin';

describe('modular tgui patches', () => {
	test('adds imports to existing named imports with AST targeting', () => {
		const source = [
			'import {',
			'  Box,',
			'} from "tgui-core/components";',
			'',
			'export function Panel() {',
			'  return <Box />;',
			'}',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'ast-add-import',
					module: 'tgui-core/components',
					imports: ['Button'],
				},
			]),
		).toContain(
			[
				'import {',
				'  Box,',
				'  Button,',
				'} from "tgui-core/components";',
			].join('\n'),
		);
	});

	test('adds new imports with AST targeting when the module is missing', () => {
		const source = [
			"import { Box } from 'tgui-core/components';",
			'',
			'export function Panel() {',
			'  return <Box />;',
			'}',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'ast-add-import',
					module: './downstream/ExtraPanel',
					imports: ['ExtraPanel'],
				},
			]),
		).toContain("import { ExtraPanel } from './downstream/ExtraPanel';");
	});

	test('adds type-only imports separately from value imports with AST targeting', () => {
		const source = [
			"import { CheckboxInput } from '../../base';",
			'',
			'export const feature = CheckboxInput;',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'ast-add-import',
					module: '../../base',
					imports: ['FeatureToggle'],
					typeOnly: true,
				},
			]),
		).toContain("import type { FeatureToggle } from '../../base';");
	});

	test('removes named import specifiers with AST targeting', () => {
		const source = [
			"import { CheckboxInput, FeatureToggle } from '../../base';",
			'',
			'export const feature = CheckboxInput;',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'ast-remove-import-specifier',
					module: '../../base',
					imports: ['FeatureToggle'],
				},
			]),
		).toContain("import { CheckboxInput } from '../../base';");
	});

	test('adds type members to reformatted type declarations with AST targeting', () => {
		const source = [
			'export type PreferencesMenuData =',
			'  {',
			'    name: string;',
			'  };',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'ast-add-type-member',
					typeName: 'PreferencesMenuData',
					content: 'extra_panel_state: string;',
				},
			]),
		).toContain(
			[
				'export type PreferencesMenuData =',
				'  {',
				'    name: string;',
				'    extra_panel_state: string;',
				'  };',
			].join('\n'),
		);
	});

	test('removes type members with AST targeting', () => {
		const source = [
			'export type CharacterPreferencesData = {',
			'  clothing: Record<string, string>;',
			'  silicon_preferences: Record<string, unknown>;',
			'  features: Record<string, string>;',
			'};',
			'',
		].join('\n');

		const patched = applyPatchOperations(source, [
			{
				kind: 'ast-remove-type-member',
				typeName: 'CharacterPreferencesData',
				members: ['silicon_preferences'],
			},
		]);

		expect(patched).not.toContain('silicon_preferences');
		expect(patched).toContain('clothing: Record<string, string>;');
	});

	test('adds array entries by variable name with AST targeting', () => {
		const source = [
			'const tabs',
			'  =',
			'  [',
			"    'General',",
			'  ];',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'ast-add-array-item',
					variableName: 'tabs',
					content: "'Downstream',",
				},
			]),
		).toContain(
			[
				'const tabs',
				'  =',
				'  [',
				"    'General',",
				"    'Downstream',",
				'  ];',
			].join('\n'),
		);
	});

	test('adds object entries by variable name with AST targeting', () => {
		const source = [
			'const pages',
			'  =',
			'  {',
			'    General: GeneralPage,',
			'  };',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'ast-add-object-entry',
					variableName: 'pages',
					content: 'Downstream: DownstreamPage,',
				},
			]),
		).toContain(
			[
				'const pages',
				'  =',
				'  {',
				'    General: GeneralPage,',
				'    Downstream: DownstreamPage,',
				'  };',
			].join('\n'),
		);
	});

	test('replaces variable initializers with AST targeting', () => {
		const source = [
			'const mainFeatures = [',
			"  'clothing',",
			'];',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'ast-replace-variable-initializer',
					variableName: 'mainFeatures',
					content: "['clothing'].filter(Boolean)",
				},
			]),
		).toContain("const mainFeatures = ['clothing'].filter(Boolean);");
	});

	test('adds destructured properties by initializer with AST targeting', () => {
		const source = [
			'export function PageMain() {',
			'  const {',
			'    alertLevel,',
			'    shuttleRecallable,',
			'  } = data;',
			'',
			'  return null;',
			'}',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'ast-add-destructured-properties',
					sourceExpression: 'data',
					afterProperty: 'shuttleRecallable',
					properties: ['canManageSecurityCyborgs', 'securityCyborgs'],
				},
			]),
		).toContain(
			[
				'    shuttleRecallable,',
				'    canManageSecurityCyborgs,',
				'    securityCyborgs,',
			].join('\n'),
		);
	});

	test('adds function body statements before return with AST targeting', () => {
		const source = [
			'export function PageMain() {',
			'  const showAlertLevelConfirm = true;',
			'',
			'  return <Box />;',
			'}',
			'',
		].join('\n');

		expect(
			applyPatchOperations(
				source,
				[
					{
						kind: 'ast-add-function-body-statement',
						functionName: 'PageMain',
						position: 'before-return',
						content: 'const securityCyborgReasonLongEnough = true;',
					},
				],
				'PageMain.tsx',
			),
		).toContain(
			[
				'  const securityCyborgReasonLongEnough = true;',
				'  return <Box />;',
			].join('\n'),
		);
	});

	test('adds JSX children to matching components with AST targeting', () => {
		const source = [
			'export function PageMain() {',
			'  return (',
			'    <Section title="Functions">',
			'      <Flex direction="column">',
			'        <Button>Existing</Button>',
			'      </Flex>',
			'    </Section>',
			'  );',
			'}',
			'',
		].join('\n');

		expect(
			applyPatchOperations(
				source,
				[
					{
						kind: 'ast-add-jsx-child',
						functionName: 'PageMain',
						componentName: 'Flex',
						propName: 'direction',
						propValue: 'column',
						containingText: 'Existing',
						content: '<Button>Security Cyborg Management</Button>',
					},
				],
				'PageMain.tsx',
			),
		).toContain(
			[
				'        <Button>Existing</Button>',
				'        <Button>Security Cyborg Management</Button>',
				'      </Flex>',
			].join('\n'),
		);
	});

	test('adds enum members with AST targeting', () => {
		const source = ['enum Page {', '  Main,', '  Jobs,', '}', ''].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'ast-add-enum-member',
					enumName: 'Page',
					content: 'CyborgCharacter,',
				},
			]),
		).toContain(['enum Page {', '  Main,', '  Jobs,', '  CyborgCharacter,', '}'].join('\n'));
	});

	test('removes enum members with AST targeting', () => {
		const source = ['enum PrefPage {', '  Main,', '  Silicon,', '  Jobs,', '}', ''].join('\n');

		const patched = applyPatchOperations(source, [
			{
				kind: 'ast-remove-enum-member',
				enumName: 'PrefPage',
				memberName: 'Silicon',
			},
		]);

		expect(patched).not.toContain('Silicon');
		expect(patched).toContain('Jobs');
	});

	test('adds switch cases with AST targeting', () => {
		const source = [
			'switch (currentPage) {',
			'  case Page.Main:',
			'    pageContents = <MainPage />;',
			'    break;',
			'  case Page.Jobs:',
			'    pageContents = <JobsPage />;',
			'    break;',
			'}',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'ast-add-switch-case',
					switchExpression: 'currentPage',
					afterCase: 'Page.Main',
					content: [
						'  case Page.CyborgCharacter:',
						'    pageContents = <CyborgCharacterPage />;',
						'    break;',
					].join('\n'),
				},
			]),
		).toContain('case Page.CyborgCharacter:');
	});

	test('removes switch cases with AST targeting', () => {
		const source = [
			'switch (currentPage) {',
			'  case Page.Main:',
			'    pageContents = <MainPage />;',
			'    break;',
			'  case Page.Silicon:',
			'    pageContents = <SiliconPage />;',
			'    break;',
			'  case Page.Jobs:',
			'    pageContents = <JobsPage />;',
			'    break;',
			'}',
			'',
		].join('\n');

		const patched = applyPatchOperations(source, [
			{
				kind: 'ast-remove-switch-case',
				switchExpression: 'currentPage',
				caseExpression: 'Page.Silicon',
			},
		]);

		expect(patched).not.toContain('Page.Silicon');
		expect(patched).toContain('Page.Jobs');
	});

	test('wraps exported function components with AST targeting', () => {
		const source = [
			'export',
			'function PreferencesMenu() {',
			"  return <Window title=\"Preferences\" />;",
			'}',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'ast-wrap-function-component',
					exportName: 'PreferencesMenu',
					innerName: 'BasePreferencesMenu',
					wrapper: [
						'export function PreferencesMenu() {',
						'  return <PreferenceShell content={<BasePreferencesMenu />} />;',
						'}',
						'',
					].join('\n'),
				},
			]),
		).toContain('function BasePreferencesMenu()');
	});

	test('adds imports after the existing import block', () => {
		const source = [
			"import { Box } from 'tgui-core/components';",
			'',
			'export function Panel() {',
			'  return <Box />;',
			'}',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'add-import',
					content: "import { ExtraPanel } from './downstream/ExtraPanel';",
				},
			]),
		).toContain(
			[
				"import { Box } from 'tgui-core/components';",
				"import { ExtraPanel } from './downstream/ExtraPanel';",
				'',
				'export function Panel() {',
			].join('\n'),
		);
	});

	test('adds fields to exported type declarations', () => {
		const source = [
			'export type PreferencesMenuData = {',
			'  name: string;',
			'};',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'add-type-member',
					typeName: 'PreferencesMenuData',
					content: 'extra_panel_state: string;',
				},
			]),
		).toContain(
			[
				'export type PreferencesMenuData = {',
				'  name: string;',
				'  extra_panel_state: string;',
				'};',
			].join('\n'),
		);
	});

	test('adds entries to arrays', () => {
		const source = [
			'const tabs = [',
			"  'General',",
			'];',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'add-array-item',
					anchor: 'const tabs =',
					content: "'Downstream',",
				},
			]),
		).toContain(
			[
				'const tabs = [',
				"  'General',",
				"  'Downstream',",
				'];',
			].join('\n'),
		);
	});

	test('adds entries to objects', () => {
		const source = [
			'const pages = {',
			'  General: GeneralPage,',
			'};',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'add-object-entry',
					anchor: 'const pages =',
					content: 'Downstream: DownstreamPage,',
				},
			]),
		).toContain(
			[
				'const pages = {',
				'  General: GeneralPage,',
				'  Downstream: DownstreamPage,',
				'};',
			].join('\n'),
		);
	});

	test('wraps exported function components', () => {
		const source = [
			'export function PreferencesMenu() {',
			"  return <Window title=\"Preferences\" />;",
			'}',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'wrap-function-component',
					exportName: 'PreferencesMenu',
					innerName: 'BasePreferencesMenu',
					wrapper: [
						'export function PreferencesMenu() {',
						'  return <PreferenceShell content={<BasePreferencesMenu />} />;',
						'}',
						'',
					].join('\n'),
				},
			]),
		).toBe(
			[
				'function BasePreferencesMenu() {',
				"  return <Window title=\"Preferences\" />;",
				'}',
				'export function PreferencesMenu() {',
				'  return <PreferenceShell content={<BasePreferencesMenu />} />;',
				'}',
				'',
			].join('\n'),
		);
	});

	test('replaces a function or render block by exact anchor', () => {
		const source = [
			'function getTitle() {',
			"  return 'Upstream';",
			'}',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'replace',
					anchor: "  return 'Upstream';",
					content: "  return 'Downstream';",
				},
			]),
		).toContain("  return 'Downstream';");
	});

	test('replaces all matching anchors when requested', () => {
		const source = ['const first = "old";', 'const second = "old";', ''].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'replace-all',
					anchor: '"old"',
					content: '"new"',
					expectedOccurrences: 2,
				},
			]),
		).toBe(['const first = "new";', 'const second = "new";', ''].join('\n'));
	});

	test('supports whole-file override resolution with extensionless imports', () => {
		const target = path.resolve('/repo/tgui/packages/tgui/interfaces/Panel.tsx');
		const replacement = path.resolve('/repo/modular/overrides/Panel.tsx');
		const overrides = new Map([[target, replacement]]);

		expect(
			findOverrideReplacement(
				path.resolve('/repo/tgui/packages/tgui/interfaces'),
				'./Panel',
				overrides,
			),
		).toBe(replacement);
	});

	test('supports whole-file override resolution with tgui alias imports', () => {
		const tguiRoot = path.resolve('/repo/tgui');
		const target = path.resolve('/repo/tgui/packages/tgui/backend.ts');
		const replacement = path.resolve('/repo/modular/overrides/backend.ts');
		const overrides = new Map([[target, replacement]]);

		expect(
			findOverrideReplacement(
				path.resolve('/repo/tgui/packages/tgui/interfaces'),
				'tgui/backend',
				overrides,
				tguiRoot,
			),
		).toBe(replacement);
	});

	test('falls generated relative imports back to the original tgui tree', () => {
		const tguiRoot = path.resolve('/repo/tgui');
		const generatedRoot = path.resolve('/repo/modular/.generated');
		const originalTypes = path.resolve(
			'/repo/tgui/packages/tgui/interfaces/PreferencesMenu/types',
		);

		expect(
			findOverrideReplacement(
				path.resolve(
					'/repo/modular/.generated/packages/tgui/interfaces/PreferencesMenu/CharacterPreferences',
				),
				'../types',
				new Map(),
				tguiRoot,
			generatedRoot,
		),
	).toBe(originalTypes);
	});

	test('loads shallow modular tgui manifests only from the configured folder', () => {
		const moduleRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'tgui-modular-'));
		const manifestsRoot = path.join(moduleRoot, 'manifests');
		const nestedRoot = path.join(manifestsRoot, 'nested');

		fs.mkdirSync(nestedRoot, { recursive: true });
		fs.writeFileSync(
			path.join(manifestsRoot, 'panel.tgui.js'),
			[
				'exports.modularTgui = true;',
				"exports.patches = [{ target: 'panel.tsx', operations: [] }];",
				'',
			].join('\n'),
		);
		fs.writeFileSync(
			path.join(nestedRoot, 'nested.tgui.js'),
			[
				'exports.modularTgui = true;',
				"exports.patches = [{ target: 'nested.tsx', operations: [] }];",
				'',
			].join('\n'),
		);

		const definitions = loadModularTguiDefinitions(moduleRoot, {
			scanRoots: [{ path: 'manifests', recursive: false }],
		});

		expect(definitions.patches.map((patch) => patch.target)).toEqual([
			'panel.tsx',
		]);
	});

	test('loads recursive modular tgui manifests from subfolders', () => {
		const moduleRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'tgui-modular-'));
		const manifestsRoot = path.join(moduleRoot, 'manifests');
		const nestedRoot = path.join(manifestsRoot, 'nested');

		fs.mkdirSync(nestedRoot, { recursive: true });
		fs.writeFileSync(
			path.join(manifestsRoot, 'panel.tgui.js'),
			[
				'exports.modularTgui = true;',
				"exports.patches = [{ target: 'panel.tsx', operations: [] }];",
				'',
			].join('\n'),
		);
		fs.writeFileSync(
			path.join(nestedRoot, 'nested.tgui.js'),
			[
				'exports.modularTgui = true;',
				"exports.patches = [{ target: 'nested.tsx', operations: [] }];",
				'',
			].join('\n'),
		);

		const definitions = loadModularTguiDefinitions(moduleRoot, {
			scanRoots: [{ path: 'manifests', recursive: true }],
		});

		expect(definitions.patches.map((patch) => patch.target)).toEqual([
			'panel.tsx',
			'nested.tsx',
		]);
	});

	test('adds styles through append operations', () => {
		const source = [
			"@include meta.load-css('./interfaces/PreferencesMenu.scss');",
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'append',
					content:
						"@include meta.load-css('../../modular_zzplurt/modules/tgui_modular/styles/preferences.scss');",
				},
			]),
		).toContain(
			"@include meta.load-css('../../modular_zzplurt/modules/tgui_modular/styles/preferences.scss');",
		);
	});

	test('adds asset or route registrations through anchored insertion', () => {
		const source = [
			'const assetFiles = [',
			"  'upstream.png',",
			'];',
			'',
		].join('\n');

		expect(
			applyPatchOperations(source, [
				{
					kind: 'insert',
					anchor: "  'upstream.png',",
					position: 'after',
					content: "\n  'downstream.png',",
				},
			]),
		).toContain(
			[
				'const assetFiles = [',
				"  'upstream.png',",
				"  'downstream.png',",
				'];',
			].join('\n'),
		);
	});

	test('fails when exact anchors drift', () => {
		expect(() =>
			applyPatchOperations('const value = 1;', [
				{
					kind: 'replace',
					anchor: 'const missing = 1;',
					content: 'const value = 2;',
				},
			]),
		).toThrow(/expected 1 occurrence/);
	});
});
