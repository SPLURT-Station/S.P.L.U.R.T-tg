/obj/item/stack/packing_peanuts
	name = "packing peanuts"
	singular_name = "packing peanut"
	desc = "100% biodegradable packing peanuts for ensuring safe delivery of fragile objects - You still shouldn't eat them."
	icon = 'modular_zzplurt/icons/obj/stack_objects.dmi'
	icon_state = "packing_peanuts"
	base_icon_state = "packing_peanuts"
	dye_color = DYE_RED
	w_class = WEIGHT_CLASS_TINY
	max_amount = 50
	item_flags = NOBLUDGEON
	merge_type = /obj/item/stack/packing_peanuts
	novariants = FALSE
	grind_results = list(/datum/reagent/consumable/peanut_butter/packing = 5, /datum/reagent/consumable/nutriment/fat/oil/corn = 2)

/obj/item/stack/packing_peanuts/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()
	AddComponentFrom(\
		SOURCE_EDIBLE_INNATE,\
		/datum/component/edible, \
		initial_reagents = list(/datum/reagent/consumable/corn_starch = 13, /datum/reagent/consumable/peanut_butter/packing = 2),\
		foodtypes = GRAIN | JUNKFOOD | NUTS | CLOTH,\
		volume = 15,\
		bite_consumption = 5,\
		tastes = "starch",\
		check_liked = CALLBACK(src, PROC_REF(check_liked)),\
	)

/// Override for checkliked in edible component, because cargo technicians LOVE packing peanuts
/obj/item/stack/packing_peanuts/proc/check_liked(mob/living/carbon/human/consumer)
	var/obj/item/organ/liver/liver = consumer.get_organ_slot(ORGAN_SLOT_LIVER)
	if(!HAS_TRAIT(consumer, TRAIT_AGEUSIA) && liver && HAS_TRAIT(liver, TRAIT_CARGO_METABOLISM))
		return FOOD_LIKED
