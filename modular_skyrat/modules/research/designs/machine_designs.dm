/datum/design/board/quantum_server
	name = "Quantum Server Board"
	desc = "The circuit board for a Quantum Server."
	id = "quantum_server"
	build_path = /obj/item/circuitboard/machine/quantum_server
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/board/bitrunning_rewards_vendor
	name = "Bitrunning Rewards Vendor Board"
	desc = "The circuit board for a Bitrunning Rewards Vendor."
	id = "bitrunning_rewards_vendor"
	build_path = /obj/item/circuitboard/computer/order_console/bitrunning
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO
