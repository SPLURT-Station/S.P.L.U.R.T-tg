/*!
 * Kinetic Gauntlets Trophy Extensions
 *
 * Simple extensions for specific crusher trophies to work with gauntlets.
 * Much simpler approach - no base method overrides.
 */

/obj/item/crusher_trophy/demon_claws/add_to(obj/item/crusher, mob/living/user)
	. = ..()
	if(!.)
		return FALSE

	var/datum/component/kinetic_gauntlets/gauntlets_comp = crusher.GetComponent(/datum/component/kinetic_gauntlets)
	if(gauntlets_comp)
		var/obj/item/clothing/gloves/kinetic_gauntlets/gauntlets = crusher
		if(gauntlets.left_gauntlet)
			gauntlets.left_gauntlet.force += bonus_value * 0.2
		if(gauntlets.right_gauntlet)
			gauntlets.right_gauntlet.force += bonus_value * 0.2
		gauntlets_comp.detonation_damage += bonus_value * 0.8

/obj/item/crusher_trophy/demon_claws/remove_from(obj/item/crusher, mob/living/user)
	var/datum/component/kinetic_gauntlets/gauntlets_comp = crusher.GetComponent(/datum/component/kinetic_gauntlets)
	if(gauntlets_comp)
		var/obj/item/clothing/gloves/kinetic_gauntlets/gauntlets = crusher
		if(gauntlets.left_gauntlet)
			gauntlets.left_gauntlet.force -= bonus_value * 0.2
		if(gauntlets.right_gauntlet)
			gauntlets.right_gauntlet.force -= bonus_value * 0.2
		gauntlets_comp.detonation_damage -= bonus_value * 0.8

	return ..()

/obj/item/crusher_trophy/legion_skull/add_to(obj/item/crusher, mob/living/user)
	. = ..()
	if(!.)
		return FALSE

	var/datum/component/kinetic_gauntlets/gauntlets_comp = crusher.GetComponent(/datum/component/kinetic_gauntlets)
	if(gauntlets_comp)
		gauntlets_comp.recharge_time -= bonus_value

/obj/item/crusher_trophy/legion_skull/remove_from(obj/item/crusher, mob/living/user)
	var/datum/component/kinetic_gauntlets/gauntlets_comp = crusher.GetComponent(/datum/component/kinetic_gauntlets)
	if(gauntlets_comp)
		gauntlets_comp.recharge_time += bonus_value

	return ..()

/obj/item/crusher_trophy/wendigo_horn/add_to(obj/item/crusher, mob/living/user)
	. = ..()
	if(!.)
		return FALSE

	var/datum/component/kinetic_gauntlets/gauntlets_comp = crusher.GetComponent(/datum/component/kinetic_gauntlets)
	if(gauntlets_comp)
		var/obj/item/clothing/gloves/kinetic_gauntlets/gauntlets = crusher
		if(gauntlets.left_gauntlet)
			gauntlets.left_gauntlet.force *= 2
		if(gauntlets.right_gauntlet)
			gauntlets.right_gauntlet.force *= 2

/obj/item/crusher_trophy/wendigo_horn/remove_from(obj/item/crusher, mob/living/user)
	var/datum/component/kinetic_gauntlets/gauntlets_comp = crusher.GetComponent(/datum/component/kinetic_gauntlets)
	if(gauntlets_comp)
		var/obj/item/clothing/gloves/kinetic_gauntlets/gauntlets = crusher
		if(gauntlets.left_gauntlet)
			gauntlets.left_gauntlet.force /= 2
		if(gauntlets.right_gauntlet)
			gauntlets.right_gauntlet.force /= 2

	return ..()
