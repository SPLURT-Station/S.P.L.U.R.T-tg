/obj/item/food/monkeycube/dangerous_horse
	name = "a pony cube"
	desc = "This is a cube that, when water is added, creates a syndicate pony powerful enough to break the enemy's face!"
	bite_consumption = 10
	food_reagents = list(
		/datum/reagent/toxin = 15,
		/datum/reagent/medicine/strange_reagent = 1,
	)
	tastes = list("the loss of 5 TC" = 1, "eaten friend" = 1)
	spawned_mob = /mob/living/basic/pony/dangerous
