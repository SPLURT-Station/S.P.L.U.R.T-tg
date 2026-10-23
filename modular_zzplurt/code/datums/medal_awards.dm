/datum/preferences
	/// List of medal commendation entries this player has received across rounds
	var/list/medal_awards_received = list()
	/// List of medal commendation entries this player has awarded to others across rounds
	var/list/medal_awards_given = list()

/datum/award/score/medal
	category = "Medals"
	icon = 'icons/obj/clothing/accessories.dmi'
	icon_state = "bronze"

/datum/award/score/medal/get_ui_data(list/award_data, datum/achievement_data/holder)
	. = ..()
	var/client/owner_client = GLOB.directory[holder.owner_ckey]
	var/datum/preferences/prefs = owner_client?.prefs
	if(!prefs)
		return .

	var/list/source_list = (type == /datum/award/score/medal/medals_given) ? prefs.medal_awards_given : prefs.medal_awards_received
	if(!islist(source_list) || !length(source_list))
		return .

	var/list/matching_lines = list()
	var/list/last_entry
	for(var/list/entry in source_list)
		if(!islist(entry))
			continue
		if(type != /datum/award/score/medal/medals_received && type != /datum/award/score/medal/medals_given)
			if(entry["award_type"] != "[type]")
				continue
		last_entry = entry
		var/medal_name = entry["medal"] || name
		var/commender = entry["awarder"] || "Unknown"
		var/commendee = entry["awarded_to"] || "Unknown"
		var/reason = entry["reason"] || "No reason recorded."
		matching_lines += "[medal_name] ([commender] -> [commendee]): \"[reason]\""

	var/match_count = length(matching_lines)
	if(!match_count)
		return .

	if(award_data["value"] < match_count)
		award_data["value"] = match_count

	if(type == /datum/award/score/medal/medals_given)
		.["achieve_info"] = "Last awarded to [last_entry["awarded_to"] || "Unknown"] ([last_entry["medal"] || "medal"])"
	else
		.["achieve_info"] = "Last awarded by [last_entry["awarder"] || "Unknown"] to [last_entry["awarded_to"] || "Unknown"]"

	var/start_idx = max(1, match_count - 4)
	var/list/recent_lines = matching_lines.Copy(start_idx)
	.["achieve_tooltip"] = recent_lines.Join("\n")
	return .

/datum/award/score/medal/medals_received
	name = "Medals Received"
	desc = "The total number of commendation medals you have been awarded."
	database_id = "Medals Received"
	icon_state = "gold"

/datum/award/score/medal/medals_given
	name = "Medals Awarded"
	desc = "The total number of commendation medals you have awarded to other crewmembers."
	database_id = "Medals Awarded"
	icon_state = "medal_paperwork"

/datum/award/score/medal/bronze
	name = "Bronze Medals"
	desc = "Awarded for distinguished conduct and service."
	database_id = "Bronze Medals"
	icon_state = "bronze"

/datum/award/score/medal/bronze_heart
	name = "Bronze Heart Medals"
	desc = "Awarded for sacrifice or severe injury in the line of duty."
	database_id = "Bronze Heart Medals"
	icon_state = "bronze_heart"

/datum/award/score/medal/silver
	name = "Silver Medals"
	desc = "Awarded for outstanding achievement and excellence."
	database_id = "Silver Medals"
	icon_state = "silver"

/datum/award/score/medal/valor
	name = "Medals of Valor"
	desc = "Awarded for acts of exceptional valor."
	database_id = "Medals of Valor"
	icon_state = "silver"

/datum/award/score/medal/gold
	name = "Gold Medals"
	desc = "Awarded for the highest levels of heroism and leadership."
	database_id = "Gold Medals"
	icon_state = "gold"

/datum/award/score/medal/plasma
	name = "Plasma Medals"
	desc = "Awarded for significant contributions to science or engineering."
	database_id = "Plasma Medals"
	icon_state = "plasma"

/datum/award/score/medal/medical
	name = "Medical Medals"
	desc = "Awarded for distinguished performance and competence within the medical department."
	database_id = "Medical Medals"
	icon_state = "med_medal2"

/datum/award/score/medal/ribbon
	name = "Service Ribbons"
	desc = "Awarded for devotion to duty."
	database_id = "Service Ribbons"
	icon_state = "cargo"

/// Returns the achievement score type corresponding to this medal
/obj/item/clothing/accessory/medal/proc/get_medal_award_type()
	if(istype(src, /obj/item/clothing/accessory/medal/plasma))
		return /datum/award/score/medal/plasma
	if(istype(src, /obj/item/clothing/accessory/medal/gold))
		return /datum/award/score/medal/gold
	if(istype(src, /obj/item/clothing/accessory/medal/silver/valor))
		return /datum/award/score/medal/valor
	if(istype(src, /obj/item/clothing/accessory/medal/silver))
		return /datum/award/score/medal/silver
	if(istype(src, /obj/item/clothing/accessory/medal/bronze_heart))
		return /datum/award/score/medal/bronze_heart
	if(istype(src, /obj/item/clothing/accessory/medal/med_medal) || istype(src, /obj/item/clothing/accessory/medal/med_medal2))
		return /datum/award/score/medal/medical
	if(istype(src, /obj/item/clothing/accessory/medal/ribbon))
		return /datum/award/score/medal/ribbon
	return /datum/award/score/medal/bronze

/// Records medal scores and persistent commendation history for both the recipient and the awarder
/obj/item/clothing/accessory/medal/proc/record_medal_commendation(mob/living/attacher, mob/living/distinguished)
	var/award_type = get_medal_award_type()
	var/list/commendation_entry = list(
		"medal" = name,
		"award_type" = "[award_type]",
		"awarder" = awarder,
		"awarded_to" = awarded_to,
		"reason" = commendation_message,
		"round_id" = GLOB.round_id,
		"date" = time2text(world.realtime, "YYYY-MM-DD hh:mm"),
	)

	var/client/recipient_client = distinguished?.client
	if(recipient_client)
		if(recipient_client.prefs)
			LAZYINITLIST(recipient_client.prefs.medal_awards_received)
			recipient_client.prefs.medal_awards_received += list(commendation_entry)
			recipient_client.prefs.save_preferences()
		recipient_client.give_award(/datum/award/score/medal/medals_received, distinguished)
		recipient_client.give_award(award_type, distinguished)

	var/client/attacher_client = attacher?.client
	if(attacher_client)
		if(attacher_client.prefs)
			LAZYINITLIST(attacher_client.prefs.medal_awards_given)
			attacher_client.prefs.medal_awards_given += list(commendation_entry)
			attacher_client.prefs.save_preferences()
		attacher_client.give_award(/datum/award/score/medal/medals_given, attacher)

/// Formats a list of medal commendation entries into HTML
/client/proc/format_medal_history_section(title, list/entries)
	var/list/section = list()
	var/count = islist(entries) ? length(entries) : 0
	section += "<h3>[title] ([count])</h3>"
	if(!count)
		section += "<p><i>None recorded yet.</i></p>"
		return section.Join("")

	section += "<ul>"
	for(var/idx = count to 1 step -1)
		var/list/entry = entries[idx]
		if(!islist(entry))
			continue
		var/medal_name = html_encode("[entry["medal"] || "medal"]")
		var/commender = html_encode("[entry["awarder"] || "Unknown"]")
		var/commendee = html_encode("[entry["awarded_to"] || "Unknown"]")
		var/reason = html_encode("[entry["reason"] || "No reason recorded."]")
		var/date_text = entry["date"] ? html_encode("[entry["date"]]") : ""
		var/round_text = entry["round_id"] ? "Round #[html_encode("[entry["round_id"]]")]" : ""
		var/meta_info = ""
		if(round_text && date_text)
			meta_info = " <small>([round_text] - [date_text])</small>"
		else if(round_text || date_text)
			meta_info = " <small>([round_text][date_text])</small>"

		section += "<li><b>[capitalize(medal_name)]</b>[meta_info]<br>"
		section += "Awarded to <b>[commendee]</b> by <b>[commender]</b><br>"
		section += "<i>\"[reason]\"</i></li><br>"
	section += "</ul>"
	return section.Join("")

GAME_VERB_DESC(/client, view_medal_history, "View Medal History", "View the medals and commendations you have received and given.", "OOC")
	if(!prefs)
		return
	var/list/dat = list()
	dat += "<h2>Medal & Commendation History</h2>"
	dat += format_medal_history_section("Medals Received", prefs.medal_awards_received)
	dat += "<hr>"
	dat += format_medal_history_section("Medals Awarded to Others", prefs.medal_awards_given)

	var/datum/browser/popup = new(usr, "medal_history", "Medal & Commendation History", 600, 500)
	popup.set_content(dat.Join(""))
	popup.open()
