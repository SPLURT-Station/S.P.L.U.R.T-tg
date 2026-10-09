/obj/item/analyzer
	name = "gas analyzer"
	desc = "A hand-held analyzer which scans and provides analysis of gas atmospheres."
	icon = 'icons/obj/device.dmi'
	icon_state = "analyzer"
	item_state = "analyzer"
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	materials = list(/datum/material/iron = 30, /datum/material/glass = 20)
	var/datum/weakref/target

/obj/item/analyzer/attack_self(mob/user)
	var/turf/T = get_turf(user)
	if(T)
		scan_target(T, user)

/obj/item/analyzer/attack_obj(obj/O, mob/user)
	if(scan_target(O, user))
		return
	return ..()

/obj/item/analyzer/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(scan_target(target, user))
		return

/obj/item/analyzer/proc/scan_target(atom/A, mob/user)
	if(!A)
		return FALSE
	target = WEAKREF(A)
	tgui_interact(user)
	return TRUE

/obj/item/analyzer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GasAnalyzer", name)
		ui.open()

/obj/item/analyzer/tgui_state(mob/user)
	return GLOB.hands_state

/obj/item/analyzer/tgui_data(mob/user)
	var/list/data = list()
	var/atom/A = target?.resolve()
	if(!A)
		data["error"] = "No target scanned."
		return data

	data["target_name"] = A.name
	
	var/datum/gas_mixture/mix = A.return_air()
	if(!mix)
		data["error"] = "Unable to analyze target."
		return data

	data["pressure"] = mix.return_pressure()
	data["temperature"] = mix.return_temperature()
	
	var/list/gases = list()
	var/total_moles = mix.total_moles()
	data["total_moles"] = total_moles
	
	if(total_moles > 0)
		for(var/id in mix.get_gases())
			var/moles = mix.get_moles(id)
			if(moles <= 0)
				continue
			var/list/gas_data = list()
			gas_data["name"] = mix.get_gas_name(id)
			gas_data["moles"] = moles
			gas_data["percentage"] = (moles / total_moles) * 100
			gases += list(gas_data)
	
	data["gases"] = gases
	return data
