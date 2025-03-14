import { useState } from 'react';
import { Button, Flex, Section } from 'tgui-core/components';

import { useEmotes } from './hooks';

interface EmoteEntry {
  key: string;
  name: string;
}

const COOLDOWN_DURATION = 1000; // 1 second

export const EmotesToolbar = () => {
  const emotes = useEmotes();
  const [cooldowns, setCooldowns] = useState<Record<string, boolean>>({});

  const emoteList = Object.entries(emotes.list || {}).map(
    ([key, name]): EmoteEntry => ({
      key,
      name: String(name),
    }),
  );

  const emoteCreate = () => Byond.sendMessage('emotes/create');

  const emoteExecute = (key: string) => {
    if (cooldowns[key]) {
      return;
    }

    Byond.sendMessage('emotes/execute', {
      key: key,
    });

    setCooldowns((prev) => ({ ...prev, [key]: true }));
    setTimeout(() => {
      setCooldowns((prev) => ({ ...prev, [key]: false }));
    }, COOLDOWN_DURATION);
  };

  const emoteContextAction = (key: string) =>
    Byond.sendMessage('emotes/contextAction', {
      key: key,
    });

  return (
    <Section>
      <Flex align="center" style={{ 'flex-wrap': 'wrap' }}>
        {emoteList
          .sort((a, b) => a.name.localeCompare(b.name))
          .map((emote) => (
            <Flex.Item mx={0.5} mt={1} key={emote.key}>
              <Button
                content={emote.name}
                onClick={() => emoteExecute(emote.key)}
                onContextMenu={(e) => {
                  e.preventDefault();
                  emoteContextAction(emote.key);
                }}
                tooltip={`*${emote.key}`}
                disabled={cooldowns[emote.key]}
              />
            </Flex.Item>
          ))}
        <Flex.Item mx={0.5} mt={1}>
          <Button icon="plus" color="green" onClick={() => emoteCreate()} />
        </Flex.Item>
      </Flex>
    </Section>
  );
};
