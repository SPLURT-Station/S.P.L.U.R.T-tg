import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { createSearch } from 'common/string';

import { useBackend, useLocalState } from '../../../backend';
import { Button, Icon, Section, Stack, Tabs, Tooltip } from '../../../components';
import { Box } from '../../../components';

type ContentInfo = {
  interactions: InteractionData[];
  favorite_interactions: string[];
  user_is_blacklisted: boolean;
  target_is_blacklisted: boolean;
}

type InteractionData = {
  key: string;
  desc: string;
  type: number;
  additionalDetails: string[];

  interactionFlags:number;
  maxDistance:any;
  extreme_pref:any;
  isTargetSelf:any;
  target_has_active_player:any;
  target_is_blacklisted:any;
  theyAllowExtreme:any;
  theyAllowLewd:any;
  user_is_blacklisted:any;
  // verb_consent:any;
  max_distance:any;
  required_from_user:any;
  required_from_user_exposed:any;
  required_from_user_unexposed:any;
  user_num_feet:any;
  required_from_target:any;
  required_from_target_exposed:any;
  required_from_target_unexposed:any;
  target_num_feet:any;
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
  const { act, data } = useBackend<ContentInfo>();
  const [
    searchText,
    setSearchText,
  ] = useLocalState('searchText', '');
  const interactions = sortInteractions(
    data.interactions,
    searchText,
    data)
    || [];
  const favorite_interactions = data.favorite_interactions || [];
  const [inFavorites, setInFavorites] = useLocalState('inFavorites', false);
  const valid_favorites = interactions.filter(interaction => favorite_interactions.includes(interaction.key));
  const interactions_to_display = inFavorites
    ? valid_favorites
    : interactions;
  const { user_is_blacklisted, target_is_blacklisted } = data;
  return (
    <Stack vertical>
      {
        interactions_to_display.length ? (
          interactions_to_display.map((interaction) => (
            <Stack.Item key={interaction.key}>
              <Stack fill>
                <Stack.Item grow>
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
                <Stack.Item>
                  <Button
                    icon="star"
                    tooltip={`${favorite_interactions.includes(interaction.key) ? "Remove from" : "Add to"} favorites`}
                    onClick={() => act('favorite', {
                      interaction: interaction.key,
                    })}
                    selected={favorite_interactions.includes(interaction.key)}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
          ))
        ) : (
          <Section align="center">
            {(() => {
              let message;
              if (user_is_blacklisted || target_is_blacklisted) {
                message = `${user_is_blacklisted ? "Your" : "Their"} mob type is blacklisted from interactions`;
              }
              else if (searchText) {
                message = "No matching results.";
              }
              else if (inFavorites) {
                if (favorite_interactions.length > 0) {
                  message = "No favorites available. Maybe you or your partner lack something your favorites require.";
                } else {
                  message = "You have no favorites! Choose some by clicking the star to the right of any interactions!";
                }
              }
              else {
                message = "No interactions available.";
              }
              return <>{message}</>;
            })()}
          </Section>

        )
      }
    </Stack>
  );
};

/**
 * Interaction sorter! also search box
 */
export const sortInteractions = (interactions:InteractionData[], searchText = '', data) => {
  const testSearch = createSearch<InteractionData>(searchText,
    (interaction:InteractionData) => interaction.desc);
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
    (interactions) => filter(interactions, (interaction:InteractionData) =>
      !user_is_blacklisted && !target_is_blacklisted),

    // Optional search term, do before the others so we don't even run the tests
    (interactions) => searchText ? filter(interactions, testSearch) : interactions,

    // Filter off interactions depending on pref
    (interactions) => filter(interactions, (interaction:InteractionData) =>
      // Regular interaction
      (interaction.type === INTERACTION_NORMAL ? true
        // Lewd interaction
        : interaction.type === INTERACTION_LEWD ? verb_consent
          // Extreme interaction
          : verb_consent && extreme_pref)),

    // Filter off interactions depending on target's pref
    (interactions) => filter(interactions, (interaction:InteractionData) =>
      // If it's ourself, we've just checked it above, ignore
      ((isTargetSelf || (target_has_active_player === 0)) ? true
        // Regular interaction
        : interaction.type === INTERACTION_NORMAL ? true
          // Lewd interaction
          : interaction.type === INTERACTION_LEWD ? theyAllowLewd
          // Extreme interaction
            : theyAllowLewd && theyAllowExtreme)),

    // Is self
    (interactions) => filter(interactions, (interaction:InteractionData) =>
      {
        const flagCheck = (INTERACTION_FLAG_USER_IS_TARGET & interaction.interactionFlags) !== 0;
        return isTargetSelf ? flagCheck : !flagCheck;
      }),
    // Has a player or none at all
    (interactions) => filter(interactions, (interaction:InteractionData) =>
      (!isTargetSelf && (target_has_active_player === 1)
        ? !(INTERACTION_FLAG_OOC_CONSENT
          & interaction.interactionFlags) : true)),
    // Distance
    (interactions) => filter(interactions, (interaction:InteractionData) =>
      max_distance <= interaction.maxDistance),
    // User requirements
    (interactions) => filter(interactions, (interaction:InteractionData) =>
      interaction.required_from_user
        ? !!((required_from_user & interaction.required_from_user)
          === interaction.required_from_user) : true),

    (interactions) => filter(interactions, (interaction:InteractionData) => {
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
    (interactions) => filter(interactions, (interaction:InteractionData) => interaction.user_num_feet
      ? (interaction.user_num_feet <= user_num_feet) : true),
    // Target requirements
    (interactions) => filter(interactions, (interaction:InteractionData) => interaction.required_from_target
      ? !!((required_from_target
        & interaction.required_from_target)
          === interaction.required_from_target) : true),
    (interactions) => filter(interactions, (interaction:InteractionData) => {
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
    (interactions) => filter(interactions, (interaction:InteractionData) => interaction.target_num_feet
      ? (interaction.target_num_feet <= target_num_feet) : true),

    // Searching by "desc"
    (interactions) => sortBy(interactions, (interaction:InteractionData) => interaction.desc),
    // Searching by type
    (interactions) => sortBy(interactions, (interaction:InteractionData) => interaction.type),
  ])(interactions);
};
