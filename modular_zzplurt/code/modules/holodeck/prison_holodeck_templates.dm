//   --------------------
// -- PRISON TEMPLATES --
//   --------------------
/datum/map_template/holodeck_prison
	/// id
	var/template_id
	/// Is this an emag program
	var/restricted = FALSE

	should_place_on_top = FALSE
	returns_created_atoms = TRUE
	keep_cached_map = TRUE

/datum/map_template/holodeck_prison/offline
	name = "Workshop - Offline"
	template_id = "workshop_offline"
	mappath = "_maps/splurt/templates/holodeck_prison_offline.dmm"

/datum/map_template/holodeck_prison/donut
	name = "Workshop - Baking Workshop"
	template_id = "workshop_donut"
	mappath = "_maps/splurt/templates/holodeck_prison_donut.dmm"

/datum/map_template/holodeck_prison/workshop
	name = "Workshop - Normal Workshop"
	template_id = "workshop_basic"
	mappath = "_maps/splurt/templates/holodeck_prison_workshop.dmm"

/datum/map_template/holodeck_prison/basketball
	name = "Workshop - Basketball Court"
	template_id = "workshop_basketball"
	mappath = "_maps/splurt/templates/holodeck_prison_basketball.dmm"

/datum/map_template/holodeck_prison/boxing
	name = "Workshop - Boxing Arena"
	template_id = "workshop_boxing"
	mappath = "_maps/splurt/templates/holodeck_prison_boxing.dmm"
