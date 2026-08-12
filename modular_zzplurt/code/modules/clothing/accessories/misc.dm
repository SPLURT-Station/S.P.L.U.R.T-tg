/datum/atom_skin/blank_pin
	abstract_type = /datum/atom_skin/blank_pin

/datum/atom_skin/blank_pin/blank
	preview_name = "blank"
	new_icon_state = "pin_blank"

/datum/atom_skin/blank_pin/green
	preview_name = "green"
	new_icon_state = "pin_green"

/datum/atom_skin/blank_pin/yellow
	preview_name = "yellow"
	new_icon_state = "pin_yellow"

/datum/atom_skin/blank_pin/purple
	preview_name = "purple"
	new_icon_state = "pin_purple"

/datum/atom_skin/blank_pin/mute
	preview_name = "mute"
	new_icon_state = "pin_mute"

/datum/atom_skin/blank_pin/xenophilia
	preview_name = "xenophilia"
	new_icon_state = "pin_xenophilia"

/datum/atom_skin/blank_pin/isolation
	preview_name = "isolation"
	new_icon_state = "pin_isolation"

/datum/atom_skin/blank_pin/peace
	preview_name = "peace"
	new_icon_state = "pin_peace"

/datum/atom_skin/blank_pin/shy
	preview_name = "shy"
	new_icon_state = "pin_shy"

/datum/atom_skin/blank_pin/sub
	preview_name = "sub"
	new_icon_state = "pin_sub"

/datum/atom_skin/blank_pin/dom
	preview_name = "dom"
	new_icon_state = "pin_dom"

/datum/atom_skin/blank_pin/switch
	preview_name = "switch"
	new_icon_state = "pin_switch"

/datum/atom_skin/blank_pin/missing_texture
	preview_name = "missing texture"
	new_icon_state = "pin_css"

/obj/item/clothing/accessory/pride/other
	name = "blank pin"
	desc = "A holographic pin for showing off anything you wish. Comes with some basic selection."
	icon = 'modular_zzplurt/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/accessories.dmi'
	icon_state = "pin_blank"

/obj/item/clothing/accessory/pride/other/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/blank_pin)
