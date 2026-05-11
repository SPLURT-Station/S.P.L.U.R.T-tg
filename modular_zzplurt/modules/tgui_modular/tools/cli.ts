import { fileURLToPath } from 'node:url';

const [, , command, ...args] = Bun.argv;

switch (command) {
	case 'analyze':
		run(['rspack', '--analyze', '--config', pathFromCli('../rspack.config.ts')]);
		break;
	case 'build':
		run(['rspack', 'build', '--config', pathFromCli('../rspack.config.ts')]);
		break;
	case 'compare':
		runTool('../compare.ts', args);
		break;
	case 'create-override':
		runTool('./create_override.ts', args);
		break;
	case 'dev':
		run(['bun', '--smol', pathFromCli('../dev_server.ts'), ...args]);
		break;
	case 'generate-final':
		runTool('./generate_final.ts', args);
		break;
	case 'migrate-overrides':
		runTool('./migrate_modified.ts', args);
		break;
	case 'test':
		run(['bun', 'test', pathFromCli('../')]);
		break;
	default:
		console.error(
			[
				'Usage: bun run tgui:modular-tool -- <command> [options]',
				'',
				'Commands:',
				'  analyze',
				'  build',
				'  compare',
				'  create-override',
				'  dev',
				'  generate-final',
				'  migrate-overrides',
				'  test',
			].join('\n'),
		);
		process.exit(1);
}

function runTool(relativePath: string, args: string[]) {
	run(['bun', pathFromCli(relativePath), ...args]);
}

function run(cmd: string[]) {
	const result = Bun.spawnSync({
		cmd,
		stderr: 'inherit',
		stdout: 'inherit',
	});

	process.exit(result.exitCode);
}

function pathFromCli(relativePath: string) {
	return fileURLToPath(new URL(relativePath, import.meta.url));
}
