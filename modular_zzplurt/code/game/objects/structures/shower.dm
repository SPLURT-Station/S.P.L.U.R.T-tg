// Showers are known for their hackable electrical components
/obj/machinery/shower/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()

	// Check if valid
	if(isnull(user) || !istype(emag_card))
		return FALSE

	// Check for bloodmag
	if(emag_card.type == /obj/item/card/emag/bloodfledge)
		// Check if reagent is already blood
		if(reagent_id == /datum/reagent/blood)
			// Alert user
			balloon_alert(user, "shower already sanguinized!")

		else
			// Set new reagent type
			reagent_id = /datum/reagent/blood

			// Alert user
			balloon_alert(user, "shower sanguinized!")
