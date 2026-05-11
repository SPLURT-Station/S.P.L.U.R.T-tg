import path from 'node:path';

import {
	getDefaultToolPaths,
	migrateModifiedTguiFiles,
	optionalStringArg,
	parseArgs,
	requireStringArg,
} from './lib';

const args = parseArgs(Bun.argv.slice(2));
const paths = getDefaultToolPaths();
const outputDir = path.resolve(paths.repoRoot, requireStringArg(args, 'out-dir'));
const upstreamRef = optionalStringArg(args, 'upstream-ref');
const upstreamUrl = optionalStringArg(args, 'upstream-url');
const targetList = optionalStringArg(args, 'targets');
const targets = targetList
	?.split(',')
	.map((target) => target.trim())
	.filter(Boolean);
const result = await migrateModifiedTguiFiles({
	outputDir,
	paths,
	targets,
	upstreamRef,
	upstreamUrl,
});

for (const target of result.migrated) {
	console.log(`MIGRATED ${target}`);
}

for (const target of result.skipped) {
	console.log(`SKIPPED ${target}`);
}
