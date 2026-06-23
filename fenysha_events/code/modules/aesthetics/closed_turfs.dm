/turf/closed/wall/mineral/titanium/spaceship
	icon = 'fenysha_events/icons/turf/shipwalls.dmi'
	icon_state = "ship_walls-0"
	base_icon_state = "ship_walls"
	sheet_type = /obj/item/stack/sheet/spaceship
	smoothing_groups = SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_SHUTTLE_PARTS
	canSmoothWith = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_SURVIVAL_TITANIUM_POD

/turf/closed/wall/mineral/titanium/spaceship/nodiagonal
	icon_state = "map-shuttle_nd"
	smoothing_flags = SMOOTH_BITMASK

/turf/closed/wall/mineral/titanium/spaceship/nosmooth
	icon_state = "ship_walls-0"
	smoothing_flags = NONE

/turf/closed/wall/mineral/titanium/spaceship/overspace
	icon_state = "map-overspace"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_DIAGONAL_CORNERS
	fixed_underlay = list("space" = TRUE)

/turf/closed/wall/mineral/titanium/spaceship/interior/copyTurf(turf/T)
	if(T.type != type)
		T.ChangeTurf(type)
		if(underlays.len)
			T.underlays = underlays
	if(T.icon_state != icon_state)
		T.icon_state = icon_state
	if(T.icon != icon)
		T.icon = icon
	if(color)
		T.atom_colours = atom_colours.Copy()
		T.update_atom_colour()
	if(T.dir != dir)
		T.setDir(dir)
	T.transform = transform
	return T

/turf/closed/wall/mineral/titanium/spaceship/copyTurf(turf/T)
	. = ..()
	T.transform = transform

/obj/structure/window/reinforced/shuttle/spaceship
	name = "окно космического корабля" // spaceship window
	desc = "Устойчивое к давлению окно космического корабля." // A pressure-resistant spaceship window.
	icon = 'fenysha_events/icons/turf/shipwindows.dmi'
	icon_state = "pod_window-0"
	base_icon_state = "pod_window"
	glass_type = /obj/item/stack/sheet/spaceshipglass
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE
	canSmoothWith = SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE
	obj_flags = CAN_BE_HIT
	custom_materials = list(/datum/material/alloy/plastitaniumglass = SHEET_MATERIAL_AMOUNT * 2)

/obj/structure/window/reinforced/shuttle/spaceship/tinted
	opacity = TRUE

/obj/structure/window/reinforced/shuttle/spaceship/unanchored
	anchored = FALSE

/obj/structure/fence/interlink
	name = "укрепленный забор" // reinforced fence
	desc = "Новейшая разработка Nanotrasen: укрепленный металлический забор. Это удержит надоедливых ассистентов!" // The latest in Nanotrasen development: A reinforced metal fence. This'll keep those pesky assistants out!
	cuttable = FALSE
	invulnerable = TRUE

/turf/closed/indestructible/steel
	icon = 'icons/turf/walls/wall.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith =  SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS
