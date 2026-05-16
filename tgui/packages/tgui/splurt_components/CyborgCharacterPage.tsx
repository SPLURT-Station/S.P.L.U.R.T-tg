import { type ReactNode, useEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Collapsible,
  ImageButton,
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
  CyborgPreviewStateOption,
  CyborgPreviewVisualOption,
  CyborgReproductionManagement,
  PreferencesMenuData,
} from '../interfaces/PreferencesMenu/types';
import { createSetPreference } from '../interfaces/PreferencesMenu/types';
import { useServerPrefs } from '../interfaces/PreferencesMenu/useServerPrefs';
import { BottomDropdown } from './BottomDropdown';

const PREVIEW_ROTATION_DIRS = ['north', 'east', 'south', 'west'];
const REST_DIRECTION_KEYS = ['rest', 'sit', 'bellyup', 'rest_deep'];
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

type CyborgPreviewChoice = {
  value: string;
  label: string;
  preview_image?: string | null;
  preview_model?: string;
};

function CyborgPreviewSelectedButton(props: {
  label: string;
  options: CyborgPreviewChoice[];
  selected: string;
  open: boolean;
  onToggle: () => void;
  tooltipFor?: (option: CyborgPreviewChoice) => string;
}) {
  const { label, options, selected, open, onToggle, tooltipFor } = props;
  if (!options.length) {
    return null;
  }

  const selectedOption =
    options.find((option) => option.value === selected) || options[0];
  const optionTooltip = (option: CyborgPreviewChoice) =>
    tooltipFor?.(option) || option.label;

  return (
    <Box style={{ width: '78px' }}>
      <Box color="label" mb={0.25}>
        {label}
      </Box>
      <StopWindowDrag>
        <ImageButton
          base64={selectedOption.preview_image || undefined}
          color={open ? 'green' : undefined}
          imageSize={48}
          selected={open}
          tooltip={optionTooltip(selectedOption)}
          tooltipPosition="bottom"
          onClick={onToggle}
          style={{
            minHeight: '72px',
            minWidth: '72px',
            textTransform: 'none',
          }}
        >
          {selectedOption.label}
        </ImageButton>
      </StopWindowDrag>
    </Box>
  );
}

function CyborgPreviewOptionTray(props: {
  options: CyborgPreviewChoice[];
  selected: string;
  onSelect: (value: string) => void;
  tooltipFor?: (option: CyborgPreviewChoice) => string;
}) {
  const { options, selected, onSelect, tooltipFor } = props;
  if (!options.length) {
    return null;
  }

  const optionTooltip = (option: CyborgPreviewChoice) =>
    tooltipFor?.(option) || option.label;

  return (
    <StopWindowDrag>
      <Box
        mb={0.75}
        style={{
          maxHeight: '180px',
          overflowX: 'hidden',
          overflowY: 'auto',
        }}
      >
        <Stack wrap>
          {options.map((option) => (
            <Stack.Item key={option.value}>
              <ImageButton
                base64={option.preview_image || undefined}
                color={option.value === selected ? 'green' : undefined}
                imageSize={48}
                selected={option.value === selected}
                tooltip={optionTooltip(option)}
                tooltipPosition="bottom"
                onClick={() => onSelect(option.value)}
                style={{
                  minHeight: '72px',
                  minWidth: '72px',
                  textTransform: 'none',
                }}
              >
                {option.label}
              </ImageButton>
            </Stack.Item>
          ))}
        </Stack>
      </Box>
    </StopWindowDrag>
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
            value={11 - (effectiveSettings.priority || 5)}
            format={(value) => `${11 - value}`}
            onChange={(e, value) =>
              act('set_cyborg_reproduction_direction_value', {
                slot: genital.slot,
                field: 'priority',
                value: 11 - value,
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
  const normalDirections = offsetDirections.filter(
    (directionEntry) => !REST_DIRECTION_KEYS.includes(directionEntry.value),
  );
  const restDirections = offsetDirections.filter((directionEntry) =>
    REST_DIRECTION_KEYS.includes(directionEntry.value),
  );
  const renderDirectionRows = (
    directionEntries: CyborgReproductionManagement['offset_directions'],
  ) =>
    directionEntries.map((directionEntry) => (
      <CyborgDirectionalLayoutControls
        key={`${genital.slot}-${directionEntry.value}`}
        genital={genital}
        direction={directionEntry.value}
        directionLabel={directionEntry.label}
        arousal={effectiveDirectionalArousal}
      />
    ));

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

          {renderDirectionRows(normalDirections)}

          {!!restDirections.length && (
            <Collapsible title="Resting State Offsets" mt={1}>
              {renderDirectionRows(restDirections)}
            </Collapsible>
          )}
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
  const genitals = normalizeList(rawGenitals).filter(
    (genital) => !!genital.has_sprite,
  );
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
  const [openPreviewPicker, setOpenPreviewPicker] = useState<string | null>(
    null,
  );
  const previewScrollerRef = useRef<HTMLDivElement>(null);
  const previewTopScrollRef = useRef<HTMLDivElement>(null);
  const previewPanOffsetRef = useRef({ x: 0, y: 0 });
  const previewCenteringRef = useRef(false);
  const previewSyncingScrollRef = useRef(false);
  const previewLayers = [...(cyborg?.preview_layers || [])].sort(
    (left, right) => left.z - right.z,
  );
  const previewCanvasWidth = cyborg?.preview_canvas_width || PREVIEW_MAP_SIZE_PX;
  const previewCanvasHeight =
    cyborg?.preview_canvas_height || PREVIEW_MAP_SIZE_PX;
  const previewBodyLayer = previewLayers.find((layer) => layer.kind === 'body');
  const previewBodyCenterX = previewBodyLayer
    ? (previewBodyLayer.x + previewBodyLayer.width / 2) * previewZoom
    : null;
  const previewBodyCenterY = previewBodyLayer
    ? (previewCanvasHeight - previewBodyLayer.y - previewBodyLayer.height / 2) *
      previewZoom
    : null;

  useEffect(() => {
    const scroller = previewScrollerRef.current;
    if (!scroller || previewBodyCenterX === null || previewBodyCenterY === null) {
      return;
    }

    const frame = requestAnimationFrame(() => {
      previewCenteringRef.current = true;
      const nextScrollLeft =
        previewBodyCenterX -
        scroller.clientWidth / 2 +
        previewPanOffsetRef.current.x;
      scroller.scrollLeft = nextScrollLeft;
      scroller.scrollTop =
        previewBodyCenterY -
        scroller.clientHeight / 2 +
        previewPanOffsetRef.current.y;
      if (previewTopScrollRef.current) {
        previewTopScrollRef.current.scrollLeft = nextScrollLeft;
      }
      requestAnimationFrame(() => {
        previewCenteringRef.current = false;
      });
    });

    return () => cancelAnimationFrame(frame);
  }, [previewBodyCenterX, previewBodyCenterY]);

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
      'silicon_anus_sprite',
      'silicon_breasts_sprite',
    ],
  );

  const syncPreviewTopScroll = (scrollLeft: number) => {
    const topScroller = previewTopScrollRef.current;
    if (!topScroller || previewSyncingScrollRef.current) {
      return;
    }

    previewSyncingScrollRef.current = true;
    topScroller.scrollLeft = scrollLeft;
    previewSyncingScrollRef.current = false;
  };

  const handlePreviewScroll = () => {
    const scroller = previewScrollerRef.current;
    if (
      !scroller ||
      previewCenteringRef.current ||
      previewBodyCenterX === null ||
      previewBodyCenterY === null
    ) {
      return;
    }

    previewPanOffsetRef.current = {
      x: scroller.scrollLeft - (previewBodyCenterX - scroller.clientWidth / 2),
      y: scroller.scrollTop - (previewBodyCenterY - scroller.clientHeight / 2),
    };
    syncPreviewTopScroll(scroller.scrollLeft);
  };

  const handlePreviewTopScroll = () => {
    const scroller = previewScrollerRef.current;
    const topScroller = previewTopScrollRef.current;
    if (
      !scroller ||
      !topScroller ||
      previewSyncingScrollRef.current ||
      previewBodyCenterX === null
    ) {
      return;
    }

    previewSyncingScrollRef.current = true;
    scroller.scrollLeft = topScroller.scrollLeft;
    previewSyncingScrollRef.current = false;
    previewPanOffsetRef.current = {
      ...previewPanOffsetRef.current,
      x:
        topScroller.scrollLeft -
        (previewBodyCenterX - scroller.clientWidth / 2),
    };
  };

  const rotatePreviewDirection = (offset: number) => {
    const currentIndex = PREVIEW_ROTATION_DIRS.indexOf(cyborg.selected_dir);
    const safeIndex = currentIndex >= 0 ? currentIndex : 0;
    const nextIndex =
      (safeIndex + offset + PREVIEW_ROTATION_DIRS.length) %
      PREVIEW_ROTATION_DIRS.length;
    act('set_cyborg_preview_dir', { dir: PREVIEW_ROTATION_DIRS[nextIndex] });
  };

  const departmentPreviewOptions =
    (cyborg.department_previews as CyborgPreviewVisualOption[] | undefined) ||
    cyborg.models.map((department) => ({
      value: department,
      label: department,
    }));
  const modelPreviewOptions =
    (cyborg.model_previews as CyborgPreviewVisualOption[] | undefined) ||
    (cyborg.models_by_department?.[cyborg.selected_department] || []).map(
      (model) => ({
        value: model,
        label: model,
      }),
    );
  const statePreviewOptions = (cyborg.states ||
    []) as CyborgPreviewStateOption[];
  const departmentTooltip = (option: CyborgPreviewChoice) =>
    option.preview_model
      ? `${option.label}: ${option.preview_model}`
      : option.label;
  const activePreviewPicker =
    openPreviewPicker === 'department'
      ? {
          options: departmentPreviewOptions,
          selected: cyborg.selected_department,
          tooltipFor: departmentTooltip,
          onSelect: (value: string) =>
            act('set_cyborg_preview_department', {
              department: value,
            }),
        }
      : openPreviewPicker === 'model'
        ? {
            options: modelPreviewOptions,
            selected: cyborg.selected_model,
            tooltipFor: undefined,
            onSelect: (value: string) =>
              act('set_cyborg_preview_model', { model: value }),
          }
        : openPreviewPicker === 'state'
          ? {
              options: statePreviewOptions,
              selected: cyborg.selected_state,
              tooltipFor: undefined,
              onSelect: (value: string) =>
                act('set_cyborg_preview_state', { state: value }),
            }
          : null;

  const visualsPage = (
    <Stack vertical fill style={{ height: '100%', overflow: 'hidden' }}>
      <Stack.Item grow={0}>
        <Section title="Preview">
          <Box
            style={{
              alignItems: 'center',
              display: 'flex',
              flexDirection: 'column',
              maxHeight: '760px',
              overflowX: 'hidden',
              overflowY: 'auto',
              width: '100%',
            }}
          >
            <Box style={{ maxWidth: PREVIEW_MAP_SIZE, width: '100%' }}>
              <Stack mb={0.75}>
                <Stack.Item>
                  <CyborgPreviewSelectedButton
                    label="Department"
                    options={departmentPreviewOptions}
                    selected={cyborg.selected_department}
                    open={openPreviewPicker === 'department'}
                    tooltipFor={departmentTooltip}
                    onToggle={() =>
                      setOpenPreviewPicker(
                        openPreviewPicker === 'department'
                          ? null
                          : 'department',
                      )
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <CyborgPreviewSelectedButton
                    label="Model"
                    options={modelPreviewOptions}
                    selected={cyborg.selected_model}
                    open={openPreviewPicker === 'model'}
                    onToggle={() =>
                      setOpenPreviewPicker(
                        openPreviewPicker === 'model' ? null : 'model',
                      )
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <CyborgPreviewSelectedButton
                    label="State"
                    options={statePreviewOptions}
                    selected={cyborg.selected_state}
                    open={openPreviewPicker === 'state'}
                    onToggle={() =>
                      setOpenPreviewPicker(
                        openPreviewPicker === 'state' ? null : 'state',
                      )
                    }
                  />
                </Stack.Item>
              </Stack>
              {activePreviewPicker && (
                <CyborgPreviewOptionTray
                  options={activePreviewPicker.options}
                  selected={activePreviewPicker.selected}
                  tooltipFor={activePreviewPicker.tooltipFor}
                  onSelect={(value) => {
                    setOpenPreviewPicker(null);
                    activePreviewPicker.onSelect(value);
                  }}
                />
              )}
              <CyborgPreviewControlRow label="Direction">
                <Stack>
                  <Stack.Item>
                    <Button
                      icon="rotate-left"
                      content="Rotate Left"
                      onClick={() => rotatePreviewDirection(1)}
                    />
                  </Stack.Item>
                  <Stack.Item grow textAlign="center" color="label">
                    {cyborg.selected_dir}
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="rotate-right"
                      content="Rotate Right"
                      onClick={() => rotatePreviewDirection(-1)}
                    />
                  </Stack.Item>
                </Stack>
              </CyborgPreviewControlRow>
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
            </Box>
            <StopWindowDrag>
              <Box
                ref={previewTopScrollRef}
                onScroll={handlePreviewTopScroll}
                style={{
                  backgroundColor: '#000',
                  height: '14px',
                  maxWidth: PREVIEW_MAP_SIZE,
                  overflowX: 'auto',
                  overflowY: 'hidden',
                  width: '100%',
                }}
              >
                <Box
                  style={{
                    height: '1px',
                    width: `${previewCanvasWidth * previewZoom}px`,
                  }}
                />
              </Box>
            </StopWindowDrag>
            <Box
              ref={previewScrollerRef}
              onScroll={handlePreviewScroll}
              style={{
                alignItems: 'center',
                backgroundColor: '#000',
                display: 'flex',
                height: PREVIEW_MAP_SIZE,
                justifyContent: 'center',
                overflowX: 'hidden',
                overflowY: 'auto',
                width: PREVIEW_MAP_SIZE,
              }}
            >
              {!!previewLayers.length && (
                <Box
                  style={{
                    height: `${previewCanvasHeight * previewZoom}px`,
                    position: 'relative',
                    width: `${previewCanvasWidth * previewZoom}px`,
                  }}
                >
                  {previewLayers.map((layer) => (
                    <img
                      alt=""
                      key={layer.key}
                      src={layer.image}
                      style={{
                        height: `${layer.height * previewZoom}px`,
                        imageRendering: 'pixelated',
                        left: `${layer.x * previewZoom}px`,
                        position: 'absolute',
                        top: `${
                          (previewCanvasHeight - layer.y - layer.height) *
                          previewZoom
                        }px`,
                        width: `${layer.width * previewZoom}px`,
                        zIndex: layer.z,
                      }}
                    />
                  ))}
                </Box>
              )}
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
