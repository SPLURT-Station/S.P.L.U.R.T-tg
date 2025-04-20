// Peanuts!
/obj/item/seeds/peanut/Initialize(mapload, nogenes)
	. = ..()
	mutatelist ||= list()
	mutatelist += /obj/item/seeds/peanut/packing

/obj/item/seeds/peanut/packing
	name = "package peanut seed pack"
	desc = "These seeds grow into package peanut plants."
	icon = 'modular_zzplurt/icons/obj/service/hydroponics/seeds.dmi'
	icon_state = "seed-peanut"
	species = "package peanut"
	plantname = "Package Peanut Plant"
	product = /obj/item/food/grown/peanut/packing
	lifespan = 55
	endurance = 35
	yield = 6
	growing_icon = 'icons/obj/service/hydroponics/growing.dmi'
	icon_grow = "peanut-grow"
	icon_dead = "peanut-dead"
	genes = list(/datum/plant_gene/trait/one_bite)
	// very bad nutritional profile
	reagents_add = list(/datum/reagent/consumable/corn_starch = 0.1, /datum/reagent/consumable/nutriment/fat/oil/corn = 0.05)

/obj/item/food/grown/peanut/packing
	seed = /obj/item/seeds/peanut/packing
	name = "package peanut"
	desc = "A boring mutated crop that doesn't pack much flavor. Though, when processed, they make shipping safer."
	icon = 'modular_zzplurt/icons/obj/service/hydroponics/harvest.dmi'
	icon_state = "package_peanut"
	foodtypes = GRAIN | NUTS | CLOTH
	grind_results = list(/datum/reagent/consumable/peanut_butter/packing = 0)
	tastes = list("starchy peanuts" = 1)
	var/packing_type = /obj/item/stack/packing_peanuts
	var/packing_name = "packing peanuts"

// Copypasta from cotton, bite me
/obj/item/food/grown/peanut/packing/attack_self(mob/user)
	var/packing_count = 1
	if(seed)
		packing_count += round(seed.potency / 25)

	user.balloon_alert(user, "pulled [packing_count] piece\s")
	new packing_type(user.drop_location(), packing_count)
	qdel(src)

// Override to make it so cargo techs love package peanuts
/obj/item/food/grown/peanut/packing/proc/make_edible()
	AddComponentFrom(
		SOURCE_EDIBLE_INNATE,\
		/datum/component/edible,\
		initial_reagents = food_reagents,\
		food_flags = food_flags,\
		foodtypes = foodtypes,\
		volume = max_volume,\
		eat_time = eat_time,\
		tastes = tastes,\
		eatverbs = eatverbs,\
		bite_consumption = bite_consumption,\
		junkiness = junkiness,\
		reagent_purity = starting_reagent_purity,\
		check_liked = CALLBACK(src, PROC_REF(check_liked)),\
	)

/// Override for checkliked in edible component, because cargo technicians LOVE packing peanuts
/obj/item/food/grown/peanut/packing/proc/check_liked(mob/living/carbon/human/consumer)
	var/obj/item/organ/liver/liver = consumer.get_organ_slot(ORGAN_SLOT_LIVER)
	if(!HAS_TRAIT(consumer, TRAIT_AGEUSIA) && liver && HAS_TRAIT(liver, TRAIT_CARGO_METABOLISM))
		return FOOD_LIKED
