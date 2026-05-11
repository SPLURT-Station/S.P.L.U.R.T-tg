import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui-panel/events/listeners.ts',
		operations: [
			{
				kind: "replace",
				anchor: block`
				import { pingReply, pingSoft } from '../ping/handlers';
				import {
				  handleTelemetryData,
				  telemetryRequest,
				  testTelemetryCommand,
				} from '../telemetry/handlers';
				import { handleLoadAssets } from './handlers/assets';
				import { roundrestart } from './handlers/roundrestart';
				
				const listeners = {
				  'asset/stylesheet': loadStyleSheet,
				  'asset/mappings': handleLoadAssets,
				  'audio/playMusic': playMusic,
				  'audio/stopMusic': stopMusic,
				  'chat/message': chatMessage,
				`,
				content: block`
				import { handleEmotesList } from '../emotes/handlers';
				import { pingReply, pingSoft } from '../ping/handlers';
				import {
				  handleTelemetryData,
				  telemetryRequest,
				  testTelemetryCommand,
				} from '../telemetry/handlers';
				import { handleLoadAssets } from './handlers/assets';
				import { roundrestart } from './handlers/roundrestart';
				
				const listeners = {
				  'asset/stylesheet': loadStyleSheet,
				  'asset/mappings': handleLoadAssets,
				  'audio/playMusic': playMusic,
				  'audio/stopMusic': stopMusic,
				  'chat/message': chatMessage,
				  'emotes/setList': handleEmotesList,
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
