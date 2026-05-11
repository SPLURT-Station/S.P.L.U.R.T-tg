import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

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
				content: block`
				// SPLURT EDIT - Security cyborg management
				export type SecurityCyborg = {
				  name: string;
				  ref: string;
				  fired: boolean;
				};
				// SPLURT EDIT END
				
				
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  // static_data",
				position: "before",
				content: block`
				  // SPLURT EDIT - Security cyborg management
				  canManageSecurityCyborgs: BooleanLike;
				  securityCyborgs: SecurityCyborg[];
				  // SPLURT EDIT END
				
				
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
