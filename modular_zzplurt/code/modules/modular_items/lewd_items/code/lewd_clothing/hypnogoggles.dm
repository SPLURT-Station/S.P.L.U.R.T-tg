// Overrides the logging behavior of induced hypnosis
// from modular_skyrat/modules/modular_items/lewd_items/code/lewd_clothing/hypnogoggles.dm

/datum/brain_trauma/very_special/induced_hypnosis/on_gain()
	message_admins("[ADMIN_LOOKUPFLW(owner)] was hypnotized with the phrase '[hypnotic_phrase]'.")
	owner.log_message("was hypnotized with the phrase '[hypnotic_phrase]'.", LOG_GAME)
	return ..()

/datum/brain_trauma/very_special/induced_hypnosis/on_lose()
	message_admins("[ADMIN_LOOKUPFLW(owner)] is no longer hypnotized with the phrase '[hypnotic_phrase]'.")
	owner.log_message("is no longer hypnotized with the phrase '[hypnotic_phrase]'.", LOG_GAME)
	. = ..()
