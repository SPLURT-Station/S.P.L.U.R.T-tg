/datum/species/shadow/nightmare
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/shadow/nightmare,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/shadow/nightmare,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/shadow/nightmare,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/shadow/nightmare,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/shadow/nightmare,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/shadow/nightmare,
	)

/obj/item/bodypart/head/shadow/nightmare
	burn_modifier = 1.2

/obj/item/bodypart/chest/shadow/nightmare
	burn_modifier = 1.2

/obj/item/bodypart/arm/left/shadow/nightmare
	burn_modifier = 1.15 // SPLURT change: reduced from 1.2 to 1.15 to balance revert to 100 max HP

/obj/item/bodypart/arm/right/shadow/nightmare
	burn_modifier = 1.15 // SPLURT change: reduced from 1.2 to 1.15 to balance revert to 100 max HP

/obj/item/bodypart/leg/left/shadow/nightmare
	burn_modifier = 1.15 // SPLURT change: reduced from 1.2 to 1.15 to balance revert to 100 max HP

/obj/item/bodypart/leg/right/shadow/nightmare
	burn_modifier = 1.15 // SPLURT change: reduced from 1.2 to 1.15 to balance revert to 100 max HP
