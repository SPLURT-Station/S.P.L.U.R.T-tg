import {
  Box,
  Button,
  Collapsible,
  Icon,
  NoticeBox,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';

import { useBackend } from '../../../backend';

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
};

type InteractionsTabProps = {
  searchText: string;
  inFavorites: boolean;
  showCategories: boolean;
};

export const InteractionsTab = ({
  searchText,
  inFavorites,
  showCategories,
}: InteractionsTabProps) => {
  const { act, data } = useBackend<InteractionsInfo>();
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
  const renderInteractionButton = (interaction: string) => (
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
                  <Icon name={detail.icon} />
                </Tooltip>
              ),
            )}
          </Box>
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          icon={favorite_interactions.includes(interaction) ? 'star' : 'star-o'}
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
    </Stack>
  );

  return (
    <Stack vertical fill>
      <Stack.Item>
        <NoticeBox>
          {block_interact ? 'Unable to Interact' : 'Able to Interact'}
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
    </Stack>
  );
};
