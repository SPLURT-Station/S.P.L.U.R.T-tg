import dateformat from 'dateformat';
import yaml from 'js-yaml';
import { useEffect, useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Icon,
  Image,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Window } from '../layouts';

const icons = {
  add: { icon: 'check-circle', color: 'green' },
  admin: { icon: 'user-shield', color: 'purple' },
  balance: { icon: 'balance-scale-right', color: 'yellow' },
  bugfix: { icon: 'bug', color: 'green' },
  code_imp: { icon: 'code', color: 'green' },
  config: { icon: 'cogs', color: 'purple' },
  expansion: { icon: 'check-circle', color: 'green' },
  experiment: { icon: 'radiation', color: 'yellow' },
  image: { icon: 'image', color: 'green' },
  imageadd: { icon: 'tg-image-plus', color: 'green' },
  imagedel: { icon: 'tg-image-minus', color: 'red' },
  qol: { icon: 'hand-holding-heart', color: 'green' },
  refactor: { icon: 'tools', color: 'green' },
  rscadd: { icon: 'check-circle', color: 'green' },
  rscdel: { icon: 'times-circle', color: 'red' },
  server: { icon: 'server', color: 'purple' },
  sound: { icon: 'volume-high', color: 'green' },
  soundadd: { icon: 'tg-sound-plus', color: 'green' },
  sounddel: { icon: 'tg-sound-minus', color: 'red' },
  spellcheck: { icon: 'spell-check', color: 'green' },
  map: { icon: 'map', color: 'green' },
  tgs: { icon: 'toolbox', color: 'purple' },
  tweak: { icon: 'wrench', color: 'green' },
  unknown: { icon: 'info-circle', color: 'label' },
  wip: { icon: 'hammer', color: 'orange' },
};

const DateDropdown = (props) => {
  const { dates, selectedDate, setSelectedDate } = props;
  const [selectedIndex, setSelectedIndex] = useState(0);

  return (
    dates.length > 0 && (
      <Stack mb={1}>
        <Stack.Item>
          <Button
            className="Changelog__Button"
            disabled={selectedIndex === 0}
            icon={'chevron-left'}
            onClick={() => {
              const index = selectedIndex - 1;

              setSelectedIndex(index);
              setSelectedDate(dates[index]);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight,
              );
            }}
          />
        </Stack.Item>
        <Stack.Item>
          <Dropdown
            autoScroll={false}
            options={dates}
            onSelected={(value) => {
              const index = dates.indexOf(value);

              setSelectedIndex(index);
              setSelectedDate(value);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight,
              );
            }}
            selected={selectedDate}
            width="150px"
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            className="Changelog__Button"
            disabled={selectedIndex === dates.length - 1}
            icon={'chevron-right'}
            onClick={() => {
              const index = selectedIndex + 1;

              setSelectedIndex(index);
              setSelectedDate(dates[index]);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight,
              );
            }}
          />
        </Stack.Item>
      </Stack>
    )
  );
};

const ChangelogList = (props) => {
  const { contents, bubberContents, splurtContents } = props; // SPLURT EDIT ADDITION: Changelog 3

  const combinedDates = {};
  Object.assign(
    combinedDates,
    typeof contents === 'object' ? contents : {},
    typeof bubberContents === 'object' ? bubberContents : {},
    typeof splurtContents === 'object' ? splurtContents : {}, // SPLURT EDIT ADDITION: Changelog 3
  );

  if (Object.keys(combinedDates).length < 1) {
    return <p>{contents}</p>;
  }

  return Object.keys(combinedDates)
    .sort()
    .reverse()
    .map((date) => (
      <Section key={date} title={dateformat(date, 'd mmmm yyyy', true)} pb={1}>
        <Box ml={3}>
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
          {bubberContents[date] && (
            <Section mb={-2}>
              {Object.entries(bubberContents[date]).map(([name, changes]) => (
                <BubberChangelogEntry
                  key={name}
                  author={name}
                  changes={changes}
                />
              ))}
            </Section>
          )}
          {contents[date] && (
            <Section mt={-1}>
              {Object.entries(contents[date]).map(([name, changes]) => (
                <ChangelogEntry key={name} author={name} changes={changes} />
              ))}
            </Section>
          )}
        </Box>
      </Section>
    ));
};

const BubberChangelogEntry = (props) => {
  const { author, changes } = props;

  return (
    <Stack.Item mb={-1} pb={1} key={author}>
      <Box>
        <h4>
          <Image verticalAlign="bottom" src={resolveAsset('bubber_16.png')} />{' '}
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
                        : icons['unknown'].color
                    }
                    name={
                      icons[changeType]
                        ? icons[changeType].icon
                        : icons['unknown'].icon
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

const ChangelogEntry = (props) => {
  const { author, changes } = props;

  return (
    <Stack.Item mb={-1} pb={1} key={author}>
      <Box>
        <h4>
          <Image verticalAlign="bottom" src={resolveAsset('tg_16.png')} />{' '}
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
                        : icons['unknown'].color
                    }
                    name={
                      icons[changeType]
                        ? icons[changeType].icon
                        : icons['unknown'].icon
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
                        : icons['unknown'].color
                    }
                    name={
                      icons[changeType]
                        ? icons[changeType].icon
                        : icons['unknown'].icon
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

export const BubberChangelog = (props) => {
  const { data } = useBackend();
  const { dates } = data;
  const [contents, setContents] = useState('');
  const [bubberContents, setBubberContents] = useState('');
  const [splurtContents, setSplurtContents] = useState(''); // SPLURT EDIT ADDITION: Changelog 3
  const [selectedDate, setSelectedDate] = useState(dates[0]);

  useEffect(() => {
    setContents('Loading changelog data...');
    setBubberContents('Loading changelog data...');
    setSplurtContents('Loading changelog data...'); // SPLURT EDIT ADDITION: Changelog 3
    getData(selectedDate);
  }, [selectedDate]);

  function getData(date, attemptNumber = 1) {
    const { act } = useBackend();
    const maxAttempts = 6;

    if (attemptNumber > maxAttempts) {
      setContents('Failed to load data after ' + maxAttempts + ' attempts.');
      return;
    }

    act('get_month', { date });

    Promise.all([
      fetch(resolveAsset(date + '.yml')),
      fetch(resolveAsset('bubber_' + date + '.yml')),
      fetch(resolveAsset('splurt_' + date + '.yml')), // SPLURT EDIT ADDITION: Changelog 3
    ]).then(async (links) => {
      const result = await links[0].text();
      const bubberResult = await links[1].text();
      const splurtResult = await links[2].text(); // SPLURT EDIT ADDITION: Changelog 3

      // SPLURT EDIT ADDITION: Changelog 3
      if (
        links[0].status !== 200 &&
        links[1].status !== 200 &&
        links[2].status !== 200
      ) {
        // SPLURT EDIT ADDITION END
        const timeout = 50 + attemptNumber * 50;

        setContents('Loading changelog data' + '.'.repeat(attemptNumber + 3));
        setBubberContents(
          'Loading changelog data' + '.'.repeat(attemptNumber + 3),
        );
        // SPLURT EDIT ADDITION: Changelog 3
        setSplurtContents(
          'Loading changelog data' + '.'.repeat(attemptNumber + 3),
        );
        // SPLURT EDIT ADDITION END
        setTimeout(() => {
          getData(date, attemptNumber + 1);
        }, timeout);
      } else {
        if (links[0].status === 200) {
          setContents(yaml.load(result, { schema: yaml.CORE_SCHEMA }));
        }
        if (links[1].status === 200) {
          setBubberContents(
            yaml.load(bubberResult, { schema: yaml.CORE_SCHEMA }),
          );
        }
        // SPLURT EDIT ADDITION: Changelog 3
        if (links[2].status === 200) {
          setSplurtContents(
            yaml.load(splurtResult, { schema: yaml.CORE_SCHEMA }),
          );
        }
        // SPLURT EDIT ADDITION END
      }
    });
  }

  const header = (
    <Section>
      <h1>S.P.L.U.R.T-tg</h1> {/* SPLURT EDIT ADDITION: Changelog 3 */}
      <p>
        <b>Thanks to: </b>
        /tg/station 13, Effigy, Stellar Haven, Baystation 12, /vg/station,
        NTstation, CDK Station devs, FacepunchStation, GoonStation devs, the
        original Space Station 13 developers, and the countless others who have
        contributed to the game.
      </p>
      <p>
        {'Current organization members can be found '}
        <a href="https://github.com/orgs/SPLURT-Station/people">here</a>
        {', recent GitHub contributors can be found '}
        <a href="https://github.com/SPLURT-Station/S.P.L.U.R.T-tg/pulse/monthly">
          here
        </a>
        .
      </p>
      <p>
        {'You can also join our discord '}
        <a href="https://discord.com/invite/wynHVMzHzC">here</a>!
      </p>
      <DateDropdown
        dates={dates}
        selectedDate={selectedDate}
        setSelectedDate={setSelectedDate}
      />
    </Section>
  );

  const footer = (
    <Section>
      <DateDropdown
        dates={dates}
        selectedDate={selectedDate}
        setSelectedDate={setSelectedDate}
      />
      <h2>Licenses</h2>
      <Section title="S.P.L.U.R.T-tg">
        <p>
          {'All code is licensed under '}
          <a href="https://www.gnu.org/licenses/agpl-3.0.html">GNU AGPL v3</a>.
          {' See '}
          <a href="https://github.com/SPLURT-Station/S.P.L.U.R.T-tg/blob/master/LICENSE">
            LICENSE
          </a>{' '}
          for more details.
        </p>
        <p>
          {'All assets including icons and sound are under a '}
          <a href="https://creativecommons.org/licenses/by-sa/3.0/">
            Creative Commons 3.0 BY-SA license
          </a>
          {' unless otherwise indicated.'}
        </p>
      </Section>
      <Section title="TGS">
        <p>
          The TGS DMAPI API is licensed as a subproject under the MIT license.
        </p>
        <p>
          {' See the footer of '}
          <a
            href={
              'https://github.com/tgstation/tgstation/blob/master' +
              '/code/__DEFINES/tgs.dm'
            }
          >
            code/__DEFINES/tgs.dm
          </a>
          {' and '}
          <a
            href={
              'https://github.com/tgstation/tgstation/blob/master' +
              '/code/modules/tgs/LICENSE'
            }
          >
            code/modules/tgs/LICENSE
          </a>
          {' for the MIT license.'}
        </p>
      </Section>
      <Section title="/tg/station 13">
        <p>
          {'All code after '}
          <a
            href={
              'https://github.com/tgstation/tgstation/commit/' +
              '333c566b88108de218d882840e61928a9b759d8f'
            }
          >
            commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at
            4:38 PM PST
          </a>
          {' is licensed under '}
          <a href="https://www.gnu.org/licenses/agpl-3.0.html">GNU AGPL v3</a>.
        </p>
        <p>
          {'All code before that commit is licensed under '}
          <a href="https://www.gnu.org/licenses/gpl-3.0.html">GNU GPL v3</a>
          {', including tools unless their readme specifies otherwise. See '}
          <a href="https://github.com/tgstation/tgstation/blob/master/LICENSE">
            LICENSE
          </a>
          {' and '}
          <a href="https://github.com/tgstation/tgstation/blob/master/GPLv3.txt">
            GPLv3.txt
          </a>
          {' for more details.'}
        </p>
        <p>
          {'All assets including icons and sound are under a '}
          <a href="https://creativecommons.org/licenses/by-sa/3.0/">
            Creative Commons 3.0 BY-SA license
          </a>
          {' unless otherwise indicated.'}
        </p>
      </Section>
      <Section title="Goonstation SS13">
        <p>
          <b>Coders: </b>
          Stuntwaffle, Showtime, Pantaloons, Nannek, Keelin, Exadv1, hobnob,
          Justicefries, 0staf, sniperchance, AngriestIBM, BrianOBlivion
        </p>
        <p>
          <b>Spriters: </b>
          Supernorn, Haruhi, Stuntwaffle, Pantaloons, Rho, SynthOrange, I Said
          No
        </p>
        <p>
          S.P.L.U.R.T, Bubberstation and /tg/station 13 are thankful to the
          GoonStation 13 Development Team for its work on the game up to the
          {' r4407 release. The changelog for changes up to r4407 can be seen '}
          <a href="https://wiki.ss13.co/Pre-2016_Changelog#April_2010">here</a>.
        </p>
        <p>
          {'Except where otherwise noted, Goon Station 13 is licensed under a '}
          <a href="https://creativecommons.org/licenses/by-nc-sa/3.0/">
            Creative Commons Attribution-Noncommercial-Share Alike 3.0 License
          </a>
          .
        </p>
        <p>
          {'Rights are currently extended to '}
          <a href="http://forums.somethingawful.com/">SomethingAwful Goons</a>
          {' only.'}
        </p>
      </Section>
    </Section>
  );

  return (
    <Window title="Changelog" width={730} height={700}>
      <Window.Content scrollable>
        {header}
        {/* SPLURT EDIT ADDITION: Changelog 3 */}
        <ChangelogList
          contents={contents}
          bubberContents={bubberContents}
          splurtContents={splurtContents}
        />
        {/* SPLURT EDIT ADDITION END */}
        {footer}
      </Window.Content>
    </Window>
  );
};
