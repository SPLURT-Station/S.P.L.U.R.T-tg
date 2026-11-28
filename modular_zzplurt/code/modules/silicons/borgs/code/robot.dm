/mob/living/silicon/robot/crowbar_act(mob/living/user, obj/item/this_item)
	var/validbreakout = FALSE
	for(var/obj/item/dogborg/sleeper/this_sleeper in held_items)
		if(!LAZYLEN(this_sleeper.contents))
			continue
		if(!validbreakout)
			visible_message("<span class='notice'>[user] wedges [this_item] into the crevice separating [this_sleeper] from [src]'s chassis, and begins to pry...</span>", "<span class='notice'>You wedge [this_item] into the crevice separating [this_sleeper] from [src]'s chassis, and begin to pry...</span>")
		validbreakout = TRUE
		this_sleeper.go_out(null, src)
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

/mob/living/silicon/robot/update_icons()
	. = ..() // SKyrat sets the pose and cuts overlays; eyes and hat are already back
	apply_shell_lights()
	apply_sleeper_belly()

/mob/living/silicon/robot/proc/apply_shell_lights()
	// Headlamp on, or a doomsday lamp that cannot be switched off
	//Standing keeps the _1 core painted. Rest keeps the [pose]_e Skyrat painted after it cut that _1.
	if(lamp_enabled || lamp_doom)
		return
	// Standing idle eyes. One object covers standard, hound, and every special_light_key.
	if(eye_lights)
		cut_overlay(eye_lights)
	// Rest, sit, belly-up, and deep sleep use a string overlay instead of eye_lights.
	if(model && (TRAIT_R_HAS_UNIQUE_RESTING_LIGHTS in model.model_features))
		cut_overlay("[icon_state]_e")

/mob/living/silicon/robot/proc/apply_sleeper_belly()
	if(!model?.sleeper_overlay)
		return
	// A wrecked chassis has no gut art. A standing belly on -wreck sits in the wrong place
	if(stat == DEAD && (TRAIT_R_UNIQUEWRECK in model.model_features))
		return

	var/color_suffix
	if(sleeper_garbage)
		color_suffix = "_g" // living patient
	else if(sleeper_occupant)
		color_suffix = "_r" // dead, cleaning, or a stuffed compactor
	else
		return

	var/state = "[model.sleeper_overlay][color_suffix]" // [pose_suffix] would go after [color_suffix]

	// Temporary placeholder code; loads _r overlay where _g fails; six cyborgs (Cargo Hound/Darkhound, Mining Hound/Darkhound, J9, and Drake Engi do not have _g suffix sprites on file (Drake engi is broke pretty bad))
	var/static/list/states_by_icon = list()
	if(!states_by_icon[icon])
		states_by_icon[icon] = icon_states(icon)
	if(!(state in states_by_icon[icon]))
		if(color_suffix != "_g")
			return
		state = "[model.sleeper_overlay]_r"
		if(!(state in states_by_icon[icon]))
			return
	add_overlay(state)

/mob/living/silicon/robot/add_overlay(list/add_overlays)
	if(overlays)
		return ..()
	overlays = build_appearance_list(add_overlays)
	VALIDATE_OVERLAY_LIMIT(src)
	POST_OVERLAY_CHANGE(src)

/mob/living/silicon/robot/on_changed_z_level(turf/old_turf, turf/new_turf, same_z_layer, notify_contents)
	if(same_z_layer || QDELING(src))
		return ..()
	if(eye_lights)
		cut_overlay(eye_lights)
		SET_PLANE_EXPLICIT(eye_lights, PLANE_TO_TRUE(eye_lights.plane), src)
		if(lamp_enabled || lamp_doom)
			add_overlay(eye_lights)
	return ..()
