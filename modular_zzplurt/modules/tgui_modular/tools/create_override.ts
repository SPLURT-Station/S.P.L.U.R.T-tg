import fs from 'node:fs';
import path from 'node:path';

import {
	createOverrideFromSources,
	getDefaultToolPaths,
	normalizeTguiTarget,
	optionalStringArg,
	parseArgs,
	readUpstreamSource,
	requireStringArg,
} from './lib';

const args = parseArgs(Bun.argv.slice(2));
const paths = getDefaultToolPaths();
const target = normalizeTguiTarget(requireStringArg(args, 'target'));
const outputDir = path.resolve(paths.repoRoot, requireStringArg(args, 'out-dir'));
const upstreamRef = optionalStringArg(args, 'upstream-ref');
const upstreamUrl = optionalStringArg(args, 'upstream-url');
const localSource = fs.readFileSync(path.resolve(paths.tguiRoot, target), 'utf8');
const upstreamSource = await readUpstreamSource({
	paths,
	target,
	upstreamRef,
	upstreamUrl,
});
const result = createOverrideFromSources({
	localSource,
	moduleRoot: paths.moduleRoot,
	outputDir,
	target,
	upstreamSource,
});

if (!result.changed) {
	console.log(`UNCHANGED ${result.target}`);
	process.exit(0);
}

console.log(`OVERRIDE ${result.target}`);
console.log(`manifest: ${result.manifestPath}`);
console.log(`strategy: ${result.strategy}`);
if (result.replacementPath) {
	console.log(`replacement: ${result.replacementPath}`);
}
for (const warning of result.warnings) {
	console.warn(`WARNING ${warning}`);
}
