import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/CrewConsoleBubbers.tsx',
		operations: [
			{
				kind: "replace",
				anchor: "  if (healthSum <= 56) return 0;\n  if (healthSum <= 72) return 1;\n  if (healthSum <= 85) return 2;\n  if (healthSum <= 100) return 3;\n  if (healthSum <= 115) return 4;\n  return 5; // over 116 (near crit)",
				content: "  //Splurt Edit Start\n  if (healthSum <= 56) return 0;\n  if (healthSum <= 72) return 1;\n  if (healthSum <= 85) return 2;\n  if (healthSum <= 100) return 3;\n  if (healthSum <= 115) return 4;\n  return 5; // over 116 (near crit)\n  // Back to 100 HP :) Splurt edit end",
				expectedOccurrences: 1,
			},
		],
	},
];
