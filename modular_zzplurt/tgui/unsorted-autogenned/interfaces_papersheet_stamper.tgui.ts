import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PaperSheet/Stamper.tsx',
		operations: [
			{
				kind: "insert",
				anchor: "        sprite={held_item_details.stamp_class}",
				position: "after",
				content: "\n        scale={held_item_details.stamp_scale} //SPLURT ADDITION",
				expectedOccurrences: 1,
			},
		],
	},
];
