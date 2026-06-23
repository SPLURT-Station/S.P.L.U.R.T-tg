import { Box, Button, Input, Section, Stack } from 'tgui-core/components';

import type { ColorModeProps } from './modeProps';

export function ColorMode({ act, selectedColor }: ColorModeProps) {
  return (
    <Stack.Item grow>
      <Section
        fill
        title="Настройки цвета"
        buttons={
          <Button icon="palette" onClick={() => act('pick_color')}>
            Выбрать цвет
          </Button>
        }
      >
        <Stack vertical>
          <Stack.Item>
            <Input
              fluid
              value={selectedColor}
              onChange={(value) => act('set_color', { color: value })}
            />
          </Stack.Item>
          <Stack.Item>
            <Box color={selectedColor} fontSize="1.1em">
              Текущий цвет: {selectedColor}
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Box color="#d2d2d2" fontSize="0.9em">
              ЛКМ: применить цвет к объекту • ПКМ: сбросить цвет объекта
            </Box>
          </Stack.Item>
        </Stack>
      </Section>
    </Stack.Item>
  );
}
