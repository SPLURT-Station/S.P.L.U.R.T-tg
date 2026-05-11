import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/Crayon.tsx',
		operations: [
			{
				kind: "replace",
				anchor: block`
				    washable_coloring_mode,
				    remove_coloring,
				
				`,
				content: "",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: block`
				              <LabeledList.Item>
				                <Button
				                  content={washable_coloring_mode ? 'Washable paint' : 'Permanent paint'}
				                  onClick={() => act('change_color_mode')}
				                />
				                <Button
				                  content={remove_coloring ? 'Remove paint mode' : 'Paint mode'}
				                  selected={remove_coloring}
				                  onClick={() => act('toggle_remove_coloring')}
				                />
				              </LabeledList.Item>
				
				`,
				content: "",
				expectedOccurrences: 1,
			},
		],
	},
];
