import { Button, LabeledList, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../../../backend';

type GenitalInfo = {
  genitals: Array<{
    name: string;
    slot: string;
    visibility: number;
    aroused: number;
    can_arouse: boolean;
    always_accessible: boolean;
    is_simple?: boolean;
    active?: boolean;
  }>;
};

const GENITAL_NEVER_SHOW = 1;
const GENITAL_HIDDEN_BY_CLOTHES = 2;
const GENITAL_ALWAYS_SHOW = 3;

const AROUSAL_NONE = 1;
const AROUSAL_PARTIAL = 2;
const AROUSAL_FULL = 3;

type GenitalTabProps = {
  searchText: string;
};

export const GenitalTab = ({ searchText }: GenitalTabProps) => {
  const { act, data } = useBackend<GenitalInfo>();
  const { genitals = [] } = data;

  const filteredGenitals = genitals.filter((genital) =>
    genital.name.toLowerCase().includes(searchText.toLowerCase()),
  );

  return (
    <Section fill>
      <LabeledList>
        {filteredGenitals.map((genital) => (
          <LabeledList.Item
            key={genital.slot}
            label={genital.name}
            buttons={
              <Stack>
                {genital.is_simple ? (
                  <Stack.Item>
                    <Button
                      icon={genital.active ? 'check' : 'times'}
                      color={genital.active ? 'good' : 'bad'}
                      tooltip={genital.active ? 'Active' : 'Inactive'}
                      onClick={() =>
                        act('toggle_genital_active', {
                          genital: genital.name,
                        })
                      }
                    />
                  </Stack.Item>
                ) : (
                  <>
                    <Stack.Item>
                      <Button
                        icon={genital.always_accessible ? 'lock-open' : 'lock'}
                        color={genital.always_accessible ? 'good' : 'default'}
                        tooltip={
                          genital.always_accessible
                            ? 'Always accessible'
                            : 'Normal accessibility'
                        }
                        onClick={() =>
                          act('toggle_genital_accessibility', {
                            genital: genital.slot,
                          })
                        }
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Stack>
                        <Stack.Item>
                          <Button
                            icon="eye"
                            selected={
                              genital.visibility === GENITAL_ALWAYS_SHOW
                            }
                            tooltip="Always show"
                            onClick={() =>
                              act('toggle_genital_visibility', {
                                genital: genital.slot,
                                visibility: GENITAL_ALWAYS_SHOW,
                              })
                            }
                          />
                        </Stack.Item>
                        <Stack.Item>
                          <Button
                            icon="eye-low-vision"
                            selected={
                              genital.visibility === GENITAL_HIDDEN_BY_CLOTHES
                            }
                            tooltip="Show when naked"
                            onClick={() =>
                              act('toggle_genital_visibility', {
                                genital: genital.slot,
                                visibility: GENITAL_HIDDEN_BY_CLOTHES,
                              })
                            }
                          />
                        </Stack.Item>
                        <Stack.Item>
                          <Button
                            icon="eye-slash"
                            selected={genital.visibility === GENITAL_NEVER_SHOW}
                            tooltip="Never show"
                            onClick={() =>
                              act('toggle_genital_visibility', {
                                genital: genital.slot,
                                visibility: GENITAL_NEVER_SHOW,
                              })
                            }
                          />
                        </Stack.Item>
                      </Stack>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon={
                          genital.can_arouse
                            ? genital.aroused === AROUSAL_NONE
                              ? 'heart'
                              : genital.aroused === AROUSAL_PARTIAL
                                ? 'heartbeat'
                                : 'heart-circle-bolt'
                            : 'times'
                        }
                        color={
                          !genital.can_arouse
                            ? 'grey'
                            : genital.aroused === AROUSAL_NONE
                              ? 'red'
                              : genital.aroused === AROUSAL_PARTIAL
                                ? 'good'
                                : 'pink'
                        }
                        tooltip={
                          genital.can_arouse
                            ? genital.aroused === AROUSAL_NONE
                              ? 'Not aroused'
                              : genital.aroused === AROUSAL_PARTIAL
                                ? 'Partially aroused'
                                : 'Fully aroused'
                            : "Can't be aroused"
                        }
                        disabled={!genital.can_arouse}
                        onClick={() => {
                          if (!genital.can_arouse) return;
                          const nextArousal =
                            genital.aroused === AROUSAL_NONE
                              ? AROUSAL_PARTIAL
                              : genital.aroused === AROUSAL_PARTIAL
                                ? AROUSAL_FULL
                                : AROUSAL_NONE;
                          act('toggle_genital_arousal', {
                            genital: genital.slot,
                            arousal: nextArousal,
                          });
                        }}
                      />
                    </Stack.Item>
                  </>
                )}
              </Stack>
            }
          />
        ))}
      </LabeledList>
    </Section>
  );
};
