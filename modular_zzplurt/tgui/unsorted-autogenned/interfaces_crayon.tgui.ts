import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/Crayon.tsx',
		operations: [
			{
				kind: "replace",
				anchor: "    washable_coloring_mode,\n    remove_coloring,\n",
				content: "",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "              <LabeledList.Item>\n                <Button\n                  content={washable_coloring_mode ? 'Washable paint' : 'Permanent paint'}\n                  onClick={() => act('change_color_mode')}\n                />\n                <Button\n                  content={remove_coloring ? 'Remove paint mode' : 'Paint mode'}\n                  selected={remove_coloring}\n                  onClick={() => act('toggle_remove_coloring')}\n                />\n              </LabeledList.Item>\n",
				content: "",
				expectedOccurrences: 1,
			},
		],
	},
];
