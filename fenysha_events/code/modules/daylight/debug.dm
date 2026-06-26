ADMIN_VERB(set_daylight_time, R_ADMIN, "Set Daylight Time (0-1)", "Force daylight intensity or return to auto", ADMIN_CATEGORY_EVENTS)
	if(!check_rights(R_ADMIN))
		return

	var/value = input(usr, "Set forced intensity (0 = night, 1 = day, -1 = auto)", "Daylight Control", -1) as num|null
	if(isnull(value))
		return

	value = clamp(value, -1, 1)
	SSdaylight.manual_time = (value < 0 ? -1 : value)
	SSdaylight.time_locked = (value >= 0)
	SSdaylight.cycle_locked = (value >= 0)

	if(value >= 0)
		var/color = SSdaylight.get_manual_light_color(value)
		SSdaylight.set_intensity_and_color(value, color, FALSE)

	log_admin("[key_name(usr)] set daylight time to [value == -1 ? "AUTO" : value]")
	message_admins(span_adminnotice("[key_name_admin(usr)] set daytime: [value == -1 ? "auto" : value]"))

ADMIN_VERB(toggle_daylight_cycle_lock, R_ADMIN, "Toggle Daylight Cycle Lock", "Lock/unlock automatic day-night cycle", ADMIN_CATEGORY_EVENTS)
	if(!check_rights(R_ADMIN))
		return

	SSdaylight.cycle_locked = !SSdaylight.cycle_locked
	if(!SSdaylight.cycle_locked)
		SSdaylight.time_locked = FALSE
		SSdaylight.manual_time = -1

	log_admin("[key_name(usr)] [SSdaylight.cycle_locked ? "locked" : "unlocked"] daylight cycle")
	message_admins(span_adminnotice("[key_name_admin(usr)] [SSdaylight.cycle_locked ? "locked" : "unlocked"] daylight cycle"))

ADMIN_VERB(flash_daylight, R_ADMIN, "Flash Daylight", "Temporarily flash areas with a color", ADMIN_CATEGORY_EVENTS)
	if(!check_rights(R_ADMIN))
		return

	var/color = input(usr, "Choose flash color", "Flash Color") as color|null
	if(isnull(color))
		return

	var/duration = input(usr, "Set flash duration in seconds", "Flash Duration", 10) as num|null
	if(isnull(duration))
		return

	var/transition_time = input(usr, "Set transition time in seconds", "Transition Time", 2) as num|null
	if(isnull(transition_time))
		return

	SSdaylight.flash(color, duration SECONDS, transition_time SECONDS)

	log_admin("[key_name(usr)] triggered daylight flash with color [color] for [duration] seconds")
	message_admins(span_adminnotice("[key_name_admin(usr)] triggered daylight flash with color [color] for [duration] seconds"))

ADMIN_VERB(open_daylight_control_panel, R_ADMIN, "Open Daylight Control Panel", "Open UI panel for day/night and weather control", ADMIN_CATEGORY_EVENTS)
	if(!check_rights(R_ADMIN))
		return
	var/datum/daylight_control_panel/panel = new
	panel.ui_interact(usr)

// ================= Daylight debugging (temporary) =================
// "Status Report" - confirms the daylight SOURCE exists + is registered on your screen, and how many daylight
//   areas got their per-turf light overlays. If 0 areas are lit, run "Reapply Area Lighting". If the source isn't
//   on your screen, run "Re-register Source".

ADMIN_VERB(daylight_debug_report, R_ADMIN, "Daylight Debug: Status Report", "Print daylight diagnostics", ADMIN_CATEGORY_EVENTS)
	var/list/lines = list()
	lines += "Daylight areas registered: [length(SSdaylight.daylight_areas)]"
	var/lit = 0
	for(var/area/daylit_area as anything in SSdaylight.daylight_areas)
		if(daylit_area.daylight_lit)
			lit++
	lines += "Areas with light overlay painted: [lit]"
	var/obj/daylight_wash_source/source = SSdaylight.wash_source
	if(source)
		lines += "Daylight source: present (color [source.color], alpha [source.alpha], target [source.render_target])"
		lines += "Source on your screen: [(usr.canon_client && (source in usr.canon_client.screen)) ? "YES" : "NO"]"
	else
		lines += "Daylight source: MISSING"
	lines += "Anchor plane on your HUD: [usr.hud_used?.get_plane_master(RENDER_PLANE_DAYLIGHT) ? "YES" : "NO"]"
	to_chat(usr, span_boldnotice("== Daylight debug ==\n[lines.Join("\n")]"))

ADMIN_VERB(daylight_debug_reapply_lighting, R_ADMIN, "Daylight Debug: Reapply Area Lighting", "Re-add the daylight light overlay to all daylight areas", ADMIN_CATEGORY_EVENTS)
	var/count = 0
	for(var/area/daylit_area as anything in SSdaylight.daylight_areas)
		daylit_area.clear_daylight_overlay()
		daylit_area.apply_daylight_overlay()
		count++
	to_chat(usr, span_notice("Reapplied the daylight light overlay to [count] daylight area(s)."))

ADMIN_VERB(daylight_debug_reregister_source, R_ADMIN, "Daylight Debug: Re-register Source", "Re-add the daylight source to your screen", ADMIN_CATEGORY_EVENTS)
	if(!SSdaylight.wash_source)
		to_chat(usr, span_warning("No daylight source exists yet."))
		return
	usr.hud_used?.register_reuse(SSdaylight.wash_source)
	to_chat(usr, span_notice("Re-registered the daylight source onto your screen."))

/datum/daylight_control_panel/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/daylight_control_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DaylightControl", "Daylight Control")
		ui.open()

/datum/daylight_control_panel/ui_data(mob/user)
	var/list/data = list()
	data["cycle_locked"] = SSdaylight.cycle_locked
	data["time_locked"] = SSdaylight.time_locked
	data["manual_time"] = SSdaylight.manual_time
	data["daylight_cycle"] = SSdaylight.daylight_cycle
	data["current_intensity"] = SSdaylight.current_intensity
	data["current_color"] = SSdaylight.current_color
	data["current_phase"] = SSdaylight.current_phase ? SSdaylight.current_phase.name : "Unknown"
	data["active_weather_count"] = (SSdaylight.visual_weather_override == "none") ? 0 : 1
	data["visual_weather_mode"] = SSdaylight.visual_weather_override
	return data

/datum/daylight_control_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!check_rights_for(ui.user?.client, R_ADMIN))
		return

	switch(action)
		if("set_manual")
			var/value = text2num(params["value"])
			value = clamp(value, -1, 1)
			SSdaylight.manual_time = (value < 0 ? -1 : value)
			SSdaylight.time_locked = (value >= 0)
			SSdaylight.cycle_locked = (value >= 0)
			if(value >= 0)
				var/color = SSdaylight.get_manual_light_color(value)
				SSdaylight.set_intensity_and_color(value, color, FALSE)
			return TRUE

		if("set_cycle_minutes")
			var/new_cycle = clamp(round(text2num(params["value"]), 1), 5, 240)
			SSdaylight.daylight_cycle = new_cycle
			SSticker.station_time_rate_multiplier = 1440 / SSdaylight.daylight_cycle
			return TRUE

		if("toggle_cycle_lock")
			SSdaylight.cycle_locked = !SSdaylight.cycle_locked
			if(!SSdaylight.cycle_locked)
				SSdaylight.time_locked = FALSE
				SSdaylight.manual_time = -1
			return TRUE

		if("set_auto")
			SSdaylight.manual_time = -1
			SSdaylight.time_locked = FALSE
			SSdaylight.cycle_locked = FALSE
			return TRUE

		if("start_weather")
			var/selected = params["weather_type"]
			switch(selected)
				if("rain")
					SSdaylight.visual_weather_override = "rain"
				if("snow")
					SSdaylight.visual_weather_override = "snow"
				if("radiation")
					SSdaylight.visual_weather_override = "dust"
				if("mist")
					SSdaylight.visual_weather_override = "mist"
				if("auto")
					SSdaylight.visual_weather_override = "auto"
			log_admin("[key_name(ui.user)] switched visual weather to [SSdaylight.visual_weather_override] from daylight control panel")
			message_admins(span_adminnotice("[key_name_admin(ui.user)] switched visual weather to [SSdaylight.visual_weather_override] from daylight control panel"))
			return TRUE

		if("stop_weather")
			SSdaylight.visual_weather_override = "none"
			log_admin("[key_name(ui.user)] disabled visual weather from daylight control panel")
			message_admins(span_adminnotice("[key_name_admin(ui.user)] disabled visual weather from daylight control panel"))
			return TRUE

	return FALSE

/datum/preference/toggle/daylight_tint_fx
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "daylight_tint_fx"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/daylight_tint_fx/create_default_value()
	return TRUE

/datum/preference/toggle/daylight_particle_fx
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "daylight_particle_fx"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/daylight_particle_fx/create_default_value()
	return TRUE
