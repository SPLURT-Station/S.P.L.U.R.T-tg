// Player preference toggle to enable smothering/breath-control erotic interactions
/datum/preference/toggle/erp/smother_enable
	savefile_key = "smother_enable_pref"

/datum/preference/toggle/erp/smother_enable/apply_to_client(client/client, value)
	var/mob/living/L = client.mob
	if(istype(L))
		// Only add component if enabling and mob type is allowed; always remove when disabling
		if(value && (!isnull(GLOB.smother_allowed_mob_types) ? is_type_in_typecache(L, GLOB.smother_allowed_mob_types) : TRUE))
			if(!L.GetComponent(/datum/component/smother))
				L.AddComponent(/datum/component/smother, L)
		else
			var/datum/component/C = L.GetComponent(/datum/component/smother)
			if(C)
				qdel(C)
