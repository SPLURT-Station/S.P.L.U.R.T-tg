import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  Input,
  Knob,
  LabeledControls,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { Window } from '../layouts';

export const Jukebox = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    active,
    track_selected,
    track_length,
    volume,
    repeat,
    songs,
    queued_tracks = [],
  } = data;
  const cost_for_play = 0;
  const is_emagged = false;
  const has_access = true;

  const SONGS_PER_PAGE = 15;

  const [tab, setTab] = useSharedState('tab', 1);
  const [currentPage, setCurrentPage] = useSharedState('currentPage', 1);
  const [searchQuery, setSearchQuery] = useSharedState('searchQuery', '');

  const [queuePage, setQueuePage] = useSharedState('queuePage', 1);

  const filteredSongs = searchQuery
    ? songs.filter((track) =>
        track.name.toLowerCase().includes(searchQuery.toLowerCase().trim()),
      )
    : songs;

  const filteredPages = Math.ceil(filteredSongs.length / SONGS_PER_PAGE);

  if (currentPage > filteredPages) {
    setCurrentPage(1);
  }

  const paginatedSongs = paginate(filteredSongs, SONGS_PER_PAGE, currentPage);

  const filteredQueuePages = Math.ceil(queued_tracks.length / SONGS_PER_PAGE);

  const handleSearchInput = (query) => {
    setSearchQuery(query);
    setCurrentPage(1);
  };

  return (
    <Window width={520} height={680}>
      <Window.Content overflowY="scroll">
        <Section
          fluid
          title="Настройки"
          buttons={
            <Box>
              <Button
                content={repeat ? 'Повтор' : '1 Раз'}
                selected={repeat}
                disabled={!has_access}
                onClick={() => act('repeat')}
              />
              <Button
                icon={active ? 'pause' : 'play'}
                content={active ? 'Стоп' : 'Играть'}
                selected={active}
                disabled={!has_access}
                onClick={() => act('toggle')}
              />
            </Box>
          }
        >
          <Stack>
            <Stack.Item>
              <LabeledList>
                <LabeledList.Item label="Текущий трек">
                  {track_selected ? track_selected : 'Трек не выбран'}
                </LabeledList.Item>
                <LabeledList.Item label="Продолжительность">
                  {track_selected ? track_length : 'Трек не выбран'}
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Item>
              <LabeledControls justify="center">
                <LabeledControls.Item
                  position="relative"
                  label="Громкость"
                  right="4px"
                >
                  <Box position="relative">
                    <Knob
                      size={2.4}
                      color={volume > 750 ? 'red' : 'green'}
                      value={volume}
                      unit="%"
                      minValue={0}
                      maxValue={is_emagged ? 1000 : 100}
                      step={1}
                      stepPixelSize={1}
                      disabled={!has_access}
                      onDrag={(e, value) =>
                        act('set_volume', {
                          volume: value,
                        })
                      }
                    />
                    <Button
                      fluid
                      position="absolute"
                      top="67px"
                      right="66px"
                      color="transparent"
                      icon="fast-backward"
                      disabled={!has_access}
                      onClick={() =>
                        act('set_volume', {
                          volume: 'min',
                        })
                      }
                    />
                    <Button
                      fluid
                      position="absolute"
                      top="67px"
                      right="-14px"
                      color="transparent"
                      icon="fast-forward"
                      disabled={!has_access}
                      onClick={() =>
                        act('set_volume', {
                          volume: 'max',
                        })
                      }
                    />
                    <Button
                      fluid
                      position="absolute"
                      top="67px"
                      right="84px"
                      color="transparent"
                      icon="undo"
                      disabled={!has_access}
                      onClick={() =>
                        act('set_volume', {
                          volume: 'reset',
                        })
                      }
                    />
                  </Box>
                </LabeledControls.Item>
              </LabeledControls>
            </Stack.Item>
          </Stack>
          <LabeledList>
            <LabeledList.Item label="Цена добавления в очередь">
              {has_access ? 'Бесплатно' : cost_for_play + ' CR'}
            </LabeledList.Item>
          </LabeledList>
        </Section>

        <Tabs>
          <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
            Треки
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
            Очередь
          </Tabs.Tab>
          <Stack.Item grow />
          <Button
            color="transparent"
            icon="shuffle"
            tooltip="Случайная песня"
            onClick={() => act('random_song')}
          />
        </Tabs>
        {tab === 1 && (
          <Section fluid vertical>
            <Stack>
              <Stack.Item grow>
                <Input
                  fluid
                  autoFocus
                  placeholder="Найти треки..."
                  value={searchQuery}
                  onInput={(e) => handleSearchInput(e.target.value)}
                />
              </Stack.Item>
            </Stack>

            <Section fluid>
              {paginatedSongs && paginatedSongs.length ? (
                <Tabs vertical style={{ 'pointer-events': 'none' }}>
                  {paginatedSongs.map((track) => (
                    <Tabs.Tab
                      key={track.name}
                      style={{
                        backgroundColor: 'rgba(0, 0, 0, 0.2)', // Черный фон с прозрачностью 0.8
                        transition: 'background-color 0.3s ease',
                        marginBottom: '4px',
                        borderRadius: '4px',
                        border: '1px solid rgba(0, 0, 0, 0.1)',
                      }}
                    >
                      <Stack>
                        <Stack.Item grow>{track.name}</Stack.Item>
                        <Stack.Item>
                          <Button
                            icon="play"
                            content="В очередь"
                            style={{
                              'pointer-events': 'auto',
                            }}
                            onClick={() => {
                              act('add_to_queue', { track: track.name });
                            }}
                          />
                        </Stack.Item>
                      </Stack>
                    </Tabs.Tab>
                  ))}
                </Tabs>
              ) : (
                <Box textColor="gray" textAlign="center" mt={2}>
                  Треков нет
                </Box>
              )}
            </Section>
            {filteredPages > 1 && (
              <Stack align="center" justify="center">
                <Stack.Item>
                  <Button
                    icon="chevron-left"
                    onClick={() =>
                      setCurrentPage(currentPage - 1 < 1 ? 1 : currentPage - 1)
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  Страница {currentPage}/{filteredPages}
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="chevron-right"
                    onClick={() =>
                      setCurrentPage(
                        currentPage + 1 > filteredPages
                          ? filteredPages
                          : currentPage + 1,
                      )
                    }
                  />
                </Stack.Item>
              </Stack>
            )}
          </Section>
        )}
        {tab === 2 && (
          <Section fluid>
            <Tabs vertical style={{ 'pointer-events': 'none' }}>
              {paginate(queued_tracks, SONGS_PER_PAGE, queuePage).map(
                (song) => (
                  <Tabs.Tab
                    key={song}
                    style={{
                      backgroundColor: 'rgba(255, 255, 255, 0.5)',
                      transition: 'background-color 0.3s ease',
                      marginBottom: '4px',
                      borderRadius: '4px',
                      border: '1px solid rgba(0, 0, 0, 0.1)',
                    }}
                  >
                    {song}
                  </Tabs.Tab>
                ),
              )}
            </Tabs>
            {filteredQueuePages > 1 && (
              <Stack align="center" justify="center">
                <Stack.Item>
                  <Button
                    icon="chevron-left"
                    onClick={() =>
                      setQueuePage(queuePage - 1 < 1 ? 1 : queuePage - 1)
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  Страница {queuePage}/{filteredQueuePages}
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="chevron-right"
                    onClick={() =>
                      setQueuePage(
                        queuePage + 1 > filteredQueuePages
                          ? filteredQueuePages
                          : queuePage + 1,
                      )
                    }
                  />
                </Stack.Item>
              </Stack>
            )}
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};

function paginate(array, page_size, page_number) {
  return array.slice((page_number - 1) * page_size, page_number * page_size);
}
