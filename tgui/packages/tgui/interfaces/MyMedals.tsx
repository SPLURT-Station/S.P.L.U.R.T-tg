import { Box, NoticeBox, Section } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type MedalRecord = {
  medal: string;
  giver: string;
  recipient: string;
  reason: string | null;
};

type MedalHistoryData = {
  given: MedalRecord[];
  received: MedalRecord[];
};

const MedalList = (props: { entries: MedalRecord[] }) => {
  const { entries } = props;
  if (!entries.length) {
    return <Box color="label">No medals recorded.</Box>;
  }
  return entries.map((entry, index) => (
    <Box key={index} mb={2}>
      <Box bold>{entry.medal}</Box>
      <Box>Given by: {entry.giver}</Box>
      <Box>Received by: {entry.recipient}</Box>
      <Box>{entry.reason}</Box>
    </Box>
  ));
};

export const MyMedals = () => {
  const { data } = useBackend<MedalHistoryData>();
  const { given = [], received = [] } = data;
  return (
    <Window width={550} height={550}>
      <Window.Content scrollable>
        <NoticeBox>
          Your medals for the current round only. Records start when awarded and
          are not carried between rounds. Earlier awards are not backfilled.
        </NoticeBox>
        <Section title="Received">
          <MedalList entries={received} />
        </Section>
        <Section title="Given">
          <MedalList entries={given} />
        </Section>
      </Window.Content>
    </Window>
  );
};
