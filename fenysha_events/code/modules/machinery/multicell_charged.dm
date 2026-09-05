/obj/machinery/cell_charger_multi
	name = "multi-charge battery rack"
	desc = "A charging rack capable of charging several batteries at once."
	icon = 'fenysha_events/icons/machinery/multicharger.dmi'
	icon_state = "cchargermulti"
	base_icon_state = "cchargermulti"
	use_power = IDLE_POWER_USE
	idle_power_usage = 5
	active_power_usage = 60
	power_channel = AREA_USAGE_EQUIP
	circuit = /obj/item/circuitboard/machine/cell_charger_multi
	pass_flags = PASSTABLE
	/// List of batteries currently charging
	var/list/charging_batteries = list()
	/// Maximum number of batteries that can charge at once
	var/max_batteries = 4
	/// Base charge rate (at spawn)
	var/charge_rate = STANDARD_CELL_RATE

/obj/machinery/cell_charger_multi/update_overlays()
	. = ..()

	if(!charging_batteries.len)
		return

	for(var/i = charging_batteries.len, i >= 1, i--)
		var/obj/item/stock_parts/power_store/cell/charging = charging_batteries[i]
		var/newlevel = round(charging.percent() * 4 / 100)
		var/mutable_appearance/charge_overlay = mutable_appearance(icon, "[base_icon_state]-o[newlevel]")
		var/mutable_appearance/cell_overlay = mutable_appearance(icon, "[base_icon_state]-cell")
		charge_overlay.pixel_x = 5 * (i - 1)
		cell_overlay.pixel_x = 5 * (i - 1)
		. += new /mutable_appearance(charge_overlay)
		. += new /mutable_appearance(cell_overlay)

/obj/machinery/cell_charger_multi/click_alt(mob/user)
	if(!can_interact(user) || !charging_batteries.len)
		return
	to_chat(user, span_notice("You press the quick-eject button - all the batteries pop out!"))
	for(var/i in charging_batteries)
		removecell()
	return CLICK_ACTION_SUCCESS

/obj/machinery/cell_charger_multi/examine(mob/user)
	. = ..()
	if(!charging_batteries.len)
		. += "There are no batteries in the device."
	else
		. += "The device contains [charging_batteries.len] [charging_batteries.len == 1 ? "battery" : "batteries"]."
		for(var/obj/item/stock_parts/power_store/cell/charging in charging_batteries)
			. += "The slot holds [charging], current charge: [round(charging.percent(), 1)]%."
	if(in_range(user, src) || isobserver(user))
		. += span_notice("The indicator reads: Charge power <b>[display_power(charge_rate, convert = FALSE)]</b> per cell.")
	. += span_notice("Alt+click to instantly eject all batteries!")

/obj/machinery/cell_charger_multi/attackby(obj/item/tool, mob/user, params)
	if(istype(tool, /obj/item/stock_parts/power_store/cell) && !panel_open)
		if(machine_stat & BROKEN)
			to_chat(user, span_warning("[src] is broken!"))
			return
		if(!anchored)
			to_chat(user, span_warning("[src] isn't bolted to the floor!"))
			return
		var/obj/item/stock_parts/power_store/cell/inserting_cell = tool
		if(inserting_cell.chargerate <= 0)
			to_chat(user, span_warning("[inserting_cell] can't be charged!"))
			return
		if(length(charging_batteries) >= max_batteries)
			to_chat(user, span_warning("[src] is completely full, no more batteries will fit!"))
			return
		else
			var/area/current_area = loc.loc
			if(!isarea(current_area))
				return
			if(current_area.power_equip == 0)
				to_chat(user, span_warning("[src] flashes red when you try to insert the battery!"))
				return
			if(!user.transferItemToLoc(tool, src))
				return

			charging_batteries += tool
			user.visible_message(span_notice("[user] inserts a battery into [src]."), span_notice("You insert a battery into [src]."))
			update_appearance()
	else
		if(!charging_batteries.len && default_deconstruction_screwdriver(user, icon_state, icon_state, tool))
			return
		if(default_deconstruction_crowbar(tool))
			return
		if(!charging_batteries.len && default_unfasten_wrench(user, tool))
			return
		return ..()

/obj/machinery/cell_charger_multi/process(seconds_per_tick)
	if(!charging_batteries.len || !anchored || (machine_stat & (BROKEN|NOPOWER)))
		return

	// Build a queue only from batteries that aren't fully charged yet
	var/list/charging_queue
	for(var/obj/item/stock_parts/power_store/cell/battery_slot in charging_batteries)
		if(battery_slot.percent() >= 100)
			continue
		LAZYADD(charging_queue, battery_slot)

	if(!LAZYLEN(charging_queue))
		return

	// Small consumption for the rack itself + scaling based on the number of batteries
	use_energy(charge_rate / length(charging_queue) * seconds_per_tick * 0.01)

	for(var/obj/item/stock_parts/power_store/cell/charging_cell in charging_queue)
		charge_cell(charge_rate * seconds_per_tick, charging_cell)

	LAZYNULL(charging_queue)
	update_appearance()

/obj/machinery/cell_charger_multi/attack_tk(mob/user)
	if(!charging_batteries.len)
		return

	to_chat(user, span_notice("You telekinetically extract [removecell(user)] from [src]."))

	return COMPONENT_CANCEL_ATTACK_CHAIN

/obj/machinery/cell_charger_multi/RefreshParts()
	. = ..()
	var/tier_total
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		tier_total += capacitor.tier
	charge_rate = tier_total * (initial(charge_rate) / 6)

/obj/machinery/cell_charger_multi/emp_act(severity)
	. = ..()

	if(machine_stat & (BROKEN|NOPOWER) || . & EMP_PROTECT_CONTENTS)
		return

	for(var/obj/item/stock_parts/power_store/cell/charging in charging_batteries)
		charging.emp_act(severity)

/obj/machinery/cell_charger_multi/on_deconstruction(disassembled)
	for(var/obj/item/stock_parts/power_store/cell/charging in charging_batteries)
		charging.forceMove(drop_location())
	charging_batteries = null
	return ..()

/obj/machinery/cell_charger_multi/attack_ai(mob/user)
	return

/obj/machinery/cell_charger_multi/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	var/obj/item/stock_parts/power_store/cell/charging = removecell(user)

	if(!charging)
		return

	user.put_in_hands(charging)
	charging.add_fingerprint(user)

	user.visible_message(span_notice("[user] removes [charging] from [src]."), span_notice("You remove [charging] from [src]."))

/obj/machinery/cell_charger_multi/proc/removecell(mob/user)
	if(!charging_batteries.len)
		return FALSE
	var/obj/item/stock_parts/power_store/cell/charging
	if(charging_batteries.len > 1 && user)
		var/list/buttons = list()
		for(var/obj/item/stock_parts/power_store/cell/battery in charging_batteries)
			buttons["[battery.name] ([round(battery.percent(), 1)]%)"] = battery
		var/cell_name = tgui_input_list(user, "Select a battery to remove.", "Remove Battery", buttons)
		if(!in_range(loc, user))
			return FALSE
		charging = buttons[cell_name]
	else
		charging = charging_batteries[1]
	if(!charging)
		return FALSE
	charging.forceMove(drop_location())
	charging.update_appearance()
	charging_batteries -= charging
	update_appearance()
	return charging

/obj/machinery/cell_charger_multi/Destroy()
	for(var/obj/item/stock_parts/power_store/cell/charging in charging_batteries)
		QDEL_NULL(charging)
	charging_batteries = null
	return ..()

/obj/item/circuitboard/machine/cell_charger_multi
	name = "Multi-Charge Rack (board)"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/cell_charger_multi
	req_components = list(/datum/stock_part/capacitor = 6)
	needs_anchored = FALSE


/datum/design/board/cell_charger_multi
	name = "Machine Blueprint (multi-charge rack board)"
	desc = "A board for creating a multi-charge battery rack."
	id = "multi_cell_charger"
	build_path = /obj/item/circuitboard/machine/cell_charger_multi
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING


/**
 * Wall-mounted version
 */

/obj/machinery/cell_charger_multi/wall_mounted
	name = "wall-mounted multi-charge rack"
	desc = "An innovative battery charging rack, neatly mounted on the wall and taking up no floor space!"
	icon = 'fenysha_events/icons/machinery/wallmounted/cell_charger.dmi'
	icon_state = "wall_charger"
	base_icon_state = "wall_charger"
	circuit = null
	max_batteries = 3
	charge_rate = STANDARD_CELL_RATE * 3
	var/repacked_type = /obj/item/wallframe/cell_charger_multi

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/cell_charger_multi/wall_mounted, 29)

/obj/machinery/cell_charger_multi/wall_mounted/Initialize(mapload)
	. = ..()
	if(mapload)
		find_and_mount_on_atom()

/obj/machinery/cell_charger_multi/wall_mounted/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	user.balloon_alert(user, "disassembling...")
	tool.play_tool_sound(src)
	if(tool.use_tool(src, user, 1 SECONDS))
		playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
		deconstruct(TRUE)
		return

// Disable the standard disassembly methods
/obj/machinery/cell_charger_multi/wall_mounted/default_deconstruction_screwdriver(mob/user, icon_state_open, icon_state_closed, obj/item/screwdriver)
	return NONE

/obj/machinery/cell_charger_multi/wall_mounted/default_deconstruction_crowbar(obj/item/crowbar, ignore_panel, custom_deconstruct)
	return NONE

/obj/machinery/cell_charger_multi/wall_mounted/default_pry_open(obj/item/crowbar, close_after_pry, open_density, closed_density)
	return NONE

/obj/machinery/cell_charger_multi/wall_mounted/on_deconstruction(disassembled)
	if(disassembled)
		new repacked_type(drop_location())

/obj/machinery/cell_charger_multi/wall_mounted/RefreshParts()
	. = ..()
	charge_rate = STANDARD_CELL_RATE * 3

/obj/item/wallframe/cell_charger_multi
	name = "unpacked wall-mounted multi-charge rack"
	desc = "An innovative battery charging rack in its packaging - ready to be mounted on the wall."
	icon = 'fenysha_events/icons/machinery/wallmounted/cell_charger.dmi'
	icon_state = "packed"
	w_class = WEIGHT_CLASS_NORMAL
	result_path = /obj/machinery/cell_charger_multi/wall_mounted
	pixel_shift = 29
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1,
	)

MAPPING_DIRECTIONAL_HELPERS(/obj/item/wallframe/cell_charger_multi, 27)
