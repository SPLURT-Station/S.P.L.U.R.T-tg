import { Icon, Image, LabeledList, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  character_preview: string;
  primary_school: string;
  secondary_school: string;
  psyonic_level: string;
  owner_name: string;
  owner_age: number;
  owner_species: string;
  owner_preview: string;
};

export const PsyonicLicense = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    primary_school,
    secondary_school,
    psyonic_level,
    owner_name,
    owner_age,
    owner_species,
    owner_preview,
  } = data;
  return (
    <Window title="Psyonic License" width={625} height={450} theme="ntos">
      <Window.Content>
        <Stack minWidth="625px">
          <Stack.Item width="50px">
            <Icon height="100%" fontSize="50px" name="flushed" color="cyan" />
          </Stack.Item>
          <Stack.Item width="500px">
            <Section textAlign="center" title="PSYCASTER LICENCE" italic>
              {'Мы всегда наблюдаем'}
            </Section>
          </Stack.Item>
          <Stack.Item width="50px">
            <Icon height="100%" fontSize="50px" name="flushed" color="cyan" />
          </Stack.Item>
        </Stack>
        <Stack minWidth="625px" verticalAlign="middle">
          <Stack.Item
            width="34%"
            minWidth="207px"
            textAlign="center"
            align="center"
          >
            <Section textAlign="center" align="center" height="200px">
              {/* <Icon name="brain" fontSize="200px" color="cyan" height="100%" /> */}
              <Image
                fillPositionedParent
                width="100%"
                height="200px"
                opacity={1}
                src={`data:image/jpeg;base64,${data.owner_preview}`}
              />
            </Section>
          </Stack.Item>
          <Stack.Item textAlign="center" height="100%">
            <Section title="Информация о владельце" height="200px">
              <LabeledList>
                <LabeledList.Item label="ФИО">
                  {data.owner_name}
                </LabeledList.Item>
                <LabeledList.Item label="Возраст">
                  {data.owner_age}
                </LabeledList.Item>
                <LabeledList.Item label="Раса">
                  {data.owner_species}
                </LabeledList.Item>
                <LabeledList.Item label="Первичная школа">
                  {data.primary_school}
                </LabeledList.Item>
                <LabeledList.Item label="Вторичная школа">
                  {data.secondary_school}
                </LabeledList.Item>
                <LabeledList.Item label="Псионический потенциал">
                  {data.psyonic_level}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
        </Stack>
        <Stack minWidth="625px">
          <Stack.Item width="100%">
            <Section textAlign="center">
              {
                'Данная лицензия удостоверяет то, что пользователь является псиоником.'
              }
              {
                ' Лицензия пользователя псионики позволяет пользователю применять способности в целях самозащиты, оказания лечебной помощи и в прочих, установленных законом случаев.'
              }
              {
                ' Пользователь псионики обязан иметь лицензию при себе всё время, иначе его действия могут быть классифицированы СБ НТ как нелегальные и повлечь за собой юридические последствия.'
              }
            </Section>
          </Stack.Item>
        </Stack>
        <Stack>
          <Stack.Item>
            <Section
              textColor="red"
              fontWeight="900"
              minWidth="625px"
              textAlign="center"
            >
              {'ПОДДЕЛКА ЛИЦЕНЗИИ КАРАЕТСЯ ЗАКОНОМ'}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
