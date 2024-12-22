/datum/interaction/lewd/eyefuck
	command = "eyefuck"
	description = "Fuck their eye."
	interaction_sound = null
	require_user_penis = REQUIRE_EXPOSED
	require_target_eyes = REQUIRE_EXPOSED
	max_distance = 1
	write_log_user = "eyefucked"
	write_log_target = "had their eye fucked by"
	extreme = TRUE

/datum/interaction/lewd/eyefuck/eyesocketfuck
	command = "eyesocketfuck"
	description = "Fuck their eyesocket."
	require_target_eyes = null
	require_target_eyesockets = REQUIRE_EXPOSED
	write_log_user = "eyesocketfucked"
	write_log_target = "had their eyesocket fucked by"

/datum/interaction/lewd/eyefuck/display_interaction(mob/living/user, mob/living/partner)
	var/message

	var/u_His = user.p_their()

	if(user.is_fucking(partner, CUM_TARGET_EYES))
		message = "[pick(
			"pounds into \the <b>[partner]</b>'s [partner.has_eyes() ? "eye":"eyesocket"].",
			"shoves [u_His] dick deep into \the <b>[partner]</b>'s skull",
			"thrusts in and out of \the <b>[partner]</b>'s [partner.has_eyes() ? "eye":"eyesocket"].",
			"goes balls deep into \the <b>[partner]</b>'s cranium over and over again.")]"
		var/client/cli = partner.client
		var/mob/living/carbon/C = partner
		if(cli && istype(C))
			if(LAZY_READ_PREF_FROM_CLIENT(cli, /datum/preference/choiced/erp_status_extmharm) != "No")
				if(prob(15))
					C.bleed(2)
				if(prob(25))
					C.adjustOrganLoss(ORGAN_SLOT_EYES,rand(3,7))
					C.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(3,7))
	else
		message = "forcefully slides [u_His] cock inbetween \the <b>[partner]</b>'s [partner.has_eyes() ? "eyelid":"eyesocket"]."
		user.set_is_fucking(partner, CUM_TARGET_EYES, user.get_organ_slot(ORGAN_SLOT_PENIS))

	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/champ1.ogg',
												'modular_zzplurt/sound/interactions/champ2.ogg'), 50, 1, -1)
	user.visible_message("<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting(TRUE))
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_EYES, partner)
	partner.handle_post_sex(LOW_LUST, null, user)
