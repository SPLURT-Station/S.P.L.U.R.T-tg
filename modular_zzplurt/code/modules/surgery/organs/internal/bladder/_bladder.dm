
/obj/item/organ/bladder
	name = "bladder"
	desc = "This is where your lemonade comes from!"
	icon = 'modular_zzplurt/icons/obj/medical/organs/organs.dmi'
	icon_state = "bladder"

	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_BLADDER

	/// The reagent we piss.
	var/datum/reagent/pissed_reagent = /datum/reagent/ammonia/urine
	/// How much piss are we currently storing?
	var/stored_piss = 0
	/// Max amount of piss we can store.
	var/max_piss_storage = 300
	/// The amount of liquid we eject per piss.
	var/piss_dosage = 15 // 300 / 15 == 20 piss emotes
	/// What's the temperature of our piss?
	var/piss_temperature = 340
	/// How long (roughly) does it take us to fill up on piss through life ticks alone (i.e no overdrinking)?
	var/time_before_full = 1.5 HOURS
	/// Delay the next notification for having a full bladder.
	// COOLDOWN_DECLARE(piss_notification)

/obj/item/organ/bladder/on_life(seconds_per_tick, times_fired)
	. = ..()
	var/added_piss = max_piss_storage * (seconds_per_tick / time_before_full)
	if(organ_flags & ORGAN_FAILING)
		added_piss *= 20 // 22-ish minutes before needing to piss, if napkin math checks out
	add_piss(added_piss)

/obj/item/organ/bladder/proc/add_piss(amount)
	if(owner.client?.prefs.read_preference(/datum/preference/choiced/erp_status_unholy) == "No")
		return

	// var/old_piss = stored_piss
	stored_piss = min(stored_piss + amount, max_piss_storage)

	// if((stored_piss >= max_piss_storage) && ((old_piss < max_piss_storage) || COOLDOWN_FINISHED(src, piss_notification)))
	// 	to_chat(owner, span_boldwarning("Your bladder is about to burst!"))
	// 	COOLDOWN_START(src, piss_notification, 3 MINUTES)
	// else if((stored_piss >= max_piss_storage * 0.75) && ((old_piss < max_piss_storage * 0.75) || COOLDOWN_FINISHED(src, piss_notification)))
	// 	to_chat(owner, span_warning("You could <b>really</b> use a trip to the bathroom."))
	// 	COOLDOWN_START(src, piss_notification, 3 MINUTES)
	// else if((stored_piss >= max_piss_storage * 0.5) && ((old_piss < max_piss_storage * 0.5) || COOLDOWN_FINISHED(src, piss_notification)))
	// 	to_chat(owner, span_warning("Your bladder is feeling full."))
	// 	COOLDOWN_START(src, piss_notification, 5 MINUTES)


/obj/item/organ/bladder/proc/urinate(forced = FALSE)
	if(owner.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_unholy) == "No")
		if(!forced)
			to_chat(owner, span_notice("You must enable the unholy verbs preference to piss.")) // we cant have nice things
		return
	if(stored_piss < piss_dosage * 2/3)
		if(!forced)
			to_chat(owner, span_notice("Try as you might you fail to piss."))
		return

	var/list/ignored_mobs = list()
	for(var/client/client)
		if(client.mob == owner)
			continue
		if(client.prefs?.read_preference(/datum/preference/choiced/erp_status_unholy) != "No")
			continue
		ignored_mobs += client.mob

	var/turf/open/owner_turf = get_turf(owner)
	var/obj/item/reagent_containers/held_container = owner.get_active_held_item()
	var/obj/structure/toilet/valid_toilet = locate(/obj/structure/toilet) in owner_turf
	var/obj/structure/urinal/valid_urinal = locate(/obj/structure/urinal) in owner_turf

	var/remaining_piss = min(stored_piss, piss_dosage)
	stored_piss -= remaining_piss

	playsound(owner, pick(GLOB.waterpiss_noises), 80, TRUE)
	if(owner_turf.liquids?.height >= LIQUID_WAIST_LEVEL_HEIGHT)
		owner.visible_message(span_notice("[owner] pisses into [istype(owner_turf, /turf/open/floor/iron/pool) ? "the pool" : "the surrounding water"].")) // wouldnt make sense in a pool of f.e tomato juice but shut up
		owner_turf.add_liquid(pissed_reagent, remaining_piss, FALSE, piss_temperature)
		return

	if(istype(held_container))
		var/space_left = held_container.reagents.maximum_volume - held_container.reagents.total_volume
		if(space_left < 1) // rounding memes
			goto bathroom_checks

		remaining_piss = round(remaining_piss - held_container.reagents.add_reagent(pissed_reagent, remaining_piss, reagtemp = piss_temperature), CHEMICAL_QUANTISATION_LEVEL)
		if(remaining_piss < 0)
			owner.visible_message(span_notice("[owner] pisses into [held_container], without spilling a drop."), ignored_mobs = ignored_mobs)
			return
		else if(remaining_piss == 0)
			owner.visible_message(span_warning("[owner] pisses into [held_container], filling it to the brim."))
		else
			owner.visible_message(span_warning("[owner] pisses into [held_container].. but it overflows!"))
			if(valid_toilet || valid_urinal)
				owner.visible_message(span_warning("The excess urine drips over and into [valid_toilet || valid_urinal]. Whew."))
			else
				owner.visible_message(span_warning("The excess urine spills over onto the floor."))
				goto floor_piss
			return

	bathroom_checks:
	if(valid_toilet)
		owner.visible_message(span_notice("[owner] pisses into the toilet."), ignored_mobs = ignored_mobs)
		return
	if(valid_urinal)
		owner.visible_message(span_notice("[owner] carefully pisses into the urinal not spilling a drop."), ignored_mobs = ignored_mobs)
		return

	owner.visible_message(span_warning("[owner] pisses all over the floor!"), ignored_mobs = ignored_mobs)
	floor_piss: // below the msg bcuz earlier container check

	owner_turf.add_liquid(pissed_reagent, remaining_piss, FALSE, piss_temperature)

	var/datum/record/crew/record = find_record(owner.name)
	if(!record)
		return

	for(var/obj/machinery/camera/camera in view(7, owner))
		if(!camera.can_use() || get_dist(owner, camera) > camera.view_range)
			continue

		var/datum/crime/new_crime = new(name = "Public Urination", details = "This person has been caught on video camera pissing in \the [owner_turf.loc]", author = "Automated Criminal Detection Service")
		record.crimes += new_crime
		record.wanted_status = WANTED_ARREST
		break


/obj/item/organ/bladder/clown
	name = "clown bladder"
	desc = "How does this even work?"

	pissed_reagent = /datum/reagent/lube

/obj/item/organ/bladder/cybernetic
	name = "cybernetic bladder"
	desc = "This is where your oil comes from!" // not really
	icon_state = "bladder-c"

// /obj/item/organ/bladder/cybernetic/emp_act(severity)
// 	. = ..()
// 	if(. & EMP_PROTECT_SELF)
// 		return
// 	if(prob(40 / severity))
// 		urinate()
