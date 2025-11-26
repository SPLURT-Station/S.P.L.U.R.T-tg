/datum/storage/expanded_utility_belt
	max_slots = 14
	max_total_storage = 42

/datum/storage/expanded_utility_belt/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	set_holdable(GLOB.tool_items + list(
		/obj/item/clothing/gloves,
		/obj/item/radio,
		/obj/item/melee/sickly_blade/lock,
		/obj/item/reagent_containers/cup/soda_cans,
	))
