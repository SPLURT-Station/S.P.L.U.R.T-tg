/obj/machinery/ammo_workbench
	name = "ammo workbench"
	desc = "A machine that vaguely resembles a lathe, designed exclusively for manufacturing ammunition. \
			It has a slot for magazines, ammo boxes, clips - anything that can hold ammunition."
	icon = 'fenysha_events/icons/machinery/ammo_workbench.dmi'
	icon_state = "ammobench"
	density = TRUE
	use_power = IDLE_POWER_USE
	circuit = /obj/item/circuitboard/machine/ammo_workbench

	var/busy = FALSE
	var/hacked = FALSE
	var/disabled = FALSE
	var/shocked = FALSE

	var/hack_wire
	var/disable_wire
	var/shock_wire

	var/error_message = ""
	var/error_type = ""
	var/disk_error = ""
	var/disk_error_type = ""

	var/timer_id

	var/turbo_boost = FALSE

	var/obj/item/ammo_box/loaded_magazine = null
	var/obj/item/disk/ammo_workbench/advanced/loaded_datadisk = null

	/// List of all possible round types (typepaths)
	var/list/possible_ammo_types = list()
	/// Filtered allowed casing/round types
	var/list/valid_casings = list()
	/// Strings with material costs for the interface
	var/list/casing_mat_strings = list()

	var/allowed_harmful = TRUE
	var/allowed_advanced = TRUE
	var/allowed_antikhara = FALSE

	var/list/loaded_datadisks = list()

	var/creation_efficiency = 0.8
	var/time_per_round = 1.8 SECONDS

	var/base_efficiency = 0.8
	var/base_time_per_round = 1.8 SECONDS
	var/turbo_time_per_round = 0.225 SECONDS
	var/turbo_efficiency = 1.4

	/// Mode that completely ignores restrictions (dangerous!)
	var/adminbus = FALSE

	/// Material container
	var/datum/material_container/materials

/obj/machinery/ammo_workbench/unlocked
	allowed_harmful = TRUE
	allowed_advanced = TRUE

/obj/item/circuitboard/machine/ammo_workbench
	name = "Ammo Workbench Board"
	icon_state = "circuit_map"
	build_path = /obj/machinery/ammo_workbench
	req_components = list(
		/datum/stock_part/servo = 2,
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/micro_laser = 2
	)

/obj/machinery/ammo_workbench/Initialize(mapload)
	. = ..()
	materials = new ( \
		src, \
		SSmaterials.flat_materials, \
		0, \
		MATCONTAINER_EXAMINE|MATCONTAINER_ACCEPT_ALLOYS, \
	)
	RefreshParts()
	set_wires(new /datum/wires/ammo_workbench(src))

/obj/machinery/ammo_workbench/Destroy()
	QDEL_NULL(wires)
	if(timer_id)
		deltimer(timer_id)
		timer_id = null
	if(loaded_magazine)
		loaded_magazine.forceMove(drop_location())
		loaded_magazine = null
	return ..()

/obj/machinery/ammo_workbench/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("The display shows: stores up to <b>[materials.max_amount / SHEET_MATERIAL_AMOUNT]</b> sheets of material.<br>Material consumption: <b>[creation_efficiency*100]%</b>.")

/obj/machinery/ammo_workbench/RefreshParts()
	. = ..()

	// Time per round
	var/time_eff = 1.8 SECONDS
	for(var/datum/stock_part/micro_laser/L in component_parts)
		time_eff -= L.tier * 0.4 SECONDS  // two lasers -> maximum -1.6s

	time_per_round = clamp(time_eff, 0.2 SECONDS, 20 SECONDS)
	base_time_per_round = time_per_round
	turbo_time_per_round = time_eff / 8

	// Material consumption efficiency
	var/eff = 1.4
	for(var/datum/stock_part/servo/S in component_parts)
		eff -= S.tier * 0.1  // two servos -> maximum -0.4 -> 1.0 -> 0.6 etc.

	creation_efficiency = max(0.1, eff)
	base_efficiency = creation_efficiency
	turbo_efficiency = creation_efficiency * 2

	// Storage capacity
	var/cap = 0
	for(var/datum/stock_part/matter_bin/B in component_parts)
		cap += B.tier * 40 * SHEET_MATERIAL_AMOUNT

	materials.max_amount = cap

	toggle_turbo_boost(forced_off = TRUE)
	update_ammotypes()

/obj/machinery/ammo_workbench/proc/update_ammotypes()
	LAZYCLEARLIST(valid_casings)
	LAZYCLEARLIST(casing_mat_strings)

	if(!loaded_magazine)
		return

	var/obj/item/ammo_casing/base_type = loaded_magazine.ammo_type
	var/caliber = initial(base_type.caliber)

	if(loaded_magazine && caliber)
		possible_ammo_types = typesof(base_type)
	else
		possible_ammo_types = list(base_type)

	for(var/path in possible_ammo_types)
		if(!initial(path:projectile_type))
			continue
		if(initial(path:anti_khara) && !allowed_antikhara)
			continue

		// Get the materials
		var/obj/item/ammo_casing/temp = new path
		var/list/raw = temp.get_material_composition()
		qdel(temp)

		var/list/eff_cost = list()
		var/tooltip = ""
		for(var/mat_ref in raw)
			var/amt = raw[mat_ref] * creation_efficiency
			eff_cost[mat_ref] = amt

			var/datum/material/M = SSmaterials.get_material(mat_ref)
			tooltip += "[amt / SHEET_MATERIAL_AMOUNT] × [M.name]"
			if(length(eff_cost) < length(raw))
				tooltip += ", "

		valid_casings += path
		valid_casings[path] = initial(path:name)
		casing_mat_strings += tooltip

/obj/machinery/ammo_workbench/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AmmoWorkbench")
		ui.open()


	if(shocked)
		shock(user, 80)


/obj/machinery/ammo_workbench/ui_data(mob/user)
	var/list/data = list()

	data["loaded_datadisks"] = list()
	data["datadisk_loaded"] = !!loaded_datadisk
	data["datadisk_name"] = loaded_datadisk ? initial(loaded_datadisk.name) : null
	data["datadisk_desc"] = loaded_datadisk ? initial(loaded_datadisk.desc) : null

	data["disk_error"] = disk_error
	data["disk_error_type"] = disk_error_type

	for(var/dtype in loaded_datadisks)
		data["loaded_datadisks"] += list(list(
			"loaded_disk_name" = initial(dtype:name),
			"loaded_disk_desc" = initial(dtype:desc)
		))

	data["mag_loaded"] = !!loaded_magazine
	data["error"] = error_message
	data["error_type"] = error_type
	data["system_busy"] = busy

	if(!error_message)
		if(busy)
			data["error"] = "SYSTEM BUSY"
		else if(!loaded_magazine)
			data["error"] = "NO MAGAZINE INSERTED"

	data["efficiency"] = creation_efficiency
	data["time"] = time_per_round / 10
	data["hacked"] = hacked
	data["turboBoost"] = turbo_boost

	// Materials
	data["materials"] = list()
	for(var/mat_ref in materials.materials)
		var/datum/material/M = mat_ref
		var/raw_amt = materials.materials[mat_ref]
		data["materials"] += list(list(
			"name" = M.name,
			"id" = REF(M),
			"amount" = raw_amt / SHEET_MATERIAL_AMOUNT
		))

	if(loaded_magazine)
		data["mag_name"] = loaded_magazine.name
		data["current_rounds"] = length(loaded_magazine.stored_ammo)
		data["max_rounds"] = loaded_magazine.max_ammo

		data["available_rounds"] = list()
		for(var/i in 1 to length(valid_casings))
			var/path = valid_casings[i]
			data["available_rounds"] += list(list(
				"name" = valid_casings[path],
				"typepath" = "[path]",
				"mats_list" = casing_mat_strings[i]
			))

	return data

/obj/machinery/ammo_workbench/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("EjectMag")
			ejectItem(usr)
			. = TRUE

		if("FillMagazine")
			var/path = text2path(params["selected_type"])
			if(path)
				fill_magazine_start(path)
			. = TRUE

		if("Release")
			var/datum/material/M = locate(params["id"])
			if(!M || !materials.materials[M])
				return

			var/sheets = CEILING(materials.materials[M] / SHEET_MATERIAL_AMOUNT, 1)
			var/want = text2num(params["sheets"]) || 50
			var/take = min(want, 50, sheets)

			materials.retrieve_stack(take, M, drop_location())
			. = TRUE

		if("turboBoost")
			toggle_turbo_boost()
			. = TRUE

		if("ReadDisk")
			loadDisk()
			. = TRUE

		if("EjectDisk")
			ejectDisk()
			. = TRUE

/obj/machinery/ammo_workbench/proc/toggle_turbo_boost(forced_off = FALSE)
	if(forced_off)
		turbo_boost = FALSE
	else
		turbo_boost = !turbo_boost

	if(turbo_boost)
		time_per_round = turbo_time_per_round
		creation_efficiency = turbo_efficiency
	else
		time_per_round = base_time_per_round
		creation_efficiency = base_efficiency

	update_ammotypes()
	SStgui.update_uis(src)

/obj/machinery/ammo_workbench/proc/ejectItem(mob/user)
	if(!loaded_magazine)
		return

	loaded_magazine.forceMove(drop_location())
	if(user?.Adjacent(src))
		user.put_in_hands(loaded_magazine)

	loaded_magazine = null
	busy = FALSE
	error_message = ""
	error_type = ""
	if(timer_id)
		deltimer(timer_id)
		timer_id = null

	update_ammotypes()
	update_appearance()
	to_chat(user, span_notice("You removed the container from the workbench."))

/obj/machinery/ammo_workbench/proc/fill_magazine_start(casing_path)
	if(machine_stat & (NOPOWER|BROKEN) || busy)
		return

	if(!(casing_path in possible_ammo_types))
		error_message = "INCOMPATIBLE AMMUNITION TYPE"
		error_type = "bad"
		return

	var/obj/item/ammo_casing/C = casing_path

	if(initial(C.harmful) && !allowed_harmful && !hacked)
		error_message = "SECURITY VIOLATION DETECTED"
		error_type = "bad"
		return

	if(initial(C.anti_khara) && !allowed_antikhara)
		error_message = "CANNOT PRINT WITHOUT UPGRADE"
		error_type = "bad"
		return

	if(!loaded_magazine)
		error_message = "NO MAGAZINE INSERTED"
		error_type = ""
		return

	if(loaded_magazine.stored_ammo.len >= loaded_magazine.max_ammo)
		error_message = "CONTAINER FULL"
		error_type = "good"
		return

	busy = TRUE
	error_message = ""
	error_type = ""

	timer_id = addtimer(CALLBACK(src, PROC_REF(fill_round), casing_path), time_per_round, TIMER_STOPPABLE)

/obj/machinery/ammo_workbench/proc/fill_round(casing_path)
	if(machine_stat & (NOPOWER|BROKEN) || QDELETED(loaded_magazine))
		ammo_fill_finish(FALSE)
		return

	var/obj/item/ammo_casing/new_casing = new casing_path

	var/list/raw_cost = new_casing.get_material_composition()
	var/list/cost = list()
	for(var/mat_ref in raw_cost)
		cost[mat_ref] = raw_cost[mat_ref] * creation_efficiency

	if(!materials.has_materials(cost))
		error_message = "INSUFFICIENT MATERIALS"
		error_type = "bad"
		qdel(new_casing)
		ammo_fill_finish(FALSE)
		return

	if(!loaded_magazine.give_round(new_casing))
		error_message = "INCOMPATIBLE ROUND TYPE"
		error_type = "bad"
		qdel(new_casing)
		ammo_fill_finish(FALSE)
		return

	materials.use_materials(cost)
	new_casing.set_custom_materials(cost)

	loaded_magazine.update_appearance()
	flick("ammobench_process", src)
	use_energy(3000 JOULES)
	playsound(loc, 'sound/machines/piston/piston_raise.ogg', 60, TRUE)

	if(loaded_magazine.stored_ammo.len >= loaded_magazine.max_ammo)
		error_message = "CONTAINER FILLED"
		error_type = "good"
		ammo_fill_finish(TRUE)
		return

	timer_id = addtimer(CALLBACK(src, PROC_REF(fill_round), casing_path), time_per_round, TIMER_STOPPABLE)

/obj/machinery/ammo_workbench/proc/ammo_fill_finish(success = TRUE)
	SStgui.update_uis(src)
	playsound(loc, success ? 'sound/machines/ping.ogg' : 'sound/machines/buzz/buzz-sigh.ogg', 40, TRUE)
	busy = FALSE
	if(timer_id)
		deltimer(timer_id)
		timer_id = null
	update_appearance()

/obj/machinery/ammo_workbench/proc/Insert_Item(obj/item/I, mob/living/user)
	if(user.combat_mode)
		return FALSE

	if(istype(I, /obj/item/ammo_box))
		if(!user.transferItemToLoc(I, src))
			return FALSE

		if(loaded_magazine)
			to_chat(user, span_notice("You quickly swapped [loaded_magazine] for [I]."))
			loaded_magazine.forceMove(drop_location())
			user.put_in_hands(loaded_magazine)

		loaded_magazine = I
		to_chat(user, span_notice("You inserted [I] into the workbench's receiver."))
		flick("h_lathe_load", src)
		update_appearance()
		update_ammotypes()
		playsound(loc, 'sound/items/weapons/autoguninsert.ogg', 35, TRUE)
		return TRUE

	if(istype(I, /obj/item/disk/ammo_workbench))
		if(loaded_datadisk)
			to_chat(user, span_warning("[src] already contains a disk."))
			return FALSE
		if(!user.transferItemToLoc(I, src))
			return FALSE

		loaded_datadisk = I
		to_chat(user, span_notice("You inserted [I] into the disk drive."))
		flick("h_lathe_load", src)
		playsound(loc, 'sound/machines/terminal/terminal_insert_disc.ogg', 35, TRUE)
		loadDisk()
		return TRUE

	return FALSE

/obj/machinery/ammo_workbench/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "[initial(icon_state)]_t", initial(icon_state), I))
		return
	if(default_deconstruction_crowbar(I))
		return
	if(panel_open && is_wire_tool(I))
		wires.interact(user)
		return TRUE

	if(Insert_Item(I, user))
		return TRUE

	return ..()

/obj/machinery/ammo_workbench/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!can_interact(user))
		return
	ejectItem(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/ammo_workbench/proc/loadDisk()
	if(!loaded_datadisk)
		disk_error = "NO DISK INSERTED"
		disk_error_type = "bad"
		return FALSE

	if(loaded_datadisk.type in loaded_datadisks)
		disk_error = "DISK DATA ALREADY LOADED"
		disk_error_type = "bad"
		return FALSE

	disk_error = "DISK LOADED SUCCESSFULLY"
	disk_error_type = "good"
	loaded_datadisk.on_bench_install(src)
	loaded_datadisks += loaded_datadisk.type
	SStgui.update_uis(src)
	return TRUE

/obj/machinery/ammo_workbench/proc/ejectDisk()
	if(!loaded_datadisk)
		return
	loaded_datadisk.forceMove(drop_location())
	loaded_datadisk = null
	disk_error = ""
	disk_error_type = ""
	SStgui.update_uis(src)

/obj/machinery/ammo_workbench/shock(mob/living/shocking, chance, shock_source, siemens_coeff)
	. = ..()

	if(machine_stat & (BROKEN|NOPOWER))
		return FALSE
	if(!prob(chance))
		return FALSE
	do_sparks(5, TRUE, src)
	return electrocute_mob(shocking, get_area(src), src, 0.7, TRUE)

/datum/wires/ammo_workbench
	holder_type = /obj/machinery/ammo_workbench
	proper_name = "Ammo Workbench"

/datum/wires/ammo_workbench/New(atom/holder)
	wires = list(WIRE_HACK, WIRE_DISABLE, WIRE_SHOCK, WIRE_ZAP)
	add_duds(6)
	..()

/datum/wires/ammo_workbench/on_pulse(wire)
	var/obj/machinery/ammo_workbench/A = holder
	switch(wire)
		if(WIRE_HACK)
			A.adjust_hacked(!A.hacked)
			addtimer(CALLBACK(A, TYPE_PROC_REF(/obj/machinery/ammo_workbench, reset), wire), 6 SECONDS)
		if(WIRE_SHOCK)
			A.shocked = !A.shocked
			addtimer(CALLBACK(A, TYPE_PROC_REF(/obj/machinery/ammo_workbench, reset), wire), 6 SECONDS)
		if(WIRE_DISABLE)
			A.disabled = !A.disabled
			addtimer(CALLBACK(A, TYPE_PROC_REF(/obj/machinery/ammo_workbench, reset), wire), 6 SECONDS)

/datum/wires/ammo_workbench/on_cut(wire, mend, mob/living/source)
	var/obj/machinery/ammo_workbench/A = holder
	switch(wire)
		if(WIRE_HACK)
			A.adjust_hacked(!mend)
		if(WIRE_SHOCK)
			A.shocked = !mend
		if(WIRE_DISABLE)
			A.disabled = !mend

/obj/machinery/ammo_workbench/proc/reset(wire)
	switch(wire)
		if(WIRE_HACK)
			if(!wires.is_cut(wire))
				adjust_hacked(FALSE)
		if(WIRE_SHOCK)
			if(!wires.is_cut(wire))
				shocked = FALSE
		if(WIRE_DISABLE)
			if(!wires.is_cut(wire))
				disabled = FALSE

/obj/machinery/ammo_workbench/proc/adjust_hacked(state)
	hacked = state

/obj/item/disk/ammo_workbench
	name = "ammo blueprint disk"
	desc = "You shouldn't be seeing this."

/obj/item/disk/ammo_workbench/advanced
	name = "advanced ammo disk"
	desc = "Contains data for manufacturing lethal and special ammunition types. Using it may compromise security settings."

/obj/item/disk/ammo_workbench/advanced/proc/on_bench_install(obj/machinery/ammo_workbench/bench)
	bench.allowed_harmful = TRUE
	bench.allowed_advanced = TRUE
	bench.update_ammotypes()
