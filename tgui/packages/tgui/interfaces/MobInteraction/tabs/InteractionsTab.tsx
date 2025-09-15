import { useState } from 'react';
import { createPortal } from 'react-dom';
import {
  Box,
  Button,
  Collapsible,
  Icon,
  Modal,
  NoticeBox,
  Section,
  Slider,
  Stack,
  Tooltip,
} from 'tgui-core/components';

import { useBackend } from '../../../backend';

type AutoInteractionInfo = {
  speed: number;
  target: string;
  target_name: string;
  next_interaction: number;
};

type InteractionsInfo = {
  categories: string[];
  interactions: Record<string, string[]>;
  descriptions: Record<string, string>;
  colors: Record<string, string>;
  block_interact: boolean;
  favorite_interactions: string[];
  ref_user: string;
  ref_self: string;
  self: string;
  additional_details: Record<
    string,
    { info: string; icon: string; color: string }[]
  >;
  auto_interaction_info: Record<string, AutoInteractionInfo>;
  auto_interaction_speed_values: number[];
};

type InteractionsTabProps = {
  searchText: string;
  inFavorites: boolean;
  showCategories: boolean;
};

type AutoInteractionModalProps = {
  interaction: string;
  ref_self: string;
  onClose: () => void;
};

const AutoInteractionModal = ({
  interaction,
  ref_self,
  onClose,
}: AutoInteractionModalProps) => {
  const { act, data } = useBackend<InteractionsInfo>();
  const { auto_interaction_info, auto_interaction_speed_values } = data;
  const isActive = !!auto_interaction_info[`${interaction}_target_${ref_self}`];

  return (
    <Modal width="400px">
      <Section
        title={`Auto Interaction: ${interaction}`}
        buttons={<Button color="red" icon="window-close" onClick={onClose} />}
      >
        <Stack vertical fill>
          {isActive && (
            <Stack.Item>
              <Box>
                Interacting with:{' '}
                {auto_interaction_info[`${interaction}_target_${ref_self}`]
                  ?.target_name || 'No one'}
              </Box>
            </Stack.Item>
          )}
          <Stack.Item>
            <Box>
              Speed:{' '}
              {auto_interaction_info[`${interaction}_target_${ref_self}`]
                ?.speed || 'Stopped'}
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Slider
              minValue={auto_interaction_speed_values[0]}
              maxValue={auto_interaction_speed_values[1]}
              value={
                auto_interaction_info[`${interaction}_target_${ref_self}`]
                  ?.speed || auto_interaction_speed_values[1]
              }
              onChange={(e, value) => {
                if (
                  auto_interaction_info[`${interaction}_target_${ref_self}`]
                ) {
                  act('auto_interaction', {
                    interaction_text: `${interaction}_target_${ref_self}`,
                    speed: value,
                    selfref: ref_self,
                  });
                }
              }}
            />
          </Stack.Item>
          <Stack.Item>
            <Stack fill>
              {auto_interaction_info[`${interaction}_target_${ref_self}`] ? (
                <Stack.Item grow>
                  <Button
                    fluid
                    color="red"
                    icon="stop"
                    onClick={() => {
                      act('auto_interaction', {
                        interaction_text: `${interaction}_target_${ref_self}`,
                        action: 'stop',
                      });
                    }}
                  >
                    Stop
                  </Button>
                </Stack.Item>
              ) : (
                <Stack.Item grow>
                  <Button
                    fluid
                    color="green"
                    icon="play"
                    onClick={() => {
                      act('auto_interaction', {
                        interaction_text: `${interaction}_target_${ref_self}`,
                        speed: auto_interaction_speed_values[1],
                        selfref: ref_self,
                      });
                    }}
                  >
                    Play
                  </Button>
                </Stack.Item>
              )}
            </Stack>
          </Stack.Item>
        </Stack>
      </Section>
    </Modal>
  );
};

export const InteractionsTab = ({
  searchText,
  inFavorites,
  showCategories,
}: InteractionsTabProps) => {
  const { act, data } = useBackend<InteractionsInfo>();
  const [autoInteractionModalOpen, setAutoInteractionModalOpen] = useState<
    string | null
  >(null);

  const {
    categories = [],
    interactions,
    descriptions,
    colors,
    block_interact,
    favorite_interactions = [],
    ref_user,
    ref_self,
    self,
    additional_details,
    auto_interaction_info,
    auto_interaction_speed_values,
  } = data;

  // Filter interactions based on search text and favorites
  const filterInteractions = (category: string) => {
    let categoryInteractions = interactions[category] || [];
    if (searchText) {
      categoryInteractions = categoryInteractions.filter((interaction) =>
        interaction.toLowerCase().includes(searchText.toLowerCase()),
      );
    }
    if (inFavorites) {
      categoryInteractions = categoryInteractions.filter((interaction) =>
        favorite_interactions.includes(interaction),
      );
    }
    return categoryInteractions;
  };

  // Get all interactions in a flat list
  const getAllInteractions = () => {
    let allInteractions: Array<{
      name: string;
      category: string;
    }> = [];
    categories.forEach((category) => {
      const categoryInteractions = filterInteractions(category);
      allInteractions = allInteractions.concat(
        categoryInteractions.map((interaction) => ({
          name: interaction,
          category: category,
        })),
      );
    });
    return allInteractions;
  };

  // Render an individual interaction button
  const renderInteractionButton = (interaction: string) => {
    const hasAutoInteraction =
      !!auto_interaction_info[`${interaction}_target_${ref_self}`];

    return (
      <Stack fill>
        <Stack.Item grow>
          <Button
            fluid
            color={block_interact ? 'grey' : colors[interaction]}
            tooltip={descriptions[interaction]}
            disabled={block_interact}
            onClick={() =>
              act('interact', {
                interaction: interaction,
                selfref: ref_self,
                userref: ref_user,
              })
            }
          >
            {interaction}
            <Box textAlign="right" fillPositionedParent>
              {additional_details[interaction]?.map(
                (detail: { info: string; icon: string; color: string }) => (
                  <Tooltip content={detail.info} key={detail.info}>
                    <Box mx={0.5} as="span">
                      <Icon name={detail.icon} />
                    </Box>
                  </Tooltip>
                ),
              )}
            </Box>
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon={
              favorite_interactions.includes(interaction) ? 'star' : 'star-o'
            }
            color={
              favorite_interactions.includes(interaction) ? 'yellow' : 'default'
            }
            tooltip={`${
              favorite_interactions.includes(interaction)
                ? 'Remove from'
                : 'Add to'
            } favorites`}
            onClick={() =>
              act('favorite', {
                interaction: interaction,
              })
            }
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon={hasAutoInteraction ? 'play' : 'stop'}
            color={hasAutoInteraction ? 'green' : 'red'}
            tooltip="Auto Interaction"
            onClick={() => setAutoInteractionModalOpen(interaction)}
          />
        </Stack.Item>
      </Stack>
    );
  };

  return (
    <Stack vertical fill>
      <Stack.Item>
        <NoticeBox>
          <Stack>
            <Stack.Item grow>
              {block_interact ? 'Unable to Interact' : 'Able to Interact'}
            </Stack.Item>
            {Object.keys(auto_interaction_info).length > 0 && (
              <Stack.Item>
                <Button
                  color="red"
                  icon="stop"
                  tooltip="Stop all auto interactions"
                  onClick={() => {
                    // Stop all active auto interactions
                    Object.keys(auto_interaction_info).forEach(
                      (interaction_text) => {
                        act('auto_interaction', {
                          interaction_text: interaction_text,
                          action: 'stop',
                        });
                      },
                    );
                  }}
                >
                  Stop all auto interactions
                </Button>
              </Stack.Item>
            )}
          </Stack>
        </NoticeBox>
      </Stack.Item>
      <Stack.Item grow>
        {showCategories ? (
          // Categorized view
          categories.map((category) => {
            const filteredInteractions = filterInteractions(category);
            if (filteredInteractions.length === 0) {
              return null;
            }
            return (
              <Collapsible
                key={category}
                title={category}
                buttons={
                  <Box inline color="grey" fontSize={0.9}>
                    {filteredInteractions.length}
                    {' interactions'}
                  </Box>
                }
              >
                <Section fill>
                  <Stack vertical>
                    {filteredInteractions.map((interaction) => (
                      <Stack.Item key={interaction}>
                        {renderInteractionButton(interaction)}
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Collapsible>
            );
          })
        ) : (
          // Flat list view
          <Section fill>
            <Stack vertical>
              {getAllInteractions().map(({ name, category }) => (
                <Stack.Item key={name}>
                  {renderInteractionButton(name)}
                </Stack.Item>
              ))}
            </Stack>
          </Section>
        )}
      </Stack.Item>
      {autoInteractionModalOpen &&
        createPortal(
          <AutoInteractionModal
            interaction={autoInteractionModalOpen}
            ref_self={ref_self}
            onClose={() => setAutoInteractionModalOpen(null)}
          />,
          document.body,
        )}
    </Stack>
  );
};
