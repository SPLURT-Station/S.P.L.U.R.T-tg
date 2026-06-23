import {
  AnimatedNumber,
  Box,
  Button,
  Flex,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
  Slider,
} from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

interface TurbineData {
  connected: boolean;
  active: boolean;
  rpm: number;
  power: number;
  integrity: number;
  max_rpm: number;
  max_temperature: number;

  inlet_temp: number;
  rotor_temp: number;

  compressor_pressure: number;
  rotor_pressure: number;
  outlet_water_volume: number;
  compressor_too_cold: boolean;
  regulator: number;
  steam_consumption: number;

  target_rpm: number;
}

export const TrainTurbineComputer = () => {
  const { act, data } = useBackend<TurbineData>();
  const {
    connected,
    active,
    rpm,
    power,
    integrity,
    max_rpm,
    max_temperature,
    inlet_temp,
    rotor_temp,
    outlet_water_volume,
    compressor_too_cold,
    compressor_pressure,
    rotor_pressure,
    regulator,
    steam_consumption,
    target_rpm,
  } = data;

  if (!connected) {
    return (
      <Window width={800} height={500}>
        <Window.Content>
          <Section title="Ошибка соединения">
            <Box color="bad" fontSize="1.4rem" textAlign="center" mt={4}>
              <Icon name="exclamation-triangle" mr={2} />
              Турбина не обнаружена или собрана не полностью!
            </Box>
          </Section>
        </Window.Content>
      </Window>
    );
  }

  const tempWarning = rotor_temp > max_temperature * 0.9;
  const pressureWarning = rotor_pressure > 500;
  const integrityWarning = integrity < 30;
  const overload = rpm > max_rpm;

  const turbineColor =
    integrity < 30 ? 'bad' : integrity < 70 ? 'average' : 'good';

  const rotorGlow = rpm > max_rpm * 0.85 ? 'drop-shadow(0 0 12px orange)' : '';

  return (
    <Window width={1000} height={550} theme="retro">
      <Window.Content scrollable>
        <Flex direction="row" spacing={2} height="100%">
          {/* Левая колонка — статус и управление */}
          <Flex.Item grow={1} basis={0} minWidth="290px">
            <Section title="Статус турбины" mb={2}>
              <LabeledList>
                <LabeledList.Item label="Питание">
                  <Button
                    content={active ? 'ВКЛ' : 'ВЫКЛ'}
                    color={active ? 'good' : 'bad'}
                    icon={active ? 'power-off' : 'power-off'}
                    iconRotation={active ? 0 : 180}
                    onClick={() => act('toggle_power')}
                    disabled={active && rpm > 0}
                    fluid
                  />
                  {!!active && rpm > 0 && (
                    <Box inline color="bad" ml={1} fontSize="0.9rem">
                      <Icon name="lock" rotation={45} />
                      Остановите вращение перед выключением
                    </Box>
                  )}
                  {!!compressor_too_cold && (
                    <Box inline color="bad" ml={1} fontSize="0.9rem">
                      <Icon name="circle-exclamation" rotation={45} />
                      Пар/водяной пар на входе слишком холодный!
                    </Box>
                  )}
                </LabeledList.Item>

                <LabeledList.Item label="Целостность">
                  <ProgressBar
                    value={integrity / 100}
                    color={
                      integrityWarning
                        ? 'bad'
                        : integrity < 70
                          ? 'average'
                          : 'good'
                    }
                  >
                    <AnimatedNumber
                      value={integrity}
                      format={(v) => `${Math.round(v)}%`}
                    />{' '}
                    %
                  </ProgressBar>
                </LabeledList.Item>

                <LabeledList.Item label="Выходная мощность">
                  <Box fontSize="1.6rem" color="good">
                    <Icon name="bolt" mr={1} />
                    <AnimatedNumber
                      value={power}
                      format={(v) => Math.round(v).toLocaleString()}
                    />{' '}
                    кВт
                  </Box>
                </LabeledList.Item>
              </LabeledList>
            </Section>

            <Section title="Управление впуском пара">
              <LabeledList>
                <LabeledList.Item label="Регулятор впуска">
                  <Slider
                    minValue={0.01}
                    maxValue={1}
                    step={0.01}
                    stepPixelSize={10}
                    value={regulator}
                    onChange={(_, value) =>
                      act('regulate', { regulate: value })
                    }
                    format={(v) => `${(v * 100).toFixed(0)}%`}
                  />
                </LabeledList.Item>

                <LabeledList.Item labelWrap label="Расход пара">
                  <Flex direction="row" align="center">
                    <Button
                      icon="minus"
                      onClick={() =>
                        act('adjust_steam_rate', { adjust: -0.05 })
                      }
                    />
                    <Box
                      mx={2}
                      width="100px"
                      textAlign="center"
                      fontSize="1.2rem"
                    >
                      <AnimatedNumber
                        value={steam_consumption}
                        format={(v) => v.toFixed(2)}
                      />
                    </Box>
                    <Button
                      icon="plus"
                      onClick={() => act('adjust_steam_rate', { adjust: 0.05 })}
                    />
                  </Flex>
                  <Box fontSize="0.8rem" opacity={0.7} textAlign="center">
                    моль/тик (конденсация → вода)
                  </Box>
                </LabeledList.Item>

                <LabeledList.Item>
                  <Button
                    content="АВАРИЙНЫЙ СБРОС ГАЗА"
                    color="bad"
                    icon="exclamation-triangle"
                    onClick={() => act('emergency_vent')}
                    disabled={!active}
                    fluid
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Flex.Item>

          {/* Центральная визуализация турбины */}
          <Flex.Item grow={1.3} basis={0}>
            <Flex
              direction="column"
              align="center"
              justify="center"
              height="100%"
            >
              <Section
                title="Паровая турбина"
                backgroundColor={integrity < 30 ? '#330000' : undefined}
                p={4}
                textAlign="center"
              >
                <Box
                  fontFamily="monospace"
                  fontSize="1.7rem"
                  color={turbineColor}
                  lineHeight="1.2"
                  style={{
                    filter:
                      integrity < 50 ? 'drop-shadow(0 0 10px red)' : rotorGlow,
                  }}
                >
                  {'          █████████          '}
                  <br />
                  {'        ██═════════██        '}
                  <br />
                  {'       ██═══╦═══╦═══██       '}
                  <br />
                  {'      ██═══╦═══╦═══██      '}
                  <br />
                  {'     ██═════════════██     '}
                  <br />
                  {'    ██═══ РОТОР ════██    '}
                  <br />
                  {'     ██═════════════██     '}
                  <br />
                  {'      ██═══╦═══╦═══██      '}
                  <br />
                  {'       ██═══╩═══╩═══██       '}
                  <br />
                  {'        ██═════════██        '}
                  <br />
                  {'          █████████          '}
                </Box>

                <Box
                  mt={3}
                  fontSize="2.2rem"
                  bold
                  color={overload ? 'bad' : turbineColor}
                >
                  <AnimatedNumber
                    value={rpm}
                    format={(v) => Math.round(v).toLocaleString()}
                  />{' '}
                  об/мин
                </Box>

                <Box mt={2} width="280px">
                  <ProgressBar
                    value={rpm / max_rpm}
                    color={
                      overload
                        ? 'bad'
                        : rpm > max_rpm * 0.8
                          ? 'average'
                          : 'good'
                    }
                  >
                    {overload ? 'ПЕРЕГРУЗКА!' : 'Нормальная работа'}
                  </ProgressBar>
                </Box>

                <Box mt={2} fontSize="1.1rem" opacity={0.9}>
                  <Icon
                    name="thermometer-half"
                    mr={1}
                    color={tempWarning ? 'bad' : undefined}
                  />
                  Температура ротора: <AnimatedNumber value={rotor_temp} /> K
                </Box>
              </Section>
            </Flex>
          </Flex.Item>

          {/* Правая колонка — температуры, давление, целевые обороты */}
          <Flex.Item grow={1} basis={0} minWidth="290px">
            <Section title="Температуры" mb={2}>
              <LabeledList>
                <LabeledList.Item label="Вход (K)">
                  <ProgressBar
                    value={(inlet_temp - 273) / (max_temperature - 273)}
                    color="teal"
                  >
                    <AnimatedNumber value={inlet_temp} /> K
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item label="Ротор (K)">
                  <ProgressBar
                    value={rotor_temp / max_temperature}
                    color={tempWarning ? 'bad' : 'orange'}
                  >
                    <AnimatedNumber value={rotor_temp} /> / {max_temperature} K
                  </ProgressBar>
                </LabeledList.Item>
              </LabeledList>
            </Section>

            <Section title="Давление" mb={2}>
              <LabeledList>
                <LabeledList.Item label="Компрессор">
                  <ProgressBar value={compressor_pressure / 1000} color="good">
                    <AnimatedNumber value={compressor_pressure} /> кПа
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item label="Выход воды">
                  <ProgressBar value={outlet_water_volume} color="blue">
                    <AnimatedNumber value={outlet_water_volume} /> ед.
                  </ProgressBar>
                </LabeledList.Item>
              </LabeledList>
            </Section>

            <Section title="Целевые обороты">
              <Box textAlign="center" fontSize="1.3rem" mb={1}>
                <AnimatedNumber value={target_rpm} /> об/мин
              </Box>
              <Slider
                minValue={0}
                maxValue={max_rpm}
                step={100}
                stepPixelSize={4}
                value={target_rpm}
                onChange={(_, value) =>
                  act('set_target_rpm', { target: value })
                }
                unit="об/мин"
                height="28px"
                fontSize="1.1rem"
              />
              <Box textAlign="center" mt={1} opacity={0.8}>
                {((target_rpm / max_rpm) * 100).toFixed(1)}% от максимума (
                {max_rpm} об/мин)
              </Box>
            </Section>
          </Flex.Item>
        </Flex>

        {/* Критические предупреждения */}
        {(tempWarning || pressureWarning || integrityWarning || overload) && (
          <Section
            title="ВНИМАНИЕ!"
            backgroundColor="#660000"
            mt={2}
            textAlign="center"
          >
            <Flex spacing={2} justify="center">
              {overload && (
                <Box color="bad" bold>
                  <Icon name="bomb" mr={1} />
                  ПЕРЕГРУЗКА ОБОРОТОВ!
                </Box>
              )}
              {tempWarning && (
                <Box color="bad" bold>
                  <Icon name="fire" mr={1} />
                  ПЕРЕГРЕВ РОТОРА!
                </Box>
              )}
              {pressureWarning && (
                <Box color="bad" bold>
                  <Icon name="gauge-high" mr={1} />
                  КРИТИЧЕСКОЕ ДАВЛЕНИЕ!
                </Box>
              )}
              {integrityWarning && (
                <Box color="bad" bold>
                  <Icon name="heart-crack" mr={1} />
                  СТРУКТУРНЫЕ ПОВРЕЖДЕНИЯ!
                </Box>
              )}
            </Flex>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
