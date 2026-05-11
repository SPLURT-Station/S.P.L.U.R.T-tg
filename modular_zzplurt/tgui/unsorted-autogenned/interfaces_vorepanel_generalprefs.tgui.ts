import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/VorePanel/GeneralPrefs.tsx',
		operations: [
			{
				kind: "replace",
				anchor: block`
				  absorb_allowed: { component: PrefBinary, name: 'Absorption Allowed' },
				  fullscreen_overlays_allowed: {
				    component: PrefBinary,
				    name: 'Fullscreen Overlays',
				  },
				`,
				content: block`
				  // SPLURT MODULAR EDIT - CHOMPStation Drain mode preference
				  drain_allowed: { component: PrefBinary, name: 'Drain Allowed' },
				  absorb_allowed: { component: PrefBinary, name: 'Absorption Allowed' },
				  fullscreen_overlays_allowed: {
				    component: PrefBinary,
				    name: 'Fullscreen Overlays',
				  },
				  cyborg_sleepers: { component: PrefBinary, name: 'Cyborg Sleepers' }, // SPLURT ADDITION - CYBORGS - Cyborg sleepers
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
