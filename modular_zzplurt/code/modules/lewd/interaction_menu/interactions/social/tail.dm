// Wholesome tail-based social interactions for players with tail
// These require REQUIRE_GENITAL_ANY flag and work with all tail types

/datum/interaction/tail_hug
	name = "Tail Hug"
	description = "Hug someone with your tail."
	user_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY)
	message = list("hugs %TARGET% with their tail.")
	category = "Miscellaneous"
	sound_use = TRUE
	sound_possible = list('sound/items/weapons/thudswoosh.ogg')

/datum/interaction/tail_pet
	name = "Tail Pet"
	description = "Pet someone with your tail."
	user_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY)
	message = list("pets %TARGET% with their tail.")
	category = "Miscellaneous"
	sound_use = TRUE
	sound_possible = list('sound/items/weapons/thudswoosh.ogg')

/datum/interaction/tail_weave
	name = "Tail Intertwine"
	description = "Intertwine your tail with theirs."
	message = list("intertwines their tail with %TARGET%'s tail.")
	category = "Miscellaneous"
	user_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY)
	target_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY)
	sound_use = TRUE
	sound_possible = list('sound/items/weapons/thudswoosh.ogg')

/datum/interaction/selfhugtail
	name = "Self-Tail Hug"
	description = "Hug your own tail for comfort."
	category = "Miscellaneous"
	message = list("hugs their own tail.")
	usage = INTERACTION_SELF
	user_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY)
	sound_use = TRUE
	sound_possible = list('sound/items/weapons/thudswoosh.ogg')
