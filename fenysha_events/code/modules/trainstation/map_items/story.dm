/obj/item/keycard/important/trainstation
	color = COLOR_GOLD

/obj/item/keycard/important/trainstation/lab_key
	name = "Ключ-карта лаборатории"
	desc = "Ключ-карта с высоким уровнем допуска, открывающая доступ в лабораторный комплекс."


/obj/structure/prop/big/bigdice/radiosphere
	name = "Радиосфера"
	desc = "Огромный комплекс датчиков и усилителей сигнала, заключённый в оболочку, напоминающую идеально симметричный октаэдр. От объекта исходит едва уловимый, постоянный шум — словно далёкий шёпот эфира."
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


/obj/effect/decal/fakelattice/passthru/roof
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	flags_1 = SUPERMATTER_IGNORES_1
	layer = ABOVE_ALL_MOB_LAYER
