import fs from 'node:fs';
import path from 'node:path';

import {
	generateFinalSource,
	getDefaultToolPaths,
	loadConfiguredDefinitions,
	normalizeTguiTarget,
	optionalStringArg,
	parseArgs,
	requireStringArg,
} from './lib';

const args = parseArgs(Bun.argv.slice(2));
const paths = getDefaultToolPaths();
const target = normalizeTguiTarget(requireStringArg(args, 'target'));
const output = optionalStringArg(args, 'out');
const result = generateFinalSource({
	definitions: loadConfiguredDefinitions(paths.moduleRoot),
	moduleRoot: paths.moduleRoot,
	target,
	tguiRoot: paths.tguiRoot,
});

if (output) {
	const outputPath = path.resolve(paths.repoRoot, output);
	fs.mkdirSync(path.dirname(outputPath), { recursive: true });
	fs.writeFileSync(outputPath, result.source);
	console.log(`WROTE ${result.target} -> ${outputPath}`);
} else {
	process.stdout.write(result.source);
}
