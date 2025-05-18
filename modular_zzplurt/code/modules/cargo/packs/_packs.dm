/datum/supply_pack
	/// Whether or not this pack comes filled to the brim with packing peanuts, for safety
	var/handle_with_care = TRUE

/datum/supply_pack/fill(obj/structure/closet/crate/C)
	. = ..()
	if(handle_with_care && C.packable && !C.packing_overlay)
		C.get_packed()
