/obj/effect/mapping_helpers/wall_generator
	name = "Wall placer"

	icon = 'modular_zzplurt/icons/effects/backrooms.dmi'
	icon_state = "wallgen"
	late = TRUE
	alpha = 255
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	var/wall_type = /turf/closed/indestructible/backrooms
	var/floor_type = /turf/open/indestructible/backrooms


	var/time_before_deploy = 30 SECONDS

	var/time_before_remove = 5 MINUTES


	// Is this trap armed and ready to place wall under it
	var/armed = FALSE
	// Timer for deploying the wall
	var/deploy_timer = null
	// Timer for removing the wall
	var/remove_timer = null

	var/deployed = FALSE

	// Adjacent trap that controls state of entire group
	var/obj/effect/mapping_helpers/wall_generator/remote_control = null

	// Group of wall generators that are linked together to deploy walls at the same time
	var/list/group = list()

	var/turf/our_turf = null


/obj/effect/mapping_helpers/wall_generator/LateInitialize()
	if(!group)
		find_or_create_group()
	subscribe_to_turf(get_turf(src))

/obj/effect/mapping_helpers/wall_generator/proc/find_or_create_group()
	if(remote_control && remote_control != src && remote_control.group)
		return remote_control.group

	if(group)
		return group

	var/list/our_group = list(src)
	for(var/obj/effect/mapping_helpers/wall_generator/other in oview(src, 1))
		if(other != src)
			other.join_to_group(src)

	group = our_group
	return group

/obj/effect/mapping_helpers/wall_generator/proc/join_to_group(obj/effect/mapping_helpers/wall_generator/previous)
	if(previous.group)
		group = previous.group

	group += src
	remote_control = previous
	for(var/obj/effect/mapping_helpers/wall_generator/other in oview(src, 1))
		if(other != src && other != previous)
			other.join_to_group(src)


/obj/effect/mapping_helpers/wall_generator/proc/subscribe_to_turf(turf/T)
	if(!T)
		return
	T = get_turf(src)
	if(T == our_turf)
		return
	if(QDELETED(T))
		return

	if(our_turf)
		UnregisterSignal(our_turf, list(COMSIG_TURF_CHANGE, COMSIG_ATOM_ENTERED))
	RegisterSignal(T, COMSIG_TURF_CHANGE, PROC_REF(on_our_turf_change))
	RegisterSignal(T, COMSIG_ATOM_ENTERED, PROC_REF(on_atom_entered))
	our_turf = T

/obj/effect/mapping_helpers/wall_generator/proc/on_our_turf_change()
	addtimer(CALLBACK(src, PROC_REF(subscribe_to_turf)), 1)

/obj/effect/mapping_helpers/wall_generator/proc/on_atom_entered(turf/T, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	if(QDELETED(arrived))
		return
	if(!isliving(arrived))
		return
	if(armed || deployed)
		return
	if(!group)
		return
	arm_group()

/obj/effect/mapping_helpers/wall_generator/proc/arm_group()
	for(var/obj/effect/mapping_helpers/wall_generator/other in group)
		if(other && !QDELETED(other))
			other.armed = TRUE
	addtimer(CALLBACK(src, PROC_REF(deploy_group)), time_before_deploy)

/obj/effect/mapping_helpers/wall_generator/proc/deploy_group()
	for(var/obj/effect/mapping_helpers/wall_generator/other in group)
		if(other && !QDELETED(other))
			other.deploy_wall()

/obj/effect/mapping_helpers/wall_generator/proc/deploy_wall()
	if(!our_turf)
		return
	if(QDELETED(our_turf))
		return
	if(our_turf.type == wall_type)
		return
	for(var/mob/living/L in view(8, src))
		if(L && !QDELETED(L) && L.stat != DEAD)
			addtimer(CALLBACK(src, PROC_REF(deploy_wall)), 1 SECONDS)
			return
	our_turf.ChangeTurf(wall_type)
	deployed = TRUE
	addtimer(CALLBACK(src, PROC_REF(remove_wall)), time_before_remove)

/obj/effect/mapping_helpers/wall_generator/proc/remove_wall()
	if(!our_turf)
		return
	if(QDELETED(our_turf))
		return
	if(our_turf.type == floor_type)
		return
	deployed = FALSE
	armed = FALSE
	our_turf.ChangeTurf(floor_type)

