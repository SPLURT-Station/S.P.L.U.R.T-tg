
/datum/interaction/lewd/ears_rub
	name = "Stroke Ears"
	description = "Stroke their ears gently."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_HAND)
	message = list("strokes %TARGET%'s ears.")
	sound_use = TRUE
	sound_possible = list('sound/items/weapons/thudswoosh.ogg')

/datum/interaction/lewd/ears_lick
	name = "Ear Lick"
	description = "Lick their ear."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_MOUTH)
	message = list("licks %TARGET%'s ear.")
	sound_use = TRUE
	sound_possible = list('sound/items/weapons/thudswoosh.ogg')
