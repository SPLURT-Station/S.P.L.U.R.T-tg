/datum/keybinding/living/combat_indicator/down(client/user)
	. = ..()
	var/mob/living/carbon/human/humie = user.mob
	if(. || !istype(humie))
		return
	if(humie.client?.prefs?.read_preference(/datum/preference/toggle/intents))
		humie.set_combat_focus(!humie.combat_focus)
	else
		humie.set_combat_mode(!humie.combat_mode)
