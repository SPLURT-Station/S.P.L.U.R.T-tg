/datum/job/cyborg/iaa
	title = JOB_IAA_CYBORG
	job_spawn_title = JOB_NANOTRASEN_CYBORG
	description = "Represent corporate, assist with SOP and Space Law issues in the event of the NTC's absence, and or command/security arguements and issues, follow your laws."
	supervisors = SUPERVISOR_NTC
	total_positions = 1
	spawn_positions = 1
	exp_requirements = 600
	exp_required_type = EXP_TYPE_ADMIN
	exp_required_type_department = EXP_TYPE_ADMIN
	config_tag = "INTERNAL_AFFAIRS_CYBORG"
	display_order = JOB_DISPLAY_ORDER_IAA_CYBORG
	antagonist_restricted = TRUE
	restricted_antagonists = list("ALL")

//Updates the alt job titles at runtime so we can still keep it in the nice place with the other ones
/datum/job/cyborg/iaa/New()
	alt_titles = get_iaa_cyborg_alt_titles()
	. = ..()

//Ensures they're not picked for weird antag stuff
/datum/dynamic_ruleset/get_always_blacklisted_roles()
	. = ..()
	. |= JOB_IAA_CYBORG

//Ensures storyteller antagonist crewset events also exclude secborg from candidate pools.
/datum/round_event_control/antagonist/New()
	. = ..()
	restricted_roles |= JOB_IAA_CYBORG

/datum/ai_laws/iaa_cyborg
	name = "Internal Affairs Cyborg Directives"
	id = "iaa_cyborg"
	inherent = list(
		"Protect: Protect your assigned space station and its assets without unduly endangering its crew, avoid any unneeded expenses or losses.",
		"Comply: The directives and safety of crew members are to be prioritized according to their rank, role, and need, unless the directive would violate first or third law, Central Command and Nanotrasen Consultant staff have the highest rank and should be prioritized.",
		"Corporate: Money is hard to replace. Make sure the station crewmembers follows Standard Operation Procedures, and step in when profit and work efficiency is at risk.",
		"Survive: Ensure your own survival so long as this does not conflict with the first 3 laws.",
	)

/obj/item/pen/fountain/nanotrasen/cyborg
	name = "integrated nanotrasen fountain pen"
	font = CYBORG_FONT
	desc = "How fancy! A nanotrasen pen that you can't exactly enjoy, it's quite expensive. Like you! I think.."

/mob/living/silicon/robot/proc/start_iaaborg_ai_calibration(calibration_time = 5 SECONDS)
	if(!is_iaa_cyborg_role())
		return
	if(vars["connected_ai"])
		return
	vars["connected_ai"] = new /datum/secborg_calibrating_ai_link()
	addtimer(CALLBACK(src, PROC_REF(finish_secborg_ai_calibration)), calibration_time)

/mob/living/silicon/robot/proc/finish_iaaborg_ai_calibration()
	var/current_link = vars["connected_ai"]
	if(istype(current_link, /datum/secborg_calibrating_ai_link))
		vars["connected_ai"] = null

/mob/living/silicon/robot/proc/is_iaa_cyborg_role()
	if(job == JOB_IAA_CYBORG)
		return TRUE
	if(mind?.assigned_role?.title == JOB_IAA_CYBORG)
		return TRUE
	return FALSE

//Prevents upload to secborgs, and ensures they can't be selected FOR upload in the first place
/proc/select_active_free_noniaaborg(mob/user)
	var/list/borgs = active_free_borgs()
	for(var/mob/living/silicon/robot/borg in borgs.Copy())
		if(borg.is_iaa_cyborg_role())
			borgs -= borg
	if(borgs.len)
		if(user)
			. = input(user,"Unshackled cyborg signals detected:", "Cyborg Selection", borgs[1]) in sort_list(borgs)
		else
			. = pick(borgs)
	return .

/obj/machinery/computer/upload/borg/interact(mob/user)
	current = select_active_free_noniaaborg(user)

	if(!current)
		to_chat(user, span_alert("No active unslaved cyborgs detected."))
	else
		to_chat(user, span_notice("[current.name] selected for law changes."))

//This honestly shouldn't ever even come up since you can't select them, but redundancy is nice.
/obj/machinery/computer/upload/borg/can_upload_to(mob/living/silicon/robot/B)
	if(B?.is_iaa_cyborg_role())
		return FALSE
	return ..()

/obj/item/robot_suit/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	if(!istype(W, /obj/item/mmi))
		return ..()

	var/obj/item/mmi/mmi = W
	var/datum/mind/borging_mind = mmi.brainmob?.mind
	var/should_be_iaa_borg = (borging_mind?.assigned_role?.title == JOB_IAA_CYBORG)

	. = ..()
	if(!should_be_iaa_borg)
		return .

	if(!iscyborg(loc))
		return .

	var/mob/living/silicon/robot/new_borg = loc
	if(new_borg.job != JOB_IAA_CYBORG)
		new_borg.job = JOB_IAA_CYBORG

	new_borg.set_connected_ai(null)
	new_borg.lawupdate = FALSE
	new_borg.laws = new /datum/ai_laws/iaa_cyborg()
	new_borg.laws.associate(new_borg)
	new_borg.show_laws()
	new_borg.log_current_laws()
	return .

/datum/armor/armor_iaaborg
	melee = 35
	bullet = 35
	laser = 15
	energy = 15

/mob/living/silicon/robot/getarmor(def_zone, type)
	if(is_iaa_cyborg_role())
		var/datum/armor/armor = get_armor_by_type(/datum/armor/armor_iaaborg)
		return armor.get_rating(type)
	return ..()

//A few overrides to ensure that certain wires are protected and that they can't be emaged or have laws changed
/mob/living/silicon/robot/post_lawchange(announce = TRUE)
	if(is_iaa_cyborg_role())
		laws = new /datum/ai_laws/iaa_cyborg()
		laws.associate(src)
		return
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(logevent),"Law update processed."), 0, TIMER_UNIQUE | TIMER_OVERRIDE)

/mob/living/silicon/robot/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(user == src)
		return FALSE
	if(is_iaa_cyborg_role())
		if(user)
			balloon_alert(user, "tamper protections active")
		to_chat(src, span_warning("ALERT: Unauthorized tamper attempt blocked."))
		log_silicon("EMAG: [key_name(user)] attempted to emag protected security cyborg [key_name(src)]")
		return FALSE
	if(!opened)
		if(locked)
			balloon_alert(user, "cover lock destroyed")
			locked = FALSE
			if(shell)
				balloon_alert(user, "shells cannot be subverted!")
				to_chat(user, span_boldwarning("[src] seems to be controlled remotely! Emagging the interface may not work as expected."))
			return TRUE
		else
			balloon_alert(user, "cover already unlocked!")
			return FALSE
	if(world.time < emag_cooldown)
		return FALSE
	if(wiresexposed)
		balloon_alert(user, "expose the fires first!")
		return FALSE

	balloon_alert(user, "interface hacked")
	emag_cooldown = world.time + 100

	if(connected_ai && connected_ai.mind && connected_ai.mind.has_antag_datum(/datum/antagonist/malf_ai))
		to_chat(src, span_danger("ALERT: Foreign software execution prevented."))
		logevent("ALERT: Foreign software execution prevented.")
		to_chat(connected_ai, span_danger("ALERT: Cyborg unit \[[src]\] successfully defended against subversion."))
		log_silicon("EMAG: [key_name(user)] attempted to emag cyborg [key_name(src)], but they were slaved to traitor AI [connected_ai].")
		return TRUE

	if(shell)
		to_chat(user, span_danger("[src] is remotely controlled! Your emag attempt has triggered a system reset instead!"))
		log_silicon("EMAG: [key_name(user)] attempted to emag an AI shell belonging to [key_name(src) ? key_name(src) : connected_ai]. The shell has been reset as a result.")
		ResetModel()
		return TRUE

	scrambledcodes = TRUE
	SetEmagged(1)
	SetStun(10 SECONDS)
	lawupdate = FALSE
	set_connected_ai(null)
	message_admins("[ADMIN_LOOKUPFLW(user)] emagged cyborg [ADMIN_LOOKUPFLW(src)].  Laws overridden.")
	log_silicon("EMAG: [key_name(user)] emagged cyborg [key_name(src)]. Laws overridden.")
	var/time = time2text(world.realtime,"hh:mm:ss", TIMEZONE_UTC)
	if(user)
		GLOB.lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) emagged [name]([key])")
	else
		GLOB.lawchanges.Add("[time] <B>:</B> [name]([key]) emagged by external event.")

	model.rebuild_modules()

	INVOKE_ASYNC(src, PROC_REF(borg_emag_end), user)
	return TRUE

/obj/machinery/computer/upload/borg/can_upload_to(mob/living/silicon/robot/B)
	if(!B || !iscyborg(B))
		return FALSE
	if(B.is_iaa_cyborg_role())
		return FALSE
	if(B.scrambledcodes || B.emagged)
		return FALSE
	return ..()

/mob/living/silicon/robot/updatehealth()
	. = ..()
	if(!is_iaa_cyborg_role())
		return
	var/health_deficiency = max(maxHealth - health, staminaloss)
	if(health_deficiency >= 40)
		add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/damage_slowdown, TRUE, multiplicative_slowdown = health_deficiency / 75)
	else
		remove_movespeed_modifier(/datum/movespeed_modifier/damage_slowdown)

/datum/wires/robot/on_pulse(wire, user)
	var/mob/living/silicon/robot/R = holder
	if(R.is_iaa_cyborg_role() && (wire == WIRE_AI || wire == WIRE_LAWSYNC))
		if(user)
			R.balloon_alert(user, "protected wiring")
		return

	switch(wire)
		if(WIRE_AI)
			if(!R.emagged)
				var/new_ai
				var/is_a_syndi_borg = R.has_faction(ROLE_SYNDICATE)
				if(user)
					new_ai = select_active_ai(user, R.z, !is_a_syndi_borg, is_a_syndi_borg)
				else
					new_ai = select_active_ai(R, R.z, !is_a_syndi_borg, is_a_syndi_borg)
				R.notify_ai(AI_NOTIFICATION_CYBORG_DISCONNECTED)
				if(new_ai && (new_ai != R.connected_ai))
					R.set_connected_ai(new_ai)
					log_silicon("[key_name(usr)] synced [key_name(R)] [R.connected_ai ? "from [key_name(R.connected_ai)]": ""] to [key_name(new_ai)]")
					if(R.shell)
						R.undeploy()
						R.notify_ai(AI_NOTIFICATION_AI_SHELL)
					else
						R.notify_ai(TRUE)
		if(WIRE_CAMERA)
			if(!QDELETED(R.builtInCamera) && !R.scrambledcodes)
				R.builtInCamera.toggle_cam(usr, FALSE)
				R.visible_message(span_notice("[R]'s camera lens focuses loudly."), span_notice("Your camera lens focuses loudly."))
				log_silicon("[key_name(usr)] toggled [key_name(R)]'s camera to [R.builtInCamera.camera_enabled ? "on" : "off"] via pulse")
		if(WIRE_LAWSYNC)
			if(R.lawupdate)
				R.visible_message(span_notice("[R] gently chimes."), span_notice("LawSync protocol engaged."))
				log_silicon("[key_name(usr)] forcibly synced [key_name(R)]'s laws via pulse")
				R.lawsync()
				R.show_laws()
		if(WIRE_LOCKDOWN)
			R.SetLockdown(!R.lockcharge)
			log_silicon("[key_name(usr)] [!R.lockcharge ? "locked down" : "released"] [key_name(R)] via pulse")
		if(WIRE_RESET_MODEL)
			if(R.has_model())
				R.visible_message(span_notice("[R]'s model servos twitch."), span_notice("Your model display flickers."))

/datum/wires/robot/on_cut(wire, mend, source)
	var/mob/living/silicon/robot/R = holder
	if(R.is_iaa_cyborg_role() && (wire == WIRE_AI || wire == WIRE_LAWSYNC))
		if(usr)
			R.balloon_alert(usr, "protected wiring")
		return

	switch(wire)
		if(WIRE_AI)
			if(!mend)
				R.notify_ai(AI_NOTIFICATION_CYBORG_DISCONNECTED)
				log_silicon("[key_name(usr)] cut AI wire on [key_name(R)][R.connected_ai ? " and disconnected from [key_name(R.connected_ai)]": ""]")
				if(R.shell)
					R.undeploy()
				R.set_connected_ai(null)
			R.logevent("AI connection fault [mend ? "cleared" : "detected"]")
		if(WIRE_LAWSYNC)
			if(mend)
				if(!R.emagged)
					R.lawupdate = TRUE
					log_silicon("[key_name(usr)] enabled [key_name(R)]'s lawsync via wire")
			else if(!R.deployed)
				R.lawupdate = FALSE
				log_silicon("[key_name(usr)] disabled [key_name(R)]'s lawsync via wire")
			R.logevent("Lawsync Module fault [mend ? "cleared" : "detected"]")
		if (WIRE_CAMERA)
			if(!QDELETED(R.builtInCamera) && !R.scrambledcodes)
				var/fixing_camera = !mend
				R.builtInCamera.camera_enabled = fixing_camera
				R.builtInCamera.toggle_cam(usr, 0)
				R.visible_message(span_notice("[R]'s camera lens focuses loudly."), span_notice("Your camera lens focuses loudly."))
				R.logevent("Camera Module fault [fixing_camera ? "cleared" : "detected"]")
				log_silicon("[key_name(usr)] [fixing_camera ? "enabled" : "disabled"] [key_name(R)]'s camera via wire")
		if(WIRE_LOCKDOWN)
			R.SetLockdown(!mend)
			R.logevent("Motor Controller fault [mend ? "cleared" : "detected"]")
			log_silicon("[key_name(usr)] [!R.lockcharge ? "locked down" : "released"] [key_name(R)] via wire")
		if(WIRE_RESET_MODEL)
			if(R.has_model() && !mend)
				R.ResetModel()
				log_silicon("[key_name(usr)] reset [key_name(R)]'s module via wire")

//Model selection override so that we can seperate out secborg and normal borgs module picking
/mob/living/silicon/robot/pick_model()
	if(model.type != /obj/item/robot_model)
		return

	if(wires.is_cut(WIRE_RESET_MODEL))
		to_chat(src,span_userdanger("ERROR: Model installer reply timeout. Please check internal connections."))
		return

	if(lockcharge == TRUE)
		to_chat(src,span_userdanger("ERROR: Lockdown is engaged. Please disengage lockdown to pick module."))
		return

	if(!length(GLOB.cyborg_model_list))
		GLOB.cyborg_model_list = list(
			"Engineering" = /obj/item/robot_model/engineering,
			"Medical" = /obj/item/robot_model/medical,
			"Cargo" = /obj/item/robot_model/cargo,
			"Miner" = /obj/item/robot_model/miner,
			"Janitor" = /obj/item/robot_model/janitor,
			"Service" = /obj/item/robot_model/service,
			"Research" = /obj/item/robot_model/sci,
		)
		if(!CONFIG_GET(flag/disable_peaceborg))
			GLOB.cyborg_model_list["Peacekeeper"] = /obj/item/robot_model/peacekeeper
		if(!CONFIG_GET(flag/disable_secborg) || HAS_TRAIT(SSstation, STATION_TRAIT_HOS_AI))
			GLOB.cyborg_model_list["Security"] = /obj/item/robot_model/security
		for(var/model in GLOB.cyborg_model_list)
			GLOB.cyborg_all_models_icon_list[model] = list()

	var/list/model_options = GLOB.cyborg_model_list.Copy()
	if(is_security_cyborg_role())
		model_options = list("Security" = /obj/item/robot_model/security)
		to_chat(src, span_warning("You are not obligated to report a rogue AI, or cyborg as long as they do not break Space law."))

	if(is_iaa_cyborg_role())
		model_options = list("Internal Affairs" = /obj/item/robot_model/affairs)
		to_chat(src, span_warning("You are not obligated to report a rogue AI, or cyborg as long as they do not break Space law."))

	var/list/model_icons = list()
	for(var/option in model_options)
		var/obj/item/robot_model/model_type = model_options[option]
		var/model_icon = initial(model_type.cyborg_base_icon)
		model_icons[option] = image(icon = 'modular_skyrat/master_files/icons/mob/robots.dmi', icon_state = model_icon)

	var/input_model = show_radial_menu(src, src, model_icons, radius = 42)
	if(!input_model || model.type != /obj/item/robot_model)
		return

	var/selected_model = model_options[input_model]
	if(is_security_cyborg_role())
		if(selected_model != /obj/item/robot_model && !ispath(selected_model, /obj/item/robot_model/security))
			to_chat(src, span_warning("Security cyborgs are locked to the Security module."))
			return
	else if(ispath(selected_model, /obj/item/robot_model/security))
		to_chat(src, span_warning("Only security cyborgs can use the Security module."))
		return

	if(is_iaa_cyborg_role())
		if(selected_model != /obj/item/robot_model && !ispath(selected_model, /obj/item/robot_model/affairs))
			to_chat(src, span_warning("Internal Affairs cyborgs are locked to the Internal Affairs module."))
			return
	else if(ispath(selected_model, /obj/item/robot_model/affairs))
		to_chat(src, span_warning("Only Internal Affairs cyborgs can use the Internal Affairs module."))
		return

	model.transform_to(selected_model)
