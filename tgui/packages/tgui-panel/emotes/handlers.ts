import { store } from '../events/store';
import { emotesListAtom } from './atoms';

function normalizeEmotesList(payload: unknown): Record<string, string> {
  if (!payload) {
    return {};
  }

  if (typeof payload === 'string') {
    try {
      return normalizeEmotesList(JSON.parse(payload));
    } catch {
      return {};
    }
  }

  if (Array.isArray(payload)) {
    return payload.reduce<Record<string, string>>((acc, emote) => {
      if (emote && typeof emote === 'object') {
        const key = String((emote as any).key ?? '');
        const name = String((emote as any).name ?? key);
        if (key) {
          acc[key] = name;
        }
      }
      return acc;
    }, {});
  }

  if (typeof payload === 'object') {
    const source =
      payload && typeof (payload as any).list === 'object'
        ? (payload as any).list
        : payload;

    return Object.entries(source as Record<string, unknown>).reduce<
      Record<string, string>
    >((acc, [key, value]) => {
      if (value === undefined || value === null) {
        return acc;
      }
      acc[key] = String(value);
      return acc;
    }, {});
  }

  return {};
}

export function handleEmotesList(payload: unknown): void {
  store.set(emotesListAtom, normalizeEmotesList(payload));
}
