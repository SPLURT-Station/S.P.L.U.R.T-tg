// Name every fake statpanel entry is given. The panel dispatches a click by sending the entry's
// name back as a command with whitespace turned into dashes, so /client/verb/backrooms_cant_escape
// below has to be named exactly this or the presses land nowhere.
#define BACKROOMS_TRAPPED_VERB_NAME "Can't escape"
/// Fullscreen category the trap's image occupies.
#define BACKROOMS_TRAP_FULLSCREEN "backrooms_trap"


/**
 * Base type for the backrooms' step-on traps.
 *
 * Handles the parts every trap shares - the roll, the per victim cooldown, and the entry check -
 * and leaves what actually happens to trigger(). Attach it to a turf, usually through the
 * /obj/effect/mapping_helpers/backrooms_trap helper.
 */
/datum/component/backrooms_trap
	/// Chance, in percent, that stepping on this does anything at all
	var/chance = 100
	/// How long a victim is immune for after setting this off
	var/cooldown = 10 SECONDS
	/// Victim REF() -> world.time they are allowed to trigger this again
	var/list/last_triggered_by_ref = list()
	/// Short name shown on the TESTING marker. Subtypes override it with what they actually do.
	var/trap_label = "trap"
#ifdef TESTING
	/// Label hovering over our turf. TESTING builds only.
	VAR_PRIVATE/obj/effect/backrooms_trap_marker/testing_marker
#endif

/datum/component/backrooms_trap/Initialize(chance_percent = 100, cooldown_time = 10 SECONDS)
	if(!isturf(parent))
		return COMPONENT_INCOMPATIBLE
	chance = max(0, chance_percent)
	cooldown = max(0, cooldown_time)
	return ..()

/datum/component/backrooms_trap/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_ENTERED, PROC_REF(on_entered))
	create_testing_marker()

/datum/component/backrooms_trap/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_ATOM_ENTERED)
	last_triggered_by_ref?.Cut()
	clear_testing_marker()

/datum/component/backrooms_trap/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	if(!can_trigger(arrived))
		return

	var/mob/living/victim = arrived
	if(cooldown)
		LAZYSET(last_triggered_by_ref, REF(victim), world.time + cooldown)

	trigger(victim)

/// Whether stepping on us does anything. Subtypes should extend this rather than replace it.
/datum/component/backrooms_trap/proc/can_trigger(atom/movable/arrived)
	if(!chance || !isliving(arrived))
		return FALSE

	var/mob/living/victim = arrived
	if(victim.stat == DEAD || !victim.client)
		return FALSE

	var/next_allowed = LAZYACCESS(last_triggered_by_ref, REF(victim))
	if(isnum(next_allowed) && world.time < next_allowed)
		return FALSE

	return prob(chance)

/// What the trap does to whoever stepped on it. Abstract - every trap is a subtype implementing this.
/datum/component/backrooms_trap/proc/trigger(mob/living/victim)
	return

/**
 * Labels our turf so a tester can see what is sitting where.
 *
 * Traps are invisible by design, which makes them miserable to test - a turf that rolled badly and
 * a turf that was never trapped look identical. Compiled out entirely unless TESTING is on.
 */
/datum/component/backrooms_trap/proc/create_testing_marker()
#ifdef TESTING
	var/turf/trapped_turf = parent
	testing_marker = new(trapped_turf)
	testing_marker.maptext = MAPTEXT_TINY_UNICODE("[trap_label] [chance]%")
#endif
	return

/datum/component/backrooms_trap/proc/clear_testing_marker()
#ifdef TESTING
	QDEL_NULL(testing_marker)
#endif
	return


#ifdef TESTING
/// Floating label marking a trapped turf. Only exists in TESTING builds.
/obj/effect/backrooms_trap_marker
	name = "trap marker"
	icon = null
	icon_state = null
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_LIGHTING_PLANE
	maptext_width = 128
	maptext_height = 32
	maptext_x = -48
	maptext_y = 4
#endif


/// The original backrooms trap: the carpet gives out and drops you somewhere else on the level.
/datum/component/backrooms_trap/pitfall

/datum/component/backrooms_trap/pitfall/trigger(mob/living/victim)
	var/turf/destination = get_backrooms_fall_turf()
	if(!destination)
		return

	victim.visible_message(
		span_warning("[victim] suddenly slips and vanishes!"),
		span_userdanger("The carpet gives way under your feet!"),
	)
	victim.forceMove(destination)
	victim.Paralyze(1 SECONDS)

/datum/component/backrooms_trap/pitfall/proc/get_backrooms_fall_turf()
	if(!length(GLOB.backrooms_fall_points))
		return null

	var/obj/effect/mapping_helpers/backrooms_fall_point/point = pick(GLOB.backrooms_fall_points)
	return get_turf(point)


/// Buries every entry in the victim's statpanel under copies of one useless verb, and jumps them
/// the first time they try it.
/datum/component/backrooms_trap/cant_escape
	/// How long the fullscreen image hangs around before clearing itself
	var/image_duration = 3 SECONDS
	/// Played whenever an image appears. One sound for the whole trap, not one per verb.
	var/press_sound = 'modular_zzplurt/sound/effects/nextbot_jumpscare.mp3'
	/// Icon the fullscreen image is pulled out of
	var/image_icon = 'modular_zzplurt/icons/effects/nextbot.dmi'
	/// Icon states picked between at random, one per press
	var/list/image_states = list("white_face", "black_face", "long_neck")

/datum/component/backrooms_trap/cant_escape/Initialize(chance_percent = 100, cooldown_time = 10 SECONDS, duration_of_image)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!isnull(duration_of_image))
		image_duration = duration_of_image

/datum/component/backrooms_trap/cant_escape/trigger(mob/living/victim)
	victim.apply_status_effect(
		/datum/status_effect/backrooms_cant_escape,
		image_duration,
		press_sound,
		image_icon,
		image_states,
	)


/// Hangs one of the backrooms' screen distortions on whoever steps here.
/datum/component/backrooms_trap/distortion
	trap_label = "distortion"
	/// Distortions applied to the victim. A list, so one trap can hand out a whole stack.
	var/list/distortion_types
	/// How long they last. Null leaves each distortion permanent until something takes it off.
	var/distortion_duration = null

/datum/component/backrooms_trap/distortion/Initialize(chance_percent = 100, cooldown_time = 10 SECONDS, duration_of_distortion)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!isnull(duration_of_distortion))
		distortion_duration = duration_of_distortion

/datum/component/backrooms_trap/distortion/trigger(mob/living/victim)
	for(var/distortion as anything in distortion_types)
		victim.apply_status_effect(distortion, distortion_duration)

/datum/component/backrooms_trap/distortion/fisheye
	trap_label = "fisheye"
	distortion_types = list(/datum/status_effect/backrooms_distortion/fisheye)

/datum/component/backrooms_trap/distortion/colour_shift
	trap_label = "colour shift"
	distortion_types = list(/datum/status_effect/backrooms_distortion/colour_shift)

/datum/component/backrooms_trap/distortion/bloom
	trap_label = "bloom"
	distortion_types = list(/datum/status_effect/backrooms_distortion/bloom)

/datum/component/backrooms_trap/distortion/blur
	trap_label = "blur"
	distortion_types = list(/datum/status_effect/backrooms_distortion/blur)

/datum/component/backrooms_trap/distortion/scanlines
	trap_label = "scanlines"
	distortion_types = list(/datum/status_effect/backrooms_distortion/scanlines)

/datum/component/backrooms_trap/distortion/rolling_bar
	trap_label = "rolling bar"
	distortion_types = list(/datum/status_effect/backrooms_distortion/rolling_bar)

/// The whole stack at once - everything the level can do to a screen.
/datum/component/backrooms_trap/distortion/crt
	trap_label = "CRT"
	distortion_types = list(
		/datum/status_effect/backrooms_distortion/fisheye,
		/datum/status_effect/backrooms_distortion/bloom,
		/datum/status_effect/backrooms_distortion/colour_shift,
		/datum/status_effect/backrooms_distortion/blur,
		/datum/status_effect/backrooms_distortion/scanlines,
		/datum/status_effect/backrooms_distortion/rolling_bar,
	)


/**
 * Makes the statpanel useless for as long as it lasts.
 *
 * Every verb the panel would normally list is redrawn as [BACKROOMS_TRAPPED_VERB_NAME], one fake
 * entry per real one. Pressing any of them shows a random fullscreen image with the trap's sound;
 * the image clears itself after image_duration, and the next press after that lets the victim go.
 *
 * The real client and mob verb lists are never touched, so nothing here can strand a player without
 * their verbs - lifting the effect just asks the client to redraw the panel from the untouched lists.
 */
/datum/status_effect/backrooms_cant_escape
	id = "backrooms_cant_escape"
	duration = STATUS_EFFECT_PERMANENT
	alert_type = null

	/// How long an image stays up once summoned
	var/image_duration = 3 SECONDS
	/// Sound sent alongside every image
	var/press_sound
	/// Icon the image is pulled out of
	var/image_icon
	/// Icon states picked between at random
	var/list/image_states
	/// Set once an image has been put on screen, so on_remove() knows to leave it running out
	var/showed_image = FALSE

/datum/status_effect/backrooms_cant_escape/on_creation(mob/living/new_owner, duration_of_image, sound_on_press, icon_of_image, list/states_of_image)
	if(!isnull(duration_of_image))
		image_duration = duration_of_image
	if(!isnull(sound_on_press))
		press_sound = sound_on_press
	if(!isnull(icon_of_image))
		image_icon = icon_of_image
	if(length(states_of_image))
		image_states = states_of_image
	return ..()

/datum/status_effect/backrooms_cant_escape/on_apply()
	if(!owner.client)
		return FALSE

	add_verb(owner.client, /client/verb/backrooms_cant_escape)
	replace_panel_verbs()
	return TRUE

/datum/status_effect/backrooms_cant_escape/on_remove()
	// An image that made it to the screen is on its own timer and gets to finish. Only tear one down
	// if we are ending some other way, with a leftover that nothing else will clean up.
	if(!showed_image)
		owner.clear_fullscreen(BACKROOMS_TRAP_FULLSCREEN)

	var/client/owner_client = owner.client
	if(!owner_client)
		return

	remove_verb(owner_client, /client/verb/backrooms_cant_escape)
	// Rebuilds the panel from the real verb lists, which we left alone the whole time.
	owner_client.init_verbs()

/// Redraws the panel with one [BACKROOMS_TRAPPED_VERB_NAME] in place of each verb it would have shown.
/datum/status_effect/backrooms_cant_escape/proc/replace_panel_verbs()
	var/client/owner_client = owner.client
	if(!owner_client)
		return

	var/list/fake_tabs = list()
	var/list/fake_verbs = list()
	for(var/procpath/panel_verb as anything in collect_panel_verbs(owner_client))
		fake_tabs |= panel_verb.category
		fake_verbs[++fake_verbs.len] = list(panel_verb.category, BACKROOMS_TRAPPED_VERB_NAME)

	if(!length(fake_verbs))
		return

	owner_client.panel_tabs = fake_tabs
	// allow_duplicates, or the panel keeps the first copy and drops the rest as same-named repeats.
	owner_client.stat_panel.send_message("init_verbs", list(
		panel_tabs = fake_tabs,
		verblist = fake_verbs,
		allow_duplicates = TRUE,
	))
	// Sitting on the Status tab, none of this is visible. Drag them onto a tab that is now wall to
	// wall Can't escape so the effect actually lands.
	owner_client.stat_panel.send_message("set_tab", list(tab = fake_tabs[1]))

/// Mirrors what /client/proc/init_verbs() would have listed, so we can swap each entry for our own.
/datum/status_effect/backrooms_cant_escape/proc/collect_panel_verbs(client/owner_client)
	var/list/candidates = owner_client.verbs.Copy()
	if(owner_client.mob)
		candidates += owner_client.mob.verbs
		for(var/atom/movable/thing as anything in owner_client.mob.contents)
			candidates += thing.verbs

	var/list/listed = list()
	for(var/procpath/candidate as anything in candidates)
		if(!candidate || candidate.hidden || !istext(candidate.category))
			continue
		listed += candidate

	return listed

/// Called by the fake verb. One press is the whole interaction - the image lands and the panel is
/// handed straight back, with the image left up on its own timer while they work out what happened.
/datum/status_effect/backrooms_cant_escape/proc/on_pressed()
	show_image()
	qdel(src)

/datum/status_effect/backrooms_cant_escape/proc/show_image()
	if(!owner.client || !length(image_states))
		return

	var/atom/movable/screen/fullscreen/backrooms_trap/image_screen = owner.overlay_fullscreen(BACKROOMS_TRAP_FULLSCREEN, /atom/movable/screen/fullscreen/backrooms_trap, 0)
	// overlay_fullscreen() bakes the severity onto the icon_state, so choose ours back afterwards.
	image_screen.icon = image_icon
	image_screen.icon_state = pick(image_states)

	if(press_sound)
		SEND_SOUND(owner, sound(press_sound, volume = 100))

	showed_image = TRUE
	// Timed off the mob, not off us - this effect is deleted the moment the press is handled.
	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob, clear_fullscreen), BACKROOMS_TRAP_FULLSCREEN), image_duration)


/atom/movable/screen/fullscreen/backrooms_trap
	icon = 'modular_zzplurt/icons/effects/nextbot.dmi'
	icon_state = "white_face"
	show_when_dead = TRUE


// Hidden so it never lists itself - the panel only ever sees the copies replace_panel_verbs() pushes.
/client/verb/backrooms_cant_escape()
	set name = BACKROOMS_TRAPPED_VERB_NAME
	set hidden = TRUE

	if(!isliving(mob))
		return

	var/mob/living/victim = mob
	var/datum/status_effect/backrooms_cant_escape/trapped = victim.has_status_effect(/datum/status_effect/backrooms_cant_escape)
	if(!trapped)
		return

	trapped.on_pressed()


/obj/effect/mapping_helpers/backrooms_trap
	name = "backrooms trap"
	icon_state = "merge_conflict_marker"
	late = TRUE
	alpha = 0
	/// Trap dropped onto our turf. Subtypes swap this out for a different effect.
	var/trap_type = /datum/component/backrooms_trap/pitfall

/obj/effect/mapping_helpers/backrooms_trap/LateInitialize()
	var/turf/trapped_turf = get_turf(src)
	if(trapped_turf)
		trapped_turf.AddComponent(trap_type)
	qdel(src)

/obj/effect/mapping_helpers/backrooms_trap/cant_escape
	name = "backrooms can't escape trap"
	trap_type = /datum/component/backrooms_trap/cant_escape

/obj/effect/mapping_helpers/backrooms_trap/fisheye
	name = "backrooms fisheye trap"
	trap_type = /datum/component/backrooms_trap/distortion/fisheye

/obj/effect/mapping_helpers/backrooms_trap/colour_shift
	name = "backrooms colour shift trap"
	trap_type = /datum/component/backrooms_trap/distortion/colour_shift

/obj/effect/mapping_helpers/backrooms_trap/bloom
	name = "backrooms bloom trap"
	trap_type = /datum/component/backrooms_trap/distortion/bloom

/obj/effect/mapping_helpers/backrooms_trap/blur
	name = "backrooms blur trap"
	trap_type = /datum/component/backrooms_trap/distortion/blur

/obj/effect/mapping_helpers/backrooms_trap/scanlines
	name = "backrooms scanlines trap"
	trap_type = /datum/component/backrooms_trap/distortion/scanlines

/obj/effect/mapping_helpers/backrooms_trap/rolling_bar
	name = "backrooms rolling bar trap"
	trap_type = /datum/component/backrooms_trap/distortion/rolling_bar

/obj/effect/mapping_helpers/backrooms_trap/crt
	name = "backrooms CRT trap"
	trap_type = /datum/component/backrooms_trap/distortion/crt

#undef BACKROOMS_TRAPPED_VERB_NAME
#undef BACKROOMS_TRAP_FULLSCREEN
