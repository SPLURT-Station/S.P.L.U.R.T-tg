/datum/round_event_control/train_event/nuke_effect
	name = "Nuclear Explosion"
	description = "Creates the effects of a nuclear explosion at a distance from the train"
	category = "Trainstation"
	typepath = /datum/round_event/train_event/nuke

/datum/round_event/train_event/nuke
	announce_when = 10     // Announcement 10 seconds after the event starts
	end_when = 1000        // Duration of the effects (long enough for everything to play out)

/datum/round_event/train_event/nuke/setup()
	. = ..()
	start_when = announce_when + 13  // Main effects begin ~23 seconds after the announcement

/datum/round_event/train_event/nuke/announce(fake)
	priority_announce("Activation of a portable nuclear device detected 15 kilometers from your location. \
						Prepare for the impact of the shockwave!", \
					"NUCLEAR ALERT", 'fenysha_events/sounds/mobs/sirenhead/siren_alarm_air.ogg')

/datum/round_event/train_event/nuke/start()
	INVOKE_ASYNC(src, PROC_REF(caboom))
	addtimer(CALLBACK(src, PROC_REF(run_postnuke)), 38 SECONDS)

/datum/round_event/train_event/nuke/proc/caboom()
	// Bright flash on the horizon
	SSdaylight.flash("#fcc95b", 15 SECONDS, 0.3 SECONDS)
	sleep(0.8 SECONDS)

	flash_peoples()           // Blinding and burns
	sleep(10 SECONDS)
	sound_wave()              // Sound wave + shattered windows
	sleep(1 SECONDS)
	impact_wave()             // Shockwave + shaking

/datum/round_event/train_event/nuke/proc/flash_peoples()
	for(var/mob/living/player in GLOB.alive_player_list)
		if(QDELETED(player))
			continue
		to_chat(player, span_danger("A blinding flash of light from the horizon!"))
		for(var/turf/open/T in view(player, 5))
			var/area/turf_area = get_area(T)
			if(!turf_area.outdoors || !can_see(player, T))
				continue
			flash_and_burn(player, T)
			break

/datum/round_event/train_event/nuke/proc/flash_and_burn(mob/living/target, turf/affect_turf)
	var/flash_result = target.flash_act(4, override_blindness_check = TRUE, affect_silicon = TRUE, length = 5 SECONDS)
	if(flash_result)
		to_chat(target, span_userdanger("An overwhelming flash blinds you!"))
	if(prob(20 * max(1, (5 - get_dist(target, affect_turf)))))
		target.adjust_fire_stacks(rand(3, 4))

/datum/round_event/train_event/nuke/proc/sound_wave()
	sound_to_playing_players('fenysha_events/sounds/thefinalstation/nuke_ex.ogg')
	for(var/mob/living/player in GLOB.alive_player_list)
		if(prob(30))
			player.soundbang_act(SOUNDBANG_STRONG)

		if(QDELETED(player) || !prob(60))
			continue

		for(var/obj/structure/window/window in view(player, 5))
			var/should_brake = FALSE
			for(var/turf/T in orange(1, window))
				var/area/turf_area = get_area(T)
				if(!turf_area.outdoors)
					continue
				should_brake = TRUE
				break
			if(!should_brake)
				continue
			if(prob(40))
				window.take_damage(window.max_integrity * 10)
			else
				window.take_damage(rand(30, 150))
		CHECK_TICK

/datum/round_event/train_event/nuke/proc/impact_wave()
	if(SStrain_controller.is_moving())
		SStrain_controller.stop_moving()
		priority_announce("Attention! Emergency braking activated!", "Train Control", 'sound/effects/alert.ogg')

	for(var/obj/machinery/light/light in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/light))
		if(!is_station_level(light.z))
			continue
		if(prob(30))
			light.break_light_tube()
		else
			light.flicker(rand(3, 8))

	for(var/mob/living/player in GLOB.alive_player_list)
		to_chat(player, span_userdanger("A powerful shockwave crashes into you!"))
		shake_camera(player, 1 SECONDS, 2)
		if(prob(60))
			player.Knockdown(3 SECONDS)


/datum/round_event/train_event/nuke/proc/run_postnuke()
	sound_to_playing_players('fenysha_events/sounds/thefinalstation/post_nuke.ogg')
	addtimer(CALLBACK(src, PROC_REF(start_fallout_and_kill)), rand(30, 60) SECONDS)
	kill()


/datum/round_event/train_event/nuke/proc/start_fallout_and_kill()
	SSweather.run_weather(/datum/weather/nuclear_fallout)


/datum/weather/nuclear_fallout
	name = "Nuclear Fallout"
	desc = "Radioactive fallout following a recent nuclear explosion. The sky is shrouded in gray ash."

	telegraph_message = span_warning("Nuclear fallout is approaching!")
	telegraph_duration = 15 SECONDS

	weather_message = span_danger("Radioactive ash is falling from the sky. Find shelter under a roof!")
	weather_duration_lower = 5 MINUTES
	weather_duration_upper = 15 MINUTES
	weather_overlay = "light_ash"
	weather_color = COLOR_GOLEM_GRAY

	end_message = span_danger("The nuclear fallout has stopped!")
	end_duration = 0 SECONDS

	area_type = /area
	protected_areas = list(/area/space)
	target_trait = ZTRAIT_STATION

	use_glow = FALSE
	weather_flags = (WEATHER_MOBS)

/datum/weather/nuclear_fallout/weather_act_mob(mob/living/victim)
	if(prob(40))
		radiation_pulse(victim, 1, RAD_MEDIUM_INSULATION, 60)
		SEND_SOUND(victim, 'fenysha_events/sounds/rad_counter.ogg')
	return ..()
