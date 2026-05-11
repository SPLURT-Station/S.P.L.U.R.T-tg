import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/VorePanel/GeneralPrefs.tsx',
		operations: [
			{
				kind: "replace",
				anchor: "  absorb_allowed: { component: PrefBinary, name: 'Absorption Allowed' },\n  fullscreen_overlays_allowed: {\n    component: PrefBinary,\n    name: 'Fullscreen Overlays',\n  },",
				content: "  // SPLURT MODULAR EDIT - CHOMPStation Drain mode preference\n  drain_allowed: { component: PrefBinary, name: 'Drain Allowed' },\n  absorb_allowed: { component: PrefBinary, name: 'Absorption Allowed' },\n  fullscreen_overlays_allowed: {\n    component: PrefBinary,\n    name: 'Fullscreen Overlays',\n  },\n  cyborg_sleepers: { component: PrefBinary, name: 'Cyborg Sleepers' }, // SPLURT ADDITION - CYBORGS - Cyborg sleepers",
				expectedOccurrences: 1,
			},
		],
	},
];
