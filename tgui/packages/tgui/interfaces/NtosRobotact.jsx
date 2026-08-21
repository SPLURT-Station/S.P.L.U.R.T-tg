import { useState } from 'react';
import {
  AnimatedNumber,
  Box,
  Button,
  Collapsible,
  Flex,
  LabeledList,
  NoticeBox,
  NumberInput,
  ProgressBar,
  Section,
  Slider,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { formatEnergy, formatPower } from 'tgui-core/format';

import { useBackend } from '../backend';
import { NtosWindow } from '../layouts';

export const NtosRobotact = (props) => {
  return (
    <NtosWindow width={800} height={600}>
      <NtosWindow.Content>
        <NtosRobotactContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosRobotactContent = (props) => {
  const { act, data } = useBackend();
  const [tab_main, setTab_main] = useState(1);
  const [tab_sub, setTab_sub] = useState(1);
  const {
    charge,
    maxcharge,
    integrity,
    lampIntensity,
    lampConsumption,
    cover,
    locomotion,
    wireModule,
    wireCamera,
    wireAI,
    wireLaw,
    sensors,
    printerPictures,
    printerToner,
    printerTonerMax,
    thrustersInstalled,
    thrustersStatus,
    selfDestructAble,
    cyborg_groups = [],
    masterAI_online,
    MasterAI_connected,
  } = data;
  const borgName = data.borgName || [];
  const borgType = data.designation || [];
  const masterAI = data.masterAI || [];
  const laws = data.Laws || [];
  const borgLog = data.borgLog || [];
  const borgUpgrades = data.borgUpgrades || [];

  return (
    <Flex direction={'column'}>
      <Flex.Item position="relative" mb={1}>
        <Tabs>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab_main === 1}
            onClick={() => setTab_main(1)}
          >
            Status
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab_main === 2}
            onClick={() => setTab_main(2)}
          >
            Logs
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab_main === 3}
            onClick={() => setTab_main(3)}
          >
            Network
          </Tabs.Tab>
        </Tabs>
      </Flex.Item>
      {tab_main === 1 && (
        <>
          <Flex direction={'row'}>
            <Flex.Item width="30%">
              <Section title="Configuration" fill>
                <LabeledList>
                  <LabeledList.Item label="Unit">
                    {borgName.slice(0, 17)}
                  </LabeledList.Item>
                  <LabeledList.Item label="Type">{borgType}</LabeledList.Item>
                  <LabeledList.Item label="AI">
                    {masterAI.slice(0, 17)}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            </Flex.Item>
            <Flex.Item grow={1} basis="content" ml={1}>
              <Section title="Status">
                Charge:
                <Button
                  content="Power Alert"
                  disabled={charge}
                  onClick={() => act('alertPower')}
                />
                <ProgressBar
                  value={charge / maxcharge}
                  ranges={{
                    good: [0.5, Infinity],
                    average: [0.1, 0.5],
                    bad: [-Infinity, 0.1],
                  }}
                >
                  <AnimatedNumber
                    value={charge}
                    format={(charge) => formatEnergy(charge)}
                  />
                </ProgressBar>
                Chassis Integrity:
                <ProgressBar
                  value={integrity}
                  minValue={0}
                  maxValue={100}
                  ranges={{
                    bad: [-Infinity, 25],
                    average: [25, 75],
                    good: [75, Infinity],
                  }}
                />
              </Section>
              <Section title="Lamp Power">
                <Slider
                  value={lampIntensity}
                  step={1}
                  stepPixelSize={25}
                  maxValue={5}
                  minValue={1}
                  onChange={(e, value) =>
                    act('lampIntensity', {
                      ref: value,
                    })
                  }
                />
                Lamp power usage: {formatPower(lampIntensity * lampConsumption)}
              </Section>
            </Flex.Item>
            <Flex.Item width="50%" ml={1}>
              <Section fitted>
                <Tabs fluid={1} textAlign="center">
                  <Tabs.Tab
                    icon=""
                    lineHeight="23px"
                    selected={tab_sub === 1}
                    onClick={() => setTab_sub(1)}
                  >
                    Actions
                  </Tabs.Tab>
                  <Tabs.Tab
                    icon=""
                    lineHeight="23px"
                    selected={tab_sub === 2}
                    onClick={() => setTab_sub(2)}
                  >
                    Upgrades
                  </Tabs.Tab>
                  <Tabs.Tab
                    icon=""
                    lineHeight="23px"
                    selected={tab_sub === 3}
                    onClick={() => setTab_sub(3)}
                  >
                    Diagnostics
                  </Tabs.Tab>
                </Tabs>
              </Section>
              {tab_sub === 1 && (
                <Section>
                  <LabeledList>
                    <LabeledList.Item label="Maintenance Cover">
                      <Button.Confirm
                        content="Unlock"
                        disabled={cover === 'UNLOCKED'}
                        onClick={() => act('coverunlock')}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Sensor Overlay">
                      <Button
                        content={sensors}
                        onClick={() => act('toggleSensors')}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item
                      label={`Stored Photos (${printerPictures})`}
                    >
                      <Button
                        content="View"
                        disabled={!printerPictures}
                        onClick={() => act('viewImage')}
                      />
                      <Button
                        content="Print"
                        disabled={!printerPictures}
                        onClick={() => act('printImage')}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Printer Toner">
                      <ProgressBar value={printerToner / printerTonerMax} />
                    </LabeledList.Item>
                    {!!thrustersInstalled && (
                      <LabeledList.Item label="Toggle Thrusters">
                        <Button
                          content={thrustersStatus}
                          onClick={() => act('toggleThrusters')}
                        />
                      </LabeledList.Item>
                    )}
                    {!!selfDestructAble && (
                      <LabeledList.Item label="Self Destruct">
                        <Button.Confirm
                          content="ACTIVATE"
                          color="red"
                          onClick={() => act('selfDestruct')}
                        />
                      </LabeledList.Item>
                    )}
                  </LabeledList>
                </Section>
              )}
              {tab_sub === 2 && (
                <Section>
                  {borgUpgrades.map((upgrade) => (
                    <Box mb={1} key={upgrade}>
                      {upgrade}
                    </Box>
                  ))}
                </Section>
              )}
              {tab_sub === 3 && (
                <Section>
                  <LabeledList>
                    <LabeledList.Item
                      label="AI Connection"
                      color={
                        wireAI === 'FAULT'
                          ? 'red'
                          : wireAI === 'READY'
                            ? 'yellow'
                            : 'green'
                      }
                    >
                      {wireAI}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="LawSync"
                      color={wireLaw === 'FAULT' ? 'red' : 'green'}
                    >
                      {wireLaw}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="Camera"
                      color={
                        wireCamera === 'FAULT'
                          ? 'red'
                          : wireCamera === 'DISABLED'
                            ? 'yellow'
                            : 'green'
                      }
                    >
                      {wireCamera}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="Module Controller"
                      color={wireModule === 'FAULT' ? 'red' : 'green'}
                    >
                      {wireModule}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="Motor Controller"
                      color={
                        locomotion === 'FAULT'
                          ? 'red'
                          : locomotion === 'DISABLED'
                            ? 'yellow'
                            : 'green'
                      }
                    >
                      {locomotion}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="Maintenance Cover"
                      color={cover === 'UNLOCKED' ? 'red' : 'green'}
                    >
                      {cover}
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              )}
            </Flex.Item>
          </Flex>
          <Flex.Item height={21} mt={1}>
            <Section
              title="Laws"
              fill
              scrollable
              buttons={
                <>
                  <Button
                    content="State Laws"
                    onClick={() => act('lawstate')}
                  />
                  <Button icon="volume-off" onClick={() => act('lawchannel')} />
                </>
              }
            >
              {laws.map((law) => (
                <Box mb={1} key={law}>
                  {law}
                </Box>
              ))}
            </Section>
          </Flex.Item>
        </>
      )}
      {tab_main === 2 && (
        <Flex.Item height={40}>
          <Section fill scrollable backgroundColor="black">
            {borgLog.map((log) => (
              <Box mb={1} key={log}>
                <font color="green">{log}</font>
              </Box>
            ))}
          </Section>
        </Flex.Item>
      )}
      {tab_main === 3 && (
        <Flex.Item height={40}>
          <Section
            title={MasterAI_connected ? masterAI : 'NOT CONFIGURED'}
            textAlign="center"
          >
            <LabeledList>
              <LabeledList.Item label="Status">
                <Box color={masterAI_online ? 'good' : 'bad'}>
                  {!MasterAI_connected
                    ? 'No Conection'
                    : masterAI_online
                      ? 'Online'
                      : 'Unresponsive'}
                </Box>
              </LabeledList.Item>
            </LabeledList>
          </Section>

          <Stack vertical>
            {cyborg_groups.map((borggroup, cyborgindex) => (
              <Stack.Item key={cyborgindex}>
                <Stack>
                  {borggroup.map((cyborg, borgindex) => (
                    <Stack.Item key={borgindex} width="24.25%">
                      <Section
                        key={cyborg.ref}
                        title={cyborg.otherBorgName.slice(0, 20)}
                      >
                        <LabeledList>
                          <LabeledList.Item label="Status">
                            <Box
                              color={
                                cyborg.status
                                  ? 'bad'
                                  : cyborg.locked_down
                                    ? 'average'
                                    : 'good'
                              }
                            >
                              {cyborg.status
                                ? 'Not Responding'
                                : cyborg.locked_down
                                  ? 'Locked Down'
                                  : cyborg.shell_discon
                                    ? 'Nominal/Disconnected'
                                    : 'Nominal'}
                            </Box>
                          </LabeledList.Item>
                          <LabeledList.Item label="Condition">
                            <Box
                              color={
                                cyborg.integ <= 25
                                  ? 'bad'
                                  : cyborg.integ <= 75
                                    ? 'average'
                                    : 'good'
                              }
                            >
                              {cyborg.integ === 0
                                ? 'Hard Fault'
                                : cyborg.integ <= 25
                                  ? 'Functionality Disrupted'
                                  : cyborg.integ <= 75
                                    ? 'Functionality Impaired'
                                    : 'Operational'}
                            </Box>
                          </LabeledList.Item>
                          <LabeledList.Item label="Charge">
                            <Box
                              color={
                                cyborg.charge <= 30
                                  ? 'bad'
                                  : cyborg.charge <= 70
                                    ? 'average'
                                    : 'good'
                              }
                            >
                              {typeof cyborg.charge === 'number'
                                ? `${cyborg.charge}%`
                                : 'No Cell'}
                            </Box>
                          </LabeledList.Item>
                          <LabeledList.Item label="Model">
                            {cyborg.module}
                          </LabeledList.Item>
                        </LabeledList>
                      </Section>
                    </Stack.Item>
                  ))}
                </Stack>
                <Stack.Divider />
              </Stack.Item>
            ))}
          </Stack>

          {!cyborg_groups.length && (
            <NoticeBox textAlign="center" top="30%" position="relative">
              <Box fontSize={2}>
                CONNECTION UNAVAILABLE -- NETWORK STATUS UNKNOWN
              </Box>
            </NoticeBox>
          )}
        </Flex.Item>
      )}
    </Flex>
  );
};

const REPRODUCTION_DIRECTION_LABELS = {
  south: 'South',
  north: 'North',
  east: 'East',
  west: 'West',
  rest: 'Resting',
  sit: 'Sitting',
  bellyup: 'Belly Up',
  rest_deep: 'Deep Rest',
};

const REPRODUCTION_COLOR_LAYER_LABELS = {
  1: 'Primary',
  2: 'Secondary',
  3: 'Tertiary',
};

const AROUSAL_NONE = 1;
const AROUSAL_PARTIAL = 2;
const AROUSAL_FULL = 3;

const getReproductionArousalKey = (arousal) => {
  switch (arousal) {
    case AROUSAL_NONE:
      return 'none';
    case AROUSAL_PARTIAL:
      return 'partial';
    case AROUSAL_FULL:
      return 'full';
    default:
      return null;
  }
};

const getDirectionalLayoutSettings = (genital, direction, arousal) => {
  const directionState = genital.advanced?.[direction] || {};
  const settings = {
    visible:
      directionState.visible === undefined || directionState.visible === null
        ? true
        : !!directionState.visible,
    pixel_x: directionState.pixel_x || 0,
    pixel_y: directionState.pixel_y || 0,
    rotation: directionState.rotation || 0,
  };
  const targetArousal = arousal ?? genital.aroused;
  const arousalKey = genital.can_arouse
    ? getReproductionArousalKey(targetArousal)
    : null;
  const arousalSettings = arousalKey
    ? directionState.arousal?.[arousalKey] || {}
    : null;

  if (arousalSettings) {
    if (
      arousalSettings.visible !== undefined &&
      arousalSettings.visible !== null
    ) {
      settings.visible = !!arousalSettings.visible;
    }
    if (
      arousalSettings.pixel_x !== undefined &&
      arousalSettings.pixel_x !== null
    ) {
      settings.pixel_x = arousalSettings.pixel_x;
    }
    if (
      arousalSettings.pixel_y !== undefined &&
      arousalSettings.pixel_y !== null
    ) {
      settings.pixel_y = arousalSettings.pixel_y;
    }
    if (
      arousalSettings.rotation !== undefined &&
      arousalSettings.rotation !== null
    ) {
      settings.rotation = arousalSettings.rotation;
    }
  }

  return settings;
};

const ReproductionNumberInput = ({
  act,
  slot,
  field,
  value,
  minValue,
  maxValue,
  step,
  width,
  direction,
  arousal,
}) => (
  <NumberInput
    animated
    tickWhileDragging
    minValue={minValue}
    maxValue={maxValue}
    step={step}
    stepPixelSize={6}
    width={width || '90px'}
    value={value}
    onChange={(newValue) =>
      act(
        direction ? 'setReproductionDirectionValue' : 'setReproductionValue',
        {
          slot,
          field,
          value: newValue,
          direction,
          arousal,
        },
      )
    }
  />
);

const RobotactDirectionalLayoutControls = ({
  act,
  genital,
  direction,
  arousal,
}) => {
  const settings = getDirectionalLayoutSettings(genital, direction, arousal);
  const isVisible = !!settings.visible;
  const offsetLimit = genital.offset_limit || 32;
  const activeArousal = genital.can_arouse ? arousal : null;
  return (
    <Stack align="center" key={`${genital.slot}-${direction}`} mb={0.5}>
      <Stack.Item basis="80px" color="label">
        {REPRODUCTION_DIRECTION_LABELS[direction] || direction}
      </Stack.Item>
      <Stack.Item basis="90px">
        <Button.Checkbox
          checked={isVisible}
          fluid
          textAlign="center"
          onClick={() =>
            act('setReproductionDirectionValue', {
              slot: genital.slot,
              field: 'visible',
              value: isVisible ? 0 : 1,
              direction,
              arousal: activeArousal,
            })
          }
        >
          Show
        </Button.Checkbox>
      </Stack.Item>
      <Stack.Item>
        <ReproductionNumberInput
          act={act}
          slot={genital.slot}
          field="pixel_x"
          direction={direction}
          minValue={-offsetLimit}
          maxValue={offsetLimit}
          step={1}
          value={settings.pixel_x || 0}
          arousal={activeArousal}
        />
      </Stack.Item>
      <Stack.Item>
        <ReproductionNumberInput
          act={act}
          slot={genital.slot}
          field="pixel_y"
          direction={direction}
          minValue={-offsetLimit}
          maxValue={offsetLimit}
          step={1}
          value={settings.pixel_y || 0}
          arousal={activeArousal}
        />
      </Stack.Item>
      <Stack.Item>
        <ReproductionNumberInput
          act={act}
          slot={genital.slot}
          field="rotation"
          direction={direction}
          minValue={-180}
          maxValue={180}
          step={1}
          value={settings.rotation || 0}
          arousal={activeArousal}
        />
      </Stack.Item>
      <Stack.Item grow={1} textAlign="right">
        <Button
          icon="undo"
          content="Reset"
          onClick={() =>
            act('resetReproductionDirectionValue', {
              slot: genital.slot,
              direction,
              arousal: activeArousal,
            })
          }
        />
      </Stack.Item>
    </Stack>
  );
};

const RobotactGenitalControls = ({ act, genital }) => {
  const [directionalArousal, setDirectionalArousal] = useState(null);
  const effectiveDirectionalArousal = genital.can_arouse
    ? (directionalArousal ?? genital.aroused)
    : null;
  const effectiveDirectionalArousalLabel = genital.can_arouse
    ? effectiveDirectionalArousal === AROUSAL_NONE
      ? 'None'
      : effectiveDirectionalArousal === AROUSAL_PARTIAL
        ? 'Partial'
        : effectiveDirectionalArousal === AROUSAL_FULL
          ? 'Full'
          : genital.arousal_label
    : null;

  return (
    <Collapsible
      key={genital.slot}
      open
      title={`${genital.name} (${genital.sprite || 'Default'})`}
    >
      <Section>
        <LabeledList>
          <LabeledList.Item label="Sprite">
            <Flex align="center" justify="space-between" width="100%">
              <Flex.Item>{genital.sprite || 'Default'}</Flex.Item>
              <Flex.Item>
                <Stack align="center">
                  <Stack.Item>
                    <Button
                      icon={genital.visible ? 'eye-slash' : 'eye'}
                      content={genital.visible ? 'Hide' : 'Show'}
                      onClick={() =>
                        act('toggleReproductionVisibility', {
                          slot: genital.slot,
                        })
                      }
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="undo"
                      content="Reset All"
                      onClick={() =>
                        act('resetReproductionValue', {
                          slot: genital.slot,
                        })
                      }
                    />
                  </Stack.Item>
                </Stack>
              </Flex.Item>
            </Flex>
          </LabeledList.Item>
          <LabeledList.Item label="Color">
            <Stack vertical>
              {Object.entries(genital.color_layers || { 1: 'primary' }).map(
                ([layerKey, layerName]) => {
                  const colorIndex = Number(layerKey);
                  const customColor = genital.colors?.[colorIndex - 1];
                  const resolvedColor =
                    genital.resolved_colors?.[colorIndex - 1] || '#000000';
                  return (
                    <Stack align="center" key={`${genital.slot}-${layerKey}`}>
                      <Stack.Item basis="70px" color="label">
                        {REPRODUCTION_COLOR_LAYER_LABELS[colorIndex] ||
                          layerName}
                      </Stack.Item>
                      <Stack.Item>
                        <Box
                          style={{
                            background: resolvedColor,
                            border: '1px solid white',
                            boxSizing: 'border-box',
                            height: '16px',
                            width: '16px',
                          }}
                        />
                      </Stack.Item>
                      <Stack.Item grow={1}>
                        {customColor || `Default (${resolvedColor})`}
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          icon="palette"
                          content="Change"
                          onClick={() =>
                            act('setReproductionColor', {
                              slot: genital.slot,
                              color_index: colorIndex,
                            })
                          }
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          icon="undo"
                          content="Default"
                          disabled={!customColor}
                          onClick={() =>
                            act('resetReproductionColor', {
                              slot: genital.slot,
                              color_index: colorIndex,
                            })
                          }
                        />
                      </Stack.Item>
                    </Stack>
                  );
                },
              )}
            </Stack>
          </LabeledList.Item>
          <LabeledList.Item label="Visibility">
            <Box color={genital.visible ? 'good' : 'average'}>
              {genital.visible ? 'Visible' : 'Hidden'}
            </Box>
          </LabeledList.Item>
          {!!genital.can_arouse && (
            <LabeledList.Item label="Arousal">
              <Stack>
                <Stack.Item grow={1}>
                  <Box color="label">{genital.arousal_label}</Box>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    selected={genital.aroused === AROUSAL_NONE}
                    content="None"
                    onClick={() =>
                      act('setReproductionArousal', {
                        slot: genital.slot,
                        arousal: AROUSAL_NONE,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    selected={genital.aroused === AROUSAL_PARTIAL}
                    content="Partial"
                    onClick={() =>
                      act('setReproductionArousal', {
                        slot: genital.slot,
                        arousal: AROUSAL_PARTIAL,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    selected={genital.aroused === AROUSAL_FULL}
                    content="Full"
                    onClick={() =>
                      act('setReproductionArousal', {
                        slot: genital.slot,
                        arousal: AROUSAL_FULL,
                      })
                    }
                  />
                </Stack.Item>
              </Stack>
            </LabeledList.Item>
          )}
        </LabeledList>
        <Stack mt={1} align="center">
          <Stack.Item basis="80px" color="label">
            Pixel X
          </Stack.Item>
          <Stack.Item>
            <ReproductionNumberInput
              act={act}
              slot={genital.slot}
              field="pixel_x"
              minValue={-(genital.offset_limit || 32)}
              maxValue={genital.offset_limit || 32}
              step={1}
              value={genital.pixel_x || 0}
            />
          </Stack.Item>
          <Stack.Item basis="80px" color="label">
            Pixel Y
          </Stack.Item>
          <Stack.Item>
            <ReproductionNumberInput
              act={act}
              slot={genital.slot}
              field="pixel_y"
              minValue={-(genital.offset_limit || 32)}
              maxValue={genital.offset_limit || 32}
              step={1}
              value={genital.pixel_y || 0}
            />
          </Stack.Item>
        </Stack>
        <Stack mt={1} align="center">
          <Stack.Item basis="80px" color="label">
            Rotation
          </Stack.Item>
          <Stack.Item>
            <ReproductionNumberInput
              act={act}
              slot={genital.slot}
              field="rotation"
              minValue={-180}
              maxValue={180}
              step={1}
              value={genital.rotation || 0}
            />
          </Stack.Item>
          <Stack.Item basis="80px" color="label">
            Size
          </Stack.Item>
          <Stack.Item>
            <ReproductionNumberInput
              act={act}
              slot={genital.slot}
              field="scale"
              minValue={0.25}
              maxValue={genital.scale_limit || 4}
              step={0.05}
              value={genital.scale || 1}
            />
          </Stack.Item>
        </Stack>
        <Collapsible title="Advanced Directional Offsets" mt={1}>
          {!!genital.can_arouse && (
            <Stack vertical mb={0.5}>
              <Stack.Item color="label">
                Editing directional offsets for arousal state:{' '}
                {effectiveDirectionalArousalLabel}
              </Stack.Item>
              <Stack.Item>
                <Stack>
                  <Stack.Item>
                    <Button
                      selected={directionalArousal === null}
                      content="Current"
                      onClick={() => setDirectionalArousal(null)}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      selected={effectiveDirectionalArousal === AROUSAL_NONE}
                      content="None"
                      onClick={() => setDirectionalArousal(AROUSAL_NONE)}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      selected={effectiveDirectionalArousal === AROUSAL_PARTIAL}
                      content="Partial"
                      onClick={() => setDirectionalArousal(AROUSAL_PARTIAL)}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      selected={effectiveDirectionalArousal === AROUSAL_FULL}
                      content="Full"
                      onClick={() => setDirectionalArousal(AROUSAL_FULL)}
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          )}
          <Stack mb={0.5}>
            <Stack.Item basis="80px" color="label">
              Facing
            </Stack.Item>
            <Stack.Item basis="90px" color="label">
              Shown
            </Stack.Item>
            <Stack.Item basis="90px" color="label">
              Pixel X
            </Stack.Item>
            <Stack.Item basis="90px" color="label">
              Pixel Y
            </Stack.Item>
            <Stack.Item basis="90px" color="label">
              Rotation
            </Stack.Item>
          </Stack>
          {Object.keys(REPRODUCTION_DIRECTION_LABELS).map((direction) => (
            <RobotactDirectionalLayoutControls
              key={`${genital.slot}-${direction}`}
              act={act}
              genital={genital}
              direction={direction}
              arousal={effectiveDirectionalArousal}
            />
          ))}
        </Collapsible>
      </Section>
    </Collapsible>
  );
};

const RobotactReproductionManagement = ({ act, reproductionManagement }) => {
  const rawGenitals = reproductionManagement.genitals || [];
  const rawPresets = reproductionManagement.presets || [];
  const genitals = Array.isArray(rawGenitals)
    ? rawGenitals
    : Object.values(rawGenitals);
  const presets = Array.isArray(rawPresets)
    ? rawPresets
    : Object.values(rawPresets);
  return (
    <Section
      fill
      scrollable
      title="Reproduction Management"
      buttons={
        <Stack align="center">
          <Stack.Item>
            <Button
              icon="save"
              content={`Save Preset (${presets.length}/${reproductionManagement.presetLimit || 10})`}
              onClick={() => act('saveReproductionPreset')}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="bookmark"
              content="Save Model Default"
              onClick={() => act('saveReproductionModelDefault')}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="upload"
              content="Load Model Default"
              disabled={!reproductionManagement.has_model_default}
              onClick={() => act('loadReproductionModelDefault')}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="trash"
              color="bad"
              content="Clear Model Default"
              disabled={!reproductionManagement.has_model_default}
              onClick={() => act('clearReproductionModelDefault')}
            />
          </Stack.Item>
        </Stack>
      }
    >
      <Box mb={1} color="label">
        Adjust visibility, color, and placement for the currently enabled cyborg
        genitals.
      </Box>
      <Box mb={1} color="average">
        Current model: {reproductionManagement.model_name || 'Unknown'}.
        {reproductionManagement.has_model_default
          ? ' A model-specific default is saved and will auto-load when this model is selected.'
          : ' No model-specific default is saved yet.'}
      </Box>
      {!genitals.length && (
        <NoticeBox>
          This cyborg has no configurable genitals enabled in character
          preferences.
        </NoticeBox>
      )}
      {!!presets.length && (
        <Section title="Saved Presets">
          {presets.map((preset) => (
            <Stack key={preset.name} align="center" mb={0.5}>
              <Stack.Item grow={1}>{preset.name}</Stack.Item>
              <Stack.Item>
                <Button
                  icon="upload"
                  content="Load"
                  onClick={() =>
                    act('loadReproductionPreset', {
                      preset: preset.name,
                    })
                  }
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="trash"
                  color="bad"
                  content="Delete"
                  onClick={() =>
                    act('deleteReproductionPreset', {
                      preset: preset.name,
                    })
                  }
                />
              </Stack.Item>
            </Stack>
          ))}
        </Section>
      )}
      {!!genitals.length && (
        <Stack vertical>
          {genitals.map((genital) => (
            <Stack.Item key={genital.slot}>
              <RobotactGenitalControls act={act} genital={genital} />
            </Stack.Item>
          ))}
        </Stack>
      )}
    </Section>
  );
};
