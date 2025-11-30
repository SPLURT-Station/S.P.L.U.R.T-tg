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
	sound_range = 1
	sound_use = FALSE
	user_pleasure = 0
	target_pleasure = 0
	user_arousal = 2
	target_arousal = 2

/datum/interaction/lewd/unholy/piss_over/act(mob/living/user, mob/living/target)
	. = ..()
	var/obj/item/organ/bladder/bladder = user.get_organ_slot(ORGAN_SLOT_BLADDER)
	if(bladder && ishuman(target))
		var/datum/reagents/reagents = new /datum/reagents(bladder.piss_amount, NONE)
		reagents.add_reagent(bladder.pissin_reagent, bladder.piss_amount, reagtemp = bladder.piss_temperature)
		reagents.expose(target, TOUCH)
		qdel(reagents)

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
	sound_range = 1
	sound_use = FALSE
	user_pleasure = 0
	target_pleasure = 0
	user_arousal = 3
	target_arousal = 3

/datum/interaction/lewd/unholy/piss_mouth/act(mob/living/user, mob/living/target)
	. = ..()
	var/obj/item/organ/bladder/bladder = user.get_organ_slot(ORGAN_SLOT_BLADDER)
	if(bladder && ishuman(target))
		var/datum/reagents/reagents = new /datum/reagents(bladder.piss_amount, NONE)
		reagents.add_reagent(bladder.pissin_reagent, bladder.piss_amount, reagtemp = bladder.piss_temperature)
		reagents.expose(target, INGEST)
		qdel(reagents)
