/obj/item/robot_model
	/// Pixel offset applied when comparing a custom override sprite against the occlusion mask for non-moving states.
	var/cyborg_icon_override_idle_pixel_x = 0
	/// Pixel offset applied when comparing a custom override sprite against the occlusion mask for non-moving states.
	var/cyborg_icon_override_idle_pixel_y = 0
	/// Pixel offset applied when comparing a custom override sprite against the occlusion mask for moving states.
	var/cyborg_icon_override_moving_pixel_x = 0
	/// Pixel offset applied when comparing a custom override sprite against the occlusion mask for moving states.
	var/cyborg_icon_override_moving_pixel_y = 0

/obj/item/robot_model/proc/refresh_cyborg_icon_override_rendering()
	var/mob/living/silicon/robot/cyborg = robot || loc
	if(!istype(cyborg))
		return FALSE
	cyborg.update_cyborg_genital_appearance()
	return TRUE

/obj/item/robot_model/vv_edit_var(var_name, var_value)
	. = ..()
	if(. == FALSE)
		return FALSE

	switch(var_name)
		if(NAMEOF(src, cyborg_icon_override), NAMEOF(src, cyborg_icon_override_idle_pixel_x), NAMEOF(src, cyborg_icon_override_idle_pixel_y), NAMEOF(src, cyborg_icon_override_moving_pixel_x), NAMEOF(src, cyborg_icon_override_moving_pixel_y))
			refresh_cyborg_icon_override_rendering()
	return .

/obj/item/robot_model/standard/Initialize(mapload)
	. = ..()
	borg_skins |= list(
		"Assaultron" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "assaultron_standard"),
		"RoboMaid" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "robomaid_sd"),
	)

/obj/item/robot_model/service/Initialize(mapload)
	. = ..()
	borg_skins |= list(
		"Assaultron" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "assaultron_service"),
		"Meka (Dapper)" = list(SKIN_ICON_STATE = "mekaserve_alt2", SKIN_ICON = CYBORG_ICON_SPLURT_TALL, SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK, TRAIT_R_UNIQUETIP, TRAIT_R_TALL), TALL_HAT_OFFSET),
	)

/obj/item/robot_model/engineering/Initialize(mapload)
	. = ..()
	borg_skins |= list(
		"Assaultron" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "assaultron_engi"),
		"RoboMaid" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "robomaid_eng"),
	)

/obj/item/robot_model/medical/Initialize(mapload)
	. = ..()
	borg_skins |= list(
		"Assaultron" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "assaultron_medical"),
		"RoboMaid" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "robomaid_med"),
		"Paramedic Drake" = list(SKIN_ICON = CYBORG_ICON_MED_SPLURT_WIDE, SKIN_ICON_STATE = "draketrauma", SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK, TRAIT_R_WIDE), DRAKE_HAT_OFFSET),
	)

/obj/item/robot_model/security/Initialize(mapload)
	. = ..()
	borg_skins |= list(
		"Assaultron" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "assaultron_sec"),
		"RoboMaid" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "robomaid_sec"),
		"Feline" = list(SKIN_ICON = CYBORG_ICON_SPLURT_WIDE, SKIN_ICON_STATE = "vixmed-b", SKIN_FEATURES = list(TRAIT_R_WIDE, TRAIT_R_SMALL), BORGI_HAT_OFFSET),
	)

/obj/item/robot_model/peacekeeper/Initialize(mapload) //adds the sec skins to peacekeeper
	. = ..()
	borg_skins |= list(
		"Assaultron" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "assaultron_sec"),
		"Feline" = list(SKIN_ICON = CYBORG_ICON_SPLURT_WIDE, SKIN_ICON_STATE = "vixmed-b", SKIN_FEATURES = list(TRAIT_R_WIDE, TRAIT_R_SMALL), BORGI_HAT_OFFSET),
	)
