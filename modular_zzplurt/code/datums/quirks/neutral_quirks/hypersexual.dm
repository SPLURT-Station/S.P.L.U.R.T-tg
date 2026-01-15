/// Interval of time between quirk holder gaining rouse effect
#define HYPERSX_ROUSE_TIME rand(HYPERSX_ROUSE_TIME_MIN, HYPERSX_ROUSE_TIME_MAX)
/// Minimum amount of time between intervals
#define HYPERSX_ROUSE_TIME_MIN 15 MINUTES
/// Maximum amount of time between intervals
#define HYPERSX_ROUSE_TIME_MAX 30 MINUTES
/// Minimum amount of arousal gained
#define HYPERSX_ROUSE_AMT_MIN 50
/// Maximum amount of arousal gained
#define HYPERSX_ROUSE_AMT_MAX 70

/// Messages used when gaining roused status
#define HYPERSX_ROUSE_MESSAGES pick(\
	"A wave of sensual desire washes over your body.",\
	"Desire claws at the edges of your mind.",\
	"Your thoughts narrow to a singular desire.",\
	"Lustful longing begins to overtake you again.",\
	)

// Special testing overrides
#ifdef TESTING
#undef HYPERSX_ROUSE_TIME_MIN
#undef HYPERSX_ROUSE_TIME_MAX
#define HYPERSX_ROUSE_TIME_MIN 1 MINUTES
#define HYPERSX_ROUSE_TIME_MAX 1 MINUTES
#endif

/**
 * Quirk for gaining arousal at random timed intervals.
 * * Uses a desire system similar to D4C.
 * * Requires climaxing to clear desire.
 * * Applies dynamic examine text during desire.
 */
/datum/quirk/hypersexual
	name = "Hypersexual"
	desc = "You experience uncontrollable bursts of sensual desire at random intervals."
	value = 0
	gain_text = span_purple("The sensual desires will call to you again soon...")
	lose_text = span_purple("You gain more control over your desires.")
	medical_record_text = "Patient was overly enthusiastic when asked if sexually active."
	mob_trait = TRAIT_HYPERSEXUAL
	icon = FA_ICON_THERMOMETER_3 // "In heat"
	erp_quirk = TRUE
	var/timer_rouse
	var/is_roused

/datum/quirk/hypersexual/add(client/client_source)
	// Set timer
	timer_rouse = addtimer(CALLBACK(src, PROC_REF(arouse)), HYPERSX_ROUSE_TIME, TIMER_STOPPABLE)

	// Register signal for performing climax
	RegisterSignal(quirk_holder, COMSIG_HUMAN_PERFORM_CLIMAX, PROC_REF(handle_climax))

	// Testing warning text
	#ifdef TESTING
	to_chat(quirk_holder, span_warning("You are currently using " + /datum/quirk/hypersexual::name + " in TESTING mode. Functionality may differ."))
	#endif

/datum/quirk/hypersexual/remove()
	// Remove mood event
	quirk_holder.clear_mood_event(QMOOD_HYPERSEXUAL)

	// Remove timer
	deltimer(timer_rouse)

	// Unregister signal for performing climax
	UnregisterSignal(quirk_holder, COMSIG_HUMAN_PERFORM_CLIMAX)

	// Remove examine text status effect
	quirk_holder.remove_status_effect(/datum/status_effect/quirk_examine/hypersexual)

/// Proc to handle performing a climax
/datum/quirk/hypersexual/proc/handle_climax()
	SIGNAL_HANDLER

	// Check if currently roused
	if(is_roused)
		// Remove roused
		unarouse()

/// Proc to apply roused status to holder
/datum/quirk/hypersexual/proc/arouse()
	// Check if not conscious
	if(quirk_holder.stat != CONSCIOUS)
		// Do nothing
		return

	// Define quirk mob
	var/mob/living/carbon/human/quirk_mob = quirk_holder

	// Check if arousal below threshold
	if(quirk_mob.arousal <= AROUSAL_HIGH)
		// Adjust by random level
		quirk_mob.adjust_arousal(rand(HYPERSX_ROUSE_AMT_MIN, HYPERSX_ROUSE_AMT_MAX))

	// Add examine text status effect
	quirk_holder.apply_status_effect(/datum/status_effect/quirk_examine/hypersexual)

	// Alert user in chat
	to_chat(quirk_holder, span_love(HYPERSX_ROUSE_MESSAGES))

	// Set roused variable
	is_roused = TRUE

	// Add negative mood effect
	quirk_holder.add_mood_event(QMOOD_HYPERSEXUAL, /datum/mood_event/hypersexual/rouse_need)

/// Proc to remove roused status from holder
/datum/quirk/hypersexual/proc/unarouse()
	// Unset roused variable
	is_roused = FALSE

	// Add positive mood event
	quirk_holder.add_mood_event(QMOOD_HYPERSEXUAL, /datum/mood_event/hypersexual/rouse_satisfied)

	// Remove timer
	deltimer(timer_rouse)
	timer_rouse = null

	// Remove examine text status effect
	quirk_holder.remove_status_effect(/datum/status_effect/quirk_examine/hypersexual)

	// Add new timer
	timer_rouse = addtimer(CALLBACK(src, PROC_REF(arouse)), HYPERSX_ROUSE_TIME, TIMER_STOPPABLE)

/// Base mood event for this quirk
/datum/mood_event/hypersexual/
	description = "I'm so overcome with desire that I broke the game."

/// Negative mood for experiencing desire
/datum/mood_event/hypersexual/rouse_need
	description = "Hedonistic desires claw at my mind."
	mood_change = -6

/// Positive mood for satisfying desire
/datum/mood_event/hypersexual/rouse_satisfied
	description = "I've found release from my sensual desires!"
	mood_change = 4
	timeout = 2 MINUTES

// Quirk examine text status effect
/datum/status_effect/quirk_examine/hypersexual
	id = QUIRK_EXAMINE_HYPERSEXUAL

// Set effect examine text
/datum/status_effect/quirk_examine/hypersexual/get_examine_text()
	return owner.get_arousal_text()

#undef HYPERSX_ROUSE_TIME
#undef HYPERSX_ROUSE_TIME_MIN
#undef HYPERSX_ROUSE_TIME_MAX
#undef HYPERSX_ROUSE_AMT_MIN
#undef HYPERSX_ROUSE_AMT_MAX
