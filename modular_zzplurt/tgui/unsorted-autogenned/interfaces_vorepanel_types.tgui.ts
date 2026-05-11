import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/VorePanel/types.ts',
		operations: [
			{
				kind: "insert",
				anchor: "  Unabsorbed = 'Unabsorb',",
				position: "after",
				content: block`
				
				  // SPLURT MODULAR EDIT START - Add Drain/Heal digest modes
				  Drain = 'Drain',
				  Heal = 'Heal',
				  // SPLURT MODULAR EDIT END
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  [DigestMode.Unabsorbed]: { text: 'being reformed.', color: 'good' },",
				position: "after",
				content: block`
				
				  // SPLURT MODULAR EDIT START - Add Drain/Heal digest mode text
				  [DigestMode.Drain]: {
				    text: 'having their nutrition drained.',
				    color: 'warning',
				  },
				  [DigestMode.Heal]: { text: 'being healed.', color: 'good' },
				  // SPLURT MODULAR EDIT END
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  unabsorb_messages_prey: 'Unabsorb Messages (Prey)',",
				position: "after",
				content: block`
				
				  // SPLURT MODULAR EDIT START - Add Drain/Heal message labels
				  drain_messages_owner: 'Drain Messages (Owner)',
				  drain_messages_prey: 'Drain Messages (Prey)',
				  heal_messages_owner: 'Heal Messages (Owner)',
				  heal_messages_prey: 'Heal Messages (Prey)',
				  // SPLURT MODULAR EDIT END
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
