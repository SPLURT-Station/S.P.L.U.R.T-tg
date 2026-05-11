# Modular tgui overlays

This module lets downstream code replace tgui source files at build time without
editing the upstream-owned files in place.

The usual `tgui:build` package script points Rspack at this module's wrapper
config. Downstream changes can live in the central `manifest.ts`, or in scanned
`*.tgui.ts` files elsewhere in the modular tree.

## Scan Roots

Use `scanRoots` in `manifest.ts` to choose folders that contain modular tgui
files.

```ts
export const scanRoots = [
	// Only scan files directly in this folder.
	{ path: '../some_module/tgui', recursive: false },

	// Scan this folder and every child folder.
	{ path: '../shared_tgui_overlays', recursive: true },
];
```

Paths are relative to `modular_zzplurt/modules/tgui_modular` unless absolute.
Only files ending in `.tgui.ts`, `.tgui.tsx`, `.tgui.js`, or `.tgui.jsx` are
loaded. A scanned file must opt in with `export const modularTgui = true`.

```ts
import { block, type ModularTguiPatch } from '../tgui_modular';
import type { ModularTguiOverride } from '../tgui_modular';

export const modularTgui = true;

export const overrides: ModularTguiOverride[] = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PreferencesMenu/types.ts',
		operations: [
			{
				kind: 'ast-add-type-member',
				typeName: 'PreferencesMenuData',
				content: block`
					extra_panel_state: string;
				`,
			},
		],
	},
];
```

Files in a scan folder are loaded alphabetically. Recursive scans load files in
the current folder first, then child folders alphabetically. Patch operations
still run in the order they are listed.

If multiple scanned files touch the same tgui target, they are composed in scan
order. A whole-file override replaces the current working source for that
target, and later patches apply on top of that replacement. Later whole-file
overrides for the same target replace earlier work, so use more than one
whole-file override on a target only when that replacement behavior is intended.

## Whole-file overrides

Use an override when a file is heavily downstream-owned, or when small patches
would be harder to understand than a complete replacement.

```ts
export const overrides = [
	{
		target: 'packages/tgui/interfaces/PreferencesMenu/types.ts',
		replacement: 'overrides/PreferencesMenu/types.ts',
	},
];
```

`target` is relative to the `tgui/` directory. `replacement` is relative to this
module directory unless it starts with `../` or `/`.

When Rspack resolves an import for the target file, the plugin redirects that
request to the replacement file. The replacement file must provide the exports
that callers expect from the original file.

The redirect works for relative imports like `./types` and tgui aliases like
`tgui/backend`. Remember that relative imports inside the replacement file are
resolved from the replacement file's real folder, not from the original upstream
folder.

## Small source patches

Use patches when the upstream file should mostly stay intact, but the built
bundle needs one downstream edit. Patches are applied to generated files under
`tgui/node_modules/.bun/node_modules/.cache/tgui_modular/` when Bun's active
dependency links are available, falling back to `tgui/node_modules/.cache/`.
Rspack is redirected to those generated files. That cache lives under
`node_modules` so it stays untracked and resolves shared dependencies like
normal tgui code.

Add patches to `manifest.ts`, or to any scanned `*.tgui.ts` file:

```ts
export const patches = [
	{
		target: 'packages/tgui/interfaces/PreferencesMenu/types.ts',
		operations: [
			{
				kind: 'add-type-member',
				typeName: 'PreferencesMenuData',
				content: 'extra_panel_state: string;',
			},
		],
	},
];
```

Patch targets are relative to `tgui/`. Patch operations run in order.

Prefer `ast-*` operations when they fit. They parse the source with TypeScript
and target code structure, so they are less sensitive to upstream formatting
changes. The older text-anchor operations still exist as fallback tools, but
they should be treated as fragile: if upstream rewrites nearby text, they can
fail at build time.

To compare generated modular output against a git ref that still contains the
old direct edits, run:

```sh
bun ../modular_zzplurt/modules/tgui_modular/tools/cli.ts compare HEAD
```

Diff files are written under
`tgui/node_modules/.bun/node_modules/.cache/tgui_modular_compare/`.

## Common operations

### 1. Add imports

Prefer `ast-add-import`. It adds named imports to an existing import from the
same module, or creates a new import when the module is not imported yet.

```ts
{
	kind: 'ast-add-import',
	module: './downstream/ExtraPanel',
	imports: ['ExtraPanel'],
}
```

### 2. Add fields to types

Prefer `ast-add-type-member`. It finds an exported `type` or `interface` by
name and adds a member before its closing brace.

```ts
{
	kind: 'ast-add-type-member',
	typeName: 'PreferencesMenuData',
	content: 'extra_panel_state: string;',
}
```

### 3. Add entries to arrays

Prefer `ast-add-array-item` for named array variables.

```ts
{
	kind: 'ast-add-array-item',
	variableName: 'tabs',
	content: 'extraTab,',
}
```

### 4. Add entries to objects

Prefer `ast-add-object-entry` for named object variables.

```ts
{
	kind: 'ast-add-object-entry',
	variableName: 'pages',
	content: 'Extra: ExtraPage,',
}
```

### 5. Wrap a function component

Renames an exported function component, then appends your wrapper export. This is
useful when you want to keep upstream rendering but place downstream UI around
it.

```ts
{
	kind: 'ast-wrap-function-component',
	exportName: 'PreferencesMenu',
	innerName: 'BasePreferencesMenu',
	wrapper: `
export function PreferencesMenu() {
	return <PreferenceShell content={<BasePreferencesMenu />} />;
}
`,
}
```

### 6. Replace one function or block

There is no generic AST replacement yet. Use exact text replacement when a
single block has to change and a whole-file override would be too much. By
default, the anchor must appear exactly once.

```ts
{
	kind: 'replace',
	anchor: "return 'Upstream';",
	content: "return 'Downstream';",
}
```

Set `expectedOccurrences` if the same anchor should be replaced only when it
appears a specific number of times.

### 7. Add styles

Stylesheets are not TypeScript, so use `append`, `prepend`, or an anchored text
insert to add a stylesheet load.

```ts
{
	kind: 'append',
	content: "@include meta.load-css('../../modular_zzplurt/modules/tgui_modular/styles/preferences.scss');",
}
```

### 8. Add assets or route registrations

When a TypeScript file has a named static list, prefer `ast-add-array-item` or
`ast-add-object-entry`. Use anchored insertion for non-TypeScript files or
unusual registration shapes.

```ts
{
	kind: 'ast-add-array-item',
	variableName: 'assetFiles',
	content: "'downstream.png',",
}
```

For normal tgui interfaces, prefer adding a new file under
`packages/tgui/interfaces`; the router already discovers those automatically.

## Primitive operations

These are useful escape hatches for simple edits, but they are plain text
operations. Prefer AST operations when possible.

```ts
{ kind: 'insert', anchor: 'text', position: 'before', content: '...' }
{ kind: 'insert', anchor: 'text', position: 'after', content: '...' }
{ kind: 'replace', anchor: 'text', content: '...' }
{ kind: 'prepend', content: '...' }
{ kind: 'append', content: '...' }
```

## Testing

Run the focused unit tests from the `tgui/` directory:

```sh
bun ../modular_zzplurt/modules/tgui_modular/tools/cli.ts test
```

Run the full tgui build:

```sh
bun run tgui:build
```

## Tools

Run these from the `tgui/` directory.

Create one modular edit from a locally modified tgui file:

```sh
bun ../modular_zzplurt/modules/tgui_modular/tools/cli.ts create-override \
	--target packages/tgui/interfaces/Example.tsx \
	--out-dir ../modular_zzplurt/tgui/my_feature \
	--upstream-ref upstream/master
```

`--upstream-url` may be used instead of `--upstream-ref` for a GitHub repo or
raw-content base URL. The tool compares upstream source against the local file.
It first tries to infer a safe AST patch, currently starting with named import
additions. If it cannot prove the AST patch reproduces the local file exactly,
it writes a whole-file override instead and prints a warning.

Generate the final runtime source for a tgui file after modular overrides and
patches:

```sh
bun ../modular_zzplurt/modules/tgui_modular/tools/cli.ts generate-final \
	--target packages/tgui/interfaces/Example.tsx \
	--out /tmp/Example.final.tsx
```

Migrate locally modified tgui files into modular edits:

```sh
bun ../modular_zzplurt/modules/tgui_modular/tools/cli.ts migrate-overrides \
	--out-dir ../modular_zzplurt/tgui/my_feature \
	--upstream-ref upstream/master
```

Use `--targets a.tsx,b.tsx` to migrate only specific tgui targets. For each
file, the migrator saves a temporary copy of the local final source, writes an
override, restores the local tgui file to upstream source, generates the modular
runtime result, and verifies it matches the temporary copy before moving on.
