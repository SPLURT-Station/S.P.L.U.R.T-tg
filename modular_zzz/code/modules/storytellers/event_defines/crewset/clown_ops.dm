/datum/round_event_control/antagonist/team/nuke_ops/clown
	name = "Clown Operatives"
	roundstart = TRUE

	antag_flag = ROLE_CLOWN_OPERATIVE
	antag_datum = /datum/antagonist/nukeop/clownop
	antag_leader_datum = /datum/antagonist/nukeop/leader/clownop

	weight = 1
	tags = list(TAG_CREW_ANTAG, TAG_CHAOTIC, TAG_MEDIUM)

	base_antags = 2
	maximum_antags = 5
	maximum_antags_global = 5

	typepath = /datum/round_event/antagonist/team/clown

	ruleset_lazy_templates = list(LAZY_TEMPLATE_KEY_NUKIEBASE)

/datum/round_event/antagonist/team/clown
	var/datum/job/job_type = /datum/job/clown_operative
	var/required_role = ROLE_CLOWN_OPERATIVE

	var/datum/team/nuclear/nuke_team

/datum/round_event/antagonist/team/nukie/nuke_ops/clown/candidate_roles_setup(mob/candidate)
	candidate.mind.set_assigned_role(SSjob.get_job_type(job_type))
	candidate.mind.special_role = required_role

/datum/round_event/antagonist/team/nukie/clown/start()
	. = ..()
	if(!.)
		return

	var/list/nukes = SSmachines.get_machines_by_type(/obj/machinery/nuclearbomb/syndicate)
	for(var/obj/machinery/nuclearbomb/syndicate/nuke as anything in nukes)
		new /obj/machinery/nuclearbomb/syndicate/bananium(nuke.loc)
		qdel(nuke)
