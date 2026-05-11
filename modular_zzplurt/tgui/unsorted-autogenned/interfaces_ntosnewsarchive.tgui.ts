import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/NtosNewsArchive.jsx',
		operations: [
			{
				kind: "replace",
				anchor: block`
				import { useBackend } from '../backend';
				import { Collapsible, Section } from 'tgui-core/components';
				`,
				content: block`
				import { Collapsible, Section } from 'tgui-core/components';
				
				import { useBackend } from '../backend';
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
