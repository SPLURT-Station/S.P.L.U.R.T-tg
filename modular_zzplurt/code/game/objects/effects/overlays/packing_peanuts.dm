/// Crate overlay for packing peanuts
/obj/effect/overlay/packing_peanuts
	name = "packing peanuts"
	desc = "The latest development in cargonian technology. You can safely store your items among these."
	icon = 'modular_zzplurt/icons/obj/crates_peanuts.dmi'
	icon_state = "packing"
	base_icon_state = "packing"
	anchored = TRUE
	plane = FLOAT_PLANE
	layer = FLOAT_LAYER
	vis_flags = VIS_INHERIT_ID
	appearance_flags = KEEP_TOGETHER | LONG_GLIDE | PIXEL_SCALE
	/// We need a reference to our master crate so that when clicked, we try to put items inside the peanuts
	var/obj/structure/closet/peanut_master

/obj/effect/overlay/packing_peanuts/Initialize(mapload, obj/structure/closet/peanut_master)
	. = ..()
	if(peanut_master)
		src.peanut_master = peanut_master
		src.icon = peanut_master.packing_icon
		src.icon_state = peanut_master.packing_icon_state
		src.base_icon_state = peanut_master.packing_icon_state
		update_contents(peanut_master)
	update_appearance(UPDATE_ICON)

/obj/effect/overlay/packing_peanuts/Destroy(force)
	peanut_master = null
	return ..()

/obj/effect/overlay/packing_peanuts/update_icon(updates)
	. = ..()
	add_filter("packing", 1, alpha_mask_filter(icon = icon(src.icon, "[base_icon_state]_mask")))

/obj/effect/overlay/packing_peanuts/update_overlays()
	. = ..()
	. += mutable_appearance(icon, "[base_icon_state]_over", plane = FLOAT_PLANE, layer = ABOVE_MOB_LAYER,  offset_spokesman = (peanut_master || src))

/obj/effect/overlay/packing_peanuts/proc/update_contents(obj/structure/closet/packed_crate)
	vis_contents = packed_crate.contents
	update_appearance(UPDATE_ICON)
