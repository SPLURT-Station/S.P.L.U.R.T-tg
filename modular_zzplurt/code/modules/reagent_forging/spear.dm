// spears get their extended reach only when wielded
/obj/item/spear
	reach = 1

// the on_wield two-handed code runs after the modular code so we need to override it to set the reach to 2 when wielded
/obj/item/spear/on_wield(obj/item/source, mob/living/carbon/user)
	. = ..()
	reach = 2

/obj/item/spear/on_unwield(obj/item/source, mob/living/carbon/user)
	. = ..()
	reach = 1

/obj/item/melee/forged_reagent_weapon/spear/Initialize(mapload)
	. = ..()
	// InheritComponent has a typo and doesn't set from wield_reach properly, so we need to set wielded_reach and unwielded_reach manually
	var/datum/component/two_hand_reach/reach_component = GetComponent(/datum/component/two_hand_reach)
	reach_component.unwielded_reach = 1
	reach_component.wielded_reach = 2
	reach = 1
