/obj/item/clothing/suit/bellyriding_harness
	name = "dual harness"
	desc = "LustWish-brand harness, suitable for fastening one person under or beneath another. \
			Manufactured in a \"one-size-fits-all\" configuration for bipedals and taurs alike. \
			In recent times, these have come into fashion with EROS-sector security forces for \"alternative\" forms of punishment or coercion."

	icon = 'modular_skyrat/master_files/icons/obj/clothing/under/misc.dmi'
	icon_state = "gear_harness"

	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit/misc.dmi'
	worn_icon_taur_hoof = 'modular_zzplurt/icons/mob/clothing/suit/misc_hoof.dmi'
	worn_icon_taur_paw = 'modular_zzplurt/icons/mob/clothing/suit/misc_paw.dmi'
	worn_icon_taur_snake = null
	worn_icon_state = "bellyriding_harness"
	supports_variations_flags = CLOTHING_NO_VARIATION

	slot_flags = ITEM_SLOT_OCLOTHING

/obj/item/clothing/suit/bellyriding_harness/mob_can_equip(mob/living/user, slot, disable_warning, bypass_equip_delay_self, ignore_equipped, indirect_action)
	if(isteshari(user) || user.mob_size < 1) // fuck you
		if(!disable_warning)
			to_chat(user, span_warning("This harness is far too big for you to wear!"))
		return FALSE
	return ..()

/obj/item/clothing/suit/bellyriding_harness/equipped(mob/user, slot, initial)
	. = ..()
	if(ishuman(loc) && slot == ITEM_SLOT_OCLOTHING)
		loc.AddComponent(/datum/component/bellyriding, src)
		strip_delay = 7 SECONDS
	else
		qdel(loc.GetComponent(/datum/component/bellyriding)) // qdel accepts null and this is easier than wondering if dropped() actually works
		strip_delay = initial(strip_delay)

/obj/item/clothing/suit/bellyriding_harness/can_mob_unequip(mob/user)
	var/mob/living/carbon/human/wearer = loc
	if(!istype(wearer))
		return ..()

	if(wearer.get_slot_by_item(src) == ITEM_SLOT_OCLOTHING)
		var/datum/component/bellyriding/rider_comp = wearer.GetComponent(/datum/component/bellyriding)
		if(rider_comp?.current_victim)
			to_chat(user, span_warning("Someone is currently riding [wearer == user ? "you" : wearer], untie them first!"))
			return FALSE

	return ..()

/obj/item/clothing/suit/bellyriding_harness/dropped(mob/user, silent)
	. = ..()
	qdel(user.GetComponent(/datum/component/bellyriding)) // qdel accepts null
