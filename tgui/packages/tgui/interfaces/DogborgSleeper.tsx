import {
  Box,
  Button,
  DmIcon,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

const damageTypes = [
  {
    label: 'Brute',
    type: 'bruteLoss',
  },
  {
    label: 'Burn',
    type: 'fireLoss',
  },
  {
    label: 'Toxin',
    type: 'toxLoss',
  },
  {
    label: 'Oxygen',
    type: 'oxyLoss',
  },
];

export const DogborgSleeper = (props, context) => {
  const { act, data } = useBackend<{
    occupant?: any;
    occupied: boolean;
    cleaning: boolean;
    items: string;
    medical_scanner: boolean;
    chems?: Array<{ name: string; id: string }>;
    max_items: number | null;
    stuffed_at: number | null;
    item_count: number;
    held: Array<{
      name: string;
      icon: string;
      icon_state: string;
      amount?: number;
      kept: boolean;
    }>;
  }>();
  const {
    occupant = {},
    occupied,
    cleaning,
    items,
    medical_scanner,
    max_items,
    stuffed_at,
    item_count,
    held = [],
  } = data;

  const preSortChems = data.chems || [];
  const chems = preSortChems.sort((a, b) => {
    const descA = a.name.toLowerCase();
    const descB = b.name.toLowerCase();
    if (descA < descB) {
      return -1;
    }
    if (descA > descB) {
      return 1;
    }
    return 0;
  });

  return (
    <Window width={375} height={560}>
      <Window.Content scrollable>
        <Section
          title={occupant.name ? occupant.name : 'No Occupant'}
          minHeight="210px"
          buttons={
            !!occupant.stat && (
              <Box inline bold color={occupant.statstate}>
                {occupant.stat}
              </Box>
            )
          }
        >
          {!!cleaning && <NoticeBox>{items}</NoticeBox>}
          {!!occupied && (
            <>
              <ProgressBar
                value={occupant.health}
                minValue={occupant.minHealth}
                maxValue={occupant.maxHealth}
                ranges={{
                  good: [50, Infinity],
                  average: [0, 50],
                  bad: [-Infinity, 0],
                }}
              />
              <Box mt={1} />
              {!!medical_scanner && (
                <LabeledList>
                  {damageTypes.map((type) => (
                    <LabeledList.Item
                      key={type.type}
                      label={
                        occupant.is_robotic_organism && type.label === 'Toxin'
                          ? 'Corruption'
                          : type.label
                      }
                    >
                      <ProgressBar
                        value={occupant[type.type]}
                        minValue={0}
                        maxValue={occupant.maxHealth}
                        color="bad"
                      />
                    </LabeledList.Item>
                  ))}
                  <LabeledList.Item
                    label="Cells"
                    color={occupant.cloneLoss ? 'bad' : 'good'}
                  >
                    {occupant.cloneLoss ? 'Damaged' : 'Healthy'}
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Brain"
                    color={occupant.brainLoss ? 'bad' : 'good'}
                  >
                    {occupant.brainLoss ? 'Abnormal' : 'Healthy'}
                  </LabeledList.Item>
                </LabeledList>
              )}
            </>
          )}
        </Section>
        {typeof max_items === 'number' && (
          <Section
            title="Contents"
            buttons={
              <Box inline>
                {item_count} / {max_items}
              </Box>
            }
          >
            <ProgressBar
              value={item_count}
              minValue={0}
              maxValue={max_items}
              ranges={{
                good: [0, (stuffed_at ?? max_items) - 1],
                average: [stuffed_at ?? max_items, max_items - 1],
                bad: [max_items, Infinity],
              }}
            />
            <Box mt={1} />
            {held.length === 0 && <Box color="label">Empty.</Box>}
            {held.map((entry, index) => (
              <Stack
                key={`${entry.name}-${entry.icon_state}-${index}`}
                align="center"
                mb={0.5}
              >
                <Stack.Item>
                  <DmIcon
                    icon={entry.icon}
                    icon_state={entry.icon_state}
                    height="32px"
                    width="32px"
                    fallback={<Box width="32px" height="32px" />}
                  />
                </Stack.Item>
                <Stack.Item grow>
                  {entry.name}
                  {typeof entry.amount === 'number' ? ` x${entry.amount}` : ''}
                  {entry.kept ? ' (kept)' : ''}
                </Stack.Item>
              </Stack>
            ))}
          </Section>
        )}
        <Section
          title="Operations"
          minHeight="205px"
          buttons={
            <>
              {
                <Button
                  icon={'sign-out-alt'}
                  content={'Eject Contents'}
                  onClick={() => act('eject')}
                />
              }
              {
                <Button
                  icon={cleaning ? 'exclamation-triangle' : 'recycle'}
                  content={'Self-Clean Cycle'}
                  disabled={cleaning}
                  onClick={() => act('cleaning')}
                />
              }
              {
                <Button
                  icon="stop"
                  content="Stop Recycle"
                  disabled={!cleaning}
                  onClick={() => act('stop_cleaning')}
                />
              }
            </>
          }
        >
          {chems.map((chem) => (
            <Button
              key={chem.name}
              icon="flask"
              content={chem.name}
              disabled={!occupied}
              width="140px"
              onClick={() =>
                act('inject', {
                  chem: chem.id,
                })
              }
            />
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
