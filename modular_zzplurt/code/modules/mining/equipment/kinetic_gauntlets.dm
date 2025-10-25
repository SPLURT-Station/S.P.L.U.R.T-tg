/*!
 * Kinetic Gauntlets
 *
 * Mining gauntlets with extendable fist-weapons that use kinetic crusher mechanics.
 * Alternative to the traditional two-handed kinetic crusher.
 */

/obj/item/clothing/gloves/kinetic_gauntlets
	name = "kinetic gauntlets"
	desc = "Nanotrasen's take on the power-fist, originally designed to help the security department but ultimately scrapped due to causing too much collateral damage. \
		Later on, repurposed into a pair of mining tools after a disgruntled shaft miner complained to R&D about mining \"not being metal enough\"."
	icon = 'modular_zzplurt/icons/obj/mining.dmi'
	icon_state = "kgauntlets"
	worn_icon = 'modular_zzplurt/icons/mob/clothing/gloves.dmi'
	worn_icon_state = "kgauntlets_off"

	armor_type = /datum/armor/melee_energy
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 1.15, /datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT * 2.075)
	resistance_flags = FIRE_PROOF

	force = 3
	obj_flags = UNIQUE_RENAME
	throwforce = 3
	throw_speed = 2

	actions_types = list(/datum/action/item_action/extend_gauntlets)
	attack_verb_continuous = list("slaps", "challenges")
	attack_verb_simple = list("slap", "challenge")
	equip_delay_self = 2 SECONDS
	hitsound = 'sound/items/weapons/slap.ogg'
	slot_flags = ITEM_SLOT_GLOVES
	w_class = WEIGHT_CLASS_BULKY

	light_on = FALSE
	light_power = 5
	light_range = 4
	light_system = OVERLAY_LIGHT_DIRECTIONAL

	/// Left gauntlet fist
	var/obj/item/kinetic_gauntlet/left/left_gauntlet
	/// Right gauntlet fist
	var/obj/item/kinetic_gauntlet/right/right_gauntlet

/obj/item/clothing/gloves/kinetic_gauntlets/Initialize(mapload)
	. = ..()

	left_gauntlet = new(src)
	right_gauntlet = new(src)

	AddComponent(/datum/component/kinetic_gauntlets, \
		detonation_damage = 50, \
		backstab_bonus = 30, \
		recharge_time = 1.5 SECONDS, \
		attack_check = CALLBACK(src, PROC_REF(can_attack)), \
		detonate_check = CALLBACK(src, PROC_REF(can_detonate)) \
	)

/obj/item/clothing/gloves/kinetic_gauntlets/Destroy()
	QDEL_NULL(left_gauntlet)
	QDEL_NULL(right_gauntlet)
	return ..()

/obj/item/clothing/gloves/kinetic_gauntlets/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	left_gauntlet?.forceMove(src)
	right_gauntlet?.forceMove(src)

/obj/item/clothing/gloves/kinetic_gauntlets/ui_action_click(mob/user, datum/action/actiontype)
	toggle_gauntlets()

/obj/item/clothing/gloves/kinetic_gauntlets/proc/gauntlets_deployed()
	var/mob/living/carbon/human/wearer = loc
	if(!istype(wearer))
		return FALSE
	return (left_gauntlet?.loc == wearer) || (right_gauntlet?.loc == wearer)

/obj/item/clothing/gloves/kinetic_gauntlets/proc/can_attack(mob/living/user)
	return (left_gauntlet?.loc == user) || (right_gauntlet?.loc == user)

/obj/item/clothing/gloves/kinetic_gauntlets/proc/can_detonate(mob/living/user)
	return (left_gauntlet?.loc == user) && (right_gauntlet?.loc == user)

/obj/item/clothing/gloves/kinetic_gauntlets/proc/on_gauntlet_qdel()
	if(QDELETED(left_gauntlet))
		left_gauntlet = null
	if(QDELETED(right_gauntlet))
		right_gauntlet = null

	if(isnull(left_gauntlet) && isnull(right_gauntlet) && !QDELING(src))
		qdel(src)

/obj/item/clothing/gloves/kinetic_gauntlets/proc/toggle_gauntlets()
	var/mob/living/carbon/human/wearer = loc
	if(!istype(wearer))
		return

	if(gauntlets_deployed())
		retract_gauntlets()
	else
		deploy_gauntlets()

/obj/item/clothing/gloves/kinetic_gauntlets/proc/deploy_gauntlets()
	var/mob/living/carbon/human/wearer = loc
	if(!istype(wearer) || DOING_INTERACTION(wearer, type))
		return

	if(wearer.gloves != src)
		to_chat(wearer, span_warning("You must be wearing these to do this!"))
		return

	if(gauntlets_deployed())
		return

	if(!wearer.can_put_in_hand(left_gauntlet, 1) || !wearer.can_put_in_hand(right_gauntlet, 2))
		playsound(src, 'sound/machines/scanner/scanbuzz.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE)
		to_chat(wearer, span_warning("You need both free hands to deploy [src]!"))
		return

	wearer.add_movespeed_modifier(/datum/movespeed_modifier/equipping_gauntlets)
	if(!do_after(wearer, 1.5 SECONDS, src, IGNORE_USER_LOC_CHANGE, interaction_key = type))
		playsound(src, 'sound/machines/scanner/scanbuzz.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE)
		to_chat(wearer, span_warning("You fail to deploy [src]!"))
		wearer.remove_movespeed_modifier(/datum/movespeed_modifier/equipping_gauntlets)
		return

	wearer.remove_movespeed_modifier(/datum/movespeed_modifier/equipping_gauntlets)

	if(!wearer.can_put_in_hand(left_gauntlet, 1) || !wearer.can_put_in_hand(right_gauntlet, 2))
		playsound(src, 'sound/machines/scanner/scanbuzz.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE)
		to_chat(wearer, span_warning("You need both free hands to deploy [src]!"))
		return

	wearer.put_in_l_hand(left_gauntlet)
	wearer.put_in_r_hand(right_gauntlet)

	ADD_TRAIT(src, TRAIT_NODROP, type)

	worn_icon_state = "kgauntlets_on"
	wearer.update_worn_gloves()

	playsound(src, 'sound/vehicles/mecha/mechmove03.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	playsound(src, 'sound/vehicles/mecha/mechmove01.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	to_chat(wearer, span_notice("You deploy [src]."))

/obj/item/clothing/gloves/kinetic_gauntlets/proc/retract_gauntlets()
	var/mob/living/carbon/human/wearer = loc
	if(!istype(wearer) || DOING_INTERACTION(wearer, type))
		return

	if(wearer.gloves != src)
		to_chat(wearer, span_warning("You must be wearing these to do this!"))
		return

	if(!gauntlets_deployed())
		return

	wearer.add_movespeed_modifier(/datum/movespeed_modifier/equipping_gauntlets)
	if(!do_after(wearer, 1.5 SECONDS, src, IGNORE_USER_LOC_CHANGE, interaction_key = type))
		wearer.remove_movespeed_modifier(/datum/movespeed_modifier/equipping_gauntlets)
		playsound(src, 'sound/machines/scanner/scanbuzz.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE)
		to_chat(wearer, span_warning("You fail to retract [src]!"))
		return

	wearer.remove_movespeed_modifier(/datum/movespeed_modifier/equipping_gauntlets)

	left_gauntlet?.forceMove(src)
	right_gauntlet?.forceMove(src)

	REMOVE_TRAIT(src, TRAIT_NODROP, type)

	worn_icon_state = "kgauntlets_off"
	wearer.update_worn_gloves()

	playsound(src, 'sound/vehicles/mecha/powerloader_turn2.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	playsound(src, 'sound/vehicles/mecha/mechmove01.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	to_chat(wearer, span_notice("You retract [src]."))

/obj/item/kinetic_gauntlet
	name = "kinetic gauntlet"
	desc = "Okay, these <i>are</i> pretty metal."
	icon = 'modular_zzplurt/icons/obj/mining.dmi'
	icon_state = "kgauntlet_r"
	inhand_icon_state = "kgauntlet"
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/equipment/melee_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/equipment/melee_righthand.dmi'
	attack_verb_continuous = list("rams", "fists", "pulverizes", "power-punches")
	attack_verb_simple = list("ram", "fist", "pulverize", "power-punch")

	armor_type = /datum/armor/melee_energy
	force = 15
	obj_flags = DROPDEL
	resistance_flags = FIRE_PROOF

	secondary_attack_speed = 0.1 SECONDS

	/// Linked gauntlets object
	var/obj/item/clothing/gloves/kinetic_gauntlets/linked_gauntlets
	/// Next attack time for this specific gauntlet
	var/next_attack = 0
	/// Is this the left hand?
	var/is_left_hand = FALSE

/obj/item/kinetic_gauntlet/Initialize(mapload)
	. = ..()
	if(!istype(loc, /obj/item/clothing/gloves/kinetic_gauntlets))
		return INITIALIZE_HINT_QDEL

	linked_gauntlets = loc
	ADD_TRAIT(src, TRAIT_NODROP, type)

	RegisterSignal(src, COMSIG_ITEM_ATTACK, PROC_REF(on_attack_delegate))
	RegisterSignal(src, COMSIG_ITEM_AFTERATTACK, PROC_REF(on_afterattack_delegate))

/obj/item/kinetic_gauntlet/Destroy(force)
	if(linked_gauntlets)
		linked_gauntlets.on_gauntlet_qdel()
		linked_gauntlets = null
	return ..()

/obj/item/kinetic_gauntlet/proc/on_attack_delegate(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER

	if(!linked_gauntlets)
		return

	var/datum/component/kinetic_gauntlets/gauntlets_comp = linked_gauntlets.GetComponent(/datum/component/kinetic_gauntlets)
	if(!gauntlets_comp)
		return

	return gauntlets_comp.on_attack(source, target, user)

/obj/item/kinetic_gauntlet/proc/on_afterattack_delegate(obj/item/source, mob/living/target, mob/living/user, click_parameters)
	SIGNAL_HANDLER

	if(!linked_gauntlets)
		return

	var/datum/component/kinetic_gauntlets/gauntlets_comp = linked_gauntlets.GetComponent(/datum/component/kinetic_gauntlets)
	if(!gauntlets_comp)
		return

	return gauntlets_comp.on_afterattack(source, target, user, click_parameters)

/obj/item/kinetic_gauntlet/melee_attack_chain(mob/user, atom/target, params)
	if(next_attack > world.time)
		return
	return ..()

/obj/item/kinetic_gauntlet/attack(mob/living/target_mob, mob/living/user, params)
	. = ..()
	playsound(src, 'sound/items/weapons/genhit2.ogg', 40, TRUE)
	next_attack = world.time + 0.8 SECONDS
	user.changeNext_move(CLICK_CD_HYPER_RAPID)

	var/obj/item/other_gauntlet = user.get_inactive_held_item()
	if(istype(other_gauntlet, /obj/item/kinetic_gauntlet))
		user.swap_hand()

/obj/item/kinetic_gauntlet/attack_self(mob/user, modifiers)
	if(linked_gauntlets?.left_gauntlet && src != linked_gauntlets.left_gauntlet)
		return linked_gauntlets.left_gauntlet.attack_self(user, modifiers)
	return ..()

/obj/item/kinetic_gauntlet/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!linked_gauntlets)
		return ITEM_INTERACT_BLOCKING

	if(interacting_with == user)
		user.balloon_alert(user, "can't aim at yourself!")
		return ITEM_INTERACT_BLOCKING

	var/datum/component/kinetic_gauntlets/gauntlets_comp = linked_gauntlets.GetComponent(/datum/component/kinetic_gauntlets)
	if(!gauntlets_comp)
		return ITEM_INTERACT_BLOCKING

	if(gauntlets_comp.attack_check && !gauntlets_comp.attack_check.Invoke(user))
		return ITEM_INTERACT_BLOCKING

	if(!gauntlets_comp.charged)
		user.balloon_alert(user, "recharging...")
		return ITEM_INTERACT_BLOCKING

	gauntlets_comp.fire_kinetic_blast(interacting_with, user, modifiers)
	user.changeNext_move(CLICK_CD_MELEE)
	return ITEM_INTERACT_SUCCESS

/obj/item/kinetic_gauntlet/ranged_interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	return interact_with_atom_secondary(interacting_with, user, modifiers)

/obj/item/kinetic_gauntlet/left
	icon_state = "kgauntlet_l"
	is_left_hand = TRUE
	actions_types = list(/datum/action/item_action/toggle_light)

/obj/item/kinetic_gauntlet/left/Initialize(mapload)
	. = ..()
	if(linked_gauntlets)
		RegisterSignal(linked_gauntlets, COMSIG_ATOM_SABOTEUR_ACT, PROC_REF(do_saboteur))

/obj/item/kinetic_gauntlet/left/Destroy(force)
	if(linked_gauntlets)
		UnregisterSignal(linked_gauntlets, COMSIG_ATOM_SABOTEUR_ACT)
		linked_gauntlets.set_light_on(FALSE)
	return ..()

/obj/item/kinetic_gauntlet/left/update_overlays()
	. = ..()
	if(linked_gauntlets?.light_on)
		. += "[icon_state]_lit"

/obj/item/kinetic_gauntlet/left/attack_self(mob/user, modifiers)
	if(!linked_gauntlets)
		return

	linked_gauntlets.set_light_on(!linked_gauntlets.light_on)
	playsound(src, 'sound/items/weapons/empty.ogg', 100, TRUE)
	update_appearance()

/obj/item/kinetic_gauntlet/left/proc/do_saboteur(datum/source, disrupt_duration)
	SIGNAL_HANDLER
	if(!linked_gauntlets)
		return

	linked_gauntlets.set_light_on(FALSE)
	playsound(src, 'sound/items/weapons/empty.ogg', 100, TRUE)
	update_appearance()
	return COMSIG_SABOTEUR_SUCCESS

/obj/item/kinetic_gauntlet/right

/datum/action/item_action/extend_gauntlets
	name = "Extend Gauntlets"
	desc = "Deploy or retract the kinetic gauntlet fists."
	button_icon = 'modular_zzplurt/icons/obj/mining.dmi'
	button_icon_state = "kgauntlets"

/datum/movespeed_modifier/equipping_gauntlets
	multiplicative_slowdown = 0.8
