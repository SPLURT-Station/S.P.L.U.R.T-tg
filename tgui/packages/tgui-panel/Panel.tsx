/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { Pane } from 'tgui/layouts';
import { Button, Section, Stack } from 'tgui-core/components';

import { NowPlayingWidget, useAudio } from './audio';
import { ChatPanel, ChatTabs } from './chat';
import { EmotesToolbar, useEmotes } from './emotes'; // SPLURT EDIT:  CUSTOM EMOTE PANEL
import { useGame } from './game';
import { Notifications } from './Notifications';
import { PingIndicator } from './ping';
import { ReconnectButton } from './reconnect';
import { SettingsPanel, useSettings } from './settings';

export const Panel = (props) => {
  const audio = useAudio();
  const settings = useSettings();
  const game = useGame();
  const emotes = useEmotes(); // SPLURT EDIT:  CUSTOM EMOTE PANEL
  if (process.env.NODE_ENV !== 'production') {
    const { useDebug, KitchenSink } = require('tgui/debug');
    const debug = useDebug();
    if (debug.kitchenSink) {
      return <KitchenSink panel />;
    }
  }

  return (
    <Pane theme={settings.theme}>
      <Stack fill vertical>
        <Stack.Item>
          <Section fitted>
            <Stack mr={1} align="center">
              <Stack.Item grow overflowX="auto">
                <ChatTabs />
              </Stack.Item>
              <Stack.Item>
                <PingIndicator />
              </Stack.Item>
              {/* SPLURT EDIT START:  CUSTOM EMOTE PANEL */}
              <Stack.Item>
                <Button
                  color="grey"
                  selected={emotes.visible}
                  icon="asterisk"
                  tooltip="Emote Panel"
                  tooltipPosition="bottom-start"
                  onClick={() => emotes.toggle()}
                />
              </Stack.Item>
              {/* SPLURT EDIT END:  CUSTOM EMOTE PANEL */}
              <Stack.Item>
                <Button
                  color="grey"
                  selected={audio.visible}
                  icon="music"
                  tooltip="Music player"
                  tooltipPosition="bottom-start"
                  onClick={() => audio.toggle()}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon={settings.visible ? 'times' : 'cog'}
                  selected={settings.visible}
                  tooltip={
                    settings.visible ? 'Close settings' : 'Open settings'
                  }
                  tooltipPosition="bottom-start"
                  onClick={() => settings.toggle()}
                />
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
        {/* SPLURT EDIT START:  CUSTOM EMOTE PANEL */}
        {emotes.visible && (
          <Stack.Item>
            <Section>
              <EmotesToolbar />
            </Section>
          </Stack.Item>
        )}
        {/* SPLURT EDIT END:  CUSTOM EMOTE PANEL */}
        {audio.visible && (
          <Stack.Item>
            <Section>
              <NowPlayingWidget />
            </Section>
          </Stack.Item>
        )}
        {settings.visible && (
          <Stack.Item>
            <SettingsPanel />
          </Stack.Item>
        )}
        <Stack.Item grow>
          <Section fill fitted position="relative">
            <Pane.Content scrollable>
              <ChatPanel lineHeight={settings.lineHeight} />
            </Pane.Content>
            <Notifications>
              {game.connectionLostAt && (
                <Notifications.Item rightSlot={<ReconnectButton />}>
                  You are either AFK, experiencing lag or the connection has
                  closed.
                </Notifications.Item>
              )}
              {game.roundRestartedAt && (
                <Notifications.Item>
                  The connection has been closed because the server is
                  restarting. Please wait while you automatically reconnect.
                </Notifications.Item>
              )}
            </Notifications>
          </Section>
        </Stack.Item>
      </Stack>
    </Pane>
  );
};
