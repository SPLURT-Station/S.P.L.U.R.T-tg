/**
 * Base for the backrooms' screen distortions.
 *
 * Each subtype owns exactly one named filter on the victim's game plane masters and nothing else,
 * so they stack freely - a victim can be warped, tinted and blooming at once, and dropping any one
 * of them leaves the other two untouched.
 *
 * Plane masters are rebuilt from scratch whenever the HUD is, which throws our filters away with
 * them, so every distortion reapplies itself on COMSIG_MOB_HUD_CREATED.
 */
/datum/status_effect/backrooms_distortion
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = null

	/// Name of the filter this effect owns. Has to be unique per subtype or they overwrite each other.
	var/filter_key
	/// Sort priority handed to add_filter, deciding the order the filters stack in
	var/filter_priority = 1

/datum/status_effect/backrooms_distortion/on_creation(mob/living/new_owner, custom_duration)
	if(!isnull(custom_duration))
		duration = custom_duration
	return ..()

/datum/status_effect/backrooms_distortion/on_apply()
	if(isnull(filter_key))
		CRASH("[type] was applied without a filter_key")

	RegisterSignal(owner, COMSIG_MOB_HUD_CREATED, PROC_REF(on_hud_created))
	apply_distortion()
	return TRUE

/datum/status_effect/backrooms_distortion/on_remove()
	UnregisterSignal(owner, COMSIG_MOB_HUD_CREATED)
	remove_distortion()

/// The rebuilt HUD's plane masters are new objects that never had our filter, so put it back on.
/datum/status_effect/backrooms_distortion/proc/on_hud_created(mob/source)
	SIGNAL_HANDLER

	apply_distortion()

/datum/status_effect/backrooms_distortion/proc/apply_distortion()
	var/datum/hud/victim_hud = owner?.hud_used
	if(isnull(victim_hud))
		return

	for(var/atom/movable/screen/plane_master/game_plane as anything in victim_hud.get_true_plane_masters(RENDER_PLANE_GAME))
		add_to_plane(game_plane)

/datum/status_effect/backrooms_distortion/proc/remove_distortion()
	var/datum/hud/victim_hud = owner?.hud_used
	if(isnull(victim_hud))
		return

	for(var/atom/movable/screen/plane_master/game_plane as anything in victim_hud.get_true_plane_masters(RENDER_PLANE_GAME))
		game_plane.remove_filter(filter_key)

/// Hangs this effect's filter on one game plane master. Subtypes implement it.
/datum/status_effect/backrooms_distortion/proc/add_to_plane(atom/movable/screen/plane_master/game_plane)
	return

/**
 * Vars an admin can edit in VV and see the result immediately.
 *
 * A filter's parameters are baked in when it is added, so editing one of these changes nothing on
 * its own - the filter has to be torn down and rebuilt. Subtypes append their own with ..() + list().
 */
/datum/status_effect/backrooms_distortion/proc/get_live_edit_vars()
	return list(NAMEOF(src, filter_priority))

/// Rebuilds the filter from the current var values, putting an edit on screen straight away.
/datum/status_effect/backrooms_distortion/proc/refresh_distortion()
	remove_distortion()
	apply_distortion()

/datum/status_effect/backrooms_distortion/vv_edit_var(var_name, var_value)
	. = ..()
	if(!. || !(var_name in get_live_edit_vars()))
		return

	refresh_distortion()


/**
 * Bends the world around the centre of the screen.
 *
 * A displacement filter shifts each pixel by however far the red and green channels of its
 * displacement map say to, so the effect needs the map on screen as something to sample. That is
 * what warp_source is: a fullscreen screen object whose render_target starts with a "*", which
 * renders it for sampling without ever drawing it.
 */
/datum/status_effect/backrooms_distortion/fisheye
	id = "backrooms_fisheye"
	filter_key = "backrooms_fisheye"
	filter_priority = 1

	/// How hard the warp pulls once it has faded all the way in
	var/warp_size = 10
	/// How long the warp takes to wind up to warp_size
	var/warp_in_time = 1 SECONDS
	/// Screen object carrying the displacement map the filter samples
	var/atom/movable/screen/fullscreen/backrooms_fisheye_source/warp_source

/datum/status_effect/backrooms_distortion/fisheye/on_apply()
	// No client means nothing to hang the render source on, and the filter would sample nothing.
	if(isnull(owner.client) || isnull(owner.hud_used))
		return FALSE

	return ..()

/datum/status_effect/backrooms_distortion/fisheye/on_remove()
	. = ..()

	if(QDELETED(warp_source))
		warp_source = null
		return

	owner?.client?.screen -= warp_source
	QDEL_NULL(warp_source)

/datum/status_effect/backrooms_distortion/fisheye/apply_distortion()
	if(!build_warp_source())
		return

	return ..()

/// Puts the displacement map on screen so the filter has something to read. Recreated after a HUD rebuild.
/datum/status_effect/backrooms_distortion/fisheye/proc/build_warp_source()
	var/client/victim_client = owner?.client
	if(isnull(victim_client) || isnull(owner.hud_used))
		return FALSE

	if(QDELETED(warp_source))
		warp_source = new(null, owner.hud_used)
		// The leading star renders it for sampling only - it is never drawn to the screen itself.
		warp_source.render_target = "*backrooms_fisheye_[REF(src)]"

	warp_source.update_for_view(victim_client.view)
	victim_client.screen |= warp_source
	return TRUE

/datum/status_effect/backrooms_distortion/fisheye/get_live_edit_vars()
	return ..() + list(
		NAMEOF(src, warp_size),
		NAMEOF(src, warp_in_time),
	)

/datum/status_effect/backrooms_distortion/fisheye/add_to_plane(atom/movable/screen/plane_master/game_plane)
	if(QDELETED(warp_source))
		return

	// Starts flat and winds up, so stepping into it reads as the room bending rather than a cut.
	game_plane.add_filter(filter_key, filter_priority, displacement_map_filter(render_source = warp_source.render_target, size = 0))

	var/warp = game_plane.get_filter(filter_key)
	if(warp)
		animate(warp, size = warp_size, time = warp_in_time, easing = CUBIC_EASING|EASE_OUT)


/// Drifts the whole screen between a set of sickly tints, never sitting on one long enough to adjust to it.
/datum/status_effect/backrooms_distortion/colour_shift
	id = "backrooms_colour_shift"
	filter_key = "backrooms_colour_shift"
	filter_priority = 3
	tick_interval = 8 SECONDS

	/// Tints drifted between. Needs at least two, or there is nothing to drift to.
	var/list/tint_colours = list(
		"#c9d48f", // the fluorescent yellow everything down here already is, but more so
		"#8fd4a8",
		"#8fa8d4",
		"#d48f9c",
	)
	/// How long one drift takes. Kept under tick_interval so it settles before the next one starts.
	var/shift_time = 5 SECONDS
	/// Index into tint_colours currently showing
	var/current_colour = 1

/datum/status_effect/backrooms_distortion/colour_shift/add_to_plane(atom/movable/screen/plane_master/game_plane)
	game_plane.add_filter(filter_key, filter_priority, get_tint_filter())

/datum/status_effect/backrooms_distortion/colour_shift/tick(seconds_between_ticks)
	drift_colour()

/datum/status_effect/backrooms_distortion/colour_shift/get_live_edit_vars()
	return ..() + list(
		NAMEOF(src, tint_colours),
		NAMEOF(src, shift_time),
		NAMEOF(src, current_colour),
	)

/// Editing tint_colours in VV can leave current_colour pointing past the end of it, so clamp first.
/datum/status_effect/backrooms_distortion/colour_shift/refresh_distortion()
	current_colour = clamp(current_colour, 1, max(length(tint_colours), 1))
	return ..()

/datum/status_effect/backrooms_distortion/colour_shift/proc/get_tint_filter()
	// An emptied tint_colours leaves nothing to tint with, so sit on a no-op white rather than runtime.
	if(!length(tint_colours))
		return color_matrix_filter(color_to_full_rgba_matrix("#ffffff"))

	return color_matrix_filter(color_to_full_rgba_matrix(tint_colours[current_colour]))

/// Picks a tint that is not the one already showing and blends across to it.
/datum/status_effect/backrooms_distortion/colour_shift/proc/drift_colour()
	var/datum/hud/victim_hud = owner?.hud_used
	if(isnull(victim_hud) || length(tint_colours) < 2)
		return

	var/next_colour = current_colour
	while(next_colour == current_colour)
		next_colour = rand(1, length(tint_colours))
	current_colour = next_colour

	for(var/atom/movable/screen/plane_master/game_plane as anything in victim_hud.get_true_plane_masters(RENDER_PLANE_GAME))
		game_plane.transition_filter(filter_key, get_tint_filter(), shift_time, CUBIC_EASING)


/// Blows out every light source until the level glares.
/datum/status_effect/backrooms_distortion/bloom
	id = "backrooms_bloom"
	filter_key = "backrooms_bloom"
	filter_priority = 2

	/// Anything brighter than this blooms. The backrooms' lights sit well above it.
	var/bloom_threshold = "#4a4a4a"
	/// How far the glare spreads
	var/bloom_size = 4
	/// How far past the threshold a colour has to be before it starts spreading
	var/bloom_offset = 2
	/// How strongly the glare is laid back over the picture
	var/bloom_alpha = 190

/datum/status_effect/backrooms_distortion/bloom/get_live_edit_vars()
	return ..() + list(
		NAMEOF(src, bloom_threshold),
		NAMEOF(src, bloom_size),
		NAMEOF(src, bloom_offset),
		NAMEOF(src, bloom_alpha),
	)

/datum/status_effect/backrooms_distortion/bloom/add_to_plane(atom/movable/screen/plane_master/game_plane)
	game_plane.add_filter(filter_key, filter_priority, bloom_filter(bloom_threshold, bloom_size, bloom_offset, bloom_alpha))


/// Pulls the picture very slightly out of focus, the way a tube never quite resolves a pixel.
/datum/status_effect/backrooms_distortion/blur
	id = "backrooms_blur"
	filter_key = "backrooms_blur"
	filter_priority = 4

	/// How far out of focus. Past about 2 this stops reading as softness and starts hurting to play through.
	var/blur_size = 0.6

/datum/status_effect/backrooms_distortion/blur/get_live_edit_vars()
	return ..() + list(NAMEOF(src, blur_size))

/datum/status_effect/backrooms_distortion/blur/add_to_plane(atom/movable/screen/plane_master/game_plane)
	game_plane.add_filter(filter_key, filter_priority, gauss_blur_filter(blur_size))


/**
 * Lays a grille of dark rows over the picture.
 *
 * Handed a small icon, a layering filter tiles it across the plane master's own 32x32 icon space
 * rather than across the viewport, which is no use for a screen full of scanlines. So this does what
 * the fisheye does and samples a render_target that is already the size of the view, which sidesteps
 * tiling completely - the grille is drawn at full size once and read straight off.
 */
/datum/status_effect/backrooms_distortion/scanlines
	id = "backrooms_scanlines"
	filter_key = "backrooms_scanlines"
	filter_priority = 5

	/// "scanlines" is a dark row every 2 pixels, "scanlines_wide" every 4
	var/scanline_state = "scanlines"
	/// How dark the rows land, 0 to 255
	var/scanline_alpha = 45
	/// INSET keeps the rows off empty space. Plain BLEND_OVERLAY lays them over everything instead.
	var/scanline_blend = BLEND_INSET_OVERLAY
	/// Screen object carrying the grille the filter samples
	var/atom/movable/screen/fullscreen/backrooms_scanline_source/scanline_source

/datum/status_effect/backrooms_distortion/scanlines/on_apply()
	// No client means nothing to hang the render source on, and the filter would sample nothing.
	if(isnull(owner.client) || isnull(owner.hud_used))
		return FALSE

	return ..()

/datum/status_effect/backrooms_distortion/scanlines/on_remove()
	. = ..()

	if(QDELETED(scanline_source))
		scanline_source = null
		return

	owner?.client?.screen -= scanline_source
	QDEL_NULL(scanline_source)

/datum/status_effect/backrooms_distortion/scanlines/apply_distortion()
	if(!build_scanline_source())
		return

	return ..()

/// Puts a viewport-sized grille on screen for the filter to read. Recreated after a HUD rebuild.
/datum/status_effect/backrooms_distortion/scanlines/proc/build_scanline_source()
	var/client/victim_client = owner?.client
	if(isnull(victim_client) || isnull(owner.hud_used))
		return FALSE

	if(QDELETED(scanline_source))
		scanline_source = new(null, owner.hud_used)
		// The leading star renders it for sampling only - it is never drawn to the screen itself.
		scanline_source.render_target = "*backrooms_scanlines_[REF(src)]"

	scanline_source.icon_state = scanline_state
	scanline_source.alpha = clamp(scanline_alpha, 0, 255)
	scanline_source.update_for_view(victim_client.view)
	victim_client.screen |= scanline_source
	return TRUE

/datum/status_effect/backrooms_distortion/scanlines/get_live_edit_vars()
	return ..() + list(
		NAMEOF(src, scanline_state),
		NAMEOF(src, scanline_alpha),
		NAMEOF(src, scanline_blend),
	)

/datum/status_effect/backrooms_distortion/scanlines/add_to_plane(atom/movable/screen/plane_master/game_plane)
	if(QDELETED(scanline_source))
		return

	game_plane.add_filter(filter_key, filter_priority, layering_filter(render_source = scanline_source.render_target, blend_mode = scanline_blend))


/**
 * Drags a band of tearing up the screen, like a tube that has lost vertical hold.
 *
 * wave_filter displaces along one axis as a function of the other, so a wave given only a vertical
 * wavelength shears the picture sideways in a band. Walking the offset through one full wavelength
 * on a loop is what makes that band travel. Sits last so it shears the finished picture, scanlines
 * and all, the way a real tube would.
 */
/datum/status_effect/backrooms_distortion/rolling_bar
	id = "backrooms_rolling_bar"
	filter_key = "backrooms_rolling_bar"
	filter_priority = 6

	/// Height of the band in pixels - one full wavelength of the wave
	var/bar_height = 160
	/// How far the band shoves the picture sideways
	var/bar_strength = 3
	/// How long the band takes to cross one wavelength. Lower rolls faster.
	var/roll_time = 2 SECONDS

/datum/status_effect/backrooms_distortion/rolling_bar/get_live_edit_vars()
	return ..() + list(
		NAMEOF(src, bar_height),
		NAMEOF(src, bar_strength),
		NAMEOF(src, roll_time),
	)

/datum/status_effect/backrooms_distortion/rolling_bar/add_to_plane(atom/movable/screen/plane_master/game_plane)
	game_plane.add_filter(filter_key, filter_priority, wave_filter(y = bar_height, size = bar_strength, offset = 0, flags = WAVE_SIDEWAYS))

	var/bar = game_plane.get_filter(filter_key)
	if(!bar)
		return

	// Exactly one wavelength per loop, so the band leaves the top as the next one enters the bottom.
	animate(bar, offset = 1, time = roll_time, loop = -1)


/atom/movable/screen/fullscreen/backrooms_fisheye_source
	icon = 'modular_zzplurt/icons/effects/backrooms_fisheye.dmi'
	icon_state = "fisheye"
	plane = FULLSCREEN_PLANE
	needs_offsetting = FALSE

/atom/movable/screen/fullscreen/backrooms_scanline_source
	icon = 'modular_zzplurt/icons/effects/backrooms_scanlines.dmi'
	icon_state = "scanlines"
	plane = FULLSCREEN_PLANE
	needs_offsetting = FALSE
