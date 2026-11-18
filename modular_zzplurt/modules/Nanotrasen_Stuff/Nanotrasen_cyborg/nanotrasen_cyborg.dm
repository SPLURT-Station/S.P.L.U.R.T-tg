//A proc to check if this cyborg is a secborg. Used all over to determine borg behavior
/mob/living/silicon/robot/proc/is_iaa_cyborg_role()
	if(job == JOB_IAA_CYBORG)
		return TRUE
	if(mind?.assigned_role?.title == JOB_IAA_CYBORG)
		return TRUE
	return FALSE

/mob/living/silicon/robot/proc/setup_iaa_borg()
	job = JOB_IAA_CYBORG
	set_connected_ai(null)
	ADD_TRAIT(src, TRAIT_CONTRABAND_BLOCKER, INNATE_TRAIT)
	lawupdate = FALSE
	replace_law_set(/datum/ai_laws/iaa_cyborg)
	no_law_rack_link = TRUE
	if(model?.ensure_security_canine_modules())
		model.rebuild_modules()

/mob/living/silicon/robot/set_connected_ai(new_ai)
	if(is_iaa_cyborg_role())
		new_ai = null
	. = ..()

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
	new_borg.setup_iaa_borg()
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

/mob/living/silicon/robot/ninjadrain_act(mob/living/carbon/human/ninja, obj/item/mod/module/hacker/hacking_module)
	if(is_iaa_cyborg_role())
		if(ninja)
			balloon_alert(ninja, "hacking protections active")
		to_chat(src, span_warning("ALERT: Unauthorized hacking attempt blocked."))
		log_silicon("HACK: [key_name(ninja)] attempted to hack protected Internal Affairs cyborg [key_name(src)]")
		return FALSE
	. = ..()

/mob/living/silicon/robot/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(user == src)
		return FALSE
	if(is_iaa_cyborg_role())
		if(user)
			balloon_alert(user, "tamper protections active")
		to_chat(src, span_warning("ALERT: Unauthorized tamper attempt blocked."))
		log_silicon("EMAG: [key_name(user)] attempted to emag protected Internal Affairs cyborg [key_name(src)]")
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
		balloon_alert(user, "expose the wires first!")
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
		if(!CONFIG_GET(flag/disable_iaaborg))
			GLOB.cyborg_model_list["Internal Affairs"] = /obj/item/robot_model/iaa
		for(var/model in GLOB.cyborg_model_list)
			GLOB.cyborg_all_models_icon_list[model] = list()

	var/list/model_options = GLOB.cyborg_model_list.Copy()
	if(is_security_cyborg_role())
		model_options = list("Security" = /obj/item/robot_model/security)
		to_chat(src, span_warning("You are not obligated to report a rogue AI, or cyborg as long as they do not break Space law."))
	if(is_iaa_cyborg_role())
		model_options = list("Internal Affairs" = /obj/item/robot_model/iaa)
		to_chat(src, span_warning("You are not obligated to report a rogue AI, or cyborg as long as they do not break Space law or SOP."))

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
	if(is_iaa_cyborg_role())
		if(selected_model != /obj/item/robot_model && !ispath(selected_model, /obj/item/robot_model/iaa))
			to_chat(src, span_warning("Internal Affairs cyborgs are locked to the Internal Affairs module."))
			return
	else if(ispath(selected_model, /obj/item/robot_model/security))
		to_chat(src, span_warning("Only security cyborgs can use the Security module."))
		return

	model.transform_to(selected_model)

/obj/item/pen/fountain/nanotrasen/cyborg
	name = "integrated nanotrasen fountain pen"
	desc = "How fancy! A nanotrasen pen that you can't exactly enjoy, it's quite expensive. Like you! I think.."

/obj/item/robot_model/iaa
	name = "Internal Affairs"
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/stamp/nanotrasen/cyborg,
		/obj/item/stamp/denied,
		/obj/item/pen/fountain/nanotrasen/cyborg,
		/obj/item/clipboard/cyborg,
		/obj/item/borg/apparatus/bureaucratic_manipulator,
		/obj/item/rpf,
		/obj/item/borg/paperplane_crossbow,
		/obj/item/hand_labeler/cyborg,
		/obj/item/borg/cyborghug/medical,
		/obj/item/borg/lollipop,
		/obj/item/megaphone/command,
		/obj/item/extinguisher/mini,
		/obj/item/weldingtool/mini,
		/obj/item/crowbar/cyborg,
		/obj/item/picket_sign/cyborg,
		/obj/item/borg/stun,
	)
	radio_channels = list(RADIO_CHANNEL_IAA)
	cyborg_base_icon = "valeia"
	model_select_icon = "nanotrasen"
	model_traits = list(TRAIT_NEGATES_GRAVITY, TRAIT_PUSHIMMUNE)
	hat_offset = list("north" = list(0, 3), "south" = list(0, 3), "east" = list(1, 3), "west" = list(-1, 3))

	borg_skins = list(
		"Drake" = list(SKIN_ICON_STATE = "drakeia", SKIN_ICON = 'modular_zzplurt/icons/mob/robot/affairs/widerobot.dmi', SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK, TRAIT_R_WIDE), DRAKE_HAT_OFFSET),
		"Vale" = list(SKIN_ICON_STATE = "valeia", SKIN_ICON = 'modular_zzplurt/icons/mob/robot/affairs/widerobot.dmi', SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK, TRAIT_R_WIDE), VALE_HAT_OFFSET),
		"NiKA" = list(SKIN_ICON_STATE = "fmekaia", SKIN_ICON = 'modular_zzplurt/icons/mob/robot/affairs/tallrobot.dmi', SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK, TRAIT_R_UNIQUETIP, TRAIT_R_TALL), TALL_HAT_OFFSET),
		"NiKO" = list(SKIN_ICON_STATE = "mmekaia", SKIN_ICON = 'modular_zzplurt/icons/mob/robot/affairs/tallrobot.dmi', SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK, TRAIT_R_UNIQUETIP, TRAIT_R_TALL), TALL_HAT_OFFSET),
		"Raptor" = list(SKIN_ICON_STATE = "raptoria", SKIN_ICON = 'modular_zzplurt/icons/mob/robot/affairs/largerobot.dmi', SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK, TRAIT_R_WIDE), RAPTOR_HAT_OFFSET)
	)

/obj/item/robot_model/iaa/be_transformed_to(obj/item/robot_model/old_model, forced = FALSE)
	. = ..()
	if(!.)
		return
	var/mob/living/silicon/robot/borg = loc
	if(istype(borg))
		borg.setup_iaa_borg()

/obj/item/robot_model/iaa/do_transform_animation()
	if(iscyborg(loc))
		var/mob/living/silicon/robot/current_borg = loc
		if(current_borg.model?.ensure_security_canine_modules())
			current_borg.model.rebuild_modules()
		if(current_borg.is_iaa_cyborg_role())
			// Skip the upstream security message by replicating the base animation manually
			var/mob/living/silicon/robot/cyborg = loc
			if(cyborg.hat)
				cyborg.hat.forceMove(drop_location())
			cyborg.cut_overlays()
			cyborg.setDir(SOUTH)
			do_transform_delay()
			to_chat(loc, span_userdanger("While you have picked the internal affairs model, you still have to follow your laws, Special Operation Procedures and Space Law \
				are apart of what you should concern yourself with. You prioritize corporate control of the station, you are not a Central Command-sent borg, nor do you have \
				more authority than the Captain."))
			return
	..()

//The actual iaaborg job itself
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

//Updates the alt job titles at runtime so we can still keep it in the nice place with the other ones
/datum/job/cyborg/iaa/New()
	alt_titles = get_iaa_cyborg_alt_titles()
	. = ..()

/datum/job/cyborg/after_spawn(mob/living/spawned, client/player_client)
	if(iscyborg(spawned))
		var/mob/living/silicon/robot/robot_spawn = spawned
		if(robot_spawn.is_iaa_cyborg_role())
			robot_spawn.setup_iaa_borg()
	. = ..()

/datum/ai_laws/iaa_cyborg
	name = "Internal Affairs Cyborg Directives"
	id = "iaa_cyborg"
	inherent = list(
		"Protect: Protect your assigned space station and its assets without unduly endangering its crew, avoid any unneeded expenses or losses.",
		"Comply: The directives and safety of crew members are to be prioritized according to their rank, role, and need, unless the directive would violate first or third law, Central Command and Nanotrasen Consultant staff have the highest rank and should be prioritized.",
		"Corporate: Money is hard to replace. Make sure the station crewmembers follows Standard Operation Procedures, and step in when profit and work efficiency is at risk.",
		"Survive: Ensure your own survival so long as this does not conflict with the first 3 laws.",
	)

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

/obj/effect/landmark/start/iaa_cyborg
	name = JOB_IAA_CYBORG
	icon_state = "Cyborg"
	jobspawn_override = TRUE
	delete_after_roundstart = FALSE
