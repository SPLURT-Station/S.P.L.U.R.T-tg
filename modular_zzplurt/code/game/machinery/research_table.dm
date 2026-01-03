#define POINT_TYPE_CARGO "cargo"
#define POINT_TYPE_SCIENCE "science"

/obj/machinery/research_table
	name = "Sex Research Rack"
	desc = "The rack with silicone padding and plenty of straps for subject restraining.\
	\nA lot of sensors are connected to this device that record the state of the body during orgasm. Well, you know... For scientific purposes...\
	\nYeah..... I fucking LOVE science."
	icon = 'modular_zzplurt/icons/obj/research_rack.dmi'
	icon_state = "rack_better"
	can_buckle = TRUE
	density = TRUE
	buckle_lying = 90
	pass_flags_self = PASSTABLE | LETPASSTHROW
	layer = TABLE_LAYER
	obj_flags = CAN_BE_HIT | IGNORE_DENSITY
	pass_flags = LETPASSTHROW //You can throw objects over this, despite it's density.")
	circuit = /obj/item/circuitboard/machine/research_table
	var/self_unbuckle_time = 3 MINUTES
	var/static/list/users = list()
	var/tier = 1
	var/configured = FALSE
	var/point_type = POINT_TYPE_SCIENCE
	var/max_repeat_usage = 3
	//var/slaver_mode = FALSE slavers dont exist on splurt anymore leaving it here for all of you to see

/obj/machinery/research_table/examine(mob/user)
	. = ..()
	if(configured)
		. += span_notice("The same person can be used up to [max_repeat_usage * tier] time\s.")
	switch(point_type)
		if(POINT_TYPE_SCIENCE)
			. += span_notice("The table is set to generate science points.")
		else
			. += span_notice("The table is set to generate money for cargo.")
	if(!configured && !panel_open)
		. += span_notice("It's not configured yet, you could use a <b>multitool</b> to configure it.")
	if(panel_open)
		. += span_notice("The panel is <b>screwed</b> open and you could change generation type with a <b>multitool</b>.")

/obj/machinery/research_table/multitool_act(mob/living/user, obj/item/I)
	if(!user.combat_mode)
		if(panel_open)
			user.visible_message(span_notice("[user] begins changing the generation type on \the [src]."), span_notice("You begin changing the generation type on \the [src]."))
			if(do_after(user, 5 SECONDS, src))
				point_type = point_type == POINT_TYPE_SCIENCE ? POINT_TYPE_CARGO : POINT_TYPE_SCIENCE
				var/generation_message = null
				switch(point_type)
					if(POINT_TYPE_SCIENCE)
						generation_message = "generate research points for science"
					else
						generation_message = "generate money for cargo"
				user.visible_message(span_notice("[user] finished changing the generation type on \the [src]."), span_notice("You change the generation type on \the [src] to [generation_message]."))
			else
				to_chat(user, span_warning("You need to stand still and uninterrupted for 5 seconds!"))
			return TRUE
		else
			user.visible_message(span_notice("[user] begins reconfiguring \the [src]."), span_notice("You begin reconfiguring \the [src]."))
			if(do_after(user, 5 SECONDS, src))
				configured = !configured
				user.visible_message(span_notice("[user] finished reconfiguring \the [src]."), span_notice("The research table is now [configured ? "configured" : "not configured"]."))
			else
				to_chat(user, span_warning("You need to stand still and uninterrupted for 5 seconds!"))
			return TRUE
	. = ..()

/obj/machinery/research_table/screwdriver_act(mob/living/user, obj/item/I)
	return default_deconstruction_screwdriver(user, icon_state, icon_state, I)

/obj/machinery/research_table/crowbar_act(mob/living/user, obj/item/I)
	return default_deconstruction_crowbar(I, FALSE)

/obj/machinery/research_table/mouse_drop_receive(mob/living/M, mob/living/user)
	if(istype(M))
		if(get_turf(M) != get_turf(src) && user.stat == CONSCIOUS)
			var/message = M == user ? "[M] climbs on the [src]." : "[user] puts [M] on the [src]."
			var/self_message = M == user ? "You climb on the [src]." : "You put [M] on the [src]."
			visible_message(message, self_message)
			M.forceMove(get_turf(src))
		. = ..()
		if(. && !configured) // Successfully buckled, not configured.
			say("Warning, table not configured yet!")
	return

/obj/machinery/research_table/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	if(QDELETED(buckled_mob) || QDELETED(user))
		return
	if(!handle_unbuckling(buckled_mob, user))
		if(buckled_mob == user)
			to_chat(user, span_warning("You fail to unbuckle yourself."))
		else
			to_chat(user, span_warning("You fail to unbuckle [buckled_mob]."))
		return
	UnregisterSignal(buckled_mob, COMSIG_MOB_POST_CLIMAX)
	say("User left, resetting scanners.")
	return ..()

/obj/machinery/research_table/proc/handle_unbuckling(mob/living/buckled_mob, user)
	if(buckled_mob == user)
		if(do_after(user, self_unbuckle_time, src))
			return TRUE
		else
			return FALSE
	return TRUE

/obj/machinery/research_table/buckle_mob(mob/living/buckled_mob, force, check_loc)
	RegisterSignal(buckled_mob, COMSIG_MOB_POST_CLIMAX, PROC_REF(on_climax))
	say("New user detected, tracking data.")
	. = ..()

/obj/machinery/research_table/RefreshParts()
	. = ..()
	// looks like you can just stack random shit into it to make it better lol!!!
	var/parts = 0
	tier = 0
	for(var/obj/item/stock_parts/part in component_parts)
		tier += part.rating
		parts++
	tier /= parts

/obj/machinery/research_table/proc/on_climax(mob/living/carbon/buckled_mob, mob/living/partner, interaction_position, manual)
	if(!configured)
		say("Failed to get any data, the table is not configured!")
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 30, 1)
		return
	if(!istype(buckled_mob))
		say("Failed to get any data from the subject, it is not a human.")
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 30, 1)
		return
	if(buckled_mob == partner)
		say("Failed to get any data from the subject, two are needed for the experiment!")
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 30, 1)
		return
	if(users[buckled_mob.name] > (max_repeat_usage * tier))
		say("There is already too much data from this subject.")
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 30, 1)
		return
	users[buckled_mob.name] += 1
	var/points_awarded = 0

	// little bonus if you... if you have interesting body traits
	// I don't stack these on purpose for "balancing"
	// study the physiological effects of sex or something
	if(buckled_mob.has_quirk(TRAIT_RESTORATIVE_METABOLISM) || buckled_mob.has_quirk(TRAIT_BODY_MORPHER) || buckled_mob.has_quirk(TRAIT_UNDEAD))
		points_awarded += 10 * rand(0,5)

	// study the psychological effects of sex or something
	// uncomment this as soon as you merge the other PR pretty please
	if(buckled_mob.has_quirk(TRAIT_HYPERSEXUAL))
		points_awarded += 10 * rand(0,5)

	// if you are pregnant i guess its interesting to see whats up?
	var/datum/status_effect/pregnancy/prego = buckled_mob.has_status_effect(/datum/status_effect/pregnancy)
	if(prego)
		points_awarded += (prego.pregnancy_stage * 10) * rand(0,5)

	for(var/obj/item/organ/genital/genital in buckled_mob.organs)
		if(istype(genital, /obj/item/organ/genital/testicles))
			var/obj/item/organ/genital/testicles/testies = genital
			points_awarded += testies.cumshot_size
		// if breasts are filled. add points
		else if(istype(genital, /obj/item/organ/genital/breasts))
			var/obj/item/organ/genital/breasts/boob = genital
			var/datum/reagent/consumable/milk/milk_reg = boob.internal_fluid_datum
			if(istype(milk_reg))
				points_awarded += milk_reg.volume

		points_awarded += genital.genital_size
	points_awarded *= tier
	points_awarded *= CONFIG_GET(number/sex_table_multiplier)
	switch(point_type)
		if(POINT_TYPE_SCIENCE)
			var/datum/techweb/station_techweb = locate(/datum/techweb/science) in SSresearch.techwebs
			if(station_techweb)
				station_techweb.add_point_list(list(TECHWEB_POINT_TYPE_GENERIC = points_awarded))
			else
				say("Cannot connect to a techweb on the station!")
		else
			var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_CAR)
			if(D)
				D.adjust_money(points_awarded)
	if(points_awarded)
		var/add_s = points_awarded == 1 ? "" : "s"
		say("Obtained [points_awarded] [point_type == POINT_TYPE_SCIENCE ? "point" : "credit"][add_s] from the session.")
		var/list/quotes = list(
			"Thank you for your contribution to science!" = 72,
			"Goooooood boooooy!" = 16,
			"That's a big one." = 10,
			"Oh yeah we like that..." = 2,
		)
		say(pick_weight(quotes))

		// thank you.
		if(points_awarded >= 2000) // idk this value probably needs tweaking
			// you did an AWESOME job and therefore you get a nice sound effect played
			var/list/awesome_sounds = list(
				'modular_zzplurt/sound/machines/research_table/EpicGameEncouragementPhrases_Awesome_02.ogg',
				'modular_zzplurt/sound/machines/research_table/EpicGameEncouragementPhrases_Congratulations_02.ogg',
				'modular_zzplurt/sound/machines/research_table/EpicGameEncouragementPhrases_Epic_02.ogg',
				'modular_zzplurt/sound/machines/research_table/EpicGameEncouragementPhrases_Flawless_02.ogg',
				'modular_zzplurt/sound/machines/research_table/EpicGameEncouragementPhrases_ThatsAmazing_02.ogg',
				'modular_zzplurt/sound/machines/research_table/EpicGameEncouragementPhrases_ThatsIncredible_02.ogg',
				'modular_zzplurt/sound/machines/research_table/EpicGameEncouragementPhrases_Victory_02.ogg'
			)
			playsound(src, pick(awesome_sounds), 30, 1)
		else
			playsound(src, 'sound/machines/chime.ogg', 30, 1)

	// YOU FUCKING SUCK AT SEX
	else
		say("Obtained no [point_type == POINT_TYPE_SCIENCE ? "points" : "credits"] from the session.") // Probably has no genitals at all
		playsound(src, 'sound/machines/buzz/buzz-two.ogg', 30, 1)

#undef POINT_TYPE_CARGO
#undef POINT_TYPE_SCIENCE
