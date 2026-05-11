import fs from 'node:fs';
import { createRequire } from 'node:module';
import path from 'node:path';

import { broadcastMessage, setupLink } from '../../../tgui/packages/tgui-dev-server/link/server';
import { loadSourceMaps } from '../../../tgui/packages/tgui-dev-server/link/retrace';
import { createLogger } from '../../../tgui/packages/tgui-dev-server/logging';
import { reloadByondCache } from '../../../tgui/packages/tgui-dev-server/reloader';
import { resolveGlob } from '../../../tgui/packages/tgui-dev-server/util';

import { config } from './rspack.config-dev';

const logger = createLogger('rspack');
const reloadOnce = process.argv.includes('--reload');
const tguiRoot = path.resolve(import.meta.dirname, '../../../tgui');

class ModularRspackCompiler {
	rspack: any;
	bundleDir = '';

	async setup() {
		const requireFromTgui = createRequire(`${tguiRoot}/`);
		this.rspack = await requireFromTgui('@rspack/core');
		this.bundleDir = config.output?.path || '';
	}

	async watch() {
		logger.log('setting up');
		setupLink();

		const compiler = this.rspack.rspack(config);

		compiler.hooks.watchRun.tapPromise('tgui-dev-server', async () => {
			const files = await resolveGlob(this.bundleDir, '*.hot-update.*');
			for (const file of files) {
				await Bun.file(file).delete();
			}
			logger.log('compiling');
		});

		compiler.hooks.done.tap('tgui-dev-server', async () => {
			await loadSourceMaps(this.bundleDir);
			await reloadByondCache(this.bundleDir);
			broadcastMessage({
				type: 'hotUpdate',
			});
		});

		logger.log('watching for changes');
		compiler.watch({}, (err, stats) => {
			if (err) {
				logger.error('compilation error', err);
				return;
			}
			stats
				?.toString(config.stats)
				.split('\n')
				.forEach((line) => {
					logger.log(line);
				});
		});
	}
}

async function setupServer() {
	fs.mkdirSync('./public/.tmp', { recursive: true });

	const compiler = new ModularRspackCompiler();
	await compiler.setup();

	if (reloadOnce) {
		await reloadByondCache(compiler.bundleDir);
		return;
	}

	await compiler.watch();
}

setupServer();
