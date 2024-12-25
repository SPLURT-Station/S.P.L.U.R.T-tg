import { useBackend } from '../../../backend';
import { Button, Stack } from '../../../components';

type ContentPref = {
  desc: string,
  key: string,
  value: boolean,
}

type ContentPrefsInfo = {
  erp_prefs: ContentPref[],
}

export const ContentPreferencesTab = (props, context) => {
  const { act, data } = useBackend<ContentPrefsInfo>();
  const {
    erp_prefs,
  } = data;
  return (
    <Stack vertical fill>
      {erp_prefs.map((erp_pref) =>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={erp_pref.value ? "toggle-on" : "toggle-off"}
          selected={erp_pref.value}
          onClick={() => act('pref', {
            pref: erp_pref.key,
          })}
        >
          {erp_pref.desc}
        </Button>
      </Stack.Item>
    )}
    </Stack>
  );
};
