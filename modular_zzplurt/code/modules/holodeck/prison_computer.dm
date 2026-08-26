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
	linked = GLOB.areas_by_type[mapped_start_area]
	if(!linked)
		log_mapping("[src] at [AREACOORD(src)] has no matching holodeck area.")
		qdel(src)
		return

	bottom_left = locate(linked.x, linked.y, src.z)
	if(!bottom_left)
		log_mapping("[src] at [AREACOORD(src)] has an invalid holodeck area.")
		qdel(src)
		return

	var/area/computer_area = get_area(src)
	if(istype(computer_area, /area/station/holodeck))
		log_mapping("Prison Holodeck computer cannot be in a holodeck, This would cause circular power dependency.")
		qdel(src)
		return

	// the following is necessary for power reasons
	if(!offline_program)
		stack_trace("Prison Holodeck console created without an offline program")
		qdel(src)
		return

	linked.linked = src
	var/area/my_area = get_area(src)
	if(my_area)
		linked.energy_usage = my_area.energy_usage
	else
		linked.energy_usage = list(AREA_USAGE_LEN)

	COOLDOWN_START(src, holodeck_cooldown, HOLODECK_CD)
	generate_program_list()
	load_program(offline_program,TRUE)
