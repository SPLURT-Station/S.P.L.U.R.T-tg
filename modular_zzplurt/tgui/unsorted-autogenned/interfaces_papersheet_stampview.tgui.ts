import type { ModularTguiPatch } from '../.';

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
				content: "\n            scale={stamp.scale} //SPLURT ADDITION",
				expectedOccurrences: 1,
			},
		],
	},
];
