import { useBackend } from '../../../backend';
import { Button, Flex, LabeledList } from '../../../components';

type CharacterPrefsInfo = {
  erp_pref: number,
  noncon_pref: number,
  vore_pref: number,
  extreme_pref: number,
  extreme_harm: boolean,
}

export const CharacterPrefsTab = (props, context) => {
  const { act, data } = useBackend<CharacterPrefsInfo>(context);
  const {
    erp_pref,
    noncon_pref,
    vore_pref,
    extreme_pref,
    extreme_harm,
  } = data;
  return (
    <Flex direction="column">
      <LabeledList>
        <LabeledList.Item label="ERP Preference">
          <Button
            icon={"check"}
            color={erp_pref === 1 ? "green" : "default"}
            onClick={() => act('char_pref', {
              char_pref: 'erp_pref',
              value: 1,
            })} />
          <Button
            icon={"question"}
            color={erp_pref === 2 ? "yellow" : "default"}
            onClick={() => act('char_pref', {
              char_pref: 'erp_pref',
              value: 2,
            })} />
          <Button
            icon={"times"}
            color={erp_pref === 0 ? "red" : "default"}
            onClick={() => act('char_pref', {
              char_pref: 'erp_pref',
              value: 0,
            })} />
        </LabeledList.Item>
        <LabeledList.Item label="Noncon Preference">
          <Button
            icon={"check"}
            color={noncon_pref === 1 ? "green" : "default"}
            onClick={() => act('char_pref', {
              char_pref: 'noncon_pref',
              value: 1,
            })} />
          <Button
            icon={"question"}
            color={noncon_pref === 2 ? "yellow" : "default"}
            onClick={() => act('char_pref', {
              char_pref: 'noncon_pref',
              value: 2,
            })} />
          <Button
            icon={"times"}
            color={noncon_pref === 0 ? "red" : "default"}
            onClick={() => act('char_pref', {
              char_pref: 'noncon_pref',
              value: 0,
            })} />
        </LabeledList.Item>
        <LabeledList.Item label="Vore Preference">
          <Button
            icon={"check"}
            color={vore_pref === 1 ? "green" : "default"}
            onClick={() => act('char_pref', {
              char_pref: 'vore_pref',
              value: 1,
            })} />
          <Button
            icon={"question"}
            color={vore_pref === 2 ? "yellow" : "default"}
            onClick={() => act('char_pref', {
              char_pref: 'vore_pref',
              value: 2,
            })} />
          <Button
            icon={"times"}
            color={vore_pref === 0 ? "red" : "default"}
            onClick={() => act('char_pref', {
              char_pref: 'vore_pref',
              value: 0,
            })} />
        </LabeledList.Item>
        <LabeledList.Item label="Extreme Preference">
          <Button
            icon={"check"}
            color={extreme_pref === 1 ? "green" : "default"}
            onClick={() => act('char_pref', {
              char_pref: 'extreme_pref',
              value: 1,
            })} />
          <Button
            icon={"question"}
            color={extreme_pref === 2 ? "yellow" : "default"}
            onClick={() => act('char_pref', {
              char_pref: 'extreme_pref',
              value: 2,
            })} />
          <Button
            icon={"times"}
            color={extreme_pref === 0 ? "red" : "default"}
            onClick={() => act('char_pref', {
              char_pref: 'extreme_pref',
              value: 0,
            })} />
        </LabeledList.Item>
        {extreme_pref ? (
          <LabeledList.Item label="Extreme Harm">
            <Button
              icon={"check"}
              color={extreme_harm ? "green" : "default"}
              onClick={() => act('char_pref', {
                char_pref: 'extreme_harm',
                value: 1,
              })} />
            <Button
              icon={"times"}
              color={extreme_harm ? "default" : "red"}
              onClick={() => act('char_pref', {
                char_pref: 'extreme_harm',
                value: 0,
              })} />
          </LabeledList.Item>
        ) : (null)}
      </LabeledList>
    </Flex>
  );
};
