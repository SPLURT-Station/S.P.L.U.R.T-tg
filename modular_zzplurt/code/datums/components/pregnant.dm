/datum/component/pregnant
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// Baby boy we are holding, if he dies or is moved bad things happen and the component is deleted
	var/mob/living/baby_boy

	/// Name of the mommy
	var/father_name
	/// Name of the daddy
	var/mother_name
	/// Genetic distribution
	var/genetic_distribution = PREGNANCY_GENETIC_DISTRIBUTION_DEFAULT
	/// Ways the egg has been tampered with, reducing ghost choice - Associative list
	var/list/tampering = list()

	/// Copy of the father's DNA
	var/datum/dna/father_dna
	/// Copy of the mother's DNA
	var/datum/dna/mother_dna

/datum/component/pregnant/Initialize(mob/living/baby_boy, mother_name, father_name, baby_name, datum/dna/mother_dna, datum/dna/father_dna, genetic_distribution)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

	if(!baby_boy)
		qdel(src)
		return

	src.baby_boy = baby_boy
	baby_boy.forceMove(parent)
	if(baby_name)
		tampering["name"] = baby_name
	src.mother_name = mother_name
	src.father_name = father_name
	if(mother_dna)
		src.mother_dna = new()
		mother_dna.copy_dna(src.father_dna)
	if(father_dna)
		src.father_dna = new()
		father_dna.copy_dna(src.father_dna)

	if(!isnull(genetic_distribution))
		src.genetic_distribution = genetic_distribution

/datum/component/pregnant/RegisterWithParent()
	RegisterSignal(parent, SIGNAL_ADDTRAIT(TRAIT_WAS_RENAMED), PROC_REF(on_renamed))
	RegisterSignal(parent, SIGNAL_REMOVETRAIT(TRAIT_WAS_RENAMED), PROC_REF(on_renamed_removed))
	RegisterSignal(parent, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_GHOST, PROC_REF(on_attack_ghost))
	RegisterSignal(parent, COMSIG_ATOM_BREAK, PROC_REF(still_birth))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	if(baby_boy)
		RegisterSignal(baby_boy, COMSIG_MOVABLE_MOVED, PROC_REF(still_birth))
		RegisterSignal(baby_boy, COMSIG_LIVING_DEATH, PROC_REF(still_birth))
		RegisterSignal(baby_boy, COMSIG_QDELETING, PROC_REF(still_birth))
		baby_boy.AddComponent(\
			/datum/component/ghost_direct_control,\
			ban_type = ROLE_SENTIENCE,\
			role_name = "Offspring of [mother_name || "someone"][father_name ? " and [father_name]" : ""]",\
			poll_question = "Do you want to play as [mother_name || "someone"]'s offspring?[tampering["name"] ? " Your name will be [tampering["name"]]" : ""]",\
			poll_candidates = TRUE,\
			poll_length = 1.5 MINUTES,\
			assumed_control_message = "You are the son (or daughter) of [mother_name || "someone"][father_name ? " and [father_name]" : ""]!",\
			poll_ignore_key = POLL_IGNORE_PREGNANCY,\
			after_assumed_control = CALLBACK(src, PROC_REF(ghost_assumed_control)),\
		)

/datum/component/pregnant/UnregisterFromParent()
	UnregisterSignal(parent, list(\
		SIGNAL_ADDTRAIT(TRAIT_WAS_RENAMED),\
		SIGNAL_REMOVETRAIT(TRAIT_WAS_RENAMED),\
		COMSIG_ATOM_ATTACKBY,
		COMSIG_ATOM_ATTACK_GHOST,\
		COMSIG_ATOM_BREAK,\
		COMSIG_ATOM_EXAMINE,\
	))
	if(!QDELETED(baby_boy))
		UnregisterSignal(baby_boy, list(\
			COMSIG_MOVABLE_MOVED,\
			COMSIG_LIVING_DEATH,\
			COMSIG_QDELETING,\
		))
		qdel(baby_boy.GetComponent(/datum/component/ghost_direct_control))

/datum/component/pregnant/Destroy(force)
	baby_boy = null
	return ..()

/datum/component/pregnant/proc/on_attackby(atom/source, obj/item/thing, mob/living/user, params)
	SIGNAL_HANDLER

	if(!thing.is_drawable(user) || user.combat_mode)
		return

	var/male_amount = thing.reagents.get_reagent_amount(/datum/reagent/consumable/cum)
	var/female_amount = thing.reagents.get_reagent_amount(/datum/reagent/consumable/femcum)
	if(!male_amount && !female_amount)
		return

	var/diff = male_amount - female_amount
	diff = clamp(diff, -genetic_distribution, 100 - genetic_distribution)
	if(!diff)
		return COMPONENT_CANCEL_ATTACK_CHAIN

	genetic_distribution += diff
	thing.reagents.remove_all(/datum/reagent/consumable/cum)
	thing.reagents.remove_all(/datum/reagent/consumable/femcum)
	to_chat(user, span_notice("You alter the genetic distribution of [parent], it is now [genetic_distribution]%."))
	tampering["genetic_distribution"] = genetic_distribution
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/pregnant/proc/on_attack_ghost(mob/source, mob/dead/observer/hopeful_ghost)
	SIGNAL_HANDLER

	//relay to the mob
	if(baby_boy)
		INVOKE_ASYNC(baby_boy, TYPE_PROC_REF(/atom, attack_ghost), hopeful_ghost)
		return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/pregnant/proc/on_renamed(atom/source)
	SIGNAL_HANDLER

	var/baby_name = reject_bad_name(source.name)
	if(baby_name)
		tampering["name"] = baby_name
	else
		tampering -= "name"

/datum/component/pregnant/proc/on_renamed_removed(atom/source)
	SIGNAL_HANDLER

	tampering -= "name"

/datum/component/pregnant/proc/on_examine(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	examine_list += span_notice("[source] [source.p_have()] something hatching inside of [source.p_them()]!")
	var/parents
	if(mother_name && father_name)
		parents = "<b>[mother_name]</b> and <b>[father_name]</b>"
	else if(mother_name)
		parents = "<b>[mother_name]</b>"
	else if(father_name)
		parents = "<b>[father_name]</b>"
	if(parents)
		examine_list += span_info("It is the offspring of [parents].")
	if(tampering["name"])
		examine_list += span_info("The offspring's name will be \"[tampering["name"]]\".")
	//entrails reader can get deeper information about the baby
	if(HAS_MIND_TRAIT(user, TRAIT_ENTRAILS_READER) || isobserver(user))
		if(tampering["genetic_distribution"])
			examine_list += span_info("The offspring will inherit [genetic_distribution]% of their DNA from their father, [100-genetic_distribution]% from their mother.")
		else
			examine_list += span_info("The offspring's genetic distribution is uncertain.")

		if(tampering["physique"])
			examine_list += span_info("The offspring will be a biological [tampering["physique"]].")
		else
			examine_list += span_info("The offspring's biological sex is uncertain.")

		if(tampering["gender"])
			examine_list += span_info("The offspring will be referred to as a [tampering["gender"]]")
		else
			examine_list += span_info("The offspring's gender is uncertain.")

/datum/component/pregnant/proc/still_birth(atom/source)
	SIGNAL_HANDLER

	var/atom/atom_parent = parent
	if(QDELETED(baby_boy))
		baby_boy = null
	else
		QDEL_NULL(baby_boy)
	if(!QDELETED(atom_parent))
		new /obj/effect/gibspawner/generic(atom_parent.drop_location())
		if(atom_parent.uses_integrity)
			atom_parent.take_damage(atom_parent.max_integrity * (1-atom_parent.integrity_failure))
	if(!QDELING(src))
		qdel(src)

/datum/component/pregnant/proc/ghost_assumed_control(mob/living/a_living_soul)
	var/atom/atom_parent = parent
	if(!QDELING(src))
		qdel(src)
	playsound(atom_parent, 'sound/effects/splat.ogg', 80, vary = TRUE)
	a_living_soul.AdjustUnconscious(30 SECONDS)
	a_living_soul.forceMove(atom_parent.drop_location())
	if(atom_parent.uses_integrity)
		atom_parent.take_damage(atom_parent.max_integrity * (1-atom_parent.integrity_failure))
	if(ishuman(a_living_soul))
		INVOKE_ASYNC(src, PROC_REF(assumed_control_async), a_living_soul)

/datum/component/pregnant/proc/assumed_control_async(mob/living/carbon/human/a_living_soul)
	//dna determination
	if(father_dna && mother_dna && !tampering.Find("genetic_distribution"))
		var/target_distribution = tgui_input_number(a_living_soul, "What will  be your genetic distribution? (0 - All father, 50 - Equal mix, 100 - All mother)", "The miracle of birth", src.genetic_distribution, PREGNANCY_GENETIC_DISTRIBUTION_MAXIMUM, PREGNANCY_GENETIC_DISTRIBUTION_MINIMUM)
		determine_baby_dna(a_living_soul, src.mother_dna, src.father_dna, target_distribution)

	//name determination
	if(!tampering.Find("name"))
		var/target_name = reject_bad_name(tgui_input_text(a_living_soul, "What will be your name?", "The miracle of birth", a_living_soul.real_name))
		if(target_name)
			a_living_soul.real_name = target_name
			a_living_soul.name = a_living_soul.real_name
	else
		a_living_soul.real_name = tampering["name"] || generate_random_name_species_based(a_living_soul.gender, unique = TRUE, species_type = a_living_soul.dna.species.type)
		a_living_soul.name = a_living_soul.real_name

	//biological sex determination
	if(!tampering.Find("physique"))
		var/static/list/possible_sexes = list(
			MALE,
			FEMALE,
		)
		a_living_soul.physique = tgui_input_list(a_living_soul, "What will be your biological sex? (Used for mob sprite generation)", "The miracle of birth", possible_sexes, a_living_soul.physique || MALE)

	//gender determination
	if(!tampering.Find("gender"))
		var/list/possible_genders = list(
			"Refer to biological sex" = a_living_soul.physique,
			"He/Him" = MALE,
			"She/Her" = FEMALE,
			"They/Them" = PLURAL,
			"It/It's" = NEUTER,
		)
		var/heelvsbabyface = tgui_input_list(a_living_soul, "What will be your pronouns? (How the game refers to your character)", "The miracle of birth", possible_genders, possible_genders[1])
		a_living_soul.gender = possible_genders[heelvsbabyface]

	a_living_soul.updateappearance(icon_update = TRUE, mutcolor_update = TRUE, mutations_overlay_update = TRUE) //bad proc name

/proc/determine_baby_dna(mob/living/carbon/human/baby_boy, datum/dna/mother_dna, datum/dna/father_dna, genetic_distribution = PREGNANCY_GENETIC_DISTRIBUTION_DEFAULT)
	//inherit species from momma no matter what
	baby_boy.set_species(mother_dna.species.type)

	//now do the rest
	var/datum/dna/baby_dna = baby_boy.dna
	baby_dna.features = list()
	baby_dna.mutant_bodyparts = list()
	baby_dna.body_markings = list()
	//identity blocks first
	for(var/block_id in GLOB.dna_identity_blocks)
		var/datum/dna_block/identity/block = GLOB.dna_identity_blocks[block_id]
		if(prob(genetic_distribution))
			baby_dna.unique_identity = block.modified_hash(baby_dna.unique_identity, block.get_block(father_dna.unique_identity))
		else
			baby_dna.unique_identity = block.modified_hash(baby_dna.unique_identity, block.get_block(mother_dna.unique_identity))
	//features second
	for(var/feature in (mother_dna.features | father_dna.features))
		if(prob(genetic_distribution))
			if(!father_dna.features[feature])
				continue
			baby_dna.features[feature] = father_dna.features[feature]
		else
			if(!mother_dna.features[feature])
				continue
			baby_dna.features[feature] = mother_dna.features[feature]
	//mutant bodyparts third (this is where the mess begins)
	//removed due to upstream edits, we might need to fix it later.
	// for(var/key in SSaccessories.genetic_accessories)
	// 	if(prob(genetic_distribution))
	// 		if(!father_dna.mutant_bodyparts[key] ||
	// 			!(father_dna.mutant_bodyparts[key][MUTANT_INDEX_NAME] in SSaccessories.genetic_accessories[key]))
	// 			continue
	// 		baby_dna.mutant_bodyparts[key] = list() | father_dna.mutant_bodyparts[key]
	// 	else
	// 		if(!mother_dna.mutant_bodyparts[key] ||
	// 			!(mother_dna.mutant_bodyparts[key][MUTANT_INDEX_NAME] in SSaccessories.genetic_accessories[key]))
	// 			continue
	// 		baby_dna.mutant_bodyparts[key] = list() | father_dna.mutant_bodyparts[key]
	//markings fourth (this is stupid, but i couldnt figure out a better solution than limb based quite yet)
	for(var/zone in GLOB.marking_zones)
		if(prob(genetic_distribution))
			if(!father_dna.body_markings[zone])
				continue
			baby_dna.body_markings[zone] = list() | father_dna.body_markings[zone]
		else
			if(!mother_dna.body_markings[zone])
				continue
			baby_dna.body_markings[zone] = list() | mother_dna.body_markings[zone]

	//not realistic but i am too lazy to make it work good for now
	if(prob(genetic_distribution))
		baby_dna.blood_type = father_dna.blood_type
	else
		baby_dna.blood_type = mother_dna.blood_type

	//blood color and blend mode are handled by species, so i am under the assumption i should not touch them directly

	/*
	I am a great soft jelly thing. Smoothly rounded, with no mouth,
	with pulsing white holes filled by fog where my eyes used to be. Rubbery appendages that were once my arms;
	bulks rounding down into legless humps of soft slippery matter.
	I leave a moist trail when I move.
	Blotches of diseased, evil gray come and go on my surface, as though light is being beamed from within.
	Outwardly: dumbly, I shamble about, a thing that could never have been known as human, a thing whose shape is so alien a travesty
	that humanity becomes more obscene for the vague resemblance.
	Inwardly: alone. Here. Living under the land, under the sea, in the belly of AM, whom we created because our time was badly spent
	and we must have known unconsciously that he could do it better. At least the four of them are safe at last.
	AM will be all the madder for that. It makes me a little happier. And yet ... AM has won, simply ... he has taken his revenge ...
	*/
	baby_boy.underwear = "Nude"
	baby_boy.undershirt = "Nude"
	baby_boy.socks = "Nude"

	baby_boy.updateappearance(icon_update = TRUE, mutcolor_update = TRUE, mutations_overlay_update = TRUE) //bad proc name
