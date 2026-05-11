import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/BubberChangelog.jsx',
		operations: [
			{
				kind: "replace",
				anchor: "  const { contents, bubberContents } = props;",
				content: "  const { contents, bubberContents, splurtContents } = props; // SPLURT EDIT ADDITION: Changelog 3",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "    typeof bubberContents === 'object' ? bubberContents : {},",
				position: "after",
				content: "\n    typeof splurtContents === 'object' ? splurtContents : {}, // SPLURT EDIT ADDITION: Changelog 3",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "        <Box ml={3}>",
				position: "after",
				content: "\n          {/* SPLURT EDIT ADDITION: Changelog 3 */}\n          {splurtContents[date] && (\n            <Section mb={-2}>\n              {Object.entries(splurtContents[date]).map(([name, changes]) => (\n                <SplurtChangelogEntry\n                  key={name}\n                  author={name}\n                  changes={changes}\n                />\n              ))}\n            </Section>\n          )}\n          {/* SPLURT EDIT ADDITION END */}",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "export const BubberChangelog = (props) => {",
				position: "before",
				content: "// SPLURT EDIT ADDITION: Changelog 3\nconst SplurtChangelogEntry = (props) => {\n  const { author, changes } = props;\n\n  return (\n    <Stack.Item mb={-1} pb={1} key={author}>\n      <Box>\n        <h4>\n          <Image verticalAlign=\"bottom\" src={resolveAsset('splurt_16.png')} />{' '}\n          {author} changed:\n        </h4>\n      </Box>\n      <Box ml={3} mt={-0.2}>\n        <Table>\n          {changes.map((change) => {\n            const changeType = Object.keys(change)[0];\n            return (\n              <Table.Row key={changeType + change[changeType]}>\n                <Table.Cell\n                  className={classes([\n                    'Changelog__Cell',\n                    'Changelog__Cell--Icon',\n                  ])}\n                >\n                  <Icon\n                    color={\n                      icons[changeType]\n                        ? icons[changeType].color\n                        : icons.unknown.color\n                    }\n                    name={\n                      icons[changeType]\n                        ? icons[changeType].icon\n                        : icons.unknown.icon\n                    }\n                    verticalAlign=\"middle\"\n                  />\n                </Table.Cell>\n                <Table.Cell className=\"Changelog__Cell\">\n                  {change[changeType]}\n                </Table.Cell>\n              </Table.Row>\n            );\n          })}\n        </Table>\n      </Box>\n    </Stack.Item>\n  );\n};\n// SPLURT EDIT ADDITION END\n\n",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  const [bubberContents, setBubberContents] = useState('');",
				position: "after",
				content: "\n  const [splurtContents, setSplurtContents] = useState(''); // SPLURT EDIT ADDITION: Changelog 3",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "    setBubberContents('Loading changelog data...');",
				position: "after",
				content: "\n    setSplurtContents('Loading changelog data...'); // SPLURT EDIT ADDITION: Changelog 3",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "      fetch(resolveAsset(`bubber_${date}.yml`)),",
				position: "after",
				content: "\n      fetch(resolveAsset(`splurt_${date}.yml`)), // SPLURT EDIT ADDITION: Changelog 3",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "      const bubberResult = await links[1].text();",
				position: "after",
				content: "\n      const splurtResult = await links[2].text(); // SPLURT EDIT ADDITION: Changelog 3",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "      if (links[0].status !== 200 && links[1].status !== 200) {",
				content: "      // SPLURT EDIT ADDITION: Changelog 3\n      if (\n        links[0].status !== 200 &&\n        links[1].status !== 200 &&\n        links[2].status !== 200\n      ) {\n        // SPLURT EDIT ADDITION END",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "        setTimeout(() => {",
				position: "before",
				content: "        // SPLURT EDIT ADDITION: Changelog 3\n        setSplurtContents(\n          `Loading changelog data${'.'.repeat(attemptNumber + 3)}`,\n        );\n        // SPLURT EDIT ADDITION END\n",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "        }\n      }",
				content: "        }\n        // SPLURT EDIT ADDITION: Changelog 3\n        if (links[2].status === 200) {\n          setSplurtContents(\n            yaml.load(splurtResult, { schema: yaml.CORE_SCHEMA }),\n          );\n        }\n        // SPLURT EDIT ADDITION END\n      }",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "      <h1>Bubberstation 13</h1>",
				content: "      <h1>S.P.L.U.R.T-tg</h1> {/* SPLURT EDIT ADDITION: Changelog 3 */}",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "        <a href=\"https://github.com/orgs/Bubberstation/people\">here</a>",
				content: "        <a href=\"https://github.com/orgs/SPLURT-Station/people\">here</a>",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "        <a href=\"https://github.com/Bubberstation/Bubberstation/pulse/monthly\">",
				content: "        <a href=\"https://github.com/SPLURT-Station/S.P.L.U.R.T-tg/pulse/monthly\">",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "        <a href=\"https://discord.com/invite/AvjrTqnqEx\">here</a>!",
				content: "        <a href=\"https://discord.com/invite/wynHVMzHzC\">here</a>!",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "      <Section title=\"Bubberstation 13\">",
				content: "      <Section title=\"S.P.L.U.R.T-tg\">",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "          <a href=\"https://github.com/bubberstation/bubberstation/blob/master/LICENSE\">",
				content: "          <a href=\"https://github.com/SPLURT-Station/S.P.L.U.R.T-tg/blob/master/LICENSE\">",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "          Bubberstation and /tg/station 13 are thankful to the GoonStation 13\n          Development Team for its work on the game up to the",
				content: "          S.P.L.U.R.T, Bubberstation and /tg/station 13 are thankful to the\n          GoonStation 13 Development Team for its work on the game up to the",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "        <ChangelogList contents={contents} bubberContents={bubberContents} />",
				content: "        {/* SPLURT EDIT ADDITION: Changelog 3 */}\n        <ChangelogList\n          contents={contents}\n          bubberContents={bubberContents}\n          splurtContents={splurtContents}\n        />\n        {/* SPLURT EDIT ADDITION END */}",
				expectedOccurrences: 1,
			},
		],
	},
];
