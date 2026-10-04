// This file is for player-facing award tracking.
// Admins currently have access to this functionality, but it needs to be exposed to players.

// Define a datum for player awards
/datum/player_awards
	var/list/awards = list()

	proc
		add_award(award_name, award_description)
			if award_name not in awards
				awards[award_name] = award_description
				log_game("Player award added: [award_name]")
			else
				log_game("Player award already exists: [award_name]")

		remove_award(award_name)
			if award_name in awards
				awards.Remove(award_name)
				log_game("Player award removed: [award_name]")
			else
				log_game("Player award not found: [award_name]")

		get_awards()
			return awards

// Example of how to integrate this with player objects (this would likely be in player.dm or similar)
/*

/mob/living/player
	var/obj/player_awards = null

	New(var/mob/user)
		player_awards = new /datum/player_awards()
		..()

	// Example of adding an award
	proc
		award_player(award_name, award_description)
			if player_awards
				player_awards.add_award(award_name, award_description)

		// Example of displaying awards (this would need a UI element)
		display_awards()
			if player_awards
				var/award_list = player_awards.get_awards()
				var/message = "Your Awards:\n"
				for(var/award in award_list)
					message += "- [award]: [award_list[award]]\n"
				to_chat(src, message)
			else
				to_chat(src, "You have no awards.")
*/
