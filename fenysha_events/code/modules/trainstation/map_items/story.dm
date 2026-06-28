/obj/item/keycard/important/trainstation
	color = COLOR_GOLD

/obj/item/keycard/important/trainstation/lab_key
	name = "laboratory keycard"
	desc = "A high-clearance keycard that grants access to the laboratory complex."


/obj/structure/prop/big/bigdice/radiosphere
	name = "Radiosphere"
	desc = "An enormous complex of sensors and signal amplifiers, encased in a shell resembling a perfectly symmetrical octahedron. A faint, constant hum emanates from the object - like the distant whisper of the airwaves."
	icon = 'fenysha_events/icons/structures/radiosphere.dmi'
	icon_state = "main"
	density = TRUE
	uses_integrity = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	flags_1 = SUPERMATTER_IGNORES_1
	pixel_x = -240
	pixel_y = -32

	plane = MASSIVE_OBJ_PLANE
	appearance_flags = LONG_GLIDE


/obj/effect/decal/fakelattice/passthru
	density = FALSE

/obj/effect/decal/fakelattice/passthru/Initialize(mapload)
	. = ..()
	density = FALSE

/obj/effect/decal/fakelattice/passthru/roof
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	flags_1 = SUPERMATTER_IGNORES_1
	layer = ABOVE_ALL_MOB_LAYER
	density = FALSE
