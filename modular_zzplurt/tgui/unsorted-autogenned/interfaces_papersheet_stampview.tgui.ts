import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PaperSheet/StampView.tsx',
		operations: [
			{
				kind: "insert",
				anchor: "            sprite={stamp.class}",
				position: "after",
				content: block`
				
				            scale={stamp.scale} //SPLURT ADDITION
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
