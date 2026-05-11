import fs from 'node:fs';
import path from 'node:path';

import { overrides, patches, scanRoots } from './manifest';
import { loadModularTguiDefinitions } from './manifest_loader';
import { applyPatchOperations, generatedPathForTarget } from './patches';

const moduleRoot = path.resolve(import.meta.dirname);
const repoRoot = path.resolve(moduleRoot, '../../..');
const tguiRoot = path.resolve(repoRoot, 'tgui');
const compareRef = process.argv[2] ?? 'HEAD';
const outputRoot = path.resolve(
	tguiRoot,
	'node_modules/.bun/node_modules/.cache/tgui_modular_compare',
);

type Comparison = {
	diffPath?: string;
	status: 'match' | 'different' | 'missing-expected';
	target: string;
};

const comparisons: Comparison[] = [];
const definitions = loadModularTguiDefinitions(moduleRoot, {
	overrides,
	patches,
	scanRoots,
});

fs.rmSync(outputRoot, { force: true, recursive: true });

for (const override of definitions.overrides) {
	const generatedSource = fs.readFileSync(
		path.resolve(override.sourceRoot, override.replacement),
		'utf8',
	);

	comparisons.push(compareTarget(override.target, generatedSource));
}

for (const patch of definitions.patches) {
	const source = fs.readFileSync(path.resolve(tguiRoot, patch.target), 'utf8');
	const generatedSource = applyPatchOperations(
		source,
		patch.operations,
		patch.target,
	);

	comparisons.push(compareTarget(patch.target, generatedSource));
}

for (const comparison of comparisons) {
	switch (comparison.status) {
		case 'match':
			console.log(`MATCH ${comparison.target}`);
			break;
		case 'different':
			console.log(`DIFF  ${comparison.target}`);
			console.log(`      ${comparison.diffPath}`);
			break;
		case 'missing-expected':
			console.log(`MISS  ${comparison.target}`);
			console.log(`      ${compareRef}:tgui/${comparison.target} was not readable`);
			break;
	}
}

const mismatches = comparisons.filter(
	(comparison) => comparison.status !== 'match',
);

if (mismatches.length > 0) {
	process.exitCode = 1;
}

function compareTarget(target: string, generatedSource: string): Comparison {
	const expectedSource = readRefFile(`tgui/${target}`);

	if (expectedSource === undefined) {
		return {
			status: 'missing-expected',
			target,
		};
	}

	if (expectedSource === generatedSource) {
		return {
			status: 'match',
			target,
		};
	}

	const generatedPath = generatedPathForTarget(
		path.resolve(outputRoot, 'generated'),
		target,
	);
	const expectedPath = generatedPathForTarget(
		path.resolve(outputRoot, 'expected'),
		target,
	);
	const diffPath = path.resolve(
		outputRoot,
		`${target.replaceAll('/', '__')}.diff`,
	);

	fs.mkdirSync(path.dirname(generatedPath), { recursive: true });
	fs.mkdirSync(path.dirname(expectedPath), { recursive: true });
	fs.writeFileSync(generatedPath, generatedSource);
	fs.writeFileSync(expectedPath, expectedSource);

	const diff = Bun.spawnSync({
		cmd: ['git', 'diff', '--no-index', '--', expectedPath, generatedPath],
		cwd: repoRoot,
		stderr: 'pipe',
		stdout: 'pipe',
	});

	fs.writeFileSync(diffPath, diff.stdout.toString());

	return {
		diffPath,
		status: 'different',
		target,
	};
}

function readRefFile(repoPath: string) {
	const result = Bun.spawnSync({
		cmd: ['git', 'show', `${compareRef}:${repoPath}`],
		cwd: repoRoot,
		stderr: 'pipe',
		stdout: 'pipe',
	});

	if (result.exitCode !== 0) {
		return undefined;
	}

	return result.stdout.toString();
}
