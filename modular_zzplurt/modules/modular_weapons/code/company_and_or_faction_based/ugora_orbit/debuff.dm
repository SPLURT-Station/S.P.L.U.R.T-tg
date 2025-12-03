/datum/status_effect/bluespace_scarred
	id = "bluespace_scarred"
	duration = 1.4 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/bluespace_scarred
	status_type = STATUS_EFFECT_REFRESH
	var/obj/effect/dummy/lighting_obj/moblight/mob_scarred

/datum/status_effect/bluespace_scarred/on_apply()
	mob_scarred = owner.mob_light(3, 15, LIGHT_COLOR_FLARE)
	ADD_TRAIT(owner, TRAIT_NO_TELEPORT, id)
	owner.add_filter("designated_target", 3, list("type" = "outline", "color" = COLOR_BLUE, "size" = 1))
	return TRUE

/atom/movable/screen/alert/status_effect/bluespace_scarred
	name = "Bluespace Scarring"
	desc = "IT SAW ME IT SAW ME IT SAW ME IT SAW ME"
	icon = 'icons/hud/screen_alert.dmi'
	icon_state = "default"
