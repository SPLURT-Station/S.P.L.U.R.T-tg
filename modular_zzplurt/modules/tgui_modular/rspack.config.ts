import path from 'node:path';

import baseConfig from '../../../tgui/rspack.config';

import { createModularTguiPlugins } from './plugin';

const tguiRoot = path.resolve(import.meta.dirname, '../../../tgui');

export default {
	...baseConfig,
	plugins: [
		...createModularTguiPlugins(tguiRoot),
		...(baseConfig.plugins ?? []),
	],
};
