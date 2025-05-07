/datum/species/jelly/on_species_gain(mob/living/carbon/new_jellyperson, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	var/mob/living/carbon/human/H = new_jellyperson
	if(istype(H))
		var/datum/action/innate/slime_blobform/blobform = new
		blobform.Grant(H)

/datum/species/jelly/on_species_loss(mob/living/carbon/former_jellyperson, datum/species/new_species, pref_load)
	var/mob/living/carbon/human/H = former_jellyperson
	if(istype(H))
		var/datum/action/innate/slime_blobform/blobform = locate() in H.actions
		if(blobform)
			blobform.Remove(H)
	. = ..()

// Slime Blobform Action
/datum/action/innate/slime_blobform
	name = "Puddle Transformation"
	desc = "Transform into a slime puddle, allowing you to move under doors and tables."
	check_flags = AB_CHECK_CONSCIOUS
	button_icon = 'modular_zzplurt/icons/mob/actions/actions_slime.dmi'
	button_icon_state = "slimepuddle"
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	var/is_puddle = FALSE
	var/in_transformation_duration = 1.2 SECONDS
	var/out_transformation_duration = 0.7 SECONDS
	var/puddle_icon = 'modular_zzplurt/icons/mob/effects/slime.dmi'
	var/puddle_state = "puddle"
	var/mutable_appearance/tracked_overlay
	var/datum/component/squeak/squeak
	var/transforming = FALSE
	var/original_mobility_flags
	var/original_pass_flags

/datum/action/innate/slime_blobform/IsAvailable(feedback = FALSE)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	if(transforming)
		return FALSE
	return TRUE

/datum/action/innate/slime_blobform/Remove(mob/removed_from)
	if(is_puddle)
		detransform()
	return ..()

/datum/action/innate/slime_blobform/Activate()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return

	if(IsAvailable())
		var/mutcolor = H.dna.features["mcolor"]
		if(!is_puddle)
			if(H.mobility_flags & MOBILITY_USE)
				transforming = TRUE
				is_puddle = TRUE
				owner.cut_overlays()
				ADD_TRAIT(H, TRAIT_INVISIBLE_MAN, SLIMEPUDDLE_TRAIT)
				var/obj/effect/puddle_effect = new /obj/effect/temp_visual/slime_puddle(get_turf(owner), owner.dir)
				playsound(owner, 'modular_zzplurt/sound/effects/changed_transfur.ogg', 50)
				puddle_effect.color = sanitize_hexcolor(mutcolor)
				puddle_effect.transform = H.transform
				H.Stun(in_transformation_duration, ignore_canstun = TRUE)

				ADD_TRAIT(H, TRAIT_PARALYSIS_L_ARM, SLIMEPUDDLE_TRAIT)
				ADD_TRAIT(H, TRAIT_PARALYSIS_R_ARM, SLIMEPUDDLE_TRAIT)
				original_mobility_flags = H.mobility_flags
				H.mobility_flags &= ~MOBILITY_PICKUP
				H.mobility_flags &= ~MOBILITY_USE
				H.mobility_flags &= ~MOBILITY_REST
				H.mobility_flags &= ~MOBILITY_LIEDOWN
				// These traits don't exist in TG, except added to a bunch of other traits. In case there's balance issues we'll need to refractor this or remove it.
				//ADD_TRAIT(H, TRAIT_SPRINT_LOCKED, SLIMEPUDDLE_TRAIT)
				//ADD_TRAIT(H, TRAIT_ARMOR_BROKEN, SLIMEPUDDLE_TRAIT)

				H.add_movespeed_modifier(/datum/movespeed_modifier/slime_puddle)

				original_pass_flags = H.pass_flags
				H.pass_flags |= PASSMOB
				H.pass_flags |= PASSTABLE
				H.layer = 3
				squeak = H.AddComponent(/datum/component/squeak, list('sound/effects/blob/blobattack.ogg'))

				sleep(in_transformation_duration)

				var/mutable_appearance/puddle_overlay = mutable_appearance(icon = puddle_icon, icon_state = puddle_state, color = sanitize_hexcolor(mutcolor))
				tracked_overlay = puddle_overlay
				owner.add_overlay(puddle_overlay)
				owner.update_body()

				transforming = FALSE
		else
			detransform()
	else
		owner.balloon_alert(owner, "can't transform while immobilized!")

/datum/action/innate/slime_blobform/proc/detransform()
	var/mob/living/carbon/human/H = owner
	H.cut_overlay(tracked_overlay)
	var/obj/effect/puddle_effect = new /obj/effect/temp_visual/slime_puddle/reverse(get_turf(owner), owner.dir)
	playsound(H, 'modular_zzplurt/sound/effects/changed_transfur.ogg', 50)
	puddle_effect.color = tracked_overlay.color
	puddle_effect.transform = H.transform
	H.Stun(out_transformation_duration, ignore_canstun = TRUE)
	sleep(out_transformation_duration)

	REMOVE_TRAIT(H, TRAIT_PARALYSIS_L_ARM, SLIMEPUDDLE_TRAIT)
	REMOVE_TRAIT(H, TRAIT_PARALYSIS_R_ARM, SLIMEPUDDLE_TRAIT)
	REMOVE_TRAIT(H, TRAIT_INVISIBLE_MAN, SLIMEPUDDLE_TRAIT)
	H.mobility_flags = original_mobility_flags
	H.pass_flags = original_pass_flags
	H.layer = initial(H.layer)
	//REMOVE_TRAIT(H, TRAIT_SPRINT_LOCKED, SLIMEPUDDLE_TRAIT)
	//REMOVE_TRAIT(H, TRAIT_ARMOR_BROKEN, SLIMEPUDDLE_TRAIT)
	H.remove_movespeed_modifier(/datum/movespeed_modifier/slime_puddle)
	H.pass_flags &= ~PASSMOB
	is_puddle = FALSE
	if(squeak)
		qdel(squeak)
	H.regenerate_icons()
	transforming = FALSE

// Slime puddle movespeed modifier
/datum/movespeed_modifier/slime_puddle
	multiplicative_slowdown = 4

// Visual effects for slime puddle transformation
/obj/effect/temp_visual/slime_puddle
	icon = 'modular_zzplurt/icons/mob/effects/slime.dmi'
	icon_state = "to_puddle"
	duration = /datum/action/innate/slime_blobform::in_transformation_duration
	layer = ABOVE_MOB_LAYER

/obj/effect/temp_visual/slime_puddle/reverse
	icon_state = "from_puddle"
	duration = /datum/action/innate/slime_blobform::out_transformation_duration
