import path from 'node:path';

import { config as baseConfig } from '../../../tgui/rspack.config-dev';

import { createModularTguiPlugins } from './plugin';

const tguiRoot = path.resolve(import.meta.dirname, '../../../tgui');

export const config = {
	...baseConfig,
	plugins: [
		...createModularTguiPlugins(tguiRoot),
		...(baseConfig.plugins ?? []),
	],
};

export default config;
