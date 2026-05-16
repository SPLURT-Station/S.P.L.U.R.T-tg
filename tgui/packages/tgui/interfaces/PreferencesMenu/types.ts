import type { BooleanLike } from 'tgui-core/react';

import type { sendAct } from '../../events/act';
import type {
  LoadoutCategory,
  LoadoutList,
  typePath,
} from './CharacterPreferences/loadout/base';
import type { Gender } from './preferences/gender';

export enum Food {
  Alcohol = 'ALCOHOL',
  Breakfast = 'BREAKFAST',
  Bugs = 'BUGS',
  Cloth = 'CLOTH',
  Dairy = 'DAIRY',
  Fried = 'FRIED',
  Fruit = 'FRUIT',
  Gore = 'GORE',
  Grain = 'GRAIN',
  Gross = 'GROSS',
  Junkfood = 'JUNKFOOD',
  Meat = 'MEAT',
  Nuts = 'NUTS',
  Oranges = 'ORANGES',
  Pineapple = 'PINEAPPLE',
  Raw = 'RAW',
  Seafood = 'SEAFOOD',
  Stone = 'STONE',
  Sugar = 'SUGAR',
  Toxic = 'TOXIC',
  Vegetables = 'VEGETABLES',
  Bloody = 'BLOODY', // SKYRAT EDIT ADDITION - Hemophage Food
}

export enum JobPriority {
  Low = 1,
  Medium = 2,
  High = 3,
}

export type Name = {
  can_randomize: BooleanLike;
  explanation: string;
  group: string;
};

export type Species = {
  name: string;
  desc: string[];
  lore: string[];
  icon: string;
  sort_bottom: BooleanLike;
  //BUBBER EDIT ADD: Sort_bottom, whether a species is sorted to the bottom of the list.

  use_skintones: BooleanLike;
  sexes: BooleanLike;

  enabled_features: string[];

  perks: {
    positive: Perk[];
    negative: Perk[];
    neutral: Perk[];
  };

  diet?: {
    liked_food: Food[];
    disliked_food: Food[];
    toxic_food: Food[];
  };
};

export type Perk = {
  ui_icon: string;
  name: string;
  description: string;
};

export type Department = {
  head?: string;
};

export type Job = {
  description: string;
  department: string;
  // SKYRAT EDIT
  alt_titles?: string[];
  // SKYRAT EDIT END
};

export type Quirk = {
  description: string;
  icon: string;
  name: string;
  value: number;
  customizable: boolean;
  customization_options?: string[];
};

// SKYRAT EDIT START
export type Language = {
  description: string;
  name: string;
  icon: string;
  can_understand: boolean;
  can_speak: boolean;
};

export type Marking = {
  name: string;
  color: string;
  marking_id: string;
};

export type MarkingData = {
  marking_choices: string[];
  markings_list: Marking[];
};

export type Limb = {
  slot: string;
  name: string;
  can_augment: boolean;
  chosen_aug: string;
  chosen_style: string;
  aug_choices: Record<string, string>;
  costs: Record<string, number>;
  markings: MarkingData;
};

export type Organ = {
  slot: string;
  name: string;
  chosen_organ: string;
  organ_choices: Record<string, string>;
  costs: Record<string, number>;
};

// SKYRAT EDIT END
export type QuirkInfo = {
  max_positive_quirks: number;
  quirk_info: Record<string, Quirk>;
  quirk_blacklist: string[][];
  points_enabled: boolean;
};

export type Personality = {
  name: string;
  description: string;
  pos_gameplay_description: string | null;
  neg_gameplay_description: string | null;
  neut_gameplay_description: string | null;
  path: typePath;
  groups: string[] | null;
};

export enum RandomSetting {
  AntagOnly = 1,
  Disabled = 2,
  Enabled = 3,
}

export enum JoblessRole {
  BeOverflow = 1,
  BeRandomJob = 2,
  ReturnToLobby = 3,
}

export enum GamePreferencesSelectedPage {
  Settings,
  Keybindings,
}

export const createSetPreference =
  (act: typeof sendAct, preference: string) => (value: unknown) => {
    act('set_preference', {
      preference,
      value,
    });
  };

export enum PrefsWindow {
  Character = 0,
  Game = 1,
  Keybindings = 2,
}

export type CharacterPreferencesData = {
  character_preview_view: string;
  character_profiles: (string | null)[];

  cyborg_character?: CyborgCharacterData;

  preview_options: string[]; // SKYRAT EDIT ADDITION
  preview_selection: string; // SKYRAT EDIT ADDITION

  clothing: Record<string, string>;
  features: Record<string, string>;
  game_preferences: Record<string, unknown>;
  non_contextual: {
    random_body: RandomSetting;
    [otherKey: string]: unknown;
  };
  secondary_features: Record<string, unknown>;
  character_basics: Record<string, unknown>; // BUBBER EDIT ADDITION: more character setup tabs
  ooc_preferences: Record<string, unknown>; // BUBBER EDIT ADDITION: more character setup tabs
  supplemental_features: Record<string, unknown>;
  manually_rendered_features: Record<string, string>;

  names: Record<string, string>;

  misc: {
    gender: Gender;
    joblessrole: JoblessRole;
    species: string;
    loadout_lists: LoadoutList; // BUBBER EDIT: Multiple loadout presets: ORIGINAL: loadout_list: LoadoutList;
    job_clothes: BooleanLike;
    loadout_index: string; // BUBBER EDIT ADDITION: Multiple loadout presets
    background_state: string; // BUBBER EDIT ADDITION: Swappable character editor backgrounds
  };

  randomization: Record<string, RandomSetting>;
};

export type PreferencesMenuData = {
  character_preview_view: string;
  character_profiles: (string | null)[];

  character_preferences: CharacterPreferencesData;

  content_unlocked: BooleanLike;

  job_bans?: string[];
  job_days_left?: Record<string, number>;
  job_required_experience?: Record<
    string,
    {
      experience_type: string;
      required_playtime: number;
    }
  >;
  job_preferences: Record<string, JobPriority>;

  // SKYRAT EDIT
  job_alt_titles: Record<string, string>;

  robotic_styles: string[];
  limbs_data: Limb[];
  organs_data: Organ[];
  marking_presets: string[];

  selected_languages: Language[];
  unselected_languages: Language[];
  total_language_points: number;
  quirks_balance: number;
  positive_quirk_count: number;
  species_restricted_jobs?: string[];
  ckey: string;
  // SKYRAT EDIT END
  // SPLURT EDIT START
  donator_tier: number;
  // SPLURT EDIT END

  keybindings: Record<string, string[]>;
  overflow_role: string;
  default_quirk_balance: number;
  selected_quirks: string[];
  selected_personalities: typePath[] | null;
  max_personalities: number;
  mood_enabled: BooleanLike;
  species_disallowed_quirks: string[];

  antag_bans?: string[];
  antag_days_left?: Record<string, number>;
  selected_antags: string[];

  active_slot: number;
  name_to_use: string;

  window: PrefsWindow;
};

export type CyborgDirectionalOverride = {
  visible?: BooleanLike;
  pixel_x?: number;
  pixel_y?: number;
  rotation?: number;
  priority?: number;
};

export type CyborgDirectionalLayout = {
  visible: BooleanLike;
  pixel_x: number;
  pixel_y: number;
  rotation: number;
  priority: number;
  arousal?: Record<string, CyborgDirectionalOverride>;
};

export type CyborgReproductionGenital = {
  slot: string;
  name: string;
  sprite: string;
  has_sprite: BooleanLike;
  visible: BooleanLike;
  can_arouse: BooleanLike;
  aroused: number;
  arousal_label: string;
  pixel_x: number;
  pixel_y: number;
  rotation: number;
  scale: number;
  direction_pixel_x: number;
  direction_pixel_y: number;
  direction_rotation: number;
  direction_visible: BooleanLike;
  scale_limit: number;
  body_scale: number;
  offset_limit: number;
  colors: (string | null)[];
  color_layers: string[] | Record<string, string>;
  resolved_colors: (string | null)[];
  preview_color: string;
  advanced: Record<string, CyborgDirectionalLayout>;
};

export type CyborgOffsetDirection = {
  value: string;
  label: string;
};

export type CyborgReproductionManagement = {
  enabled: BooleanLike;
  presetLimit: number;
  presets: { name: string }[];
  genitals: CyborgReproductionGenital[];
  offset_directions: CyborgOffsetDirection[];
  model_department: string;
  model_name: string;
  model_key: string;
  has_model_default: BooleanLike;
};

export type CyborgModelCatalog = Record<string, string[]>;

export type CyborgPreviewStateOption = {
  value: string;
  label: string;
  icon_state: string;
  movement: boolean;
  preview_image?: string | null;
};

export type CyborgPreviewVisualOption = {
  value: string;
  label: string;
  preview_image?: string | null;
  preview_model?: string;
};

export type CyborgCharacterData = {
  preview: string;
  preview_image: string | null;
  preview_layers: {
    key: string;
    kind: string;
    image: string;
    x: number;
    y: number;
    width: number;
    height: number;
    z: number;
  }[];
  preview_canvas_width: number;
  preview_canvas_height: number;
  models: string[];
  models_by_department: CyborgModelCatalog;
  department_previews: CyborgPreviewVisualOption[];
  model_previews: CyborgPreviewVisualOption[];
  selected_department: string;
  selected_model: string;
  selected_state: string;
  base_state: string;
  states: CyborgPreviewStateOption[];
  selected_dir: string;
  preview_width: number;
  preview_height: number;
  size: number;
  size_options: number[];
  reproductionManagement: CyborgReproductionManagement;
};

export type ServerData = {
  jobs: {
    departments: Record<string, Department>;
    jobs: Record<string, Job>;
  };
  names: {
    types: Record<string, Name>;
  };
  quirks: QuirkInfo;
  personality: {
    personalities: Personality[];
    personality_incompatibilities: Record<string, string[]>;
  };
  random: {
    randomizable: string[];
  };
  loadout: {
    loadout_tabs: LoadoutCategory[];
  };
  species: Record<string, Species>;
  background_state: { choices: string[] }; // BUBBER EDIT ADDITION
  [otheyKey: string]: unknown;
};
