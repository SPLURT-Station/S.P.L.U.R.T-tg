import { useAtomValue, useSetAtom } from 'jotai';
import { emotesAtom, emotesVisibleAtom } from './atoms';

export const useEmotes = () => {
  const emotes = useAtomValue(emotesAtom);
  const setEmotesVisible = useSetAtom(emotesVisibleAtom);

  return {
    ...emotes,
    toggle: () => setEmotesVisible((visible) => !visible),
  };
};
