// Bloodfledge exclusive emag
/datum/crafting_recipe/emag_bloodfledge
	name = "Hemorrhagic Sanguinizer"
	desc = "A modified Bloodfledge ID card capable of channeling technopathic blood magic."
	reqs = list(
		/obj/item/card/id/advanced/quirk/bloodfledge = 1,
		/obj/item/assembly/signaler = 1,
		/obj/item/reagent_containers/syringe = 1,
		/obj/item/reagent_containers/blood = 1,
		/obj/item/stack/cable_coil = 5,
	)
	result = /obj/item/card/emag/bloodfledge
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER, TOOL_MULTITOOL)
	category = CAT_EQUIPMENT
	crafting_flags = CRAFT_MUST_BE_LEARNED

// Bloodfledge emag post-crafting
/obj/item/card/emag/bloodfledge/on_craft_completion(list/components, datum/crafting_recipe/current_recipe, atom/crafter)
	// Define carbon holder
	var/mob/living/carbon/item_mob = crafter

	// Check for valid holder
	if(!item_mob || !istype(item_mob, /mob/living/carbon))
		// Do nothing
		return

	// Get blood prefix
	var/blood_name = item_mob?.get_blood_prefix()

	// Check if blood prefix exists
	if(blood_name)
		// Rename the card
		name = LOWER_TEXT("[blood_name]rrhagic Sanguinizer")
	. = ..()

/datum/crafting_recipe/durathread_utility_belt
	name = "Durathread Toolbelt"
	result = /obj/item/storage/backpack/duffelbag/durathread_utility_belt
	reqs = list(/obj/item/stack/sheet/durathread = 5,
				/obj/item/stack/sheet/leather = 2)
	time = 5 SECONDS
	category = CAT_CLOTHING
