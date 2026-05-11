import type { ModularTguiOverride } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides: ModularTguiOverride[] = [
	{
		target: 'packages/tgui/interfaces/Mecha/ModulesPane.tsx',
		replacement: 'overrides/packages/tgui/interfaces/Mecha/ModulesPane.tsx',
	},
];

export const patches = [];
