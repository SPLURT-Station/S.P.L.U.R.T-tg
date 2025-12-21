/datum/interaction/lewd/extreme/knotfuck_ear
	knotting_supported = TRUE
	knotfucking = TRUE
	target_knotting_require = list(ORGAN_SLOT_EARS)
	custom_slot = ORGAN_SLOT_EARS
	name = "Ear Knotfuck"
	description = "Knotfuck their ear."
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS)
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list(
		"%CUMMING% cums deep into %CAME_IN%'s ear",
		"%CUMMING% shoots their load into %CAME_IN%'s ear canal",
		"%CUMMING% fills %CAME_IN%'s ear with their cum"
	))
	cum_self_text_overrides = list(CLIMAX_POSITION_USER = list(
		"You cum deep into %CAME_IN%'s ear",
		"You shoot your load into %CAME_IN%'s ear canal",
		"You fill %CAME_IN%'s ear with your cum"
	))
	cum_partner_text_overrides = list(CLIMAX_POSITION_USER = list(
		"%CUMMING% cums deep into your ear",
		"%CUMMING% shoots their load into your ear canal",
		"%CUMMING% fills your ear with their cum"
	))
	message = list(
		"pounds into %TARGET%'s ear.",
		"shoves their knot deep into %TARGET%'s skull",
		"slams their knot in and out of %TARGET%'s ear.",
		"goes balls deep into %TARGET%'s cranium over and over again."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/champ1.ogg',
		'modular_zzplurt/sound/interactions/champ2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 6
	target_pleasure = 0
	user_arousal = 9
	target_arousal = 0
	target_pain = 20

/datum/interaction/lewd/extreme/knotfuck_ear/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	if(target.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) == "No" && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target)))
		return
	if(prob(20) && iscarbon(target))
		target:bleed(2)
	if(prob(30))
		target.adjust_organ_loss(ORGAN_SLOT_EARS, rand(3,7))
		target.adjust_organ_loss(ORGAN_SLOT_BRAIN, rand(3,7))

/datum/interaction/lewd/extreme/knotfuck_earsocket
	knotting_supported = TRUE
	knotfucking = TRUE
	target_knotting_require = list(ORGAN_SLOT_EARS)
	custom_slot = ORGAN_SLOT_EARS
	name = "Knotfuck Earsocket"
	description = "Knotfuck their earsocket."
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS)
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list(
		"%CUMMING% cums deep into %CAME_IN%'s empty ear socket",
		"%CUMMING% shoots their load into %CAME_IN%'s skull",
		"%CUMMING% fills %CAME_IN%'s ear socket with their cum"
	))
	cum_self_text_overrides = list(CLIMAX_POSITION_USER = list(
		"You cum deep into %CAME_IN%'s empty ear socket",
		"You shoot your load into %CAME_IN%'s skull",
		"You fill %CAME_IN%'s ear socket with your cum"
	))
	cum_partner_text_overrides = list(CLIMAX_POSITION_USER = list(
		"%CUMMING% cums deep into your empty ear socket",
		"%CUMMING% shoots their load into your skull",
		"%CUMMING% fills your ear socket with their cum"
	))
	message = list(
		"pounds into %TARGET%'s earsocket.",
		"shoves their %KNOT% deep into %TARGET%'s skull",
		"slams their %KNOT% in and out of %TARGET%'s earsocket.",
		"goes balls deep into %TARGET%'s cranium over and over again."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/champ1.ogg',
		'modular_zzplurt/sound/interactions/champ2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 6
	target_pleasure = 0
	user_arousal = 9
	target_arousal = 0
	target_pain = 20

/datum/interaction/lewd/extreme/knotfuck_earsocket/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	if(target.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) == "No" && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target)))
		return
	if(prob(20) && iscarbon(target))
		target:bleed(2)
	if(prob(30))
		target.adjust_organ_loss(ORGAN_SLOT_BRAIN, rand(3,7))

/datum/interaction/lewd/extreme/knotfuck_eye
	knotting_supported = TRUE
	knotfucking = TRUE
	target_knotting_require = list(ORGAN_SLOT_EYES)
	custom_slot = ORGAN_SLOT_EYES
	name = "Knotfuck Eye"
	description = "Knotfuck their eye."
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
		"shoves their %KNOT% deep into %TARGET%'s skull",
		"slams their %KNOT% in and out of %TARGET%'s eye.",
		"goes balls deep into %TARGET%'s cranium over and over again."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/champ1.ogg',
		'modular_zzplurt/sound/interactions/champ2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 6
	target_pleasure = 0
	user_arousal = 9
	target_arousal = 0
	target_pain = 20

/datum/interaction/lewd/extreme/knotfuck_eye/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	if(target.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) == "No" && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target)))
		return
	if(prob(20) && iscarbon(target))
		target:bleed(2)
	if(prob(30))
		target.adjust_organ_loss(ORGAN_SLOT_EYES, rand(3,7))
		target.adjust_organ_loss(ORGAN_SLOT_BRAIN, rand(3,7))

/datum/interaction/lewd/extreme/knotfuck_eyesocket
	knotting_supported = TRUE
	knotfucking = TRUE
	target_knotting_require = list(ORGAN_SLOT_EYES)
	custom_slot = ORGAN_SLOT_EYES
	name = "Knotfuck Eyesocket"
	description = "Knotfuck their eyesocket."
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
		"shoves their %KNOT% deep into %TARGET%'s skull",
		"slams their %KNOT% in and out of %TARGET%'s eyesocket.",
		"goes balls deep into %TARGET%'s cranium over and over again."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/champ1.ogg',
		'modular_zzplurt/sound/interactions/champ2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 6
	target_pleasure = 0
	user_arousal = 9
	target_arousal = 0
	target_pain = 20

/datum/interaction/lewd/extreme/knotfuck_eyesocket/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	if(target.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) == "No" && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target)))
		return
	if(prob(20) && iscarbon(target))
		target:bleed(2)
	if(prob(30))
		target.adjust_organ_loss(ORGAN_SLOT_BRAIN, rand(3,7))
