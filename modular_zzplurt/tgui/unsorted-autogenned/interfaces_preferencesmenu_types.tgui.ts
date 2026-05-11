import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PreferencesMenu/types.ts',
		operations: [
			{
				kind: "replace",
				anchor: block`
				  // SKYRAT EDIT END
				
				  keybindings: Record<string, string[]>;
				`,
				content: block`
				  // SKYRAT EDIT END
				  // SPLURT EDIT START
				  donator_tier: number;
				  // SPLURT EDIT END
				
				  keybindings: Record<string, string[]>;
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
