/mob/living/silicon/robot/crowbar_act(mob/living/user, obj/item/this_item)
	var/validbreakout = FALSE
	for(var/obj/item/dogborg/sleeper/this_sleeper in held_items)
		if(!LAZYLEN(this_sleeper.contents))
			continue
		if(!validbreakout)
			visible_message("<span class='notice'>[user] wedges [this_item] into the crevice separating [this_sleeper] from [src]'s chassis, and begins to pry...</span>", "<span class='notice'>You wedge [this_item] into the crevice separating [this_sleeper] from [src]'s chassis, and begin to pry...</span>")
		validbreakout = TRUE
		this_sleeper.go_out()
	if(validbreakout)
		return TRUE
	return ..()

/mob/living/silicon/robot/proc/update_size_pref()
	var/cyborg_size = client?.prefs?.read_preference(/datum/preference/numeric/cyborg_size)
	if(cyborg_size && cyborg_size != current_size)
		if(is_security_cyborg_role())
			cyborg_size = max(cyborg_size, 0.8) // Don't let secborgs be smaller than 0.8
		update_transform(current_size > 0 ? (cyborg_size / current_size) : 1)

/mob/living/silicon/robot
	var/sleeper_garbage
	var/sleeper_occupant
	var/sleeper_enviroment

/mob/living/silicon/robot/Initialize(mapload)
	. = ..()
	simulated_genitals[ORGAN_SLOT_TAIL] = TRUE
