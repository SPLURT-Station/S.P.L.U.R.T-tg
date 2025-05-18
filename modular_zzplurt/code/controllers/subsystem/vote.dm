/**
 * Ranked choice voting, where voters rank options in order of preference.
 * If an option doesn't reach the threshold, lowest votes are transferred to next preferences.
 */
/datum/controller/subsystem/vote/proc/submit_ranked_vote(mob/voter, their_vote, rank)
	if(!current_vote)
		return
	if(!voter?.ckey)
		return
	if(CONFIG_GET(flag/no_dead_vote) && voter.stat == DEAD && !voter.client?.holder)
		return
	if(!current_vote.can_mob_vote(voter))
		return

	var/ckey = voter.ckey
	voted += ckey

	// Clear previous ranking for this option if any
	var/old_rank = current_vote.choices_by_ckey["[ckey]_[their_vote]"]
	if(old_rank)
		// Remove the old first place vote if we're changing from rank 1
		if(old_rank == 1)
			current_vote.choices[their_vote]--
		current_vote.choices_by_ckey["[ckey]_[their_vote]"] = null

	// Add new ranking
	if(rank > 0)
		current_vote.choices_by_ckey["[ckey]_[their_vote]"] = rank
		// Only count first place votes in the total
		if(rank == 1)
			current_vote.choices[their_vote]++

	return TRUE

/datum/controller/subsystem/vote/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/voter = usr

	switch(action)
		if("voteRanked")
			return submit_ranked_vote(voter, params["voteOption"], params["voteRank"])

