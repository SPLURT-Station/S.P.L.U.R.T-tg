// SPLURT EDIT - Extra inventory slots & toggle, using the new HUD group / inventory_slot system

/datum/hud/human/initialize_screen_objects()
	. = ..()

	var/extra_style = extra_inventory_ui_style(ui_style)
	add_screen_object(/atom/movable/screen/human/toggle/extra, HUD_HUMAN_TOGGLE_EXTRA_INVENTORY, HUD_GROUP_TOGGLEABLE_INVENTORY, extra_style, ui_inventory_extra)
	thirst = add_screen_object(/atom/movable/screen/thirst, HUD_MOB_THIRST, HUD_GROUP_INFO) // SPLURT ADDITION - THIRST

/// Shared create helper for extra inventory slots that use the custom extra UI style
/datum/inventory_slot/human/proc/create_extra_element(datum/hud/hud)
	var/atom/movable/screen/inventory/inv_box = hud.add_screen_object(screen_type, HUD_KEY_ITEM_SLOT(slot_id), screen_group, extra_inventory_ui_style(hud.ui_style), screen_loc)
	inv_box.name = name
	inv_box.icon_state = icon_state
	inv_box.icon_full = icon_full
	inv_box.icon_empty = icon_state
	inv_box.slot_id = slot_id
	return inv_box

/datum/inventory_slot/human/underwear
	name = "underwear"
	slot_id = ITEM_SLOT_UNDERWEAR
	icon_state = "underwear"
	icon_full = "template"
	screen_loc = ui_boxers
	screen_group = HUD_GROUP_EXTRA_INVENTORY
	inherit_style = FALSE

/datum/inventory_slot/human/underwear/create_element(datum/hud/hud)
	return create_extra_element(hud)

/datum/inventory_slot/human/socks
	name = "socks"
	slot_id = ITEM_SLOT_SOCKS
	icon_state = "socks"
	icon_full = "template"
	screen_loc = ui_socks
	screen_group = HUD_GROUP_EXTRA_INVENTORY
	inherit_style = FALSE

/datum/inventory_slot/human/socks/create_element(datum/hud/hud)
	return create_extra_element(hud)

/datum/inventory_slot/human/shirt
	name = "shirt"
	slot_id = ITEM_SLOT_SHIRT
	icon_state = "shirt"
	icon_full = "template"
	screen_loc = ui_shirt
	screen_group = HUD_GROUP_EXTRA_INVENTORY
	inherit_style = FALSE

/datum/inventory_slot/human/shirt/create_element(datum/hud/hud)
	return create_extra_element(hud)

/datum/inventory_slot/human/bra
	name = "bra"
	slot_id = ITEM_SLOT_BRA
	icon_state = "bra"
	icon_full = "template"
	screen_loc = ui_bra
	screen_group = HUD_GROUP_EXTRA_INVENTORY
	inherit_style = FALSE

/datum/inventory_slot/human/bra/create_element(datum/hud/hud)
	return create_extra_element(hud)

/datum/inventory_slot/human/ears_extra
	name = "right ear"
	slot_id = ITEM_SLOT_EARS_RIGHT
	icon_state = "ears_extra"
	icon_full = "template"
	screen_loc = ui_ears_extra
	screen_group = HUD_GROUP_EXTRA_INVENTORY
	inherit_style = FALSE

/datum/inventory_slot/human/ears_extra/create_element(datum/hud/hud)
	return create_extra_element(hud)

/datum/inventory_slot/human/wrists
	name = "wrists"
	slot_id = ITEM_SLOT_WRISTS
	icon_state = "wrists"
	icon_full = "template"
	screen_loc = ui_wrists
	screen_group = HUD_GROUP_EXTRA_INVENTORY
	inherit_style = FALSE

/datum/inventory_slot/human/wrists/create_element(datum/hud/hud)
	return create_extra_element(hud)

/atom/movable/screen/human/toggle/extra
	name = "toggle extra"
	icon_state = "toggle_extra"
	base_icon_state = "toggle_extra"
	screen_loc = ui_inventory_extra

/atom/movable/screen/human/toggle/extra/Click()
	var/mob/targetmob = usr

	if(isobserver(usr))
		if(ishuman(usr.client.eye) && (usr.client.eye != usr))
			var/mob/M = usr.client.eye
			targetmob = M

	if(!targetmob.hud_used)
		return

	if(usr.hud_used.extra_shown)
		usr.hud_used.extra_shown = FALSE
		usr.client.screen -= targetmob.hud_used.screen_groups[HUD_GROUP_EXTRA_INVENTORY]
	else
		usr.hud_used.extra_shown = TRUE
		if(usr.hud_used.inventory_shown)
			usr.client.screen += targetmob.hud_used.screen_groups[HUD_GROUP_EXTRA_INVENTORY]
