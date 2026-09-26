

// NEW Nanotrasen Consultant
/obj/effect/mapping_helpers/airlock/access/any/cent_com/consultant/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_CAPTAIN
	return access_list

// Nanotrasen External Staff
/obj/effect/mapping_helpers/airlock/access/any/cent_com/nanotrasenstaff/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_GENERAL
	return access_list

// Nanotrasen Blueshield
/obj/effect/mapping_helpers/airlock/access/any/cent_com/blueshield/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_OFFICER
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/cent_com/consultant/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_CAPTAIN
	return access_list

// Nanotrasen External Staff
/obj/effect/mapping_helpers/airlock/access/all/cent_com/nanotrasenstaff/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_GENERAL
	return access_list

// Nanotrasen Blueshield
/obj/effect/mapping_helpers/airlock/access/all/cent_com/blueshield/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_OFFICER
	return access_list
