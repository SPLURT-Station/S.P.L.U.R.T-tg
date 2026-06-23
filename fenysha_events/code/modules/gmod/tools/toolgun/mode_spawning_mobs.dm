/datum/toolgun_mode/spawning/mobs
	name = "Мобы"
	desc = "Заспавните почти любое живое существо без каких-либо ограничений!"
	mode_key = "mobs"
	type_blacklist = list(
		/mob/dead,
		/mob/eye,
		/mob/dview,
		/mob/proccall_handler,
		/mob/oranges_ear,
		/mob/living/basic/supermatter_spider, // По понятным причинам
	)

	var/mob_ai_controller = ""
	var/mob_max_health = 100
	var/mob_health = 100
	var/mob_bodytemperature = BODYTEMP_NORMAL
	var/mob_min_temperature = NPC_DEFAULT_MIN_TEMP
	var/mob_max_temperature = NPC_DEFAULT_MAX_TEMP
	var/mob_need_atmosphere = TRUE
	var/mob_unsuitable_atmos_damage = 1
	var/mob_melee_damage_lower = 0
	var/mob_melee_damage_upper = 0

/datum/toolgun_mode/spawning/mobs/get_root_type()
	return /mob

/datum/toolgun_mode/spawning/mobs/get_root_path_text()
	return "/mob"

/datum/toolgun_mode/spawning/mobs/sync_settings_from_selected_type()
	..()
	if(!selected_type)
		return
	if("ai_controller" in selected_type.vars)
		var/ai_path = selected_type.vars["ai_controller"]
		if(ispath(ai_path, /datum/ai_controller))
			mob_ai_controller = "[ai_path]"
		else
			mob_ai_controller = ""
	if("maxHealth" in selected_type.vars)
		mob_max_health = max(1, text2num("[selected_type.vars["maxHealth"]]"))
	if("health" in selected_type.vars)
		mob_health = clamp(text2num("[selected_type.vars["health"]]"), 0, mob_max_health)
	if("bodytemperature" in selected_type.vars)
		mob_bodytemperature = text2num("[selected_type.vars["bodytemperature"]]")
	if("minbodytemp" in selected_type.vars)
		mob_min_temperature = text2num("[selected_type.vars["minbodytemp"]]")
	if("maxbodytemp" in selected_type.vars)
		mob_max_temperature = text2num("[selected_type.vars["maxbodytemp"]]")
	if("unsuitable_atmos_damage" in selected_type.vars)
		mob_unsuitable_atmos_damage = text2num("[selected_type.vars["unsuitable_atmos_damage"]]")
		mob_need_atmosphere = mob_unsuitable_atmos_damage > 0
	if("melee_damage_lower" in selected_type.vars)
		mob_melee_damage_lower = text2num("[selected_type.vars["melee_damage_lower"]]")
	if("melee_damage_upper" in selected_type.vars)
		mob_melee_damage_upper = text2num("[selected_type.vars["melee_damage_upper"]]")

/datum/toolgun_mode/spawning/mobs/ui_data(mob/user)
	. = ..()
	.["mob_ai_controller"] = mob_ai_controller
	.["mob_max_health"] = mob_max_health
	.["mob_health"] = mob_health
	.["mob_bodytemperature"] = mob_bodytemperature
	.["mob_min_temperature"] = mob_min_temperature
	.["mob_max_temperature"] = mob_max_temperature
	.["mob_need_atmosphere"] = mob_need_atmosphere
	.["mob_unsuitable_atmos_damage"] = mob_unsuitable_atmos_damage
	.["mob_melee_damage_lower"] = mob_melee_damage_lower
	.["mob_melee_damage_upper"] = mob_melee_damage_upper

/datum/toolgun_mode/spawning/mobs/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("set_mob_ai_controller")
			mob_ai_controller = trimtext(params["value"])
			return TRUE
		if("set_mob_max_health")
			var/new_value = text2num(params["value"])
			if(isnum(new_value))
				mob_max_health = max(1, round(new_value, 1))
				mob_health = clamp(mob_health, 0, mob_max_health)
			return TRUE
		if("set_mob_health")
			var/new_value = text2num(params["value"])
			if(isnum(new_value))
				mob_health = clamp(round(new_value, 1), 0, mob_max_health)
			return TRUE
		if("set_mob_bodytemperature")
			var/new_value = text2num(params["value"])
			if(isnum(new_value))
				mob_bodytemperature = round(new_value, 0.1)
			return TRUE
		if("set_mob_min_temperature")
			var/new_value = text2num(params["value"])
			if(isnum(new_value))
				mob_min_temperature = round(new_value, 0.1)
			return TRUE
		if("set_mob_max_temperature")
			var/new_value = text2num(params["value"])
			if(isnum(new_value))
				mob_max_temperature = round(new_value, 0.1)
			return TRUE
		if("toggle_mob_need_atmosphere")
			mob_need_atmosphere = !mob_need_atmosphere
			return TRUE
		if("set_mob_unsuitable_atmos_damage")
			var/new_value = text2num(params["value"])
			if(isnum(new_value))
				mob_unsuitable_atmos_damage = max(0, round(new_value, 0.1))
			return TRUE
		if("set_mob_melee_damage_lower")
			var/new_value = text2num(params["value"])
			if(isnum(new_value))
				mob_melee_damage_lower = round(new_value, 0.1)
				if(mob_melee_damage_upper < mob_melee_damage_lower)
					mob_melee_damage_upper = mob_melee_damage_lower
			return TRUE
		if("set_mob_melee_damage_upper")
			var/new_value = text2num(params["value"])
			if(isnum(new_value))
				mob_melee_damage_upper = round(new_value, 0.1)
				if(mob_melee_damage_upper < mob_melee_damage_lower)
					mob_melee_damage_lower = mob_melee_damage_upper
			return TRUE
	return ..()

/datum/toolgun_mode/spawning/mobs/after_spawn(atom/created_atom, mob/user)
	. = ..()
	if(!ismob(created_atom))
		return
	var/mob/living/spawned_mob = created_atom

	var/path_ai_controller = text2path(mob_ai_controller)
	if(path_ai_controller && ispath(path_ai_controller, /datum/ai_controller) && ("ai_controller" in spawned_mob.vars))
		spawned_mob.ai_controller = path_ai_controller

	if("maxHealth" in spawned_mob.vars)
		spawned_mob.maxHealth = mob_max_health
	if("health" in spawned_mob.vars)
		spawned_mob.health = clamp(mob_health, 0, spawned_mob.maxHealth)
	if("bodytemperature" in spawned_mob.vars)
		spawned_mob.bodytemperature = mob_bodytemperature
	/*
	if(isbasicmob(spawned_mob))
		var/mob/basic/spawned_basic_mob = spawned_mob
		spawned_basic_mob.min_temperature = mob_min_temperature
		spawned_basic_mob.max_temperature = mob_max_temperature
	*/
	if("melee_damage_lower" in spawned_mob.vars)
		spawned_mob.melee_damage_lower = mob_melee_damage_lower
	if("melee_damage_upper" in spawned_mob.vars)
		spawned_mob.melee_damage_upper = mob_melee_damage_upper
