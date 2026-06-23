import {
  Box,
  Button,
  DmIcon,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';

import type { BuildModeProps } from './modeProps';

export function BuildMode(props: BuildModeProps) {
  const fallback = <Box width="48px" height="48px" />;
  const gridStyle = {
    display: 'grid',
    gridTemplateColumns: 'repeat(5, 1fr)',
    gap: '8px',
  };

  let displayChildNodes = props.currentChildNodes;
  if (props.normalizedSearch) {
    displayChildNodes = props.currentChildNodes.filter(
      (node) =>
        node.name.toLowerCase().includes(props.normalizedSearch) ||
        node.id.toLowerCase().includes(props.normalizedSearch),
    );
  }
  const folderChildNodes = displayChildNodes.filter((node) =>
    Boolean(props.childrenByParent[node.id]?.length),
  );

  return (
    <>
      <Stack.Item>
        <Input
          fluid
          placeholder="Поиск по всем типам и именам турфов..."
          value={props.search}
          onChange={props.onSearchChange}
        />
      </Stack.Item>
      <Stack.Item grow>
        <Stack fill>
          <Stack.Item basis="280px">
            <Section fill scrollable title="Подтипы турфов">
              {props.currentBrowsePath !== '/turf' && (
                <Button
                  fluid
                  icon="arrow-up"
                  mb={1}
                  backgroundColor="transparent"
                  onClick={() => {
                    const lastSlash = props.currentBrowsePath.lastIndexOf('/');
                    const parentPath =
                      lastSlash > 0
                        ? props.currentBrowsePath.slice(0, lastSlash)
                        : '/turf';
                    props.act('browse_to', { path: parentPath });
                  }}
                >
                  .. Назад
                </Button>
              )}
              <Box mb={1}>
                <Button
                  fluid
                  color={
                    props.currentBrowsePath === '/turf' ? 'grey' : 'transparent'
                  }
                  onClick={() => props.act('browse_to', { path: '/turf' })}
                >
                  turf (корень)
                </Button>
              </Box>
              {folderChildNodes.map((node) => (
                <Button
                  key={node.id}
                  fluid
                  mb={0.5}
                  color="transparent"
                  onClick={() => props.act('browse_to', { path: node.id })}
                >
                  {node.name}
                </Button>
              ))}
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Section
              fill
              scrollable
              title="Поверхности"
              buttons={
                <Button
                  icon="paint-brush"
                  onClick={() => props.act('build_here')}
                >
                  Построить здесь
                </Button>
              }
            >
              <Box style={gridStyle}>
                {props.turfs.map((entry) => {
                  const isSelected = props.selectedPath === entry.type;
                  return (
                    <Box key={entry.type}>
                      <Button
                        tooltip={
                          entry.name ||
                          entry.type.split('/').pop() ||
                          entry.type
                        }
                        onDoubleClick={() =>
                          props.act('select_turf', { path: entry.type })
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

              {!props.normalizedSearch && props.hasMore && (
                <Button
                  fluid
                  icon="download"
                  mt={2}
                  onClick={() => props.act('load_more')}
                >
                  Загрузить ещё ({props.visibleCount}/{props.matchCount})
                </Button>
              )}
            </Section>
          </Stack.Item>

          <Stack.Item basis="300px">
            <Section title="Выбранная поверхность" mb={2}>
              {props.selectedEntry ? (
                <Stack vertical>
                  <Stack.Item>
                    <Box fontWeight="bold">{props.selectedEntry.name}</Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Box color="#b0b0b0">{props.selectedEntry.type}</Box>
                  </Stack.Item>
                </Stack>
              ) : (
                <Box color="#aaaaaa">Ничего не выбрано</Box>
              )}
            </Section>

            <Section title="Режим строительства" mb={2}>
              <Stack vertical>
                <Stack.Item>
                  <Button
                    fluid
                    color={
                      props.buildAction === 'brush' ? 'grey' : 'transparent'
                    }
                    onClick={() =>
                      props.act('set_build_action', { build_action: 'brush' })
                    }
                  >
                    Кисть
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    fluid
                    color={
                      props.buildAction === 'fill' ? 'grey' : 'transparent'
                    }
                    onClick={() =>
                      props.act('set_build_action', { build_action: 'fill' })
                    }
                  >
                    Заливка
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    fluid
                    color={
                      props.buildAction === 'wand' ? 'grey' : 'transparent'
                    }
                    onClick={() =>
                      props.act('set_build_action', { build_action: 'wand' })
                    }
                  >
                    Палочка
                  </Button>
                </Stack.Item>
                {props.buildAction === 'wand' && (
                  <Stack.Item>
                    <Input
                      fluid
                      value={String(props.wandRange)}
                      onChange={(value) =>
                        props.act('set_wand_range', { range: value })
                      }
                    />
                  </Stack.Item>
                )}
              </Stack>
            </Section>

            <Section title="Настройки">
              <Stack vertical>
                <Stack.Item>
                  <Button.Checkbox
                    checked={props.useCustomColor}
                    content="Использовать свой цвет"
                    onClick={() => props.act('toggle_use_custom_color')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Input
                    fluid
                    value={props.customColor}
                    onChange={(value) =>
                      props.act('set_custom_color', { color: value })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Checkbox
                    checked={props.customDensity}
                    content="Плотность включена"
                    onClick={() => props.act('toggle_custom_density')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Checkbox
                    checked={props.customOpacity}
                    content="Непрозрачность включена"
                    onClick={() => props.act('toggle_custom_opacity')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Checkbox
                    checked={props.customIndestructible}
                    content="Неразрушимый"
                    onClick={() => props.act('toggle_custom_indestructible')}
                  />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </>
  );
}
