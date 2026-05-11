import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

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
				content: block`
				
				    // SPLURT EDIT START: EXTRA TAGS
				    personalExtremeTag,
				    personalExtremeHarmTag,
				    personalUnholyTag,
				    // SPLURT EDIT END: EXTRA TAGS
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "          </LabeledList>",
				position: "before",
				content: block`
				            {/* SPLURT EDIT START: EXTRA TAGS */}
				            <LabeledList.Item label="Extreme">
				              <Button fluid>{personalExtremeTag}</Button>
				            </LabeledList.Item>
				            <LabeledList.Item label="Extreme Harm">
				              <Button fluid>{personalExtremeHarmTag}</Button>
				            </LabeledList.Item>
				            <LabeledList.Item label="Unholy">
				              <Button fluid>{personalUnholyTag}</Button>
				            </LabeledList.Item>
				            {/* SPLURT EDIT END: EXTRA TAGS */}
				
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: block`
				          </SortButton>
				          <Table.Cell collapsing textAlign="right">
				`,
				content: block`
				          </SortButton>
				          {/* SPLURT EDIT START: EXTRA TAGS */}
				          <SortButton
				            id="extreme"
				            sortId={sortId}
				            sortOrder={sortOrder}
				            onClick={handleSort}
				          >
				            Extreme
				          </SortButton>
				          <SortButton
				            id="extremeharm"
				            sortId={sortId}
				            sortOrder={sortOrder}
				            onClick={handleSort}
				          >
				            Extreme Harm
				          </SortButton>
				          <SortButton
				            id="unholy"
				            sortId={sortId}
				            sortOrder={sortOrder}
				            onClick={handleSort}
				          >
				            Unholy
				          </SortButton>
				          {/* SPLURT EDIT END: EXTRA TAGS */}
				          <Table.Cell collapsing textAlign="right">
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "            <Table.Cell>{character.noncon}</Table.Cell>",
				position: "after",
				content: block`
				
				            {/* SPLURT EDIT START: EXTRA TAGS */}
				            <Table.Cell>{character.extreme}</Table.Cell>
				            <Table.Cell>{character.extremeharm}</Table.Cell>
				            <Table.Cell>{character.unholy}</Table.Cell>
				            {/* SPLURT EDIT END: EXTRA TAGS */}
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
