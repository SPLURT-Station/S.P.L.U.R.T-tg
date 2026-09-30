/// Returns a serialized boolean only when it is exactly TRUE or FALSE.
/// Malformed values fall back to the field's existing default.
/proc/deserialize_vore_boolean(value, default_value)
	if(!isnum(value) || (value != FALSE && value != TRUE))
		return default_value
	return value

/// Returns a bounded serialized number without coercing non-numeric input.
/proc/deserialize_vore_number(value, min_value, max_value, default_value)
	if(!isnum(value))
		return default_value
	return clamp(value, min_value, max_value)

/// Serializes this belly to store in savefile data.
/obj/vore_belly/proc/serialize()
	return list(
		VORE_BELLY_KEY = VORE_BELLY_VERSION,
		"name" = name,
		"desc" = desc,
		"digest_mode" = digest_mode?.name,
		"can_taste" = can_taste,
		"insert_verb" = insert_verb,
		"release_verb" = release_verb,
		"brute_damage" = brute_damage,
		"burn_damage" = burn_damage,
		"muffles_radio" = muffles_radio,
		"escape_chance" = escape_chance,
		"escape_time" = escape_time,
		"overlay_path" = overlay_path,
		"overlay_color" = overlay_color,
		"is_wet" = is_wet,
		"wet_loop" = wet_loop,
		"fancy_sounds" = fancy_sounds,
		"insert_sound" = insert_sound,
		"release_sound" = release_sound,
		"digest_messages_pred" = digest_messages_pred,
		"digest_messages_prey" = digest_messages_prey,
		"absorb_messages_owner" = absorb_messages_owner,
		"absorb_messages_prey" = absorb_messages_prey,
		"unabsorb_messages_owner" = unabsorb_messages_owner,
		"unabsorb_messages_prey" = unabsorb_messages_prey,
		"drain_messages_owner" = drain_messages_owner,
		"drain_messages_prey" = drain_messages_prey,
		"heal_messages_owner" = heal_messages_owner,
		"heal_messages_prey" = heal_messages_prey,
		"struggle_messages_outside" = struggle_messages_outside,
		"struggle_messages_inside" = struggle_messages_inside,
		"absorbed_struggle_messages_outside" = absorbed_struggle_messages_outside,
		"absorbed_struggle_messages_inside" = absorbed_struggle_messages_inside,
		"escape_attempt_messages_owner" = escape_attempt_messages_owner,
		"escape_attempt_messages_prey" = escape_attempt_messages_prey,
		"escape_messages_owner" = escape_messages_owner,
		"escape_messages_prey" = escape_messages_prey,
		"escape_messages_outside" = escape_messages_outside,
		"escape_fail_messages_owner" = escape_fail_messages_owner,
		"escape_fail_messages_prey" = escape_fail_messages_prey,
	)

// Called when a savefile passed to us does not match our expected version
/obj/vore_belly/proc/apply_migrations(list/data)
	data[VORE_BELLY_KEY] = VORE_BELLY_VERSION

/// Deserializes this belly from savefile data
/obj/vore_belly/proc/deserialize(list/data)
	if(!islist(data))
		return FALSE
	if(!(VORE_BELLY_KEY in data)) // We've been passed invalid data, probably VRDB
		var/maybe_name = data["name"]
		if(istext(maybe_name) && length(maybe_name))
			deserialize_vrdb(data)
			return TRUE
		to_chat(usr, span_warning("Unable to load belly, missing '[VORE_BELLY_KEY]' signature and cannot detect VRDB"))
		return FALSE
	if(data[VORE_BELLY_KEY] != VORE_BELLY_VERSION)
		apply_migrations(data)
	if(data[VORE_BELLY_KEY] != VORE_BELLY_VERSION)
		return FALSE

	name = istext(data["name"]) ? (permissive_sanitize_name(data["name"]) || "(Bad Name)") : "(Bad Name)"
	desc = istext(data["desc"]) ? (STRIP_HTML_SIMPLE(data["desc"], MAX_FLAVOR_LEN) || "(Bad Desc)") : "(Bad Desc)"
	var/saved_digest_mode = istext(data["digest_mode"]) ? sanitize_text(data["digest_mode"]) : null
	digest_mode = GLOB.digest_modes[saved_digest_mode] || GLOB.digest_modes[DIGEST_MODE_SAFE]

	can_taste = deserialize_vore_boolean(data["can_taste"], TRUE)
	insert_verb = istext(data["insert_verb"]) ? (STRIP_HTML_SIMPLE(data["insert_verb"], MAX_VERB_LENGTH) || "ingest") : "ingest"
	release_verb = istext(data["release_verb"]) ? (STRIP_HTML_SIMPLE(data["release_verb"], MAX_VERB_LENGTH) || "expels") : "expels"

	brute_damage = deserialize_vore_number(data["brute_damage"], 0, MAX_BRUTE_DAMAGE, 0)
	burn_damage = deserialize_vore_number(data["burn_damage"], 0, MAX_BURN_DAMAGE, 1)

	muffles_radio = deserialize_vore_boolean(data["muffles_radio"], TRUE)
	escape_chance = deserialize_vore_number(data["escape_chance"], 0, 100, 100)
	escape_time = deserialize_vore_number(data["escape_time"], MIN_ESCAPE_TIME, MAX_ESCAPE_TIME, DEFAULT_ESCAPE_TIME)

	if(istext(data["overlay_path"]))
		var/maybe_overlay_path = text2path(data["overlay_path"])
		if(ispath(maybe_overlay_path, /atom/movable/screen/fullscreen/carrier/vore))
			overlay_path = maybe_overlay_path

	overlay_color = istext(data["overlay_color"]) ? sanitize_hexcolor(data["overlay_color"], default = "#ffffff") : "#ffffff"

	is_wet = deserialize_vore_boolean(data["is_wet"], TRUE)
	wet_loop = deserialize_vore_boolean(data["wet_loop"], TRUE)
	fancy_sounds = deserialize_vore_boolean(data["fancy_sounds"], TRUE)

	if(istext(data["insert_sound"]))
		var/new_insert_sound = trim(sanitize(data["insert_sound"]), MAX_MESSAGE_LEN)
		if(new_insert_sound)
			if(fancy_sounds && (new_insert_sound in GLOB.vore_sounds_insert_fancy))
				insert_sound = new_insert_sound
			if(!fancy_sounds && (new_insert_sound in GLOB.vore_sounds_insert_classic))
				insert_sound = new_insert_sound

	if(istext(data["release_sound"]))
		var/new_release_sound = trim(sanitize(data["release_sound"]), MAX_MESSAGE_LEN)
		if(new_release_sound)
			if(fancy_sounds && (new_release_sound in GLOB.vore_sounds_release_fancy))
				release_sound = new_release_sound
			if(!fancy_sounds && (new_release_sound in GLOB.vore_sounds_release_classic))
				release_sound = new_release_sound

	deserialize_messages(data)
	return TRUE

/// Special handler that tries to deserialize as much of a VRDB save as it can
/obj/vore_belly/proc/deserialize_vrdb(list/data)
	var/maybe_name = data["name"]
	to_chat(usr, span_warning("Attempting to load VRDB belly '[maybe_name]'..."))
	name = istext(maybe_name) ? (permissive_sanitize_name(maybe_name) || "(Bad Name)") : "(Bad Name)"
	desc = istext(data["desc"]) ? (STRIP_HTML_SIMPLE(data["desc"], MAX_FLAVOR_LEN) || "(Bad Desc)") : "(Bad Desc)"
	var/saved_digest_mode = istext(data["mode"]) ? sanitize_text(data["mode"]) : null
	digest_mode = GLOB.digest_modes[saved_digest_mode] || GLOB.digest_modes[DIGEST_MODE_SAFE]

	can_taste = deserialize_vore_boolean(data["can_taste"], TRUE)
	insert_verb = istext(data["vore_verb"]) ? (STRIP_HTML_SIMPLE(data["vore_verb"], MAX_VERB_LENGTH) || "ingest") : "ingest"
	release_verb = istext(data["release_verb"]) ? (STRIP_HTML_SIMPLE(data["release_verb"], MAX_VERB_LENGTH) || "expels") : "expels"

	escape_chance = deserialize_vore_number(data["escapechance"], 0, 100, 100)
	escape_time = deserialize_vore_number(data["escapetime"], MIN_ESCAPE_TIME, MAX_ESCAPE_TIME, DEFAULT_ESCAPE_TIME)

	is_wet = deserialize_vore_boolean(data["is_wet"], TRUE)
	wet_loop = deserialize_vore_boolean(data["wet_loop"], TRUE)
	fancy_sounds = deserialize_vore_boolean(data["fancy_vore"], TRUE)

	if(istext(data["vore_sound"]))
		var/new_insert_sound = trim(sanitize(data["vore_sound"]), MAX_MESSAGE_LEN)
		if(new_insert_sound)
			if(fancy_sounds && (new_insert_sound in GLOB.vore_sounds_insert_fancy))
				insert_sound = new_insert_sound
			if(!fancy_sounds && (new_insert_sound in GLOB.vore_sounds_insert_classic))
				insert_sound = new_insert_sound

	if(istext(data["release_sound"]))
		var/new_release_sound = trim(sanitize(data["release_sound"]), MAX_MESSAGE_LEN)
		if(new_release_sound)
			if(fancy_sounds && (new_release_sound in GLOB.vore_sounds_release_fancy))
				release_sound = new_release_sound
			if(!fancy_sounds && (new_release_sound in GLOB.vore_sounds_release_classic))
				release_sound = new_release_sound

	deserialize_messages(data)

/obj/vore_belly/proc/deserialize_messages(list/data)
	if(islist(data["digest_messages_pred"]))
		set_messages("digest_messages_pred", data["digest_messages_pred"])
	if(islist(data["digest_messages_owner"])) // VRDB
		set_messages("digest_messages_pred", data["digest_messages_owner"])
	if(islist(data["digest_messages_prey"]))
		set_messages("digest_messages_prey", data["digest_messages_prey"])
	if(islist(data["absorb_messages_owner"]))
		set_messages("absorb_messages_owner", data["absorb_messages_owner"])
	if(islist(data["absorb_messages_prey"]))
		set_messages("absorb_messages_prey", data["absorb_messages_prey"])
	if(islist(data["unabsorb_messages_owner"]))
		set_messages("unabsorb_messages_owner", data["unabsorb_messages_owner"])
	if(islist(data["unabsorb_messages_prey"]))
		set_messages("unabsorb_messages_prey", data["unabsorb_messages_prey"])
	if(islist(data["drain_messages_owner"]))
		set_messages("drain_messages_owner", data["drain_messages_owner"])
	if(islist(data["drain_messages_prey"]))
		set_messages("drain_messages_prey", data["drain_messages_prey"])
	if(islist(data["heal_messages_owner"]))
		set_messages("heal_messages_owner", data["heal_messages_owner"])
	if(islist(data["heal_messages_prey"]))
		set_messages("heal_messages_prey", data["heal_messages_prey"])
	if(islist(data["struggle_messages_outside"]))
		set_messages("struggle_messages_outside", data["struggle_messages_outside"])
	if(islist(data["struggle_messages_inside"]))
		set_messages("struggle_messages_inside", data["struggle_messages_inside"])
	if(islist(data["absorbed_struggle_messages_outside"]))
		set_messages("absorbed_struggle_messages_outside", data["absorbed_struggle_messages_outside"])
	if(islist(data["absorbed_struggle_messages_inside"]))
		set_messages("absorbed_struggle_messages_inside", data["absorbed_struggle_messages_inside"])
	if(islist(data["escape_attempt_messages_owner"]))
		set_messages("escape_attempt_messages_owner", data["escape_attempt_messages_owner"])
	if(islist(data["escape_attempt_messages_prey"]))
		set_messages("escape_attempt_messages_prey", data["escape_attempt_messages_prey"])
	if(islist(data["escape_messages_owner"]))
		set_messages("escape_messages_owner", data["escape_messages_owner"])
	if(islist(data["escape_messages_prey"]))
		set_messages("escape_messages_prey", data["escape_messages_prey"])
	if(islist(data["escape_messages_outside"]))
		set_messages("escape_messages_outside", data["escape_messages_outside"])
	if(islist(data["escape_fail_messages_owner"]))
		set_messages("escape_fail_messages_owner", data["escape_fail_messages_owner"])
	if(islist(data["escape_fail_messages_prey"]))
		set_messages("escape_fail_messages_prey", data["escape_fail_messages_prey"])
