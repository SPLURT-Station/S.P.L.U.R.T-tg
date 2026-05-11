import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/CommunicationsConsole/types.ts',
		operations: [
			{
				kind: "insert",
				anchor: "export type Shuttle = {",
				position: "before",
				content: "// SPLURT EDIT - Security cyborg management\nexport type SecurityCyborg = {\n  name: string;\n  ref: string;\n  fired: boolean;\n};\n// SPLURT EDIT END\n\n",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  // static_data",
				position: "before",
				content: "  // SPLURT EDIT - Security cyborg management\n  canManageSecurityCyborgs: BooleanLike;\n  securityCyborgs: SecurityCyborg[];\n  // SPLURT EDIT END\n\n",
				expectedOccurrences: 1,
			},
		],
	},
];
