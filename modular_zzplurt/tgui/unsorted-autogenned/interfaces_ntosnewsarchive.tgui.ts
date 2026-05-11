import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/NtosNewsArchive.jsx',
		operations: [
			{
				kind: "replace",
				anchor: "import { useBackend } from '../backend';\nimport { Collapsible, Section } from 'tgui-core/components';",
				content: "import { Collapsible, Section } from 'tgui-core/components';\n\nimport { useBackend } from '../backend';",
				expectedOccurrences: 1,
			},
		],
	},
];
