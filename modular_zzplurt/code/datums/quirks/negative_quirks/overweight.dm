// Re-implemented here to match old server
/datum/quirk/sluggish
	desc = "For whatever reason, you're just slower than everyone else. Maybe you just take life one day at a time."
	value = 0
	gain_text = span_notice("You're feeling a bit sluggish this shift!")
	lose_text = span_notice("You feel more energetic again.")
	mob_trait = TRAIT_SLOW

/datum/quirk/sluggish/add(client/client_source)
	// Set nutrition value
	quirk_holder.nutrition = rand(NUTRITION_LEVEL_FAT + NUTRITION_LEVEL_START_MIN, NUTRITION_LEVEL_FAT + NUTRITION_LEVEL_START_MAX)

	// Set overeat duration
	quirk_holder.overeatduration = 300 SECONDS

	// Add fat trait
	ADD_TRAIT(quirk_holder, TRAIT_FAT, OBESITY)

// Speed multiplier granted by this quirk
// Disabled because this is a neutral quirk
/datum/movespeed_modifier/sluggish
	multiplicative_slowdown = 0 // Previously 0.5
