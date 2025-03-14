/mob/living
	var/pleasure = 0
	var/arousal = 0
	var/pain = 0
	var/satisfaction = 0

	var/pain_limit = 0
	var/arousal_status = AROUSAL_NONE

	var/last_climax = 0
	var/climax_cooldown = 0
	var/obj/item/organ/genital/last_climax_source = null

	var/refractory_period

	var/list/simulated_genitals = list(
		ORGAN_SLOT_PENIS = FALSE,
		ORGAN_SLOT_VAGINA = FALSE,
		ORGAN_SLOT_BREASTS = FALSE,
		ORGAN_SLOT_ANUS = TRUE,
		ORGAN_SLOT_BUTT = FALSE,
		ORGAN_SLOT_BELLY = FALSE
	)

	var/list/simulated_interaction_requirements = list(
		INTERACTION_REQUIRE_SELF_HAND = TRUE,
		INTERACTION_REQUIRE_SELF_MOUTH = TRUE,
		INTERACTION_REQUIRE_SELF_TOPLESS = TRUE,
		INTERACTION_REQUIRE_SELF_BOTTOMLESS = TRUE,
		INTERACTION_REQUIRE_SELF_FEET = 2,
	)

/mob/living/proc/set_pleasure(amount)
	pleasure = clamp(amount, 0, 100)
	update_pleasure_hud()

/// Returns true if the mob has an accessible penis for the parameter
/mob/living/proc/has_penis(required_state = REQUIRE_GENITAL_ANY)
	return simulated_genitals[ORGAN_SLOT_PENIS]

/// Returns true if the mob has an accessible vagina for the parameter
/mob/living/proc/has_vagina(required_state = REQUIRE_GENITAL_ANY)
	return simulated_genitals[ORGAN_SLOT_VAGINA]

/// Returns true if the mob has accessible breasts for the parameter
/mob/living/proc/has_breasts(required_state = REQUIRE_GENITAL_ANY)
	return simulated_genitals[ORGAN_SLOT_BREASTS]

/// Returns true if the mob has an accessible anus for the parameter
/mob/living/proc/has_anus(required_state = REQUIRE_GENITAL_ANY)
	return simulated_genitals[ORGAN_SLOT_ANUS]

/// These are stub procs that should be overridden by human
/mob/living/proc/is_topless()
	return simulated_interaction_requirements[INTERACTION_REQUIRE_SELF_TOPLESS]

/mob/living/proc/is_bottomless()
	return simulated_interaction_requirements[INTERACTION_REQUIRE_SELF_BOTTOMLESS]

/mob/living/proc/is_barefoot()
	return TRUE

/mob/living/proc/update_pleasure_hud()
	return // Stub proc that should be overridden by human

/mob/living/proc/set_arousal(amount)
	arousal = clamp(amount, AROUSAL_MINIMUM, AROUSAL_LIMIT)
	update_arousal_hud()

/mob/living/proc/update_arousal_hud()
	return // Stub proc that should be overridden by human

/mob/living/proc/update_pain_hud()
	return // Stub proc that should be overridden by human

/mob/living/proc/is_wearing_condom()
	return FALSE // Stub proc that should be overridden by human

// I'm unsure if mobs should get checked for these, but I'm adding them for now

/mob/living/proc/has_feet(required_state = REQUIRE_GENITAL_ANY)
	return simulated_interaction_requirements[INTERACTION_REQUIRE_SELF_FEET]

/mob/living/proc/has_balls(required_state = REQUIRE_GENITAL_ANY)
	return simulated_genitals[ORGAN_SLOT_PENIS]

/mob/living/proc/has_belly(required_state = REQUIRE_GENITAL_ANY)
	return simulated_genitals[ORGAN_SLOT_BELLY]

/mob/living/proc/get_num_feet()
	return simulated_interaction_requirements[INTERACTION_REQUIRE_SELF_FEET]
