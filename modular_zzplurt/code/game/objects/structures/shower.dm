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

			// Clear old reagents
			reagents.clear_reagents()

			// Add new reagent
			reagents.add_reagent(reagent_id, reagent_capacity)

			// Create balloon alert
			balloon_alert(user, "shower sanguinized!")

			// Alert in chat with reduced range
			user.visible_message(\
				span_notice("[user] swipes [user.p_their()] [emag_card] against the [src] controls."),\
				span_notice("You tap the [emag_card] against the [src] controls."),\
				vision_distance = COMBAT_MESSAGE_RANGE
			)

			// Log interaction
			user.log_message("has sanguinized a shower.", LOG_ATTACK)
