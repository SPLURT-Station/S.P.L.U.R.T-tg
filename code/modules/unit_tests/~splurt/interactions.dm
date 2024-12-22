/datum/unit_test/interactions/Run()
	SSinteractions.make_interactions()
	if(!SSinteractions.interactions || !length(SSinteractions.interactions))
		TEST_FAIL("make_interactions() was called but SSinteractions.interactions is empty.")
	var/list/check_duplicates = list()
	for(var/datum/interaction/interaction in SSinteractions.interactions)
		check_duplicates[interaction.command] += 1
	for(var/item in check_duplicates)
		if(item > 1)
			TEST_FAIL("There are [check_duplicates[item]] interactions using the command \"[item]\", there can only be one interaction per command!")
	return
