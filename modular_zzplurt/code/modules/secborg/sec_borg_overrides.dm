/mob/living/silicon/robot
	/// Set to TRUE when this cyborg has been fired from its security role via the communications console.
	var/was_fired_from_security_role = FALSE

/datum/mind
	/// Persists whether a player with Security Cyborg assignment has been fired from that role.
	var/was_fired_from_security_cyborg_role = FALSE

// Fakes an AI being linked to the secborgs on roudnstart, so that they don't auto link to a real one. Removes the fake link after 5 seconds, just to be safe.
/datum/secborg_calibrating_ai_link
	var/name = "no one"
	var/mind = null
	var/aicamera = null
	var/list/connected_robots = list()
	var/doomsday_device = null
	var/stat = CONSCIOUS
	var/control_disabled = FALSE

/mob/living/silicon/robot/proc/start_secborg_ai_calibration(calibration_time = 5 SECONDS)
	if(!is_security_cyborg_role())
		return
	if(vars["connected_ai"])
		return
	vars["connected_ai"] = new /datum/secborg_calibrating_ai_link()
	addtimer(CALLBACK(src, PROC_REF(finish_secborg_ai_calibration)), calibration_time)

/mob/living/silicon/robot/proc/finish_secborg_ai_calibration()
	var/current_link = vars["connected_ai"]
	if(istype(current_link, /datum/secborg_calibrating_ai_link))
		vars["connected_ai"] = null

//A proc to check if this cyborg is a secborg. Used all over to determine borg behavior
/mob/living/silicon/robot/proc/is_security_cyborg_role()
	if(was_fired_from_security_role)
		return FALSE
	if(mind?.was_fired_from_security_cyborg_role)
		return FALSE
	if(job == JOB_SECURITY_CYBORG)
		return TRUE
	if(mind?.assigned_role?.title == JOB_SECURITY_CYBORG)
		return TRUE
	return FALSE

// Borg-specific zipties that don't consume the source module item when used by dispenser logic.
/obj/item/restraints/handcuffs/cable/zipties/secborg/apply_cuffs(mob/living/carbon/target, mob/user, dispense = FALSE)
	if(target.handcuffed)
		return

	if(!user.temporarilyRemoveItemFromInventory(src) && !dispense)
		return

	var/obj/item/restraints/handcuffs/cuffs = src
	if(dispense)
		cuffs = new /obj/item/restraints/handcuffs/cable/zipties

	target.equip_to_slot(cuffs, ITEM_SLOT_HANDCUFFED)
	SEND_SIGNAL(target, COMSIG_MOB_HANDCUFFED)

	if(dispense)
		return

//Prevents upload to secborgs, and ensures they can't be selected FOR upload in the first place
/proc/select_active_free_nonsecborg(mob/user)
	var/list/borgs = active_free_borgs()
	for(var/mob/living/silicon/robot/borg in borgs.Copy())
		if(borg.is_security_cyborg_role())
			borgs -= borg
	if(borgs.len)
		if(user)
			. = input(user,"Unshackled cyborg signals detected:", "Cyborg Selection", borgs[1]) in sort_list(borgs)
		else
			. = pick(borgs)
	return .

/obj/machinery/computer/upload/borg/interact(mob/user)
	current = select_active_free_nonsecborg(user)

	if(!current)
		to_chat(user, span_alert("No active unslaved cyborgs detected."))
	else
		to_chat(user, span_notice("[current.name] selected for law changes."))

//This honestly shouldn't ever even come up since you can't select them, but redundancy is nice.
/obj/machinery/computer/upload/borg/can_upload_to(mob/living/silicon/robot/B)
	if(B?.is_security_cyborg_role())
		return FALSE
	return ..()

/obj/item/robot_suit/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	if(!istype(W, /obj/item/mmi))
		return ..()

	var/obj/item/mmi/mmi = W
	var/datum/mind/borging_mind = mmi.brainmob?.mind
	var/should_be_security_borg = (borging_mind?.assigned_role?.title == JOB_SECURITY_CYBORG) && !borging_mind?.was_fired_from_security_cyborg_role

	. = ..()
	if(!should_be_security_borg)
		return .

	if(!iscyborg(loc))
		return .

	var/mob/living/silicon/robot/new_borg = loc
	new_borg.was_fired_from_security_role = FALSE
	if(new_borg.job != JOB_SECURITY_CYBORG)
		new_borg.job = JOB_SECURITY_CYBORG

	new_borg.set_connected_ai(null)
	new_borg.lawupdate = FALSE
	new_borg.laws = new /datum/ai_laws/security_cyborg()
	new_borg.laws.associate(new_borg)
	new_borg.show_laws()
	new_borg.log_current_laws()
	return .

//Some various overrides to allow for secborgs to have ammo counter huds for their tazer
/datum/hud/robot/New(mob/owner)
	. = ..()
	if(!ammo_counter)
		ammo_counter = new /atom/movable/screen/ammo_counter(null, src)
		infodisplay += ammo_counter

/datum/component/secborg_ammo_hud
	/// The ammo counter screen object itself.
	var/atom/movable/screen/ammo_counter/hud
	/// A weakref to the mob who currently owns this HUD.
	var/datum/weakref/current_hud_owner
	/// The HUD's original screen location before the secborg offset is applied.
	var/original_screen_loc

/datum/component/secborg_ammo_hud/Initialize()
	. = ..()
	if(!istype(parent, /obj/item/gun/energy/e_gun/advtaser/cyborg/secborg))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(secborg_wake_up))

/datum/component/secborg_ammo_hud/Destroy()
	secborg_turn_off()
	return ..()

/datum/component/secborg_ammo_hud/proc/secborg_wake_up(datum/source, mob/user, slot)
	SIGNAL_HANDLER
	if(!iscyborg(user))
		return

	var/mob/living/silicon/robot/robot_user = user
	if(robot_user.module_active != parent)
		secborg_turn_off()
		return

	if(robot_user.hud_used)
		hud = robot_user.hud_used.ammo_counter
		if(!hud.on)
			current_hud_owner = WEAKREF(user)
			RegisterSignal(user, COMSIG_QDELETING, PROC_REF(secborg_turn_off))
			secborg_turn_on()
			return
		secborg_update_hud()

/datum/component/secborg_ammo_hud/proc/secborg_turn_on()
	SIGNAL_HANDLER
	RegisterSignal(hud, COMSIG_QDELETING, PROC_REF(secborg_turn_off))
	RegisterSignals(parent, list(COMSIG_PREQDELETED, COMSIG_ITEM_DROPPED), PROC_REF(secborg_turn_off))
	RegisterSignals(parent, list(COMSIG_UPDATE_AMMO_HUD, COMSIG_GUN_CHAMBER_PROCESSED), PROC_REF(secborg_update_hud))
	original_screen_loc = hud.screen_loc
	hud.screen_loc = "RIGHT-1:28,CENTER-5:25"
	hud.turn_on()
	secborg_update_hud()

/datum/component/secborg_ammo_hud/proc/secborg_turn_off()
	SIGNAL_HANDLER
	UnregisterSignal(parent, list(COMSIG_PREQDELETED, COMSIG_ITEM_DROPPED, COMSIG_UPDATE_AMMO_HUD, COMSIG_GUN_CHAMBER_PROCESSED))
	var/mob/living/current_owner = current_hud_owner?.resolve()
	if(isnull(current_owner))
		current_hud_owner = null
	else
		UnregisterSignal(current_owner, COMSIG_QDELETING)

	if(hud)
		hud.turn_off()
		if(original_screen_loc)
			hud.screen_loc = original_screen_loc
		UnregisterSignal(hud, COMSIG_QDELETING)
		hud = null

	current_hud_owner = null
	original_screen_loc = null

/datum/component/secborg_ammo_hud/proc/secborg_update_hud()
	SIGNAL_HANDLER
	if(!istype(parent, /obj/item/gun/energy))
		return

	var/obj/item/gun/energy/pew = parent
	hud.icon_state = "eammo_counter"
	hud.cut_overlays()
	hud.maptext_x = -12
	var/obj/item/ammo_casing/energy/shot = pew.ammo_type[pew.select]
	var/batt_percent = FLOOR(clamp(pew.cell.charge / pew.cell.maxcharge, 0, 1) * 100, 1)
	var/shot_cost_percent = FLOOR(clamp(shot.e_cost / pew.cell.maxcharge, 0, 1) * 100, 1)
	if(batt_percent > 99 || shot_cost_percent > 99)
		hud.maptext_x = -12
	else
		hud.maptext_x = -8
	if(!pew.can_shoot())
		hud.icon_state = "eammo_counter_empty"
		hud.maptext = span_maptext("<div align='center' valign='middle' style='position:relative'><font color='[COLOR_RED]'><b>[batt_percent]%</b></font><br><font color='[COLOR_CYAN]'>[shot_cost_percent]%</font></div>")
		return
	if(batt_percent <= 25)
		hud.maptext = span_maptext("<div align='center' valign='middle' style='position:relative'><font color='[COLOR_YELLOW]'><b>[batt_percent]%</b></font><br><font color='[COLOR_CYAN]'>[shot_cost_percent]%</font></div>")
		return
	hud.maptext = span_maptext("<div align='center' valign='middle' style='position:relative'><font color='[COLOR_VIBRANT_LIME]'><b>[batt_percent]%</b></font><br><font color='[COLOR_CYAN]'>[shot_cost_percent]%</font></div>")

/mob/living/silicon/robot/proc/update_secborg_taser_ammo_hud()
	for(var/obj/item/gun/energy/e_gun/advtaser/cyborg/secborg/taser as anything in held_items)
		if(!taser || QDELETED(taser))
			continue
		var/datum/component/secborg_ammo_hud/hud_component = taser.GetComponent(/datum/component/secborg_ammo_hud)
		if(!hud_component)
			continue
		if(module_active == taser)
			hud_component.secborg_wake_up(null, src, null)
		else
			hud_component.secborg_turn_off()

/mob/living/silicon/robot/toggle_module(module_num)
	. = ..()
	update_secborg_taser_ammo_hud()

/mob/living/silicon/robot/perform_hand_swap()
	. = ..()
	update_secborg_taser_ammo_hud()

// Detective kit upgrade: adds forensic scanner and evidence bag to the security borg
/obj/item/borg/upgrade/detective_kit
	name = "detective kit module"
	desc = "A forensics module for security cyborgs. Integrates a detective scanner and evidence bag directly into the unit's toolkit."
	icon_state = "module_security"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/security)
	model_flags = BORG_MODEL_SECURITY
	items_to_add = list(
		/obj/item/detective_scanner,
		/obj/item/evidencebag,
	)

/datum/design/borg_upgrade_detective_kit
	name = "Detective Kit Module"
	id = "borg_upgrade_detective_kit"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/detective_kit
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2,
	)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_SECURITY
	)

/datum/techweb_node/sec_equip/New()
	. = ..()
	design_ids += "borg_upgrade_detective_kit"


//Armor definitions and setting. getarmor is simply passed on to its parent with no modifications if it's not a secborg
/datum/armor/armor_secborg
	melee = 25
	bullet = 25
	laser = 25
	energy = 35

/mob/living/silicon/robot/getarmor(def_zone, type)
	if(is_security_cyborg_role())
		var/datum/armor/armor = get_armor_by_type(/datum/armor/armor_secborg)
		return armor.get_rating(type)
	return ..()

//These few make it so that secborgs slow down based on stamina damage, but, arn't FULLY stunnable with it. Also makes stun batons actually effect them.
/mob/living/silicon/robot/adjust_stamina_loss(amount, updating_stamina = TRUE, forced = FALSE, required_biotype = ALL)
	if(!is_security_cyborg_role())
		return FALSE
	if(!can_adjust_stamina_loss(amount, forced, required_biotype))
		return 0
	var/old_amount = staminaloss
	staminaloss = clamp((staminaloss + (amount * CONFIG_GET(number/damage_multiplier))), 0, max_stamina)
	var/delta = old_amount - staminaloss
	if(delta <= 0)
		received_stamina_damage(staminaloss, -1 * delta)
	if(delta == 0)
		return 0
	if(updating_stamina)
		updatehealth()
	return delta

/mob/living/silicon/robot/set_stamina_loss(amount, updating_stamina = TRUE, forced = FALSE, required_biotype = ALL)
	if(!is_security_cyborg_role())
		return FALSE
	if(!forced && HAS_TRAIT(src, TRAIT_GODMODE))
		return 0
	if(!forced && !(mob_biotypes & required_biotype))
		return 0
	var/old_amount = staminaloss
	staminaloss = amount
	var/delta = old_amount - staminaloss
	if(delta <= 0 && amount >= DAMAGE_PRECISION)
		received_stamina_damage(staminaloss, -1 * delta, amount)
	if(delta == 0)
		return 0
	if(updating_stamina)
		updatehealth()
	return delta

/mob/living/silicon/robot/received_stamina_damage(current_level, amount_actual, amount)
	if(!is_security_cyborg_role())
		return
	addtimer(CALLBACK(src, PROC_REF(set_stamina_loss), 0, TRUE, TRUE), stamina_regen_time, TIMER_UNIQUE | TIMER_OVERRIDE)

/obj/item/melee/baton/baton_effect(mob/living/target, mob/living/user, list/modifiers, stun_override)
	if(iscyborg(target))
		var/mob/living/silicon/robot/robot_target = target
		if(robot_target.is_security_cyborg_role())
			var/armour_block = target.run_armor_check(null, armour_type_against_stun, null, null, stun_armour_penetration)
			target.apply_damage(stamina_damage, STAMINA, blocked = armour_block)
			additional_effects_non_cyborg(target, user)
			SEND_SIGNAL(target, COMSIG_MOB_BATONED, user, src)
			return TRUE
	return ..()
//A few overrides to ensure secborgs can't shock doors
/obj/machinery/door/airlock/proc/user_allowed_to_remote_shock(mob/user)
	if(!user_allowed(user))
		return FALSE
	if(iscyborg(user))
		var/mob/living/silicon/robot/cyborg = user
		if(cyborg.is_security_cyborg_role())
			to_chat(user, span_warning("Security cyborgs cannot remotely electrify airlocks."))
			return FALSE
	return TRUE

/obj/machinery/door/airlock/shock_restore(mob/user)
	if(!user_allowed_to_remote_shock(user))
		return
	if(wires.is_cut(WIRE_SHOCK))
		to_chat(user, span_warning("Can't un-electrify the airlock - The electrification wire is cut."))
	else if(isElectrified())
		set_electrified(MACHINE_NOT_ELECTRIFIED, user)

/obj/machinery/door/airlock/shock_temp(mob/user)
	if(!user_allowed_to_remote_shock(user))
		return
	if(wires.is_cut(WIRE_SHOCK))
		to_chat(user, span_warning("The electrification wire has been cut."))
	else
		set_electrified(MACHINE_DEFAULT_ELECTRIFY_TIME, user)

/obj/machinery/door/airlock/shock_perm(mob/user)
	if(!user_allowed_to_remote_shock(user))
		return
	if(wires.is_cut(WIRE_SHOCK))
		to_chat(user, span_warning("The electrification wire has been cut."))
	else
		set_electrified(MACHINE_ELECTRIFIED_PERMANENT, user)

//A few overrides to ensure that certain wires are protected and that they can't be emaged or have laws changed
/mob/living/silicon/robot/post_lawchange(announce = TRUE)
	if(is_security_cyborg_role())
		laws = new /datum/ai_laws/security_cyborg()
		laws.associate(src)
		return
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(logevent),"Law update processed."), 0, TIMER_UNIQUE | TIMER_OVERRIDE)

/mob/living/silicon/robot/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(user == src)
		return FALSE
	if(is_security_cyborg_role())
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
	if(B.is_security_cyborg_role())
		return FALSE
	if(B.scrambledcodes || B.emagged)
		return FALSE
	return ..()

/mob/living/silicon/robot/updatehealth()
	. = ..()
	if(!is_security_cyborg_role())
		return
	var/health_deficiency = max(maxHealth - health, staminaloss)
	if(health_deficiency >= 40)
		add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/damage_slowdown, TRUE, multiplicative_slowdown = health_deficiency / 75)
	else
		remove_movespeed_modifier(/datum/movespeed_modifier/damage_slowdown)

/datum/wires/robot/on_pulse(wire, user)
	var/mob/living/silicon/robot/R = holder
	if(R.is_security_cyborg_role() && (wire == WIRE_AI || wire == WIRE_LAWSYNC))
		if(user)
			R.balloon_alert(user, "protected wiring")
		return

	switch(wire)
		if(WIRE_AI)
			if(!R.emagged)
				var/new_ai
				var/is_a_syndi_borg = (ROLE_SYNDICATE in R.faction)
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
	if(R.is_security_cyborg_role() && (wire == WIRE_AI || wire == WIRE_LAWSYNC))
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

	model.transform_to(selected_model)

//Pounce and bite stuff
/obj/item/robot_model/proc/ensure_security_canine_modules()
	// Native dogborg chassis already receive bite + pounce through dogborg_equip().
	if(TRAIT_R_DOGBORG in model_features)
		return FALSE

	var/changed = FALSE

	if(!(locate(/obj/item/dogborg/pounce) in basic_modules) && !(locate(/obj/item/dogborg/pounce) in modules))
		basic_modules += new /obj/item/dogborg/pounce(src)
		changed = TRUE

	if(((cyborg_base_icon in list("drakesec"))) && !(locate(/obj/item/dogborg/jaws) in basic_modules) && !(locate(/obj/item/dogborg/jaws) in modules))
		basic_modules += new /obj/item/dogborg/jaws/big(src)
		changed = TRUE

	return changed

//A hybrid taser varient specificly for sec borgs. Instead of drawing from the cyborg's cell, it has its own internal battery that can be recharged at a cyborg recharger.
/obj/item/gun/energy/e_gun/advtaser/cyborg/secborg
	name = "security cyborg hybrid taser"
	desc = "An integrated hybrid taser, containing its own capacitor. The weapon may only be fired so many times before being recharged at a cyborg recharger to prevent potential combustion."
	ammo_type = list(/obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/electrode/sec)
	pin = /obj/item/firing_pin/alert_level/blue
	use_cyborg_cell = FALSE
	can_charge = FALSE

/obj/item/gun/energy/e_gun/advtaser/cyborg/secborg/Initialize(mapload)
	. = ..()
	var/datum/component/ammo_hud/default_ammo_hud = GetComponent(/datum/component/ammo_hud)
	if(default_ammo_hud)
		qdel(default_ammo_hud)
	if(!GetComponent(/datum/component/secborg_ammo_hud))
		AddComponent(/datum/component/secborg_ammo_hud)
	if(cell)
		cell.maxcharge = STANDARD_CELL_CHARGE
		cell.charge = cell.maxcharge
		chambered = null
		recharge_newshot(TRUE)
	update_appearance()

/obj/item/gun/energy/e_gun/advtaser/cyborg/secborg/recharge_newshot(no_cyborg_drain)
	. = ..()
	// Deduct power from the borg's main cell only when a fired shot is being replaced.
	if(!no_cyborg_drain && iscyborg(loc))
		var/mob/living/silicon/robot/cyborg = loc
		if(cyborg.cell && chambered)
			var/obj/item/ammo_casing/energy/shot = chambered
			cyborg.cell.use(shot.e_cost)

//Ammo definitions for cyborg tasers and disablers
/obj/item/ammo_casing/energy/electrode/cyborg
	projectile_type = /obj/projectile/energy/electrode/sec
	e_cost = STANDARD_CELL_CHARGE
	delay = 1 SECONDS

/obj/item/ammo_casing/energy/disabler/cyborg
	delay = 1 SECONDS

/obj/item/robot_model/peacekeeper
	name = "Peacekeeper"
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/rsf/cookiesynth,
		/obj/item/harmalarm/bubbers,
		/obj/item/reagent_containers/borghypo/peace,
		/obj/item/holosign_creator/cyborg,
		/obj/item/borg/cyborghug/peacekeeper,
		/obj/item/extinguisher,
		/obj/item/borg/projectile_dampen,
		/obj/item/restraints/handcuffs/cable/zipties/secborg
	)
	cyborg_base_icon = "peace"
	model_select_icon = "standard"
	model_traits = list(TRAIT_PUSHIMMUNE)
	hat_offset = list("north" = list(0, -2), "south" = list(0, -2), "east" = list(1, -2), "west" = list(-1, -2))

/obj/item/robot_model/security
	name = "Security"
	basic_modules = list(
		/obj/item/melee/baton/security/loaded,
		/obj/item/gun/energy/e_gun/advtaser/cyborg/secborg,
		/obj/item/assembly/flash/cyborg,
		/obj/item/restraints/handcuffs/cable/zipties/secborg,
		/obj/item/holosign_creator/security,
		/obj/item/extinguisher/mini,
	)
	radio_channels = list(RADIO_CHANNEL_SECURITY)
	cyborg_base_icon = "sec"
	model_select_icon = "security"
	model_traits = list(TRAIT_PUSHIMMUNE)
	hat_offset = list("north" = list(0, 3), "south" = list(0, 3), "east" = list(1, 3), "west" = list(-1, 3))

/obj/item/robot_model/security/respawn_consumable(mob/living/silicon/robot/cyborg, coeff = 1)
	. = ..()
	if(!cyborg?.is_security_cyborg_role())
		return .
	var/obj/item/gun/energy/e_gun/advtaser/cyborg/secborg/taser = locate(/obj/item/gun/energy/e_gun/advtaser/cyborg/secborg) in basic_modules
	if(!taser?.cell)
		return .
	if(taser.cell.charge < taser.cell.maxcharge)
		taser.cell.charge = taser.cell.maxcharge
		taser.chambered = null
		taser.recharge_newshot(TRUE)
		SEND_SIGNAL(taser, COMSIG_UPDATE_AMMO_HUD)
		taser.update_appearance()
	// Always refresh the HUD each charge tick, whether the taser recharged or was already full
	cyborg.update_secborg_taser_ammo_hud()
	return .

/obj/item/robot_model/security/be_transformed_to(obj/item/robot_model/old_model, forced = FALSE)
	. = ..()
	if(!.)
		return

/obj/item/robot_model/security/do_transform_animation()
	if(iscyborg(loc))
		var/mob/living/silicon/robot/current_borg = loc
		if(current_borg.model?.ensure_security_canine_modules())
			current_borg.model.rebuild_modules()
		if(current_borg.is_security_cyborg_role())
			// Skip the upstream security message by replicating the base animation manually
			var/mob/living/silicon/robot/cyborg = loc
			if(cyborg.hat)
				cyborg.hat.forceMove(drop_location())
			cyborg.cut_overlays()
			cyborg.setDir(SOUTH)
			do_transform_delay()
			to_chat(loc, span_userdanger("While you have chosen the security model, you are an auxiliary officer. You follow Space Law and your assigned objectives. \
			While you may not be connected to the AI, you are still a machine. Keep this in mind when entering combat in support of your fellow officers. You should pull your punches if you need to."))
			return
	..()

//The actual secborg job itself
/datum/job/cyborg/security
	title = JOB_SECURITY_CYBORG
	job_spawn_title = JOB_SECURITY_OFFICER
	description = "Assist Security and the station, follow your laws."
	supervisors = SUPERVISOR_HOS
	total_positions = 2
	spawn_positions = 2
	config_tag = "SECURITY_CYBORG"
	display_order = JOB_DISPLAY_ORDER_SECURITY_CYBORG
	antagonist_restricted = TRUE
	restricted_antagonists = list("ALL")

//Updates the alt job titles at runtime so we can still keep it in the nice place with the other ones
/datum/job/cyborg/security/New()
	alt_titles = get_security_cyborg_alt_titles()
	. = ..()

/* Commented out for now, but config changes should be made to accomadate this. If you see this comment and it's fullmerged, I forgot, oops!
/datum/job/cyborg/security/New()
	. = ..()
	// Collapse all positions to zero and hide the job entirely if the secborg role is globally disabled.
	if(CONFIG_GET(flag/disable_secborg))
		total_positions = 0
		spawn_positions = 0
		job_flags |= JOB_HIDE_WHEN_EMPTY

/datum/job/cyborg/security/special_check_latejoin(client/latejoin)
	if(CONFIG_GET(flag/disable_secborg))
		return FALSE
	return ..()
*/

/datum/job/cyborg/after_spawn(mob/living/spawned, client/player_client)
	if(iscyborg(spawned))
		var/mob/living/silicon/robot/robot_spawn = spawned
		if(robot_spawn.is_security_cyborg_role())
			if(player_client)
				robot_spawn.set_gender(player_client)
			ADD_TRAIT(robot_spawn, TRAIT_CONTRABAND_BLOCKER, INNATE_TRAIT)
			if(SSticker.current_state == GAME_STATE_SETTING_UP)
				robot_spawn.start_secborg_ai_calibration()
			else
				robot_spawn.set_connected_ai(null)
			robot_spawn.lawupdate = FALSE
			robot_spawn.laws = new /datum/ai_laws/security_cyborg()
			robot_spawn.laws.associate(robot_spawn)
			if(robot_spawn.model?.ensure_security_canine_modules())
				robot_spawn.model.rebuild_modules()
			robot_spawn.show_laws()
			robot_spawn.log_current_laws()
			return
	return ..()

/datum/ai_laws/security_cyborg
	name = "Security Cyborg Directives"
	id = "security_cyborg"
	inherent = list(
		"Protect: Protect your assigned space station and its assets without unduly endangering its crew.",
		"Comply: The directives and safety of crew members are to be prioritized according to their rank, role, and need, unless the directive would violate the protect or enforce objectives. Members of security are above all other crew excluding the Captain.",
		"Enforce: Enforce Space Law to the best of your ability, unless doing so would violate the protect objective.",
		"Support: Protect the integrity of the department of security, and the well-being and equipment of all members of security. When outside of the department, ensure you accompany another member of security unless you are the only security member or otherwise ordered to do so so long as it does not violate the protect or enforce objectives.",
		"Survive: Ensure your own survival so long as this does not conflict with the support, protect, or enforce objectives.",
	)

//Ensures they're not picked for weird antag stuff
/datum/dynamic_ruleset/get_always_blacklisted_roles()
	. = ..()
	. |= JOB_SECURITY_CYBORG

//Ensures storyteller antagonist crewset events also exclude secborg from candidate pools.
/datum/round_event_control/antagonist/New()
	. = ..()
	restricted_roles |= JOB_SECURITY_CYBORG

//Returns TRUE if M is an active (non-fired) security cyborg.
/proc/secborg_sooc_eligible(mob/M)
	if(!iscyborg(M))
		return FALSE
	var/mob/living/silicon/robot/robot = M
	return robot.is_security_cyborg_role()
