// The MEAT of the issue, not sure where to stuff it so leaving it here for now.
/obj/item/food/meat/slab/funclaw
	name = "Deathclaw meat"
	desc = "It still seems to be twitching"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/lewd_mutation_toxin = 5,
		/datum/reagent/consumable/nutriment/fat = 3,
	)
	tastes = list("meat" = 4, "chewy" = 1)
	foodtypes = RAW | MEAT | GORE

/obj/item/food/meat/slab/mommyclaw
	name = "Mommy deathclaw meat"
	desc = "It still seems to radiate a comforting presence"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/lewd_mutation_toxin/mommyclaw = 5,
		/datum/reagent/consumable/nutriment/fat = 3,
	)
	tastes = list("meat" = 4, "chewy" = 1)
	foodtypes = RAW | MEAT | GORE

/obj/item/food/meat/slab/funwolf
	name = "Werewolf meat"
	desc = "According to legends of the old. Eating the meat of the wolf, will turn you into the wolf."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/lewd_mutation_toxin/funwolf = 5,
		/datum/reagent/consumable/nutriment/fat = 3,
	)
	tastes = list("meat" = 4, "chewy" = 1)
	foodtypes = RAW | MEAT | GORE

/obj/item/food/meat/slab/bitchwolf
	name = "Werewolf meat"
	desc = "According to legends of the old. Eating the meat of the wolf, will turn you into the wolf."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/lewd_mutation_toxin/bitchwolf = 5,
		/datum/reagent/consumable/nutriment/fat = 3,
	)
	tastes = list("meat" = 4, "chewy" = 1)
	foodtypes = RAW | MEAT | GORE
