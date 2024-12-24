import { filter, map, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { createSearch } from 'common/string';
import { useBackend, useLocalState } from '../../../backend';
import { Button, Icon, Section, Stack, Tooltip } from '../../../components';
import { Box } from '../../../components';

type ContentInfo = {
  interactions: InteractionData[];
  user_is_blacklisted: boolean;
  target_is_blacklisted: boolean;
}

type InteractionData = {
  key: string;
  desc: string;
  type: number;
  additionalDetails: string[];
}

const INTERACTION_NORMAL = 0;
const INTERACTION_LEWD = 1;
const INTERACTION_EXTREME = 2;

const INTERACTION_FLAG_ADJACENT = (1<<0);
const INTERACTION_FLAG_EXTREME_CONTENT = (1<<1);
const INTERACTION_FLAG_OOC_CONSENT = (1<<2);
const INTERACTION_FLAG_TARGET_NOT_TIRED = (1<<3);
const INTERACTION_FLAG_USER_IS_TARGET = (1<<4);
const INTERACTION_FLAG_USER_NOT_TIRED = (1<<5);

export const InteractionsTab = (props, context) => {
  const { act, data } = useBackend<ContentInfo>(context);
  const [
    searchText,
    setSearchText,
  ] = useLocalState(context, 'searchText', '');
  const interactions = sortInteractions(
    data.interactions,
    searchText,
    data)
    || [];
  const { user_is_blacklisted, target_is_blacklisted } = data;
  return (
    <Stack vertical>
      {
        interactions.length ? (
          interactions.map((interaction) => (
            <Stack.Item key={interaction.key}>
              <Button
                key={interaction.key}
                content={interaction.desc}
                color={interaction.type === INTERACTION_EXTREME ? "red"
                  : interaction.type ? "pink"
                    : "default"}
                fluid
                mb={-0.7}
                onClick={() => act('interact', {
                  interaction: interaction.key,
                })}>
                <Box textAlign="right" fillPositionedParent>
                  {interaction.additionalDetails && (
                    interaction.additionalDetails.map(detail => (
                      <Tooltip content={detail.info} key={detail}>
                        <Icon name={detail.icon} key={detail} />
                      </Tooltip>
                    )))}
                </Box>
              </Button>
            </Stack.Item>
          ))
        ) : (
          <Section align="center">
            {
              user_is_blacklisted || target_is_blacklisted
                ? `${user_is_blacklisted ? "Your" : "Their"} mob type is blacklisted from interactions`
                : searchText ? "No matching results."
                  : "No interactions available."
            }
          </Section>
        )
      }
    </Stack>
  );
};

/**
 * Interaction sorter! also search box
 */
export const sortInteractions = (interactions, searchText = '', data) => {
  const testSearch = createSearch<InteractionData>(searchText,
    interaction => interaction.desc);
  const {
    extreme_pref,
    isTargetSelf,
    target_has_active_player,
    target_is_blacklisted,
    theyAllowExtreme,
    theyAllowLewd,
    user_is_blacklisted,
    verb_consent,


    max_distance,
    required_from_user,
    required_from_user_exposed,
    required_from_user_unexposed,
    user_num_feet,

    required_from_target,
    required_from_target_exposed,
    required_from_target_unexposed,
    target_num_feet,
  } = data;
  return flow([
    // Blacklists completely disable any and all interactions
    filter(interaction =>
      !user_is_blacklisted && !target_is_blacklisted),

    // Optional search term, do before the others so we don't even run the tests
    searchText && filter(testSearch),

    // Filter off interactions depending on pref
    filter(interaction =>
      // Regular interaction
      (interaction.type === INTERACTION_NORMAL ? true
        // Lewd interaction
        : interaction.type === INTERACTION_LEWD ? verb_consent
          // Extreme interaction
          : verb_consent && extreme_pref)),

    // Filter off interactions depending on target's pref
    filter(interaction =>
      // If it's ourself, we've just checked it above, ignore
      ((isTargetSelf || (target_has_active_player === 0)) ? true
        // Regular interaction
        : interaction.type === INTERACTION_NORMAL ? true
          // Lewd interaction
          : interaction.type === INTERACTION_LEWD ? theyAllowLewd
          // Extreme interaction
            : theyAllowLewd && theyAllowExtreme)),

    // Is self
    filter(interaction =>
      (isTargetSelf ? (INTERACTION_FLAG_USER_IS_TARGET
        & interaction.interactionFlags)
        : !(INTERACTION_FLAG_USER_IS_TARGET & interaction.interactionFlags))),
    // Has a player or none at all
    filter(interaction =>
      (!isTargetSelf && (target_has_active_player === 1)
        ? !(INTERACTION_FLAG_OOC_CONSENT
          & interaction.interactionFlags) : true)),
    // Distance
    filter(interaction =>
      max_distance <= interaction.maxDistance),
    // User requirements
    filter(interaction =>
      interaction.required_from_user
        ? !!((required_from_user & interaction.required_from_user)
          === interaction.required_from_user) : true),

    filter(interaction => {
      // User requires exposed
      const exposed = !interaction.required_from_user_exposed
      || ((interaction.required_from_user_exposed
        & required_from_user_exposed)
          === interaction.required_from_user_exposed);
      // User requires unexposed
      const unexposed = !interaction.required_from_user_unexposed
      || ((interaction.required_from_user_unexposed
        & required_from_user_unexposed)
          === interaction.required_from_user_unexposed);

      if (interaction.required_from_user_exposed
        && interaction.required_from_user_unexposed) {
        return exposed || unexposed;
      }
      else {
        return exposed && unexposed;
      }
    }),

    // User required feet amount
    filter(interaction => interaction.user_num_feet
      ? (interaction.user_num_feet <= user_num_feet) : true),
    // Target requirements
    filter(interaction => interaction.required_from_target
      ? !!((required_from_target
        & interaction.required_from_target)
          === interaction.required_from_target) : true),
    filter(interaction => {
      // Target requires exposed
      const exposed = !interaction.required_from_target_exposed
          || ((interaction.required_from_target_exposed
            & required_from_target_exposed)
              === interaction.required_from_target_exposed);
      // Target requires unexposed
      const unexposed = !interaction.required_from_target_unexposed
          || ((interaction.required_from_target_unexposed
            & required_from_target_unexposed)
              === interaction.required_from_target_unexposed);

      if (interaction.required_from_target_exposed
            && interaction.required_from_target_unexposed) {
        return exposed || unexposed;
      }
      else {
        return exposed && unexposed;
      }
    }),
    // Target required feet amount
    filter(interaction => interaction.target_num_feet
      ? (interaction.target_num_feet <= target_num_feet) : true),

    // Searching by "desc"
    sortBy(interaction => interaction.desc),
    // Searching by type
    sortBy(interaction => interaction.type),
  ])(interactions);
};
