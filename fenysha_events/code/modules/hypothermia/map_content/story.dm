GLOBAL_LIST_EMPTY(important_items)

/obj/item/story_pointer
	name = "important item finder"
	desc = "A handheld search sensor - capable of locating important things. Handy in your situation."
	icon = 'icons/obj/devices/tracker.dmi'
	icon_state = "pinpointer"
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	icon_state = "pinpointer_hunter"
	worn_icon_state = "pinpointer_black"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 2.5)
	sound_vary = TRUE
	pickup_sound = SFX_GENERIC_DEVICE_PICKUP
	drop_sound = SFX_GENERIC_DEVICE_DROP

	/// Maximum signal detection distance.
	var/detection_range = 200
	/// Cooldown between uses.
	var/cooldown_time = 4 SECONDS
	/// Time of the next possible use.
	var/next_use_time = 0
	/// Name of the last selected object
	var/last_tracked_name
	/// Protection against radial menu spam.
	var/radial_open = FALSE

/obj/item/story_pointer/examine(mob/user)
	. = ..()
	. += span_notice("Alt-click to reset the current target.")
	. += span_notice("Current search range: [detection_range] meters.")

/obj/item/story_pointer/click_alt(mob/user)
	if(last_tracked_name)
		last_tracked_name = null
		user.balloon_alert(user, "Target reset!")
	else ..()

/obj/item/story_pointer/attack_self(mob/living/user)
	if(world.time < next_use_time)
		user.balloon_alert(user, "too fast!")
		return

	if(radial_open)
		user.balloon_alert(user, "already selecting a target!")
		next_use_time = world.time + 1 SECONDS
		return

	var/list/important_items = get_important_items()
	if(!LAZYLEN(important_items))
		user.balloon_alert(user, "no important objects!")
		next_use_time = world.time + 1 SECONDS
		return

	var/list/choosable_targets = list()
	var/list/possible_tracked_atoms = list()

	for(var/atom/item as anything in important_items)
		if(QDELETED(item))
			continue
		var/dist = get_dist(get_turf(src), get_turf(item))
		if(dist > detection_range)
			continue // Too far away
		var/display_name = ismob(item) ? item:real_name : item.name

		choosable_targets[display_name] = image(icon = item.icon, icon_state = item.icon_state)
		possible_tracked_atoms[display_name] = item

	if(!length(choosable_targets))
		user.balloon_alert(user, "no important objects nearby!")
		next_use_time = world.time + 1 SECONDS
		return

	if(length(choosable_targets) == 1)
		for(var/name in choosable_targets)
			last_tracked_name = name
			break

	else if(isnull(last_tracked_name) || !(last_tracked_name in choosable_targets))
		radial_open = TRUE
		last_tracked_name = show_radial_menu(
			user,
			user,
			choosable_targets,
			custom_check = CALLBACK(src, PROC_REF(check_menu)),
			radius = 40,
			require_near = TRUE,
			tooltips = TRUE,
		)
		radial_open = FALSE

	if(isnull(last_tracked_name) || !(last_tracked_name in choosable_targets))
		next_use_time = world.time + 1 SECONDS
		if(last_tracked_name)
			user.balloon_alert(user, "Target lost!")
		return

	var/atom/tracked_thing = possible_tracked_atoms[last_tracked_name]
	if(QDELETED(tracked_thing))
		last_tracked_name = null
		next_use_time = world.time + 1 SECONDS
		user.balloon_alert(user, "Target lost!")
		return

	var/dist = get_dist(get_turf(src), get_turf(tracked_thing))
	if(dist > detection_range)
		last_tracked_name = null
		next_use_time = world.time + 1 SECONDS
		user.balloon_alert(user, "Target lost, too far away!")
		return

	playsound(user, 'sound/effects/singlebeat.ogg', 50, TRUE, SILENCED_SOUND_EXTRARANGE)

	var/list/tracking_info = get_tracking_info(tracked_thing, user)
	user.balloon_alert(user, tracking_info["message"])

	if(tracking_info["arrow_color"] && user.hud_used)
		new /atom/movable/screen/navigate_arrow(null, user.hud_used, get_turf(tracked_thing), tracking_info["arrow_color"])

	next_use_time = world.time + cooldown_time

/obj/item/story_pointer/proc/get_important_items()
	return list()

/obj/item/story_pointer/proc/check_menu()
	if(QDELETED(src))
		return FALSE
	return TRUE

/obj/item/story_pointer/proc/get_tracking_info(atom/tracked_thing, mob/user)
	var/list/info = list("message" = "error text!", "arrow_color" = null)

	var/turf/their_turf = get_turf(tracked_thing)
	var/turf/our_turf = get_turf(user)
	var/their_z = their_turf?.z
	var/our_z = our_turf?.z

	if(!our_z || !their_z)
		info["message"] = "in another world!"
		return info

	if(our_z != their_z)
		if(is_station_level(their_z))
			if(is_station_level(our_z))
				if(our_z > their_z)
					info["message"] = "below you!"
				else
					info["message"] = "above you!"
			else
				info["message"] = "on the station!"
		else if(is_mining_level(their_z))
			info["message"] = "on the lavaland!"
		else if(is_away_level(their_z) || is_secret_level(their_z))
			info["message"] = "in the gates!"
		else
			info["message"] = "in another world!"
		return info

	var/dist = get_dist(our_turf, their_turf)
	var/dir = get_dir(our_turf, their_turf)
	var/half_range = detection_range / 2

	if(dist > half_range)
		info["message"] = "roughly to the [dir2text(dir)]!"
		return info
	if(dist > 1)
		var/arrow_color
		switch(dist)
			if(0 to 15)
				info["message"] = "very close, [dir2text(dir)]!"
				arrow_color = COLOR_GREEN
			if(16 to 31)
				info["message"] = "close, [dir2text(dir)]!"
				arrow_color = COLOR_YELLOW
			if(32 to 127)
				info["message"] = "far, [dir2text(dir)]!"
				arrow_color = COLOR_ORANGE
			else
				info["message"] = "very far!"
				arrow_color = COLOR_RED

		info["arrow_color"] = arrow_color
	else
		info["message"] = "Right here!"

	if(ismob(tracked_thing))
		var/mob/tracked_mob = tracked_thing
		if(tracked_mob.stat == DEAD)
			info["message"] = "dead, " + info["message"]

	return info

/obj/item/story_pointer/story
	detection_range = 60

/obj/item/story_pointer/story/get_important_items()
	return GLOB.important_items.Copy()


/obj/item/keycard/important
	name = "important story keycard"
	color = COLOR_RED
	max_integrity = 250
	armor_type = /datum/armor/disk_nuclear
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/item/keycard/important/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/stationloving, TRUE)
	SSpoints_of_interest.make_point_of_interest(src)


/obj/item/keycard/important/hypothermia
	color = COLOR_BLUE_LIGHT


/obj/item/keycard/important/hypothermia/amory_key
	name = "key to the heavy armory «Zvezda»"

/obj/item/keycard/important/hypothermia/ship_control_key
	name = "«Buran» control key"
	color = COLOR_GOLD
	desc = "This is the key to the control console of the «Buran»-class colonial shuttle. Without it the shuttle simply won't start!"

/obj/item/story_item
	name = "important story item"
	max_integrity = 250
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

	var/important_text = "This is an important story item! Don't lose it!"

/obj/item/story_item/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/stationloving, TRUE)
	SSpoints_of_interest.make_point_of_interest(src)
	GLOB.important_items += src

/obj/item/story_item/Destroy(force)
	. = ..()
	GLOB.important_items -= src

/obj/item/story_item/examine(mob/user)
	. = ..()
	. += span_boldwarning(important_text)


/obj/item/story_item/hypothermia_applied_ai_core
	name = "installed AI core"
	desc = "An old positronic brain in a cracked casing. Someone has scratched «THEDRIVER» into it with a fingernail. It barely works."
	icon = 'icons/obj/devices/assemblies.dmi'
	icon_state = "spheribrain-searching"
	w_class = WEIGHT_CLASS_BULKY
	important_text = "This is the only AI module capable of piloting the colonial shuttle. Without it the ship won't take off!"


/obj/item/story_item/hypothermia_fusion_core
	name = "depleted fusion core"
	desc = "A heavy RBMK-class micro-fusion core. The last one on the colony. Cold, but the containment rings are intact. Fuel it with plasma or uranium sheets — it might work again."
	icon = 'icons/obj/devices/assemblies.dmi'
	icon_state = "syndicate-bomb-inactive-wires"
	w_class = WEIGHT_CLASS_HUGE
	throwforce = 20
	important_text = "Without a working fusion core the shuttle's engines won't get power. You won't be able to leave the planet!"

	var/refueled = FALSE

/obj/item/story_item/hypothermia_fusion_core/attackby(obj/item/W, mob/user, params)
	if(refueled)
		return ..()

	if(istype(W, /obj/item/stack/sheet/mineral/plasma))
		var/obj/item/stack/sheet/mineral/plasma/P = W
		if(P.amount >= 50)
			P.use(50)
			refueled = TRUE
			icon_state = "syndicate-bomb-active-wires"
			desc = "A heavy RBMK-class micro-fusion core. Now working — someone shoved plasma sheets into it and said a prayer."
			visible_message(span_notice("[user] shoves plasma sheets into [src]. The core begins to hum quietly."))
			return
		else
			balloon_alert(user, "Not enough material!")
	if(istype(W, /obj/item/stack/sheet/mineral/uranium))
		var/obj/item/stack/sheet/mineral/uranium/U = W
		if(U.amount >= 50)
			U.use(50)
			refueled = TRUE
			icon_state = "syndicate-bomb-active-wires"
			desc = "A heavy RBMK-class micro-fusion core. Someone welded uranium plates onto it. It's heating up dangerously... but it will give power!"
			visible_message(span_danger("[user] inserts uranium sheets into [src]. The core begins to hum quietly!"))
			return
		else
			balloon_alert(user, "Not enough material!")
	return ..()


/obj/item/story_item/hypothermia_navigation_tape
	name = "navigation tape cassette"
	desc = "A dusty magnetic tape labeled «H1132 → EARTH». The only copy of the jump coordinates out of this system. Without it the autopilot will just steer the shuttle into the Sun."
	icon = 'icons/obj/devices/circuitry_n_data.dmi'
	icon_state = "tape_yellow"
	w_class = WEIGHT_CLASS_SMALL
	important_text = "This is the only tape with Earth's coordinates! Without it the shuttle won't go anywhere and you'll burn up in hyperspace!"


/obj/item/story_item/hypothermia_thermal_regulator
	name = "main thermal regulation valve"
	desc = "A huge brass valve torn out of the colony's thermal regulation system. Without it the shuttle's engines will overheat and explode 30 seconds after launch."
	icon = 'icons/obj/devices/assemblies.dmi'
	icon_state = "valve_1"
	w_class = WEIGHT_CLASS_HUGE
	throwforce = 15
	important_text = "A critically important thermal regulation valve! Without it the shuttle's engines will explode within half a minute of flight!"


// Shuttle template
/datum/map_template/shuttle/zvezda
	port_id = "event"
	prefix = "_maps/modular_events/"
	suffix = "buran"
	name = "«Buran»-class colonial shuttle"
	description = "A «Buran»-class colonial shuttle. The only chance to leave the planet."
	width = 23
	height = 30

/obj/docking_port/mobile/buran
	name = "«Buran»-class colonial shuttle"
	shuttle_id = "event"
	width = 23
	height = 30
	movement_force = list("KNOCKDOWN" = 0,"THROW" = 0)

/obj/docking_port/stationary/zvezda_buran
	name = "«Buran» docking port"
	hidden = FALSE
	dir = WEST
	dheight = 50
	height = 60
	dwidth = 40
	width = 50
	roundstart_template = /datum/map_template/shuttle/zvezda

/obj/machinery/shuttle_launch_terminal
	name = "shuttle launch terminal"
	desc = "The launch terminal for the «Buran» shuttle. It can only be activated after all critical modules are inserted and authorization is confirmed."
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "computer"
	density = TRUE
	anchored = TRUE
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	max_integrity = 2500

	var/obj/item/story_item/hypothermia_applied_ai_core/ai_core
	var/obj/item/story_item/hypothermia_fusion_core/fusion_core
	var/obj/item/story_item/hypothermia_navigation_tape/nav_tape
	var/obj/item/story_item/hypothermia_thermal_regulator/thermal_reg

	var/ready_ai = FALSE
	var/ready_core = FALSE
	var/ready_nav = FALSE
	var/ready_therm = FALSE
	var/key_inserted = FALSE

	var/launch_time = 15 MINUTES
	var/time_left
	var/obj/docking_port/mobile/connected_port = null

	var/launching = FALSE


/obj/machinery/shuttle_launch_terminal/Initialize(mapload)
	. = ..()
	for(var/obj/docking_port/mobile/M in get_area(src))
		connected_port = M
		break

	if(!connected_port)
		stack_trace("Launch terminal placed without a mobile docking port nearby!")
	add_filter("story_outline", 2, list("type" = "outline", "color" = "#fa3b3b", "size" = 1))

/obj/machinery/shuttle_launch_terminal/Destroy(force)
	priority_announce("ALERT! ALERT! The control terminal has been destroyed. Launch is impossible.", "Priority Announcement", 'sound/effects/alert.ogg')
	. = ..()

/obj/machinery/shuttle_launch_terminal/examine(mob/user)
	. = ..()
	check_modules()
	if(!ready_ai)
		. += span_warning("Missing the installed AI core!")
	if(!ready_core)
		. += span_warning("Missing a fueled fusion core!")
	if(!ready_nav)
		. += span_warning("Missing the navigation tape!")
	if(!ready_therm)
		. += span_warning("Missing the thermal regulation valve!")
	if(key_inserted)
		. += span_notice("Key inserted.")
	else
		. += span_warning("Key not inserted.")


/obj/machinery/shuttle_launch_terminal/proc/check_modules()
	ready_ai = !!ai_core
	ready_core = !!fusion_core
	ready_nav = !!nav_tape
	ready_therm = !!thermal_reg
	return ready_ai && ready_core && ready_nav && ready_therm


/obj/machinery/shuttle_launch_terminal/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/keycard/important/hypothermia/ship_control_key))
		if(key_inserted)
			to_chat(user, span_warning("The key is already inserted."))
			return

		if(!check_modules())
			to_chat(user, span_warning("Insert all critical modules first!"))
			return

		balloon_alert(user, "Launch procedure starting!")
		visible_message(span_notice("[user] begins the launch procedure."))
		if(!do_after(user, 15 SECONDS, src))
			balloon_alert(user, "Procedure interrupted!")
			return
		balloon_alert(user, "Launching the shuttle!")
		if(!user.transferItemToLoc(W, src))
			return

		key_inserted = TRUE
		to_chat(user, span_notice("You insert the key into the terminal."))
		visible_message(span_notice("[user] inserts the control key into the launch terminal."))

		start_launch_countdown(user)
		return

	if(istype(W, /obj/item/story_item/hypothermia_applied_ai_core))
		if(ai_core)
			to_chat(user, span_warning("The AI core is already installed!"))
			return

		if(!user.transferItemToLoc(W, src))
			return

		ai_core = W
		to_chat(user, span_notice("You insert [W] into the terminal."))
		visible_message(span_notice("[user] inserts [W] into the terminal."))
		return

	if(istype(W, /obj/item/story_item/hypothermia_fusion_core))
		var/obj/item/story_item/hypothermia_fusion_core/core = W
		if(fusion_core)
			to_chat(user, span_warning("The fusion core is already installed!"))
			return

		if(!core.refueled)
			to_chat(user, span_warning("The fusion core isn't fueled!"))
			return

		if(!user.transferItemToLoc(W, src))
			return

		fusion_core = W
		to_chat(user, span_notice("You insert [W] into the terminal."))
		visible_message(span_notice("[user] inserts [W] into the terminal."))
		return

	if(istype(W, /obj/item/story_item/hypothermia_navigation_tape))
		if(nav_tape)
			to_chat(user, span_warning("The navigation tape is already inserted!"))
			return

		if(!user.transferItemToLoc(W, src))
			return

		nav_tape = W
		to_chat(user, span_notice("You insert [W] into the terminal."))
		visible_message(span_notice("[user] inserts [W] into the terminal."))
		return

	if(istype(W, /obj/item/story_item/hypothermia_thermal_regulator))
		if(thermal_reg)
			to_chat(user, span_warning("The thermal regulation valve is already installed!"))
			return

		if(!user.transferItemToLoc(W, src))
			return

		thermal_reg = W
		to_chat(user, span_notice("You insert [W] into the terminal."))
		visible_message(span_notice("[user] inserts [W] into the terminal."))
		return

	return ..()



/obj/machinery/shuttle_launch_terminal/proc/start_launch_countdown(mob/user)
	if(launching)
		return

	launching = TRUE
	time_left = launch_time

	priority_announce("Shuttle launch sequence initiated. Liftoff in 15 minutes. \
						Keep the control console secure.", "Priority Announcement", 'sound/effects/alert.ogg')

	addtimer(CALLBACK(src, PROC_REF(announce_remaining), 10), launch_time - 10 MINUTES)
	addtimer(CALLBACK(src, PROC_REF(announce_remaining), 5), launch_time - 5 MINUTES)
	addtimer(CALLBACK(src, PROC_REF(announce_remaining), 1), launch_time - 1 MINUTES)
	addtimer(CALLBACK(src, PROC_REF(launch_shuttle)), launch_time)

	if(istype(SSround_events?.active_event, /datum/full_round_event/hypothermia))
		var/datum/full_round_event/hypothermia/hypo = SSround_events.active_event
		hypo.on_buran_startup()

/obj/machinery/shuttle_launch_terminal/proc/announce_remaining(minutes)
	priority_announce("[minutes] minute[minutes > 1 ? "s" : ""] until shuttle launch.", "Priority Announcement", 'sound/effects/alert.ogg')
	if(minutes <= 1)
		var/message = "The shuttle is about to launch, just a little more and I'll survive!"
		for(var/mob/living/player in GLOB.alive_player_list)
			if(ishuman(player))
				to_chat(player, span_boldnotice(message))

/obj/machinery/shuttle_launch_terminal/proc/launch_shuttle()
	priority_announce("ATTENTION! ATTENTION! LAUNCH SEQUENCE COMPLETE. SHUTTLE LAUNCHING!", "Priority Announcement", 'sound/effects/alert.ogg')
	connected_port.destination = null
	connected_port.mode = SHUTTLE_IGNITING
	connected_port.setTimer(connected_port.ignitionTime)

	if(istype(SSround_events?.active_event, /datum/full_round_event/hypothermia))
		var/datum/full_round_event/hypothermia/hypo = SSround_events.active_event
		hypo.on_buran_launch()

/obj/item/climbing_hook/emergency/safeguard
	name = "safety belay hook"
	desc = "An emergency belay hook that triggers automatically when its owner falls into a chasm, pulling them to safety but causing injuries."
	icon_state = "climbingrope_s"
	slot_flags = ITEM_SLOT_BELT
	var/attempting = FALSE	// To avoid infinite loops
	var/dropping = FALSE

/obj/item/climbing_hook/emergency/safeguard/examine(mob/user)
	. = ..()
	. += span_warning("[name] must be worn on the belt for it to save its owner from falling!")

/obj/item/climbing_hook/emergency/safeguard/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_BELT && isliving(user))
		RegisterSignal(user, COMSIG_MOVABLE_CHASM_DROPPED, PROC_REF(on_chasm_drop))

/obj/item/climbing_hook/emergency/safeguard/dropped(mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_MOVABLE_CHASM_DROPPED)

/obj/item/climbing_hook/emergency/safeguard/proc/on_chasm_drop(mob/living/user, turf/chasm_turf)
	SIGNAL_HANDLER
	if(user.stat == DEAD || attempting || dropping)
		return
	attempting = TRUE
	addtimer(CALLBACK(src, PROC_REF(try_rescue), user, chasm_turf), 0)
	return COMPONENT_NO_CHASM_DROP

/obj/item/climbing_hook/emergency/safeguard/proc/try_rescue(mob/living/user, turf/chasm_turf)
	var/list/possible_turfs = list()
	for(var/turf/T in orange(2, chasm_turf))
		if(!T.density && !(ischasm(T) && !HAS_TRAIT(T, TRAIT_CHASM_STOPPED)) && isopenturf(T))
			possible_turfs += T
	if(!length(possible_turfs))
		drop_back(user, chasm_turf)
		return
	var/turf/safe_turf = pick(possible_turfs)
	if(!safe_turf)
		drop_back(user, chasm_turf)
		return
	rescue_user(user, chasm_turf, safe_turf)
	attempting = FALSE

/obj/item/climbing_hook/emergency/safeguard/proc/rescue_user(mob/living/user, turf/chasm_turf, turf/safe_turf)
	chasm_turf.Beam(safe_turf, icon_state = "zipline_hook", time = 1 SECONDS)
	playsound(user, 'sound/items/weapons/zipline_fire.ogg', 50)
	chasm_turf.visible_message(span_warning("A safety line shoots out of [user] and latches onto [safe_turf]! [user] climbs to safety!"))
	user.take_bodypart_damage(20)
	user.throw_at(safe_turf, get_dist(user, safe_turf), 1, src, FALSE, TRUE)
	user.forceMove(safe_turf)
	user.Paralyze(5 SECONDS)
	var/datum/component/chasm/chasm_comp = chasm_turf.GetComponent(/datum/component/chasm)
	chasm_comp?.falling_atoms -= WEAKREF(user)

/obj/item/climbing_hook/emergency/safeguard/proc/drop_back(mob/living/user, turf/chasm_turf)
	attempting = FALSE
	var/datum/component/chasm/chasm_comp = chasm_turf.GetComponent(/datum/component/chasm)
	chasm_comp?.falling_atoms -= WEAKREF(user)
	dropping = TRUE
	chasm_comp?.drop(user)
	dropping = FALSE
