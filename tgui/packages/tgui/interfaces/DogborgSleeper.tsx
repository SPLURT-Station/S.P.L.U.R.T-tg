import { Fragment } from 'react';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
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
  }>();
  const { occupant = {}, occupied, cleaning, items, medical_scanner } = data;
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
    <Window width={375} height={465}>
      <Window.Content>
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
