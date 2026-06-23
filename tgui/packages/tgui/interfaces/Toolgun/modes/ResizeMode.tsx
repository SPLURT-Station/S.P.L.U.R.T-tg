import { Box, Button, Input, Section, Stack } from 'tgui-core/components';

import type { ResizeModeProps } from './modeProps';

export function ResizeMode({ act, scaleValue }: ResizeModeProps) {
  return (
    <Stack.Item grow>
      <Section fill title="Настройки размера">
        <Stack vertical>
          <Stack.Item>
            <Input
              fluid
              value={String(scaleValue)}
              onChange={(value) => act('set_scale', { scale: value })}
            />
          </Stack.Item>
          <Stack.Item>
            <Box color="#d2d2d2" fontSize="0.9em">
              ЛКМ: изменить размер на ×{scaleValue} • ПКМ: сбросить масштаб
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack.Item grow>
                <Button fluid onClick={() => act('set_scale', { scale: 0.5 })}>
                  0.5×
                </Button>
              </Stack.Item>
              <Stack.Item grow>
                <Button fluid onClick={() => act('set_scale', { scale: 1 })}>
                  1×
                </Button>
              </Stack.Item>
              <Stack.Item grow>
                <Button fluid onClick={() => act('set_scale', { scale: 2 })}>
                  2×
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Section>
    </Stack.Item>
  );
}
