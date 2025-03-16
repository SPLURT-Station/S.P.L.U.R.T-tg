/*
 * Shadow Wood Frames
 */

/obj/structure/table_frame/shadow_wood
	name = "shadow wood frame"
	desc = "Four wooden legs with four framing wooden rods for a wooden table. You could easily pass through this."
	icon = 'modular_zzplurt/icons/obj/structures.dmi'
	icon_state = "table_frame_shadow"
	framestack = /obj/item/stack/sheet/mineral/wood/shadow
	framestackamount = 2
	resistance_flags = FLAMMABLE

/obj/structure/table_frame/shadow_wood/attackby(obj/item/I, mob/user, params)
	if (istype(I, /obj/item/stack))
		var/obj/item/stack/material = I
		var/toConstruct // stores the table variant
		if(istype(I, /obj/item/stack/sheet/mineral/wood/shadow))
			toConstruct = /obj/structure/table/wood/shadow
		else if(istype(I, /obj/item/stack/tile/carpet))
			to_chat(user, span_warning("You can't apply a carpet to this table!"))
			return
		if (toConstruct)
			if(material.get_amount() < 1)
				to_chat(user, span_warning("You need one [material.name] sheet to do this!"))
				return
			to_chat(user, span_notice("You start adding [material] to [src]..."))
			if(do_after(user, 20, target = src) && material.use(1))
				make_new_table(toConstruct)
	else
		return ..()
