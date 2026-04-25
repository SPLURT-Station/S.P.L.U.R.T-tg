// exotic respiration!
// wanna breathe something other than oxygen? wanna die horribly choking to death on normal air? this is the quirk for you!
// see lungs.dm in the same folder for the meat of the actual code that makes this work

/datum/preference/choiced/exoresp
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "exoresp_gas"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/choiced/exoresp/init_possible_values()
	return list(
		"BZ",
		"Nitrous oxide",
		"Carbon dioxide",
		"Nitrogen",
		"Plasma",
	)

/datum/preference/choiced/exoresp/create_default_value()
	return "Carbon dioxide" // longest one so the box will actually have enough space to show the rest of them lmao

/datum/quirk_constant_data/exoresp
	associated_typepath = /datum/quirk/equipping/lungs/exoresp
	customization_options = list(/datum/preference/choiced/exoresp)

/datum/quirk/equipping/lungs/exoresp
	name = "Exotic Respiration"
	desc = "For one reason or another, you breathe something other than oxygen. Unfortunately, this also means oxygen is toxic to you."
	icon = FA_ICON_HURRICANE
	medical_record_text = "Patient's respiration is reliant on an exotic gas."
	gain_text = "<span class='danger'>Your lungs spasm. Oxygen feels toxic!</span>"
	lose_text = "<span class='notice'>Oxygen no longer feels toxic to you.</span>"
	value = -4
	quirk_flags = QUIRK_HUMAN_ONLY
	species_blacklist = list(SPECIES_SYNTH, SPECIES_PROTEAN)
	stored_items = list(/obj/item/clothing/accessory/breathing = list(ITEM_SLOT_BACK))
	items = list(/obj/item/clothing/mask/breath = list(ITEM_SLOT_MASK))

/datum/quirk/equipping/lungs/exoresp/add(client/client_source)
	var/choice = "Carbon dioxide" // default to something so the quirk doesn't break if the pref fails to load for some reason
	if(client_source?.prefs)
		choice = client_source.prefs.read_preference(/datum/preference/choiced/exoresp)
	configure_from_choice(choice)
	return ..()

/datum/preference/choiced/exoresp/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/quirk/equipping/lungs/exoresp/proc/configure_from_choice(choice)
	if(isnull(choice))
		choice = "Carbon dioxide" // and then null check anyways out of paranoia
	switch(choice)
		if("BZ")
			forced_items = list(
				/obj/item/tank/internals/bz/belt/full = list(ITEM_SLOT_HANDS, ITEM_SLOT_LPOCKET, ITEM_SLOT_RPOCKET),
			)
			lungs_typepath = /obj/item/organ/lungs/exotic/bz // see bubber's nitrogen breather quirk for the framework being used here
			breath_type = "BZ"
		if("Nitrous oxide")
			forced_items = list(
				/obj/item/tank/internals/n2o/belt/full = list(ITEM_SLOT_HANDS, ITEM_SLOT_LPOCKET, ITEM_SLOT_RPOCKET),
			)
			lungs_typepath = /obj/item/organ/lungs/exotic/n2o
			breath_type = "N2O"
		if("Carbon dioxide")
			forced_items = list(
				/obj/item/tank/internals/co2/belt/full = list(ITEM_SLOT_HANDS, ITEM_SLOT_LPOCKET, ITEM_SLOT_RPOCKET),
			)
			lungs_typepath = /obj/item/organ/lungs/exotic/co2
			breath_type = "CO2"
		if("Nitrogen")
			forced_items = list(
				/obj/item/tank/internals/nitrogen/belt/full/highpressure = list(ITEM_SLOT_HANDS, ITEM_SLOT_LPOCKET, ITEM_SLOT_RPOCKET),
			)
			lungs_typepath = /obj/item/organ/lungs/exotic/n2 // not using the vox lungs because they're also low-pressure adapted, making them a sidegrade
			breath_type = "Nitrogen"
		if("Plasma")
			forced_items = list(
				/obj/item/tank/internals/plasmaman/belt/full/highpressure = list(ITEM_SLOT_HANDS, ITEM_SLOT_LPOCKET, ITEM_SLOT_RPOCKET),
			)
			lungs_typepath = /obj/item/organ/lungs/exotic/plasma // ditto 76 but for plasmamen
			breath_type = "Plasma"

/datum/quirk/equipping/lungs/exoresp/add_unique(client/client_source)
	. = ..()
	restore_mask()

/datum/quirk/equipping/lungs/exoresp/proc/restore_mask() // /datum/quirk/equipping's logic rudely discards our loadout mask onto the floor if we had one, so we search for a mask among the items we force dropped and try to reequip it
	var/mob/living/carbon/human/holder = quirk_holder
	if(!istype(holder))
		return
	for(var/obj/item/clothing/mask/restoredmask in force_dropped_items) // parent helpfully provides a list of items it force dropped so we use that
		if(istype(restoredmask, /obj/item/clothing/mask/breath)) // probably shouldn't reequip the same breath mask
			continue
		if(force_equip_item(holder, restoredmask, ITEM_SLOT_MASK, FALSE)) // this doesn't check if the mask you brought has internals, but if you take exoresp and then bring a loadout mask item without internals, you did ask for this to happen
			force_dropped_items -= restoredmask
			UnregisterSignal(restoredmask, COMSIG_QDELETING) // clean up after ourselves
			return restoredmask
	return
