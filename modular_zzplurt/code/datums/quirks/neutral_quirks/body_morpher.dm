// REMOVED QUIRK - Disabled in favor of new NIFSoft method
/datum/quirk/body_morpher
	name = "Body Morpher"
	desc = "You have the ability to morph and shift your body, like a slimeperson can."
	value = 0
	gain_text = span_notice("Your body feels more malleable.")
	lose_text = span_notice("Your body returns to a normal consistency.")
	medical_record_text = "Patient's body seems unusually malleable."
	mob_trait = TRAIT_BODY_MORPHER
	icon = FA_ICON_PEOPLE_ARROWS
	mail_goodies = list (
		/obj/item/toy/foamblade = 1 // Fake changeling
	)
/datum/quirk/body_morpher/add(client/client_source)
	// Define quirk mob
	var/mob/living/carbon/human/quirk_mob = quirk_holder

	// Add quirk ability action datum
	var/datum/action/innate/alter_form/splurt/quirk_action = new
	quirk_action.Grant(quirk_mob)

	// Capture base character preset on first gain
	if(client_source)
		var/datum/bodymorph_presets/bp = client_source.get_bodymorph_presets()
		if(!bp.has_base_preset())
			var/list/base = capture_bodymorph_preset(quirk_mob)
			if(base.len)
				base["name"] = "Base Character"
				bp.set_base_preset(base)
				log_game("BODYMORPH: [key_name(quirk_mob)] base character preset captured")

/datum/quirk/body_morpher/remove()
	// Define quirk mob
	var/mob/living/carbon/human/quirk_mob = quirk_holder

	if(QDELETED(quirk_mob))
		return

	// Remove quirk ability action datum
	var/datum/action/innate/alter_form/quirk_action = locate() in quirk_mob.actions
	quirk_action.Remove(quirk_mob)
