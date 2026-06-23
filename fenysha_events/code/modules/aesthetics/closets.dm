/obj/structure/closet/generic/wall
	door_anim_squish = 0.3
	door_anim_angle = 115
	door_hinge_x = -8.5
	wall_mounted = TRUE
	max_mob_size = MOB_SIZE_SMALL
	density = TRUE
	anchored = TRUE
	anchorable = FALSE //Предотвращает откручивание и перетаскивание. Нужно отварить!
	paint_jobs = FALSE //Предотвращает перекраску в другие ненастенные шкафы.
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

//Эти две предварительно заблокированные версии closet/generic/wall, только для маппинга
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

//Эти прок создают пустые подтипы, когда размещаются пользователем, а не маппером...
//Secure/personal не получают эти, так как они делаются с электроникой воздушного шлюза
/obj/structure/closet/generic/wall/empty/PopulateContents()
	return

/obj/structure/closet/emcloset/wall/empty/PopulateContents()
	return

/obj/structure/closet/firecloset/wall/empty/PopulateContents()
	return

//Настенные крепления, для перестройки настенных шкафов выше
/obj/item/wallframe/closet
	name = "настенный шкаф" // wall mounted closet
	desc = "Настенное хранилище для... ну, что бы вы в него не положили. Примените к стене для использования." // It's a wall mounted storage unit for... well, whatever you put in this one. Apply to wall to use.
	icon = 'fenysha_events/icons/structures/closet_wall.dmi'
	icon_state = "locker_mount"
	result_path = /obj/structure/closet/generic/wall/empty
	pixel_shift = 32

/obj/item/wallframe/emcloset
	name = "настенный аварийный шкаф" // wall mounted emergency closet
	desc = "Настенное хранилище для аварийных дыхательных масок и баллонов с О2. Примените к стене для использования." // It's a wall mounted storage unit for emergency breath masks and O2 tanks. Apply to wall to use.
	icon = 'fenysha_events/icons/structures/closet_wall.dmi'
	icon_state = "emergency_mount"
	result_path = /obj/structure/closet/emcloset/wall/empty
	pixel_shift = 32

/obj/item/wallframe/firecloset
	name = "настенный пожарный шкаф" // wall mounted fire-safety closet
	desc = "Настенное хранилище для пожарного инвентаря. Примените к стене для использования." // It's a wall mounted storage unit for fire-fighting supplies. Apply to wall to use.
	icon = 'fenysha_events/icons/structures/closet_wall.dmi'
	icon_state = "fire_mount"
	result_path = /obj/structure/closet/firecloset/wall/empty
	pixel_shift = 32
