/// Default amount of drift force to apply when flying
#define DEFAULT_FUNCTIONAL_FORCE 1 NEWTONS // Equal to moth wings
/// Default minimum air pressure to allow movement
#define DEFAULT_MIN_PRESSURE 86 // Roughly equal to moth wings

/**
 * Flutter movement element
 *
 * A mob with this element can move normally in pressurized zero-gravity environments.
 * Uses the same drift-input hooks as /datum/component/jetpack (moth wings).
 */
/datum/element/flutter_move
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH_ON_HOST_DESTROY
	argument_hash_start_idx = 2

	/// Amount of drift force to apply when flying
	var/functional_force = DEFAULT_FUNCTIONAL_FORCE

	/// Minimum air pressure to allow movement
	var/min_pressure = DEFAULT_MIN_PRESSURE

/datum/element/flutter_move/Attach(datum/target, input_force, input_pressure)
	. = ..()

	// Check for living target
	if (!isliving(target))
		return ELEMENT_INCOMPATIBLE

	// Set functional force
	if(input_force)
		functional_force = input_force

	// Set minimum pressure
	if(input_pressure)
		min_pressure = input_pressure

	var/mob/living/flyer = target
	// Match jetpack: lower multiplier = faster drifting under this force
	flyer.inertia_move_multiplier_active /= functional_force

	RegisterSignal(flyer, COMSIG_MOVABLE_DRIFT_BLOCK_INPUT, PROC_REF(on_input_block))
	RegisterSignal(flyer, COMSIG_MOB_ATTEMPT_HALT_SPACEMOVE, PROC_REF(on_pushoff))
	RegisterSignal(flyer, COMSIG_MOVABLE_SPACEMOVE, PROC_REF(on_spacemove))

/datum/element/flutter_move/Detach(datum/source)
	var/mob/living/flyer = source
	flyer.inertia_move_multiplier_active *= functional_force
	UnregisterSignal(flyer, list(
		COMSIG_MOVABLE_DRIFT_BLOCK_INPUT,
		COMSIG_MOB_ATTEMPT_HALT_SPACEMOVE,
		COMSIG_MOVABLE_SPACEMOVE,
	))
	return ..()

/// Check if this mob should be allowed to flutter
/datum/element/flutter_move/proc/can_fly(mob/living/source)
	if(source.pulledby)
		return FALSE

	if(source.throwing)
		return FALSE

	var/turf/current_turf = get_turf(source)
	if(!current_turf)
		return FALSE

	var/datum/gas_mixture/environment = current_turf.return_air()
	if(environment?.return_pressure() < min_pressure)
		return FALSE

	return TRUE

/datum/element/flutter_move/proc/should_trigger(mob/living/source)
	if(!source?.client)
		return FALSE
	if(!isturf(source.loc))
		return FALSE
	if(!(source.movement_type & FLOATING) || source.buckled)
		return FALSE
	return can_fly(source)

/datum/element/flutter_move/proc/on_input_block(mob/living/source)
	SIGNAL_HANDLER

	if(!should_trigger(source))
		return NONE

	return DRIFT_ALLOW_INPUT

/datum/element/flutter_move/proc/on_pushoff(mob/living/source, movement_dir, continuous_move, atom/backup)
	SIGNAL_HANDLER

	if(get_dir(source, backup) == movement_dir || source.loc == backup.loc)
		return NONE

	if(!source.client?.intended_direction || source.client.intended_direction == get_dir(source, backup))
		return NONE

	if(isnull(source.drift_handler))
		return NONE

	if(!should_trigger(source))
		return NONE

	return COMPONENT_PREVENT_SPACEMOVE_HALT

/// stabilize = FALSE: only cancel idle spacemove when the player is actively trying to move
/datum/element/flutter_move/proc/on_spacemove(mob/living/source, movement_dir, continuous_move, backup)
	SIGNAL_HANDLER

	if((!continuous_move && movement_dir) && should_trigger(source))
		return COMSIG_MOVABLE_STOP_SPACEMOVE

	return NONE

#undef DEFAULT_FUNCTIONAL_FORCE
#undef DEFAULT_MIN_PRESSURE
