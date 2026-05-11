import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/common/JobToIcon.ts',
		operations: [
			{
				kind: "insert",
				anchor: "  Cyborg: 'robot',",
				position: "after",
				content: block`
				
				  'Security Cyborg': 'robot', //SPLURT ADDITION
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  'Nanotrasen Consultant': 'clipboard-check',",
				position: "after",
				content: block`
				
				  'Nanotrasen Crew Trainer': 'hat-cowboy', //Splurt Edit
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
