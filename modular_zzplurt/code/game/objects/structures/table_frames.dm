/*
 * Shadow Wood Frames
 */

/obj/structure/table_frame/shadow_wood
	name = "shadow wood frame"
	desc = "Four wooden legs with four framing wooden rods for a wooden table. You could easily pass through this."
	icon = 'modular_zzplurt/icons/obj/structures.dmi'
	icon_state = "table_frame_shadow"
	base_icon_state = "table_frame_shadow"
	framestack = /obj/item/stack/sheet/mineral/wood/shadow
	framestackamount = 2
	resistance_flags = FLAMMABLE

/obj/structure/table/shadow_wood
	name = "shadow wood table"
	desc = "Do not apply fire to this. Rumour says it burns easily."
	icon = '/modular_zzplurt/icons/obj/smooth_structures/table_shadow.dmi'
	icon_state = "table_shadow"
	base_icon_state = "table_shadow"
	frame = /obj/structure/table_frame/shadow_wood
	framestack = /obj/item/stack/sheet/mineral/wood/shadow
	buildstack = /obj/item/stack/sheet/mineral/wood/shadow
	resistance_flags = FLAMMABLE
	max_integrity = 70
