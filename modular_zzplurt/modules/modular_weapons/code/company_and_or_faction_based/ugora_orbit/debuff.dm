/datum/status_effect/bluespace_scarred
	id = "bluespace_scarred"
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/bluespace_scarred
	status_type = STATUS_EFFECT_REFRESH
	var/obj/effect/dummy/lighting_obj/moblight/mob_scarred

/datum/status_effect/bluespace_scarred/on_apply()
	mob_scarred = owner.mob_light(3, 15, LIGHT_COLOR_FLARE)
	ADD_TRAIT(owner, TRAIT_NO_TELEPORT, id)
	owner.add_filter("bluespace_scarred", 3, list("type" = "outline", "color" = COLOR_BLUE, "size" = 1))
	return TRUE

/datum/status_effect/bluespace_scarred/on_remove()
	QDEL_NULL(mob_scarred)
	owner.remove_filter("bluespace_scarred")
	REMOVE_TRAIT(owner, TRAIT_NO_TELEPORT, id)

/atom/movable/screen/alert/status_effect/bluespace_scarred
	name = "Bluespace Scarring"
	desc = "Your teleportation is blocked! This effect will end soon"
	icon = 'modular_zzplurt/modules/status_effect.dmi'
	icon_state = "scarred_blue"

//Aussie Catgirl told me this is a good idea so I did it.
