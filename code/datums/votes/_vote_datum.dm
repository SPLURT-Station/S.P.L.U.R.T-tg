
/**
 * # Vote Singleton
 *
 * A singleton datum that represents a type of vote for the voting subsystem.
 */
/datum/vote
	/// The name of the vote.
	var/name
	/// If supplied, an override question will be displayed instead of the name of the vote.
	var/override_question
	/// The sound effect played to everyone when this vote is initiated.
	var/vote_sound = 'sound/misc/bloop.ogg'
	/// A list of default choices we have for this vote.
	var/list/default_choices
	/// Does the name of this vote contain the word "vote"?
	var/contains_vote_in_name = FALSE
	/// What message do we show as the tooltip of this vote if the vote can be initiated?
	var/default_message = "Click to initiate a vote."
	/// The counting method we use for votes.
	var/count_method = VOTE_COUNT_METHOD_SINGLE
	/// The method for selecting a winner.
	var/winner_method = VOTE_WINNER_METHOD_SIMPLE
	/// Should we show details about the number of votes submitted for each option?
	var/display_statistics = TRUE
	/// The threshold for a winner in ranked voting as a percentage (0-100)
	var/ranked_winner_threshold = 50

	// Internal values used when tracking ongoing votes.
	// Don't mess with these, change the above values / override procs for subtypes.
	/// An assoc list of [all choices] to [number of votes in the current running vote].
	VAR_FINAL/list/choices = list()
	/// A assoc list of [ckey] to [what they voted for in the current running vote].
	VAR_FINAL/list/choices_by_ckey = list()
	/// The world time this vote was started.
	VAR_FINAL/started_time = -1
	/// The time remaining in this vote's run.
	VAR_FINAL/time_remaining = -1

/**
 * Used to determine if this vote is a possible
 * vote type for the vote subsystem.
 *
 * If FALSE is returned, this vote singleton
 * will not be created when the vote subsystem initializes,
 * meaning no one will be able to hold this vote.
 */
/datum/vote/proc/is_accessible_vote()
	return !!length(default_choices)

/**
 * Resets our vote to its default state.
 */
/datum/vote/proc/reset()
	SHOULD_CALL_PARENT(TRUE)

	choices.Cut()
	choices_by_ckey.Cut()
	started_time = null
	time_remaining = -1

/**
 * If this vote has a config associated, toggles it between enabled and disabled.
 */
/datum/vote/proc/toggle_votable()
	return

/**
 * If this vote has a config associated, returns its value (True or False, usually).
 * If it has no config, returns -1.
 */
/datum/vote/proc/is_config_enabled()
	return -1

/**
 * Checks if the passed mob can initiate this vote.
 *
 * * forced - if being invoked by someone who is an admin
 *
 * Return VOTE_AVAILABLE if the mob can initiate the vote.
 * Return a string with the reason why the mob can't initiate the vote.
 */
/datum/vote/proc/can_be_initiated(forced = FALSE)
	SHOULD_CALL_PARENT(TRUE)

	if(!forced && !is_config_enabled())
		return "This vote is currently disabled by the server configuration."

	return VOTE_AVAILABLE

/**
 * Called prior to the vote being initiated.
 *
 * Return FALSE to prevent the vote from being initiated.
 */
/datum/vote/proc/create_vote(mob/vote_creator)
	SHOULD_CALL_PARENT(TRUE)

	for(var/key in default_choices)
		choices[key] = 0

	return TRUE

/**
 * Called when this vote is actually initiated.
 *
 * Return a string - the text displayed to the world when the vote is initiated.
 */
/datum/vote/proc/initiate_vote(initiator, duration)
	SHOULD_CALL_PARENT(TRUE)

	started_time = world.time
	time_remaining = round(duration / 10)

	return "[contains_vote_in_name ? "[capitalize(name)]" : "[capitalize(name)] vote"] started by [initiator || "Central Command"]."

/**
 * Gets the result of the vote.
 *
 * non_voters - a list of all ckeys who didn't vote in the vote.
 *
 * Returns a list of all options that won.
 * If there were no votes at all, the list will be length = 0, non-null.
 * If only one option one, the list will be length = 1.
 * If there was a tie, the list will be length > 1.
 */
/datum/vote/proc/get_vote_result(list/non_voters)
	RETURN_TYPE(/list)
	SHOULD_CALL_PARENT(TRUE)

	switch(winner_method)
		if(VOTE_WINNER_METHOD_NONE)
			return list()
		if(VOTE_WINNER_METHOD_SIMPLE)
			return get_simple_winner()
		if(VOTE_WINNER_METHOD_WEIGHTED_RANDOM)
			return get_random_winner()
		if(VOTE_WINNER_METHOD_RANKED)
			return get_ranked_winner()

	stack_trace("invalid select winner method: [winner_method]. Defaulting to simple.")
	return get_simple_winner()

/// Gets the winner of the vote, selecting the choice with the most votes.
/datum/vote/proc/get_simple_winner()
	var/highest_vote = 0
	var/list/current_winners = list()

	for(var/option in choices)
		var/vote_count = choices[option]
		if(vote_count < highest_vote)
			continue

		if(vote_count > highest_vote)
			highest_vote = vote_count
			current_winners = list(option)
			continue
		current_winners += option

	return length(current_winners) ? current_winners : list()

/// Gets the winner of the vote, selecting a random choice from all choices based on their vote count.
/datum/vote/proc/get_random_winner()
	var/winner = pick_weight(choices)
	return winner ? list(winner) : list()

/// Gets the winner using ranked choice voting.
/datum/vote/proc/get_ranked_winner()
	// Total number of voters who submitted at least one ranked choice
	var/total_voters = 0
	// List of all voter ckeys
	var/list/all_voters = list()

	// Collect all voters and create a map of their current rankings
	var/list/voter_rankings = list() // Stores current rankings for each voter
	for(var/key in choices_by_ckey)
		var/split_key = splittext(key, "_")
		if(length(split_key) != 2)
			continue

		var/ckey = split_key[1]
		var/choice = split_key[2]
		var/rank = choices_by_ckey[key]

		if(rank > 0)
			if(!(ckey in all_voters))
				all_voters += ckey
				total_voters++
				voter_rankings[ckey] = list()

			voter_rankings[ckey][choice] = rank

	// Log initial state to admins
	var/admin_msg = "Ranked Vote Initial State:\n"
	admin_msg += "Total Voters: [total_voters]\n"
	admin_msg += "Current Choices:\n"
	for(var/choice in choices)
		admin_msg += "\t[choice]: [choices[choice]] votes\n"
	admin_msg += "\nVoter Rankings:\n"
	for(var/ckey in voter_rankings)
		admin_msg += "\t[ckey]'s rankings:\n\t\t"
		var/list/sorted_rankings = list()
		var/list/rankings = voter_rankings[ckey]
		for(var/i in 1 to length(rankings))
			for(var/choice in rankings)
				if(rankings[choice] == i)
					sorted_rankings += "[i]. [choice]"
		admin_msg += sorted_rankings.Join(", ") + "\n"
	message_admins(admin_msg)

	// If no one voted, return empty list
	if(total_voters == 0)
		return list()

	// Calculate the threshold for victory
	var/victory_threshold = round((total_voters * ranked_winner_threshold) / 100, 1)
	message_admins("Victory threshold set to [victory_threshold] votes ([ranked_winner_threshold]% of [total_voters] voters)")

	var/round_number = 1
	// While we still have choices to consider
	while(length(choices) > 1)
		message_admins("=== Round [round_number] of Ranked Choice Voting ===")

		// Find highest vote count and check if it meets threshold
		var/highest_votes = 0
		var/list/highest_choices = list()

		for(var/option in choices)
			var/votes = choices[option]
			if(votes > highest_votes)
				highest_votes = votes
				highest_choices = list(option)
			else if(votes == highest_votes)
				highest_choices += option

		// Check if any option has reached the threshold
		if(highest_votes >= victory_threshold)
			message_admins("Victory threshold ([victory_threshold]) reached! Winner(s): [highest_choices.Join(", ")] with [highest_votes] votes")
			return highest_choices

		// Find lowest vote count to eliminate
		var/lowest_votes = INFINITY
		var/list/lowest_choices = list()

		for(var/option in choices)
			var/votes = choices[option]
			if(votes < lowest_votes)
				lowest_votes = votes
				lowest_choices = list(option)
			else if(votes == lowest_votes)
				lowest_choices += option

		// If we have multiple options with the lowest votes, pick one randomly
		var/option_to_eliminate
		if(length(lowest_choices) > 1)
			option_to_eliminate = pick(lowest_choices)
			message_admins("Multiple options tied for lowest votes ([lowest_votes]): [lowest_choices.Join(", ")]. Randomly eliminating: [option_to_eliminate]")
		else
			option_to_eliminate = lowest_choices[1]
			message_admins("Eliminating [option_to_eliminate] with lowest votes: [lowest_votes]")

		// Remove the eliminated option from choices
		choices -= option_to_eliminate

		// Update rankings and redistribute votes
		var/redistribution_msg = "Vote redistribution after eliminating [option_to_eliminate]:\n"
		for(var/ckey in voter_rankings)
			var/list/rankings = voter_rankings[ckey]
			var/eliminated_rank = rankings[option_to_eliminate]
			if(!eliminated_rank)
				continue

			// Remove the eliminated option from their rankings
			rankings -= option_to_eliminate

			// If it was their first choice, we need to redistribute their vote
			if(eliminated_rank == 1)
				// Find their new first choice
				var/new_first_choice
				var/lowest_rank = INFINITY
				for(var/choice in rankings)
					var/rank = rankings[choice]
					if(rank < lowest_rank)
						lowest_rank = rank
						new_first_choice = choice

				// Redistribute the vote if they have another choice
				if(new_first_choice)
					redistribution_msg += "\t[ckey]'s vote moved from [option_to_eliminate] to [new_first_choice]\n"
					choices[new_first_choice]++

				// Adjust all remaining ranks down by 1
				for(var/choice in rankings)
					rankings[choice]--

			// Update the choices_by_ckey list to reflect the new rankings
			for(var/choice in rankings)
				choices_by_ckey["[ckey]_[choice]"] = rankings[choice]

		message_admins(redistribution_msg)

		// Log current state of choices and rankings
		var/status_msg = "Current vote counts after round [round_number]:\n"
		for(var/option in choices)
			status_msg += "\t[option]: [choices[option]] votes\n"
		status_msg += "\nUpdated Rankings:\n"
		for(var/ckey in voter_rankings)
			status_msg += "\t[ckey]'s rankings:\n\t\t"
			var/list/sorted_rankings = list()
			var/list/rankings = voter_rankings[ckey]
			for(var/i in 1 to length(rankings))
				for(var/choice in rankings)
					if(rankings[choice] == i)
						sorted_rankings += "[i]. [choice]"
			status_msg += sorted_rankings.Join(", ") + "\n"
		message_admins(status_msg)

		round_number++

	// If we're down to one option, it's the winner
	if(length(choices) == 1)
		message_admins("Only one option remains: [choices[1]] is the winner!")
		return list(choices[1])

	// This should never happen but just in case
	message_admins("ERROR: Ranked choice voting ended with no winner!")
	return list()

/**
 * Gets the resulting text displayed when the vote is completed.
 *
 * all_winners - list of all options that won. Can be multiple, in the event of ties.
 * real_winner - the option that actually won.
 * non_voters - a list of all ckeys who didn't vote in the vote.
 *
 * Return a formatted string of text to be displayed to everyone.
 */
/datum/vote/proc/get_result_text(list/all_winners, real_winner, list/non_voters)
	var/title_text = ""
	var/returned_text = ""
	if(override_question)
		title_text += span_bold(override_question)
	else
		title_text += span_bold("[capitalize(name)] Vote")

	returned_text += "Winner Selection: "
	switch(winner_method)
		if(VOTE_WINNER_METHOD_NONE)
			returned_text += "None"
		if(VOTE_WINNER_METHOD_WEIGHTED_RANDOM)
			returned_text += "Weighted Random"
		if(VOTE_WINNER_METHOD_RANKED)
			returned_text += "Ranked"
		else
			returned_text += "Simple"

	var/total_votes = 0 // for determining percentage of votes
	for(var/option in choices)
		total_votes += choices[option]

	if(total_votes <= 0)
		return span_bold("Vote Result: Inconclusive - No Votes!")

	if (display_statistics)
		returned_text += "\nResults:"
		for(var/option in choices)
			returned_text += "\n"
			var/votes = choices[option]
			var/percentage_text = ""
			if(votes > 0)
				var/actual_percentage = round((votes / total_votes) * 100, 0.1)
				var/text = "[actual_percentage]"
				var/spaces_needed = 5 - length(text)
				for(var/_ in 1 to spaces_needed)
					returned_text += " "
				percentage_text += "[text]%"
			else
				percentage_text = "    0%"
			returned_text += "[percentage_text] | [span_bold(option)]: [choices[option]]"

	if(!real_winner) // vote has no winner or cannot be won, but still had votes
		return returned_text

	returned_text += "\n"
	returned_text += get_winner_text(all_winners, real_winner, non_voters)

	return fieldset_block(title_text, returned_text, "boxed_message purple_box")

/**
 * Gets the text that displays the winning options within the result text.
 *
 * all_winners - list of all options that won. Can be multiple, in the event of ties.
 * real_winner - the option that actually won.
 * non_voters - a list of all ckeys who didn't vote in the vote.
 *
 * Return a formatted string of text to be displayed to everyone.
 */
/datum/vote/proc/get_winner_text(list/all_winners, real_winner, list/non_voters)
	var/returned_text = ""
	if(length(all_winners) > 1)
		returned_text += "\n[span_bold("Vote Tied Between:")]"
		for(var/a_winner in all_winners)
			returned_text += "\n\t[a_winner]"

	returned_text += span_bold("\nVote Result: [real_winner]")
	return returned_text

/**
 * How this vote handles a tiebreaker between multiple winners.
 */
/datum/vote/proc/tiebreaker(list/winners)
	return pick(winners)

/**
 * Called when a vote is actually all said and done.
 * Apply actual vote effects here.
 */
/datum/vote/proc/finalize_vote(winning_option)
	return
