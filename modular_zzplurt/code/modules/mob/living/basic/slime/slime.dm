/mob/living/basic/slime
	var/obj/item/clothing/head/costume/crown/slime_crown

/mob/living/basic/slime/attackby(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/clothing/head/costume/crown))
		if(slime_crown)
			to_chat(user, span_warning("[src] is already wearing a crown!"))
			return

		if(!user.temporarilyRemoveItemFromInventory(attacking_item, force = TRUE, newloc = src))
			return

		slime_crown = attacking_item
		visible_message(span_notice("[user] crowns [src]!"))
		regenerate_icons()
		return

	return ..()

/mob/living/basic/slime/regenerate_icons()
	. = ..()
	if(slime_crown)
		add_overlay(mutable_appearance(
			icon = 'modular_zzplurt/icons/mob/slimes_with_crown_overlay_added.dmi',
			icon_state = life_stage == SLIME_LIFE_STAGE_BABY ? "aslime-crown-baby" : "aslime-crown",
			layer = ABOVE_MOB_LAYER,
		))

/mob/living/basic/slime/Destroy()
	QDEL_NULL(slime_crown)
	return ..()
