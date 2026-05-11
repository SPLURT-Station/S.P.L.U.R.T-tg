import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/ZubbersCharacterDirectory.jsx',
		operations: [
			{
				kind: "insert",
				anchor: "    personalNonconTag,",
				position: "after",
				content: "\n    // SPLURT EDIT START: EXTRA TAGS\n    personalExtremeTag,\n    personalExtremeHarmTag,\n    personalUnholyTag,\n    // SPLURT EDIT END: EXTRA TAGS",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "          </LabeledList>",
				position: "before",
				content: "            {/* SPLURT EDIT START: EXTRA TAGS */}\n            <LabeledList.Item label=\"Extreme\">\n              <Button fluid>{personalExtremeTag}</Button>\n            </LabeledList.Item>\n            <LabeledList.Item label=\"Extreme Harm\">\n              <Button fluid>{personalExtremeHarmTag}</Button>\n            </LabeledList.Item>\n            <LabeledList.Item label=\"Unholy\">\n              <Button fluid>{personalUnholyTag}</Button>\n            </LabeledList.Item>\n            {/* SPLURT EDIT END: EXTRA TAGS */}\n",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "          </SortButton>\n          <Table.Cell collapsing textAlign=\"right\">",
				content: "          </SortButton>\n          {/* SPLURT EDIT START: EXTRA TAGS */}\n          <SortButton\n            id=\"extreme\"\n            sortId={sortId}\n            sortOrder={sortOrder}\n            onClick={handleSort}\n          >\n            Extreme\n          </SortButton>\n          <SortButton\n            id=\"extremeharm\"\n            sortId={sortId}\n            sortOrder={sortOrder}\n            onClick={handleSort}\n          >\n            Extreme Harm\n          </SortButton>\n          <SortButton\n            id=\"unholy\"\n            sortId={sortId}\n            sortOrder={sortOrder}\n            onClick={handleSort}\n          >\n            Unholy\n          </SortButton>\n          {/* SPLURT EDIT END: EXTRA TAGS */}\n          <Table.Cell collapsing textAlign=\"right\">",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "            <Table.Cell>{character.noncon}</Table.Cell>",
				position: "after",
				content: "\n            {/* SPLURT EDIT START: EXTRA TAGS */}\n            <Table.Cell>{character.extreme}</Table.Cell>\n            <Table.Cell>{character.extremeharm}</Table.Cell>\n            <Table.Cell>{character.unholy}</Table.Cell>\n            {/* SPLURT EDIT END: EXTRA TAGS */}",
				expectedOccurrences: 1,
			},
		],
	},
];
