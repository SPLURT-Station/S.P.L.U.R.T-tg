/obj/machinery/computer/holodeck/prison
	name = "workshop control console"
	desc = "A computer used to control the prison workshop."
	icon_screen = "holocontrol"

	/// Prison holodeck loads into this area
	mapped_start_area = /area/station/holodeck/prison

	/// Only prison workshop programs
	program_type = /datum/map_template/holodeck_prison

	/// What loads when powered off / shutdown
	offline_program = "workshop-offline"

	req_access = list()

/obj/machinery/computer/holodeck/prison/post_machine_initialize()
	. = ..()
	if(QDELETED(src))
		return

	// Prevent circular power dependency
	var/area/computer_area = get_area(src)
	if(istype(computer_area, mapped_start_area))
		log_mapping("Prison workshop holodeck computer cannot be inside its own holodeck area.")
		qdel(src)
		return

/obj/machinery/computer/holodeck/prison/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Holodeck")
		ui.open()

/obj/machinery/computer/holodeck/prison/ui_data(mob/user)
	var/list/data = ..()

	// No emag support for prison variant unless you add restricted programs
	data["default_programs"] = program_cache
	data["program"] = program

	return data

/obj/machinery/computer/holodeck/prison/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	. = TRUE

	if(!allowed(usr))
		to_chat(usr, span_warning("Access denied."))
		return FALSE

	switch(action)
		if("load_program")
			var/program_to_load = params["id"]

			// Validate program exists in allowed list
			var/valid = FALSE
			for(var/list/check_list as anything in program_cache)
				if(check_list["id"] == program_to_load)
					valid = TRUE
					break

			if(!valid)
				return FALSE

			load_program(program_to_load)

		if("shutdown")
			usr.log_message("shut down the prison workshop holodeck.", LOG_GAME)
			temporary_shutdown()

	return TRUE

/obj/machinery/computer/holodeck/prison/proc/temporary_shutdown()
	if(program == offline_program)
		say("Workshop already offline.")
		return

	say("Emergency shutdown engaged. Restarting in 2 minutes.")

	emergency_shutdown()

	// Reload previous program after delay if still powered
	if(last_program && last_program != offline_program)
		addtimer(CALLBACK(src, PROC_REF(load_program), last_program, TRUE), 2 MINUTES)
