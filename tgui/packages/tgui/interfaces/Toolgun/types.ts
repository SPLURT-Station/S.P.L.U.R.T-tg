export type ToolgunTypeNode = {
  id: string;
  parent: string;
  name: string;
};

export type ToolgunObject = {
  type: string;
  name: string;
  icon: string;
  icon_state: string;
};

export type ToolgunModeEntry = {
  mode_key: string;
  name: string;
};

export type ToolgunData = {
  mode_name: string;
  mode_desc: string;
  mode_key?: string;
  selected_mode_key?: string;
  available_modes?: ToolgunModeEntry[];
  selected_type?: string;
  selected_turf?: string;
  browse_path?: string;
  search?: string;
  has_more?: boolean;
  visible_count?: number;
  match_count?: number;
  loaded_limit?: number;
  page_size?: number;
  use_custom_color?: boolean;
  custom_color?: string;
  custom_density?: boolean;
  custom_opacity?: boolean;
  custom_indestructible?: boolean;
  build_action?: 'brush' | 'fill' | 'wand';
  wand_range?: number;
  selected_color?: string;
  scale_value?: number;
  type_nodes: Record<string, ToolgunTypeNode>;
  objects?: ToolgunObject[];
  objects_all?: ToolgunObject[];
  turfs?: ToolgunObject[];
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
};
