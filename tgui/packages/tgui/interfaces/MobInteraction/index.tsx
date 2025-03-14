import { Stack } from 'tgui-core/components';

import { Window } from '../../layouts';
import { InfoSection } from './InfoSection';
import { MainContent } from './MainContent';

export const MobInteraction = () => {
  return (
    <Window width={500} height={700} title="Mob Interaction">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow basis={15}>
            <InfoSection />
          </Stack.Item>
          <Stack.Item grow basis={30}>
            <MainContent />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
