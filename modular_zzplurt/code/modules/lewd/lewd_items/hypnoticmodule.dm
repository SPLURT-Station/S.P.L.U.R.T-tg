//This file contains the VAST majority of the code for the Borg hypnotic upgrade.
/obj/item/borg/upgrade/hypnoticmodule/action(mob/living/silicon/robot/borg, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(borg.has_quirk(/datum/quirk/hypnotic_borg))
		return TRUE

	var/datum/quirk/hypnotic_borg/quirk = new
	if(!quirk.add_to_holder(new_holder = borg, client_source = borg.client, announce = FALSE))
		qdel(quirk)
		return FALSE

	return TRUE

/obj/item/borg/upgrade/hypnoticmodule/deactivate(mob/living/silicon/robot/borg, mob/living/user)
	. = ..()
	if(.)
		borg.remove_quirk(/datum/quirk/hypnotic_borg)


/datum/design/borg_hypnotic
	name = "Cyborg Hypnotic Optics Module"
	id = "hypnoticmodule"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/hypnoticmodule
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ALL
	)


/datum/quirk/hypnotic_borg
	name = "Hypnotic Optics"
	desc = "Your optical displays and chassis presence are captivating to those susceptible to hypnosis."
	abstract_parent_type = /datum/quirk/hypnotic_borg
	icon = FA_ICON_FACE_GRIN_HEARTS
	value = 0
	quirk_flags = QUIRK_HIDE_FROM_SCAN
	gain_text = "Your optical glow sharpens."
	lose_text = "Your optical glow dulls."
	medical_record_text = "Unit exhibits unusually captivating optical behavior."
	erp_quirk = TRUE
	var/hypnotic_text
	var/hypnotic_color

/datum/quirk/hypnotic_borg/add_to_holder(mob/living/new_holder, quirk_transfer = FALSE, client/client_source, unique = TRUE, announce = TRUE)
	if(!iscyborg(new_holder))
		return FALSE
	return ..()

/datum/quirk/hypnotic_borg/add(client/client_source)
	RegisterSignal(quirk_holder, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/quirk/hypnotic_borg/post_add()
	if(!quirk_holder?.client)
		return
	var/datum/preferences/preferences = quirk_holder.client.prefs
	if(!preferences || !(/datum/quirk/hypnotic::name in preferences.all_quirks))
		hypnotic_text = null
		hypnotic_color = "Hypnophrase"
		return
	hypnotic_text = preferences.read_preference(/datum/preference/text/hypnotic_text)
	hypnotic_color = preferences.read_preference(/datum/preference/choiced/hypnotic_span)

/datum/quirk/hypnotic_borg/remove()
	UnregisterSignal(quirk_holder, COMSIG_ATOM_EXAMINE)

/datum/quirk/hypnotic_borg/proc/on_examine(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	var/mob/living/silicon/robot/examinee = source
	if(!iscyborg(examinee))
		return
	if(!istype(user))
		return
	if(!(examinee.client?.prefs?.read_preference(/datum/preference/toggle/erp/hypnosis)))
		return
	if(user.stat == DEAD)
		return
	if(isnull(hypnotic_color))
		return
	examine_list += pick_color()

/datum/quirk/hypnotic_borg/proc/pick_color()
	var/choice = "hypnophrase"
	switch(hypnotic_color)
		if("Hypnophrase")
			choice = "hypnophrase"
		if("Velvet")
			choice = "velvet"
		if("Yellow Flashy")
			choice = "glossy"
		if("Pink")
			choice = "pink"
		if("Cult")
			choice = "cult"

	return "<span class='[choice]'>[isnull(hypnotic_text) ? "Their optics are enticing to stare at." : hypnotic_text]</span>"

/datum/quirk_constant_data/hypnotic_borg
	associated_typepath = /datum/quirk/hypnotic_borg
	customization_options = list(
		/datum/preference/text/hypnotic_text,
		/datum/preference/choiced/hypnotic_span,
	)

/obj/item/borg/upgrade/hypnoticmodule
	name = "borg hypnotic optics module"
	desc = "A odd looking recreational module that seems to illicit a response in the weakminded."
	icon = 'modular_skyrat/modules/borgs/icons/robot_items.dmi'
	icon_state = "module_lust"
	custom_price = 0

/datum/techweb_node/augmentation/New()
	. = ..()
	design_ids += list(
		"hypnoticmodule",
	)
