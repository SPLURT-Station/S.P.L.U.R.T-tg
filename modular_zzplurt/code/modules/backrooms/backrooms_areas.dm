/area/awaymission/secret/powered/backrooms
	name = "The backrooms"
	area_flags = NO_BOH|HIDDEN_AREA|NOTELEPORT|QUIET_LOGS|BLOCK_SUICIDE

	ambientsounds = list('modular_zzplurt/sound/ambience/backrooms_level0.ogg')
	max_ambience_cooldown = 0
	min_ambience_cooldown = 0


/area/awaymission/secret/powered/backrooms/Entered(atom/movable/arrived, area/old_area)
	. = ..()
	if(isliving(arrived))
		arrived.AddComponent(/datum/component/nextbot_target)
		var/mob/living/living = arrived
		living.add_fov_trait(REF(src), FOV_180_DEGREES)

/area/awaymission/secret/powered/backrooms/Exited(atom/movable/gone, direction)
	. = ..()
	if(isliving(gone))
		var/mob/living/living = gone
		living.remove_fov_trait(REF(src), FOV_180_DEGREES)
		if(gone.GetComponent(/datum/component/nextbot_target))
			qdel(gone.GetComponent(/datum/component/nextbot_target))

