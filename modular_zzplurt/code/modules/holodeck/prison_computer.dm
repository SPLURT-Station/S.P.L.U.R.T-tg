#define HOLODECK_CD (2 SECONDS)
#define HOLODECK_DMG_CD (5 SECONDS)

/obj/machinery/computer/holodeck/prison
	name = "workshop control console"
	desc = "A computer used to control the prison workshop."
	icon_screen = "holocontrol"

	/// Prison holodeck loads into this area
	mapped_start_area = /area/station/security/prison

	program = "workshop-offline"

	/// What loads when powered off / shutdown
	offline_program = "workshop-offline"

	/// Only prison workshop programs
	program_type = /datum/map_template/holodeck_prison

/obj/machinery/computer/holodeck/prison/post_machine_initialize()
	. = ..()
	linked = GLOB.areas_by_type[mapped_start_area]
	if(!linked)
		log_mapping("[src] at [AREACOORD(src)] has no matching prison holodeck area.")
		qdel(src)
		return

	bottom_left = locate(linked.x, linked.y, src.z)
	if(!bottom_left)
		log_mapping("[src] at [AREACOORD(src)] has an invalid prison holodeck area.")
		qdel(src)
		return

	var/area/computer_area = get_area(src)
	if(istype(computer_area, /area/station/holodeck/prison))
		log_mapping("Prison Holodeck computer cannot be in a prison holodeck, This would cause circular power dependency.")
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

#undef HOLODECK_CD
#undef HOLODECK_DMG_CD
