/datum/interaction/lewd/unholy/piss_over
	name = "Piss Over"
	description = "Piss all over them."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_BOTTOMLESS)
	message = list(
		"relieves themselves all over %TARGET%",
		"marks their territory on %TARGET%",
		"releases their bladder onto %TARGET%",
		"pisses all over %TARGET%"
	)
	user_messages = list(
		"You feel relief as you release onto %TARGET%",
		"You empty your bladder on %TARGET%",
		"You mark %TARGET% with your urine"
	)
	target_messages = list(
		"%USER% pisses all over you",
		"You feel %USER%'s warm urine splash on you",
		"%USER% marks you as their territory"
	)
	sound_possible = list()
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 0
	user_arousal = 2
	target_arousal = 2

/datum/interaction/lewd/unholy/piss_over/New()
	sound_possible = GLOB.waterpiss_noises // GLOB.waterpiss_noises: expected a constant expression
	. = ..()

/datum/interaction/lewd/unholy/piss_mouth
	name = "Piss Mouth"
	description = "Piss inside their mouth."
	interaction_requires = list(
		INTERACTION_REQUIRE_SELF_BOTTOMLESS,
		INTERACTION_REQUIRE_TARGET_MOUTH
	)
	message = list(
		"relieves themselves into %TARGET%'s mouth",
		"fills %TARGET%'s mouth with piss",
		"releases their bladder down %TARGET%'s throat",
		"uses %TARGET%'s mouth as their urinal"
	)
	user_messages = list(
		"You feel relief as you release into %TARGET%'s mouth",
		"You empty your bladder down %TARGET%'s throat",
		"You make %TARGET% drink your piss"
	)
	target_messages = list(
		"%USER% pisses right into your mouth",
		"You're forced to swallow %USER%'s urine",
		"%USER% uses your mouth as their urinal"
	)
	sound_possible = list()
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 0
	user_arousal = 3
	target_arousal = 3

/datum/interaction/lewd/unholy/piss_mouth/New()
	sound_possible = GLOB.waterpiss_noises // GLOB.waterpiss_noises: expected a constant expression
	. = ..()

/datum/interaction/lewd/unholy/piss_mouth/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	conditional_pref_sound(user, pick('modular_zzplurt/sound/interactions/crapjob.ogg',
			'modular_zzplurt/sound/interactions/crapjob1.ogg'), 80, TRUE, falloff_distance = sound_range, pref_to_check = /datum/preference/toggle/erp/sounds) // interaction with the mouth
