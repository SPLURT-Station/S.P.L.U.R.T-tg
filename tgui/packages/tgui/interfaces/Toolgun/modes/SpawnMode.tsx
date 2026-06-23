import {
  Box,
  Button,
  DmIcon,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';

import type { SpawnModeProps } from './modeProps';

export function SpawnMode(props: SpawnModeProps) {
  const {
    act,
    modeKey,
    search,
    normalizedSearch,
    hasMore,
    visibleCount,
    matchCount,
    selectedEntry,
    selectedPath,
    visibleObjects,
    currentBrowsePath,
    childrenByParent,
    currentChildNodes,
    useCustomColor,
    customColor,
    customDensity,
    customOpacity,
    customIndestructible,
    onSearchChange,
  } = props;

  const isMobMode = modeKey === 'mobs';
  const rootPath = isMobMode ? '/mob' : '/obj';
  const rootTitle = isMobMode ? 'mob (корень)' : 'obj (корень)';
  const sectionTitle = isMobMode ? 'Мобы' : 'Объекты';

  const fallback = <Box width="48px" height="48px" />;
  const gridStyle = {
    display: 'grid',
    gridTemplateColumns: 'repeat(5, 1fr)',
    gap: '8px',
  };

  let displayChildNodes = currentChildNodes;
  if (normalizedSearch) {
    displayChildNodes = currentChildNodes.filter(
      (node) =>
        node.name.toLowerCase().includes(normalizedSearch) ||
        node.id.toLowerCase().includes(normalizedSearch),
    );
  }
  const folderChildNodes = displayChildNodes.filter((node) =>
    Boolean(childrenByParent[node.id]?.length),
  );

  return (
    <>
      <Stack.Item>
        <Input
          fluid
          placeholder={
            isMobMode
              ? 'Поиск по всем типам и именам мобов...'
              : 'Поиск по всем типам и именам...'
          }
          value={search}
          onChange={onSearchChange}
        />
      </Stack.Item>
      <Stack.Item grow>
        <Stack fill>
          <Stack.Item basis="280px">
            <Section
              fill
              scrollable
              title={isMobMode ? 'Подтипы мобов' : 'Подтипы объектов'}
            >
              {currentBrowsePath !== rootPath && (
                <Button
                  fluid
                  icon="arrow-up"
                  mb={1}
                  backgroundColor="transparent"
                  onClick={() => {
                    const lastSlash = currentBrowsePath.lastIndexOf('/');
                    const parentPath =
                      lastSlash > 0
                        ? currentBrowsePath.slice(0, lastSlash)
                        : rootPath;
                    act('browse_to', { path: parentPath });
                  }}
                >
                  .. Назад
                </Button>
              )}
              <Box mb={1}>
                <Button
                  fluid
                  color={
                    currentBrowsePath === rootPath ? 'grey' : 'transparent'
                  }
                  onClick={() => act('browse_to', { path: rootPath })}
                >
                  {rootTitle}
                </Button>
              </Box>
              {folderChildNodes.map((node) => (
                <Button
                  key={node.id}
                  fluid
                  mb={0.5}
                  color="transparent"
                  onClick={() => act('browse_to', { path: node.id })}
                >
                  {node.name}
                </Button>
              ))}
              {folderChildNodes.length === 0 && (
                <Box color="#888888" textAlign="center" py={4}>
                  {normalizedSearch
                    ? 'Подтипы не обнаружены'
                    : 'У этого типа нет подтипов'}
                </Box>
              )}
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Section
              fill
              scrollable
              title={sectionTitle}
              buttons={
                <Button icon="plus" onClick={() => act('spawn_here')}>
                  Заспавнить здесь
                </Button>
              }
            >
              <Box style={gridStyle}>
                {visibleObjects.map((entry) => {
                  const isSelected = selectedPath === entry.type;
                  return (
                    <Box key={entry.type}>
                      <Button
                        tooltip={
                          entry.name ||
                          entry.type.split('/').pop() ||
                          entry.type
                        }
                        onDoubleClick={() =>
                          props.act('select_type', { path: entry.type })
                        }
                        backgroundColor={isSelected ? '#666666' : '#444444'}
                      >
                        <DmIcon
                          icon={entry.icon}
                          icon_state={entry.icon_state}
                          width="64px"
                          fallback={fallback}
                          backgroundColor={isSelected ? '#666666' : '#444444'}
                        />
                      </Button>
                    </Box>
                  );
                })}
              </Box>
              {(!normalizedSearch && hasMore && (
                <Button
                  fluid
                  icon="download"
                  mt={2}
                  onClick={() => act('load_more')}
                >
                  Загрузить ещё ({visibleCount}/{matchCount})
                </Button>
              )) ||
                ''}
            </Section>
          </Stack.Item>

          <Stack.Item basis="300px">
            <Section
              title={isMobMode ? 'Выбранный моб' : 'Выбранный объект'}
              mb={2}
            >
              {selectedEntry ? (
                <Stack vertical>
                  <DmIcon
                    position="center"
                    icon={selectedEntry.icon}
                    icon_state={selectedEntry.icon_state}
                    align="center"
                    width="128px"
                    fallback={fallback}
                  />
                  <Stack.Item>
                    <Box fontWeight="bold">
                      {selectedEntry.name ||
                        selectedEntry.type.split('/').pop() ||
                        selectedEntry.type}
                    </Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Box color="#b0b0b0" style={{ wordBreak: 'break-all' }}>
                      {selectedEntry.type}
                    </Box>
                  </Stack.Item>
                </Stack>
              ) : (
                <Box color="#aaaaaa">Ничего не выбрано</Box>
              )}
            </Section>

            <Section title="Настройки спавна" mb={2}>
              <Stack scrollable vertical>
                <Stack.Item>
                  <Button.Checkbox
                    checked={useCustomColor}
                    content="Использовать свой цвет"
                    onClick={() => act('toggle_use_custom_color')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Stack>
                    <Stack.Item grow>
                      <Input
                        fluid
                        value={customColor}
                        onChange={(value) =>
                          act('set_custom_color', { color: value })
                        }
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="palette"
                        onClick={() => act('pick_custom_color')}
                      >
                        Выбрать
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Button.Checkbox
                    checked={customDensity}
                    content="Плотность включена"
                    onClick={() => act('toggle_custom_density')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Checkbox
                    checked={customOpacity}
                    content="Непрозрачность включена"
                    onClick={() => act('toggle_custom_opacity')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Checkbox
                    checked={customIndestructible}
                    content="Неразрушимый"
                    onClick={() => act('toggle_custom_indestructible')}
                  />
                </Stack.Item>
              </Stack>
            </Section>

            {isMobMode && <MobExtraSettings {...props} />}
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </>
  );
}

function MobExtraSettings(props: SpawnModeProps) {
  const { act } = props;
  return (
    <Section title="Параметры моба">
      <Stack scrollable vertical>
        <Stack.Item>
          <Box color="#d2d2d2">AI контроллер (typepath)</Box>
          <Input
            fluid
            value={props.mob_ai_controller || ''}
            onChange={(value) => act('set_mob_ai_controller', { value })}
          />
        </Stack.Item>
        <Stack.Item>
          <Box color="#d2d2d2">Health / MaxHealth</Box>
          <Stack>
            <Stack.Item grow>
              <Input
                fluid
                value={String(props.mob_health ?? 100)}
                onChange={(value) => act('set_mob_health', { value })}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Input
                fluid
                value={String(props.mob_max_health ?? 100)}
                onChange={(value) => act('set_mob_max_health', { value })}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Box color="#d2d2d2">Body temperature (K)</Box>
          <Input
            fluid
            value={String(props.mob_bodytemperature ?? 310.15)}
            onChange={(value) => act('set_mob_bodytemperature', { value })}
          />
        </Stack.Item>
        <Stack.Item>
          <Box color="#d2d2d2">Comfort min / max temperature (K)</Box>
          <Stack>
            <Stack.Item grow>
              <Input
                fluid
                value={String(props.mob_min_temperature ?? 260)}
                onChange={(value) => act('set_mob_min_temperature', { value })}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Input
                fluid
                value={String(props.mob_max_temperature ?? 360)}
                onChange={(value) => act('set_mob_max_temperature', { value })}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Button.Checkbox
            checked={Boolean(props.mob_need_atmosphere)}
            content="Нуждается в атмосфере"
            onClick={() => act('toggle_mob_need_atmosphere')}
          />
        </Stack.Item>
        <Stack.Item>
          <Box color="#d2d2d2">Урон от неподходящей атмосферы</Box>
          <Input
            fluid
            value={String(props.mob_unsuitable_atmos_damage ?? 1)}
            onChange={(value) =>
              act('set_mob_unsuitable_atmos_damage', { value })
            }
          />
        </Stack.Item>
        <Stack.Item>
          <Box color="#d2d2d2">Melee damage min / max</Box>
          <Stack>
            <Stack.Item grow>
              <Input
                fluid
                value={String(props.mob_melee_damage_lower ?? 0)}
                onChange={(value) =>
                  act('set_mob_melee_damage_lower', { value })
                }
              />
            </Stack.Item>
            <Stack.Item grow>
              <Input
                fluid
                value={String(props.mob_melee_damage_upper ?? 0)}
                onChange={(value) =>
                  act('set_mob_melee_damage_upper', { value })
                }
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
}
