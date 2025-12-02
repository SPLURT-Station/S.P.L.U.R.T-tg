/obj/item/clothing/suit/hooded/wintercoat/fluffy_coat
	name = "Fluffy Coat"
	desc = "A very fluffy coat that can glow - the name \"Zen\" Is written on the tag.\n<span class='notice'>This coat can be toggled to glow! Alt-Right Click to toggle!</span>"
	icon_state = "furcoat_lit"
	icon = 'modular_zzplurt/icons/mob/clothing/suit/wintercoat.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit/wintercoat.dmi'
	inhand_icon_state = null
	var/toggled = FALSE
	var/obj/effect/dummy/lighting_obj/moblight/glow_light

/obj/item/clothing/suit/hooded/wintercoat/fluffy_coat/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()
	context[SCREENTIP_CONTEXT_ALT_RMB] = "Toggle glow"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/clothing/suit/hooded/wintercoat/fluffy_coat/worn_overlays(mutable_appearance/standing, isinhands, file2use, mutant_styles)
	. = ..()
	if(toggled && !isinhands)
		. += emissive_appearance(icon, icon_state, src, alpha = 80)

/obj/item/clothing/suit/hooded/wintercoat/fluffy_coat/click_alt_secondary(mob/user)
	. = ..()
	if(!isliving(user) || !user.can_perform_action(src))
		return

	var/mob/living/carbon/human/wearer = user

	if(wearer.usable_hands <= 0)
		balloon_alert(wearer, "you don't have hands!")
		return

	toggled = !toggled

	if(toggled)
		// Add glow effect if worn
		if(ishuman(wearer) && wearer.get_item_by_slot(ITEM_SLOT_OCLOTHING) == src)
			glow_light = wearer.mob_light(range = 3, power = 1.5, color = "#9900ff")
			wearer.add_filter("fluffy_coat_glow", 2, list("type" = "outline", "color" = "#9900ff", "alpha" = 80, "size" = 2))

		to_chat(wearer, span_notice("You activate the glow on \the [src]!"))
	else
		// Remove glow effect
		if(glow_light)
			QDEL_NULL(glow_light)
		if(ishuman(wearer))
			wearer.remove_filter("fluffy_coat_glow")

		to_chat(wearer, span_notice("You deactivate the glow on \the [src]."))

	if(loc == wearer)
		wearer.update_clothing(slot_flags)
	update_appearance(UPDATE_ICON)

/obj/item/clothing/suit/hooded/wintercoat/fluffy_coat/equipped(mob/living/user, slot)
	. = ..()
	if(!(toggled && slot == ITEM_SLOT_OCLOTHING))
		return
	glow_light = user.mob_light(range = 3, power = 1.5, color = "#9900ff")
	user.add_filter("fluffy_coat_glow", 2, list("type" = "outline", "color" = "#9900ff", "alpha" = 80, "size" = 2))

/obj/item/clothing/suit/hooded/wintercoat/fluffy_coat/dropped(mob/living/user)
	. = ..()
	if(!glow_light)
		return
	QDEL_NULL(glow_light)
	user.remove_filter("fluffy_coat_glow")

/obj/item/clothing/suit/hooded/wintercoat/fluffy_coat/Destroy()
	QDEL_NULL(glow_light)
	return ..()
