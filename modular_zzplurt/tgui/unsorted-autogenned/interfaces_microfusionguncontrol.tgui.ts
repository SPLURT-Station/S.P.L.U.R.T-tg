import type { ModularTguiPatch } from '../.';

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
				content: "  Box, // SPLURT TEMPORARY FIX - No scrollwheel - Remove when fixed upstream\n",
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
				anchor: "            <Section title={'Attachments'}>\n              {has_attachments ? (\n                attachments.map((attachment, index) => (\n                  <Section\n                    key={index}\n                    title={attachment.name}\n                    buttons={\n                      <Button\n                        icon=\"eject\"\n                        content=\"Eject Attachment\"\n                        onClick={() =>\n                          act('remove_attachment', {\n                            attachment_ref: attachment.ref,\n                          })\n                        }\n                      />\n                    }\n                  >\n                    <LabeledList>\n                      <LabeledList.Item label=\"Description\">\n                        {attachment.desc}\n                      </LabeledList.Item>\n                      <LabeledList.Item label=\"Slot\">\n                        {attachment.slot}\n                      </LabeledList.Item>\n                      {attachment.information && (\n                        <LabeledList.Item label=\"Information\">\n                          {attachment.information}",
				content: "            <Section title={'Attachments'} fill>\n              {/* SPLURT TEMPORARY FIX - No scrollwheel - Remove when fixed upstream */}\n              <Box\n                style={{\n                  height: '200px',\n                  overflowY: 'auto',\n                  overflowX: 'hidden',\n                }}\n              >\n                {has_attachments ? (\n                  attachments.map((attachment, index) => (\n                    <Section\n                      key={index}\n                      title={attachment.name}\n                      buttons={\n                        <Button\n                          icon=\"eject\"\n                          content=\"Eject Attachment\"\n                          onClick={() =>\n                            act('remove_attachment', {\n                              attachment_ref: attachment.ref,\n                            })\n                          }\n                        />\n                      }\n                    >\n                      <LabeledList>\n                        <LabeledList.Item label=\"Description\">\n                          {attachment.desc}",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "                      )}\n                      {!!attachment.has_modifications &&\n                        attachment.modify.map((mod, index) => (\n                          <LabeledList.Item\n                            key={index}\n                            buttons={\n                              <Button\n                                key={index}\n                                icon={mod.icon}\n                                color={mod.color}\n                                content={mod.title}\n                                onClick={() =>\n                                  act('modify_attachment', {\n                                    attachment_ref: attachment.ref,\n                                    modify_ref: mod.reference,\n                                  })\n                                }\n                              />\n                            }\n                          />\n                        ))}\n                    </LabeledList>\n                  </Section>\n                ))\n              ) : (\n                <NoticeBox color=\"blue\">No attachments installed!</NoticeBox>\n              )}",
				content: "                        <LabeledList.Item label=\"Slot\">\n                          {attachment.slot}\n                        </LabeledList.Item>\n                        {attachment.information && (\n                          <LabeledList.Item label=\"Information\">\n                            {attachment.information}\n                          </LabeledList.Item>\n                        )}\n                        {!!attachment.has_modifications &&\n                          attachment.modify.map((mod, index) => (\n                            <LabeledList.Item\n                              key={index}\n                              buttons={\n                                <Button\n                                  key={index}\n                                  icon={mod.icon}\n                                  color={mod.color}\n                                  content={mod.title}\n                                  onClick={() =>\n                                    act('modify_attachment', {\n                                      attachment_ref: attachment.ref,\n                                      modify_ref: mod.reference,\n                                    })\n                                  }\n                                />\n                              }\n                            />\n                          ))}\n                      </LabeledList>\n                    </Section>\n                  ))\n                ) : (\n                  <NoticeBox color=\"blue\">No attachments installed!</NoticeBox>\n                )}\n              </Box>\n              {/* SPLURT TEMPORARY FIX END*/}",
				expectedOccurrences: 1,
			},
		],
	},
];
