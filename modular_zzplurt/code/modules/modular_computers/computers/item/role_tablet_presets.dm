/obj/item/modular_computer/pda/heads/centcom
	name = "central command PDA"
	icon_state = "/obj/item/modular_computer/pda/heads/centcom"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick/head
	greyscale_colors = "#227A26#000099#C19B2D"
	inserted_disk = /obj/item/disk/computer/command/captain
	inserted_item = /obj/item/pen/fountain/centcom
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/job_management,
	)

/obj/item/modular_computer/pda/heads/centcom/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TABLET_CHECK_DETONATE, PROC_REF(tab_no_detonate))
	for(var/datum/computer_file/program/messenger/messenger_app in stored_files)
		messenger_app.spam_mode = TRUE

/obj/item/modular_computer/pda/heads/centcom/proc/tab_no_detonate()
	SIGNAL_HANDLER
	return COMPONENT_TABLET_NO_DETONATE

/obj/item/modular_computer/pda/centcom
	name = "central command official PDA"
	icon_state = "/obj/item/modular_computer/pda/centcom"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick
	greyscale_colors = "#359048#000099#DAE4EA"
	inserted_disk = /obj/item/disk/computer/command/hop
	inserted_item = /obj/item/pen/fountain/centcom/silver
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/records/medical,
	)

/obj/item/modular_computer/pda/centcom/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TABLET_CHECK_DETONATE, PROC_REF(tab_no_detonate))
	for(var/datum/computer_file/program/messenger/messenger_app in stored_files)
		messenger_app.spam_mode = TRUE

/obj/item/modular_computer/pda/centcom/proc/tab_no_detonate()
	SIGNAL_HANDLER
	return COMPONENT_TABLET_NO_DETONATE

/obj/item/modular_computer/pda/centcom/ert
	name = "central command response PDA"
	icon_state = "/obj/item/modular_computer/pda/centcom/ert"
	greyscale_config = /datum/greyscale_config/tablet/stripe_double
	greyscale_colors = "#359048#B4B9C6#212B31"
	inserted_disk = /obj/item/disk/computer/command/hos
	inserted_item = /obj/item/pen/fountain/centcom/silver
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/robocontrol,
	)
