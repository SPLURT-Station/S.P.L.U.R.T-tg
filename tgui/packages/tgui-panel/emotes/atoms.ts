import { atom } from 'jotai';

export type EmotesList = Record<string, string>;

export const emotesVisibleAtom = atom(false);
export const emotesListAtom = atom<EmotesList>({});

export const emotesAtom = atom((get) => ({
  visible: get(emotesVisibleAtom),
  list: get(emotesListAtom),
}));
