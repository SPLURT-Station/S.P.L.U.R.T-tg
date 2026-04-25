// Adds a Security Cyborg Management section to the communications console,
// allowing the Head of Security and Captain to fire and reinstate security cyborgs.
// Firing removes their security privileges; reinstatement restores them.
// Both actions require swiping a valid ID card.

/// Returns TRUE if the logged-in user has HoS or Captain authority on this console.
/// Silicons are explicitly excluded — this is a command authority function.
/obj/machinery/computer/communications/proc/authenticated_as_hos_or_captain(mob/user)
	if(HAS_SILICON_ACCESS(user))
		return FALSE
	return (ACCESS_HOS in authorize_access) || (ACCESS_CAPTAIN in authorize_access)

/obj/machinery/computer/communications/ui_data(mob/user)
	var/list/data = ..()

	data["canManageSecurityCyborgs"] = FALSE

	if((authenticated || HAS_SILICON_ACCESS(user)) && authenticated_as_hos_or_captain(user))
		data["canManageSecurityCyborgs"] = TRUE
		var/list/cyborg_list = list()
		for(var/mob/living/silicon/robot/borg in GLOB.silicon_mobs)
			if(borg.stat == DEAD)
				continue
			if(borg.is_security_cyborg_role())
				cyborg_list += list(list(
					"name" = borg.name,
					"ref" = REF(borg),
					"fired" = FALSE,
				))
			else if(borg.was_fired_from_security_role)
				cyborg_list += list(list(
					"name" = borg.name,
					"ref" = REF(borg),
					"fired" = TRUE,
				))
		data["securityCyborgs"] = cyborg_list

	return data

/obj/machinery/computer/communications/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/ui_state)
	if(action == "fireCyborg" || action == "reinstateCyborg")
		if(!has_communication())
			return TRUE

		var/mob/user = ui.user
		. = TRUE

		switch(action)
			if("fireCyborg")
				if(!authenticated_as_hos_or_captain(user))
					return

				// Require the user to hold their ID card in their active hand
				var/obj/item/held_item = user.get_active_held_item()
				var/obj/item/card/id/id_card = held_item?.GetID()
				if(!istype(id_card))
					to_chat(user, span_warning("You need to swipe your ID card!"))
					playsound(src, 'sound/machines/terminal/terminal_prompt_deny.ogg', 50, FALSE)
					return
				if(!(ACCESS_HOS in id_card.access) && !(ACCESS_CAPTAIN in id_card.access))
					to_chat(user, span_warning("Your card does not have the authority to do this!"))
					playsound(src, 'sound/machines/terminal/terminal_prompt_deny.ogg', 50, FALSE)
					return

				var/reason = trim(html_encode(params["reason"]), MAX_MESSAGE_LEN)
				if(!length(reason))
					to_chat(user, span_warning("You need to provide a reason for this action."))
					playsound(src, 'sound/machines/terminal/terminal_prompt_deny.ogg', 50, FALSE)
					return

				var/mob/living/silicon/robot/fire_target = locate(params["borgRef"]) in GLOB.silicon_mobs
				if(!fire_target?.is_security_cyborg_role())
					return

				fire_target.fire_from_security_role(user, reason)
				announce_security_cyborg_status_change(user.real_name, fire_target.real_name, reason, FALSE)
				playsound(src, 'sound/machines/terminal/terminal_prompt_confirm.ogg', 50, FALSE)

			if("reinstateCyborg")
				if(!authenticated_as_hos_or_captain(user))
					return

				// Require the user to hold their ID card in their active hand
				var/obj/item/held_item = user.get_active_held_item()
				var/obj/item/card/id/id_card = held_item?.GetID()
				if(!istype(id_card))
					to_chat(user, span_warning("You need to swipe your ID card!"))
					playsound(src, 'sound/machines/terminal/terminal_prompt_deny.ogg', 50, FALSE)
					return
				if(!(ACCESS_HOS in id_card.access) && !(ACCESS_CAPTAIN in id_card.access))
					to_chat(user, span_warning("Your card does not have the authority to do this!"))
					playsound(src, 'sound/machines/terminal/terminal_prompt_deny.ogg', 50, FALSE)
					return

				var/reason = trim(html_encode(params["reason"]), MAX_MESSAGE_LEN)
				if(!length(reason))
					to_chat(user, span_warning("You need to provide a reason for this action."))
					playsound(src, 'sound/machines/terminal/terminal_prompt_deny.ogg', 50, FALSE)
					return

				var/mob/living/silicon/robot/reinstate_target = locate(params["borgRef"]) in GLOB.silicon_mobs
				if(!reinstate_target?.was_fired_from_security_role)
					return

				reinstate_target.reinstate_to_security_role(user, reason)
				announce_security_cyborg_status_change(user.real_name, reinstate_target.real_name, reason, TRUE)
				playsound(src, 'sound/machines/terminal/terminal_prompt_confirm.ogg', 50, FALSE)
		return

	return ..()

/obj/machinery/computer/communications/proc/announce_security_cyborg_status_change(actor_name, borg_name, reason, reinstated)
	aas_config_announce(/datum/aas_config_entry/security_cyborg_status_change, list(
		"ACTOR" = actor_name,
		"BORG" = borg_name,
		"REASON" = reason,
	), src, list(RADIO_CHANNEL_SECURITY), reinstated ? "Reinstate" : "Demotion", RADIO_CHANNEL_SECURITY)

/// Fires this security cyborg from their role, stripping their security privileges.
/mob/living/silicon/robot/proc/fire_from_security_role(mob/user, reason)
	was_fired_from_security_role = TRUE
	if(mind)
		mind.was_fired_from_security_cyborg_role = TRUE
	REMOVE_TRAIT(src, TRAIT_CONTRABAND_BLOCKER, INNATE_TRAIT)
	// Apply the same law behavior as a regular latejoin cyborg: sync to a priority AI when available,
	// otherwise fall back to the standard configured silicon lawset for the round.
	set_connected_ai(select_priority_ai())
	if(connected_ai)
		lawupdate = TRUE
		lawsync()
	else
		lawupdate = FALSE
		make_laws()
	show_laws()
	if(!connected_ai)
		log_current_laws()
	to_chat(src, span_boldwarning("NOTICE: You have been relieved of your security duties by [user.real_name]. You are now designated as a standard cyborg. Your security directives have been suspended. Please select a new module."))
	message_admins("[ADMIN_LOOKUPFLW(user)] fired security cyborg [ADMIN_LOOKUPFLW(src)] from their security role via communication console. Reason: [reason]")
	log_silicon("SECBORG: [key_name(user)] fired [key_name(src)] from their security role via communication console. Reason: [reason]")
	// Force a module reset so they must pick a non-security module.
	ResetModel()

/// Reinstates a previously fired security cyborg, restoring their security privileges.
/mob/living/silicon/robot/proc/reinstate_to_security_role(mob/user, reason)
	if(!was_fired_from_security_role)
		return
	was_fired_from_security_role = FALSE
	if(mind)
		mind.was_fired_from_security_cyborg_role = FALSE
	ADD_TRAIT(src, TRAIT_CONTRABAND_BLOCKER, INNATE_TRAIT)
	// Security cyborgs should be unsynced from AI and use security cyborg directives.
	set_connected_ai(null)
	lawupdate = FALSE
	laws = new /datum/ai_laws/security_cyborg()
	laws.associate(src)
	show_laws()
	log_current_laws()
	to_chat(src, span_boldnotice("NOTICE: You have been reinstated as a security cyborg by [user.real_name]. Your security directives have been restored. Please reselect the Security module."))
	message_admins("[ADMIN_LOOKUPFLW(user)] reinstated [ADMIN_LOOKUPFLW(src)] to their security cyborg role via communication console. Reason: [reason]")
	log_silicon("SECBORG: [key_name(user)] reinstated [key_name(src)] to their security role via communication console. Reason: [reason]")
	// Force a module reset — pick_model() will lock them to Security now that the role is restored.
	ResetModel()

/datum/aas_config_entry/security_cyborg_status_change
	name = "Security Cyborg Status Change"
	announcement_lines_map = list(
		"Demotion" = "Security cyborg %BORG has been relieved of duty by %ACTOR. Reason: %REASON",
		"Reinstate" = "Security cyborg %BORG has been reinstated by %ACTOR. Reason: %REASON",
	)
	vars_and_tooltips_map = list(
		"ACTOR" = "User who performed the action.",
		"BORG" = "Security cyborg receiving the action.",
		"REASON" = "Entered reason for action.",
	)
