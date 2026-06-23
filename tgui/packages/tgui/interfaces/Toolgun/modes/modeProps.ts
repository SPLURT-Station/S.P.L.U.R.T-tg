import type { ToolgunObject, ToolgunTypeNode } from '../types';

export type ModeAct = (
  action: string,
  payload?: Record<string, unknown>,
) => void;

export type SpawnModeProps = {
  act: ModeAct;
  modeKey: string;
  search: string;
  normalizedSearch: string;
  hasMore: boolean;
  visibleCount: number;
  matchCount: number;
  selectedEntry: ToolgunObject | undefined;
  selectedPath: string;
  visibleObjects: ToolgunObject[];
  currentBrowsePath: string;
  childrenByParent: Record<string, ToolgunTypeNode[]>;
  currentChildNodes: ToolgunTypeNode[];
  useCustomColor: boolean;
  customColor: string;
  customDensity: boolean;
  customOpacity: boolean;
  customIndestructible: boolean;
  mob_ai_controller?: string;
  mob_max_health?: number;
  mob_health?: number;
  mob_bodytemperature?: number;
  mob_min_temperature?: number;
  mob_max_temperature?: number;
  mob_need_atmosphere?: boolean;
  mob_unsuitable_atmos_damage?: number;
  mob_melee_damage_lower?: number;
  mob_melee_damage_upper?: number;
  onSearchChange: (value: string) => void;
};

export type BuildModeProps = {
  act: ModeAct;
  search: string;
  normalizedSearch: string;
  hasMore: boolean;
  visibleCount: number;
  matchCount: number;
  selectedPath: string;
  selectedEntry: ToolgunObject | undefined;
  turfs: ToolgunObject[];
  currentBrowsePath: string;
  childrenByParent: Record<string, ToolgunTypeNode[]>;
  currentChildNodes: ToolgunTypeNode[];
  buildAction: 'brush' | 'fill' | 'wand';
  wandRange: number;
  useCustomColor: boolean;
  customColor: string;
  customDensity: boolean;
  customOpacity: boolean;
  customIndestructible: boolean;
  onSearchChange: (value: string) => void;
};

export type ColorModeProps = {
  act: ModeAct;
  selectedColor: string;
};

export type ResizeModeProps = {
  act: ModeAct;
  scaleValue: number;
};
