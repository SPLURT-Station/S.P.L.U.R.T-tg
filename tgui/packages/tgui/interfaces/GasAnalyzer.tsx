import { useBackend } from '../backend';
import { Box, Section, Table } from '../components';
import { Window } from '../layouts';

export const GasAnalyzer = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    target_name,
    error,
    pressure,
    temperature,
    total_moles,
    gases = [],
  } = data;

  return (
    <Window
      title="Gas Analyzer"
      width={400}
      height={350}>
      <Window.Content>
        {error ? (
          <Section>{error}</Section>
        ) : (
          <Section title={target_name}>
            <Table>
              <Table.Row>
                <Table.Cell bold>Pressure:</Table.Cell>
                <Table.Cell>
                  {pressure ? pressure.toFixed(2) : 0} kPa
                </Table.Cell>
              </Table.Row>
              <Table.Row>
                <Table.Cell bold>Temperature:</Table.Cell>
                <Table.Cell>
                  {temperature ? temperature.toFixed(2) : 0} K ({temperature ? Math.round(temperature - 273.15) : 0} °C)
                </Table.Cell>
              </Table.Row>
              <Table.Row>
                <Table.Cell bold>Total Moles:</Table.Cell>
                <Table.Cell>
                  {total_moles ? total_moles.toFixed(2) : 0} mol
                </Table.Cell>
              </Table.Row>
            </Table>
            <Section title="Gases" level={2}>
              {gases.length === 0 ? (
                <Box color="good">No gases detected.</Box>
              ) : (
                <Table>
                  {gases.map(gas => (
                    <Table.Row key={gas.name}>
                      <Table.Cell bold>{gas.name}:</Table.Cell>
                      <Table.Cell>
                        {gas.moles ? gas.moles.toFixed(2) : 0} mol ({gas.percentage ? gas.percentage.toFixed(2) : 0}%)
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              )}
            </Section>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
