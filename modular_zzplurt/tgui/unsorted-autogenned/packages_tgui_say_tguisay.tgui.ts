import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui-say/TguiSay.tsx',
		operations: [
			{
				kind: "insert",
				anchor: "      case KEY.Enter:",
				position: "after",
				content: "\n        // SPLURT EDIT START\n        // Allow Shift+Enter for new lines\n        if (event.shiftKey) {\n          return;\n        }\n        // SPLURT EDIT END",
				expectedOccurrences: 1,
			},
		],
	},
];
