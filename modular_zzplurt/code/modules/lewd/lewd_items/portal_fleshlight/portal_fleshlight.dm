#define URETHRA_TOP "urethra_top"
#define URETHRA_BOTTOM "urethra_bottom"

/obj/item/clothing/sextoy/portal_fleshlight
	name = "portal fleshlight"
	desc = "A silver love(TM) portal fleshlight, with bluespace tech allowing lovers to hump at a distance. Needs to be paired with portal panties before use."
	icon = 'modular_zzplurt/icons/obj/lewd/fleshlight.dmi'
	icon_state = "unpaired"
	w_class = WEIGHT_CLASS_SMALL
	clothing_flags = INEDIBLE_CLOTHING

	/// The linked portal panties
	var/obj/item/clothing/sextoy/portal_panties/linked_panties = null
	/// Whether the fleshlight is useable (has valid configuration)
	var/useable = FALSE
	/// The current target organ for the fleshlight
	var/current_target = ORGAN_SLOT_PENIS
	/// Whether the fleshlight's user is anonymous
	var/anonymous = FALSE
	/// Dictionary mapping panty target and fleshlight target to interaction names
	var/static/list/interaction_map = list(
		ORGAN_SLOT_VAGINA = list(
			ORGAN_SLOT_PENIS = /datum/interaction/lewd/portal/fuck_vagina::name,
			ORGAN_SLOT_VAGINA = /datum/interaction/lewd/portal/tribadism::name,
			ORGAN_SLOT_ANUS = null,
			URETHRA_TOP = null,
			URETHRA_BOTTOM = null,
			BODY_ZONE_PRECISE_MOUTH = /datum/interaction/lewd/portal/oral_vagina::name,
			BODY_ZONE_R_ARM = /datum/interaction/lewd/portal/finger_vagina::name,
			BODY_ZONE_L_ARM = /datum/interaction/lewd/portal/finger_vagina::name,
			BODY_ZONE_R_LEG = /datum/interaction/lewd/portal/feet/footgrind_vagina::name,
			BODY_ZONE_L_LEG = /datum/interaction/lewd/portal/feet/footgrind_vagina::name
		),
		ORGAN_SLOT_ANUS = list(
			ORGAN_SLOT_PENIS = /datum/interaction/lewd/portal/fuck_anus::name,
			ORGAN_SLOT_VAGINA = null,
			ORGAN_SLOT_ANUS = null,
			URETHRA_TOP = null,
			URETHRA_BOTTOM = null,
			BODY_ZONE_PRECISE_MOUTH = /datum/interaction/lewd/portal/oral_anus::name,
			BODY_ZONE_R_ARM = /datum/interaction/lewd/portal/finger_anus::name,
			BODY_ZONE_L_ARM = /datum/interaction/lewd/portal/finger_anus::name,
			BODY_ZONE_R_LEG = /datum/interaction/lewd/portal/feet/footgrind_anus::name,
			BODY_ZONE_L_LEG = /datum/interaction/lewd/portal/feet/footgrind_anus::name
		),
		ORGAN_SLOT_PENIS = list(
			ORGAN_SLOT_PENIS = /datum/interaction/lewd/portal/frotting::name,
			ORGAN_SLOT_VAGINA = /datum/interaction/lewd/portal/vaginal_ride::name,
			ORGAN_SLOT_ANUS = /datum/interaction/lewd/portal/anal_ride::name,
			URETHRA_TOP = /datum/interaction/lewd/portal/fuck_urethra::name,
			URETHRA_BOTTOM = /datum/interaction/lewd/portal/urethral_ride::name,
			BODY_ZONE_PRECISE_MOUTH = /datum/interaction/lewd/portal/oral_penis::name,
			BODY_ZONE_R_ARM = /datum/interaction/lewd/portal/handjob::name,
			BODY_ZONE_L_ARM = /datum/interaction/lewd/portal/handjob::name,
			BODY_ZONE_R_LEG = /datum/interaction/lewd/portal/feet/footjob::name,
			BODY_ZONE_L_LEG = /datum/interaction/lewd/portal/feet/footjob::name
		),
		BODY_ZONE_PRECISE_MOUTH = list(
			ORGAN_SLOT_PENIS = /datum/interaction/lewd/portal/fuck_mouth::name,
			ORGAN_SLOT_VAGINA = null,
			ORGAN_SLOT_ANUS = null,
			URETHRA_TOP = null,
			URETHRA_BOTTOM = null,
			BODY_ZONE_PRECISE_MOUTH = /datum/interaction/lewd/portal/oral_mouth::name,
			BODY_ZONE_R_ARM = /datum/interaction/lewd/portal/finger_mouth::name,
			BODY_ZONE_L_ARM = /datum/interaction/lewd/portal/finger_mouth::name,
			BODY_ZONE_R_LEG = null,
			BODY_ZONE_L_LEG = null
		)
	)

	/// Currently selected base-game plushie typepath for disguising the portal toy, or null for the default appearance
	var/obj/item/toy/plush/plushie_type = null
	/// Custom greyscale colors copied from a greyscale plushie instance, if any
	var/custom_plushie_greyscale_colors = null
	/// Static list of allowed base-game plushie typepaths
	var/static/list/allowed_plushie_types = list(
		/obj/item/toy/plush/abductor,
		/obj/item/toy/plush/abductor/agent,
		/obj/item/toy/plush/awakenedplushie,
		/obj/item/toy/plush/beeplushie,
		/obj/item/toy/plush/skyrat/borbplushie,
		/obj/item/toy/plush/bubbleplush,
		/obj/item/toy/plush/skyrat/cat,
		/obj/item/toy/plush/skyrat/cat/tux,
		/obj/item/toy/plush/skyrat/cat/white,
		/obj/item/toy/plush/skyrat/ian,
		/obj/item/toy/plush/skyrat/ian/lisa,
		/obj/item/toy/plush/skyrat/ian/small,
		/obj/item/toy/plush/skyrat/deer,
		/obj/item/toy/plush/donkpocket,
		/obj/item/toy/plush/skyrat/engihound,
		/obj/item/toy/plush/skyrat/fox,
		/obj/item/toy/plush/horse,
		/obj/item/toy/plush/human,
		/obj/item/toy/plush/lizard_plushie/green,
		/obj/item/toy/plush/lizard_plushie/space/green,
		/obj/item/toy/plush/skyrat/meddrake,
		/obj/item/toy/plush/skyrat/medihound,
		/obj/item/toy/plush/monkey,
		/obj/item/toy/plush/moth,
		/obj/item/toy/plush/narplush,
		/obj/item/toy/plush/nukeplushie,
		/obj/item/toy/plush/pkplush,
		/obj/item/toy/plush/plasmamanplushie,
		/obj/item/toy/plush/ratplush,
		/obj/item/toy/plush/rouny,
		/obj/item/toy/plush/skyrat/scrubpuppy,
		/obj/item/toy/plush/skyrat/secdrake,
		/obj/item/toy/plush/skyrat/sechound,
		/obj/item/toy/plush/shark,
		/obj/item/toy/plush/slimeplushie,
		/obj/item/toy/plush/snakeplushie,
		/obj/item/toy/plush/carpplushie,
		/obj/item/toy/plush/unicorn,
		/obj/item/toy/plush/whiny_plushie,
	)
	/// Static associative list mapping clean plushie names to their typepaths
	var/static/list/name_to_plushie_type
	/// Static associative list of radial menu choices for selecting a plushie appearance
	var/static/list/plushie_designs

/obj/item/clothing/sextoy/portal_fleshlight/Initialize(mapload)
	. = ..()
	if(!length(plushie_designs))
		populate_plushie_designs()
	update_appearance()
	register_context()

/// Populates the static list of plushie design choices for the radial appearance menu
/obj/item/clothing/sextoy/portal_fleshlight/proc/populate_plushie_designs()
	name_to_plushie_type = list()
	plushie_designs = list(
		"Default" = image(icon = initial(icon), icon_state = initial(icon_state)),
	)
	for(var/obj/item/toy/plush/plush_path as anything in allowed_plushie_types)
		var/plush_name = replacetext(initial(plush_path.name), "\improper ", "")
		name_to_plushie_type[plush_name] = plush_path
		plushie_designs[plush_name] = image(icon = initial(plush_path.icon), icon_state = initial(plush_path.icon_state))

/// Sets or resets the plushie disguise appearance for the portal fleshlight/dildo
/obj/item/clothing/sextoy/portal_fleshlight/proc/set_plushie_appearance(new_plushie_type, custom_colors = null)
	plushie_type = new_plushie_type
	custom_plushie_greyscale_colors = custom_colors
	if(plushie_type)
		inhand_icon_state = initial(plushie_type.inhand_icon_state)
		lefthand_file = initial(plushie_type.lefthand_file)
		righthand_file = initial(plushie_type.righthand_file)
	else
		inhand_icon_state = initial(inhand_icon_state)
		lefthand_file = initial(lefthand_file)
		righthand_file = initial(righthand_file)
	update_appearance()
	if(ismob(loc))
		var/mob/holder = loc
		holder.update_held_items()

/// Attempts to copy the appearance of an allowed base-game plushie onto this portal toy
/obj/item/clothing/sextoy/portal_fleshlight/proc/try_copy_plushie(obj/item/toy/plush/plushie, mob/user)
	if(!istype(plushie))
		return FALSE
	var/target_type = plushie.type
	if(target_type == /obj/item/toy/plush/lizard_plushie || target_type == /obj/item/toy/plush/lizard_plushie/greyscale)
		target_type = /obj/item/toy/plush/lizard_plushie/green
	else if(target_type == /obj/item/toy/plush/lizard_plushie/space)
		target_type = /obj/item/toy/plush/lizard_plushie/space/green

	if(!(target_type in allowed_plushie_types))
		balloon_alert(user, "can't copy this plushie!")
		return TRUE

	set_plushie_appearance(target_type, plushie.greyscale_colors)
	balloon_alert(user, "copied plushie appearance")
	return TRUE

/obj/item/clothing/sextoy/portal_fleshlight/click_alt_secondary(mob/user)
	if(!length(plushie_designs))
		populate_plushie_designs()
	var/choice = show_radial_menu(user, src, plushie_designs, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 36, require_near = TRUE, tooltips = TRUE)
	if(!choice)
		return CLICK_ACTION_BLOCKING
	if(choice == "Default")
		set_plushie_appearance(null)
		balloon_alert(user, "appearance reset")
	else
		var/chosen_type = name_to_plushie_type[choice]
		if(!chosen_type)
			return CLICK_ACTION_BLOCKING
		set_plushie_appearance(chosen_type)
		balloon_alert(user, "appearance changed")
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/sextoy/portal_fleshlight/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_LMB] = "Pick up"
		context[SCREENTIP_CONTEXT_RMB] = "Toggle anonymous mode"
		context[SCREENTIP_CONTEXT_ALT_LMB] = linked_panties ? "Unlink panties" : "No panties linked"
		context[SCREENTIP_CONTEXT_ALT_RMB] = "Change plushie appearance"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/clothing/sextoy/portal_panties))
		context[SCREENTIP_CONTEXT_LMB] = "Link panties"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/toy/plush))
		context[SCREENTIP_CONTEXT_LMB] = "Copy plushie appearance"
		return CONTEXTUAL_SCREENTIP_SET

	if(linked_panties?.loc && ishuman(linked_panties.loc))
		context[SCREENTIP_CONTEXT_LMB] = "Use on target"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/item/clothing/sextoy/portal_fleshlight/update_appearance(updates)
	if(plushie_type)
		var/plush_greyscale_config = initial(plushie_type.greyscale_config)
		var/plush_greyscale_colors = custom_plushie_greyscale_colors || initial(plushie_type.greyscale_colors)
		if(plush_greyscale_config && plush_greyscale_colors)
			icon_state = initial(plushie_type.post_init_icon_state) || initial(plushie_type.icon_state)
			set_greyscale(plush_greyscale_colors, plush_greyscale_config)
		else
			set_greyscale("", null)
			icon = initial(plushie_type.icon)
			icon_state = initial(plushie_type.icon_state)
	else
		set_greyscale("", null)
		icon_state = linked_panties ? "paired" : "unpaired"
		if(linked_panties && linked_panties.current_target == ORGAN_SLOT_PENIS)
			icon = 'modular_zzplurt/icons/obj/lewd/dildo.dmi'
		else
			icon = 'modular_zzplurt/icons/obj/lewd/fleshlight.dmi'
	. = ..()
	updatesleeve()

/obj/item/clothing/sextoy/portal_fleshlight/examine(mob/user)
	. = ..()
	. += span_notice("Alt-Right-click to change or reset its plushie appearance, or hit it with a base-game plushie.")
	if(!linked_panties)
		. += span_notice("The status light is off. The device needs to be paired with portal panties.")
		return

	. += span_notice("The status light is [useable ? "on" : "off"]. The portal is [useable ? "open" : "closed"].")
	. += span_notice("The current target is set to: [current_target]")

/obj/item/clothing/sextoy/portal_fleshlight/attack_self(mob/user)
	. = ..()
	switch(current_target)
		if(ORGAN_SLOT_PENIS)
			current_target = ORGAN_SLOT_VAGINA
		if(ORGAN_SLOT_VAGINA)
			current_target = ORGAN_SLOT_ANUS
		if(ORGAN_SLOT_ANUS)
			current_target = URETHRA_TOP
		if(URETHRA_TOP)
			current_target = URETHRA_BOTTOM
		if(URETHRA_BOTTOM)
			current_target = BODY_ZONE_PRECISE_MOUTH
		if(BODY_ZONE_PRECISE_MOUTH)
			current_target = ORGAN_SLOT_PENIS
	to_chat(user, span_notice("Now targeting: [current_target]"))

/obj/item/clothing/sextoy/portal_fleshlight/pre_attack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	if(istype(target, /obj/item/toy/plush))
		var/obj/item/toy/plush/plushie = target
		if(try_copy_plushie(plushie, user))
			return TRUE
	return ..()

/obj/item/clothing/sextoy/portal_fleshlight/attack(mob/living/target, mob/living/user, params)
	. = ..()
	if(!istype(linked_panties?.loc, /mob/living/carbon/human))
		to_chat(user, span_warning("The portal fleshlight isn't linked to any worn portal panties!"))
		return

	var/mob/living/carbon/human/target_wearer = linked_panties.loc

	// Get the panty target and fleshlight target
	var/panty_target = linked_panties.current_target
	var/fleshlight_target

	// Determine fleshlight target based on where it's being used
	if(user.zone_selected == BODY_ZONE_PRECISE_GROIN)
		fleshlight_target = current_target
	else
		fleshlight_target = user.zone_selected

	perform_interaction(user, target, target_wearer, panty_target, fleshlight_target)

/obj/item/clothing/sextoy/portal_fleshlight/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()

	if(istype(W, /obj/item/toy/plush))
		var/obj/item/toy/plush/plushie = W
		try_copy_plushie(plushie, user)
		return

	// Handle portal fleshlight interaction
	if(istype(W, /obj/item/clothing/sextoy/portal_fleshlight))
		var/obj/item/clothing/sextoy/portal_fleshlight/other_fleshlight = W

		// Check if both fleshlights have linked panties
		if(!linked_panties || !other_fleshlight.linked_panties)
			to_chat(user, span_warning("Both portal fleshlights need to be linked to portal panties!"))
			return

		// Check if both panties are being worn
		if(!istype(linked_panties.loc, /mob/living/carbon/human) || !istype(other_fleshlight.linked_panties.loc, /mob/living/carbon/human))
			to_chat(user, span_warning("Both portal panties need to be worn by someone!"))
			return

		var/mob/living/carbon/human/target = linked_panties.loc
		var/mob/living/carbon/human/wearer = other_fleshlight.linked_panties.loc

		// Get panty target from the other fleshlight's panties
		var/panty_target = other_fleshlight.linked_panties.current_target

		// Determine fleshlight target based on conditions
		var/fleshlight_target
		if(linked_panties.current_target == ORGAN_SLOT_PENIS && (other_fleshlight.current_target == URETHRA_TOP || other_fleshlight.current_target == URETHRA_BOTTOM))
			fleshlight_target = other_fleshlight.current_target
		else
			fleshlight_target = linked_panties.current_target

		perform_interaction(user, target, wearer, panty_target, fleshlight_target)
		return

	// Handle portal panties linking
	if(istype(W, /obj/item/clothing/sextoy/portal_panties))
		link_panties(W, user)
		return

/obj/item/clothing/sextoy/portal_fleshlight/proc/perform_interaction(mob/living/user, mob/living/target, mob/living/wearer, panty_target, fleshlight_target)
	// Get the interaction name from the map
	var/interaction_name = interaction_map[panty_target]?[fleshlight_target]
	if(!interaction_name)
		to_chat(user, span_warning("You can't use the portal fleshlight like this!"))
		return

	// Find the interaction in SSinteractions
	var/datum/interaction/lewd/portal/interaction_to_try = SSinteractions.interactions[interaction_name]

	if(!interaction_to_try?.allow_act(target, wearer))
		to_chat(user, span_warning("You can't use the portal fleshlight like this!"))
		return

	interaction_to_try.act(target, wearer)
	wearer.do_jitter_animation()

/obj/item/clothing/sextoy/portal_fleshlight/proc/link_panties(obj/item/clothing/sextoy/portal_panties/panties, mob/living/user)
	if(!istype(panties))
		return FALSE

	if(panties.linked_fleshlight)
		to_chat(user, span_warning("[panties] is already linked to another portal fleshlight!"))
		return FALSE

	if(linked_panties)
		to_chat(user, span_warning("[src] is already linked to another pair of portal panties!"))
		return FALSE

	linked_panties = panties
	panties.linked_fleshlight = src
	useable = TRUE
	icon_state = "paired"

	playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
	to_chat(user, span_notice("You link [src] to [panties]."))

	update_appearance()
	return TRUE

/obj/item/clothing/sextoy/portal_fleshlight/click_alt(mob/user)
	if(!linked_panties)
		to_chat(user, span_warning("[src] isn't linked to any portal panties!"))
		return CLICK_ACTION_BLOCKING

	var/choice = tgui_alert(user, "Are you sure you want to unlink the portal panties?", "Unlink Portal Panties", list("Yes", "No"))
	if(choice != "Yes")
		return CLICK_ACTION_BLOCKING

	to_chat(user, span_notice("You unlink the portal panties from [src]."))
	unlink_panties()
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/sextoy/portal_fleshlight/proc/unlink_panties()
	if(isliving(loc))
		audible_message("[icon2html(src, hearers(linked_panties))] *beep* *beep* *beep*")
		playsound(linked_panties, 'sound/machines/beep/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)
		to_chat(loc, span_notice("The panties beep as the link to the [src] is lost."))

	if(isliving(linked_panties?.loc))
		linked_panties.audible_message("[icon2html(linked_panties, hearers(linked_panties))] *beep* *beep* *beep*")
		playsound(linked_panties, 'sound/machines/beep/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)
		to_chat(linked_panties.loc, span_notice("The panties beep as the link to the [src] is lost."))

	linked_panties.linked_fleshlight = null
	linked_panties = null

	icon_state = "unpaired"
	update_appearance()

/obj/item/clothing/sextoy/portal_fleshlight/Destroy(force)
	if(linked_panties)
		unlink_panties()
	. = ..()

/obj/item/clothing/sextoy/portal_fleshlight/proc/updatesleeve()
	cut_overlays() // Remove current overlays

	var/clean_plush_name
	if(plushie_type)
		clean_plush_name = replacetext(initial(plushie_type.name), "\improper ", "")
		name = "portal [clean_plush_name]"
		desc = "[initial(plushie_type.desc)] It has a shimmering bluespace portal embedded in it."
		var/mutable_appearance/portal_ring = mutable_appearance('modular_zzplurt/icons/obj/lewd/dildo.dmi', "portalring")
		if(!linked_panties)
			portal_ring.alpha = 128
		add_overlay(portal_ring)
	else
		name = initial(name)
		desc = initial(desc)

	var/mob/living/carbon/human/target_wearer = null
	if(linked_panties && ishuman(linked_panties.loc))
		target_wearer = linked_panties.loc
	else
		useable = FALSE
		return

	var/obj/item/organ/genital/target_organ

	// Get the appropriate genital based on panties target
	if(linked_panties.current_target == ORGAN_SLOT_VAGINA)
		target_organ = target_wearer.get_organ_slot(ORGAN_SLOT_VAGINA)
		if(!target_organ || !istype(target_organ, /obj/item/organ/genital/vagina))
			useable = FALSE
			return
	else if(linked_panties.current_target == ORGAN_SLOT_PENIS)
		target_organ = target_wearer.get_organ_slot(ORGAN_SLOT_PENIS)
		if(!target_organ || !istype(target_organ, /obj/item/organ/genital/penis))
			useable = FALSE
			return
	else if(linked_panties.current_target == ORGAN_SLOT_ANUS)
		target_organ = target_wearer.get_organ_slot(ORGAN_SLOT_ANUS)
		if(!target_organ || !istype(target_organ, /obj/item/organ/genital/anus))
			useable = FALSE
			return

	if(target_wearer) // If the portal panties are worn
		if(!linked_panties.equipped_slot) // Check if panties are actually equipped
			useable = FALSE
			return

		// Add the appropriate sleeve overlay based on species
		var/mutable_appearance/sleeve
		if(!plushie_type && (linked_panties.current_target == ORGAN_SLOT_VAGINA || linked_panties.current_target == ORGAN_SLOT_ANUS || linked_panties.current_target == BODY_ZONE_PRECISE_MOUTH))
			sleeve = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_sleeve_normal")

			if(islizard(target_wearer))
				sleeve = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_sleeve_lizard")
			else if(isunathi(target_wearer))
				sleeve = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_sleeve_lizard")
			else if(isakula(target_wearer))
				sleeve = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_sleeve_akula")
			else if(isslimeperson(target_wearer))
				sleeve = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_sleeve_slime")
			else if(ismammal(target_wearer))
				sleeve = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_sleeve_fluff")
			else if(isvulpkanin(target_wearer))
				sleeve = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_sleeve_fluff")
			else if(istajaran(target_wearer))
				sleeve = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_sleeve_fluff")
			else if(isshadekin(target_wearer))
				sleeve = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_sleeve_fluff")
			else if(isteshari(target_wearer))
				sleeve = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_sleeve_fluff")
			else if(isvox(target_wearer))
				sleeve = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_sleeve_fluff")

			sleeve.color = linked_panties.current_target == ORGAN_SLOT_ANUS && LAZYFIND(list(/datum/sprite_accessory/genital/anus/donut::name, /datum/sprite_accessory/genital/anus/squished::name), target_organ.genital_name) ? target_organ.color : target_wearer.dna.features["mcolor"]
			add_overlay(sleeve)

		// Add the appropriate organ overlay
		var/mutable_appearance/organ
		switch(linked_panties.current_target)
			if(ORGAN_SLOT_VAGINA)
				var/obj/item/organ/genital/vagina/vag = target_organ
				organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_vag")
				switch(vag.genital_name)
					if("Human")
						organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_vag")
					if("Puffy")
						organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_vag_puffy")
					if("Gaping")
						organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_vag_gaping")
					if("Spade")
						organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_vag_spade")
					if("Feline")
						organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_vag_feline")
					if("Equine")
						organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_vag_equine")
					if("Cervine")
						organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_vag_cervine")
					if("Sergal")
						organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_vag_sergal")
					if("Cloaca")
						organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_vag_cloacal")
					if("Hemi")
						organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_vag_hemi")
				if(vag.uses_skin_color)
					organ.color = target_wearer.dna.features["mcolor"]
				else
					organ.color = vag.color
				if(vag.aroused == AROUSAL_FULL)
					var/mutable_appearance/vag_drip = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_vag_drip")
					if(plushie_type)
						vag_drip.pixel_x = 7
						vag_drip.pixel_y = -1
					add_overlay(vag_drip)
			if(ORGAN_SLOT_ANUS)
				organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_anus")
				organ.color = target_organ.color
			if(ORGAN_SLOT_PENIS)
				var/obj/item/organ/genital/penis/penis = target_organ
				organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/dildo.dmi', "penis")
				switch(penis.genital_name)
					if("Human")
						organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/dildo.dmi', "penis")
					if("Knotted", "Barbed, Knotted")
						organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/dildo.dmi', "knotted")
					if("Flared")
						organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/dildo.dmi', "flared")
					if("Tapered")
						organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/dildo.dmi', "tapered")
					if("Tentacled")
						organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/dildo.dmi', "tentacle")
					if("Hemi", "Knotted Hemi")
						organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/dildo.dmi', "hemi")
				if(penis.uses_skin_color)
					organ.color = target_wearer.dna.features["mcolor"]
				else
					organ.color = penis.color
				if(penis.aroused == AROUSAL_FULL && penis.sheath != SHEATH_NONE)
					add_overlay(mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_penis_drip"))
			if(BODY_ZONE_PRECISE_MOUTH)
				var/mutable_appearance/mouth_bg = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_mouth")
				if(plushie_type)
					mouth_bg.pixel_x = 7
					mouth_bg.pixel_y = -1
				add_overlay(mouth_bg)
				organ = mutable_appearance('modular_zzplurt/icons/obj/lewd/fleshlight.dmi', "portal_mouth_lips")
				organ.color = target_wearer.lip_style == "lipstick" ? target_wearer.lip_color : "#[target_wearer.dna.features["mcolor"]]"

		// Update name based on target
		if(plushie_type)
			name = linked_panties.current_target == ORGAN_SLOT_PENIS ? "portal dildo [clean_plush_name]" : "portal [clean_plush_name]"
		else
			name = linked_panties.current_target == ORGAN_SLOT_PENIS ? "portal dildo" : "portal fleshlight"

		useable = TRUE
		if(plushie_type && linked_panties.current_target != ORGAN_SLOT_PENIS)
			organ.pixel_x = 7
			organ.pixel_y = -1
		add_overlay(organ)
	else
		useable = FALSE

/obj/item/clothing/sextoy/portal_fleshlight/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return .

	anonymous = !anonymous
	playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
	balloon_alert(user, "anonymous mode: [anonymous ? "ON" : "OFF"]")
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

#undef URETHRA_TOP
#undef URETHRA_BOTTOM
