/// Footstep element. Plays footsteps at parent's location when it is appropriate.
/// Sound selection is полностью delegated to a callback.
#define FOOTSTEP_CALLBACK_OK 1

/datum/element/footstep_callback
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY|ELEMENT_BESPOKE
	argument_hash_start_idx = 2

	/// A list containing living mobs and the number of steps they have taken since the last time their footsteps were played.
	var/list/steps_for_living = list()

	/// Base volume multiplier.
	var/volume = 0.5

	/// Extra range added to the sound.
	var/e_range = -8

	/// Whether or not to add variation to the sounds played
	var/sound_vary = FALSE

	/// Callback that must return a list of sound file paths.
	/// Signature:
	/// CALLBACK(source, element, prepared_steps, stepcount, direction, forced, momentum_change)
	/// Return value:
	/// - list of sound paths
	/// - or null to suppress the step sound
	var/datum/callback/sound_provider


/datum/element/footstep_callback/Attach(
	datum/target,
	datum/callback/sound_provider,
	volume = 0.5,
	e_range = -8,
	sound_vary = FALSE
)
	. = ..()

	if(!ismovable(target))
		return ELEMENT_INCOMPATIBLE

	if(!sound_provider)
		return ELEMENT_INCOMPATIBLE

	src.sound_provider = sound_provider
	src.volume = volume
	src.e_range = e_range
	src.sound_vary = sound_vary

	if(ishuman(target))
		RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(play_humanstep))
		steps_for_living[target] = 0
	else if(ismob(target))
		RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(play_simplestep))
		steps_for_living[target] = 0
	else
		RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(play_simplestep))

	return


/datum/element/footstep_callback/Detach(atom/movable/source)
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	steps_for_living -= source
	return ..()


/// Calls the provider and validates that it returned a list of sounds.
/datum/element/footstep_callback/proc/resolve_step_sounds(atom/movable/source, list/prepared_steps, direction, forced, momentum_change)
	if(!sound_provider)
		return null

	var/result = sound_provider.Invoke(source, src, prepared_steps, steps_for_living[source], direction, forced, momentum_change)

	if(!islist(result) || !length(result))
		return null

	return result


/// Prepares a footstep for living mobs. Determines if it should get played.
/// Returns the turf it should get played on. Note that it is always a /turf/open
/datum/element/footstep_callback/proc/prepare_step(mob/living/source)
	var/turf/open/turf = get_turf(source)
	if(!istype(turf))
		return

	if(source.buckled || source.throwing || source.movement_type & (VENTCRAWLING | FLYING) || HAS_TRAIT(source, TRAIT_IMMOBILIZED) || CHECK_MOVE_LOOP_FLAGS(source, MOVEMENT_LOOP_OUTSIDE_CONTROL))
		return

	if(source.body_position == LYING_DOWN)
		if(turf.footstep)
			var/sound = 'sound/effects/footstep/crawl1.ogg'
			if(HAS_TRAIT(source, TRAIT_FLOPPING))
				sound = pick(SFX_FISH_PICKUP, 'sound/mobs/non-humanoids/fish/fish_drop1.ogg')
			playsound(turf, sound, 15 * volume, falloff_distance = 1, vary = sound_vary)
		return

	if(iscarbon(source) && source.move_intent == MOVE_INTENT_WALK)
		return // stealth

	steps_for_living[source] += 1
	var/steps = steps_for_living[source]

	if(steps >= 24)
		steps_for_living[source] = 0
		steps = 0

	if(steps % 2)
		return

	if(steps % 6 != 0 && !source.has_gravity())
		return

	var/list/footstep_data = list(
		STEP_SOUND_PRIORITY = STEP_SOUND_NO_PRIORITY,
	)

	var/sigreturn = SEND_SIGNAL(turf, COMSIG_TURF_PREPARE_STEP_SOUND, footstep_data)
	if(sigreturn & FOOTSTEP_OVERRIDEN)
		return footstep_data

	if(isnull(turf.footstep))
		return null

	return footstep_data


/datum/element/footstep_callback/proc/play_simplestep(atom/movable/source, atom/oldloc, direction, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER

	if(source.moving_diagonally == SECOND_DIAG_STEP)
		return // prevent a diagonal step from counting as 2

	if(forced || SHOULD_DISABLE_FOOTSTEPS(source))
		return

	var/list/prepared_steps = null
	if(isliving(source))
		prepared_steps = prepare_step(source)
		if(isnull(prepared_steps))
			return

	var/list/step_sounds = resolve_step_sounds(source, prepared_steps, direction, forced, momentum_change)
	if(isnull(step_sounds))
		return

	var/picked_sound = pick(step_sounds)
	playsound(source.loc, picked_sound, 15 * volume, falloff_distance = 1, vary = sound_vary)


/datum/element/footstep_callback/proc/play_humanstep(mob/living/carbon/human/source, atom/oldloc, direction, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER

	if(source.moving_diagonally == SECOND_DIAG_STEP)
		return // prevent a diagonal step from counting as 2

	if(forced || SHOULD_DISABLE_FOOTSTEPS(source) || !momentum_change)
		return

	var/list/prepared_steps = prepare_step(source)
	if(isnull(prepared_steps))
		return

	var/list/step_sounds = resolve_step_sounds(source, prepared_steps, direction, forced, momentum_change)
	if(isnull(step_sounds))
		return

	// list returned by playsound() filled by client mobs who heard the footstep. given to play_fov_effect()
	var/list/heard_clients

	var/picked_sound = pick(step_sounds)
	var/picked_volume = 15 * volume
	var/picked_range = e_range

	if(HAS_TRAIT(source, TRAIT_LIGHT_STEP))
		picked_volume *= 0.6
		picked_range -= 2

	heard_clients = playsound(
		source = source,
		soundin = picked_sound,
		vol = picked_volume,
		vary = sound_vary,
		extrarange = picked_range,
		falloff_distance = 1,
	)

	if(heard_clients)
		play_fov_effect(source, 5, "footstep", direction, ignore_self = TRUE, override_list = heard_clients)


#undef FOOTSTEP_CALLBACK_OK
