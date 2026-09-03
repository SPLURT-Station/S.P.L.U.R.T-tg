/obj/structure/closet/generic/wall
	door_anim_squish = 0.3
	door_anim_angle = 115
	door_hinge_x = -8.5
	wall_mounted = TRUE
	max_mob_size = MOB_SIZE_SMALL
	density = TRUE
	anchored = TRUE
	anchorable = FALSE //Prevents unscrewing and dragging. Needs to be welded!
	paint_jobs = FALSE //Prevents repainting into other non-wall closets.
	icon = 'fenysha_events/icons/structures/closet_wall.dmi'
	icon_state = "locker_wall"

/obj/structure/closet/emcloset/wall
	door_anim_squish = 0.3
	door_anim_angle = 115
	door_hinge_x = -8.5
	wall_mounted = TRUE
	max_mob_size = MOB_SIZE_SMALL
	density = TRUE
	anchored = TRUE
	anchorable = FALSE
	paint_jobs = FALSE
	icon = 'fenysha_events/icons/structures/closet_wall.dmi'
	icon_state = "emergency_wall"

/obj/structure/closet/firecloset/wall
	door_anim_squish = 0.3
	door_anim_angle = 115
	door_hinge_x = -8.5
	wall_mounted = TRUE
	max_mob_size = MOB_SIZE_SMALL
	density = TRUE
	anchored = TRUE
	anchorable = FALSE
	paint_jobs = FALSE
	icon = 'fenysha_events/icons/structures/closet_wall.dmi'
	icon_state = "fire_wall"

//These two are pre-locked versions of closet/generic/wall, for mapping only
/obj/structure/closet/secure_closet/wall
	door_anim_squish = 0.3
	door_anim_angle = 115
	door_hinge_x = -8.5
	wall_mounted = TRUE
	max_mob_size = MOB_SIZE_SMALL
	density = TRUE
	anchored = TRUE
	anchorable = FALSE
	paint_jobs = FALSE
	icon = 'fenysha_events/icons/structures/closet_wall.dmi'
	icon_state = "locker_wall"

/obj/structure/closet/secure_closet/personal/wall
	door_anim_squish = 0.3
	door_anim_angle = 115
	door_hinge_x = -8.5
	wall_mounted = TRUE
	max_mob_size = MOB_SIZE_SMALL
	density = TRUE
	anchored = TRUE
	anchorable = FALSE
	paint_jobs = FALSE
	icon = 'fenysha_events/icons/structures/closet_wall.dmi'
	icon_state = "locker_wall"

//These procs create empty subtypes when placed by a user rather than a mapper...
//Secure/personal don't get these, since they are made with airlock electronics
/obj/structure/closet/generic/wall/empty/PopulateContents()
	return

/obj/structure/closet/emcloset/wall/empty/PopulateContents()
	return

/obj/structure/closet/firecloset/wall/empty/PopulateContents()
	return

//Wall mounts, for rebuilding the wall closets above
/obj/item/wallframe/closet
	name = "wall mounted closet"
	desc = "It's a wall mounted storage unit for... well, whatever you put in this one. Apply to wall to use."
	icon = 'fenysha_events/icons/structures/closet_wall.dmi'
	icon_state = "locker_mount"
	result_path = /obj/structure/closet/generic/wall/empty
	pixel_shift = 32

/obj/item/wallframe/emcloset
	name = "wall mounted emergency closet"
	desc = "It's a wall mounted storage unit for emergency breath masks and O2 tanks. Apply to wall to use."
	icon = 'fenysha_events/icons/structures/closet_wall.dmi'
	icon_state = "emergency_mount"
	result_path = /obj/structure/closet/emcloset/wall/empty
	pixel_shift = 32

/obj/item/wallframe/firecloset
	name = "wall mounted fire-safety closet"
	desc = "It's a wall mounted storage unit for fire-fighting supplies. Apply to wall to use."
	icon = 'fenysha_events/icons/structures/closet_wall.dmi'
	icon_state = "fire_mount"
	result_path = /obj/structure/closet/firecloset/wall/empty
	pixel_shift = 32
