/datum/component/bellyriding
	var/mob/living/carbon/human/current_victim = null
	var/datum/interaction/last_interaction = null

/datum/component/bellyriding/Initialize(atom/movable/buckle_relay)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	if(!istype(buckle_relay))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/carbon/human/parent = src.parent

	taur_parent = parent.get_taur_mode() in list(STYLE_TAUR_HOOF, STYLE_TAUR_PAW)

	RegisterSignal(buckle_relay, COMSIG_MOUSEDROPPED_ONTO, PROC_REF(on_mousedropped_onto))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_step))

/datum/component/bellyriding/proc/on_mousedropped_onto(mob/living/carbon/human/victim, atom/over_object, mob/user)
	SIGNAL_HANDLER

	ASYNC try_buckle_victim(victim, user)

/datum/component/bellyriding/proc/on_step(datum/_source, old_loc, movement_dir, forced, old_locs, momentum_change)
	SIGNAL_HANDLER

	if(isnull(current_victim))
		return

	update_visuals()
	heehoo_pp()

#define BELLYRIDING_SOURCE "bellyriding source. i mean no one can check these anyways no? i could write anything here. avali are cool. go play them."
/datum/component/bellyriding/proc/update_visuals()
	var/mob/living/carbon/human/parent = src.parent
	if(current_victim.dir != parent.dir)
		current_victim.setDir(dir)


	var/datum/sprite_accessory/taur/taur_accessory
	var/taur_mutant_bodypart = parent.dna.species.mutant_bodyparts[FEATURE_TAUR]
	if(taur_mutant_bodypart)
		var/bodypart_name = taur_mutant_bodypart[MUTANT_INDEX_NAME]
		var/datum/sprite_accessory/taur/potential_accessory = SSaccessories.sprite_accessories[FEATURE_TAUR][bodypart_name]
		if(potential_accessory?.taur_mode in list(STYLE_TAUR_HOOF, STYLE_TAUR_PAW))
			taur_accessory = potential_accessory

	// reset any potential stupids
	var/matrix/final_transform = matrix()

	var/x_offset = parent.pixel_x + parent.pixel_w
	var/y_offset = parent.pixel_y + parent.pixel_z
	var/layer = parent.layer - 0.001 // arbitrary
	if(taur_accessory)
		var/counter_clockwise = current_victim.dir == WEST
		final_transform.Turn(counter_clockwise ? -80 : 80)
		y_offset + taur_accessory




	laydown_offset
	var/x_offset = GET_X_OFFSET(diroffsets)
	var/y_offset = GET_Y_OFFSET(diroffsets)
	var/layer = GET_LAYER(diroffsets, rider.layer)

	// if they are intended to be buckled, offset their existing offset
	var/atom/movable/seat = parent
	if(seat.buckle_lying && rider.body_position == LYING_DOWN)
		y_offset += (-1 * PIXEL_Y_OFFSET_LYING)

	// Rider uses pixel_z offsets as they're above the turf, not up north on the turf
	rider.add_offsets(RIDING_SOURCE, x_add = x_offset, z_add = y_offset, animate = animate)
	rider.layer = layer
#undef BELLYRIDING_SOURCE

/datum/component/bellyriding/proc/heehoo_pp()
	if(!prob(25))
		return

	var/datum/interaction/current_interaction = last_interaction
	if(isnull(current_interaction) || !current_interaction.allow_act(parent, current_victim))
		// pick a new interaction
		current_interaction = null
		for(var/datum/interaction/candidate in shuffle(SSinteractions.interactions))
			if(!candidate.allow_act(parent, current_victim))
				continue

			current_interaction = candidate
			break

		if(isnull(current_interaction))
			return // no valid interaction, why are we even here

	ASYNC current_interaction.act(parent, current_victim)




/datum/component/bellyriding/proc/try_buckle_victim(mob/living/carbon/human/victim, mob/user)
	set waitfor = FALSE

	var/atom/movable/parent = src.parent
	if(!can_buckle(victim, user))
		return

	// ok lets do some stupids here.. we're relying on native buckling behaviour
	// but if we dont do some tweaking it'll fuck over fireman carry/any other buckles
	parent.max_buckled_mobs += 1 // add a slot for us
	if(!parent.user_buckle_mob(victim, user))
		parent.max_buckled_mobs -= 1 // remove said slot
		return
	if(!can_buckle(victim, user))
		// FUCK
		parent.unbuckle_mob(victim)
		parent.max_buckled_mobs -= 1
		return

	current_victim = victim


/datum/component/bellyriding/proc/unbuckle_victim(mob/user)
	if(isnull(current_victim))
		return

	var/atom/movable/parent = src.parent
	parent.unbuckle_mob(current_victim)
	parent.max_buckled_mobs -= 1


/datum/component/bellyriding/proc/can_buckle(mob/living/carbon/human/victim, mob/user)
	if(!istype(victim) || DOING_INTERACTION_WITH_TARGET(user, parent))
		return FALSE
	if(current_victim)
		to_chat(user, span_warning("There's someone already strapped to your belly!"))
		return FALSE
	return TRUE

