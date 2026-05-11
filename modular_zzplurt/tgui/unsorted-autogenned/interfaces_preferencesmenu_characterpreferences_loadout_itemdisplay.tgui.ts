import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PreferencesMenu/CharacterPreferences/loadout/ItemDisplay.tsx',
		operations: [
			{
				kind: "replace",
				anchor: "};\n\nexport function LoadoutTabDisplay(props: TabProps) {",
				content: "};\nexport function LoadoutTabDisplay(props: TabProps) {",
				expectedOccurrences: 1,
			},
		],
	},
];
