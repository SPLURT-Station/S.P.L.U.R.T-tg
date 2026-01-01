/datum/interaction/lewd/extreme/eyefuck
	name = "Eyefuck"
	description = "Fuck their eye."
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS)
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list(
		"%CUMMING% cums deep into %CAME_IN%'s eye",
		"%CUMMING% shoots their load into %CAME_IN%'s eye socket",
		"%CUMMING% fills %CAME_IN%'s eye with their cum"
	))
	cum_self_text_overrides = list(CLIMAX_POSITION_USER = list(
		"You cum deep into %CAME_IN%'s eye",
		"You shoot your load into %CAME_IN%'s eye socket",
		"You fill %CAME_IN%'s eye with your cum"
	))
	cum_partner_text_overrides = list(CLIMAX_POSITION_USER = list(
		"%CUMMING% cums deep into your eye",
		"%CUMMING% shoots their load into your eye socket",
		"%CUMMING% fills your eye with their cum"
	))
	message = list(
		"pounds into %TARGET%'s eye.",
		"shoves their cock deep into %TARGET%'s skull",
		"thrusts in and out of %TARGET%'s eye.",
		"goes balls deep into %TARGET%'s cranium over and over again."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/champ1.ogg',
		'modular_zzplurt/sound/interactions/champ2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 5
	target_pleasure = 0
	user_arousal = 8
	target_arousal = 0
	target_pain = 15

/datum/interaction/lewd/extreme/eyefuck/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	if(target.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) == "No" && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target)))
		return
	if(prob(15) && iscarbon(target))
		target:bleed(2)
	if(prob(25))
		target.adjust_organ_loss(ORGAN_SLOT_EYES, rand(3,7))
		target.adjust_organ_loss(ORGAN_SLOT_BRAIN, rand(3,7))

/datum/interaction/lewd/extreme/eyesocketfuck
	name = "Eyesocketfuck"
	description = "Fuck their eyesocket."
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS)
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list(
		"%CUMMING% cums deep into %CAME_IN%'s empty eye socket",
		"%CUMMING% shoots their load into %CAME_IN%'s skull",
		"%CUMMING% fills %CAME_IN%'s eye socket with their cum"
	))
	cum_self_text_overrides = list(CLIMAX_POSITION_USER = list(
		"You cum deep into %CAME_IN%'s empty eye socket",
		"You shoot your load into %CAME_IN%'s skull",
		"You fill %CAME_IN%'s eye socket with your cum"
	))
	cum_partner_text_overrides = list(CLIMAX_POSITION_USER = list(
		"%CUMMING% cums deep into your empty eye socket",
		"%CUMMING% shoots their load into your skull",
		"%CUMMING% fills your eye socket with their cum"
	))
	message = list(
		"pounds into %TARGET%'s eyesocket.",
		"shoves their cock deep into %TARGET%'s skull",
		"thrusts in and out of %TARGET%'s eyesocket.",
		"goes balls deep into %TARGET%'s cranium over and over again."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/champ1.ogg',
		'modular_zzplurt/sound/interactions/champ2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 5
	target_pleasure = 0
	user_arousal = 8
	target_arousal = 0
	target_pain = 15

/datum/interaction/lewd/extreme/eyesocketfuck/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	if(target.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) == "No" && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target)))
		return
	if(prob(15) && iscarbon(target))
		target:bleed(2)
	if(prob(25))
		target.adjust_organ_loss(ORGAN_SLOT_BRAIN, rand(3,7))
