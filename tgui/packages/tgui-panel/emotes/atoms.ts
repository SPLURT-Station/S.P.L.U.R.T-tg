// SPLURT EDIT: CUSTOM EMOTE PANEL
import { atom } from 'jotai';

export const emotesVisibleAtom = atom<boolean>(false);
export const emotesListAtom = atom<Record<string, string>>({});
