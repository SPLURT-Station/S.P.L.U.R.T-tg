import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PreferencesMenu/CharacterPreferences/loadout/ItemDisplay.tsx',
		operations: [
			{
				kind: "replace",
				anchor: block`
				};
				
				export function LoadoutTabDisplay(props: TabProps) {
				`,
				content: block`
				};
				export function LoadoutTabDisplay(props: TabProps) {
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
