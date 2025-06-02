
/datum/ert/inteq
	leader_role = /datum/antagonist/ert/inteq/leader
	roles = list(/datum/antagonist/ert/inteq)
	code = "Gamma"
	rename_team = "PMC InteQ Squad"
	polldesc = "an PMC InteQ Heavy Team"
	mission = "По имеющимся разведанным, на станции присутствует особо опасный и тяжеловооруженный противник. Мега-Корпорация заинтересована в сохранении своих активов. Разберитесь с проблемой."
	opendoors = FALSE

/datum/antagonist/ert/inteq
	name = "PMC InteQ: ERT"
	outfit = /datum/outfit/centcom/inteq
	plasmaman_outfit = /datum/outfit/plasmaman/centcom_commander
	role = "Trooper"
	rip_and_tear = TRUE

/datum/antagonist/ert/inteq/New()
	. = ..()
	name_source = GLOB.commando_names

/datum/antagonist/ert/inteq/leader
	name = "PMC InteQ: ERT Leader"
	outfit = /datum/outfit/centcom/inteq/officer
	role = "Officer"
