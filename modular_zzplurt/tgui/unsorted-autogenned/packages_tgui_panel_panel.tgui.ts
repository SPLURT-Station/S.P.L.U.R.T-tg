import type { ModularTguiPatch } from '../.';

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
				content: "\nimport { EmotesToolbar, useEmotes } from './emotes'; // SPLURT EDIT:  CUSTOM EMOTE PANEL",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  const game = useAtomValue(gameAtom);",
				position: "after",
				content: "\n  const emotes = useEmotes(); // SPLURT EDIT:  CUSTOM EMOTE PANEL",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "              </Stack.Item>\n              <Stack.Item>\n                <Button\n                  color=\"grey\"",
				content: "              </Stack.Item>\n              {/* SPLURT EDIT START:  CUSTOM EMOTE PANEL */}\n              <Stack.Item>\n                <Button\n                  color=\"grey\"",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "                  color=\"grey\"",
				position: "after",
				content: "\n                  selected={emotes.visible}\n                  icon=\"asterisk\"\n                  tooltip=\"Emote Panel\"\n                  tooltipPosition=\"bottom-start\"\n                  onClick={() => emotes.toggle()}\n                />\n              </Stack.Item>\n              {/* SPLURT EDIT END:  CUSTOM EMOTE PANEL */}\n              <Stack.Item>\n                <Button\n                  color=\"grey\"",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "        {audioVisible && (",
				position: "before",
				content: "        {/* SPLURT EDIT START:  CUSTOM EMOTE PANEL */}\n        {emotes.visible && (\n          <Stack.Item>\n            <Section>\n              <EmotesToolbar />\n            </Section>\n          </Stack.Item>\n        )}\n",
				expectedOccurrences: 1,
			},
		],
	},
];
