/datum/interaction/lewd/fuck
	description = "Fuck their pussy."
	required_from_user_exposed = INTERACTION_REQUIRE_PENIS
	required_from_target_exposed = INTERACTION_REQUIRE_VAGINA
	write_log_user = "fucked"
	write_log_target = "was fucked by"
	interaction_sound = null

/datum/interaction/lewd/fuck/display_interaction(mob/living/user, mob/living/partner)
	var/message
	var/u_His = user.p_their()
	var/genital_name = user.get_penetrating_genital_name()

	if(user.is_fucking(partner, CUM_TARGET_VAGINA))
		message = "[pick(
			"pounds \the <b>[partner]</b>'s pussy.",
			"shoves [u_His] [genital_name] deep into \the <b>[partner]</b>'s pussy.",
			"thrusts in and out of \the <b>[partner]</b>'s cunt.",
			"goes balls deep into \the <b>[partner]</b>'s pussy over and over again.")]"
	else
		message = "slides [u_His] [genital_name] into \the <b>[partner]</b>'s pussy."
		user.set_is_fucking(partner, CUM_TARGET_VAGINA, user.getorganslot(ORGAN_SLOT_PENIS))

	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/champ1.ogg',
						'modular_zzplurt/sound/interactions/champ2.ogg'), 70, 1, -1)
	user.visible_message(span_lewd("<b>\The [user]</b> [message]"), ignored_mobs = user.get_unconsenting())
	if(user.can_penetrating_genital_cum())
		user.handle_post_sex(NORMAL_LUST, CUM_TARGET_VAGINA, partner, ORGAN_SLOT_PENIS) //SPLURT edit
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_PENIS, user, ORGAN_SLOT_VAGINA) //SPLURT edit

/datum/interaction/lewd/fuck/anal
	description = "Fuck their ass."
	required_from_target_exposed = INTERACTION_REQUIRE_ANUS

/datum/interaction/lewd/fuck/anal/display_interaction(mob/living/user, mob/living/partner)
	var/message
	var/u_His = user.p_their()
	var/t_His = partner.p_their()
	var/genital_name = user.get_penetrating_genital_name()

	if(user.is_fucking(partner, CUM_TARGET_ANUS))
		message = "[pick(
			"thrusts in and out of \the <b>[partner]</b>'s ass.",
			"pounds \the <b>[partner]</b>'s ass.",
			"slams [u_His] hips up against \the <b>[partner]</b>'s ass hard.",
			"goes balls deep into \the <b>[partner]</b>'s ass over and over again.")]"
	else
		message = "[pick(
			"works [u_His] [genital_name] into \the <b>[partner]</b>'s asshole.",
			"grabs the base of [u_His] twitching [genital_name] and presses the tip into \the <b>[partner]</b>'s asshole.",
			"shoves [u_His] [genital_name] deep inside of \the <b>[partner]</b>'s ass, making [t_His] rear jiggle.")]"
		user.set_is_fucking(partner, CUM_TARGET_ANUS, user.getorganslot(ORGAN_SLOT_PENIS))

	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg'), 70, 1, -1)
	user.visible_message(span_lewd("<b>\The [user]</b> [message]"), ignored_mobs = user.get_unconsenting())
	if(user.can_penetrating_genital_cum())
		user.handle_post_sex(NORMAL_LUST, CUM_TARGET_ANUS, partner, ORGAN_SLOT_PENIS) //SPLURT edit
	partner.handle_post_sex(NORMAL_LUST, null, user, "anus") //SPLURT edit

/datum/interaction/lewd/breastfuck
	description = "Fuck their breasts."
	interaction_sound = null
	required_from_user_exposed = INTERACTION_REQUIRE_PENIS
	required_from_target_exposed = INTERACTION_REQUIRE_BREASTS

/datum/interaction/lewd/breastfuck/display_interaction(mob/living/user, mob/living/partner)
	var/message
	var/u_His = user.p_their()
	var/genital_name = user.get_penetrating_genital_name()

	if(user.is_fucking(partner, CUM_TARGET_BREASTS))
		message = "[pick("fucks \the <b>[partner]</b>'s breasts.",
			"grinds [u_His] [genital_name] between \the <b>[partner]</b>'s boobs.",
			"thrusts into \the <b>[partner]</b>'s tits.",
			"grabs \the <b>[partner]</b>'s breasts together and presses [u_His] [genital_name] between them.")]"
	else
		message = "pushes \the <b>[partner]</b>'s breasts together and presses [u_His] [genital_name] between them."
		user.set_is_fucking(partner, CUM_TARGET_BREASTS, user.getorganslot(ORGAN_SLOT_PENIS))


	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg'), 70, 1, -1)
	user.visible_message(span_lewd("<b>\The [user]</b> [message]"), ignored_mobs = user.get_unconsenting())
	if(user.can_penetrating_genital_cum())
		user.handle_post_sex(NORMAL_LUST, CUM_TARGET_BREASTS, partner, ORGAN_SLOT_PENIS) //SPLURT edit

/datum/interaction/lewd/footfuck
	description = "Rub your cock on their foot."
	interaction_sound = null
	required_from_user_exposed = INTERACTION_REQUIRE_PENIS
	required_from_target_exposed = INTERACTION_REQUIRE_FEET
	required_from_target_unexposed = INTERACTION_REQUIRE_FEET
	require_target_num_feet = 1

/datum/interaction/lewd/footfuck/display_interaction(mob/living/user, mob/living/partner)
	var/message
	var/u_His = user.p_their()
	var/genital_name = user.get_penetrating_genital_name()

	var/shoes = partner.get_shoes(TRUE)

	if(user.is_fucking(partner, CUM_TARGET_FEET))
		message = "[pick("fucks \the <b>[partner]</b>'s [shoes ? shoes : pick("foot", "sole")].",
			"rubs [u_His] [genital_name] on \the <b>[partner]</b>'s [shoes ? shoes : pick("foot", "sole")].",
			"grinds [u_His] [genital_name] on \the <b>[partner]</b>'s [shoes ? shoes : pick("foot", "sole")].")]"
	else
		message = "[pick("positions [u_His] [genital_name] on \the <b>[partner]</b>'s [shoes ? shoes : pick("foot", "sole")].",
			"positions [u_His] [genital_name] on \the <b>[partner]</b>'s [shoes ? shoes : pick("foot","sole")].",
			"starts grinding [u_His] [genital_name] against \the <b>[partner]</b>'s [shoes ? shoes : pick("foot", "sole")].")]"
		user.set_is_fucking(partner, CUM_TARGET_FEET, user.getorganslot(ORGAN_SLOT_PENIS))

	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/foot_dry1.ogg',
						'modular_zzplurt/sound/interactions/foot_dry3.ogg',
						'modular_zzplurt/sound/interactions/foot_wet1.ogg',
						'modular_zzplurt/sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	user.visible_message(span_lewd("<b>\The [user]</b> [message]"), ignored_mobs = user.get_unconsenting())
	if(user.can_penetrating_genital_cum())
		user.handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, partner, CUM_TARGET_PENIS) //SPLURT edit

/datum/interaction/lewd/footfuck/double
	description = "Rub your cock between their feet."
	require_target_num_feet = 2

/datum/interaction/lewd/footfuck/double/display_interaction(mob/living/user, mob/living/partner)
	var/message
	var/u_His = user.p_their()
	var/genital_name = user.get_penetrating_genital_name()

	var/shoes = partner.get_shoes()

	if(user.is_fucking(partner, CUM_TARGET_FEET))
		message = "[pick("fucks \the <b>[partner]</b>'s [shoes ? shoes : pick("feet", "soles")].",
			"rubs [u_His] [genital_name] between \the <b>[partner]</b>'s [shoes ? shoes : pick("feet", "soles")].",
			"thrusts [u_His] [genital_name] between \the <b>[partner]</b>'s [shoes ? shoes : pick("feet", "soles")].")]"
	else
		message = "[pick("positions [u_His] [genital_name] between \the <b>[partner]</b>'s [shoes ? shoes : pick("feet", "soles")].",
			"starts grinding [u_His] [genital_name] against \the <b>[partner]</b>'s [shoes ? shoes : pick("feet", "soles")].",
			"starts grinding [u_His] [genital_name] between \the <b>[partner]</b>'s [shoes ? shoes : pick("feet", "soles")].")]"
		user.set_is_fucking(partner, CUM_TARGET_FEET, user.getorganslot(ORGAN_SLOT_PENIS))

	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/foot_dry1.ogg',
						'modular_zzplurt/sound/interactions/foot_dry3.ogg',
						'modular_zzplurt/sound/interactions/foot_wet1.ogg',
						'modular_zzplurt/sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	user.visible_message(span_lewd("<b>\The [user]</b> [message]"), ignored_mobs = user.get_unconsenting())
	if(user.can_penetrating_genital_cum())
		user.handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, partner, CUM_TARGET_PENIS) //SPLURT edit

/datum/interaction/lewd/footfuck/vag
	description = "Rub your vagina on their foot."
	interaction_sound = null
	required_from_user_exposed = INTERACTION_REQUIRE_VAGINA
	require_target_num_feet = 1

/datum/interaction/lewd/footfuck/vag/display_interaction(mob/living/user, mob/living/partner)
	var/message

	var/u_His = user.p_their()

	var/shoes = partner.get_shoes(TRUE)

	if(user.is_fucking(partner, CUM_TARGET_FEET))
		message = "[pick("grinds [u_His] pussy against \the <b>[partner]</b>'s [shoes ? shoes : pick("foot", "sole")].",
			"rubs [u_His] clit on \the <b>[partner]</b>'s [shoes ? shoes : pick("foot", "sole")].",
			"ruts on \the <b>[partner]</b>'s [shoes ? shoes : pick("foot", "sole")].")]"
	else
		message = "[pick("positions [u_His] vagina on \the <b>[partner]</b>'s [shoes ? shoes : pick("foot", "sole")].",
			"positions [u_His] clit on \the <b>[partner]</b>'s [shoes ? shoes : pick("foot","sole")].",
			"starts grinding [u_His] pussy against \the <b>[partner]</b>'s [shoes ? shoes : pick("foot", "sole")].")]"
		user.set_is_fucking(partner, CUM_TARGET_FEET, user.getorganslot(ORGAN_SLOT_VAGINA))

	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/foot_dry1.ogg',
						'modular_zzplurt/sound/interactions/foot_dry3.ogg',
						'modular_zzplurt/sound/interactions/foot_wet1.ogg',
						'modular_zzplurt/sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	user.visible_message(span_lewd("<b>\The [user]</b> [message]"), ignored_mobs = user.get_unconsenting())
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, partner, ORGAN_SLOT_VAGINA) //SPLURT edit
