/datum/component/bellyriding
	/// Who is currently attached to us?
	var/mob/living/carbon/human/current_victim = null
	/// What was our last interaction? Used for interaction swapping logic.
	var/datum/interaction/last_interaction = null
	/// How many steps must the parent take for the next interaction to occur? Decrements every step.
	var/steps_until_interaction = 4
	/// Is our ability to do interactions enabled?
	var/enable_interactions = TRUE
	/// Our tied ability.
	var/datum/action/innate/toggle_bellyriding_heehee_pp/stored_action = new

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
	QDEL_NULL(stored_action)
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

	// ok let's do some stupids here.. we're relying on native buckling behaviour
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

	// actually buckling now
	stored_action.Grant(parent)
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

	unbuckle_victim()

#define BELLYRIDING_SOURCE "bellyriding source. i mean no one can check these anyways no? i could write anything here. avali are cool. go play them."
/datum/component/bellyriding/proc/unbuckle_victim(skip_unbuckle = FALSE)
	var/mob/living/carbon/human/parent = src.parent
	var/mob/living/carbon/human/current_victim = src.current_victim
	if(isnull(current_victim))
		return

	src.current_victim = null

	if(!skip_unbuckle)
		parent.unbuckle_mob(current_victim, TRUE)
	parent.can_buckle = old_can_buckle
	parent.buckle_requires_restraints = old_buckle_requires_restraints
	parent.max_buckled_mobs -= 1
	parent.remove_movespeed_modifier(/datum/movespeed_modifier/bellyriding_nontaur)
	last_interaction = null

	stored_action.Remove(parent)

	UnregisterSignal(current_victim, COMSIG_QDELETING)
	current_victim.can_buckle_to = old_can_buckle_to
	current_victim.remove_offsets(BELLYRIDING_SOURCE, TRUE)
	current_victim.transform = null
	current_victim.dna.current_body_size = 1 // cache var, breaks if we dont reset it
	current_victim.dna.update_body_size() // apply it AFTER transform = null, because yeah
	current_victim.Knockdown(0.1 SECONDS, TRUE)


/datum/component/bellyriding/proc/can_buckle(mob/living/carbon/human/victim, mob/user)
	var/mob/living/carbon/human/parent = src.parent
	if(!istype(victim) || DOING_INTERACTION_WITH_TARGET(user, parent))
		return FALSE

	// victim checks
	if(current_victim)
		to_chat(user, span_warning("There's someone already strapped to your belly!"))
		return FALSE
	if(!victim.handcuffed || !victim.legcuffed)
		to_chat(user, span_warning("[victim] needs to be both handcuffed and legcuffed!"))
		return FALSE

	// user checks
	if(victim.mob_size > parent.mob_size)
		to_chat(user, span_warning("[victim] is bigger than you, how would that even work?"))
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
	current_victim.transform = null
	current_victim.dna.current_body_size = 1 // cache var, breaks if we dont reset it
	current_victim.dna.update_body_size()

	var/x_offset = parent.pixel_x + parent.pixel_w
	var/y_offset = parent.pixel_y + parent.pixel_z - current_victim.transform.f // cancel the vertical transform applied by update_body_size()

	var/layer = parent.layer + 0.001 //arbitrary
	if(taur_accessory) // torturer is taur
		var/taur_x_offset
		var/taur_y_offset
		if(isteshari(current_victim))
			// 200 size	- pixel_x = -10,  pixel_y = -8
			// regular	- pixel_x = -2,   pixel_y = -10
			taur_x_offset = 2 + (parent.dna.current_body_size - 1) * 8
			taur_y_offset = 10 + (parent.dna.current_body_size - 1) * -2
		else
			// 200 size	- pixel_x = 14, pixel_y = -9
			// regular	- pixel_x = 4, pixel_y = -12
			taur_x_offset = 4 + (parent.dna.current_body_size - 1) * 10
			taur_y_offset = 12 + (parent.dna.current_body_size - 1) * -3

		layer = parent.layer - 0.001
		current_victim.transform = current_victim.transform.Scale(0.8)
		switch(parent.dir)
			if(EAST)
				x_offset -= taur_x_offset
				y_offset -= taur_y_offset
				current_victim.transform = current_victim.transform.Turn(80)
			if(WEST)
				x_offset += taur_x_offset
				y_offset -= taur_y_offset
				current_victim.transform = current_victim.transform.Turn(-80)

	else // torturer is biped
		// 200 size on 100 victim: pixel_x = -13, pixel_y = 18
		// regular 			 	   pixel_x = -6,  pixel_y = 4
		var/biped_x_offset = 7 * parent.dna.current_body_size - 1
		y_offset += 14 * parent.dna.current_body_size - 10

		switch(parent.dir)
			if(EAST)
				x_offset += biped_x_offset
			if(WEST)
				x_offset -= biped_x_offset
			if(NORTH)
				layer = parent.layer - 0.001

	current_victim.add_offsets(BELLYRIDING_SOURCE, x_add = x_offset, y_add = y_offset, animate = FALSE)
	current_victim.layer = layer

#undef BELLYRIDING_SOURCE

/datum/component/bellyriding/proc/heehoo_pp()
	var/mob/living/carbon/human/parent = src.parent
	if(!parent.has_genital(REQUIRE_GENITAL_EXPOSED, ORGAN_SLOT_PENIS) || !enable_interactions)
		return // why do we bother

	var/datum/interaction/no_orifice_interaction = SSinteractions.interactions[/datum/interaction/lewd/bellyriding/frot::name] // who made these indexed by name istG
	if(!no_orifice_interaction.allow_act(parent, current_victim))
		no_orifice_interaction = SSinteractions.interactions[/datum/interaction/lewd/bellyriding/groin_rub::name]

	if(isnull(last_interaction) || !last_interaction.allow_act(parent, current_victim))
		// swap to fallback
		last_interaction = no_orifice_interaction
		goto do_the_violate

	if(last_interaction == no_orifice_interaction)
		if(prob(80))
			goto do_the_violate // actually let's tease them a bit more


		// roll which hole do we violate
		var/list/possible_interactions = list(/datum/interaction/lewd/bellyriding/anus, /datum/interaction/lewd/bellyriding/vagina)
		shuffle_inplace(possible_interactions)

		for(var/datum/interaction/candidate_type as anything in possible_interactions)
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
			span_love("[parent]'s [penis.genital_type] cock slips out of [current_victim]'s orifice!"),
			span_love("Your [penis.genital_type] cock slips out of [current_victim]'s hole!"), // assume the ppl using this item wont know what an orifice is
			ignored_mobs = list(current_victim)
		)
		to_chat(current_victim, span_love("[parent]'s [penis.genital_type] cock slips out of your hole!"))
		playsound(current_victim, 'sound/effects/emotes/kiss.ogg', 50, TRUE, -6)
		last_interaction = null
		return

	do_the_violate:
	ASYNC last_interaction.act(parent, current_victim)

/mob/living/carbon/human/unbuckle_mob(mob/living/buckled_mob, force, can_fall)
	var/datum/component/bellyriding/comp = GetComponent(/datum/component/bellyriding) // yeah. this does suck.
	if(force && comp?.current_victim == buckled_mob) // would be better if unbuckle_mob had a pre_unbuckle signal.
		comp.unbuckle_victim(skip_unbuckle = TRUE) // we make do with the tools we have.
	return ..()


/datum/movespeed_modifier/bellyriding_nontaur
	multiplicative_slowdown = 0.8 // completely arbitrary

/datum/action/innate/toggle_bellyriding_heehee_pp
	name = "Toggle Bellyriding Interactions"
	desc = "Toggle whether to actually perform bellyriding interactions on your victim or not."
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "pitchfork"
	active = TRUE

/datum/action/innate/toggle_bellyriding_heehee_pp/Activate()
	var/datum/component/bellyriding/comp = owner.GetComponent(/datum/component/bellyriding)
	comp.enable_interactions = TRUE
	active = TRUE
	build_all_button_icons(UPDATE_BUTTON_BACKGROUND) // why yes this IS necessary

	to_chat(comp.current_victim, span_notice("[owner] repositions you, your rear pressing against [owner.p_their()] eager cock.. Oh no."))
	to_chat(owner, span_notice("You reposition [comp.current_victim] to rest against your eager cock."))

/datum/action/innate/toggle_bellyriding_heehee_pp/Deactivate()
	var/datum/component/bellyriding/comp = owner.GetComponent(/datum/component/bellyriding)
	comp.enable_interactions = FALSE
	active = FALSE
	build_all_button_icons(UPDATE_BUTTON_BACKGROUND)

	to_chat(comp.current_victim, span_notice("[owner] moves you out of [owner.p_their()] cock's way.. relief at last."))
	to_chat(owner, span_notice("You move [comp.current_victim] out of your cock's way.. for now."))

