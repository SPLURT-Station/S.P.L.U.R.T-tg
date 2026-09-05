#define MORPH_ENGINE_MODE_BARRIER (1 << 1)
#define MORPH_ENGINE_MODE_CONTAINMENT (1 << 2)
#define MORPH_ENGINE_MODE_ISOLATION (1 << 3)

GLOBAL_VAR(main_morph_engine)


/obj/effect/temp_visual/morph_engine_block
	name = "Shield"
	icon_state = "emppulse"
	color = COLOR_GREEN_GRAY

/datum/component/morph_engine_tracker
	var/atom/movable/atom_parent = null
	var/obj/machinery/morphological_engine/active_engine = null
	var/power_usage_per_block = BASE_MACHINE_ACTIVE_CONSUMPTION

/datum/component/morph_engine_tracker/Initialize(engine, power_to_block = BASE_MACHINE_ACTIVE_CONSUMPTION)
	. = ..()
	if(!engine)
		engine = GLOB.main_morph_engine
	if(!engine || !istype(engine, /obj/machinery/morphological_engine))
		return COMPONENT_INCOMPATIBLE

	active_engine = engine
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

	atom_parent = parent
	power_usage_per_block = power_to_block

/datum/component/morph_engine_tracker/RegisterWithParent()
	. = ..()
	RegisterSignal(atom_parent, COMSIG_MOVABLE_ATTEMPTED_MOVE, PROC_REF(on_parent_pre_move))
	if(isliving(atom_parent))
		RegisterSignal(atom_parent, COMSIG_MOB_CLICKON, PROC_REF(on_living_parent_clickon))

/datum/component/morph_engine_tracker/UnregisterFromParent()
	. = ..()
	UnregisterSignal(atom_parent, list(COMSIG_MOVABLE_ATTEMPTED_MOVE))
	if(isliving(atom_parent))
		UnregisterSignal(atom_parent, list(COMSIG_MOB_CLICKON))

/datum/component/morph_engine_tracker/proc/on_living_parent_clickon(mob/living/living_parent, atom/target, list/modifiers)
	SIGNAL_HANDLER

	if(!active_engine || !active_engine.on)
		return

	var/turf/target_turf = get_turf(target)
	if(!active_engine.is_protected_turf(target_turf))
		return

	if(living_parent.Adjacent(target_turf))
		new /obj/effect/temp_visual/morph_engine_block(target_turf)

	return COMSIG_MOB_CANCEL_CLICKON

/datum/component/morph_engine_tracker/proc/on_parent_pre_move(atom/movable/parent, newloc, direction)
	SIGNAL_HANDLER

	if(!active_engine || !active_engine.on)
		return

	var/turf/old_turf = get_turf(atom_parent)
	var/turf/new_turf = get_turf(newloc)
	if(!new_turf)
		return

	// Block ONLY the attempt to enter a protected zone (from an unprotected one)
	// Inside the zone - movement is free, exiting is free too
	if(!(old_turf && !active_engine.is_protected_turf(old_turf) && active_engine.is_protected_turf(new_turf)))
		return

	if(!active_engine.can_block_movement(power_usage_per_block))
		return

	new /obj/effect/temp_visual/morph_engine_block(new_turf)
	addtimer(CALLBACK(src, PROC_REF(throw_back), atom_parent, old_turf), 1)

/datum/component/morph_engine_tracker/proc/throw_back(atom/movable/target, turf/old_loc)
	if(!target || QDELETED(target) || !old_loc)
		return

	target.throw_at(old_loc, get_dist(get_turf(target), old_loc), 10, atom_parent, FALSE, TRUE)
	to_chat(target, span_userdanger("An energy wave pushes you back!"))
	if(isliving(target))
		var/mob/living/living_target = target
		living_target.take_overall_damage(20)

/obj/machinery/morphological_engine
	name = "\improper Morphological Engine"
	desc = "A sphere covered with countless wires, pipes, and technical openings, emitting a faint, barely audible hum up close. \
			The panel at the bottom has several settings, marked with the letters IV, VIII, XX. Beneath them is an inscription. 'Morphological Engine'"
	icon = 'fenysha_events/icons/machinery/64x64.dmi'
	icon_state = "morf_engine"
	opacity = FALSE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	flags_1 = SUPERMATTER_IGNORES_1
	processing_flags = START_PROCESSING_MANUALLY
	base_pixel_x = -16
	pixel_x = -16

	idle_power_usage = 1 KILO WATTS
	critical_machine = TRUE

	var/enabled_power_usage = 0

	VAR_PRIVATE/list/protected_areas = null
	/// List of all zones that are under our protection
	VAR_PRIVATE/list/area_type_cache = null
	/// List of zones (including their subtypes) that will be protected by the engine
	var/list/protected_area_types = list(/area/trainstation/indoors/train)
	/// The current mode the Morphological Engine is operating in
	var/mode = NONE
	/// Whether the Morphological Engine is on
	var/on = FALSE
	/// Whether this engine is the main one
	var/main_engine = FALSE

	/// Temporary mode selected to be applied after calibration
	var/pending_mode = 0
	/// Access panel opening step (0 - closed, 1-3 - stages)
	var/access_step = 0
	/// Mode calibration step (0 - not started, 1-3 - stages)
	var/calibration_step = 0
	/// Whether the engine is damaged
	var/damaged = FALSE

	var/radio_channel = null
	/// Our radio for transmitting messages
	var/obj/item/radio/radio
	/// The key inside our radio
	var/radio_key = /obj/item/encryptionkey/headset_eng

	COOLDOWN_DECLARE(turn_power_cd)
	COOLDOWN_DECLARE(change_mode_cd)
	COOLDOWN_DECLARE(damage_khara_cd)
	COOLDOWN_DECLARE(make_dizzy_cd)

/obj/machinery/morphological_engine/Initialize(mapload)
	. = ..()
	build_area_cache()
	radio = new(src)
	radio.keyslot = new radio_key
	radio.set_listening(FALSE)
	radio.recalculateChannels()

	SSpoints_of_interest.make_point_of_interest(src)
	if(main_engine && !GLOB.main_morph_engine)
		GLOB.main_morph_engine = src

/obj/machinery/morphological_engine/Destroy(force)
	. = ..()

	if(GLOB.main_morph_engine == src)
		GLOB.main_morph_engine = null

/obj/machinery/morphological_engine/examine(mob/user)
	. = ..()
	if(on)
		. += span_warning("Your eyes strain from the attempt to observe the engine.")
		if(isliving(user))
			var/mob/living/living_user = user
			if(!living_user.is_eyes_covered())
				var/obj/item/organ/eyes/eyes = living_user.get_organ_slot(ORGAN_SLOT_EYES)
				if(eyes)
					eyes.apply_organ_damage(5)

	if(damaged)
		. += span_danger("The engine is damaged and unstable! Repair is required.")

	if(access_step > 0 || calibration_step > 0)
		. += span_notice("The control panel is open for mode configuration.")

	if(mode & MORPH_ENGINE_MODE_BARRIER)
		. += span_notice("<b>Barrier mode - enabled.</b> The engine will create a force barrier \
							that will prevent Khara mutants from physically passing through it.")
	if(mode & MORPH_ENGINE_MODE_CONTAINMENT)
		. += span_notice("<b>Containment mode - enabled.</b> The engine will emit anomalous radiation \
							that will slow the development of Khara cells within the containment zone.")
	if(mode & MORPH_ENGINE_MODE_ISOLATION)
		. += span_notice("<b>Isolation mode - enabled.</b> The engine will emit force waves - destroying Khara cells \
							within the containment zone, significantly reducing its spread. Warning - this mode \
							significantly increases power consumption and may harm all of the infected.")

	if(on)
		. += span_warning("Current power consumption: [enabled_power_usage] watts")

/obj/machinery/morphological_engine/proc/build_area_cache()
	if(!protected_area_types || !islist(protected_area_types) || !length(protected_area_types))
		return
	area_type_cache = list()
	for(var/area_type as anything in protected_area_types)
		area_type_cache |= typecacheof(area_type)

/obj/machinery/morphological_engine/proc/is_protected_area(area/A)
	if(!A)
		return FALSE
	if(!area_type_cache || !is_type_in_typecache(A.type, area_type_cache) || !protected_areas[A])
		return FALSE
	return TRUE

/obj/machinery/morphological_engine/proc/is_protected_turf(turf/T)
	if(!is_protected_area(get_area(T)))
		return FALSE
	return TRUE

/obj/machinery/morphological_engine/proc/can_block_movement(power_to_block)
	if(!(mode & MORPH_ENGINE_MODE_BARRIER) || !on || !use_energy(power_to_block))
		return FALSE
	return TRUE

/obj/machinery/morphological_engine/proc/should_slow_khara()
	return on && (mode & MORPH_ENGINE_MODE_CONTAINMENT)

/obj/machinery/morphological_engine/proc/should_kill_khara()
	return on && (mode & MORPH_ENGINE_MODE_ISOLATION)

/obj/machinery/morphological_engine/proc/turn_on(mob/user)
	if(on || damaged)
		return FALSE
	if(!COOLDOWN_FINISHED(src, turn_power_cd))
		to_chat(user, span_warning("The engine hasn't cooled down yet after the previous activation!"))
		return FALSE
	enabled_power_usage = 0

	if(mode & MORPH_ENGINE_MODE_BARRIER)
		enabled_power_usage += 20 KILO WATTS
	if(mode & MORPH_ENGINE_MODE_CONTAINMENT)
		enabled_power_usage += 40 KILO WATTS
	if(mode & MORPH_ENGINE_MODE_ISOLATION)
		enabled_power_usage += 100 KILO WATTS

	on = TRUE
	protect_areas()

	for(var/mob/living/L in GLOB.alive_player_list)
		if(!is_protected_turf(get_turf(L)))
			continue
		flash_color(L, flash_color = COLOR_NAVY, flash_time = 3 SECONDS)
		to_chat(L, span_notice("You feel exotic matter enveloping your body."))
		new /obj/effect/temp_visual/morph_engine_block(get_turf(L))

	radio.talk_into(
		src,
		"ATTENTION: Morphological Engine - activated.",
		radio_channel,
		list(SPAN_COMMAND)
	)

	update_appearance()
	begin_processing()
	visible_message(span_notice("[src] emits a low hum and activates."))
	COOLDOWN_START(src, turn_power_cd, 60 SECONDS)
	return TRUE

/obj/machinery/morphological_engine/proc/turn_off(mob/user)
	if(!on)
		return FALSE

	radio.talk_into(
		src,
		"ATTENTION: Morphological Engine - deactivated.",
		radio_channel,
		list(SPAN_COMMAND)
	)

	enabled_power_usage = 0
	on = FALSE
	update_appearance()
	end_processing()
	cleanup_areas()
	visible_message(span_notice("[src] goes quiet and deactivates."))
	COOLDOWN_START(src, turn_power_cd, 60 SECONDS)
	return TRUE

/obj/machinery/morphological_engine/proc/protect_areas()
	for(var/area_type in area_type_cache)
		var/list/instances = get_areas(area_type, FALSE)
		if(!length(instances))
			continue
		for(var/area/instance in instances)
			if(!instance || instance.z != z)
				continue
			if(should_slow_khara())
				ADD_TRAIT(instance, TRAIT_AREA_MORPENGINE, REF(src))
			if(should_kill_khara())
				ADD_TRAIT(instance, TRAIT_AREA_MORPENGINE_HAZARD, REF(src))
			LAZYADDASSOC(protected_areas, instance, TRUE)

/obj/machinery/morphological_engine/proc/cleanup_areas()
	for(var/area/A in protected_areas)
		REMOVE_TRAIT(A, TRAIT_AREA_MORPENGINE, REF(src))
		REMOVE_TRAIT(A, TRAIT_AREA_MORPENGINE_HAZARD, REF(src))
	protected_areas = null

/obj/machinery/morphological_engine/process()
	if(!on)
		return PROCESS_KILL

	if(!powered() || !use_energy(enabled_power_usage))
		balloon_alert_to_viewers("Insufficient power - shutting down!")
		turn_off()
		return


/obj/machinery/morphological_engine/attack_hand(mob/living/user, list/modifiers)
	add_fingerprint(user)
	if(access_step > 0 || calibration_step > 0)
		to_chat(user, span_warning("The panel is open - finish the configuration first!"))
		return

	if(!COOLDOWN_FINISHED(src, turn_power_cd))
		to_chat(user, span_warning("The engine hasn't cooled down yet after the previous toggle!"))
		return

	balloon_alert_to_viewers("Toggling settings!")
	if(!do_after(user, 10 SECONDS, src))
		balloon_alert_to_viewers("Toggle interrupted!")
		return
	if(on)
		balloon_alert_to_viewers("Engine - off!")
		turn_off(user)
	else
		balloon_alert_to_viewers("Engine - on!")
		turn_on(user)

/obj/machinery/morphological_engine/attackby(obj/item/I, mob/living/user, params)
	if(damaged && I.tool_behaviour != TOOL_WELDER)
		return ..()


	if(!on && access_step < 3 && calibration_step == 0)
		switch(access_step)
			if(0)
				if(I.tool_behaviour == TOOL_SCREWDRIVER)
					if(do_after(user, 2 SECONDS, target = src))
						access_step = 1
						I.play_tool_sound(src)
						to_chat(user, span_notice("You carefully unscrew the control panel fastenings."))
						visible_message(span_notice("[user] unscrews the panel on [src]."))
						return TRUE
					return

			if(1)
				if(I.tool_behaviour == TOOL_WRENCH)
					if(do_after(user, 2 SECONDS, target = src))
						access_step = 2
						I.play_tool_sound(src)
						to_chat(user, span_notice("You tighten the bolts of the internal circuits."))
						visible_message(span_notice("[user] tightens the bolts on [src]."))
						return TRUE
					return

			if(2)
				if(I.tool_behaviour == TOOL_WELDER)
					if(!I.use_tool(src, user, 3 SECONDS, volume = 50))
						return
					access_step = 3
					to_chat(user, span_notice("You weld the panel's airtight joints."))
					visible_message(span_notice("[user] welds the panel on [src]."))
					do_mode_selection(user)
					return TRUE

	if(access_step == 3 && calibration_step >= 0)
		switch(calibration_step)
			if(0)
				if(I.tool_behaviour == TOOL_SCREWDRIVER)
					if(do_after(user, 5 SECONDS, target = src))
						if(prob(20))
							fail_calibration(user)
							return TRUE
						calibration_step = 1
						I.play_tool_sound(src)
						to_chat(user, span_notice("The calibration screws are set to new positions."))
						return TRUE
					return

			if(1)
				if(I.tool_behaviour == TOOL_WRENCH)
					if(do_after(user, 5 SECONDS, target = src))
						if(prob(20))
							fail_calibration(user)
							return TRUE
						calibration_step = 2
						I.play_tool_sound(src)
						to_chat(user, span_notice("The Morph Engine's emitter mounts are securely tightened."))
						return TRUE
					return

			if(2)
				if(I.tool_behaviour == TOOL_WELDER)
					if(!I.use_tool(src, user, 8 SECONDS, volume = 60))
						return
					if(prob(20))
						fail_calibration(user)
						return TRUE

					mode = pending_mode
					access_step = 0
					calibration_step = 0
					pending_mode = 0
					visible_message(span_boldnotice("[src] emits a steady hum - calibration completed successfully!"))
					to_chat(user, span_notice("The Morphological Engine's modes have been configured successfully."))
					COOLDOWN_START(src, change_mode_cd, 30 SECONDS)
					return TRUE

	if(on)
		to_chat(user, span_warning("Configuration cannot be done while the engine is on!"))
		return ..()

	return ..()


/obj/machinery/morphological_engine/proc/create_radial_choice(name, image, info)
	var/datum/radial_menu_choice/choise = new()
	choise.name = name
	choise.info = info
	choise.image = image
	return choise

/obj/machinery/morphological_engine/proc/do_mode_selection(mob/user)
	if(access_step < 3 || !user || !Adjacent(user))
		return

	if(!pending_mode)
		pending_mode = mode

	var/continue_choosing = TRUE
	while(continue_choosing && Adjacent(user) && !QDELETED(src) && !damaged)
		for(var/i)
		var/list/radial_choices = list(
			"toggle_barrier" = create_radial_choice("Barrier ([pending_mode & MORPH_ENGINE_MODE_BARRIER ? "ON" : "OFF"])"),
			"toggle_containment" = create_radial_choice("Containment ([pending_mode & MORPH_ENGINE_MODE_CONTAINMENT ? "ON" : "OFF"])"),
			"toggle_isolation" = create_radial_choice("Isolation ([pending_mode & MORPH_ENGINE_MODE_ISOLATION ? "ON" : "OFF"])"),
			"confirm" = create_radial_choice("Confirm changes"),
		)

		var/choice = show_radial_menu(user, get_turf(src), radial_choices, radius = 24, require_near = TRUE, tooltips = TRUE)
		if(!choice || !Adjacent(user))
			continue_choosing = FALSE
			break

		switch(choice)
			if("toggle_barrier")
				pending_mode |= MORPH_ENGINE_MODE_BARRIER
				to_chat(user, span_notice("Barrier mode toggled."))
			if("toggle_containment")
				pending_mode |= MORPH_ENGINE_MODE_CONTAINMENT
				to_chat(user, span_notice("Containment mode toggled."))
			if("toggle_isolation")
				pending_mode |= MORPH_ENGINE_MODE_ISOLATION
				to_chat(user, span_notice("Isolation mode toggled."))
			if("confirm")
				if(pending_mode == mode)
					to_chat(user, span_warning("You didn't change any modes."))
					pending_mode = NONE
					return
				to_chat(user, span_boldnotice("Modes selected. Proceeding to calibration..."))
				calibration_step = 0
				continue_choosing = FALSE

/obj/machinery/morphological_engine/proc/fail_calibration(mob/user)
	visible_message(span_danger("[src] suddenly overloads! Sparks fly out of the panel!"))
	do_sparks(5, FALSE, src)
	calibration_step = 0


/obj/item/paper/guides/fenysha_events/morph_engine
	name = "Paper - \"Quick Guide to the Morphological Engine!\""
	default_raw_text = "<B>Morphological Engine - complete guide</B><BR>\
	<HR>\
	<B>Purpose</B><BR>\
	The engine protects the train's interior spaces from Khara mutation.<BR>\
	It creates force fields, anomalous radiation, and waves, blocking, slowing, and destroying Khara cells.<BR>\
	This is the main (and only) engine of the train.<BR>\
	<HR>\
	<B>Three operating modes (can be combined)</B><BR>\
	- <B>Barrier</B> (20 kW): a physical energy barrier.<BR>\
	  Khara mutants CANNOT enter the zone; a force wave throws them back.<BR>\
	  Movement inside the rooms and exiting - are free.<BR>\
	- <B>Containment</B> (40 kW): anomalous radiation.<BR>\
	  Slows the development and spread of Khara cells in the zone.<BR>\
	- <B>Isolation</B> (100 kW): force waves.<BR>\
	  Actively destroys Khara cells, greatly reducing infection.<BR>\
	  <B>WARNING:</B> very high power consumption + may harm ALL infected in the zone!<BR>\
	<HR>\
	<B>How to change modes (only when the engine is OFF)</B><BR>\
	1. Screwdriver - unscrew the panel.<BR>\
	2. Wrench - tighten the internal bolts.<BR>\
	3. Welder - weld the airtight joints.<BR>\
	4. In the menu: click the desired modes (Barrier / Containment / Isolation) - they toggle.<BR>\
		Click \"Confirm changes\".<BR>\
	5. Calibration (after confirmation):<BR>\
		- Screwdriver<BR>\
		- Wrench<BR>\
		- Welder<BR>\
	<B>WARNING:</B> there is a chance of failure at each calibration step!<BR>\
	After successful calibration, the modes are locked in.<BR>\
	<HR>\
	<B>Additional</B><BR>\
	- When activated, all living beings in the zone of effect may suffer slight malaise.<BR>\
	- If the panel is open - finish the configuration or calibration first.<BR>\
	- There is one main engine for the entire train.<BR>\
	Good luck, engineer! Don't let the Khara break through."
