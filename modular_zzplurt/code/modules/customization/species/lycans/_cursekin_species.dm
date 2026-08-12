
/datum/species/human/cursekin
	inherent_traits = list(
		TRAIT_LYCAN,
		TRAIT_MUTANT_COLORS,
		TRAIT_FAST_METABOLISM,
		TRAIT_VIRUSIMMUNE, // where wolf? wolves? where?
	)
	mutanteyes = /obj/item/organ/eyes/cursekin
	mutantears = /obj/item/organ/ears/cursekin

/datum/species/human/cursekin/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "robot",
			SPECIES_PERK_NAME = "Inorganic Rejection",
			SPECIES_PERK_DESC = "The curse afflicting the Cursekin prevents their bodies from being augmented with cybernetic organs \
			or implants."
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "bolt",
			SPECIES_PERK_NAME = "Silver Bane",
			SPECIES_PERK_DESC = "Cursekin are unusually vulnerable to anything made of silver. This vulnerability is much more severe while \
			transformed."
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "assistive-listening-systems",
			SPECIES_PERK_NAME = "Sensitive Hearing",
			SPECIES_PERK_DESC = "Cursekin are more sensitive to loud sounds, such as flashbangs.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "stomach",
			SPECIES_PERK_NAME = "Hunger of the Beast",
			SPECIES_PERK_DESC = "Cursekin have hunger onset them much more rapidly than other species.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "moon",
			SPECIES_PERK_NAME = "Lycan Form",
			SPECIES_PERK_DESC = "Cursekin can assume a larger, bestial Lycan form, possessing impressive strength, resilience, and sharp claws at the cost of \
			a slower movement speed, lack of finger dexterity, and increased vulnerability to heat and burns.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_SYRINGE,
			SPECIES_PERK_NAME = "Disease Immunity",
			SPECIES_PERK_DESC = "The Cursekin's condition grants them immunity to most illnesses.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "eye",
			SPECIES_PERK_NAME = "Keen Senses",
			SPECIES_PERK_DESC = "Cursekin's wolfish senses grant them better night vision.",
		),
	)
	return to_add


/obj/item/organ/ears/cursekin // how they look specifically is down to the player
	name = "cursekin ears"
	desc = "A pair of unusually long ears, with tufts of fur growing under them."
	damage_multiplier = 2

/obj/item/organ/eyes/cursekin
	name = "cursekin eyes"
	desc = "They bare an unusual similarity to the eyes of a wild wolf."
	flash_protect = FLASH_PROTECTION_SENSITIVE
	color_cutoffs = list(12, 7, 7) // ditto tajaran
