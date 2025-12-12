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
	sound_possible = GLOB.waterpiss_noises
	return ..()

// no checks for a full bladder because this is splurt

/datum/interaction/lewd/unholy/piss_over/act(mob/living/user, mob/living/target)
	. = ..()
	var/obj/item/organ/bladder/bladder = user.get_organ_slot(ORGAN_SLOT_BLADDER)
	if(bladder)
		var/turf/target_turf = get_turf(target)
		if(isnull(target_turf))
			return // piss off
		bladder.stored_piss = max(0, bladder.stored_piss - bladder.piss_dosage)
		if(target_turf.liquids?.reagent_list[/datum/reagent/ammonia/urine] < 15)
			target_turf.add_liquid(bladder.pissed_reagent, bladder.piss_dosage, FALSE, bladder.piss_temperature)


/datum/interaction/lewd/unholy/piss_self
	name = "Piss over self"
	description = "Piss all over yourself."
	usage = INTERACTION_SELF
	message = list(
		"relieves themselves all over themselves.",
		"releases onto themselves.",
		"paints themselves with their own urine.",
		"pisses all over themselves."
	)
	user_messages = list(
		"You feel relief as you release onto yourself.",
		"You empty your bladder on your own body.",
		"You mark your chest with your urine."
	)
	sound_possible = list()
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	user_arousal = 2

/datum/interaction/lewd/unholy/piss_self/New()
	sound_possible = GLOB.waterpiss_noises
	return ..()

/datum/interaction/lewd/unholy/piss_self/act(mob/living/user, mob/living/target)
	. = ..()
	var/obj/item/organ/bladder/bladder = user.get_organ_slot(ORGAN_SLOT_BLADDER)
	if(bladder)
		var/turf/target_turf = get_turf(user)
		if(isnull(target_turf))
			return // piss off
		bladder.stored_piss = max(0, bladder.stored_piss - bladder.piss_dosage)
		if(target_turf.liquids?.reagent_list[/datum/reagent/ammonia/urine] < 15)
			target_turf.add_liquid(bladder.pissed_reagent, bladder.piss_dosage, FALSE, bladder.piss_temperature)


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
	sound_possible = GLOB.waterpiss_noises.Copy() + list(
		'modular_zzplurt/sound/interactions/crapjob.ogg',
		'modular_zzplurt/sound/interactions/crapjob1.ogg'
	)
	return ..()

/datum/interaction/lewd/unholy/piss_mouth/act(mob/living/user, mob/living/target)
	. = ..()
	var/obj/item/organ/bladder/bladder = user.get_organ_slot(ORGAN_SLOT_BLADDER)
	if(bladder && ishuman(target))
		var/datum/reagents/reagents = new /datum/reagents(bladder.piss_dosage, NONE)
		reagents.add_reagent(bladder.pissed_reagent, bladder.piss_dosage, reagtemp = bladder.piss_temperature)
		reagents.expose(target, INGEST)
		qdel(reagents)
		bladder.stored_piss = max(0, bladder.stored_piss - bladder.piss_dosage)

/datum/interaction/lewd/unholy/piss_slit
	name = "Piss in slit"
	description = "Piss in their slit."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_BOTTOMLESS)
	message = list(
		"relieves themselves inside %TARGET%'s slit.",
		"marks %TARGET%'s slit as their territory.",
		"releases their bladder inside %TARGET%.",
		"pisses all over %TARGET%'s slit."
	)
	user_messages = list(
		"You feel relief as you release into %TARGET%.",
		"You empty your bladder into %TARGET%'s slit.",
		"You mark %TARGET%'s slit with your urine."
	)
	target_messages = list(
		"%USER% pisses inside your slit.",
		"You feel %USER%'s warm urine fill your slit.",
		"%USER% marks your slit as their territory."
	)
	sound_possible = list()
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 0
	user_arousal = 2
	target_arousal = 2

/datum/interaction/lewd/unholy/piss_slit/New()
	sound_possible = GLOB.waterpiss_noises
	return ..()

/datum/interaction/lewd/unholy/piss_slit/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return ..() && target?.dna?.features?["penis_sheath"] == SHEATH_SLIT

/datum/interaction/lewd/unholy/piss_slit/act(mob/living/user, mob/living/target)
	. = ..()
	var/obj/item/organ/bladder/bladder = user.get_organ_slot(ORGAN_SLOT_BLADDER)
	if(bladder && ishuman(target))
		bladder.stored_piss = max(0, bladder.stored_piss - bladder.piss_dosage)
		target.reagents.add_reagent(bladder.pissed_reagent, bladder.piss_dosage, reagtemp = bladder.piss_temperature)


/datum/interaction/lewd/unholy/piss_ass
	name = "Piss in ass"
	description = "Piss in their ass."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_BOTTOMLESS)
	target_required_parts = list(ORGAN_SLOT_ANUS = REQUIRE_GENITAL_EXPOSED)
	message = list(
		"relieves themselves inside %TARGET%'s anus.",
		"marks %TARGET%'s bowels as their territory.",
		"releases their bladder inside %TARGET%'s anus'.",
		"pisses all over %TARGET%'s anus."
	)
	user_messages = list(
		"You feel relief as you release into %TARGET%'s bowels'.",
		"You empty your bladder into %TARGET%'s anus.",
		"You mark %TARGET%'s insides with your urine."
	)
	target_messages = list(
		"%USER% pisses inside your anus.",
		"You feel %USER%'s warm urine fill your bowels.",
		"%USER% marks your anus as their territory."
	)
	sound_possible = list()
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 0
	user_arousal = 2
	target_arousal = 2

/datum/interaction/lewd/unholy/piss_ass/New()
	sound_possible = GLOB.waterpiss_noises
	return ..()

/datum/interaction/lewd/unholy/piss_ass/act(mob/living/user, mob/living/target)
	. = ..()
	var/obj/item/organ/bladder/bladder = user.get_organ_slot(ORGAN_SLOT_BLADDER)
	if(bladder && ishuman(target))
		bladder.stored_piss = max(0, bladder.stored_piss - bladder.piss_dosage)
		target.reagents.add_reagent(bladder.pissed_reagent, bladder.piss_dosage, reagtemp = bladder.piss_temperature)


/datum/interaction/lewd/unholy/piss_ear
	name = "Piss in ear"
	description = "Piss in their ear."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_BOTTOMLESS)
	message = list(
		"relieves themselves inside %TARGET%'s ear.",
		"marks %TARGET%'s ear as their territory.",
		"releases their bladder inside %TARGET%'s ear.",
		"pisses all over %TARGET%'s ear."
	)
	user_messages = list(
		"You feel relief as you release into %TARGET%'s ear'.",
		"You empty your bladder into %TARGET%'s ear.",
		"You mark %TARGET%'s head and ear with your urine."
	)
	target_messages = list(
		"%USER% pisses inside your ear.",
		"You feel %USER%'s warm urine fill your ear and head.",
		"%USER% marks your ear as their territory."
	)
	sound_possible = list()
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 0
	user_arousal = 2
	target_arousal = 2

/datum/interaction/lewd/unholy/piss_ear/New()
	sound_possible = GLOB.waterpiss_noises
	return ..()

/datum/interaction/lewd/unholy/piss_ear/act(mob/living/user, mob/living/target)
	. = ..()
	var/obj/item/organ/bladder/bladder = user.get_organ_slot(ORGAN_SLOT_BLADDER)
	if(bladder && ishuman(target))
		bladder.stored_piss = max(0, bladder.stored_piss - bladder.piss_dosage)
		target.reagents.add_reagent(bladder.pissed_reagent, bladder.piss_dosage, reagtemp = bladder.piss_temperature)


/datum/interaction/lewd/unholy/piss_urethra
	name = "Piss in urethra"
	description = "Piss in their urethra."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_BOTTOMLESS)
	message = list(
		"relieves themselves inside %TARGET%'s urethra.",
		"marks %TARGET%'s urethra as their territory.",
		"releases their bladder inside %TARGET%'s urethra.",
		"pisses all over %TARGET%'s urethra."
	)
	user_messages = list(
		"You feel relief as you release into %TARGET%'s urethra'.",
		"You empty your bladder into %TARGET%'s urethra.",
		"You mark %TARGET%'s urethra with your urine."
	)
	target_messages = list(
		"%USER% pisses inside your urethra.",
		"You feel %USER%'s warm urine fill your urethra.",
		"%USER% marks your urethra as their territory."
	)
	sound_possible = list()
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 0
	user_arousal = 2
	target_arousal = 2

/datum/interaction/lewd/unholy/piss_urethra/New()
	sound_possible = GLOB.waterpiss_noises
	return ..()

/datum/interaction/lewd/unholy/piss_urethra/act(mob/living/user, mob/living/target)
	. = ..()
	var/obj/item/organ/bladder/bladder = user.get_organ_slot(ORGAN_SLOT_BLADDER)
	if(bladder && ishuman(target))
		bladder.stored_piss = max(0, bladder.stored_piss - bladder.piss_dosage)
		target.reagents.add_reagent(bladder.pissed_reagent, bladder.piss_dosage, reagtemp = bladder.piss_temperature)
