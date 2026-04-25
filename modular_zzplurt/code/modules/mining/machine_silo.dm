// Makes Ore Silos fire- and acid-proof, and increases their durability. //
/obj/machinery/ore_silo
	desc = "An all-in-one bluespace storage and transmission system for the station's mineral distribution needs. It appears to be extremely robust."
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	max_integrity = 500

/obj/machinery/ore_silo/away
	name = "ore silo"
	desc = "An all-in-one bluespace storage and transmission system for the station's mineral distribution needs. Configured to automatically link with onboard fabrication equipment. It appears to be extremely robust."
	ID_required = FALSE

	/// Enable auto-linking for same z-level machines
	var/auto_link_same_z = TRUE
	/// How often to rescan (in deciseconds, 50 = 5 seconds)
	var/auto_link_interval = 50
	var/network_id = null

	/// Types that are allowed to auto-link
	var/list/auto_link_types = list(
	/obj/machinery/rnd/production/protolathe,
	/obj/machinery/rnd/production/circuit_imprinter,
	/obj/machinery/rnd/production/techfab
	)

/obj/machinery/ore_silo/away/Initialize(mapload)
	. = ..()

	if(auto_link_same_z)
		// Start AFTER everything spawns
		addtimer(CALLBACK(src, PROC_REF(auto_link_loop)), 20)

	if(network_id)
		addtimer(CALLBACK(src, PROC_REF(link_network)), 1)

	if(mapload)
		GLOB.ore_silo_default = src

/obj/machinery/ore_silo/away/proc/link_network()
	var/list/network = GLOB.ore_silo_networks[network_id]
	if(!network)
		return

	for(var/datum/component/remote_materials/R as anything in network)
		if(!R.silo && R.parent)
			connect_receptacle(R, R.parent)

/obj/machinery/ore_silo/away/proc/start_auto_linking()
	if(QDELETED(src))
		return

	auto_link_scan()

	// Scan multiple times while shuttle is active
	addtimer(CALLBACK(src, PROC_REF(start_auto_linking)), auto_link_interval)

/obj/machinery/ore_silo/away/proc/auto_link_scan()
	for(var/obj/machinery/M in world)
		if(QDELETED(M))
			continue

		if(M.z != src.z)
			continue

		if(!is_type_in_list(M, auto_link_types))
			continue

		// Optional: restrict to same area (recommended for shuttles)
		if(get_area(M) != get_area(src))
			continue

		if(has_receptacle_for(M))
			continue

		var/datum/component/remote_materials/R = M.GetComponent(/datum/component/remote_materials)

		if(!R)
			continue

		connect_receptacle(R, M)

/obj/machinery/ore_silo/away/proc/auto_link_loop()
	if(QDELETED(src))
		return

	auto_link_scan()

	// Keep scanning forever (or until destroyed)
	addtimer(CALLBACK(src, PROC_REF(auto_link_loop)), auto_link_interval)

/obj/machinery/ore_silo/away/proc/has_receptacle_for(atom/movable/M)
	for(var/datum/component/remote_materials/R as anything in ore_connected_machines)
		if(R.parent == M)
			return TRUE
	return FALSE

/datum/component/remote_materials/networked
	var/network_id = null

/datum/component/remote_materials/networked/Initialize(...)
	. = ..()

	if(network_id)
		if(!GLOB.ore_silo_networks[network_id])
			GLOB.ore_silo_networks[network_id] = list()

		GLOB.ore_silo_networks[network_id] += src

		try_link_to_silo()

/datum/component/remote_materials/networked/proc/try_link_to_silo()
	for(var/obj/machinery/ore_silo/away/S in world)
		if(S.network_id == network_id)
			if(!src.silo && src.parent)
				S.connect_receptacle(src, src.parent)

/datum/component/remote_materials/networked/Destroy()
	if(network_id && GLOB.ore_silo_networks[network_id])
		GLOB.ore_silo_networks[network_id] -= src

	return ..()

// ========================================
// CUSTOM ORE SILO WITH CONFIGURABLE MATERIALS
// Compatible with component-based material_container
// ========================================

/obj/machinery/ore_silo/away/preloaded

	// =========================
	// CONFIG (EDIT IN MAP)
	// Values are in MATERIAL UNITS
	// 1 sheet ≈ 2000 units
	// =========================

	var/starting_iron = 100000
	var/starting_glass = 100000
	var/starting_plasma = 100000
	var/starting_silver = 100000
	var/starting_gold = 100000
	var/starting_diamond = 100000
	var/starting_uranium = 100000
	var/starting_plastic = 100000
	var/starting_bluespace_crystal = 100000
	var/starting_bananium = 100000

/obj/machinery/ore_silo/away/preloaded/Initialize(mapload)
	. = ..()

	// Delay slightly to ensure component is fully initialized
	spawn(1)
		apply_starting_materials()

	return

// =========================
// APPLY MATERIALS
// =========================

/obj/machinery/ore_silo/away/preloaded/proc/apply_starting_materials()
	var/datum/component/material_container/MC = GetComponent(/datum/component/material_container)
	if(!MC)
		world.log << "[src]: No material_container component found!"
		return

	// Build material list
	var/list/new_materials = list()

	if(starting_iron)		new_materials[/datum/material/iron] = starting_iron
	if(starting_glass)		new_materials[/datum/material/glass] = starting_glass
	if(starting_plasma)		new_materials[/datum/material/plasma] = starting_plasma
	if(starting_silver)		new_materials[/datum/material/silver] = starting_silver
	if(starting_gold)		new_materials[/datum/material/gold] = starting_gold
	if(starting_diamond)	new_materials[/datum/material/diamond] = starting_diamond
	if(starting_uranium)	new_materials[/datum/material/uranium] = starting_uranium
	if(starting_plastic)	new_materials[/datum/material/plastic] = starting_plastic
	if(starting_bluespace_crystal)	new_materials[/datum/material/bluespace] = starting_bluespace_crystal
	if(starting_bananium)	new_materials[/datum/material/bananium] = starting_bananium

	// Apply directly to component
	MC.materials = new_materials

	// =========================
	// Try all possible update procs (fork-safe)
	// =========================

	if(hascall(MC, "on_materials_changed"))
		call(MC, "on_materials_changed")()

	if(hascall(MC, "recalculate"))
		call(MC, "recalculate")()

	if(hascall(MC, "update"))
		call(MC, "update")()

	if(hascall(MC, "refresh"))
		call(MC, "refresh")()

	if(hascall(MC, "ui_update"))
		call(MC, "ui_update")()

	world.log << "[src]: Applied starting materials."

// =========================
// OPTIONAL: DEBUG VERB
// =========================

/obj/machinery/ore_silo/away/preloaded/verb/set_material(mat as text, amount as num)
	set name = "Set Material"
	set category = "Debug"

	var/datum/component/material_container/MC = GetComponent(/datum/component/material_container)
	if(!MC)
		to_chat(usr, "No material container found.")
		return

	var/path

	switch(LOWER_TEXT(mat))
		if("iron")		path = /datum/material/iron
		if("glass")		path = /datum/material/glass
		if("plasma")	path = /datum/material/plasma
		if("silver")	path = /datum/material/silver
		if("gold")		path = /datum/material/gold
		if("diamond")	path = /datum/material/diamond
		if("uranium")	path = /datum/material/uranium
		if("plastic")	path = /datum/material/plastic
		if("bluespace polycrystal")	path = /datum/material/bluespace
		if("bananium")	path = /datum/material/bananium
		else
			to_chat(usr, "Unknown material.")
			return

	if(!MC.materials)
		MC.materials = list()

	MC.materials[path] = amount

	// Refresh after change
	if(hascall(MC, "on_materials_changed"))
		call(MC, "on_materials_changed")()

	to_chat(usr, "Set [mat] to [amount].")

/obj/machinery/ore_silo/away/preloaded/rich
	// Very rich amounts
	starting_iron = 20000
	starting_glass = 15000
	starting_plasma = 5000
	starting_silver = 5000
	starting_gold = 5000
	starting_diamond = 2500
	starting_uranium = 5000
	starting_plastic = 5000
	starting_bluespace_crystal = 1000
	starting_bananium = 500

/obj/machinery/ore_silo/away/preloaded/standard
	// Sub-standard amounts
	starting_iron = 15000
	starting_glass = 10000
	starting_plasma = 2500
	starting_silver = 2500
	starting_gold = 2500
	starting_diamond = 1000
	starting_uranium = 2500
	starting_plastic = 1500
	starting_bluespace_crystal = 500
	starting_bananium = 0

/obj/machinery/ore_silo/away/preloaded/poor
	// Very poor amounts
	starting_iron = 5000
	starting_glass = 5000
	starting_plasma = 1000
	starting_silver = 1000
	starting_gold = 1000
	starting_diamond = 0
	starting_uranium = 1000
	starting_plastic = 500
	starting_bluespace_crystal = 0
	starting_bananium = 0
