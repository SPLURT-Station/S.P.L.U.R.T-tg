import { loadStyleSheet } from 'common/assets';
import { playMusic, stopMusic } from '../audio/handlers';
import { chatMessage } from '../chat/handlers';
import { setEmotesList } from '../emotes/handlers'; // SPLURT EDIT: CUSTOM EMOTE PANEL
import { pingReply, pingSoft } from '../ping/handlers';
import {
  handleTelemetryData,
  telemetryRequest,
  testTelemetryCommand,
} from '../telemetry/handlers';
import { handleLoadAssets } from './handlers/assets';
import { roundrestart } from './handlers/roundrestart';

export const listeners = {
  'asset/stylesheet': loadStyleSheet,
  'asset/mappings': handleLoadAssets,
  'audio/playMusic': playMusic,
  'audio/stopMusic': stopMusic,
  'chat/message': chatMessage,
  'emotes/setList': setEmotesList, // SPLURT EDIT: CUSTOM EMOTE PANEL
  'ping/reply': pingReply,
  'ping/soft': pingSoft,
  roundrestart,
  'telemetry/request': telemetryRequest,
  testTelemetryCommand,
  update: handleTelemetryData,
} as const;
