// SPLURT EDIT: CUSTOM EMOTE PANEL event handler
import { store } from '../events/store';
import { emotesListAtom } from './atoms';

export function setEmotesList(payload: Record<string, string>) {
  store.set(emotesListAtom, payload);
}
