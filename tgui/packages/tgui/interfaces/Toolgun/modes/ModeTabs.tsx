import { Box, Button, Section, Stack } from 'tgui-core/components';

import type { ToolgunModeEntry } from '../types';

type ModeTabsProps = {
  act: (action: string, payload?: Record<string, unknown>) => void;
  modeName: string;
  modeDesc: string;
  selectedModeKey: string;
  availableModes: ToolgunModeEntry[];
};

export function ModeTabs({
  act,
  modeName,
  modeDesc,
  selectedModeKey,
  availableModes,
}: ModeTabsProps) {
  return (
    <Section title={modeName || 'Toolgun'}>
      <Stack vertical>
        <Stack.Item>
          <Box color="#d2d2d2">{modeDesc}</Box>
        </Stack.Item>
        <Stack.Item mt={1}>
          <Stack>
            {availableModes.map((mode) => (
              <Stack.Item key={mode.mode_key} grow>
                <Button
                  color={
                    selectedModeKey === mode.mode_key ? 'grey' : 'transparent'
                  }
                  onClick={() =>
                    act('select_mode', { mode_key: mode.mode_key })
                  }
                >
                  {mode.name}
                </Button>
              </Stack.Item>
            ))}
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
}
