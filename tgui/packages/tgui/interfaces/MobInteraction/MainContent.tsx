import { useLocalState } from '../../backend';
import { Icon, Input, Section, Tabs, Stack } from '../../components';

import {
  InteractionsTab,
  GenitalTab,
  CharacterPrefsTab,
  ContentPreferencesTab,
} from './tabs';

export const MainContent = (props, context) => {
  const [
    searchText,
    setSearchText,
  ] = useLocalState(context, 'searchText', '');
  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);
  return (
    <Section fill>
      <Stack vertical fill>
        <Stack.Item>
          <Tabs fluid textAlign="center">
            <Tabs.Tab selected={tabIndex === 0} onClick={() => setTabIndex(0)}>
              Interactions
            </Tabs.Tab>
            <Tabs.Tab selected={tabIndex === 1} onClick={() => setTabIndex(1)}>
              Genital Options
            </Tabs.Tab>
            <Tabs.Tab selected={tabIndex === 2} onClick={() => setTabIndex(2)}>
              Character Prefs
            </Tabs.Tab>
            <Tabs.Tab selected={tabIndex === 3} onClick={() => setTabIndex(3)}>
              Preferences
            </Tabs.Tab>
          </Tabs>
        </Stack.Item>
        <Stack.Item>
          <Stack align="baseline" fill>
            <Stack.Item>
              <Icon name="search" />
            </Stack.Item>
            <Stack.Item grow>
              <Input
                fluid
                placeholder={
                  tabIndex === 0 ? "Search for an interaction"
                    : tabIndex === 1 ? "Search for a genital"
                      : "Searching is unavailable for this tab"
                }
                onInput={(e, value) => setSearchText(value)}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow basis={0} mb={-2.3}>
          <Section overflow="auto" fill>
            {(() => {
              switch (tabIndex) {
                default:
                  return <InteractionsTab />;
                case 1:
                  return <GenitalTab />;
                case 2:
                  return <CharacterPrefsTab />;
                case 3:
                  return <ContentPreferencesTab />;
              }
            })()}
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
