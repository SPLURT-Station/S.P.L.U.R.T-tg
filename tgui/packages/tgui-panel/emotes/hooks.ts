// SPLURT EDIT: migrated from Redux to Jotai atoms
import { useAtom, useAtomValue } from 'jotai';

import { emotesListAtom, emotesVisibleAtom } from './atoms';

export const useEmotes = () => {
  const [visible, setVisible] = useAtom(emotesVisibleAtom);
  const list = useAtomValue(emotesListAtom);
  return {
    visible,
    list,
    toggle: () => setVisible((v) => !v),
  };
};
