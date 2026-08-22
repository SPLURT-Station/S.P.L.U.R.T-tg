/datum/controller/subsystem/ticker/equip_characters()
	. = ..()
	for(var/mob/dead/new_player/new_player_mob as anything in GLOB.new_player_list)
		if(QDELETED(new_player_mob) || !isliving(new_player_mob.new_character))
			CHECK_TICK
			continue
		var/mob/living/new_player_living = new_player_mob.new_character
		if(!new_player_living.mind)
			CHECK_TICK
			continue
		if(ishuman(new_player_living))
			SEND_GLOBAL_SIGNAL(COMSIG_GLOBAL_PLAYER_SETUP_FINISHED, new_player_living)
			CHECK_TICK

/mob/dead/new_player
	var/mob/living/to_transfer = null

/mob/dead/new_player/create_character(atom/destination)
	. = ..()
	to_transfer = .

/mob/dead/new_player/AttemptLateSpawn(rank)
	. = ..()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOBAL_PLAYER_SETUP_FINISHED, to_transfer)
