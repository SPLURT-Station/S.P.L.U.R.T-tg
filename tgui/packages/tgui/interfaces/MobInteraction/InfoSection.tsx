import { useBackend } from '../../backend';
import { BlockQuote, Icon, ProgressBar, Section, Stack } from '../../components';

type HeaderInfo = {
  isTargetSelf: boolean;
  interactingWith: string;
  lust: number;
  maxLust: number;
  selfAttributes: string[];
  theirAttributes: string[];
  theirLust: number;
  theirMaxLust: number;
}

export const InfoSection = (props, context) => {
  const { act, data } = useBackend<HeaderInfo>(context);
  const {
    isTargetSelf,
    interactingWith,
    lust,
    maxLust,
    selfAttributes,
    theirAttributes,
    theirLust,
    theirMaxLust,
  } = data;
  return (
    <Section title={interactingWith} fill>
      <Stack vertical fill>
        <Stack.Item grow basis={0}>
          <Section fill overflow="auto">
            <Stack>
              <Stack.Item>
                <BlockQuote>
                  You...<br />
                  {selfAttributes.map(attribute => (
                    <div key={attribute}>
                      {attribute}<br />
                    </div>
                  ))}
                </BlockQuote>
              </Stack.Item>
              {!isTargetSelf ? (
                <Stack.Item>
                  <BlockQuote>
                    They...<br />
                    {theirAttributes.map(attribute => (
                      <div key={attribute}>
                        {attribute}<br />
                      </div>
                    ))}
                  </BlockQuote>
                </Stack.Item>
              ) : (null)}
            </Stack>
          </Section>
        </Stack.Item>
        <Stack.Item>
          <Stack fill>
            <Stack.Item grow>
              <ProgressBar fill value={lust} maxValue={maxLust} color="purple"><Icon name="heart" /></ProgressBar>
            </Stack.Item>
            {(!isTargetSelf && (theirLust !== null) ? (
              <Stack.Item grow>
                <ProgressBar value={theirLust} maxValue={theirMaxLust} color="purple"><Icon name="heart" /></ProgressBar>
              </Stack.Item>
            ) : (null))}
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
