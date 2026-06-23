/datum/action/cooldown/noclip
	name = "Переключить noclip"
	desc = "При активации позволяет двигаться сквозь твердые обьекты!"
	cooldown_time = 1 SECONDS

	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "blank_white"

	var/enabled = FALSE
	var/initial_pass_flags = NONE
	var/backrooms_wall_phase_chance = 1

/datum/action/cooldown/noclip/IsAvailable(feedback)
	if(owner.stat & DEAD)
		return FALSE
	if(INCAPACITATED_IGNORING(owner, INCAPABLE_GRAB))
		return FALSE
	return ..()

/datum/action/cooldown/noclip/Activate(atom/target)
	. = ..()
	if(enabled)
		disable_noclip()
		return TRUE
	enable_noclip()
	return TRUE

/datum/action/cooldown/noclip/proc/enable_noclip()
	initial_pass_flags = owner.pass_flags
	owner.pass_flags = PASSCLOSEDTURF | PASSTABLE | PASSDOORS | PASSBLOB | PASSGLASS | PASSGRILLE | PASSMOB | PASSSTRUCTURE | PASSVEHICLE | PASSWINDOW | PASSITEM

	owner.add_movespeed_modifier(/datum/movespeed_modifier/noclip)
	owner.visible_message(span_notice("[owner.name], dissolves in air. Becoming non-physical."), span_notice("You going noclip."))

	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(owner_dead), TRUE)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_owner_moved), TRUE)

	button_icon_state = "blank"
	enabled = TRUE
	build_all_button_icons(UPDATE_BUTTON_ICON)

/datum/action/cooldown/noclip/proc/disable_noclip()
	owner.pass_flags = initial_pass_flags

	owner.remove_movespeed_modifier(/datum/movespeed_modifier/noclip)
	owner.visible_message(span_notice("[owner.name], becomes physical again."), span_notice("You back to normal again."))
	UnregisterSignal(owner, list(COMSIG_LIVING_DEATH, COMSIG_MOVABLE_MOVED))

	enabled = FALSE
	button_icon_state = "blank_white"
	build_all_button_icons(UPDATE_BUTTON_ICON)

/datum/action/cooldown/noclip/proc/owner_dead()
	SIGNAL_HANDLER

	if(enabled)
		disable_noclip()
		StartCooldown()

/datum/action/cooldown/noclip/proc/on_owner_moved(atom/movable/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER
	if(!enabled || !owner || QDELETED(owner))
		return
	if(backrooms_wall_phase_chance <= 0)
		return
	if(!owner.client) // только игроки
		return
	if(!isturf(owner.loc) || !isturf(old_loc))
		return


	var/turf/new_turf = owner.loc
	if(!istype(new_turf, /turf/closed) && !new_turf.density)
		return

	if(!prob(backrooms_wall_phase_chance))
		return

	if(!length(GLOB.backrooms_fall_points))
		return
	var/obj/effect/mapping_helpers/backrooms_fall_point/p = pick(GLOB.backrooms_fall_points)
	var/turf/target = get_turf(p)
	if(!target)
		return

	owner.visible_message(
		span_warning("[owner] jitters and disappears into the wall!"),
		span_userdanger("Reality tears for a moment, and you drop through.")
	)
	owner.forceMove(target)

/datum/movespeed_modifier/noclip
	id = "noclip"
	movetypes = GROUND | FLYING
	multiplicative_slowdown = -0.2
