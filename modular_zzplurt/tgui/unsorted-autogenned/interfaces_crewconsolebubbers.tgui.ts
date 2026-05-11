import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/CrewConsoleBubbers.tsx',
		operations: [
			{
				kind: "replace",
				anchor: block`
				  if (healthSum <= 56) return 0;
				  if (healthSum <= 72) return 1;
				  if (healthSum <= 85) return 2;
				  if (healthSum <= 100) return 3;
				  if (healthSum <= 115) return 4;
				  return 5; // over 116 (near crit)
				`,
				content: block`
				  //Splurt Edit Start
				  if (healthSum <= 56) return 0;
				  if (healthSum <= 72) return 1;
				  if (healthSum <= 85) return 2;
				  if (healthSum <= 100) return 3;
				  if (healthSum <= 115) return 4;
				  return 5; // over 116 (near crit)
				  // Back to 100 HP :) Splurt edit end
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
