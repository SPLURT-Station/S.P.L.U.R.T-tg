import { useEffect, useState } from 'react';
import {
  Box,
  Button,
  Icon,
  Modal,
  Section,
  Stack,
  TextArea,
  Tooltip,
} from 'tgui-core/components';

import { useBackend, useSharedState } from '../backend';
import { Window } from '../layouts';

type RoomData = {
  room_visibility: number;
  room_status: number;
  room_privacy: number;
  room_description: string;
  name: string;
  room_number: number;
  icon: string;
  bluespace_box: boolean;
  id_card: string;
};

const AVAILABLE_ICONS = [
  'snowflake',
  'bed',
  'coffee',
  'glass-water',
  'burger',
  'dice',
  'gamepad',
  'heart',
  'music',
  'palette',
  'book',
  'dumbbell',
  'skull',
  'ghost',
] as const;

export const HilbertsHotelRoomControl = (props) => {
  const { act, data } = useBackend<RoomData>();
  const [iconPickerOpen, setIconPickerOpen] = useSharedState(
    'iconPicker',
    false,
  );
  const [departureModalOpen, setDepartureModalOpen] = useSharedState(
    'departure',
    false,
  );

  const [localName, setLocalName] = useState(data.name || '');
  const [localDescription, setLocalDescription] = useState(
    data.room_description || '',
  );

  useEffect(() => {
    setLocalName(data.name || '');
    setLocalDescription(data.room_description || '');
  }, [data.name, data.room_description]);

  return (
    <Window width={400} height={500} title="Room Control Panel">
      {!!iconPickerOpen && (
        <Modal
          style={{
            width: '280px',
            padding: '5px',
          }}
        >
          <Section>
            <Box
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(4, 1fr)',
                gap: '4px',
                padding: '4px',
              }}
            >
              {AVAILABLE_ICONS.map((icon) => (
                <Button
                  key={icon}
                  onClick={() => {
                    act('set_icon', { icon });
                    setIconPickerOpen(false);
                  }}
                  style={{
                    height: '32px',
                    width: '32px',
                    padding: '3px 8px',
                    lineHeight: '32px',
                    cursor: 'pointer',
                  }}
                >
                  <Icon name={icon} size={1.5} />
                </Button>
              ))}
            </Box>
          </Section>
        </Modal>
      )}
      {!!departureModalOpen && (
        <Modal
          style={{
            width: '280px',
            padding: '5px',
          }}
        >
          <Section title="Confirm Departure">
            <Stack vertical>
              <Stack.Item>
                Departing will consume your ID card and open your job slot, as
                if you&apos;ve entered cryosleep stasis. Items you put in the
                box will be returned to the cryogenic oversight console.
              </Stack.Item>
              <Stack.Item>
                <Stack justify="space-between">
                  <Stack.Item>
                    <Button
                      icon="check"
                      color="good"
                      onClick={() => {
                        act('depart');
                        setDepartureModalOpen(false);
                      }}
                    >
                      Confirm
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="times"
                      color="bad"
                      onClick={() => setDepartureModalOpen(false)}
                    >
                      Cancel
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Section>
        </Modal>
      )}
      <Window.Content>
        <Section>
          <Stack>
            <Stack.Item
              style={{
                fontSize: '20px',
                textAlign: 'center',
                backgroundColor: 'rgb(0, 0, 0)',
                border: '2px solid rgb(77, 130, 173)',
                borderRadius: '3px',
                color: 'rgb(115, 177, 228)',
                padding: '2px 5px',
              }}
            >
              {data.room_number || 'Err'}
            </Stack.Item>
            <Stack vertical>
              <Stack.Item
                style={{
                  marginLeft: '10px',
                  fontSize: '8',
                  color: 'rgb(179, 179, 179)',
                  fontStyle: 'italic',
                }}
              >
                You&apos;re currently in...
              </Stack.Item>
              <Stack.Item
                style={{
                  fontSize: '18px',
                  lineHeight: '0.8',
                  marginLeft: '10px',
                  marginTop: '1px',
                }}
              >
                {data.name || 'Custom Room'}
              </Stack.Item>
            </Stack>
            <Stack.Item ml="auto" mr="2px">
              <Tooltip content="Icon picker">
                <Button
                  onClick={() => setIconPickerOpen(true)}
                  style={{
                    height: '30px',
                    width: '32px',
                    cursor: 'pointer',
                    padding: '6px 8px',
                    marginTop: '1px',
                    marginRight: '1px',
                  }}
                >
                  <Icon size={1.5} name={data.icon || 'snowflake'} />
                </Button>
              </Tooltip>
            </Stack.Item>
          </Stack>
        </Section>
        <Section title="Room Status">
          <Stack vertical>
            <Stack fill textAlign="center">
              <Stack.Item grow>
                <Button
                  fluid
                  icon={data.room_visibility ? 'eye' : 'eye-slash'}
                  onClick={() => act('toggle_visibility')}
                  lineHeight="2.2"
                  color={data.room_visibility ? 'blue' : 'green'}
                  style={{ cursor: 'pointer' }}
                >
                  {data.room_visibility ? 'Visible' : 'Invisible'}
                </Button>
              </Stack.Item>
              <Stack.Item grow>
                <Button
                  fluid
                  icon={data.room_status ? 'lock-open' : 'lock'}
                  onClick={() => act('toggle_status')}
                  lineHeight="2.2"
                  color={data.room_status ? 'blue' : 'green'}
                  style={{ cursor: 'pointer' }}
                >
                  {data.room_status ? 'Open' : 'Closed'}
                </Button>
              </Stack.Item>
              <Stack.Item grow>
                <Button
                  fluid
                  icon={data.room_privacy ? 'users' : 'user-secret'}
                  onClick={() => act('toggle_privacy')}
                  lineHeight="2.2"
                  color={data.room_privacy ? 'blue' : 'green'}
                  style={{ cursor: 'pointer' }}
                >
                  {data.room_privacy ? 'Guest names' : 'Only number'}
                </Button>
              </Stack.Item>
            </Stack>
            <Stack mt="6px">
              <Stack.Item width="100%">
                <TextArea
                  fluid
                  height="1.7em"
                  width="100%"
                  placeholder="Enter room name here..."
                  value={localName}
                  onChange={(e, value) => setLocalName(value)}
                  maxLength={20}
                />
              </Stack.Item>
              <Stack.Item>
                <Button.Confirm
                  fluid
                  icon="check"
                  onClick={() => act('confirm_name', { name: localName })}
                  style={{
                    cursor: 'pointer',
                    height: '1.7em',
                    width: '1.85em',
                  }}
                  confirmContent={<Icon name="question" />}
                />
              </Stack.Item>
            </Stack>
            <Stack.Item>
              <TextArea
                fluid
                style={{
                  width: '100%',
                  height: '8em',
                }}
                placeholder="Enter room description here..."
                value={localDescription}
                onChange={(e, value) => setLocalDescription(value)}
                maxLength={220}
              />
            </Stack.Item>
            <Stack.Item>
              <Button.Confirm
                fluid
                icon="check"
                onClick={() =>
                  act('confirm_description', { description: localDescription })
                }
                confirmContent={
                  <>
                    <Icon name="question" />
                    Confirm?
                  </>
                }
                confirmColor="blue"
              >
                Update description
              </Button.Confirm>
            </Stack.Item>
          </Stack>
        </Section>
        <Section title="Departure">
          <Stack vertical>
            <Stack.Item
              style={{
                width: '100%',
                height: 'fit-content',
                padding: '5px 5px',
                backgroundColor: 'rgb(36, 36, 36)',
              }}
            >
              {data.id_card ? (
                <Button
                  fluid
                  icon="eject"
                  onClick={() => {
                    act('eject_id');
                  }}
                  lineHeight="2"
                >
                  {data.id_card}
                </Button>
              ) : (
                <i
                  style={{
                    lineHeight: '2',
                    marginLeft: '4px',
                    color: 'rgb(128, 128, 128)',
                  }}
                >
                  No ID card present.
                </i>
              )}
            </Stack.Item>
            <Stack.Item
              style={{
                width: '100%',
                height: 'fit-content',
                padding: '5px 5px',
                backgroundColor: 'rgb(36, 36, 36)',
              }}
            >
              {data.bluespace_box ? (
                <Button
                  fluid
                  icon="eject"
                  onClick={() => {
                    act('eject_box');
                  }}
                  lineHeight="2"
                >
                  Eject storage
                </Button>
              ) : (
                <i
                  style={{
                    lineHeight: '2',
                    marginLeft: '4px',
                    color: 'rgb(128, 128, 128)',
                  }}
                >
                  Insert the storage container here.
                </i>
              )}
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="sign-out-alt"
                onClick={() => setDepartureModalOpen(true)}
                lineHeight="2"
              >
                Depart
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
