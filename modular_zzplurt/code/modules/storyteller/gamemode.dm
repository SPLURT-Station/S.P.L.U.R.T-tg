/datum/controller/subsystem/gamemode/proc/storyteller_vote_can_override()
	var/days_until_storyteller_votable = CONFIG_GET(number/days_until_storyteller_votable)
	var/rounds_until_storyteller_votable = CONFIG_GET(number/rounds_until_storyteller_votable)

	if(!(days_until_storyteller_votable && rounds_until_storyteller_votable))
		return FALSE

	if(!(text2num(time2text(world.realtime, "DD")) % days_until_storyteller_votable == 0))
		return FALSE

	if(!(text2num(GLOB.round_id) % rounds_until_storyteller_votable == 0))
		return FALSE

	return TRUE
