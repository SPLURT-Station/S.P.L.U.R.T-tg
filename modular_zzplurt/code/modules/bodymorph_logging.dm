// SPLURT ADDITION - Logging for bodymorph alterations
// Logs all bodymorphing actions to game.log as required by the bounty

/datum/action/innate/alter_form/splurt/alter_colours(mob/living/carbon/human/alterer)
	. = ..()
	if(. == null) // cancelled
		return
	log_game("BODYMORPH: [key_name(alterer)] changed body colours to [alterer.dna.features[FEATURE_MUTANT_COLOR]]")

/datum/action/innate/alter_form/splurt/alter_hair(mob/living/carbon/human/alterer)
	. = ..()
	if(. == null)
		return
	log_game("BODYMORPH: [key_name(alterer)] changed hair to [alterer.hairstyle]/[alterer.facial_hairstyle]")

/datum/action/innate/alter_form/splurt/alter_markings(mob/living/carbon/human/alterer)
	. = ..()
	if(. == null)
		return
	log_game("BODYMORPH: [key_name(alterer)] changed body markings")

/datum/action/innate/alter_form/splurt/alter_parts(mob/living/carbon/human/alterer)
	. = ..()
	if(. == null)
		return
	log_game("BODYMORPH: [key_name(alterer)] changed mutant parts")

/datum/action/innate/alter_form/splurt/alter_genitals(mob/living/carbon/human/alterer)
	. = ..()
	if(. == null)
		return
	log_game("BODYMORPH: [key_name(alterer)] changed genitalia settings")
