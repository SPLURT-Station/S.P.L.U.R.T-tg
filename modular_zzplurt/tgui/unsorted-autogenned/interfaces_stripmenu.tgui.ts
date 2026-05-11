import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

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
				content: block`
				  socks: {
				    displayName: 'socks',
				    gridSpot: getGridSpotKey([0, 0]),
				    image: 'inventory-socks.png',
				  },
				
				
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  neck: {",
				position: "before",
				content: block`
				  ears_extra: {
				    displayName: 'right ear',
				    gridSpot: getGridSpotKey([0, 3]),
				    image: 'inventory-ears_extra.png',
				  },
				
				  undershirt: {
				    displayName: 'shirt',
				    gridSpot: getGridSpotKey([0, 4]),
				    image: 'inventory-undershirt.png',
				  },
				
				  underwear: {
				    displayName: 'underwear',
				    gridSpot: getGridSpotKey([0, 5]),
				    image: 'inventory-underwear.png',
				  },
				
				  bra: {
				    displayName: 'bra',
				    gridSpot: getGridSpotKey([1, 0]),
				    image: 'inventory-bra.png',
				  },
				
				
				`,
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
				content: block`
				  wrists: {
				    displayName: 'wrists',
				    gridSpot: getGridSpotKey([3, 3]),
				    image: 'inventory-wrists.png',
				  },
				
				
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
