/datum/component/bellyriding
	/// Who is currently attached to us?
	var/mob/living/carbon/human/current_victim = null
	/// What was our last interaction? Used for interaction swapping logic.
	var/datum/interaction/last_interaction = null
	/// How many steps must the parent take for the next interaction to occur? Decrements every step.
	var/steps_until_interaction = 4

	// For restoring old state of the parent. Egh.
	var/old_can_buckle
	var/old_buckle_requires_restraints
	var/old_can_buckle_to

/datum/component/bellyriding/Initialize(atom/movable/buckle_relay)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	if(!istype(buckle_relay))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(buckle_relay, COMSIG_MOUSEDROPPED_ONTO, PROC_REF(on_mousedropped_onto))
	RegisterSignal(buckle_relay, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_attack_hand))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_step))
	RegisterSignal(parent, COMSIG_ATOM_POST_DIR_CHANGE, PROC_REF(update_visuals))

/datum/component/bellyriding/Destroy(force)
	unbuckle_victim()
	return ..()


/datum/component/bellyriding/proc/on_mousedropped_onto(datum/_source, mob/living/carbon/human/victim, user, params)
	SIGNAL_HANDLER

	try_buckle_victim(victim, user)

/datum/component/bellyriding/proc/on_attack_hand(datum/_source, mob/living/user, list/modifiers)
	SIGNAL_HANDLER

	return try_unbuckle_victim(user)

/datum/component/bellyriding/proc/on_step(datum/_source, old_loc, movement_dir, forced, old_locs, momentum_change)
	SIGNAL_HANDLER

	if(isnull(current_victim))
		return

	steps_until_interaction -= 1
	if(steps_until_interaction <= 0)
		steps_until_interaction = initial(steps_until_interaction) // it works, ok?
		heehoo_pp()
	update_visuals()

#define UNBUCKLE_UNDO_EVERYTHING parent.can_buckle = old_can_buckle; parent.buckle_requires_restraints = old_buckle_requires_restraints; parent.max_buckled_mobs -= 1;
/datum/component/bellyriding/proc/try_buckle_victim(mob/living/carbon/human/victim, mob/user)
	set waitfor = FALSE

	var/mob/living/carbon/human/parent = src.parent

	// ok lets do some stupids here.. we're relying on native buckling behaviour
	// but if we dont do some tweaking it'll fuck over fireman carry/any other buckles
	old_can_buckle = parent.can_buckle
	old_buckle_requires_restraints = parent.buckle_requires_restraints
	old_can_buckle_to = victim.can_buckle_to

	parent.can_buckle = TRUE
	parent.buckle_requires_restraints = TRUE
	parent.max_buckled_mobs += 1 // add a slot for us

	if(!can_buckle(victim, user))
		UNBUCKLE_UNDO_EVERYTHING
		return

	var/torturer_message = span_warning("You begin fastening [victim] to your harness..")
	var/victim_message = span_warning("[parent] begins fastening you to [parent.p_their()] harness!")
	var/observer_message = span_warning("[parent] begin fastening [victim] to [parent.p_their()] harness!")

	user.visible_message(observer_message, torturer_message, ignored_mobs = list(victim))
	to_chat(current_victim, victim_message)

	if(!do_after(user, 3 SECONDS, victim) || !can_buckle(victim, user) || !parent.buckle_mob(victim, TRUE, TRUE))
		UNBUCKLE_UNDO_EVERYTHING
		return

	if(!parent.dna.species.mutant_bodyparts[FEATURE_TAUR])
		parent.add_movespeed_modifier(/datum/movespeed_modifier/bellyriding_nontaur)

	current_victim = victim
	current_victim.can_buckle_to = FALSE
	RegisterSignal(current_victim, COMSIG_QDELETING, PROC_REF(unbuckle_victim))
	update_visuals()

#undef UNBUCKLE_UNDO_EVERYTHING

/datum/component/bellyriding/proc/try_unbuckle_victim(mob/living/carbon/human/user)
	set waitfor = FALSE

	var/atom/movable/parent = src.parent
	if(isnull(current_victim) || DOING_INTERACTION_WITH_TARGET(user, parent))
		return

	. = COMPONENT_CANCEL_ATTACK_CHAIN

	var/torturer_message = span_warning("You start unstrapping [current_victim] from your harness..")
	var/victim_message = span_warning("[parent] starts freeing you from [parent.p_their()] harness..")
	var/observer_message = span_warning("[parent] starts unstrapping [current_victim] from [parent.p_their()] harness..")

	user.visible_message(observer_message, torturer_message, ignored_mobs = list(current_victim))
	to_chat(current_victim, victim_message)

	if(!do_after(user, 3 SECONDS, current_victim))
		return

	unbuckle_victim(user)

#define BELLYRIDING_SOURCE "bellyriding source. i mean no one can check these anyways no? i could write anything here. avali are cool. go play them."
/datum/component/bellyriding/proc/unbuckle_victim()
	if(isnull(current_victim))
		return

	var/mob/living/carbon/human/parent = src.parent
	parent.unbuckle_mob(current_victim, TRUE)
	parent.can_buckle = old_can_buckle
	parent.buckle_requires_restraints = old_buckle_requires_restraints
	parent.max_buckled_mobs -= 1
	parent.remove_movespeed_modifier(/datum/movespeed_modifier/bellyriding_nontaur)
	last_interaction = null

	UnregisterSignal(current_victim, COMSIG_QDELETING)
	current_victim.can_buckle_to = old_can_buckle_to
	current_victim.remove_offsets(BELLYRIDING_SOURCE, TRUE)
	current_victim.transform = null
	current_victim.Stun(2 SECONDS, TRUE)
	current_victim = null


/datum/component/bellyriding/proc/can_buckle(mob/living/carbon/human/victim, mob/user)
	var/atom/movable/parent = src.parent
	if(!istype(victim) || DOING_INTERACTION_WITH_TARGET(user, parent))
		return FALSE

	if(current_victim)
		to_chat(user, span_warning("There's someone already strapped to your belly!"))
		return FALSE
	if(!victim.handcuffed || !victim.legcuffed)
		to_chat(user, span_warning("[victim] needs to be both handcuffed and legcuffed!"))
		return FALSE
	return parent.is_buckle_possible(victim, TRUE, TRUE)


/datum/component/bellyriding/proc/update_visuals()
	if(isnull(current_victim))
		return

	var/mob/living/carbon/human/parent = src.parent

	var/datum/sprite_accessory/taur/taur_accessory
	var/taur_mutant_bodypart = parent.dna.species.mutant_bodyparts[FEATURE_TAUR]
	if(taur_mutant_bodypart)
		var/bodypart_name = taur_mutant_bodypart[MUTANT_INDEX_NAME]
		var/datum/sprite_accessory/taur/potential_accessory = SSaccessories.sprite_accessories[FEATURE_TAUR][bodypart_name]
		if(potential_accessory?.taur_mode in list(STYLE_TAUR_HOOF, STYLE_TAUR_PAW))
			taur_accessory = potential_accessory

	spawn(0) // sigh
		current_victim.setDir(taur_accessory ? REVERSE_DIR(parent.dir) : parent.dir)

	// reset any potential stupids
	var/matrix/final_transform = matrix()

	var/x_offset = parent.pixel_x + parent.pixel_w
	var/y_offset = parent.pixel_y + parent.pixel_z
	var/layer = parent.layer + 0.001 //arbitrary
	if(taur_accessory)
		layer = parent.layer - 0.001
		final_transform = final_transform.Scale(0.8)
		switch(parent.dir)
			if(EAST)
				x_offset -= 2
				y_offset -= 10
				final_transform.Turn(80)
			if(WEST)
				x_offset += 2
				y_offset -= 10
				final_transform.Turn(-80)

		if(parent.body_position == LYING_DOWN)
			y_offset += (taur_accessory.laydown_offset * 0.5)
	else
		y_offset += 4 // arbitrary
		switch(parent.dir)
			if(EAST)
				x_offset += 6
			if(WEST)
				x_offset -= 6
			if(NORTH)
				layer = parent.layer - 0.001 // arbitrary

	current_victim.transform = final_transform
	current_victim.add_offsets(BELLYRIDING_SOURCE, x_add = x_offset, y_add = y_offset, animate = FALSE)
	current_victim.layer = layer

#undef BELLYRIDING_SOURCE

/datum/component/bellyriding/proc/heehoo_pp()
	var/mob/living/carbon/human/parent = src.parent
	if(!parent.has_genital(REQUIRE_GENITAL_EXPOSED, ORGAN_SLOT_PENIS))
		return // why do we bother

	var/datum/interaction/no_orifice_interaction = SSinteractions.interactions["bellyriding dick frot"] // who made these indexed by name istG
	if(!no_orifice_interaction.allow_act(parent, current_victim))
		no_orifice_interaction = SSinteractions.interactions["bellyriding dick rub against groin"]


	if(isnull(last_interaction) || !last_interaction.allow_act(parent, current_victim))
		// swap to fallback
		last_interaction = no_orifice_interaction
		goto do_the_violate

	if(last_interaction == no_orifice_interaction)
		if(prob(20))
			goto do_the_violate // actually let's tease them a bit more

		// roll which hole do we violate
		for(var/datum/interaction/candidate_type in shuffle(subtypesof(/datum/interaction/lewd/bellyriding)))
			var/datum/interaction/candidate = SSinteractions.interactions[candidate_type::name]
			if(candidate.allow_act(parent, current_victim))
				last_interaction = candidate
				break

		// assume we rolled something
		goto do_the_violate


	else if(prob(0.5))
		// small chance for dick to slip out (give a chance for other holes to shine)
		var/obj/item/organ/genital/penis/penis = parent.get_organ_slot(ORGAN_SLOT_PENIS)
		parent.visible_message(
			span_lewd("[parent]'s [penis.genital_type] cock slips out of [current_victim]'s orifice!"),
			span_lewd("Your [penis.genital_type] cock slips out of [current_victim]'s hole!"), // assume the ppl using this item wont know what an orifice is
			ignored_mobs = list(current_victim)
		)
		to_chat(current_victim, "[parent]'s [penis.genital_type] cock slips out of your hole!")
		playsound(current_victim, 'sound/effects/emotes/kiss.ogg', 50, TRUE, -6)
		last_interaction = null
		return

	do_the_violate:
	ASYNC last_interaction.act(parent, current_victim)


/datum/movespeed_modifier/bellyriding_nontaur
	multiplicative_slowdown = 0.8 // completely arbitrary
