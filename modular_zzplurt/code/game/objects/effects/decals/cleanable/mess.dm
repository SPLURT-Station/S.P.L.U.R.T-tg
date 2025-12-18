/obj/effect/decal/cleanable/piss_stain
	name = "piss puddle"
	desc = "Who would piss on the floor?"

	icon = 'modular_zzplurt/icons/effects/decals.dmi'
	icon_state = "piss_puddle"

/obj/effect/decal/cleanable/piss_stain/Initialize(mapload)
	. = ..()
	QDEL_IN(src, 10 MINUTES)
