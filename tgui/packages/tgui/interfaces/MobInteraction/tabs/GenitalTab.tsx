import { filter, map, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { createSearch } from 'common/string';
import { useBackend, useLocalState } from '../../../backend';
import { Button, Flex, Section, Stack } from '../../../components';

type GenitalInfo = {
  genitals: GenitalData[];
}

type GenitalData = {
  name: string,
  key: string,
  visibility: string,
  possible_choices: string[],
  can_arouse: boolean,
  arousal_state: boolean,
  always_accessible: boolean,
}

export const GenitalTab = (props, context) => {
  const { act, data } = useBackend<GenitalInfo>(context);
  const [
    searchText,
    setSearchText,
  ] = useLocalState(context, 'searchText', '');
  const genitals = sortGenitals(data.genitals, searchText) || [];
  return (
    <Section>
      {genitals.length ? (
        <Flex direction="column">
          {genitals.map(genital => (
            <Section key={genital.key} title={genital.name} textAlign="center">
              <Stack>
                <Stack.Item textAlign="center" grow basis={10}>
                  Visibility<br />
                  <Stack>
                    {genital.possible_choices.map(choice => (
                      <Stack.Item key={choice} grow>
                        <Button
                          fluid
                          key={choice}
                          tooltip={choice}
                          icon={ModeToIcon[choice]}
                          color={genital.visibility === choice ? "green" : "default"}
                          onClick={() => act('genital', {
                            genital: genital.key,
                            visibility: choice,
                          })} />
                      </Stack.Item>
                    ))}
                  </Stack>
                </Stack.Item>
                <Stack.Item textAlign="center" grow>
                  Actions<br />
                  <Stack fill>
                    <Stack.Item grow>
                      <Button
                        fluid
                        key={genital.arousal_state}
                        tooltip={genital.can_arouse
                          ? ((genital.arousal_state ? "Unarouse" : "Arouse") + " your " + genital.name.toLowerCase())
                          : "You cannot modify arousal on your " + genital.name.toLowerCase()}
                        icon={genital.arousal_state ? "heart" : "heart-broken"}
                        color={genital.can_arouse ? (genital.arousal_state ? "green" : "default") : "grey"}
                        onClick={() => act('genital', {
                          genital: genital.key,
                          set_arousal: !genital.arousal_state,
                        })} />
                    </Stack.Item>
                    <Stack.Item grow>
                      <Button
                        fluid
                        key={genital.always_accessible}
                        tooltip={genital.always_accessible
                          ? "Forbid others from manipulating this genital at any moment"
                          : "Allow others to manipulate this genital at any moment"}
                        icon={genital.always_accessible ? "hand-paper" : 'hand-rock'}
                        color={genital.always_accessible ? "green" : "default"}
                        onClick={() => act('genital', {
                          genital: genital.key,
                          set_accessibility: true,
                        })} />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Section>
          ))}
        </Flex>
      ) : (
        <Section align="center">
          {
            searchText ? (
              "No matching results."
            ) : (
              "You don't seem to have any genitals...\
              Or any that you could modify."
            )
          }
        </Section>
      )}
    </Section>
  );
};

/**
 * Genital sorter!
 */
const sortGenitals = (genitals, searchText = '') => {
  const testSearch = createSearch<GenitalData>(searchText,
    genital => genital.name);
  return flow([
    // Optional search term
    searchText && filter(testSearch),
    // Slightly expensive, but way better than sorting in BYOND
    sortBy(genital => genital.name),
  ])(genitals);
};

// Self explanatory
const ModeToIcon = {
  "Always visible": "eye",
  "Hidden by clothes": "tshirt",
  "Hidden by underwear": "low-vision",
  "Always hidden": "eye-slash",
};
