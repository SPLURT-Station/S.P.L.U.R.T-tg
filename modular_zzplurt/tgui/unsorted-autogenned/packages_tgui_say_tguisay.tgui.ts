import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui-say/TguiSay.tsx',
		operations: [
			{
				kind: "insert",
				anchor: "      case KEY.Enter:",
				position: "after",
				content: block`
				
				        // SPLURT EDIT START
				        // Allow Shift+Enter for new lines
				        if (event.shiftKey) {
				          return;
				        }
				        // SPLURT EDIT END
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
