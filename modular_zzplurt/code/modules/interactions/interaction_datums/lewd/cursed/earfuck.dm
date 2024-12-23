/datum/interaction/lewd/earfuck
	description = "Fuck their ear."
	interaction_sound = null
	require_user_penis = REQUIRE_EXPOSED
	require_target_ears = REQUIRE_EXPOSED
	max_distance = 1
	write_log_user = "earfucked"
	write_log_target = "had their ear fucked by"
	extreme = TRUE

/datum/interaction/lewd/earfuck/earsocketfuck
	description = "Fuck their earsocket."
	require_target_ears = null
	require_target_earsockets = REQUIRE_EXPOSED
	write_log_user = "earsocket fucked"
	write_log_target = "had their earsocket fucked by"

/datum/interaction/lewd/earfuck/display_interaction(mob/living/user, mob/living/partner)
	var/message

	var/u_His = user.p_their()

	if(user.is_fucking(partner, CUM_TARGET_EARS))
		message = "[pick(
			"pounds into \the <b>[partner]</b>'s [partner.has_ears() ? "ear":"earsocker"].",
			"shoves [u_His] dick deep into \the <b>[partner]</b>'s skull",
			"thrusts in and out of \the <b>[partner]</b>'s [partner.has_ears() ? "ear":"eyesocket"].",
			"goes balls deep into \the <b>[partner]</b>'s cranium over and over again.")]"
		var/client/cli = partner.client
		var/mob/living/carbon/C = partner
		if(cli && istype(C))
			if(LAZY_READ_PREF_FROM_CLIENT(cli, /datum/preference/choiced/erp_status_extmharm) != "No")
				if(prob(15))
					C.bleed(2)
				if(prob(25))
					C.adjustOrganLoss(ORGAN_SLOT_EARS, rand(3,7))
					C.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(3,7))
	else
		message = "forcefully slides [u_His] cock inside \the <b>[partner]</b>'s [partner.has_ears() ? "ear":"earsocket"]."
		user.set_is_fucking(partner, CUM_TARGET_EARS, user.get_organ_slot(ORGAN_SLOT_PENIS))

	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/champ1.ogg',
												'modular_zzplurt/sound/interactions/champ2.ogg'), 50, 1, -1)
	user.visible_message(message = "<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting(TRUE))
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_EARS, partner)
	partner.handle_post_sex(LOW_LUST, null, user)
