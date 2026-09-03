// One shared, smoothly-animated "daylight source" object publishes its colour+alpha as a render target. Every
// turf in a daylight area carries a cheap overlay that render_source-mirrors that target onto the lighting plane
// (BLEND_ADD). So the daylight light lives ON the turfs (world-space, spatially correct), driven by a single
// animated object - smooth and cheap. This is the engine's starlight pattern (see /obj/starlight_appearance), and
// it sidesteps masking entirely: a fullscreen wash can't be clipped by geometry, but per-turf overlays simply
// aren't there indoors.
#define DAYLIGHT_WASH_RENDER_TARGET "*DAYLIGHT_WASH"

// Anchor plane: a plane master that draws nothing - its only job is to put the shared daylight source onto each
// viewer's screen, so the source renders and publishes its render target per-client.
#define RENDER_PLANE_DAYLIGHT 18

/area
	var/daylight = FALSE
	var/has_virtual_lighting = FALSE
	/// Whether we've added the daylight light overlay to this area's turfs (daylight areas only).
	var/daylight_lit = FALSE
	/// Indoor turfs (in other areas) we've feathered daylight onto -> the overlay used on them, for cleanup.
	var/list/daylight_leaked

/area/Initialize(mapload)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(initialize_daylight), mapload)

/area/Destroy()
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(remove_daylight))


/turf/AfterChange(flags, oldType)
	. = ..()
	INVOKE_ASYNC(SSdaylight, TYPE_PROC_REF(/datum/controller/subsystem/daylight, refresh_turf_daylight), src)

/area/proc/clear_virtual_lighting()
	if(!has_virtual_lighting)
		return
	set_virtual_lighting(0)
	has_virtual_lighting = FALSE

/area/proc/update_virtual_lighting(intensity = 1)
	if(!has_virtual_lighting)
		add_virtual_lighting(intensity)
		return
	set_virtual_lighting(intensity)

/area/proc/add_virtual_lighting(intensity = 1)
	set_virtual_lighting(intensity)
	area_has_base_lighting = TRUE
	has_virtual_lighting = TRUE

/area/proc/set_virtual_lighting(intensity = 1)
	var/list/z_offsets = SSmapping.z_level_to_plane_offset
	for (var/area_zlevel in 1 to get_highest_zlevel())
		if(z_offsets[area_zlevel])
			for(var/turf/area_turf as anything in get_turfs_by_zlevel(area_zlevel))
				area_turf.luminosity = intensity

/area/proc/initialize_daylight(mapload = FALSE)
	if(daylight)
		SSdaylight.daylight_areas += src
		SSdaylight.update_area(src)
		// At roundstart, areas init before SSdaylight runs its central lighting pass, so defer to that. Anything
		// loaded AFTER that pass (runtime map templates, code-spawned areas) lights itself immediately.
		if(!mapload || SSdaylight.setup_complete)
			apply_daylight_overlay()

/area/proc/remove_daylight()
	if(daylight)
		SSdaylight.daylight_areas -= src
	clear_daylight_overlay()
	clear_virtual_lighting()

/// Shared overlay that mirrors the single daylight source (via render_source) onto the lighting plane, additively.
/// Because it's a render_source mirror, animating that one source updates the daylight on every turf at once.
/// `strength` (0-255) scales it: 255 on full daylight turfs, less on the leak rings that feather into indoors.
/// Cached per strength so add_overlay/cut_overlay always match.
/proc/get_daylight_overlay_appearance(strength = 255)
	var/static/list/cached = list()
	var/cache_key = "[strength]"
	. = cached[cache_key]
	if(.)
		return
	var/mutable_appearance/light = new /mutable_appearance()
	light.plane = LIGHTING_PLANE
	light.layer = LIGHTING_PRIMARY_LAYER
	light.blend_mode = BLEND_ADD
	light.render_source = DAYLIGHT_WASH_RENDER_TARGET
	light.alpha = strength
	cached[cache_key] = light
	return light

/// Adds the daylight light overlay to every turf in this area, then feathers it a little into adjacent indoors.
/area/proc/apply_daylight_overlay()
	if(daylight_lit)
		return
	daylight_lit = TRUE
	var/mutable_appearance/light = get_daylight_overlay_appearance()
	var/list/own_turfs = list()
	for(var/turf/area_turf in src)
		area_turf.add_overlay(light)
		own_turfs += area_turf
		CHECK_TICK
	leak_daylight(own_turfs)

/// Feathers daylight a couple of tiles into adjacent indoor (non-daylight) turfs at decreasing strength, so the
/// boundary is a soft transition rather than a hard cliff. Light stops at opaque tiles (walls / closed doors).
/// Static: computed once at setup; it will not re-leak when doors later open or close.
/area/proc/leak_daylight(list/source_turfs)
	// Alpha per ring (ring 1 is nearest the daylight). Add entries / raise values for a wider or stronger leak.
	var/static/list/leak_falloff = list(165, 120, 90, 45)
	LAZYINITLIST(daylight_leaked)
	var/list/visited = list()
	for(var/turf/seed_turf as anything in source_turfs)
		visited[seed_turf] = TRUE
	var/list/frontier = source_turfs
	for(var/ring in 1 to length(leak_falloff))
		var/mutable_appearance/leak_light = get_daylight_overlay_appearance(leak_falloff[ring])
		var/list/next_frontier = list()
		for(var/turf/frontier_turf as anything in frontier)
			if(frontier_turf.opacity) // light can't pass this tile (wall / closed door) - don't propagate past it
				continue
			for(var/cardinal_dir in GLOB.cardinals)
				var/turf/neighbor = get_step(frontier_turf, cardinal_dir)
				if(!neighbor || visited[neighbor])
					continue
				visited[neighbor] = TRUE
				var/area/neighbor_area = neighbor.loc
				if(neighbor_area?.daylight) // already a fully-lit daylight area, leave it alone
					continue
				neighbor.add_overlay(leak_light)
				daylight_leaked[neighbor] = leak_light
				next_frontier += neighbor
		frontier = next_frontier
		CHECK_TICK

/// Removes the daylight light overlay (and any leaked feather) from this area's turfs.
/area/proc/clear_daylight_overlay()
	if(!daylight_lit)
		return
	daylight_lit = FALSE
	var/mutable_appearance/light = get_daylight_overlay_appearance()
	for(var/turf/area_turf in src)
		area_turf.cut_overlay(light)
		CHECK_TICK
	for(var/turf/leaked_turf as anything in daylight_leaked)
		leaked_turf.cut_overlay(daylight_leaked[leaked_turf])
		CHECK_TICK
	daylight_leaked = null


/area/centcom/central_command_areas/admin/daylight
	daylight = TRUE
	outdoors = TRUE

/datum/daylight_phase
	var/name = "Phase"
	var/color = "#ffffff"
	var/start_time = 0
	var/target_intensity = 1

/datum/daylight_phase/dawn
	name = "Dawn"
	color = "#31211b"
	start_time = 4 HOURS
	target_intensity = 0.2

/datum/daylight_phase/sunrise
	name = "Sunrise"
	color = "#F598AB"
	start_time = 5 HOURS
	target_intensity = 0.55

/datum/daylight_phase/daytime
	name = "Daytime"
	color = "#FFFFFF"
	start_time = 5.5 HOURS
	target_intensity = 1

/datum/daylight_phase/sunset
	name = "Sunset"
	color = "#ff8a63"
	start_time = 19 HOURS
	target_intensity = 0.45

/datum/daylight_phase/dusk
	name = "Dusk"
	color = "#2b2842"
	start_time = 19.5 HOURS
	target_intensity = 0.18

/datum/daylight_phase/midnight
	name = "Midnight"
	color = "#101c3b"
	start_time = 20 HOURS
	target_intensity = 0.08


SUBSYSTEM_DEF(daylight)
	name = "Daylight Controller"
	wait = 1 SECONDS
	runlevels = RUNLEVEL_GAME
	dependencies = list(
		/datum/controller/subsystem/mapping,
		/datum/controller/subsystem/lighting
	)

	var/static/list/daylight_areas = list()
	var/static/list/obj/effect/light_emitter/daylight/all_emitters = list()
	/// The one shared source object whose colour/alpha the per-turf daylight overlays mirror via render_source.
	var/obj/daylight_wash_source/wash_source
	/// TRUE once Initialize() has run its first lighting pass. Areas that loaded BEFORE this defer to that pass;
	/// areas/turfs loaded AFTER it (runtime map templates) light themselves immediately.
	var/setup_complete = FALSE

	var/current_intensity = 1
	var/current_color = "#ffffff"
	var/list/current_rgb = list(255, 255, 255)

	var/target_intensity = 1
	var/target_color = "#ffffff"
	var/start_intensity = 1
	var/start_color = "#ffffff"
	var/transition_steps = 0
	var/const/TRANSITION_STEPS = 6

	var/daylight_fraction = 0.77

	var/delta_cycle_progress = 0.05
	var/cycle_locked = FALSE
	var/time_locked = FALSE
	var/manual_time = -1

	var/falshing = FALSE
	var/setup_queue = list()
	var/setup_running = FALSE

	var/last_cycle_progress = -1
	var/datum/daylight_phase/current_phase
	var/datum/daylight_phase/next_phase
	var/list/daylight_phases = list(
		new /datum/daylight_phase/dawn(),
		new /datum/daylight_phase/sunrise(),
		new /datum/daylight_phase/daytime(),
		new /datum/daylight_phase/sunset(),
		new /datum/daylight_phase/dusk(),
		new /datum/daylight_phase/midnight()
	)
	var/last_phase_name

	var/mob_visual_update_cooldown = 3 SECONDS
	COOLDOWN_DECLARE(mob_visual_cd)

	var/list/phase_particle_weights = list(
		"Dawn" = list(
			/particles/daylight_weather/rain = 5,
			/particles/daylight_weather/mist = 3,
		),
		"Sunrise" = list(
			/particles/daylight_weather/mist = 6,
			/particles/daylight_weather/rain = 2,
		),
		"Daytime" = list(
			/particles/daylight_weather/dust = 7,
			/particles/daylight_weather/mist = 2,
		),
		"Sunset" = list(
			/particles/daylight_weather/rain = 5,
			/particles/daylight_weather/dust = 2,
		),
		"Dusk" = list(
			/particles/daylight_weather/snow = 5,
			/particles/daylight_weather/mist = 3,
		),
		"Midnight" = list(
			/particles/daylight_weather/snow = 7,
			/particles/daylight_weather/mist = 2,
		),
	)
	var/current_particle_weather = /particles/daylight_weather/mist
	var/visual_weather_override = "auto"
	var/visual_weather_strength = 0
	var/target_visual_weather_strength = 0

	var/daylight_update_cooldown = 12 SECONDS
	var/daylight_cycle = 60
	COOLDOWN_DECLARE(daylight_update_cd)

/datum/controller/subsystem/daylight/Initialize()
	SSticker.station_time_rate_multiplier = 1440 / daylight_cycle

	current_rgb = hex2rgb(current_color)
	var/initial_progress = get_cycle_progress()
	last_cycle_progress = initial_progress
	resolve_phase()
	var/list/phase_state = get_phase_light_state()
	current_intensity = phase_state["intensity"]
	current_color = phase_state["color"]

	// Create the shared daylight source (publishes the render target the per-turf overlays mirror) and seed it
	// with the current state.
	wash_source = new()
	wash_source.color = current_color
	wash_source.alpha = round(clamp(current_intensity, 0, 1) * 255, 1)
	// Register it onto anyone who already has a HUD (built before now); future HUDs register via the anchor plate.
	for(var/mob/viewer as anything in GLOB.player_list)
		viewer.hud_used?.register_reuse(wash_source)

	update_current(current_intensity, current_color)

	// Light every daylight area now that the map is fully loaded.
	for(var/area/daylit_area as anything in daylight_areas)
		daylit_area.apply_daylight_overlay()
		CHECK_TICK
	setup_complete = TRUE

	return SS_INIT_SUCCESS

/datum/controller/subsystem/daylight/proc/update_area(area/A)
	if(!istype(A) || QDELETED(A) || !A.daylight)
		return
	A.update_virtual_lighting(round(current_intensity * 255, 1))

/// Lights newly-loaded daylight turfs. Call this after dropping a map template into the world (e.g. a train
/// station) so the daylight system picks up the new turfs automatically - no manual passes needed.
/datum/controller/subsystem/daylight/proc/handle_loaded_turfs(list/turfs)
	if(!setup_complete || !length(turfs))
		return
	var/mutable_appearance/light = get_daylight_overlay_appearance()
	for(var/turf/loaded_turf as anything in turfs)
		var/area/loaded_area = loaded_turf.loc
		if(!loaded_area?.daylight)
			continue
		if(!loaded_area.daylight_lit)
			loaded_area.apply_daylight_overlay() // brand-new daylight area: light it fully (and feather inward)
			continue
		// Turf added to an already-lit area: ensure it carries the overlay exactly once (cut guards re-runs).
		loaded_turf.cut_overlay(light)
		loaded_turf.add_overlay(light)
		CHECK_TICK

/// Re-applies (or removes) the daylight overlay on a single turf - called from /turf/AfterChange so that a turf
/// replaced by ChangeTurf (a fresh object with no overlays) is re-lit, since the area's one-time pass never re-runs.
/// Cheap no-op for the vast majority of turfs that aren't in daylight areas.
/datum/controller/subsystem/daylight/proc/refresh_turf_daylight(turf/changed)
	if(!setup_complete || QDELETED(changed)) // roundstart turfs are handled by the central pass
		return
	var/area/turf_area = changed.loc
	if(!turf_area?.daylight)
		return
	var/mutable_appearance/light = get_daylight_overlay_appearance()
	changed.cut_overlay(light) // guard against doubling if it somehow already has it
	changed.add_overlay(light)

/datum/controller/subsystem/daylight/proc/register_emitter(obj/effect/light_emitter/daylight/emitter)
	if(!emitter || QDELETED(emitter) || (emitter in all_emitters))
		return
	all_emitters += emitter
	emitter.apply_current_state()

/datum/controller/subsystem/daylight/proc/unregister_emitter(obj/effect/light_emitter/daylight/emitter)
	all_emitters -= emitter

/datum/controller/subsystem/daylight/proc/update_all_areas()
	if(setup_running)
		return
	setup_running = TRUE
	for(var/area/A in daylight_areas)
		update_area(A)
		CHECK_TICK
	setup_running = FALSE

/datum/controller/subsystem/daylight/proc/set_target(intensity, color, transition_time)
	target_intensity = clamp(intensity, 0, 1)
	target_color = color
	start_intensity = current_intensity
	start_color = current_color
	transition_steps = TRANSITION_STEPS
	if(isnull(transition_time))
		transition_time = TRANSITION_STEPS * wait
	// Animate the source straight to the target in ONE smooth pass over the whole transition, instead of
	// restarting a short animation on every fire() step (which is what made it stutter).
	update_wash(target_intensity, target_color, transition_time)

/datum/controller/subsystem/daylight/proc/set_intensity_and_color(intensity = target_intensity, color = target_color, force = FALSE)
	if(force)
		transition_steps = 0
		update_current(intensity, color)
		update_wash(intensity, color, 0) // snap the source to match
	else
		set_target(intensity, color)

/datum/controller/subsystem/daylight/proc/update_current(intensity, color, force = FALSE)
	var/changed = abs(current_intensity - intensity) > 0.001 || current_color != color
	if(!changed && !force)
		return

	current_intensity = intensity
	current_color = color
	current_rgb = hex2rgb(color)

	if(changed || force)
		update_all_areas()
		// The wash is animated to its target in set_target()/set_intensity_and_color(); do NOT restart its
		// animation on every intermediate transition step here, or it stutters.
		for(var/obj/effect/light_emitter/daylight/E in all_emitters)
			E.apply_current_state()
		SEND_SIGNAL(src, COMSIG_DAYLIGHT_UPDATED, current_intensity, current_color)

/datum/controller/subsystem/daylight/proc/get_cycle_progress()
	return station_time() / (24 HOURS)

/datum/controller/subsystem/daylight/proc/resolve_phase()
	var/time_now = station_time()
	var/datum/daylight_phase/new_current
	var/datum/daylight_phase/new_next

	for(var/i in 1 to length(daylight_phases))
		var/datum/daylight_phase/phase = daylight_phases[i]
		if(time_now >= phase.start_time)
			new_current = phase
			new_next = (i == length(daylight_phases)) ? daylight_phases[1] : daylight_phases[i + 1]

	if(!new_current)
		new_current = daylight_phases[length(daylight_phases)]
		new_next = daylight_phases[1]

	current_phase = new_current
	next_phase = new_next

/datum/controller/subsystem/daylight/proc/get_phase_progress()
	if(!current_phase || !next_phase)
		return 0

	var/full_day = 24 HOURS
	var/duration = next_phase.start_time - current_phase.start_time
	if(duration <= 0)
		duration += full_day

	var/elapsed = station_time() - current_phase.start_time
	if(elapsed < 0)
		elapsed += full_day

	if(duration <= 0)
		return 0

	return clamp(elapsed / duration, 0, 1)

/datum/controller/subsystem/daylight/proc/get_phase_light_state()
	resolve_phase()
	var/mix = get_phase_progress()
	var/color = color_interpolate(current_phase.color, next_phase.color, mix)
	var/intensity = lerp(current_phase.target_intensity, next_phase.target_intensity, mix)
	if(current_phase?.name == "Dusk" || current_phase?.name == "Midnight" || next_phase?.name == "Midnight")
		var/moonlight_ratio = clamp(1 - intensity, 0, 1)
		color = color_interpolate(color, "#6f86b6", moonlight_ratio * 0.4)
		intensity = max(intensity, 0.06)
	return list("color" = color, "intensity" = clamp(intensity, 0, 1))

/datum/controller/subsystem/daylight/proc/get_manual_light_color(value)
	var/datum/daylight_phase/day_phase = daylight_phases[3]
	var/datum/daylight_phase/night_phase = daylight_phases[6]
	return color_interpolate(night_phase.color, day_phase.color, clamp(value, 0, 1))

/datum/controller/subsystem/daylight/proc/get_auto_weather_particle_type()
	resolve_phase()
	var/list/particle_weights = phase_particle_weights[current_phase?.name]
	if(!length(particle_weights))
		return /particles/daylight_weather/mist
	return pick_weight(particle_weights)

/datum/controller/subsystem/daylight/proc/get_weather_particle_type()
	if(visual_weather_override == "rain")
		return /particles/daylight_weather/rain
	if(visual_weather_override == "snow")
		return /particles/daylight_weather/snow
	if(visual_weather_override == "dust")
		return /particles/daylight_weather/dust
	if(visual_weather_override == "mist")
		return /particles/daylight_weather/mist
	if(visual_weather_override == "none")
		return null
	var/next_auto = get_auto_weather_particle_type()
	if(next_auto)
		current_particle_weather = next_auto
	return current_particle_weather

/// Animates the shared daylight source toward the given state. Every per-turf overlay render_source-mirrors it,
/// so this single animation drives the daylight on all daylight turfs at once.
/datum/controller/subsystem/daylight/proc/update_wash(intensity = current_intensity, color = current_color, transition_time = mob_visual_update_cooldown)
	if(QDELETED(wash_source))
		return
	var/target_alpha = round(clamp(intensity, 0, 1) * 255, 1)
	animate(wash_source, color = color, alpha = target_alpha, time = max(0, transition_time), easing = SINE_EASING)

/datum/controller/subsystem/daylight/fire()
	if(transition_steps > 0)
		var/fraction = 1 - (transition_steps - 1) / TRANSITION_STEPS
		var/new_intensity = lerp(start_intensity, target_intensity, fraction)
		var/new_color = color_interpolate(start_color, target_color, fraction)
		update_current(new_intensity, new_color)
		transition_steps--

	if(!COOLDOWN_FINISHED(src, daylight_update_cd))
		return
	COOLDOWN_START(src, daylight_update_cd, daylight_update_cooldown)

	var/auto_cycle = (manual_time < 0 && !time_locked && !cycle_locked)
	var/cycle_progress = get_cycle_progress()

	if(auto_cycle)
		if(last_cycle_progress < 0)
			last_cycle_progress = cycle_progress
		else
			if(cycle_progress < last_cycle_progress - 0.01)
				message_admins("A new day has dawned on the station!")
				SEND_SIGNAL(src, COMSIG_DAYLIGHT_NEW_DAY)
				SEND_SIGNAL(src, COMSIG_DAYLIGHT_DAY_START)

			else if(last_cycle_progress < daylight_fraction && cycle_progress >= daylight_fraction)
				message_admins("Night has fallen on the station.")
				SEND_SIGNAL(src, COMSIG_DAYLIGHT_NIGHT_START)

	if(!auto_cycle)
		return
	if(abs(cycle_progress - last_cycle_progress) < delta_cycle_progress)
		return
	resolve_phase()
	var/current_phase_name = current_phase ? current_phase.name : null
	if(current_phase_name != last_phase_name)
		last_phase_name = current_phase_name

	var/list/phase_state = get_phase_light_state()
	set_target(phase_state["intensity"], phase_state["color"])
	last_cycle_progress = cycle_progress


/datum/controller/subsystem/daylight/proc/flash(color, duration = 10 SECONDS, transition_time = 2 SECONDS, areas)
	set waitfor = FALSE
	if(falshing)
		return
	falshing = TRUE
	if(!areas)
		areas = daylight_areas.Copy()
	var/trainstation_wait = 0.1 SECONDS
	var/orig_target_intensity = target_intensity
	var/orig_target_color = target_color
	var/steps_up = round(transition_time / wait, 1)
	var/steps_down = steps_up
	var/hold_steps = round(duration / trainstation_wait, 1) - steps_up - steps_down
	if(hold_steps < 0)
		hold_steps = 0
		steps_down = round((duration / wait) / 2, 1)
		steps_up = steps_down

	set_target(1, color, transition_time)
	for(var/i in 1 to steps_up)
		fire()
		sleep(trainstation_wait)
		CHECK_TICK

	for(var/i in 1 to hold_steps)
		sleep(duration / hold_steps)
		CHECK_TICK

	set_target(orig_target_intensity, orig_target_color, transition_time)
	for(var/i in 1 to steps_down)
		fire()
		sleep(trainstation_wait)
		CHECK_TICK
	falshing = FALSE

/proc/hex2rgb(hex)
	if(!hex)
		return list(255, 255, 255)

	if(copytext(hex, 1, 2) == "#")
		hex = copytext(hex, 2)

	var/len = length(hex)
	if(len == 3)
		hex = "[copytext(hex,1,2)][copytext(hex,1,2)][copytext(hex,2,3)][copytext(hex,2,3)][copytext(hex,3,4)][copytext(hex,3,4)]"

	if(length(hex) != 6)
		return list(255, 255, 255)

	var/r = hex2num(copytext(hex, 1, 3))
	var/g = hex2num(copytext(hex, 3, 5))
	var/b = hex2num(copytext(hex, 5, 7))

	return list(r, g, b)


/proc/color_interpolate(color1, color2, ratio)
	var/list/c1 = hex2rgb(color1)
	var/list/c2 = hex2rgb(color2)
	var/r = round(c1[1] + (c2[1] - c1[1]) * ratio, 1)
	var/g = round(c1[2] + (c2[2] - c1[2]) * ratio, 1)
	var/b = round(c1[3] + (c2[3] - c1[3]) * ratio, 1)
	return rgb(r, g, b)

/obj/effect/light_emitter
	flags_1 = NO_TURF_MOVEMENT_1

/obj/effect/light_emitter/daylight
	set_luminosity = 2
	set_cap = 0.5
	var/initial_lum = 2
	var/initial_cap = 0.5

/obj/effect/light_emitter/daylight/Initialize(mapload)
	. = ..()
	initial_lum = set_luminosity
	initial_cap = set_cap
	if(SSdaylight)
		SSdaylight.register_emitter(src)

/obj/effect/light_emitter/daylight/proc/apply_current_state()
	if(!SSdaylight)
		return
	var/mult = SSdaylight.current_intensity
	light_power = initial_cap * mult
	light_color = SSdaylight.current_color
	update_light()

/obj/effect/light_emitter/daylight/Destroy()
	if(SSdaylight)
		SSdaylight.unregister_emitter(src)
	return ..()


/// The shared daylight source. A single off-screen tile whose colour+alpha track the daylight cycle (animated in
/// ONE place, see update_wash) and whose appearance is published as DAYLIGHT_WASH_RENDER_TARGET. Every daylight
/// turf carries an overlay that render_source-mirrors this, so one animation drives the light on every turf.
/// This is the engine's starlight pattern - see /obj/starlight_appearance.
/obj/daylight_wash_source
	icon = 'icons/effects/alphacolors.dmi'
	icon_state = "white"
	plane = LIGHTING_PLANE
	blend_mode = BLEND_ADD
	// The leading "*" in the render target means "render to this target only, never draw normally" - so the
	// source object itself is invisible; it exists purely to be mirrored.
	render_target = DAYLIGHT_WASH_RENDER_TARGET
	screen_loc = "1,1"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/// Draws nothing. Its only job is to register the shared daylight source onto each viewer's screen (via the HUD
/// reuse system), so the source renders and publishes DAYLIGHT_WASH_RENDER_TARGET for the per-turf overlays to mirror.
/atom/movable/screen/plane_master/daylight_anchor
	name = "Daylight anchor"
	documentation = "Renders nothing. It registers the shared daylight source (/obj/daylight_wash_source) onto each \
		viewer's screen so the source publishes its render target, which the per-turf daylight overlays mirror via \
		render_source. The daylight light therefore lives on the turfs themselves (spatially correct), not as a fullscreen sheet."
	plane = RENDER_PLANE_DAYLIGHT
	appearance_flags = PLANE_MASTER|NO_CLIENT_COLOR
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_relay_planes = list()

/atom/movable/screen/plane_master/daylight_anchor/show_to(mob/mymob)
	. = ..()
	// Once per viewer is enough; only the top offset (0) registers.
	if(offset != 0 || !mymob || !SSdaylight?.wash_source)
		return
	mymob.hud_used?.register_reuse(SSdaylight.wash_source)

/atom/movable/screen/plane_master/daylight_anchor/hide_from(mob/oldmob)
	. = ..()
	if(offset != 0 || !oldmob || !SSdaylight?.wash_source)
		return
	oldmob.hud_used?.unregister_reuse(SSdaylight.wash_source)



/particles/daylight_weather
	icon = 'icons/effects/particles/generic.dmi'
	width = 480
	height = 480
	count = 120
	spawning = 0.4
	lifespan = 1.8 SECONDS
	fade = 1.2 SECONDS
	position = generator(GEN_BOX, list(-240, -180, 0), list(240, 240, 0))
	gravity = list(0, -1.3)
	drift = generator(GEN_CIRCLE, 0, 2)
	friction = 0.25

/particles/daylight_weather/rain
	icon_state = list("drop" = 4, "dot" = 1)
	color = "#b0d8ff"
	spawning = 1.2
	count = 200
	lifespan = 1.1 SECONDS
	fade = 0.5 SECONDS
	gravity = list(0, -4.4)
	drift = generator(GEN_CIRCLE, 0, 1)

/particles/daylight_weather/snow
	icon_state = list("dot" = 3, "cross" = 2)
	color = "#f2f7ff"
	spawning = 0.5
	count = 140
	lifespan = 2.6 SECONDS
	fade = 1.4 SECONDS
	gravity = list(0, -1.1)
	drift = generator(GEN_CIRCLE, 0, 3)
	spin = generator(GEN_NUM, -8, 8)

/particles/daylight_weather/dust
	icon_state = list("dot" = 4, "cross" = 1)
	color = "#c59a6f"
	spawning = 0.45
	count = 110
	lifespan = 2.4 SECONDS
	fade = 1.1 SECONDS
	gravity = list(-1.2, -0.4)
	drift = generator(GEN_CIRCLE, 0, 4)
	spin = generator(GEN_NUM, -6, 6)

/particles/daylight_weather/mist
	icon_state = list("dot" = 4)
	color = "#c7d5e8"
	spawning = 0.35
	count = 90
	lifespan = 3 SECONDS
	fade = 1.7 SECONDS
	gravity = list(0, -0.4)
	drift = generator(GEN_CIRCLE, 0, 2)
