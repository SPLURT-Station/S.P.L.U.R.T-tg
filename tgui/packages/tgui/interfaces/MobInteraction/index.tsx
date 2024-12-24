import { Stack } from '../../components';
import { Window } from '../../layouts';

import { InfoSection } from './InfoSection';
import { MainContent } from './MainContent';

export const MobInteraction = () => {
  return (
    <Window
      width={430}
      height={700}
      resizable>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow basis={0}>
            <InfoSection />
          </Stack.Item>
          <Stack.Item grow basis={"40%"}>
            <MainContent />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
