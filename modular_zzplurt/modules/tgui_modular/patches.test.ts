import { describe, expect, test } from 'bun:test';
import path from 'node:path';

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
