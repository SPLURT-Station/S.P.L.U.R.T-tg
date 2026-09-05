import { Box, Button, Input, Section, Stack } from 'tgui-core/components';

import type { ColorModeProps } from './modeProps';

export function ColorMode({ act, selectedColor }: ColorModeProps) {
  return (
    <Stack.Item grow>
      <Section
        fill
        title="Color Settings"
        buttons={
          <Button icon="palette" onClick={() => act('pick_color')}>
            Pick Color
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
              Current color: {selectedColor}
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Box color="#d2d2d2" fontSize="0.9em">
              LMB: apply color to object • RMB: reset object color
            </Box>
          </Stack.Item>
        </Stack>
      </Section>
    </Stack.Item>
  );
}
