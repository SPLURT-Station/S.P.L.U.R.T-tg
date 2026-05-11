import type { ModularTguiScanRoot } from './manifest_loader';
import type { ModularTguiPatch } from './patches';
import type { ModularTguiOverride } from './plugin';

export const scanRoots: ModularTguiScanRoot[] = [
	{
		path: '../../tgui/unsorted-autogenned',
		recursive: true,
	},
];

export const overrides: ModularTguiOverride[] = [];

export const patches: ModularTguiPatch[] = [];
