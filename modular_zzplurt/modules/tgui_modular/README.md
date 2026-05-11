# Modular tgui overlays

This module lets downstream code replace tgui source files at build time without
editing the upstream-owned files in place.

The only required hook is in the tgui Rspack config. The actual downstream
changes live here, under `modular_zzplurt/modules/tgui_modular`.

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
bundle needs one downstream edit. Patches are applied to generated files in
`.generated/`, and Rspack is redirected to those generated files.

Add patches to `manifest.ts`:

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
bun test ../modular_zzplurt/modules/tgui_modular
```

Run the full tgui build:

```sh
bun run tgui:build
```
