import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/AntagInfoRules.tsx',
		operations: [
			{
				kind: "replace-all",
				anchor: "              <a href=\"https://wiki.bubberstation.org/index.php?title=Rules\">",
				content: "              <a href=\"http://wiki.splurt.space/Rules\">",
				expectedOccurrences: 19,
			},
		],
	},
];
