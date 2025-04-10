/datum/storyteller/medium
	name = "Medium Chaos"
	desc = "Medium Chaos is the default Storyteller, and the comparison point for every other Storyteller. \
	More frequent events than Low Chaos, but less frequent events than High Chaos. Best for an average, varied experience."
	welcome_text = "If I chopped you up in a meat grinder..."
	antag_divisor = 8

	tag_multipliers = list(
		TAG_LOW = 1,
		TAG_MEDIUM = 1,
		TAG_HIGH = 0
		)
	storyteller_type = STORYTELLER_TYPE_ALWAYS_AVAILABLE
