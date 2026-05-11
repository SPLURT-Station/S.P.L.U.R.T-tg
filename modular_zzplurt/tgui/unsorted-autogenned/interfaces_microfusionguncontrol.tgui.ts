import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/MicrofusionGunControl.jsx',
		operations: [
			{
				kind: "insert",
				anchor: "  Button,",
				position: "before",
				content: block`
				  Box, // SPLURT TEMPORARY FIX - No scrollwheel - Remove when fixed upstream
				
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "      height={700}",
				content: "      height={800} // SPLURT TEMPORARY FIX - No scrollwheel - Remove when fixed upstream",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: block`
				            <Section title={'Attachments'}>
				              {has_attachments ? (
				                attachments.map((attachment, index) => (
				                  <Section
				                    key={index}
				                    title={attachment.name}
				                    buttons={
				                      <Button
				                        icon="eject"
				                        content="Eject Attachment"
				                        onClick={() =>
				                          act('remove_attachment', {
				                            attachment_ref: attachment.ref,
				                          })
				                        }
				                      />
				                    }
				                  >
				                    <LabeledList>
				                      <LabeledList.Item label="Description">
				                        {attachment.desc}
				                      </LabeledList.Item>
				                      <LabeledList.Item label="Slot">
				                        {attachment.slot}
				                      </LabeledList.Item>
				                      {attachment.information && (
				                        <LabeledList.Item label="Information">
				                          {attachment.information}
				`,
				content: block`
				            <Section title={'Attachments'} fill>
				              {/* SPLURT TEMPORARY FIX - No scrollwheel - Remove when fixed upstream */}
				              <Box
				                style={{
				                  height: '200px',
				                  overflowY: 'auto',
				                  overflowX: 'hidden',
				                }}
				              >
				                {has_attachments ? (
				                  attachments.map((attachment, index) => (
				                    <Section
				                      key={index}
				                      title={attachment.name}
				                      buttons={
				                        <Button
				                          icon="eject"
				                          content="Eject Attachment"
				                          onClick={() =>
				                            act('remove_attachment', {
				                              attachment_ref: attachment.ref,
				                            })
				                          }
				                        />
				                      }
				                    >
				                      <LabeledList>
				                        <LabeledList.Item label="Description">
				                          {attachment.desc}
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: block`
				                      )}
				                      {!!attachment.has_modifications &&
				                        attachment.modify.map((mod, index) => (
				                          <LabeledList.Item
				                            key={index}
				                            buttons={
				                              <Button
				                                key={index}
				                                icon={mod.icon}
				                                color={mod.color}
				                                content={mod.title}
				                                onClick={() =>
				                                  act('modify_attachment', {
				                                    attachment_ref: attachment.ref,
				                                    modify_ref: mod.reference,
				                                  })
				                                }
				                              />
				                            }
				                          />
				                        ))}
				                    </LabeledList>
				                  </Section>
				                ))
				              ) : (
				                <NoticeBox color="blue">No attachments installed!</NoticeBox>
				              )}
				`,
				content: block`
				                        <LabeledList.Item label="Slot">
				                          {attachment.slot}
				                        </LabeledList.Item>
				                        {attachment.information && (
				                          <LabeledList.Item label="Information">
				                            {attachment.information}
				                          </LabeledList.Item>
				                        )}
				                        {!!attachment.has_modifications &&
				                          attachment.modify.map((mod, index) => (
				                            <LabeledList.Item
				                              key={index}
				                              buttons={
				                                <Button
				                                  key={index}
				                                  icon={mod.icon}
				                                  color={mod.color}
				                                  content={mod.title}
				                                  onClick={() =>
				                                    act('modify_attachment', {
				                                      attachment_ref: attachment.ref,
				                                      modify_ref: mod.reference,
				                                    })
				                                  }
				                                />
				                              }
				                            />
				                          ))}
				                      </LabeledList>
				                    </Section>
				                  ))
				                ) : (
				                  <NoticeBox color="blue">No attachments installed!</NoticeBox>
				                )}
				              </Box>
				              {/* SPLURT TEMPORARY FIX END*/}
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
