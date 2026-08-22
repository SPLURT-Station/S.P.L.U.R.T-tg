/atom/proc/attempt_moving_turf_step(turf/mover, direction)
	return TRUE

/atom/movable/attempt_moving_turf_step(turf/mover, direction)
	if(movement_type & FLYING || movement_type & PHASING)
		return FALSE
	return TRUE


/turf/open/moving
	name = "Matrix"
	desc = "You probably shouldn't see this"
	icon = 'fenysha_events/icons/turf/trainturf.dmi'
	turf_flags = NO_RUST | IS_SOLID | NOJAUNT
	gender = PLURAL
	tiled_turf = TRUE
	planetary_atmos = TRUE
	rust_resistance = RUST_RESISTANCE_ABSOLUTE

	// Prefixes for icon_state (turf animation)
	var/moving_prefix = "moving"
	var/still_prefix = "still"
	var/fake = FALSE

	// Whether we are moving right now (synchronized by the controller)
	VAR_FINAL/moving = FALSE
	// Direction of the background movement simulation (WEST = train "drives" EAST)
	VAR_FINAL/movement_direction = WEST
	// Whether the turf contents are currently being processed
	VAR_PRIVATE/processing_content = FALSE

/turf/open/moving/Initialize(mapload)
	. = ..()
	SSmoving_turfs.register(src)
	if(SStrain_controller.is_moving())
		check_process(TRUE)
	update_appearance()

/turf/open/moving/Destroy()
	SSmoving_turfs.unregister(src)
	return ..()

/turf/open/moving/Melt()
	to_be_destroyed = FALSE
	return src

/turf/open/moving/singularity_act()
	return

/turf/open/moving/TerraformTurf(path, new_baseturf, flags)
	return

/turf/open/moving/ex_act(severity, target)
	return

/turf/open/moving/Enter(atom/movable/mover)
	. = ..()
	if(fake)
		return
	if(!moving)
		return
	if(QDELETED(mover) || isobserver(mover) || mover.flags_1 & NO_TURF_MOVEMENT_1)
		return
	SSmoving_turfs.queue_process(src)

/turf/open/moving/Exit(atom/movable/mover, atom/newloc)
	. = ..()
	if(fake)
		return
	if(!check_process(TRUE))
		SSmoving_turfs.unqueue_process(src)

/turf/open/moving/proc/check_process(register = TRUE)
	if(!length(contents) || fake)
		return FALSE
	for(var/atom/movable/AM in contents)
		if(QDELETED(AM) || isobserver(AM) || AM.flags_1 & NO_TURF_MOVEMENT_1)
			continue
		if(register)
			SSmoving_turfs.queue_process(src)
		return TRUE
	return FALSE

/turf/open/moving/proc/process_contents(seconds_per_tick)
	if(!moving || !length(contents) || processing_content)
		return
	processing_content = TRUE
	for(var/atom/movable/AM as anything in contents)
		if(QDELETED(AM) || isobserver(AM) || AM.flags_1 & NO_TURF_MOVEMENT_1 || !AM.attempt_moving_turf_step(src, movement_direction))
			continue
		move_object(AM)
	processing_content = FALSE
	if(!check_process(FALSE))
		SSmoving_turfs.unqueue_process(src)

/turf/open/moving/proc/move_object(atom/movable/ram)
	if(QDELETED(ram))
		return

	var/turf/current = ram.loc
	var/turf/target = get_step(current, movement_direction)

	if(!target)
		if(isliving(ram) && !HAS_TRAIT(ram, TRAIT_GODMODE))
			var/mob/living/L = ram
			L.adjust_brute_loss(50)
			L.throw_at(get_step(current, movement_direction), 1, 2)
			if(L.stat == DEAD)
				L.gib()
		else
			POOL_ASYNC_RELEASE(ram)
		return

	if(target.density)
		if(isliving(ram) && !HAS_TRAIT(ram, TRAIT_GODMODE))
			var/mob/living/L = ram
			L.adjust_brute_loss(50)
			L.throw_at(get_step(current, movement_direction), 1, 2)
			if(L.stat == DEAD && isclosedturf(target))
				L.gib()
		else
			POOL_ASYNC_RELEASE(ram)
		return


	var/atom/movable/blocker = null
	for(var/atom/movable/AM as anything in target.contents)
		if(AM == ram || !AM.density || ismob(AM))
			continue
		if(ram.CanPass(AM, movement_direction) || AM.CanPass(ram, turn(movement_direction, 180)))
			continue
		blocker = AM
		break

	if(blocker)
		if(isobj(blocker))
			var/obj/O = blocker
			O.take_damage(15, BRUTE)
		else if(isliving(blocker))
			var/mob/living/L = blocker
			L.adjust_brute_loss(50)

		if(QDELETED(blocker) || !blocker.density || blocker.loc != target)
			ASYNC
				move_and_bump(target, ram)
			return
	else
		ASYNC
			move_and_bump(target, ram)
		return

/turf/open/moving/proc/move_and_bump(turf/target, atom/movable/AM)
	AM.Move(target, SStrain_controller.abstract_moving_direction)

/turf/open/moving/update_appearance(updates)
	. = ..()
	var/prefix = moving ? moving_prefix : still_prefix
	icon_state = "[base_icon_state]_[prefix]"


/turf/open/moving/auto_rail
	name = "Rail scheme"
	desc = "Helper to plan how rails will be in game"

	var/rail_role
	icon = 'fenysha_events/icons/turf/rail_scheme.dmi'

/turf/open/moving/auto_rail/Initialize(mapload)
	. = ..()
	if(!rail_role)
		return

	if(!SStrain_controller || !SStrain_controller.transition_theme)
		reset_to_default()
		return
	var/list/rail_theme = SStrain_controller?.transition_theme.rail_theme
	if(!rail_theme)
		reset_to_default()
		return

	var/list/options = rail_theme[rail_role]
	SStrain_controller.transition_theme.apply_to_rail(src, options)


/turf/open/moving/auto_rail/proc/reset_to_default()
	src.icon = 'fenysha_events/icons/turf/moving/rails/rails_default.dmi'

	update_icon()
	update_icon_state()
	update_appearance()


/turf/open/moving/auto_rail/proc/change_me(icon)
	src.icon = icon

	update_icon()
	update_icon_state()
	update_appearance()

/turf/open/moving/auto_rail/update_appearance(updates)
	. = ..()
	var/prefix = moving ? moving_prefix : still_prefix
	icon_state = "[rail_role]_[prefix]"

/turf/open/moving/auto_rail/rail
	rail_role = RAIL_ROLE_RAIL
	icon_state = RAIL_ROLE_RAIL

/turf/open/moving/auto_rail/top_connector
	rail_role = RAIL_ROLE_TOP_CONNECTOR
	icon_state = RAIL_ROLE_TOP_CONNECTOR

/turf/open/moving/auto_rail/top_corner
	rail_role = RAIL_ROLE_TOP_CORNER
	icon_state = RAIL_ROLE_TOP_CORNER

/turf/open/moving/auto_rail/filler
	rail_role = RAIL_ROLE_FILLER
	icon_state = RAIL_ROLE_FILLER

/turf/open/moving/auto_rail/bottom_corner
	rail_role = RAIL_ROLE_BOTTOM_CORNER
	icon_state = RAIL_ROLE_BOTTOM_CORNER

/turf/open/moving/auto_rail/bottom_connector
	rail_role = RAIL_ROLE_BOTTOM_CONNECTOR
	icon_state = RAIL_ROLE_BOTTOM_CONNECTOR


/turf/open/moving/snow
	name = "Snow"
	desc = "It looks cold"
	icon_state = "snow_still"
	base_icon_state = "snow"

	slowdown = 2

/turf/open/moving/snow/fake
	fake = TRUE

/turf/open/moving/snow/fake/dense
	density = TRUE


/turf/open/indestructible/train_platform
	name = "Platform"
	desc = "Railway station platform."
	icon = 'fenysha_events/icons/turf/trainturf.dmi'
	icon_state = "platform_middle_still"

/turf/open/indestructible/train_platform/bottom
	icon_state = "platform_bottom_still"

/turf/open/indestructible/train_platform/top
	icon_state = "platform_top_still"
