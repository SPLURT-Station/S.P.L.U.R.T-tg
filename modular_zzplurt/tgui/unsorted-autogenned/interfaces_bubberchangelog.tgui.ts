import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

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
				content: block`
				
				    typeof splurtContents === 'object' ? splurtContents : {}, // SPLURT EDIT ADDITION: Changelog 3
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "        <Box ml={3}>",
				position: "after",
				content: block`
				
				          {/* SPLURT EDIT ADDITION: Changelog 3 */}
				          {splurtContents[date] && (
				            <Section mb={-2}>
				              {Object.entries(splurtContents[date]).map(([name, changes]) => (
				                <SplurtChangelogEntry
				                  key={name}
				                  author={name}
				                  changes={changes}
				                />
				              ))}
				            </Section>
				          )}
				          {/* SPLURT EDIT ADDITION END */}
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "export const BubberChangelog = (props) => {",
				position: "before",
				content: block`
				// SPLURT EDIT ADDITION: Changelog 3
				const SplurtChangelogEntry = (props) => {
				  const { author, changes } = props;
				
				  return (
				    <Stack.Item mb={-1} pb={1} key={author}>
				      <Box>
				        <h4>
				          <Image verticalAlign="bottom" src={resolveAsset('splurt_16.png')} />{' '}
				          {author} changed:
				        </h4>
				      </Box>
				      <Box ml={3} mt={-0.2}>
				        <Table>
				          {changes.map((change) => {
				            const changeType = Object.keys(change)[0];
				            return (
				              <Table.Row key={changeType + change[changeType]}>
				                <Table.Cell
				                  className={classes([
				                    'Changelog__Cell',
				                    'Changelog__Cell--Icon',
				                  ])}
				                >
				                  <Icon
				                    color={
				                      icons[changeType]
				                        ? icons[changeType].color
				                        : icons.unknown.color
				                    }
				                    name={
				                      icons[changeType]
				                        ? icons[changeType].icon
				                        : icons.unknown.icon
				                    }
				                    verticalAlign="middle"
				                  />
				                </Table.Cell>
				                <Table.Cell className="Changelog__Cell">
				                  {change[changeType]}
				                </Table.Cell>
				              </Table.Row>
				            );
				          })}
				        </Table>
				      </Box>
				    </Stack.Item>
				  );
				};
				// SPLURT EDIT ADDITION END
				
				
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  const [bubberContents, setBubberContents] = useState('');",
				position: "after",
				content: block`
				
				  const [splurtContents, setSplurtContents] = useState(''); // SPLURT EDIT ADDITION: Changelog 3
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "    setBubberContents('Loading changelog data...');",
				position: "after",
				content: block`
				
				    setSplurtContents('Loading changelog data...'); // SPLURT EDIT ADDITION: Changelog 3
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "      fetch(resolveAsset(`bubber_${date}.yml`)),",
				position: "after",
				content: block`
				
				      fetch(resolveAsset(\`splurt_\${date}.yml\`)), // SPLURT EDIT ADDITION: Changelog 3
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "      const bubberResult = await links[1].text();",
				position: "after",
				content: block`
				
				      const splurtResult = await links[2].text(); // SPLURT EDIT ADDITION: Changelog 3
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "      if (links[0].status !== 200 && links[1].status !== 200) {",
				content: block`
				      // SPLURT EDIT ADDITION: Changelog 3
				      if (
				        links[0].status !== 200 &&
				        links[1].status !== 200 &&
				        links[2].status !== 200
				      ) {
				        // SPLURT EDIT ADDITION END
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "        setTimeout(() => {",
				position: "before",
				content: block`
				        // SPLURT EDIT ADDITION: Changelog 3
				        setSplurtContents(
				          \`Loading changelog data\${'.'.repeat(attemptNumber + 3)}\`,
				        );
				        // SPLURT EDIT ADDITION END
				
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: block`
				        }
				      }
				`,
				content: block`
				        }
				        // SPLURT EDIT ADDITION: Changelog 3
				        if (links[2].status === 200) {
				          setSplurtContents(
				            yaml.load(splurtResult, { schema: yaml.CORE_SCHEMA }),
				          );
				        }
				        // SPLURT EDIT ADDITION END
				      }
				`,
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
				anchor: block`
				          Bubberstation and /tg/station 13 are thankful to the GoonStation 13
				          Development Team for its work on the game up to the
				`,
				content: block`
				          S.P.L.U.R.T, Bubberstation and /tg/station 13 are thankful to the
				          GoonStation 13 Development Team for its work on the game up to the
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "        <ChangelogList contents={contents} bubberContents={bubberContents} />",
				content: block`
				        {/* SPLURT EDIT ADDITION: Changelog 3 */}
				        <ChangelogList
				          contents={contents}
				          bubberContents={bubberContents}
				          splurtContents={splurtContents}
				        />
				        {/* SPLURT EDIT ADDITION END */}
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
