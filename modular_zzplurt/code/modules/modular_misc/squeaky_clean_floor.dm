/obj/effect/decal/cleaned_floor
	name = "water"
	desc = "Looks like the janitor has been doing a good job!"
	icon = 'icons/effects/water.dmi'
	icon_state = "wet_floor_static"

/obj/effect/decal/cleaned_floor/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, 80, (NO_SLIP_WHEN_WALKING))
