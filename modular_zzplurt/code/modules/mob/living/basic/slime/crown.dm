//Let's you place a crown on a slime's head, checks if the slime is alive and not already wearing a crown
/mob/living/basic/slime/proc/add_crown()
    if(istype(attacking_item, /obj/item/clothing/head/costume/crown) && stat == CONSCIOUS && !wearing_crown)
		wearing_crown = TRUE
		del attacking_item
		update_overlays()
		var/crown = new /obj/item/clothing/head/costume/crown(loc)
		crown.forceMove(src)
		to_chat(user, span_notice("You place the crown on the slime's head."))

//Changes the slime's overlay based on its lifestage and whether it's wearing a crown
/mob/living/basic/slime/proc/update_crown_overlay()
	if(wearing_crown)
		if(life_stage == SLIME_LIFE_STAGE_BABY)
			add_overlay(aslime-crown-baby)
		else if(life_stage == SLIME_LIFE_STAGE_ADULT)
			add_overlay(aslime-crown)

//Updates the slime's overlays, including the crown overlay if applicable
/mob/living/basic/slime/proc/update_overlays()
    ..()
    update_crown_overlay()
