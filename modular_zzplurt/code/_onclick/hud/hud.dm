// SPLURT EDIT - Extra inventory

GLOBAL_LIST_INIT(extra_inventory_ui_styles, list(
	'icons/hud/screen_midnight.dmi' = 'modular_zzplurt/icons/hud/screen_midnight.dmi',
	'icons/hud/screen_retro.dmi' = 'modular_zzplurt/icons/hud/screen_retro.dmi',
	'icons/hud/screen_plasmafire.dmi' = 'modular_zzplurt/icons/hud/screen_plasmafire.dmi',
	'icons/hud/screen_slimecore.dmi' = 'modular_zzplurt/icons/hud/screen_slimecore.dmi',
	'icons/hud/screen_operative.dmi' = 'modular_zzplurt/icons/hud/screen_operative.dmi',
	'icons/hud/screen_clockwork.dmi' = 'modular_zzplurt/icons/hud/screen_clockwork.dmi',
))

/proc/extra_inventory_ui_style(ui_style)
	return GLOB.extra_inventory_ui_styles[ui_style] || GLOB.extra_inventory_ui_styles[GLOB.extra_inventory_ui_styles[1]]

/datum/hud
	/// Whether the extra inventory panel (underwear/socks/etc) is currently shown
	var/extra_shown = FALSE

/datum/hud/update_ui_style(new_ui_style)
	var/old_extra_style = extra_inventory_ui_style(ui_style)
	var/new_extra_style = extra_inventory_ui_style(new_ui_style)

	. = ..()

	if(old_extra_style == new_extra_style)
		return

	for(var/atom/movable/screen/item as anything in screen_groups[HUD_GROUP_EXTRA_INVENTORY])
		if(item.icon == old_extra_style)
			item.icon = new_extra_style

	var/atom/movable/screen/toggle_extra = screen_objects[HUD_HUMAN_TOGGLE_EXTRA_INVENTORY]
	if(toggle_extra?.icon == old_extra_style)
		toggle_extra.icon = new_extra_style
