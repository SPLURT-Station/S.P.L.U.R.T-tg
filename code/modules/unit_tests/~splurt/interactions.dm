/datum/unit_test/interactions/Run()
	SSinteractions = new()
	SSinteractions.prepare_interactions()
	if(!SSinteractions.interactions || !length(SSinteractions.interactions))
		TEST_FAIL("make_interactions() was called but SSinteractions.interactions is empty.")
	return
