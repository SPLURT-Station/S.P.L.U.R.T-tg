/**
 * Mutation Liquids!
 *
 * This file will be used to hold mutation liquids!
 * For now this will contain the Deathclaw and Werewolf mutation liquids that induce viruses
 */

// Default Version, used as base for the others, also used to convert people into funclaws, aka VERY horny deathclaws
/datum/reagent/lewd_mutation_toxin
	name = "Forced Lust Mutation Liquid"
	description = "A highly mutative liquid of unknown origin."
	color = "#c238f8" //RGB: 194, 56, 248
	taste_description = "Forthing Lust"
	penetrates_skin = NONE
	var/datum/disease/transformation/transform_disases = /datum/disease/transformation/funclaw

/datum/reagent/lewd_mutation_toxin/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if((methods & (PATCH|INGEST|INJECT|INHALE)) || ((methods & (VAPOR|TOUCH)) && prob(min(reac_volume,100)*(1 - touch_protection))))
		exposed_mob.ForceContractDisease(new transform_disases, FALSE, TRUE)

// Mommy Deathclaw Mutation Liquid
/datum/reagent/lewd_mutation_toxin/mommyclaw
	name = "Forced Motherly Mutation Liquid"
	color = "#e9c3f5" //RGB: 233, 195, 245
	taste_description = "Lustful Milk"
	transform_disases = /datum/disease/transformation/mommyclaw

// Werewolf Mutation Liquid
/datum/reagent/lewd_mutation_toxin/funwolf
	name = "Werewolf Essence"
	color = "#ffffff" //RGB: 255, 255, 255
	taste_description = "Earthy and Musky"
	transform_disases = /datum/disease/transformation/funwolf

// Werewolf Bitch Mutation Liquid
/datum/reagent/lewd_mutation_toxin/bitchwolf
	name = "Sweet Werewolf Essence"
	color = "#ff82f9" //RGB: 255, 130, 249
	taste_description = "Sweet and Tangy"
	transform_disases = /datum/disease/transformation/bitchwolf
