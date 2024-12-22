/mob/living/proc/do_frot(mob/living/target)
	var/message
	var/t_His = p_their()

	message = "rubs [t_His] penis against [target]'s."
	set_is_fucking(target, CUM_TARGET_PENIS, get_organ_slot(ORGAN_SLOT_PENIS))
	visible_message("<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_PENIS, target)
	target.handle_post_sex(NORMAL_LUST, CUM_TARGET_PENIS, src)

/mob/living/proc/do_jackoff(mob/living/user)
	var/message
	var/t_His = p_their()
	var/t_Him = p_them()

	if(user.is_fucking(src, CUM_TARGET_HAND))
		message = "[pick("jerks [t_Him]self off.",
			"works [t_His] shaft.",
			"strokes [t_His] penis.",
			"wanks [t_His] cock hard.")]"
	else
		message = "[pick("wraps [t_His] hand around [t_His] cock.",
			"starts to stroke [t_His] cock.",
			"starts playing with [t_His] cock.")]"
		user.set_is_fucking(src, CUM_TARGET_HAND, user.get_organ_slot(ORGAN_SLOT_PENIS) ? user.get_organ_slot(ORGAN_SLOT_PENIS) : null)

	playlewdinteractionsound(src, pick('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>")
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_HAND, src)

/mob/living/proc/do_fingerass_self(mob/living/user)
	var/t_His = p_their()
	var/t_Him = p_them()

	visible_message(message = "<span class='lewd'><b>\The [src]</b> [pick("fingers [t_Him]self.",
		"fingers [t_His] asshole.",
		"fingers [t_Him]self hard.")]</span>")
	playlewdinteractionsound(loc, 'modular_zzplurt/sound/interactions/champ_fingering.ogg', 50, 1, -1)
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_HAND, src)

/mob/living/proc/do_fingering_self(mob/living/user)
	var/t_His = p_their()

	visible_message(message = "<span class='lewd'><b>\The [src]</b> [pick("fingers [t_His] pussy deep.",
		"fingers [t_His] pussy.",
		"plays with [t_His] pussy",
		"fingers [t_His] own pussy hard.")]</span>")
	playlewdinteractionsound(loc, 'modular_zzplurt/sound/interactions/champ_fingering.ogg', 50, 1, -1)
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_HAND, src)

/mob/living/proc/do_titgrope_self(mob/living/user)
	var/message
	var/t_His = p_their()

	if(user.combat_mode == INTENT_HARM)
		message = "[pick("aggressively gropes [t_His] breast.",
					"grabs [t_His] breasts.",
					"tightly squeezes [t_His] breasts.",
					"slaps at [t_His] breasts.",
					"gropes [t_His] breasts roughly.")]"
	else
		message = "[pick("gently gropes [t_His] breast.",
					"softly squeezes [t_His] breasts.",
					"grips [t_His] breasts.",
					"runs a few fingers over [t_His] breast.",
					"delicately teases [t_His] nipple.",
					"traces a touch across [t_His] breast.")]"
	if(prob(5 + user.get_lust()))
		visible_message(message = "<span class='lewd'><b>\The [src]</b> [pick("shivers in arousal.",
				"moans quietly.",
				"breathes out a soft moan.",
				"gasps.",
				"shudders softly.",
				"trembles as [t_His] hands run across bare skin.")]</span>")
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>")
	playlewdinteractionsound(loc, 'modular_zzplurt/sound/interactions/squelch1.ogg', 50, 1, -1)
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_HAND, src)
