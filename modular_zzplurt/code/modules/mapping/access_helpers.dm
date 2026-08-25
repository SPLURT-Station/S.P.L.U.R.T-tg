/obj/effect/mapping_helpers/airlock/access/all/admin/security/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_SECURITY
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/admin/logistics/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_LOGISTICS
	return access_list
