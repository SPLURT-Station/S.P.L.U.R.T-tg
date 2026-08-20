/// Held by anyone who has pressed the off switch. Nothing here will touch their screen again.
#define TRAIT_BACKROOMS_NO_DISTORTION "backrooms_no_distortion"

/// How long to wait before another go at a distortion that had nothing to attach itself to yet.
#define BACKROOMS_DISTORTION_RETRY (1 SECONDS)

/**
 * Source the opt-out trait is added under.
 *
 * A constant rather than REF(src). The action deletes itself the moment it fires, so a ref source
 * could never be matched again by anything - leaving a trait that is unremovable by construction
 * rather than by intent. It stays permanent for players either way, since nothing in code lifts it,
 * but an admin undoing a misclick and anyone testing the distortions now have something to remove.
 */
#define BACKROOMS_OPT_OUT_TRAIT "backrooms_opt_out"


/**
 * Every number behind one of the backrooms' screen effects, held somewhere an admin can reach it.
 *
 * These used to live on the status effects themselves, which made them close to untunable: an edit
 * meant finding a victim who happened to be wearing that distortion, VVing their copy of it, and
 * watching the change die with the effect. One of these exists per distortion for the whole round
 * instead, so an edit lands on everyone already wearing it and on everyone who gets it afterwards.
 *
 * Reach them through their globals - GLOB.backrooms_bloom, GLOB.backrooms_fisheye and so on.
 */
/datum/backrooms_distortion_settings
	/// Sort priority handed to add_filter, deciding the order the filters stack in
	var/filter_priority = 1
	/// Every live distortion reading from this, so an edit can rebuild them where they stand.
	VAR_PRIVATE/list/listeners = list()

/datum/backrooms_distortion_settings/proc/register_listener(datum/status_effect/backrooms_distortion/distortion)
	listeners |= distortion

/datum/backrooms_distortion_settings/proc/unregister_listener(datum/status_effect/backrooms_distortion/distortion)
	listeners -= distortion

/**
 * Rebuilds every live distortion reading from this.
 *
 * A filter's parameters are baked in at the moment it is added, so changing a number here does
 * nothing on its own - the filter has to be torn down and put back. Doing that for every listener is
 * what makes an edit land on the people already wearing it rather than only on the next one to get it.
 */
/datum/backrooms_distortion_settings/proc/refresh_listeners()
	// Copied: a listener that has been deleted out from under us is dropped as we go.
	for(var/datum/status_effect/backrooms_distortion/distortion as anything in listeners.Copy())
		if(QDELETED(distortion))
			listeners -= distortion
			continue

		distortion.refresh_distortion()

/datum/backrooms_distortion_settings/vv_edit_var(var_name, var_value)
	. = ..()
	if(!.)
		return

	refresh_listeners()

/datum/backrooms_distortion_settings/fisheye
	filter_priority = 1
	/// How hard the warp pulls once it has faded all the way in
	var/warp_size = 10
	/// How long the warp takes to wind up to warp_size
	var/warp_in_time = 1 SECONDS

/datum/backrooms_distortion_settings/colour_shift
	filter_priority = 3
	/// Tints drifted between. Needs at least two, or there is nothing to drift to.
	var/list/tint_colours = list(
		"#c9d48f", // the fluorescent yellow everything down here already is, but more so
		// "#8fd4a8",
		// "#8fa8d4",
		// "#d48f9c",
	)
	/// How long one drift takes. Kept under the effect's tick_interval so it settles before the next.
	var/shift_time = 5 SECONDS

/datum/backrooms_distortion_settings/bloom
	filter_priority = 2
	/// Anything brighter than this blooms. The backrooms' lights sit well above it.
	var/bloom_threshold = "#d3d3d3"
	/// How far the glare spreads
	var/bloom_size = 2
	/// How far past the threshold a colour has to be before it starts spreading
	var/bloom_offset = 1
	/// How strongly the glare is laid back over the picture
	var/bloom_alpha = 190

/datum/backrooms_distortion_settings/blur
	filter_priority = 4
	/// How far out of focus. Past about 2 this stops reading as softness and starts hurting to play through.
	var/blur_size = 0.6

/datum/backrooms_distortion_settings/scanlines
	filter_priority = 5
	/// "scanlines" is a dark row every 2 pixels, "scanlines_wide" every 4
	var/scanline_state = "scanlines"
	/// How dark the rows land, 0 to 255
	var/scanline_alpha = 45
	/// INSET keeps the rows off empty space. Plain BLEND_OVERLAY lays them over everything instead.
	var/scanline_blend = BLEND_INSET_OVERLAY

/datum/backrooms_distortion_settings/rolling_bar
	filter_priority = 6
	/// Height of the band in pixels - one full wavelength of the wave
	var/bar_height = 6
	/// How far the band shoves the picture sideways
	var/bar_strength = 0.2
	/// How long the band takes to cross one wavelength. Lower rolls faster.
	var/roll_time = 2 SECONDS

/datum/backrooms_distortion_settings/crt_border
	/// Last in the stack on purpose: the bezel is the physical edge of the tube, so it should sit
	/// flat over the finished picture rather than be bent by the fisheye or dragged by the bar.
	filter_priority = 10
	/// "crt_border" bites in hard, "crt_border_soft" is a gentler frame
	var/border_state = "crt_border"
	/// How strongly the frame lies over the picture, 0 to 255
	var/border_alpha = 255
	/// OVERLAY so the frame covers empty space too - a bezel hides whatever is behind it.
	var/border_blend = BLEND_OVERLAY

/// How the camera behaves on the way into the backrooms and on the way back out.
/datum/backrooms_transfer_settings
	/// How far the camera pushes in around the transfer
	var/zoom = 3
	/// How long the push in, and the pull back out, each take
	var/zoom_time = 1.5 SECONDS

GLOBAL_DATUM_INIT(backrooms_fisheye, /datum/backrooms_distortion_settings/fisheye, new)
GLOBAL_DATUM_INIT(backrooms_colour_shift, /datum/backrooms_distortion_settings/colour_shift, new)
GLOBAL_DATUM_INIT(backrooms_bloom, /datum/backrooms_distortion_settings/bloom, new)
GLOBAL_DATUM_INIT(backrooms_blur, /datum/backrooms_distortion_settings/blur, new)
GLOBAL_DATUM_INIT(backrooms_scanlines, /datum/backrooms_distortion_settings/scanlines, new)
GLOBAL_DATUM_INIT(backrooms_rolling_bar, /datum/backrooms_distortion_settings/rolling_bar, new)
GLOBAL_DATUM_INIT(backrooms_crt_border, /datum/backrooms_distortion_settings/crt_border, new)
GLOBAL_DATUM_INIT(backrooms_transfer, /datum/backrooms_transfer_settings, new)


/**
 * Emergency off switch for the backrooms' screen effects.
 *
 * The warping, glare, drifting colour and rolling tear can genuinely make people unwell - migraine,
 * photosensitivity, motion sickness - so anyone handed one of these effects is handed this button
 * alongside it. Pressing it strips every distortion they have and stops any more being applied for
 * the rest of the round. Nothing else about being down here changes; only the visuals stop.
 *
 * check_flags is deliberately NONE. The exiled spend much of this asleep, lying down or otherwise
 * incapacitated, and a safety valve that only works while you are healthy is not a safety valve.
 */
/datum/action/backrooms_stop_distortions
	name = "Stop Screen Effects"
	desc = "Immediately turns off the backrooms' visual distortions. Use this if they are making you unwell. This lasts the rest of the round and cannot be undone."
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "adjust_vision"
	check_flags = NONE

/datum/action/backrooms_stop_distortions/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return

	var/mob/living/victim = owner
	if(!isliving(victim))
		return

	// Recorded on the mind rather than the body. This module swaps bodies constantly - on arrival, and
	// again every time something down here kills you - and the opt-out has to survive all of that.
	// Resolved into its own var first: ADD_TRAIT pastes its target straight into target._status_traits
	// several times over, so handing it an expression rather than a plain reference does not compile.
	var/datum/trait_holder = victim.mind
	if(isnull(trait_holder))
		trait_holder = victim

	ADD_TRAIT(trait_holder, TRAIT_BACKROOMS_NO_DISTORTION, BACKROOMS_OPT_OUT_TRAIT)

	// Copied first: each removal can take this very action away once it is the last one left.
	for(var/datum/status_effect/backrooms_distortion/distortion in victim.status_effects?.Copy())
		qdel(distortion)

	to_chat(victim, span_notice("The crawling on your eyes stops. Whatever this place was doing to your sight, it is not doing it any more."))

	if(!QDELETED(src))
		qdel(src)

/**
 * Base for the backrooms' screen distortions.
 *
 * Each subtype owns exactly one named filter on the victim's game plane masters and nothing else,
 * so they stack freely - a victim can be warped, tinted and blooming at once, and dropping any one
 * of them leaves the other two untouched.
 *
 * Every number one of these draws with comes off its /datum/backrooms_distortion_settings global
 * rather than off the effect, so all of them are tunable in one place for the whole round.
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
	/// The global this distortion reads its numbers from. Resolved by get_settings() on apply.
	var/datum/backrooms_distortion_settings/settings
	/// Timer for another go at a distortion that had nothing to attach itself to. Null when settled.
	var/retry_timer

/// The settings global this distortion draws from. Every concrete subtype names its own.
/datum/status_effect/backrooms_distortion/proc/get_settings()
	RETURN_TYPE(/datum/backrooms_distortion_settings)

	return null

/datum/status_effect/backrooms_distortion/on_creation(mob/living/new_owner, custom_duration)
	if(!isnull(custom_duration))
		duration = custom_duration
	return ..()

/datum/status_effect/backrooms_distortion/on_apply()
	// Refused rather than thrown. These get applied from the middle of the exile transfer, and a
	// runtime there unwinds the whole arrival with it - leaving the victim asleep on the floor in a
	// body they cannot get out of. A misconfigured subtype should cost its own effect, nothing more.
	if(isnull(filter_key))
		stack_trace("[type] was applied without a filter_key")
		return FALSE

	settings = get_settings()
	if(isnull(settings))
		stack_trace("[type] was applied without a settings global to read from")
		return FALSE

	// Anyone who has hit the off switch is done with these for the round, no matter what applies them.
	if(HAS_MIND_TRAIT(owner, TRAIT_BACKROOMS_NO_DISTORTION))
		return FALSE

	settings.register_listener(src)

	// HUD_CREATED covers the plane masters being rebuilt under us. LOGIN matters just as much:
	// /mob/Login() calls client.clear_screen(), which throws away the render sources the fisheye,
	// scanlines and border keep on client.screen, and it only rebuilds the HUD when there is not one
	// already - so a reconnect wipes them and fires no HUD signal at all.
	RegisterSignals(owner, list(COMSIG_MOB_HUD_CREATED, COMSIG_MOB_LOGIN), PROC_REF(on_screen_rebuilt))
	apply_distortion()
	grant_stop_button()
	return TRUE

/datum/status_effect/backrooms_distortion/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_HUD_CREATED, COMSIG_MOB_LOGIN))
	settings?.unregister_listener(src)
	cancel_retry()
	remove_distortion()
	clear_stop_button()

/**
 * Queues another attempt at a distortion that had nothing to hang itself on.
 *
 * Whatever applies one of these is not guaranteed to be doing it at a moment when the victim has a
 * client and a built HUD - the exile hands out its stay distortions in the middle of a mind
 * transfer, when the new body may have neither yet. Without a retry the effect then sits on them for
 * the rest of the round showing nothing at all, because the only things that ever rebuild it are a
 * HUD rebuild and a reconnect, and on that path neither is coming.
 */
/datum/status_effect/backrooms_distortion/proc/schedule_retry()
	PROTECTED_PROC(TRUE)

	if(retry_timer)
		return

	retry_timer = addtimer(CALLBACK(src, PROC_REF(retry_distortion)), BACKROOMS_DISTORTION_RETRY, TIMER_STOPPABLE)

/// Drops a queued retry, for when the effect is going away before it ever managed to apply.
/datum/status_effect/backrooms_distortion/proc/cancel_retry()
	PRIVATE_PROC(TRUE)

	if(!retry_timer)
		return

	deltimer(retry_timer)
	retry_timer = null

/datum/status_effect/backrooms_distortion/proc/retry_distortion()
	PRIVATE_PROC(TRUE)

	retry_timer = null
	apply_distortion()

/// Hands the owner the off switch, unless they are already holding one.
/datum/status_effect/backrooms_distortion/proc/grant_stop_button()
	PRIVATE_PROC(TRUE)

	if(locate(/datum/action/backrooms_stop_distortions) in owner.actions)
		return

	var/datum/action/backrooms_stop_distortions/stop_button = new()
	stop_button.Grant(owner)

/// Takes the off switch back once there is nothing left for it to switch off.
/datum/status_effect/backrooms_distortion/proc/clear_stop_button()
	PRIVATE_PROC(TRUE)

	for(var/datum/status_effect/backrooms_distortion/other in owner.status_effects)
		if(other != src)
			return

	var/datum/action/backrooms_stop_distortions/stop_button = locate() in owner.actions
	if(stop_button)
		qdel(stop_button)

/// The rebuilt screen has neither our filter nor our render source on it, so put both back.
/datum/status_effect/backrooms_distortion/proc/on_screen_rebuilt(mob/source)
	SIGNAL_HANDLER

	apply_distortion()

/// Returns TRUE once the filter is actually on screen, FALSE while there is still nothing to put it on.
/datum/status_effect/backrooms_distortion/proc/apply_distortion()
	var/datum/hud/victim_hud = owner?.hud_used
	if(isnull(victim_hud) || isnull(settings))
		schedule_retry()
		return FALSE

	for(var/atom/movable/screen/plane_master/game_plane as anything in victim_hud.get_true_plane_masters(RENDER_PLANE_GAME))
		add_to_plane(game_plane)

	return TRUE

/datum/status_effect/backrooms_distortion/proc/remove_distortion()
	var/datum/hud/victim_hud = owner?.hud_used
	if(isnull(victim_hud))
		return

	for(var/atom/movable/screen/plane_master/game_plane as anything in victim_hud.get_true_plane_masters(RENDER_PLANE_GAME))
		game_plane.remove_filter(filter_key)

/// Hangs this effect's filter on one game plane master. Subtypes implement it.
/datum/status_effect/backrooms_distortion/proc/add_to_plane(atom/movable/screen/plane_master/game_plane)
	return

/// Rebuilds the filter from the settings as they stand now, putting an edit on screen straight away.
/datum/status_effect/backrooms_distortion/proc/refresh_distortion()
	remove_distortion()
	apply_distortion()


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

	/// Screen object carrying the displacement map the filter samples
	var/atom/movable/screen/fullscreen/backrooms_render_source/fisheye/warp_source

/datum/status_effect/backrooms_distortion/fisheye/get_settings()
	return GLOB.backrooms_fisheye

/datum/status_effect/backrooms_distortion/fisheye/on_remove()
	. = ..()

	if(QDELETED(warp_source))
		warp_source = null
		return

	owner?.client?.screen -= warp_source
	QDEL_NULL(warp_source)

/datum/status_effect/backrooms_distortion/fisheye/apply_distortion()
	if(!build_warp_source())
		schedule_retry()
		return FALSE

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

/datum/status_effect/backrooms_distortion/fisheye/add_to_plane(atom/movable/screen/plane_master/game_plane)
	if(QDELETED(warp_source))
		return

	var/datum/backrooms_distortion_settings/fisheye/warp_settings = settings

	// Added at full strength on purpose. add_filter caches every filter's params and rebuilds the
	// plane's filter list from that cache on each call, so the cached value is the one that survives
	// - cache the flat starting size instead and the warp undoes itself the moment anything else
	// touches this plane. The wind-up is then a plain animation on top of the settled value.
	game_plane.add_filter(filter_key, warp_settings.filter_priority, displacement_map_filter(render_source = warp_source.render_target, size = warp_settings.warp_size))

	var/warp = game_plane.get_filter(filter_key)
	if(!warp)
		return

	// Starts flat and winds up, so stepping into it reads as the room bending rather than a cut.
	animate(warp, size = 0, time = 0)
	animate(size = warp_settings.warp_size, time = warp_settings.warp_in_time, easing = CUBIC_EASING|EASE_OUT)


/// Drifts the whole screen between a set of sickly tints, never sitting on one long enough to adjust to it.
/datum/status_effect/backrooms_distortion/colour_shift
	id = "backrooms_colour_shift"
	filter_key = "backrooms_colour_shift"
	tick_interval = 8 SECONDS

	/// Index into the settings' tint_colours currently showing. Per victim, so they drift out of step.
	var/current_colour = 1

/datum/status_effect/backrooms_distortion/colour_shift/get_settings()
	return GLOB.backrooms_colour_shift

/datum/status_effect/backrooms_distortion/colour_shift/add_to_plane(atom/movable/screen/plane_master/game_plane)
	game_plane.add_filter(filter_key, settings.filter_priority, get_tint_filter())

/datum/status_effect/backrooms_distortion/colour_shift/tick(seconds_between_ticks)
	drift_colour()

/// Editing tint_colours can leave current_colour pointing past the end of it, so clamp first.
/datum/status_effect/backrooms_distortion/colour_shift/refresh_distortion()
	var/datum/backrooms_distortion_settings/colour_shift/tint_settings = settings
	if(tint_settings)
		current_colour = clamp(current_colour, 1, max(length(tint_settings.tint_colours), 1))

	return ..()

/datum/status_effect/backrooms_distortion/colour_shift/proc/get_tint_filter()
	var/datum/backrooms_distortion_settings/colour_shift/tint_settings = settings

	// An emptied tint_colours leaves nothing to tint with, so sit on a no-op white rather than runtime.
	if(!length(tint_settings?.tint_colours))
		return color_matrix_filter(color_to_full_rgba_matrix("#ffffff"))

	return color_matrix_filter(color_to_full_rgba_matrix(tint_settings.tint_colours[current_colour]))

/// Picks a tint that is not the one already showing and blends across to it.
/datum/status_effect/backrooms_distortion/colour_shift/proc/drift_colour()
	var/datum/hud/victim_hud = owner?.hud_used
	var/datum/backrooms_distortion_settings/colour_shift/tint_settings = settings
	if(isnull(victim_hud) || length(tint_settings?.tint_colours) < 2)
		return

	var/next_colour = current_colour
	while(next_colour == current_colour)
		next_colour = rand(1, length(tint_settings.tint_colours))
	current_colour = next_colour

	var/list/new_tint = get_tint_filter()
	for(var/atom/movable/screen/plane_master/game_plane as anything in victim_hud.get_true_plane_masters(RENDER_PLANE_GAME))
		// modify_filter with update = FALSE writes the destination into the plane's filter cache
		// without reassigning the live filters, so the drift below survives. transition_filter() does
		// both at once, but its rebuild discards the animation and the tint snaps across instantly.
		game_plane.modify_filter(filter_key, list("color" = new_tint["color"]), update = FALSE)

		var/tint = game_plane.get_filter(filter_key)
		if(tint)
			animate(tint, color = new_tint["color"], time = tint_settings.shift_time, easing = CUBIC_EASING)


/// Blows out every light source until the level glares.
/datum/status_effect/backrooms_distortion/bloom
	id = "backrooms_bloom"
	filter_key = "backrooms_bloom"

/datum/status_effect/backrooms_distortion/bloom/get_settings()
	return GLOB.backrooms_bloom

/datum/status_effect/backrooms_distortion/bloom/add_to_plane(atom/movable/screen/plane_master/game_plane)
	var/datum/backrooms_distortion_settings/bloom/glare = settings

	game_plane.add_filter(filter_key, glare.filter_priority, bloom_filter(glare.bloom_threshold, glare.bloom_size, glare.bloom_offset, glare.bloom_alpha))


/// Pulls the picture very slightly out of focus, the way a tube never quite resolves a pixel.
/datum/status_effect/backrooms_distortion/blur
	id = "backrooms_blur"
	filter_key = "backrooms_blur"

/datum/status_effect/backrooms_distortion/blur/get_settings()
	return GLOB.backrooms_blur

/datum/status_effect/backrooms_distortion/blur/add_to_plane(atom/movable/screen/plane_master/game_plane)
	var/datum/backrooms_distortion_settings/blur/focus = settings

	game_plane.add_filter(filter_key, focus.filter_priority, gauss_blur_filter(focus.blur_size))


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

	/// Screen object carrying the grille the filter samples
	var/atom/movable/screen/fullscreen/backrooms_render_source/scanlines/scanline_source

/datum/status_effect/backrooms_distortion/scanlines/get_settings()
	return GLOB.backrooms_scanlines

/datum/status_effect/backrooms_distortion/scanlines/on_remove()
	. = ..()

	if(QDELETED(scanline_source))
		scanline_source = null
		return

	owner?.client?.screen -= scanline_source
	QDEL_NULL(scanline_source)

/datum/status_effect/backrooms_distortion/scanlines/apply_distortion()
	if(!build_scanline_source())
		schedule_retry()
		return FALSE

	return ..()

/// Puts a viewport-sized grille on screen for the filter to read. Recreated after a HUD rebuild.
/datum/status_effect/backrooms_distortion/scanlines/proc/build_scanline_source()
	var/client/victim_client = owner?.client
	var/datum/backrooms_distortion_settings/scanlines/grille = settings
	if(isnull(victim_client) || isnull(owner.hud_used) || isnull(grille))
		return FALSE

	if(QDELETED(scanline_source))
		scanline_source = new(null, owner.hud_used)
		// The leading star renders it for sampling only - it is never drawn to the screen itself.
		scanline_source.render_target = "*backrooms_scanlines_[REF(src)]"

	scanline_source.icon_state = grille.scanline_state
	scanline_source.alpha = clamp(grille.scanline_alpha, 0, 255)
	scanline_source.update_for_view(victim_client.view)
	victim_client.screen |= scanline_source
	return TRUE

/datum/status_effect/backrooms_distortion/scanlines/add_to_plane(atom/movable/screen/plane_master/game_plane)
	if(QDELETED(scanline_source))
		return

	var/datum/backrooms_distortion_settings/scanlines/grille = settings

	game_plane.add_filter(filter_key, grille.filter_priority, layering_filter(render_source = scanline_source.render_target, blend_mode = grille.scanline_blend))


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

/datum/status_effect/backrooms_distortion/rolling_bar/get_settings()
	return GLOB.backrooms_rolling_bar

/datum/status_effect/backrooms_distortion/rolling_bar/add_to_plane(atom/movable/screen/plane_master/game_plane)
	var/datum/backrooms_distortion_settings/rolling_bar/tear = settings

	game_plane.add_filter(filter_key, tear.filter_priority, wave_filter(y = tear.bar_height, size = tear.bar_strength, offset = 0, flags = WAVE_SIDEWAYS))

	var/bar = game_plane.get_filter(filter_key)
	if(!bar)
		return

	// Two steps, and not transition_filter(). A loop replays the whole sequence, so without the
	// zero-length rewind the second pass animates from 1 to 1 and the bar just sits there twisting.
	// transition_filter() cannot be used either: it rebuilds the filter object as it caches the new
	// value, which throws away the animation it started a line earlier.
	// Exactly one wavelength per loop, so the band leaves the top as the next one enters the bottom.
	animate(bar, offset = 0, time = 0, loop = -1, flags = ANIMATION_PARALLEL)
	animate(offset = 1, time = tear.roll_time)


/**
 * Frames the view in a tube: rounded black corners closing in, vignetting hard into every edge.
 *
 * Sampled off a viewport-sized render_target for the same reason the scanlines are - a layering
 * filter handed a raw icon tiles it across the plane master's 32x32 icon space rather than the
 * screen.
 */
/datum/status_effect/backrooms_distortion/crt_border
	id = "backrooms_crt_border"
	filter_key = "backrooms_crt_border"

	/// Screen object carrying the frame the filter samples
	var/atom/movable/screen/fullscreen/backrooms_render_source/crt_border/border_source

/datum/status_effect/backrooms_distortion/crt_border/get_settings()
	return GLOB.backrooms_crt_border

/datum/status_effect/backrooms_distortion/crt_border/on_remove()
	. = ..()

	if(QDELETED(border_source))
		border_source = null
		return

	owner?.client?.screen -= border_source
	QDEL_NULL(border_source)

/datum/status_effect/backrooms_distortion/crt_border/apply_distortion()
	if(!build_border_source())
		schedule_retry()
		return FALSE

	return ..()

/// Puts a viewport-sized frame on screen for the filter to read. Recreated after a HUD rebuild.
/datum/status_effect/backrooms_distortion/crt_border/proc/build_border_source()
	var/client/victim_client = owner?.client
	var/datum/backrooms_distortion_settings/crt_border/bezel = settings
	if(isnull(victim_client) || isnull(owner.hud_used) || isnull(bezel))
		return FALSE

	if(QDELETED(border_source))
		border_source = new(null, owner.hud_used)
		// The leading star renders it for sampling only - it is never drawn to the screen itself.
		border_source.render_target = "*backrooms_crt_border_[REF(src)]"

	border_source.icon_state = bezel.border_state
	border_source.alpha = clamp(bezel.border_alpha, 0, 255)
	border_source.update_for_view(victim_client.view)
	victim_client.screen |= border_source
	return TRUE

/datum/status_effect/backrooms_distortion/crt_border/add_to_plane(atom/movable/screen/plane_master/game_plane)
	if(QDELETED(border_source))
		return

	var/datum/backrooms_distortion_settings/crt_border/bezel = settings

	game_plane.add_filter(filter_key, bezel.filter_priority, layering_filter(render_source = border_source.render_target, blend_mode = bezel.border_blend))


/**
 * The three screen objects the sampled distortions read their maps off.
 *
 * clear_with_screen is the important one. A render_target only exists for as long as the object
 * carrying it is actually on screen, so the moment one of these is dropped from client.screen every
 * filter sourcing it is left pointing at a name that resolves to nothing - and BYOND fills that in
 * with the game's own icon, which is what the doubled, displaced image over the middle of the screen
 * was: the window icon being read as a displacement map.
 *
 * Dropping them is easy to do by accident. /datum/hud/show_hud() opens with client.clear_screen()
 * and rebuilds the screen from the HUD's own inventory lists, and it is called from all over the
 * codebase - mood updates, martial arts, going dextrous, a multitool. None of those fire
 * COMSIG_MOB_HUD_CREATED or COMSIG_MOB_LOGIN, so nothing here ever heard about it and nothing put
 * these back. clear_screen() honours this flag, which is precisely what it is for.
 */
/atom/movable/screen/fullscreen/backrooms_render_source
	plane = FULLSCREEN_PLANE
	needs_offsetting = FALSE
	clear_with_screen = FALSE

/atom/movable/screen/fullscreen/backrooms_render_source/fisheye
	icon = 'modular_zzplurt/icons/effects/backrooms_fisheye.dmi'
	icon_state = "fisheye"

/atom/movable/screen/fullscreen/backrooms_render_source/scanlines
	icon = 'modular_zzplurt/icons/effects/backrooms_scanlines.dmi'
	icon_state = "scanlines"

/atom/movable/screen/fullscreen/backrooms_render_source/crt_border
	icon = 'modular_zzplurt/icons/effects/backrooms_crt_border.dmi'
	icon_state = "crt_border"
