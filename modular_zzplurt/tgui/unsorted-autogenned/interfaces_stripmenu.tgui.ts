import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/StripMenu.tsx',
		operations: [
			{
				kind: "insert",
				anchor: "  eyes: {",
				position: "before",
				content: "  socks: {\n    displayName: 'socks',\n    gridSpot: getGridSpotKey([0, 0]),\n    image: 'inventory-socks.png',\n  },\n\n",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  neck: {",
				position: "before",
				content: "  ears_extra: {\n    displayName: 'right ear',\n    gridSpot: getGridSpotKey([0, 3]),\n    image: 'inventory-ears_extra.png',\n  },\n\n  undershirt: {\n    displayName: 'shirt',\n    gridSpot: getGridSpotKey([0, 4]),\n    image: 'inventory-undershirt.png',\n  },\n\n  underwear: {\n    displayName: 'underwear',\n    gridSpot: getGridSpotKey([0, 5]),\n    image: 'inventory-underwear.png',\n  },\n\n  bra: {\n    displayName: 'bra',\n    gridSpot: getGridSpotKey([1, 0]),\n    image: 'inventory-bra.png',\n  },\n\n",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "    displayName: 'earwear',",
				content: "    displayName: 'left ear',",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  suit_storage: {",
				position: "before",
				content: "  wrists: {\n    displayName: 'wrists',\n    gridSpot: getGridSpotKey([3, 3]),\n    image: 'inventory-wrists.png',\n  },\n\n",
				expectedOccurrences: 1,
			},
		],
	},
];
