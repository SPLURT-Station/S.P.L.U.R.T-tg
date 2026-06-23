/area/awaymission/secret/powered/ss_construct
	name = "Констракт"
	area_flags = NO_BOH|QUIET_LOGS|BLOCK_SUICIDE

	ambientsounds = list('fenysha_events/sounds/ambience/construct_inside.ogg')
	max_ambience_cooldown = 0
	min_ambience_cooldown = 0

/area/awaymission/secret/powered/ss_construct/outdoors
	name = "Констракт (на улице)"
	outdoors = TRUE
	daylight = TRUE
	allow_shuttle_docking = TRUE

	ambientsounds = list('fenysha_events/sounds/ambience/construct_outside.ogg')
	max_ambience_cooldown = 0
	min_ambience_cooldown = 0

/area/awaymission/secret/powered/ss_construct/backrooms
	name = "Закулисье"
	area_flags = NO_BOH|HIDDEN_AREA|NOTELEPORT|QUIET_LOGS|BLOCK_SUICIDE

	ambientsounds = list('fenysha_events/sounds/ambience/backrooms_level0.ogg')
	max_ambience_cooldown = 0
	min_ambience_cooldown = 0

/area/awaymission/secret/powered/ss_construct/backrooms/Entered(atom/movable/arrived, area/old_area)
	. = ..()
	if(isliving(arrived))
		arrived.AddComponent(/datum/component/nextbot_target)
		var/mob/living/living = arrived
		living.add_fov_trait(REF(src), FOV_180_DEGREES)

/area/awaymission/secret/powered/ss_construct/backrooms/Exited(atom/movable/gone, direction)
	. = ..()
	if(isliving(gone))
		var/mob/living/living = gone
		living.remove_fov_trait(REF(src), FOV_180_DEGREES)
		if(gone.GetComponent(/datum/component/nextbot_target))
			qdel(gone.GetComponent(/datum/component/nextbot_target))
