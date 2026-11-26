/datum/design/board/quantum_server
	name = "Quantum Server Board"
	desc = "The circuit board for a Quantum Server."
	build_path = /obj/item/circuitboard/machine/quantum_server
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/board/bitrunning_rewards_vendor
	name = "Bitrunning Rewards Vendor Board"
	desc = "The circuit board for a Bitrunning Rewards Vendor."
	build_path = /obj/item/circuitboard/computer/order_console/bitrunning
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/board/sex_research
	name = "Machine Design (Sex Research Rack)"
	desc = "Allows for the construction of circuit boards used to build sex research racks."
	build_path = /obj/item/circuitboard/machine/research_table
	category = list(
		RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING
