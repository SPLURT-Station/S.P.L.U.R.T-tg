/datum/species/xeno
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/mutant/xenohybrid,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/mutant/xenohybrid,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/mutant/xenohybrid,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/mutant/xenohybrid,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/mutant/xenohybrid,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/mutant/xenohybrid
	)

/datum/species/xeno/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons = TRUE)
	. = ..()
	var/datum/action/cooldown/sonar_ping/sonar_ping = new(human_who_gained_species)
	sonar_ping.Grant(human_who_gained_species)
	human_who_gained_species.add_movespeed_modifier(/datum/movespeed_modifier/xenochimera)

/datum/species/xeno/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	C.remove_movespeed_modifier(/datum/movespeed_modifier/xenochimera)

/datum/movespeed_modifier/xenochimera
	multiplicative_slowdown = -0.1
