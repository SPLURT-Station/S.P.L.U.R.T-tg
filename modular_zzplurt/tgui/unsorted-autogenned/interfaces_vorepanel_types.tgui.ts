import type { ModularTguiPatch } from '../.';

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
				content: "\n  // SPLURT MODULAR EDIT START - Add Drain/Heal digest modes\n  Drain = 'Drain',\n  Heal = 'Heal',\n  // SPLURT MODULAR EDIT END",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  [DigestMode.Unabsorbed]: { text: 'being reformed.', color: 'good' },",
				position: "after",
				content: "\n  // SPLURT MODULAR EDIT START - Add Drain/Heal digest mode text\n  [DigestMode.Drain]: {\n    text: 'having their nutrition drained.',\n    color: 'warning',\n  },\n  [DigestMode.Heal]: { text: 'being healed.', color: 'good' },\n  // SPLURT MODULAR EDIT END",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  unabsorb_messages_prey: 'Unabsorb Messages (Prey)',",
				position: "after",
				content: "\n  // SPLURT MODULAR EDIT START - Add Drain/Heal message labels\n  drain_messages_owner: 'Drain Messages (Owner)',\n  drain_messages_prey: 'Drain Messages (Prey)',\n  heal_messages_owner: 'Heal Messages (Owner)',\n  heal_messages_prey: 'Heal Messages (Prey)',\n  // SPLURT MODULAR EDIT END",
				expectedOccurrences: 1,
			},
		],
	},
];
