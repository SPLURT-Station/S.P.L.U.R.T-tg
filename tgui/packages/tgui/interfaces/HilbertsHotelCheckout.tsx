import { useEffect, useState } from 'react';
import {
  Box,
  Button,
  Icon,
  Input,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
  Table,
  Tabs,
  Tooltip,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type RoomsData = {
  current_room: number;
  selected_template: string;
  user_donator_tier: number;
  user_ckey: string;
  active_rooms: any[];
  conservated_rooms: any[];
  hotel_map_list: any[];
};

const CATEGORY_ORDER = [
  'Misc',
  'Apartment',
  'Beach',
  'Station',
  'Winter',
  'Special',
];

const CATEGORY_ICONS = {
  apartment: 'building',
  beach: 'umbrella-beach',
  misc: 'shuffle',
  station: 'satellite',
  winter: 'snowflake',
  special: 'heart',
};

const sortCategories = (categories: string[]) =>
  categories.sort((a, b) => {
    const aIndex = CATEGORY_ORDER.indexOf(a);
    const bIndex = CATEGORY_ORDER.indexOf(b);
    if (aIndex !== -1 || bIndex !== -1) {
      return (
        (aIndex === -1 ? CATEGORY_ORDER.length : aIndex) -
        (bIndex === -1 ? CATEGORY_ORDER.length : bIndex)
      );
    }
    return a.localeCompare(b);
  });

const ROOM_STATUS = {
  1: {
    color: 'green',
    icon: 'door-open',
    label: 'Open',
    tooltip: 'Anyone can join',
  },
  2: {
    color: 'blue',
    icon: 'user-check',
    label: 'Guests',
    tooltip: 'Only trusted guests can join',
  },
  3: {
    color: 'red',
    icon: 'lock',
    label: 'Closed',
    tooltip: 'Only the owner can join',
  },
};

const RoomStatus = ({ room }) => {
  const status = ROOM_STATUS[room.room_preferences?.status] || ROOM_STATUS[3];
  return (
    <Tooltip content={status.tooltip}>
      <Button
        compact
        color={status.color}
        icon={status.icon}
        style={{ pointerEvents: 'none' }}
      >
        {status.label}
      </Button>
    </Tooltip>
  );
};

const OpenRooms = ({ data, act, selected_template }) => {
  const activeRooms = data.active_rooms || [];
  const visibleRooms = activeRooms.filter(
    (room) => room.room_preferences.visibility,
  );

  return (
    <Section
      title="Open Rooms"
      style={{
        paddingBottom: '0px',
      }}
    >
      {visibleRooms.length ? (
        <Box
          style={{
            height: '100%',
            overflowY: 'auto',
            width: '100%',
          }}
        >
          <Stack vertical>
            {visibleRooms?.map((room) => (
              <Stack
                fill
                key={room.number}
                style={{
                  padding: '5px 5px',
                  backgroundColor: 'rgba(138, 138, 138, 0.1)',
                }}
              >
                <Stack.Item mr={'10px'}>
                  <Box
                    style={{
                      fontSize: '20px',
                      width: '100px',
                      textAlign: 'center',
                      backgroundColor: 'rgb(0, 0, 0)',
                      border: '2px solid rgb(77, 130, 173)',
                      marginBottom: '5px',
                      color: 'rgb(115, 177, 228)',
                      padding: '0px 0px',
                      borderRadius: '2px',
                    }}
                  >
                    {room.number}
                  </Box>
                  <Button.Confirm
                    style={{
                      cursor: 'pointer',
                      width: '100px',
                      textAlign: 'center',
                    }}
                    confirmContent={'Join?'}
                    confirmColor="green"
                    disabled={!room.can_join}
                    tooltip={
                      room.can_join
                        ? 'Join this room'
                        : 'You do not have access to this room'
                    }
                    onClick={() =>
                      act('checkin', {
                        room: Number(room.number),
                        template: selected_template,
                      })
                    }
                    icon="right-to-bracket"
                  >
                    Join
                  </Button.Confirm>
                </Stack.Item>
                <Stack vertical width={'100%'}>
                  <Stack.Item
                    style={{
                      width: '100%',
                    }}
                  >
                    <span
                      style={{
                        display: 'flex',
                        marginTop: '-2px',
                        marginBottom: '-6px',
                      }}
                    >
                      {' '}
                      <Icon
                        size={1.4}
                        style={{
                          marginRight: '10px',
                          marginLeft: '5px',
                          lineHeight: '24px',
                        }}
                        name={room.room_preferences.icon || 'door-open'}
                      />
                      <span
                        style={{
                          fontSize: '18px',
                        }}
                      >
                        {room.name}
                      </span>
                      <span
                        style={{
                          marginLeft: '8px',
                          lineHeight: '24px',
                        }}
                      >
                        <RoomStatus room={room} />
                      </span>
                      <span
                        style={{
                          fontSize: '10px',
                          marginLeft: '10px',
                          lineHeight: '26px',
                        }}
                      >
                        {!room.room_preferences.privacy ? (
                          <Icon name="users" />
                        ) : (
                          <Tooltip
                            content={room.occupants.join(', ')}
                            position="top"
                          >
                            <Icon name="users" />
                          </Tooltip>
                        )}{' '}
                        {room.occupants.length}
                      </span>
                    </span>
                  </Stack.Item>
                  <Stack.Item
                    style={{
                      color: 'rgba(255, 255, 255, 0.7)',
                      fontSize: '12px',
                      lineHeight: '1.4',
                      wordWrap: 'break-word',
                      overflowWrap: 'break-word',
                      maxWidth: '400px',
                      marginBottom: '5px',
                      marginLeft: '5px',
                    }}
                  >
                    {room.room_preferences.description ? (
                      room.room_preferences.description
                    ) : (
                      <i>No description</i>
                    )}
                  </Stack.Item>
                </Stack>
              </Stack>
            ))}
          </Stack>
        </Box>
      ) : (
        <i>No open rooms now...</i>
      )}
    </Section>
  );
};

const RoomCheckIn = ({
  data,
  act,
  selectedTemplate,
  setSelectedTemplate,
  selectedCategory,
  setSelectedCategory,
  categories,
  searchText,
  setSearchText,
  roomName,
  setRoomName,
}) => {
  const { current_room = 1 } = data;
  return (
    <Section title="Room Check-In">
      <Stack>
        <Stack.Item grow>
          <Tabs>
            {categories.map((category) => (
              <Tabs.Tab
                key={category}
                selected={selectedCategory === category}
                onClick={() => setSelectedCategory(category)}
                style={{ cursor: 'pointer' }}
              >
                <Icon
                  name={CATEGORY_ICONS[category.toLowerCase()] || 'door-open'}
                />{' '}
                {category}
              </Tabs.Tab>
            ))}
          </Tabs>
          <Box mt={1}>
            <Input
              fluid
              placeholder="Search templates..."
              value={searchText}
              onChange={(value) => setSearchText(value)}
            />
          </Box>
          <Box mt={1}>
            <RoomsTab
              category={selectedCategory}
              searchText={searchText}
              selected_template={selectedTemplate}
              setSelectedTemplate={setSelectedTemplate}
            />
          </Box>
        </Stack.Item>
        <Stack.Item width="120px">
          <NumberInput
            width="100%"
            minValue={1}
            maxValue={1000000000}
            step={1}
            value={current_room}
            format={(value) => String(Math.floor(value))}
            onChange={(value) =>
              act('update_room', {
                room: value,
              })
            }
            lineHeight={1.8}
            fontSize="20px"
          />
          <Input
            width="100%"
            placeholder="Room name"
            value={roomName}
            onChange={(value) => setRoomName(value)}
            style={{ textAlign: 'center' }}
          />
          <Button.Confirm
            style={{ cursor: 'pointer' }}
            width="100%"
            fluid
            textAlign="center"
            mt={1}
            confirmContent={'Confirm?'}
            onClick={() =>
              act('checkin', {
                room: current_room,
                template: selectedTemplate,
                room_name: roomName,
              })
            }
            lineHeight={2}
            icon="right-to-bracket"
          >
            Check-in
          </Button.Confirm>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const ReservedRooms = ({ data, act }) => {
  const conservatedRooms = data.conservated_rooms || [];
  return (
    <Section title="Reserved Rooms">
      {conservatedRooms.length ? (
        <Table>
          {conservatedRooms.map((room) => (
            <Table.Row key={room.number}>
              <Table.Cell width="1.8em">
                <Icon name={room.room_preferences.icon || 'door-open'} />
              </Table.Cell>
              <Table.Cell>Room {room.number}</Table.Cell>
              <Table.Cell>{room.room_preferences.name}</Table.Cell>
              <Table.Cell collapsing>
                <RoomStatus room={room} />
              </Table.Cell>
              <Table.Cell collapsing>
                {room.is_owner && (
                  <Button.Confirm
                    compact
                    color="red"
                    icon="trash"
                    confirmContent="Delete?"
                    tooltip="Delete this reserved room"
                    onClick={() =>
                      act('delete_reserved_room', {
                        room: Number(room.number),
                      })
                    }
                  >
                    Delete
                  </Button.Confirm>
                )}
              </Table.Cell>
              <Table.Cell collapsing>
                <Button.Confirm
                  compact
                  icon="right-to-bracket"
                  confirmContent="Restore?"
                  confirmColor="green"
                  disabled={!room.can_join}
                  tooltip={
                    room.can_join
                      ? 'Restore and join this reserved room'
                      : 'You do not have access to this room'
                  }
                  onClick={() =>
                    act('checkin', {
                      room: Number(room.number),
                      template: data.selected_template,
                    })
                  }
                >
                  Join
                </Button.Confirm>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      ) : (
        <i>No reserved rooms now...</i>
      )}
    </Section>
  );
};

export const CheckoutMenu = (props) => {
  const { act, data } = useBackend<RoomsData>();
  const checkoutData = {
    ...data,
    current_room: data.current_room ?? 1,
    selected_template: data.selected_template ?? 'Standard',
    user_donator_tier: data.user_donator_tier ?? 0,
    user_ckey: data.user_ckey ?? '',
    active_rooms: data.active_rooms || [],
    conservated_rooms: data.conservated_rooms || [],
    hotel_map_list: data.hotel_map_list || [],
  };
  const [selectedTemplate, setSelectedTemplate] = useState(
    checkoutData.selected_template,
  );
  useEffect(() => {
    setSelectedTemplate(checkoutData.selected_template);
  }, [checkoutData.selected_template]);
  const categories = sortCategories(
    Array.from(
      new Set(
        checkoutData.hotel_map_list.map((room) => room.category || 'Misc'),
      ),
    ),
  );
  const [selectedCategory, setSelectedCategory] = useState(
    categories[0] || 'Misc',
  );
  const [searchText, setSearchText] = useState('');
  const [roomName, setRoomName] = useState('');
  useEffect(() => {
    if (categories.length && !categories.includes(selectedCategory)) {
      setSelectedCategory(categories[0]);
    }
  }, [categories, selectedCategory]);

  return (
    <Box
      style={{
        height: '100%',
        display: 'flex',
        flexDirection: 'column',
      }}
    >
      <RoomCheckIn
        data={checkoutData}
        act={act}
        selectedTemplate={selectedTemplate}
        setSelectedTemplate={setSelectedTemplate}
        selectedCategory={selectedCategory}
        setSelectedCategory={setSelectedCategory}
        categories={categories}
        searchText={searchText}
        setSearchText={setSearchText}
        roomName={roomName}
        setRoomName={setRoomName}
      />
      <Box
        style={{
          flex: 1,
          overflowY: 'auto',
          width: '100%',
          minHeight: 0, // This is important for Firefox
          scrollbarWidth: 'none',
        }}
      >
        <OpenRooms
          data={checkoutData}
          act={act}
          selected_template={selectedTemplate}
        />
        <ReservedRooms data={checkoutData} act={act} />
      </Box>
    </Box>
  );
};

const RoomsTab = (props) => {
  const { category, searchText, selected_template, setSelectedTemplate } =
    props;
  const { act, data } = useBackend<RoomsData>();
  const { hotel_map_list = [], user_ckey = '', user_donator_tier = 0 } = data;

  const targetCategory = category.toLowerCase();
  const searchQuery = searchText.trim().toLowerCase();
  const filteredRooms = hotel_map_list.filter(
    (room) => {
      const roomCategory = room.category || 'Misc';
      const canSeeRoom =
        !room.ckeywhitelist?.length || room.ckeywhitelist.includes(user_ckey);
      const matchesCategory = roomCategory.toLowerCase() === targetCategory;
      const matchesSearch =
        !searchQuery ||
        [room.name, roomCategory].join(' ').toLowerCase().includes(searchQuery);
      return canSeeRoom && matchesSearch && (searchQuery || matchesCategory);
    },
  );

  return (
    <Box
      style={{
        height: '100%',
        overflowY: 'auto',
        maxHeight: '15em',
        width: '100%',
      }}
    >
      {filteredRooms.length === 0 && (
        <NoticeBox>
          {searchQuery
            ? 'No room templates match your search.'
            : `No ${category} rooms found!`}
        </NoticeBox>
      )}
      <Stack vertical fill>
        {filteredRooms.map((room, index) => (
          <Box
            key={room.name}
            mb={index < filteredRooms.length - 1 ? '5px' : '0px'}
          >
            <Stack
              className={
                room.name === selected_template ? 'selected' : undefined
              }
              onClick={() => {
                setSelectedTemplate(room.name);
                act('select_room', { room: room.name });
              }}
              style={{
                lineHeight: '1.5',
                cursor: 'pointer',
                transition: 'background-color 0.2s',
                padding: '4px 4px',
                borderRadius: '2px',
                border: '1px solid rgba(150, 211, 150, 0.21)',
                backgroundColor:
                  room.name === selected_template
                    ? 'rgba(159, 212, 163, 0.64)'
                    : 'rgba(167, 212, 167, 0.1)',
              }}
            >
              <Stack.Item>
                {' '}
                <Icon
                  name={
                    CATEGORY_ICONS[room.category?.toLowerCase()] || 'door-open'
                  }
                  mr={2}
                  style={{ marginLeft: '5px', marginRight: '5px' }}
                />
              </Stack.Item>
              <Stack.Item grow>
                <Stack>
                  <Stack.Item>{room.name}</Stack.Item>
                  {room.donator_tier > user_donator_tier && (
                    <Stack.Item grow textAlign="right" color="red">
                      {' | Donator tier ' +
                        room.donator_tier +
                        ' access required'}
                    </Stack.Item>
                  )}
                </Stack>
              </Stack.Item>
            </Stack>
          </Box>
        ))}
      </Stack>
    </Box>
  );
};

export const HilbertsHotelCheckout = (props) => {
  const { act, data } = useBackend();

  return (
    <Window width={600} height={600} title="Dr. Hilbert's Hotel Room Reception">
      <Window.Content>
        <CheckoutMenu />
      </Window.Content>
    </Window>
  );
};
