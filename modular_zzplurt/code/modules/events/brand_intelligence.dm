//Modular override of brand_intelligence.dm to prevent vendors in hilberts hotel from being selected.

/datum/round_event/brand_intelligence/setup()
	//select our origin machine (which will also be the type of vending machine affected.)
	for(var/obj/machinery/vending/vendor as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/vending))
		if(!vendor.onstation)
			continue
		if(!vendor.density)
			continue
		if(chosen_vendor_type && !istype(vendor, chosen_vendor_type))
			continue
		var/area/vendor_area = get_area(vendor)
		if(vendor_area?.area_flags & HIDDEN_AREA)
			continue
		vending_machines.Add(vendor)
	if(!length(vending_machines)) //If somehow there are still no elligible vendors, give up.
		kill()
		return
	origin_machine = pick_n_take(vending_machines)
