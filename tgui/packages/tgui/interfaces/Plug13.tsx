import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Plug13Data = {
  is_connected: string;
  pending: boolean;
  username: string;
  error: string;
  code: string;
};

const codeRegex = /^([A-Za-z0-9]{10}|([A-Za-z0-9]{5}-[A-Za-z0-9]{5}))$/;

export const Plug13 = () => {
  const { act, data } = useBackend<Plug13Data>();

  const [code, setCode] = useState('');

  const validateCode = (code: string) => {
    if (code.length < 10) return false;
    return codeRegex.test(code);
  };

  return (
    <Window width={400} height={240}>
      <Window.Content scrollable={false}>
        {!data.is_connected ? (
          <Section title="Connection" fill>
            <Stack direction="column" justify="center" align="center" fill>
              {data.error ? (
                <Stack.Item mb={1}>
                  <NoticeBox danger style={{ maxWidth: '300px' }}>
                    {data.error}
                  </NoticeBox>
                </Stack.Item>
              ) : (
                <Box />
              )}
              <Stack.Item>
                <Input
                  monospace
                  maxLength={11}
                  placeholder="ABCDE-FGHIJ"
                  style={{ fontSize: '14px', textTransform: 'uppercase' }}
                  disabled={data.pending}
                  value={code}
                  onChange={(value) => setCode(value.toUpperCase())}
                />
              </Stack.Item>
              <Stack.Item mt={1}>
                <Button
                  icon={data.pending ? 'spinner' : 'bolt'}
                  iconSpin={data.pending}
                  disabled={data.pending || !validateCode(code)}
                  onClick={() => act('connect', { code })}
                >
                  Connect
                </Button>
              </Stack.Item>
            </Stack>
          </Section>
        ) : (
          <Section
            title="Status"
            fill
            buttons={
              <Button icon="times" onClick={() => act('disconnect')}>
                Disconnect
              </Button>
            }
          >
            <Stack direction="column" justify="center" align="center" fill>
              <Stack.Item>
                <span>Connected to account </span>
                <b>{data.username}</b>
              </Stack.Item>
              <Stack.Item mt={1} fontSize={0.9} style={{ fontStyle: 'italic' }}>
                (You can close this window)
              </Stack.Item>
            </Stack>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
