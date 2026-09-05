#define NEXTBOT_BASE_DESPAWN_DIST 30
#define NEXTBOT_REACQUIRE_DIST 8

/atom/movable/screen/fullscreen/nextbot_jumpscare
	icon = 'fenysha_events/icons/fullscreen/fullscreen_nextbot.dmi'
	icon_state = "white_face"
	alpha = 255
	show_when_dead = TRUE

/datum/component/nextbot_target
	VAR_PRIVATE/mob/living/target_mob = null
	VAR_PRIVATE/mob/living/basic/nextbot/active_nextbot = null
	VAR_PRIVATE/image/active_nextbot_image = null
	VAR_PRIVATE/next_spawn_timer = null

	var/randomize_nextbot_type = TRUE

/datum/component/nextbot_target/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	target_mob = parent
	return ..()

/datum/component/nextbot_target/RegisterWithParent()
	. = ..()
	RegisterSignal(target_mob, COMSIG_MOB_UPDATE_SIGHT, PROC_REF(on_update_sight))
	RegisterSignal(target_mob, COMSIG_QDELETING, PROC_REF(on_parent_qdel))
	schedule_next_spawn(initial = TRUE)

/datum/component/nextbot_target/UnregisterFromParent()
	. = ..()
	if(target_mob)
		UnregisterSignal(target_mob, list(COMSIG_MOB_UPDATE_SIGHT, COMSIG_QDELETING))
	cleanup_nextbot()
	if(next_spawn_timer)
		deltimer(next_spawn_timer)
		next_spawn_timer = null
	target_mob = null

/datum/component/nextbot_target/proc/on_parent_qdel()
	SIGNAL_HANDLER
	qdel(src)

/datum/component/nextbot_target/proc/on_update_sight(mob/source)
	SIGNAL_HANDLER
	if(!target_mob || source != target_mob || !target_mob.client)
		return
	target_mob.set_invis_see(initial(target_mob.see_invisible))
	target_mob.set_sight(initial(target_mob.sight))
	target_mob.lighting_cutoff = initial(target_mob.lighting_cutoff)
	target_mob.lighting_color_cutoffs = list(initial(target_mob.lighting_cutoff_red), initial(target_mob.lighting_cutoff_green), initial(target_mob.lighting_cutoff_blue))

/datum/component/nextbot_target/proc/schedule_next_spawn(initial = FALSE)
	if(!target_mob || QDELETED(target_mob))
		return
	if(next_spawn_timer)
		deltimer(next_spawn_timer)
	next_spawn_timer = addtimer(CALLBACK(src, PROC_REF(spawn_nextbot)), initial ? 1 MINUTES : rand(2 MINUTES, 6 MINUTES), TIMER_STOPPABLE)

/datum/component/nextbot_target/proc/schedule_quick_respawn()
	if(!target_mob || QDELETED(target_mob))
		return
	if(next_spawn_timer)
		deltimer(next_spawn_timer)
	next_spawn_timer = addtimer(CALLBACK(src, PROC_REF(spawn_nextbot)), rand(30 SECONDS, 90 SECONDS), TIMER_STOPPABLE)

/datum/component/nextbot_target/proc/cleanup_nextbot()
	if(active_nextbot && !QDELETED(active_nextbot))
		UnregisterSignal(active_nextbot, COMSIG_QDELETING)
	if(active_nextbot_image && target_mob?.client)
		target_mob.client.images -= active_nextbot_image
	active_nextbot_image = null
	active_nextbot = null

/datum/component/nextbot_target/proc/on_nextbot_qdel(datum/source)
	SIGNAL_HANDLER

	cleanup_nextbot()
	schedule_quick_respawn()

/datum/component/nextbot_target/proc/spawn_nextbot()
	next_spawn_timer = null
	if(!target_mob || QDELETED(target_mob) || !target_mob.client)
		schedule_next_spawn()
		return

	if(active_nextbot && !QDELETED(active_nextbot))
		schedule_next_spawn()
		return

	var/turf/target_turf = get_turf(target_mob)
	if(!target_turf)
		schedule_next_spawn()
		return

	var/turf/spawn_turf = null
	for(var/i in 1 to 12)
		var/r = rand(8, 14)
		spawn_turf = locate(
			clamp(target_turf.x + rand(-r, r), 1, world.maxx),
			clamp(target_turf.y + rand(-r, r), 1, world.maxy),
			target_turf.z
		)
		if(isturf(spawn_turf) && spawn_turf != target_turf)
			break

	if(!isturf(spawn_turf))
		spawn_turf = target_turf

	var/nextbot_type = /mob/living/basic/nextbot
	if(randomize_nextbot_type)
		var/list/pool = subtypesof(/mob/living/basic/nextbot)
		if(length(pool))
			nextbot_type = pick(pool)
	active_nextbot = new nextbot_type(spawn_turf)
	active_nextbot.assign_target(target_mob, src)
	RegisterSignal(active_nextbot, COMSIG_QDELETING, PROC_REF(on_nextbot_qdel))

	active_nextbot_image = image(active_nextbot.icon, active_nextbot, active_nextbot.icon_state, MOB_LAYER)
	active_nextbot_image.override = TRUE
	active_nextbot_image.name = active_nextbot.name

	target_mob.client.images |= active_nextbot_image
	schedule_next_spawn()

/mob/living/basic/nextbot
	name = "nextbot"
	desc = "Something wasn't supposed to end up here."
	icon = 'fenysha_events/icons/mob/nextbot.dmi'

	invisibility = INVISIBILITY_OBSERVER


	density = FALSE
	anchored = FALSE
	movement_type = PHASING | FLYING
	pass_flags = PASSTABLE


	animate_movement = NO_STEPS

	health = 999
	maxHealth = 999

	pixel_x = -48
	pixel_y = -48
	base_pixel_x = -48
	base_pixel_y = -48

	VAR_PRIVATE/mob/living/target_mob = null
	VAR_PRIVATE/datum/component/nextbot_target/owner_component = null

	var/base_speed = 0.14
	var/burst_speed = 0.24
	VAR_PRIVATE/burst_ends_at = 0
	VAR_PRIVATE/perforrming_jumpscare = FALSE
	VAR_PRIVATE/datum/vector/movement_vector = null
	VAR_PRIVATE/last_move_time = 0
	VAR_PRIVATE/overrun = 0

	COOLDOWN_DECLARE(nextbot_scream_cd)
	COOLDOWN_DECLARE(nextbot_jumpscare_cd)
	var/scream_sound = 'fenysha_events/sounds/mobs/nextbot/nextbot_scream.mp3'
	var/jumpscare_sound = 'fenysha_events/sounds/mobs/nextbot/nextbot_jumpscare.mp3'
	var/jumpscare_fullscreen_time = 2 SECONDS

/mob/living/basic/nextbot/Initialize(mapload)
	. = ..()
	last_move_time = world.time
	START_PROCESSING(SSprojectiles, src)

/mob/living/basic/nextbot/Destroy()
	STOP_PROCESSING(SSprojectiles, src)
	QDEL_NULL(movement_vector)
	target_mob = null
	owner_component = null
	return ..()

/mob/living/basic/nextbot/proc/assign_target(mob/living/new_target, datum/component/nextbot_target/owner)
	target_mob = new_target
	owner_component = owner

	recompute_vector()

/mob/living/basic/nextbot/proc/recompute_vector()
	if(!target_mob || QDELETED(target_mob))
		return
	var/datum/point/from = RETURN_PRECISE_POINT(src)
	var/datum/point/destination = RETURN_PRECISE_POINT(target_mob)
	var/new_angle = angle_between_points(from, destination)
	var/current_speed = (world.time < burst_ends_at) ? burst_speed : base_speed
	if(!movement_vector)
		movement_vector = new(current_speed, new_angle)
	else
		movement_vector.set_speed(current_speed)
		movement_vector.set_angle(new_angle)

/mob/living/basic/nextbot/proc/try_burst()
	if(world.time < burst_ends_at)
		return

	if(prob(6))
		burst_ends_at = world.time + 2 SECONDS

/mob/living/basic/nextbot/process()
	if(!loc || !isturf(loc) || perforrming_jumpscare)
		return PROCESS_KILL
	if(!target_mob || QDELETED(target_mob))
		qdel(src)
		return PROCESS_KILL

	if(get_dist(src, target_mob) > NEXTBOT_BASE_DESPAWN_DIST)
		qdel(src)
		return PROCESS_KILL

	if(get_dist(src, target_mob) <= 1)
		perforrming_jumpscare = TRUE
		trigger_jumpscare()
		qdel(src)
		return PROCESS_KILL

	try_burst()
	recompute_vector()

	var/elapsed = world.time - last_move_time
	last_move_time = world.time
	var/pixels_to_move = elapsed * SSprojectiles.pixels_per_decisecond * movement_vector.magnitude + overrun
	overrun = 0
	overrun += MODULUS(pixels_to_move, 1)
	pixels_to_move = FLOOR(pixels_to_move, 1)
	if(pixels_to_move <= 0)
		return

	process_movement(pixels_to_move)
	process_scream()

/mob/living/basic/nextbot/proc/process_scream()
	if(!COOLDOWN_FINISHED(src, nextbot_scream_cd))
		return
	var/cdtime = SSsounds.get_sound_length(scream_sound)
	COOLDOWN_START(src, nextbot_scream_cd, cdtime)

	if(!target_mob?.client)
		return
	var/d = get_dist(src, target_mob)
	var/vol = clamp(round(100 - (d * 6)), 5, 100)
	SEND_SOUND(target_mob, sound(scream_sound, volume = vol))

/mob/living/basic/nextbot/proc/trigger_jumpscare()
	if(!target_mob?.client)
		return
	if(!COOLDOWN_FINISHED(src, nextbot_jumpscare_cd))
		return
	COOLDOWN_START(src, nextbot_jumpscare_cd, 2 SECONDS)

	var/atom/movable/screen/fullscreen/jumpscare = target_mob.overlay_fullscreen("nextbot_jumpscare", /atom/movable/screen/fullscreen/nextbot_jumpscare, 0)
	jumpscare.icon_state = icon_state
	addtimer(CALLBACK(target_mob, TYPE_PROC_REF(/mob, clear_fullscreen), "nextbot_jumpscare", 0), jumpscare_fullscreen_time)
	SEND_SOUND(target_mob, sound(jumpscare_sound, volume = 100))


/mob/living/basic/nextbot/proc/process_movement(pixels_to_move)
	if(!isturf(loc) || !movement_vector)
		return

	var/total_move_distance = pixels_to_move
	while(pixels_to_move > 0 && isturf(loc) && !QDELETED(src))
		var/pixel_x_actual = pixel_x + ICON_SIZE_X / 2
		if(pixel_x_actual > ICON_SIZE_X)
			pixel_x_actual = pixel_x_actual % ICON_SIZE_X

		var/pixel_y_actual = pixel_y + ICON_SIZE_Y / 2
		if(pixel_y_actual > ICON_SIZE_Y)
			pixel_y_actual = pixel_y_actual % ICON_SIZE_Y

		var/distance_to_border = INFINITY
		var/x_to_border = INFINITY
		var/y_to_border = INFINITY

		if(movement_vector.pixel_x)
			var/x_border_dist = -pixel_x_actual
			if(movement_vector.pixel_x > 0)
				x_border_dist = ICON_SIZE_X - pixel_x_actual
			x_to_border = x_border_dist / movement_vector.pixel_x
			distance_to_border = x_to_border

		if(movement_vector.pixel_y)
			var/y_border_dist = -pixel_y_actual
			if(movement_vector.pixel_y > 0)
				y_border_dist = ICON_SIZE_Y - pixel_y_actual
			y_to_border = y_border_dist / movement_vector.pixel_y
			distance_to_border = min(distance_to_border, y_to_border)

		if(distance_to_border == INFINITY)
			return

		var/distance_to_move = min(distance_to_border, pixels_to_move)

		var/x_shift = distance_to_move >= x_to_border ? SIGN(movement_vector.pixel_x) : 0
		var/y_shift = distance_to_move >= y_to_border ? SIGN(movement_vector.pixel_y) : 0
		var/moving_turfs = x_shift || y_shift

		var/entry_x = pixel_x + movement_vector.pixel_x * distance_to_move - x_shift * ICON_SIZE_X
		var/entry_y = pixel_y + movement_vector.pixel_y * distance_to_move - y_shift * ICON_SIZE_Y

		if(moving_turfs)
			var/turf/new_turf = locate(x + x_shift, y + y_shift, z)
			if(!istype(new_turf))
				return
			step_towards(src, new_turf)
			if(QDELETED(src) || loc != new_turf)
				moving_turfs = FALSE

		pixels_to_move -= distance_to_move

		pixel_x -= x_shift * ICON_SIZE_X
		pixel_y -= y_shift * ICON_SIZE_Y

		animate(src, pixel_x = entry_x, pixel_y = entry_y, time = world.tick_lag * distance_to_move / total_move_distance, flags = ANIMATION_PARALLEL | ANIMATION_CONTINUE)

		if(TICK_CHECK)
			overrun += pixels_to_move
			return

/mob/living/basic/nextbot/white_face
	icon_state = "white_face"

/mob/living/basic/nextbot/black_face
	icon_state = "black_face"

/mob/living/basic/nextbot/long_neck
	icon_state = "long_neck"
