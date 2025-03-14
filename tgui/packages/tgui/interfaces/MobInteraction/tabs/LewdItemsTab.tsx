import { Button, Icon, Stack } from 'tgui-core/components';

import { useBackend } from '../../../backend';

type LewdItemsInfo = {
  lewd_slots: Array<{
    name: string;
    img: string | null;
    item_name?: string;
  }>;
  ref_user: string;
  ref_self: string;
};

type LewdItemsTabProps = {
  searchText: string;
};

export const LewdItemsTab = ({ searchText }: LewdItemsTabProps) => {
  const { act, data } = useBackend<LewdItemsInfo>();
  const { lewd_slots = [], ref_user, ref_self } = data;

  const filteredSlots = lewd_slots.filter((slot) => {
    const searchLower = searchText.toLowerCase();
    return (
      slot.name.toLowerCase().includes(searchLower) ||
      (slot.item_name && slot.item_name.toLowerCase().includes(searchLower))
    );
  });

  return (
    <Stack fill>
      {filteredSlots.map((slot) => (
        <Stack.Item key={slot.name}>
          <Button
            onClick={() =>
              act('item_slot', {
                item_slot: slot.name,
                selfref: ref_self,
                userref: ref_user,
              })
            }
            color="pink"
            tooltip={`${slot.name}${slot.item_name ? ` - ${slot.item_name}` : ''}`}
          >
            <Stack.Item>
              <div
                style={{
                  width: '32px',
                  height: '32px',
                  margin: '0.5em 0',
                }}
              >
                {slot.img ? (
                  <img
                    src={'data:image/png;base64,' + slot.img}
                    style={{
                      width: '100%',
                      height: '100%',
                    }}
                  />
                ) : (
                  <Icon
                    name="eye-slash"
                    size={2}
                    ml={0}
                    mt={0.75}
                    style={{
                      textAlign: 'center',
                    }}
                  />
                )}
              </div>
            </Stack.Item>
          </Button>
        </Stack.Item>
      ))}
    </Stack>
  );
};
