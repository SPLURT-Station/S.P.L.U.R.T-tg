import { useState } from 'react';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type BodyMorpherData = {
  action_name: string;
  owner_name: string;
  preset_limit: number;
  presets: BodyMorpherPreset[];
};

type BodyMorpherPreset = {
  id: string;
  name: string;
  is_base: boolean;
  gender: string;
  body_size: number;
  mutant_part_count: number;
};

const actions = [
  {
    id: 'alter_colours',
    title: 'Body Colours',
    description: 'Adjust primary, secondary, and tertiary body colours.',
    icon: 'palette',
  },
  {
    id: 'alter_dna',
    title: 'DNA',
    description: 'Change size, gender, genitals, and mutant parts.',
    icon: 'dna',
  },
  {
    id: 'alter_hair',
    title: 'Hair',
    description: 'Edit hairstyle, facial hair, and hair colours.',
    icon: 'cut',
  },
  {
    id: 'alter_markings',
    title: 'Markings',
    description: 'Swap to a different body marking set.',
    icon: 'paint-roller',
  },
];

export const BodyMorpher = (_props: unknown) => {
  const { data, act } = useBackend<BodyMorpherData>();
  const [tab, setTab] = useState<'actions' | 'presets'>('actions');
  const { action_name, owner_name, preset_limit = 20, presets = [] } = data;

  return (
    <Window title={action_name || 'Body Morpher'} width={560} height={480}>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab
            selected={tab === 'actions'}
            onClick={() => setTab('actions')}
          >
            Actions
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === 'presets'}
            onClick={() => setTab('presets')}
          >
            Presets
          </Tabs.Tab>
        </Tabs>

        {tab === 'actions' ? (
          <ActionsTab ownerName={owner_name} act={act} />
        ) : (
          <PresetsTab presets={presets} presetLimit={preset_limit} act={act} />
        )}
      </Window.Content>
    </Window>
  );
};

type ActionsTabProps = {
  ownerName: string;
  act: (action: string, payload?: Record<string, unknown>) => void;
};

const ActionsTab = ({ ownerName, act }: ActionsTabProps) => {
  return (
    <Stack vertical>
      <Stack.Item>
        <NoticeBox>
          Alter {ownerName || 'your character'} using the standard bodymorpher
          options. Presets capture the result of these changes for quick reuse.
        </NoticeBox>
      </Stack.Item>
      {actions.map((action) => (
        <Stack.Item key={action.id}>
          <Section
            title={action.title}
            buttons={
              <Button
                icon={action.icon}
                content="Open"
                onClick={() => act(action.id)}
              />
            }
          >
            <Box>{action.description}</Box>
          </Section>
        </Stack.Item>
      ))}
    </Stack>
  );
};

type PresetsTabProps = {
  presets: BodyMorpherPreset[];
  presetLimit: number;
  act: (action: string, payload?: Record<string, unknown>) => void;
};

const PresetsTab = ({ presets, presetLimit, act }: PresetsTabProps) => {
  const customPresetCount = presets.filter((preset) => !preset.is_base).length;
  const atLimit = customPresetCount >= presetLimit;

  return (
    <Section
      title={`Saved Forms (${customPresetCount}/${presetLimit})`}
      buttons={
        <Button
          icon="save"
          content="Save Current Form"
          disabled={atLimit}
          onClick={() => act('save_preset')}
        />
      }
    >
      <NoticeBox>
        You can save up to {presetLimit} custom presets. The roundstart Base
        Character preset does not count toward this limit.
      </NoticeBox>
      {!presets.length ? (
        <NoticeBox>No bodymorph presets saved yet.</NoticeBox>
      ) : (
        <Stack vertical>
          {presets.map((preset) => (
            <Stack.Item key={preset.id}>
              <Section
                title={
                  <Box inline>
                    {preset.name}
                    {preset.is_base ? (
                      <Box inline ml={1} color="label">
                        (Roundstart)
                      </Box>
                    ) : null}
                  </Box>
                }
                buttons={
                  <>
                    <Button
                      icon="sign-in-alt"
                      content="Load"
                      onClick={() => act('load_preset', { preset: preset.id })}
                    />
                    {!preset.is_base ? (
                      <Button
                        icon="trash"
                        color="bad"
                        content="Delete"
                        onClick={() =>
                          act('delete_preset', { preset: preset.id })
                        }
                      />
                    ) : null}
                  </>
                }
              >
                <LabeledList>
                  <LabeledList.Item label="Gender">
                    {preset.gender}
                  </LabeledList.Item>
                  <LabeledList.Item label="Body Size">
                    {preset.body_size}%
                  </LabeledList.Item>
                  <LabeledList.Item label="Mutant Parts">
                    {preset.mutant_part_count}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            </Stack.Item>
          ))}
        </Stack>
      )}
    </Section>
  );
};
