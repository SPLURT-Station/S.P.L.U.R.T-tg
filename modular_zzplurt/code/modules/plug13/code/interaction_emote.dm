// Plug13 Integration with Interaction Menu
// Sends haptic feedback to connected devices based on interaction parameters
// Uses organ_slot_to_plug13_emote from genital_emote.dm for organ slot mapping

/// Minimum strength for interaction emotes
#define PLUG13_INTERACTION_STRENGTH_MIN PLUG13_STRENGTH_LOW
/// Maximum strength for interaction emotes
#define PLUG13_INTERACTION_STRENGTH_MAX PLUG13_STRENGTH_MAX
/// Pleasure value that results in maximum strength
#define PLUG13_INTERACTION_STRENGTH_PLEASURE 50

/// Minimum duration for interaction emotes
#define PLUG13_INTERACTION_DURATION_MIN PLUG13_DURATION_SHORT
/// Maximum duration for interaction emotes
#define PLUG13_INTERACTION_DURATION_MAX PLUG13_DURATION_LONG
/// Pleasure value that results in maximum duration
#define PLUG13_INTERACTION_DURATION_PLEASURE 50

/// Pain multiplier for masochism emotes from interactions
#define PLUG13_INTERACTION_PAIN_MOD 0.5

#define PLUG13_INTERACTION_STRENGTH_RANGE (PLUG13_INTERACTION_STRENGTH_MAX - PLUG13_INTERACTION_STRENGTH_MIN)
#define PLUG13_INTERACTION_DURATION_RANGE (PLUG13_INTERACTION_DURATION_MAX - PLUG13_INTERACTION_DURATION_MIN)

/// Maps an interaction requirement to its corresponding Plug13 emote type
/// Returns null if the requirement doesn't map to any emote
/proc/interaction_requirement_to_plug13_emote(requirement)
	switch(requirement)
		if(INTERACTION_REQUIRE_SELF_MOUTH, INTERACTION_REQUIRE_TARGET_MOUTH)
			return PLUG13_EMOTE_FACE
		if(INTERACTION_REQUIRE_SELF_TOPLESS, INTERACTION_REQUIRE_TARGET_TOPLESS)
			return PLUG13_EMOTE_CHEST
		if(INTERACTION_REQUIRE_SELF_BOTTOMLESS, INTERACTION_REQUIRE_TARGET_BOTTOMLESS)
			return PLUG13_EMOTE_GROIN
	return null

/// Calculates Plug13 emote parameters based on pleasure/pain values
/// Returns list with "strength" and "duration" keys, or null if no emote should be sent
/proc/calculate_plug13_emote_params(pleasure, pain = 0)
	var/total_intensity = pleasure + (pain * PLUG13_INTERACTION_PAIN_MOD)
	if(total_intensity <= 0)
		return null

	// Calculate strength based on pleasure
	var/strength_modifier = min(total_intensity / PLUG13_INTERACTION_STRENGTH_PLEASURE, 1)
	var/strength = (PLUG13_INTERACTION_STRENGTH_RANGE * strength_modifier) + PLUG13_INTERACTION_STRENGTH_MIN

	// Calculate duration based on pleasure
	var/duration_modifier = min(total_intensity / PLUG13_INTERACTION_DURATION_PLEASURE, 1)
	var/duration = (PLUG13_INTERACTION_DURATION_RANGE * duration_modifier) + PLUG13_INTERACTION_DURATION_MIN

	return list(
		"strength" = clamp(strength, PLUG13_INTERACTION_STRENGTH_MIN, PLUG13_INTERACTION_STRENGTH_MAX),
		"duration" = clamp(duration, PLUG13_INTERACTION_DURATION_MIN, PLUG13_INTERACTION_DURATION_MAX)
	)

/// Sends Plug13 emotes to a mob based on their involved body parts
/// Uses organ_slot_to_plug13_emote from genital_emote.dm for mapping
/mob/living/proc/plug13_interaction_emote(list/involved_parts, list/involved_requirements, pleasure, pain = 0)
	if(!client?.plug13?.is_connected)
		return

	var/list/emote_params = calculate_plug13_emote_params(pleasure, pain)
	if(!emote_params)
		return

	var/strength = emote_params["strength"]
	var/duration = emote_params["duration"]

	// Track which emote types we've already sent to avoid duplicates
	var/list/sent_emotes = list()

	// Send emotes for each involved body part (uses shared proc from genital_emote.dm)
	for(var/part in involved_parts)
		var/emote_type = organ_slot_to_plug13_emote(part)
		if(emote_type && !(emote_type in sent_emotes))
			client.plug13.send_emote(emote_type, strength, duration)
			sent_emotes += emote_type

	// Send emotes for interaction requirements (mouth, topless, bottomless, etc.)
	for(var/requirement in involved_requirements)
		var/emote_type = interaction_requirement_to_plug13_emote(requirement)
		if(emote_type && !(emote_type in sent_emotes))
			client.plug13.send_emote(emote_type, strength, duration)
			sent_emotes += emote_type

	// If pain is significant and we haven't sent any other emotes, send masochism emote
	if(pain > 0 && !length(sent_emotes))
		var/pain_strength = clamp(pain * 2, PLUG13_STRENGTH_LOW, PLUG13_STRENGTH_MAX)
		client.plug13.send_emote(PLUG13_EMOTE_MASOCHISM, pain_strength, duration)

/// Gets the relevant interaction requirements for a position (user or target)
/proc/get_requirements_for_position(list/requirements, is_user)
	var/list/relevant = list()
	for(var/req in requirements)
		switch(req)
			// User requirements
			if(INTERACTION_REQUIRE_SELF_MOUTH)
				if(is_user)
					relevant += req
			if(INTERACTION_REQUIRE_SELF_TOPLESS)
				if(is_user)
					relevant += req
			if(INTERACTION_REQUIRE_SELF_BOTTOMLESS)
				if(is_user)
					relevant += req
			// Target requirements
			if(INTERACTION_REQUIRE_TARGET_MOUTH)
				if(!is_user)
					relevant += req
			if(INTERACTION_REQUIRE_TARGET_TOPLESS)
				if(!is_user)
					relevant += req
			if(INTERACTION_REQUIRE_TARGET_BOTTOMLESS)
				if(!is_user)
					relevant += req
	return relevant

/// Handles sending Plug13 emotes after an interaction is performed
/datum/interaction/proc/handle_plug13_emotes(mob/living/user, mob/living/target)
	if(!lewd)
		return

	// Get user's involved requirements
	var/list/user_requirements = get_requirements_for_position(interaction_requires, TRUE)

	// Get target's involved requirements
	var/list/target_requirements = get_requirements_for_position(interaction_requires, FALSE)

	// Send emotes to user
	if(user_pleasure > 0 || user_pain > 0)
		user.plug13_interaction_emote(
			user_required_parts,
			user_requirements,
			user_pleasure,
			user_pain
		)

	// Send emotes to target (if different from user)
	if(user != target && (target_pleasure > 0 || target_pain > 0))
		target.plug13_interaction_emote(
			target_required_parts,
			target_requirements,
			target_pleasure,
			target_pain
		)

// Hook into post_interaction to send Plug13 emotes
/datum/interaction/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	handle_plug13_emotes(user, target)

#undef PLUG13_INTERACTION_DURATION_RANGE
#undef PLUG13_INTERACTION_STRENGTH_RANGE
#undef PLUG13_INTERACTION_PAIN_MOD
#undef PLUG13_INTERACTION_DURATION_PLEASURE
#undef PLUG13_INTERACTION_DURATION_MAX
#undef PLUG13_INTERACTION_DURATION_MIN
#undef PLUG13_INTERACTION_STRENGTH_PLEASURE
#undef PLUG13_INTERACTION_STRENGTH_MAX
#undef PLUG13_INTERACTION_STRENGTH_MIN
