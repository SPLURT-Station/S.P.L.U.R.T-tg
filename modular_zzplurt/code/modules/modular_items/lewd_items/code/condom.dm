/obj/item/clothing/sextoy/condom
	icon = 'modular_zzplurt/icons/obj/lewd/condom.dmi'
	/// Maximum reagent capacity before the condom bursts
	var/max_volume = 300

/obj/item/clothing/sextoy/condom/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/floor_placeable)
	create_reagents(max_volume, OPENCONTAINER | INJECTABLE | DRAWABLE | NO_REACT)
	RegisterSignal(reagents, COMSIG_REAGENTS_HOLDER_UPDATED, PROC_REF(on_reagent_change))

/obj/item/clothing/sextoy/condom/proc/on_reagent_change(datum/reagents/holder, ...)
	SIGNAL_HANDLER
	if(condom_state == TRAIT_CONDOM_BROKEN)
		return
	switch(reagents.total_volume)
		if(1 to 49)
			name = "filled condom"
			condom_state = "inflated"
		if(50 to 100)
			name = "filled condom"
			condom_state = "inflated_med"
		if(101 to 249)
			name = "large filled condom"
			condom_state = "inflated_large"
		if(250 to INFINITY)
			name = "huge filled condom"
			condom_state = "inflated_huge"
		else
			if(condom_state != "unused" && condom_state != "used")
				name = "used condom"
				condom_state = "dirty"
	update_appearance()

/obj/item/clothing/sextoy/condom/condom_use()
	if(condom_state == TRAIT_CONDOM_BROKEN)
		return
	if(ishuman(loc))
		var/mob/living/carbon/human/wearer = loc
		var/obj/item/organ/genital/testicles/testicles = wearer.get_organ_slot(ORGAN_SLOT_TESTICLES)
		if(testicles?.reagents && testicles.cumshot_size > 0)
			if(reagents.holder_full())
				name = "broken condom"
				condom_state = TRAIT_CONDOM_BROKEN
				wearer.add_cum_splatter_floor(get_turf(wearer), cum_reagent = testicles.internal_fluid_datum)
				reagents.expose(get_turf(wearer), TOUCH)
				reagents.clear_reagents()
				playsound(get_turf(wearer), 'sound/effects/splat.ogg', 50, TRUE)
				update_appearance()
				return
			testicles.reagents.trans_to(src, testicles.cumshot_size, transferred_by = wearer, copy_only = TRUE)
			return
	return ..()

/obj/item/clothing/sextoy/condom/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!. && reagents?.total_volume > 0)
		splat(hit_atom)

/obj/item/clothing/sextoy/condom/proc/splat(atom/hit_atom)
	if(isliving(loc))
		return
	var/turf/target_turf = get_turf(hit_atom)
	if(target_turf)
		new /obj/effect/decal/cleanable/cum(target_turf)
		reagents.expose(hit_atom, TOUCH)
		if(hit_atom != target_turf)
			reagents.expose(target_turf, TOUCH)
		playsound(target_turf, 'sound/effects/splat.ogg', 50, TRUE)
	qdel(src)
