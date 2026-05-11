import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui-panel/events/listeners.ts',
		operations: [
			{
				kind: "replace",
				anchor: "import { pingReply, pingSoft } from '../ping/handlers';\nimport {\n  handleTelemetryData,\n  telemetryRequest,\n  testTelemetryCommand,\n} from '../telemetry/handlers';\nimport { handleLoadAssets } from './handlers/assets';\nimport { roundrestart } from './handlers/roundrestart';\n\nconst listeners = {\n  'asset/stylesheet': loadStyleSheet,\n  'asset/mappings': handleLoadAssets,\n  'audio/playMusic': playMusic,\n  'audio/stopMusic': stopMusic,\n  'chat/message': chatMessage,",
				content: "import { handleEmotesList } from '../emotes/handlers';\nimport { pingReply, pingSoft } from '../ping/handlers';\nimport {\n  handleTelemetryData,\n  telemetryRequest,\n  testTelemetryCommand,\n} from '../telemetry/handlers';\nimport { handleLoadAssets } from './handlers/assets';\nimport { roundrestart } from './handlers/roundrestart';\n\nconst listeners = {\n  'asset/stylesheet': loadStyleSheet,\n  'asset/mappings': handleLoadAssets,\n  'audio/playMusic': playMusic,\n  'audio/stopMusic': stopMusic,\n  'chat/message': chatMessage,\n  'emotes/setList': handleEmotesList,",
				expectedOccurrences: 1,
			},
		],
	},
];
