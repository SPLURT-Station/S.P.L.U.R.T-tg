import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui-panel/Panel.tsx',
		operations: [
			{
				kind: "insert",
				anchor: "import { useChatPersistence } from './chat/use-chat-persistence';",
				position: "after",
				content: block`
				
				import { EmotesToolbar, useEmotes } from './emotes'; // SPLURT EDIT:  CUSTOM EMOTE PANEL
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  const game = useAtomValue(gameAtom);",
				position: "after",
				content: block`
				
				  const emotes = useEmotes(); // SPLURT EDIT:  CUSTOM EMOTE PANEL
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: block`
				              </Stack.Item>
				              <Stack.Item>
				                <Button
				                  color="grey"
				`,
				content: block`
				              </Stack.Item>
				              {/* SPLURT EDIT START:  CUSTOM EMOTE PANEL */}
				              <Stack.Item>
				                <Button
				                  color="grey"
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "                  color=\"grey\"",
				position: "after",
				content: block`
				
				                  selected={emotes.visible}
				                  icon="asterisk"
				                  tooltip="Emote Panel"
				                  tooltipPosition="bottom-start"
				                  onClick={() => emotes.toggle()}
				                />
				              </Stack.Item>
				              {/* SPLURT EDIT END:  CUSTOM EMOTE PANEL */}
				              <Stack.Item>
				                <Button
				                  color="grey"
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "        {audioVisible && (",
				position: "before",
				content: block`
				        {/* SPLURT EDIT START:  CUSTOM EMOTE PANEL */}
				        {emotes.visible && (
				          <Stack.Item>
				            <Section>
				              <EmotesToolbar />
				            </Section>
				          </Stack.Item>
				        )}
				
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
