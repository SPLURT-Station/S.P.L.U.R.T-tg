/// Held by anyone who has pressed the off switch. Nothing here will touch their screen again.
#define TRAIT_BACKROOMS_NO_DISTORTION "backrooms_no_distortion"

/// How long to wait before another go at a distortion that had nothing to attach itself to yet.
#define BACKROOMS_DISTORTION_RETRY (1 SECONDS)

/// Source for the opt-out trait. A constant, not REF(src): the action deletes itself as it fires, so
/// a ref source could never be matched again to lift the trait.
#define BACKROOMS_OPT_OUT_TRAIT "backrooms_opt_out"


/// Tunables for one distortion, one per effect, reached through GLOB.backrooms_bloom and friends.
/// An edit here lands on everyone already wearing it as well as everyone who gets it later.
/datum/backrooms_distortion_settings
	/// Sort priority handed to add_filter, deciding the order the filters stack in
	var/filter_priority = 1
	/// Every live distortion reading from this, so an edit can rebuild them where they stand.
	VAR_PRIVATE/list/listeners = list()

/datum/backrooms_distortion_settings/proc/register_listener(datum/status_effect/backrooms_distortion/distortion)
	listeners |= distortion

/datum/backrooms_distortion_settings/proc/unregister_listener(datum/status_effect/backrooms_distortion/distortion)
	listeners -= distortion

/// Rebuilds every live distortion reading from this. A filter bakes its params in when added, so an
/// edit only shows up if the filter is torn down and put back.
/datum/backrooms_distortion_settings/proc/refresh_listeners()
	// Copied so deleted listeners can be dropped as we go.
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


/// Distortion types the off switch stripped, so turning it back on can put them back. Keyed by REF of
/// whatever holds the trait. Stores typepaths, not effects, so nothing here can hold a datum alive.
GLOBAL_LIST_EMPTY(backrooms_suppressed_distortions)

/// Accessibility toggle: strips every distortion and blocks more while it is on.
/// check_flags is NONE on purpose - the exiled spend much of this incapacitated, and a safety valve
/// that only works while you are healthy is not one.
/datum/action/backrooms_stop_distortions
	name = "Stop Screen Effects"
	desc = "Turns the backrooms' visual distortions off. Use this if they are making you unwell. Press again to turn them back on."
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "adjust_vision"
	check_flags = NONE

/// The mind, not the body - this module swaps bodies constantly and the setting has to survive that.
/// Resolved into a plain var because ADD_TRAIT pastes its target in several times over.
/datum/action/backrooms_stop_distortions/proc/get_trait_holder()
	PRIVATE_PROC(TRUE)

	var/mob/living/victim = owner
	var/datum/trait_holder = victim?.mind
	return trait_holder || victim

/datum/action/backrooms_stop_distortions/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return

	var/mob/living/victim = owner
	if(!isliving(victim))
		return

	var/datum/trait_holder = get_trait_holder()
	if(HAS_TRAIT(trait_holder, TRAIT_BACKROOMS_NO_DISTORTION))
		resume_distortions(victim, trait_holder)
	else
		suppress_distortions(victim, trait_holder)

	refresh_button()

/datum/action/backrooms_stop_distortions/proc/suppress_distortions(mob/living/victim, datum/trait_holder)
	PRIVATE_PROC(TRUE)

	// Trait first: clear_stop_button() checks it, and without it in place the last removal below would
	// take this action away and leave no way back.
	ADD_TRAIT(trait_holder, TRAIT_BACKROOMS_NO_DISTORTION, BACKROOMS_OPT_OUT_TRAIT)

	var/list/stripped = list()
	for(var/datum/status_effect/backrooms_distortion/distortion in victim.status_effects?.Copy())
		stripped += distortion.type
		qdel(distortion)

	GLOB.backrooms_suppressed_distortions[REF(trait_holder)] = stripped
	to_chat(victim, span_notice("The crawling on your eyes stops. Whatever this place was doing to your sight, it is not doing it any more."))

/datum/action/backrooms_stop_distortions/proc/resume_distortions(mob/living/victim, datum/trait_holder)
	PRIVATE_PROC(TRUE)

	REMOVE_TRAIT(trait_holder, TRAIT_BACKROOMS_NO_DISTORTION, BACKROOMS_OPT_OUT_TRAIT)

	var/list/stripped = GLOB.backrooms_suppressed_distortions[REF(trait_holder)]
	GLOB.backrooms_suppressed_distortions -= REF(trait_holder)

	// Reapplied at their default duration - what was left of a timed one is not worth tracking.
	for(var/distortion_type as anything in stripped)
		victim.apply_status_effect(distortion_type)

	to_chat(victim, span_warning("Your sight crawls again."))

/datum/action/backrooms_stop_distortions/proc/refresh_button()
	PRIVATE_PROC(TRUE)

	if(HAS_TRAIT(get_trait_holder(), TRAIT_BACKROOMS_NO_DISTORTION))
		name = "Resume Screen Effects"
		desc = "Turns the backrooms' visual distortions back on."
	else
		name = initial(name)
		desc = initial(desc)

	build_all_button_icons()

/// Picks up the current state, for a button granted to a body that arrived already suppressed.
/datum/action/backrooms_stop_distortions/Grant(mob/grant_to)
	. = ..()
	refresh_button()

/// Base for the backrooms' screen distortions. Each subtype owns exactly one named filter on the
/// victim's game plane masters, so they stack freely. Numbers come off the settings global, not the
/// effect. Reapplies on COMSIG_MOB_HUD_CREATED, since a HUD rebuild throws the filters away.
/datum/status_effect/backrooms_distortion
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = null
	/// Otherwise a deleted owner takes be_replaced(), which nulls owner before qdel, and
	/// /datum/status_effect/Destroy() only calls on_remove() while there is one. This module deletes
	/// bodies constantly, so that path leaked the whole stack every time.
	on_remove_on_mob_delete = TRUE

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
	// Refused, not thrown: these apply mid-exile-transfer, where a runtime unwinds the whole arrival.
	if(isnull(filter_key))
		stack_trace("[type] was applied without a filter_key")
		return FALSE

	settings = get_settings()
	if(isnull(settings))
		stack_trace("[type] was applied without a settings global to read from")
		return FALSE

	// Suppressed: refuse the effect, but hand over the toggle anyway - a body that arrives already
	// switched off would otherwise have no button to switch back on with.
	if(HAS_MIND_TRAIT(owner, TRAIT_BACKROOMS_NO_DISTORTION))
		grant_stop_button()
		return FALSE

	settings.register_listener(src)

	// LOGIN as well as HUD_CREATED: Login() clear_screen()s the render sources but only rebuilds the
	// HUD when there isn't one, so a reconnect wipes them without firing a HUD signal.
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

/// Drops what can outlive us whatever route the deletion took. The listener list hangs off a
/// round-long global, so a missed unregister is a permanent ref and a hard delete.
/datum/status_effect/backrooms_distortion/Destroy()
	settings?.unregister_listener(src)
	settings = null
	cancel_retry()

	return ..()

/// Queues another go at a distortion applied before the victim had a client and HUD - as the exile
/// does mid-transfer. Without it the effect sits there showing nothing, with no signal coming.
/datum/status_effect/backrooms_distortion/proc/schedule_retry()
	PROTECTED_PROC(TRUE)

	// An ownerless effect has nothing to build against and nothing coming that would change it.
	// Queueing anyway is how this datum makes itself immortal: the callback holds a reference, the
	// retry finds no HUD because there is no owner, and it queues itself again, forever.
	if(retry_timer || QDELETED(src) || isnull(owner))
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
	if(QDELETED(src) || isnull(owner))
		return

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

	// Kept while suppressed: it is the only way back on, and there are no distortions left to hold it.
	if(HAS_MIND_TRAIT(owner, TRAIT_BACKROOMS_NO_DISTORTION))
		return

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


/// Bends the world around the centre of the screen. The displacement filter needs its map on screen
/// to sample, hence warp_source - a fullscreen object whose render_target starts with "*" so it is
/// rendered for sampling but never drawn.
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


/// Lays a grille of dark rows over the picture. Sampled off a viewport-sized render_target because a
/// layering filter handed a raw icon tiles it across the plane's 32x32 icon space instead.
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


/// Drags a band of tearing up the screen, like a tube that has lost vertical hold. A wave_filter
/// given only a vertical wavelength shears sideways; walking its offset through one wavelength on a
/// loop is what makes the band travel.
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


/// Frames the view in a tube: rounded black corners, vignetting into every edge. Sampled off a
/// viewport-sized render_target for the same reason the scanlines are.
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


/// Screen objects the sampled distortions read their maps off.
/// clear_with_screen is load-bearing: a render_target only exists while its object is on screen, and
/// show_hud() clear_screen()s from all over the codebase without firing any signal we listen to.
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
