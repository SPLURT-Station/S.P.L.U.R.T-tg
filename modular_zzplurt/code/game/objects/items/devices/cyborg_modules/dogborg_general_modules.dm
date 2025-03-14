// Dorborg specific modules

#define STATUS_IDLE 0
#define STATUS_ENERGIZED 1
#define BASIC_CLEANSPEED 80
#define SCRUBPUP_CLEANSPEED 25
#define EMAGGED_CLEANSPEED 15

// Tongues (slurp)

/obj/item/soap/dogborg_tongue
	name = "synthetic tongue"
	desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
	icon = 'modular_zzplurt/icons/mob/robot/robot_items.dmi'
	icon_state = "synthtongue"
	item_flags = NOBLUDGEON
	force = 0
	cleanspeed = BASIC_CLEANSPEED
	var/status = STATUS_IDLE

/obj/item/soap/dogborg_tongue/Initialize(mapload)
	. = ..()

/datum/component/cleaner/RegisterWithParent()
	if(istype(parent, /obj/item/soap/dogborg_tongue))
		return COMPONENT_INCOMPATIBLE
	else
		return ..()

/obj/item/soap/dogborg_tongue/interact_with_atom(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(user.client && (target in user.client.screen))
		to_chat(user, "<span class='warning'>You need to take that [target.name] off before cleaning it!</span>")
		return

	var/mob/living/silicon/robot/this_robot = user
	var/mob/living/living_target = target

	playsound(user, 'sound/effects/blob/attackblob.ogg', 50, 1)
	do_attack_animation(target, "bubbles", src)

	if(istype(target, /obj/effect/decal/cleanable)) // GOTTAAAAAA SWWEEEEP SWEEP SWEEP SWEEP SWEEEEP!!
		this_robot.visible_message("[this_robot] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after(this_robot, src.cleanspeed, target = target))
			to_chat(this_robot, "<span class='notice'>You clean \the [target.name].</span>")
			qdel(target)
	else if(istype(target, /obj/item/trash)) // yummers
		this_robot.visible_message("[this_robot] nibbles away at \the [target.name].", "<span class='warning'>You begin to nibble away at \the [target.name]...</span>")
		if(!do_after(this_robot, src.cleanspeed, target = target))
			return
		to_chat(this_robot, "<span class='notice'>You finish off \the [target.name].</span>")
		qdel(target)
		this_robot.cell.give(250)
	else if(istype(target, /obj/item/stock_parts/power_store/cell)) // ayo this is bussin
		this_robot.visible_message("[this_robot] begins cramming \the [target.name] down its throat.", "<span class='warning'>You begin cramming \the [target.name] down your throat...</span>")
		if(!do_after(this_robot, 50, target = target))
			return
		to_chat(this_robot, "<span class='notice'>You finish off \the [target.name].</span>")
		var/obj/item/stock_parts/power_store/cell/target_cell = target
		this_robot.cell.charge = this_robot.cell.charge + (target_cell.charge / 3)
		qdel(target)
	else if(ishuman(living_target)) // good boy
		if(status == STATUS_IDLE && check_zone(this_robot.zone_selected) == "head")
			this_robot.visible_message("<span class='warning'>\the [this_robot] affectionally licks \the [living_target]'s face!</span>", "<span class='notice'>You affectionally lick \the [living_target]'s face!</span>")
			if(istype(living_target) && living_target.fire_stacks > 0)
				living_target.adjust_fire_stacks(-10)
			return
		else if(status == STATUS_IDLE)
			this_robot.visible_message("<span class='warning'>\the [this_robot] affectionally licks \the [living_target]!</span>", "<span class='notice'>You affectionally lick \the [living_target]!</span>")
			if(istype(living_target) && living_target.fire_stacks > 0)
				living_target.adjust_fire_stacks(-10)
			return
		else
			if(this_robot.cell.charge <= 800)
				to_chat(this_robot, "<span class='warning'>Insufficent Power!</span>")
				return
			living_target.AdjustStun(4)
			living_target.AdjustKnockdown(80)
			living_target.adjust_stutter(5 SECONDS)
			living_target.visible_message("<span class='danger'>[this_robot] shocks [living_target] with its tongue!</span>", "<span class='userdanger'>[this_robot] shocks you with its tongue!</span>")
			playsound(this_robot, 'sound/effects/sparks/sparks4.ogg', 50, 1, -1)
			this_robot.cell.use(600)
			log_combat(this_robot, living_target, "tongue stunned")
	else if(istype(target, /obj/structure/window)) // splurp
		this_robot.visible_message("[this_robot] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after(this_robot, src.cleanspeed, target = target))
			to_chat(this_robot, "<span class='notice'>You clean \the [target.name].</span>")
			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			target.set_opacity(initial(target.opacity))
	else // not so slurp
		this_robot.visible_message("[this_robot] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after(this_robot, src.cleanspeed, target = target))
			to_chat(this_robot, "<span class='notice'>You clean \the [target.name].</span>")
			var/obj/effect/decal/cleanable/cleanable_target = locate() in target
			qdel(cleanable_target)
			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			SEND_SIGNAL(target, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WASH)


/obj/item/soap/dogborg_tongue/attack_self(mob/user)
	var/mob/living/silicon/robot/this_robot = user
	if(this_robot.cell && this_robot.cell.charge > 100)
		if(this_robot.emagged && status == STATUS_IDLE)
			status = STATUS_ENERGIZED
			name = "energized tongue"
			desc = "Your tongue is energized for dangerously maximum efficency."
			icon_state = "syndietongue"
			to_chat(this_robot, "<span class='notice'>Your tongue is now [status ? "Energized" : "Normal"].</span>")
			cleanspeed = EMAGGED_CLEANSPEED
		else
			status = STATUS_IDLE
			name = "synthetic tongue"
			desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
			icon_state = "synthtongue"
			cleanspeed = BASIC_CLEANSPEED
			if(this_robot.emagged)
				to_chat(this_robot, "<span class='notice'>Your tongue is now [status ? "Energized" : "Normal"].</span>")
	update_icon()

/obj/item/soap/dogborg_tongue/scrubpup
	cleanspeed = SCRUBPUP_CLEANSPEED

// Noses (boop)

/obj/item/dogborg/dogborg_nose
	name = "BOOP module"
	desc = "The Bionic Olfactory Observation Processor module. Warm and squishy."
	icon = 'modular_zzplurt/icons/mob/robot/robot_items.dmi'
	icon_state = "nose"
	item_flags = NOBLUDGEON
	force = 0

	var/within_operational_parameters = TRUE

/obj/item/dogborg/dogborg_nose/attack_self(mob/user)
	scan_enviroment(user)

/obj/item/dogborg/dogborg_nose/proc/format_gas_concentration(concentration, standard_treshold, gas_name, check_type)
	var/format_text = "[gas_name]: [round(concentration * 100, 0.01)]%"
	var/is_alert = FALSE
	switch(check_type)
		if("less than")
			is_alert = !(abs(concentration - standard_treshold) < 20)
		if("greater than")
			is_alert = concentration > standard_treshold
	if(is_alert)
		within_operational_parameters = FALSE
	return is_alert ? span_alert(format_text) : span_info(format_text)

/obj/item/dogborg/dogborg_nose/proc/scan_enviroment(mob/user)
	user.visible_message("[user] sniffs around the air.", "<span class='info'>You sniff the air for gas traces.</span>")
	var/message = list(span_boldnotice("Results of environmental analysis:\n"))
	within_operational_parameters = TRUE

	var/datum/gas_mixture/mixture = user.loc.return_analyzable_air()
	if(!mixture)
		to_chat(user, span_warning("Module data request returned an empty string - no gas mixture provided."))
		return FALSE

	var/list/airs = islist(mixture) ? mixture : list(mixture)
	var/list/new_gasmix_data = list()
	for(var/datum/gas_mixture/air as anything in airs)
		var/mix_name = capitalize(LOWER_TEXT(user.name))
		new_gasmix_data += list(gas_mixture_parser(air, mix_name))

	var/pressure = mixture.return_pressure()
	var/total_moles = mixture.total_moles()

	var/o2_concentration = 0
	var/n2_concentration = 0
	var/co2_concentration = 0
	var/plasma_concentration = 0


	message += abs(pressure - ONE_ATMOSPHERE) < 10 ? span_info("Pressure: [round(pressure,0.1)] kPa") : span_alert("Pressure: [round(pressure,0.1)] kPa")
	within_operational_parameters = abs(pressure - ONE_ATMOSPHERE) < 10 ? within_operational_parameters : FALSE

	message += abs(mixture.return_temperature()) > 20 ? span_info("Temperature: [round(mixture.return_temperature() - T0C)]&deg;C\n") : span_alert("Temperature: [round(mixture.return_temperature() - T0C)]&deg;C\n")
	within_operational_parameters = abs(mixture.return_temperature()) > 20 ? within_operational_parameters : FALSE

	if(total_moles)
		for(var/list/gas_data as anything in new_gasmix_data)
			for(var/list/exact_gas_data as anything in gas_data["gases"])
				switch(exact_gas_data[2])
					if("Oxygen")
						o2_concentration = exact_gas_data[3]/total_moles
					if("Nitrogen")
						n2_concentration = exact_gas_data[3]/total_moles
					if("Carbon Dioxide")
						co2_concentration = exact_gas_data[3]/total_moles
					if("Plasma")
						plasma_concentration = exact_gas_data[3]/total_moles

		message += format_gas_concentration(n2_concentration, N2STANDARD, "Nitrogen", "less than")
		message += format_gas_concentration(o2_concentration, O2STANDARD, "Oxygen", "less than")
		message += format_gas_concentration(co2_concentration, 0.01, "CO2", "greater than")
		message += format_gas_concentration(plasma_concentration, 0.005, "Plasma", "greater than")

	message += span_boldnotice("Analysis summary: [within_operational_parameters ? "enviroment within operational parameters." : "<span class='danger'>enviroment outside operational parameters!</span>"]")
	to_chat(user, custom_boxed_message("purple_box", jointext(message, "\n")), type = MESSAGE_TYPE_INFO)

/obj/item/dogborg/dogborg_nose/attack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	do_attack_animation(target, null, src)
	user.visible_message("<span class='notice'>[user] [pick("nuzzles", "pushes", "boops")] \the [target.name] with their nose!</span>")

// Equipping dogborg modules (gets called during transformation)

/obj/item/robot_model/proc/dogborg_equip()
	cyborg_pixel_offset = -16
	hat_offset = INFINITY
	basic_modules += new /obj/item/dogborg/dogborg_nose(src)
	basic_modules += new /obj/item/storage/bag/borgdelivery(src)

	if(istype(src, /obj/item/robot_model/janitor))
		basic_modules += new /obj/item/soap/dogborg_tongue/scrubpup()
	else
		basic_modules += new /obj/item/soap/dogborg_tongue(src)

	if(istype(src, /obj/item/robot_model/security))
		basic_modules += new /obj/item/dogborg/jaws/big(src)
		basic_modules += new /obj/item/dogborg/pounce(src)
	else
		basic_modules += new /obj/item/dogborg/jaws/small(src)

	var/obj/item/dogborg/sleeper/this_sleeper = /obj/item/dogborg/sleeper

	var/mechanics = CONFIG_GET(flag/enable_dogborg_sleepers)
	if (mechanics)
		// Normal sleepers
		if(istype(src, /obj/item/robot_model/security))
			this_sleeper = new /obj/item/dogborg/sleeper/K9(src)

		if(istype(src, /obj/item/robot_model/medical))
			this_sleeper = new /obj/item/dogborg/sleeper(src)

		// "Unimplemented sleepers"
		if(istype(src, /obj/item/robot_model/engineering))
			this_sleeper = new /obj/item/dogborg/sleeper/compactor(src)
			this_sleeper.icon_state = "decompiler"
		if(istype(src, /obj/item/robot_model/janitor))
			this_sleeper = new /obj/item/dogborg/sleeper/compactor(src)
			this_sleeper.icon_state = "servicer"
			if(cyborg_base_icon in list("scrubpup", "drakejanit"))
				this_sleeper.icon_state = "compactor"
	else
		this_sleeper = new /obj/item/dogborg/sleeper/K9/flavour(src)
		// Recreational sleepers
		if(istype(src, /obj/item/robot_model/security))
			this_sleeper.icon_state = "sleeperb"
		if(istype(src, /obj/item/robot_model/medical))
			this_sleeper.icon_state = "sleeper"

		// Unimplemented sleepers
		if(istype(src, /obj/item/robot_model/engineering))
			this_sleeper.icon_state = "decompiler"
		if(istype(src, /obj/item/robot_model/janitor))
			this_sleeper.icon_state = "servicer"
			if(cyborg_base_icon in list("scrubpup", "drakejanit"))
				this_sleeper.icon_state = "compactor"

	basic_modules += this_sleeper
	rebuild_modules()

/obj/item/dogborg/jaws
	name = "Dogborg jaws"
	desc = "The jaws of the debug errors oh god."
	icon = 'modular_zzplurt/icons/mob/robot/robot_items.dmi'
	flags_1 = CONDUCTS_ELECTRICITY
	force = 1
	throwforce = 0
	w_class = 3
	sharpness = SHARP_EDGED

/obj/item/dogborg/jaws/big
	name = "combat jaws"
	desc = "The jaws of the law. Very sharp."
	icon_state = "jaws"
	force = 10
	attack_verb_simple = list("chomped", "bit", "ripped", "mauled", "enforced")

/obj/item/dogborg/jaws/small
	name = "puppy jaws"
	desc = "Rubberized teeth designed to protect accidental harm. Sharp enough for specialized tasks however."
	icon_state = "smalljaws"
	force = 5
	attack_verb_simple = list("nibbled", "bit", "gnawed", "chomped", "nommed")
	var/status = 0

/obj/item/dogborg/jaws/attack(atom/A, mob/living/silicon/robot/user)
	..()
	user.do_attack_animation(A, ATTACK_EFFECT_BITE)

/obj/item/dogborg/jaws/small/attack_self(mob/user)
	var/mob/living/silicon/robot/R = user
	if(R.cell && R.cell.charge > 100)
		if(R.emagged && status == 0)
			name = "combat jaws"
			icon_state = "jaws"
			desc = "The jaws of the law."
			force = 12
			attack_verb_simple = list("chomped", "bit", "ripped", "mauled", "enforced")
			status = 1
			to_chat(user, "<span class='notice'>Your jaws are now [status ? "Combat" : "Pup'd"].</span>")
		else
			name = "puppy jaws"
			icon_state = "smalljaws"
			desc = "The jaws of a small dog."
			force = 5
			attack_verb_simple = list("nibbled", "bit", "gnawed", "chomped", "nommed")
			status = 0
			if(R.emagged)
				to_chat(user, "<span class='notice'>Your jaws are now [status ? "Combat" : "Pup'd"].</span>")
	update_icon()


/obj/item/storage/bag/borgdelivery
	name = "fetching storage"
	desc = "Fetch the thing!"
	icon = 'modular_zzplurt/icons/mob/robot/robot_items.dmi'
	icon_state = "dbag"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = NONE

/obj/item/storage/bag/borgdelivery/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_BULKY
	atom_storage.max_total_storage = 30
	atom_storage.max_slots = 1
	atom_storage.set_holdable(cant_hold_list = list(/obj/item/disk/nuclear))
