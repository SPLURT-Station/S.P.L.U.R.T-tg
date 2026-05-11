import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PreferencesMenu/types.ts',
		operations: [
			{
				kind: "replace",
				anchor: "  // SKYRAT EDIT END\n\n  keybindings: Record<string, string[]>;",
				content: "  // SKYRAT EDIT END\n  // SPLURT EDIT START\n  donator_tier: number;\n  // SPLURT EDIT END\n\n  keybindings: Record<string, string[]>;",
				expectedOccurrences: 1,
			},
		],
	},
];
