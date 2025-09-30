/datum/language_holder/ashmob
	understood_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		// /datum/language/ashtongue = list(LANGUAGE_ATOM), // bubber got rid of ashtongue but will probably be reverted
	)
	spoken_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		// /datum/language/ashtongue = list(LANGUAGE_ATOM), // bubber got rid of ashtongue but will probably be reverted
	)
	// selected_language = /datum/language/ashtongue // bubber got rid of ashtongue but will probably be reverted

/mob/living/basic/chicken/gunther
	name = "\improper Gunther"
	desc = "An odd looking gutlunch, this one seems to have feathers and lay eggs, not like you'd complain about that."
	unsuitable_atmos_damage = 0
	initial_language_holder = /datum/language_holder/ashmob

/mob/living/basic/chicken/gunther/jr
	name = "\improper Gunther jr"
	fertile = FALSE

/mob/living/basic/chicken/gunther/egg_laid(obj/item/egg)
	if(GLOB.chicken_count <= MAX_CHICKENS && fertile && prob(10))
		egg.AddComponent(\
			/datum/component/fertile_egg,\
			embryo_type = /mob/living/basic/chick/gunther,\
			minimum_growth_rate = 1,\
			maximum_growth_rate = 2,\
			total_growth_required = 200,\
			current_growth = 0,\
			location_allowlist = typecacheof(list(/turf)),\
			spoilable = TRUE,\
		)

/mob/living/basic/chick/gunther
	name = "\improper Gunther chick"
	desc = "An odd looking baby gutlunch, this one seems to have feathers and lay eggs, not like you'd complain about that."
	unsuitable_atmos_damage = 0
	grow_as = /mob/living/basic/chicken/gunther/jr
	initial_language_holder = /datum/language_holder/ashmob
