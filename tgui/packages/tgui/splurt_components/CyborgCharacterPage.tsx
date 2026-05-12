import { type ReactNode, useEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Collapsible,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';

import { PreferenceList } from '../interfaces/PreferencesMenu/CharacterPreferences/MainPage';
import { NameInput } from '../interfaces/PreferencesMenu/CharacterPreferences/names';
import { PageButton } from '../interfaces/PreferencesMenu/components/PageButton';
import type {
  CyborgReproductionManagement,
  PreferencesMenuData,
} from '../interfaces/PreferencesMenu/types';
import { createSetPreference } from '../interfaces/PreferencesMenu/types';
import { useServerPrefs } from '../interfaces/PreferencesMenu/useServerPrefs';
import { BottomDropdown } from './BottomDropdown';

const PREVIEW_DIRS = ['south', 'north', 'east', 'west'];
const AROUSAL_NONE = 1;
const AROUSAL_PARTIAL = 2;
const AROUSAL_FULL = 3;
const PREVIEW_MAP_SIZE_PX = 480;
const PREVIEW_MAP_SIZE = `${PREVIEW_MAP_SIZE_PX}px`;
const PREVIEW_DEFAULT_ZOOM = 2;
const PREVIEW_MAX_ZOOM = 8;
const PREVIEW_LABEL_WIDTH = '86px';
const NO_RANDOMIZATIONS = {} as Record<string, never>;

const cyborgArousalKey = (arousal: number | null): string | null => {
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

enum CyborgPrefPage {
  Visuals,
  Lore,
}

function CyborgPreviewControlRow(props: {
  label: string;
  children: ReactNode;
}) {
  return (
    <Box
      mb={0.5}
      style={{
        alignItems: 'center',
        display: 'flex',
        gap: '0.5em',
        width: '100%',
      }}
    >
      <Box color="label" style={{ flex: `0 0 ${PREVIEW_LABEL_WIDTH}` }}>
        {props.label}
      </Box>
      <Box style={{ flex: '1 1 auto', minWidth: 0 }}>{props.children}</Box>
    </Box>
  );
}

function StopWindowDrag(props: { children: ReactNode }) {
  return (
    <Box
      onMouseDown={(event) => event.stopPropagation()}
      onPointerDown={(event) => event.stopPropagation()}
    >
      {props.children}
    </Box>
  );
}

function normalizeList<T>(value: T[] | Record<string, T> | undefined): T[] {
  if (!value) {
    return [];
  }
  if (Array.isArray(value)) {
    return value;
  }
  return Object.values(value);
}

function normalizeColorLayers(
  value: string[] | Record<string, string> | undefined,
): [string, string][] {
  if (!value) {
    return [['1', 'primary']];
  }

  if (Array.isArray(value)) {
    if (!value.length) {
      return [['1', 'primary']];
    }
    return value.map((layer, index) => [String(index + 1), layer]);
  }

  const entries = Object.entries(value).sort(
    ([leftKey], [rightKey]) => Number(leftKey) - Number(rightKey),
  );
  return entries.length ? entries : [['1', 'primary']];
}

function CyborgNumberInput(props: {
  value: number;
  field: string;
  slot: string;
  direction?: string;
  arousal?: number | null;
  minValue: number;
  maxValue: number;
  step: number;
}) {
  const { act } = useBackend<PreferencesMenuData>();
  const { direction, arousal, slot, field, value, ...numberProps } = props;
  const [draftValue, setDraftValue] = useState(value);
  const commitTimerRef = useRef<number | null>(null);

  useEffect(() => {
    setDraftValue(value);
  }, [value]);

  useEffect(
    () => () => {
      if (commitTimerRef.current !== null) {
        window.clearTimeout(commitTimerRef.current);
      }
    },
    [],
  );

  const queueCommit = (nextValue: number) => {
    if (commitTimerRef.current !== null) {
      window.clearTimeout(commitTimerRef.current);
    }

    commitTimerRef.current = window.setTimeout(() => {
      commitTimerRef.current = null;
      act(
        direction
          ? 'set_cyborg_reproduction_direction_value'
          : 'set_cyborg_reproduction_value',
        {
          slot,
          field,
          value: nextValue,
          direction,
          arousal,
        },
      );
    }, 60);
  };

  return (
    <StopWindowDrag>
      <NumberInput
        animated
        tickWhileDragging
        stepPixelSize={6}
        width="90px"
        value={draftValue}
        onChange={(nextValue) => {
          setDraftValue(nextValue);
          queueCommit(nextValue);
        }}
        {...numberProps}
      />
    </StopWindowDrag>
  );
}

function CyborgDirectionalLayoutControls(props: {
  genital: CyborgReproductionManagement['genitals'][number];
  direction: string;
  directionLabel: string;
  arousal: number | null;
}) {
  const { act } = useBackend<PreferencesMenuData>();
  const { genital, direction, directionLabel, arousal } = props;
  const settings = genital.advanced?.[direction] || {};
  const arousalKey = cyborgArousalKey(arousal);
  const arousalSettings = arousalKey
    ? settings.arousal?.[arousalKey] || {}
    : {};
  const offsetLimit = genital.offset_limit || 32;
  const activeArousal = genital.can_arouse ? arousal : null;
  const effectiveSettings = {
    visible:
      arousalSettings.visible !== undefined
        ? !!arousalSettings.visible
        : !!settings.visible,
    pixel_x:
      arousalSettings.pixel_x !== undefined
        ? arousalSettings.pixel_x
        : settings.pixel_x || 0,
    pixel_y:
      arousalSettings.pixel_y !== undefined
        ? arousalSettings.pixel_y
        : settings.pixel_y || 0,
    rotation:
      arousalSettings.rotation !== undefined
        ? arousalSettings.rotation
        : settings.rotation || 0,
    priority:
      arousalSettings.priority !== undefined
        ? arousalSettings.priority
        : settings.priority || 5,
  };

  return (
    <Stack align="center" mb={0.5}>
      <Stack.Item basis="80px" color="label">
        {directionLabel}
      </Stack.Item>
      <Stack.Item basis="90px">
        <Button.Checkbox
          checked={effectiveSettings.visible}
          fluid
          textAlign="center"
          onClick={() =>
            act('set_cyborg_reproduction_direction_value', {
              slot: genital.slot,
              field: 'visible',
              value: effectiveSettings.visible ? 0 : 1,
              direction,
              arousal: activeArousal,
            })
          }
        >
          Show
        </Button.Checkbox>
      </Stack.Item>
      <Stack.Item>
        <CyborgNumberInput
          slot={genital.slot}
          field="pixel_x"
          direction={direction}
          arousal={activeArousal}
          minValue={-offsetLimit}
          maxValue={offsetLimit}
          step={0.1}
          value={effectiveSettings.pixel_x || 0}
        />
      </Stack.Item>
      <Stack.Item>
        <CyborgNumberInput
          slot={genital.slot}
          field="pixel_y"
          direction={direction}
          arousal={activeArousal}
          minValue={-offsetLimit}
          maxValue={offsetLimit}
          step={0.1}
          value={effectiveSettings.pixel_y || 0}
        />
      </Stack.Item>
      <Stack.Item>
        <CyborgNumberInput
          slot={genital.slot}
          field="rotation"
          direction={direction}
          arousal={activeArousal}
          minValue={-180}
          maxValue={180}
          step={1}
          value={effectiveSettings.rotation || 0}
        />
      </Stack.Item>
      <Stack.Item basis="110px">
        <StopWindowDrag>
          <Slider
            minValue={1}
            maxValue={10}
            step={1}
            stepPixelSize={14}
            value={effectiveSettings.priority || 5}
            onChange={(e, value) =>
              act('set_cyborg_reproduction_direction_value', {
                slot: genital.slot,
                field: 'priority',
                value,
                direction,
                arousal: activeArousal,
              })
            }
          />
        </StopWindowDrag>
      </Stack.Item>
      <Stack.Item grow textAlign="right">
        <Button
          icon="undo"
          content="Reset"
          onClick={() =>
            act('reset_cyborg_reproduction_direction_value', {
              slot: genital.slot,
              direction,
              arousal: activeArousal,
            })
          }
        />
      </Stack.Item>
    </Stack>
  );
}

function CyborgGenitalControls(props: {
  genital: CyborgReproductionManagement['genitals'][number];
  offsetDirections: CyborgReproductionManagement['offset_directions'];
}) {
  const { act } = useBackend<PreferencesMenuData>();
  const { genital, offsetDirections } = props;
  const hasSprite = !!genital.has_sprite;
  const [directionalArousal, setDirectionalArousal] =
    useState<number>(AROUSAL_NONE);
  const effectiveDirectionalArousal = genital.can_arouse
    ? directionalArousal
    : null;
  const effectiveDirectionalArousalLabel = !genital.can_arouse
    ? 'Locked'
    : effectiveDirectionalArousal === AROUSAL_NONE
      ? 'None'
      : effectiveDirectionalArousal === AROUSAL_PARTIAL
        ? 'Partial'
        : effectiveDirectionalArousal === AROUSAL_FULL
          ? 'Full'
          : 'None';

  return (
    <Collapsible
      open
      title={`${genital.name} (${genital.sprite || 'Default'})`}
    >
      <Section>
        <LabeledList>
          <LabeledList.Item label="Sprite">
            <Stack align="center" justify="space-between">
              <Stack.Item>{genital.sprite || 'Default'}</Stack.Item>
              <Stack.Item>
                <Button
                  icon="undo"
                  content="Reset All"
                  onClick={() =>
                    act('reset_cyborg_reproduction_value', {
                      slot: genital.slot,
                    })
                  }
                />
              </Stack.Item>
            </Stack>
          </LabeledList.Item>

          {hasSprite && (
            <LabeledList.Item label="Color">
              <Stack vertical>
                {normalizeColorLayers(genital.color_layers).map(
                  ([layerKey, layerName]) => {
                    const colorIndex = Number(layerKey);
                    const customColor = genital.colors?.[colorIndex - 1];
                    const resolvedColor =
                      genital.resolved_colors?.[colorIndex - 1] || '#000000';

                    return (
                      <Stack align="center" key={`${genital.slot}-${layerKey}`}>
                        <Stack.Item basis="70px" color="label">
                          {layerName}
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
                              act('set_cyborg_reproduction_value', {
                                slot: genital.slot,
                                field: 'color',
                                value: colorIndex,
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
                              act('set_cyborg_reproduction_value', {
                                slot: genital.slot,
                                field: 'reset_color',
                                value: colorIndex,
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
          )}
        </LabeledList>

        {!hasSprite && (
          <NoticeBox info>
            Select a sprite for this genital to edit its layout offsets.
          </NoticeBox>
        )}

        {hasSprite && (
          <>
        <Stack mt={1} align="center">
          <Stack.Item basis="80px" color="label">
            Pixel X
          </Stack.Item>
          <Stack.Item>
            <CyborgNumberInput
              slot={genital.slot}
              field="pixel_x"
              minValue={-(genital.offset_limit || 32)}
              maxValue={genital.offset_limit || 32}
              step={0.1}
              value={genital.pixel_x || 0}
            />
          </Stack.Item>
          <Stack.Item basis="80px" color="label">
            Pixel Y
          </Stack.Item>
          <Stack.Item>
            <CyborgNumberInput
              slot={genital.slot}
              field="pixel_y"
              minValue={-(genital.offset_limit || 32)}
              maxValue={genital.offset_limit || 32}
              step={0.1}
              value={genital.pixel_y || 0}
            />
          </Stack.Item>
        </Stack>

        <Stack mt={1} align="center">
          <Stack.Item basis="80px" color="label">
            Rotation
          </Stack.Item>
          <Stack.Item>
            <CyborgNumberInput
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
            <CyborgNumberInput
              slot={genital.slot}
              field="scale"
              minValue={0.25}
              maxValue={genital.scale_limit || 4}
              step={0.05}
              value={genital.scale || 1}
            />
          </Stack.Item>
        </Stack>

        <Section title="Directional Offsets" mt={1}>
          <Stack vertical mb={0.5}>
            <Stack.Item color="label">
              Editing directional offsets for arousal state:{' '}
              {effectiveDirectionalArousalLabel}
            </Stack.Item>
            <Stack.Item>
              {genital.can_arouse ? (
                <Stack>
                  <Stack.Item>
                    <Button
                      selected={effectiveDirectionalArousal === AROUSAL_NONE}
                      content="None"
                      onClick={() => {
                        setDirectionalArousal(AROUSAL_NONE);
                        act('set_cyborg_preview_genital_arousal', {
                          slot: genital.slot,
                          arousal: AROUSAL_NONE,
                        });
                      }}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      selected={effectiveDirectionalArousal === AROUSAL_PARTIAL}
                      content="Partial"
                      onClick={() => {
                        setDirectionalArousal(AROUSAL_PARTIAL);
                        act('set_cyborg_preview_genital_arousal', {
                          slot: genital.slot,
                          arousal: AROUSAL_PARTIAL,
                        });
                      }}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      selected={effectiveDirectionalArousal === AROUSAL_FULL}
                      content="Full"
                      onClick={() => {
                        setDirectionalArousal(AROUSAL_FULL);
                        act('set_cyborg_preview_genital_arousal', {
                          slot: genital.slot,
                          arousal: AROUSAL_FULL,
                        });
                      }}
                    />
                  </Stack.Item>
                </Stack>
              ) : (
                <Box color="average">Locked</Box>
              )}
            </Stack.Item>
          </Stack>

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
            <Stack.Item basis="110px" color="label">
              Priority
            </Stack.Item>
          </Stack>

          {offsetDirections.map((directionEntry) => (
            <CyborgDirectionalLayoutControls
              key={`${genital.slot}-${directionEntry.value}`}
              genital={genital}
              direction={directionEntry.value}
              directionLabel={directionEntry.label}
              arousal={effectiveDirectionalArousal}
            />
          ))}
        </Section>
          </>
        )}
      </Section>
    </Collapsible>
  );
}

function CyborgReproductionManagementSection(props: {
  reproductionManagement: CyborgReproductionManagement;
}) {
  const { act } = useBackend<PreferencesMenuData>();
  const rawGenitals = props.reproductionManagement.genitals || [];
  const rawPresets = props.reproductionManagement.presets || [];
  const rawOffsetDirections =
    props.reproductionManagement.offset_directions || [];
  const genitals = normalizeList(rawGenitals);
  const presets = normalizeList(rawPresets);
  const offsetDirections = normalizeList(rawOffsetDirections);

  return (
    <Section title="Genital Layout">
      <Box
        mb={1}
        style={{
          display: 'flex',
          flexWrap: 'wrap',
          gap: '0.5em',
          alignItems: 'center',
        }}
      >
        <Button
          icon="save"
          content={`Save Preset (${presets.length}/${props.reproductionManagement.presetLimit || 10})`}
          onClick={() => act('save_cyborg_reproduction_preset')}
        />
        <Button
          icon="bookmark"
          content="Save Model Default"
          onClick={() => act('save_cyborg_reproduction_model_default')}
        />
        <Button
          icon="upload"
          content="Load Model Default"
          disabled={!props.reproductionManagement.has_model_default}
          onClick={() => act('load_cyborg_reproduction_model_default')}
        />
        <Button
          icon="trash"
          color="bad"
          content="Clear Model Default"
          disabled={!props.reproductionManagement.has_model_default}
          onClick={() => act('clear_cyborg_reproduction_model_default')}
        />
      </Box>
      <Box mb={1} color="label">
        Adjust the stored layout for the currently enabled cyborg genitals.
      </Box>
      <Box mb={1} color="average">
        Current model:{' '}
        {props.reproductionManagement.model_department || 'Unknown'} /{' '}
        {props.reproductionManagement.model_name || 'Unknown'}.
        {props.reproductionManagement.has_model_default
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
                    act('load_cyborg_reproduction_preset', {
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
                    act('delete_cyborg_reproduction_preset', {
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
              <CyborgGenitalControls
                genital={genital}
                offsetDirections={offsetDirections}
              />
            </Stack.Item>
          ))}
        </Stack>
      )}
    </Section>
  );
}

function preferenceSubsetFromBuckets(
  preferences: PreferencesMenuData['character_preferences'],
  keys: string[],
) {
  const buckets = [
    preferences.secondary_features || {},
    preferences.features || {},
    preferences.supplemental_features || {},
    preferences.non_contextual || {},
  ];

  const subset: Record<string, unknown> = {};

  for (const key of keys) {
    for (const bucket of buckets) {
      if (Object.hasOwn(bucket, key)) {
        subset[key] = bucket[key];
        break;
      }
    }
  }

  return subset;
}

export function CyborgCharacterPage() {
  const { act, data } = useBackend<PreferencesMenuData>();
  const serverData = useServerPrefs();
  const cyborg = data.cyborg_character;
  const [currentPrefPage, setCurrentPrefPage] = useState(
    CyborgPrefPage.Visuals,
  );
  const [previewZoom, setPreviewZoom] = useState(PREVIEW_DEFAULT_ZOOM);

  if (!cyborg) {
    return <NoticeBox>Loading cyborg character data...</NoticeBox>;
  }

  const identityPreferences = preferenceSubsetFromBuckets(
    data.character_preferences,
    ['silicon_gender', 'custom_species_silicon'],
  );

  const lorePreferences = preferenceSubsetFromBuckets(
    data.character_preferences,
    [
      'silicon_flavor_text',
      'silicon_flavor_text_nsfw',
      'headshot_silicon',
      'headshot_silicon_nsfw',
      'ooc_notes_silicon',
      'custom_species_lore_silicon',
    ],
  );

  const genitalPreferences = preferenceSubsetFromBuckets(
    data.character_preferences,
    [
      'silicon_penis_sprite',
      'silicon_sheath_sprite',
      'silicon_testicles_sprite',
      'silicon_vagina_sprite',
      'silicon_breasts_sprite',
    ],
  );

  const visualsPage = (
    <Stack vertical fill style={{ height: '100%', overflow: 'hidden' }}>
      <Stack.Item grow={0}>
        <Section title="Preview">
          <Box
            style={{
              alignItems: 'center',
              display: 'flex',
              flexDirection: 'column',
              height: '100%',
              width: '100%',
            }}
          >
            <Box
              style={{
                alignItems: 'center',
                backgroundColor: '#000',
                display: 'flex',
                height: PREVIEW_MAP_SIZE,
                justifyContent: 'center',
                overflow: 'auto',
                width: PREVIEW_MAP_SIZE,
              }}
            >
              {cyborg.preview_image && (
                <img
                  alt=""
                  src={cyborg.preview_image}
                  style={{
                    height: `${PREVIEW_MAP_SIZE_PX * previewZoom}px`,
                    imageRendering: 'pixelated',
                    objectFit: 'contain',
                    width: `${PREVIEW_MAP_SIZE_PX * previewZoom}px`,
                  }}
                />
              )}
            </Box>
            <Box mt={1} style={{ width: PREVIEW_MAP_SIZE }}>
              <CyborgPreviewControlRow label="Zoom">
                <StopWindowDrag>
                  <Slider
                    minValue={0.5}
                    maxValue={PREVIEW_MAX_ZOOM}
                    step={0.1}
                    stepPixelSize={8}
                    value={previewZoom}
                    unit="x"
                    onChange={(e, value) => setPreviewZoom(value)}
                  />
                </StopWindowDrag>
              </CyborgPreviewControlRow>
              <CyborgPreviewControlRow label="Background">
                <BottomDropdown
                  fluid
                  width="100%"
                  options={serverData?.background_state.choices || []}
                  selected={data.character_preferences.misc.background_state}
                  onSelected={(value) =>
                    act('update_cyborg_background', {
                      new_background: value,
                    })
                  }
                />
              </CyborgPreviewControlRow>
              <CyborgPreviewControlRow label="Size">
                <StopWindowDrag>
                  <Slider
                    minValue={0}
                    maxValue={(cyborg.size_options?.length || 1) - 1}
                    step={1}
                    stepPixelSize={80}
                    value={Math.max(
                      0,
                      (cyborg.size_options || []).indexOf(cyborg.size),
                    )}
                    format={(value) => {
                      const size = cyborg.size_options?.[value] || cyborg.size;
                      return `${Math.round(size * 100)}%`;
                    }}
                    onChange={(e, value) =>
                      act('set_cyborg_size', {
                        size: cyborg.size_options?.[value] || cyborg.size,
                      })
                    }
                  />
                </StopWindowDrag>
              </CyborgPreviewControlRow>
              <CyborgPreviewControlRow label="Department">
                <BottomDropdown
                  fluid
                  over
                  width="100%"
                  options={cyborg.models}
                  selected={cyborg.selected_department}
                  onSelected={(value) =>
                    act('set_cyborg_preview_department', {
                      department: value,
                    })
                  }
                />
              </CyborgPreviewControlRow>
              <CyborgPreviewControlRow label="Model">
                <BottomDropdown
                  fluid
                  over
                  width="100%"
                  options={
                    cyborg.models_by_department?.[cyborg.selected_department] ||
                    []
                  }
                  selected={cyborg.selected_model}
                  onSelected={(value) =>
                    act('set_cyborg_preview_model', { model: value })
                  }
                />
              </CyborgPreviewControlRow>
              <CyborgPreviewControlRow label="State">
                <BottomDropdown
                  fluid
                  over
                  width="100%"
                  options={(cyborg.states || []).map((state) => ({
                    displayText: state.label,
                    value: state.value,
                  }))}
                  selected={cyborg.selected_state}
                  onSelected={(value) =>
                    act('set_cyborg_preview_state', { state: value })
                  }
                />
              </CyborgPreviewControlRow>
              <CyborgPreviewControlRow label="Direction">
                <BottomDropdown
                  fluid
                  over
                  width="100%"
                  options={PREVIEW_DIRS}
                  selected={cyborg.selected_dir}
                  onSelected={(value) =>
                    act('set_cyborg_preview_dir', { dir: value })
                  }
                />
              </CyborgPreviewControlRow>
            </Box>
          </Box>
        </Section>
      </Stack.Item>

      <Stack.Item grow basis={0} style={{ overflowY: 'auto', minHeight: 0 }}>
        <Section title="Visuals" fill>
          <Stack vertical>
            <PreferenceList
              preferences={genitalPreferences}
              randomizations={NO_RANDOMIZATIONS}
              maxHeight="180px"
            />
            <CyborgReproductionManagementSection
              reproductionManagement={cyborg.reproductionManagement}
            />
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );

  const lorePage = (
    <Stack vertical fill style={{ height: '100%', overflow: 'hidden' }}>
      <Stack.Item grow basis={0} style={{ overflowY: 'auto', minHeight: 0 }}>
        <Stack vertical>
          <Section title="Identity">
            <Stack vertical>
              <Stack.Item>
                <NameInput
                  name={data.character_preferences.names.cyborg_name || ''}
                  handleUpdateName={createSetPreference(act, 'cyborg_name')}
                  openMultiNameInput={() => undefined}
                />
              </Stack.Item>
              <PreferenceList
                preferences={identityPreferences}
                randomizations={NO_RANDOMIZATIONS}
                maxHeight="auto"
              />
            </Stack>
          </Section>

          <Section title="Lore">
            <PreferenceList
              preferences={lorePreferences}
              randomizations={NO_RANDOMIZATIONS}
              maxHeight="auto"
            />
          </Section>
        </Stack>
      </Stack.Item>
    </Stack>
  );

  return (
    <Box
      style={{
        display: 'flex',
        flexDirection: 'column',
        gap: '0.5em',
        height: '100%',
        overflow: 'hidden',
        width: '100%',
      }}
    >
      <Box
        style={{
          display: 'flex',
          gap: '0.5em',
          justifyContent: 'center',
          width: '100%',
          flex: '0 0 auto',
        }}
      >
        <Box style={{ flex: '0 0 220px', minWidth: 0 }}>
          <PageButton
            currentPage={currentPrefPage}
            page={CyborgPrefPage.Visuals}
            setPage={setCurrentPrefPage}
          >
            Character Visuals
          </PageButton>
        </Box>
        <Box style={{ flex: '0 0 220px', minWidth: 0 }}>
          <PageButton
            currentPage={currentPrefPage}
            page={CyborgPrefPage.Lore}
            setPage={setCurrentPrefPage}
          >
            Character Lore
          </PageButton>
        </Box>
      </Box>
      <Box
        style={{
          flex: '1 1 auto',
          minHeight: 0,
          overflow: 'hidden',
          width: '100%',
        }}
      >
        {currentPrefPage === CyborgPrefPage.Visuals ? visualsPage : lorePage}
      </Box>
    </Box>
  );
}
