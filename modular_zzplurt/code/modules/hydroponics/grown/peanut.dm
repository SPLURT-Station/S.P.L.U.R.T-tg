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
