#define FILTER_STAMINACRIT 	list(type="drop_shadow", x=0, y=0, size=-3, color="#04080F")
#define FILTER_HARDCRIT 	list(type="drop_shadow", x=0, y=0, size=-3, color="#04080F")

/mob/living/carbon/set_health(new_value)
	. = ..()
	remove_filter("hardcrit")
	if(health <= crit_threshold)
		add_filter("hardcrit", 1, FILTER_HARDCRIT)

/datum/status_effect/incapacitating/stamcrit/on_apply()
	. = ..()
	owner.add_filter("staminacrit", 1, FILTER_STAMINACRIT)

/datum/status_effect/incapacitating/stamcrit/on_remove()
	. = ..()
	owner.remove_filter("staminacrit")
