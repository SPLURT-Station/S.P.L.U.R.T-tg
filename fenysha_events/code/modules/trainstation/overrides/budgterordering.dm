
/obj/item/modular_computer/pda/warden/Initialize(mapload)
	starting_programs -= /datum/computer_file/program/budgetorders
	. = ..()

/obj/item/modular_computer/pda/cargo/Initialize(mapload)
	starting_programs -= /datum/computer_file/program/budgetorders
	. = ..()

/obj/item/disk/computer/quartermaster/Initialize(mapload)
	starting_programs -= /datum/computer_file/program/budgetorders
	. = ..()

/obj/machinery/modular_computer/preset/cargochat/cargo/add_starting_software()
	. = ..()
	starting_programs -= /datum/computer_file/program/budgetorders

/obj/item/modular_computer/pda/heads/Initialize(mapload)
	head_programs -= /datum/computer_file/program/budgetorders
	. = ..()


/datum/computer_file/program/budgetorders
	extended_desc = "Deprecated for this expedition. Will not work."

/datum/computer_file/program/budgetorders/can_run(mob/user, loud, access_to_check, downloading, list/access)
	return FALSE
