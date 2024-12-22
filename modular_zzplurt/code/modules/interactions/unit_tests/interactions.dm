/datum/unit_test/interactions/Run()
	make_interactions()
	if(!GLOB.interactions)
		Fail("make_interactions() was called but GLOB.interactions is empty.")
	var/list/check_duplicates = list()
	for(var/datum/interaction/interaction in GLOB.interactions)
		check_duplicates[interaction.command] += 1
	for(var/item in check_duplicates)
		if(item > 1)
			Fail("There are [item[0]] interactions using the command \"[item]\", there can only be one interaction per command!")
	return
