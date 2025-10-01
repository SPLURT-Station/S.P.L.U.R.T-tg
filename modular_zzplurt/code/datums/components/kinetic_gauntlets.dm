/*!
 * Kinetic Gauntlets Component
 *
 * Implements kinetic crusher mechanics for gauntlet-type items.
 * Provides mark/detonate functionality without modifying core crusher code.
 */

/datum/component/kinetic_gauntlets
	/// List of attached crusher trophies
	var/list/obj/item/crusher_trophy/trophies = list()
	/// Damage dealt on mark detonation
	var/detonation_damage = 50
	/// Extra damage on backstab
	var/backstab_bonus = 30
	/// Time to recharge after firing projectile
	var/recharge_time = 1.5 SECONDS
	/// Are we ready to fire projectile?
	var/charged = TRUE
	/// Recharge timer
	var/charge_timer
	/// Callback to check if we can attack (wielding, etc)
	var/datum/callback/attack_check
	/// Callback to check if we can detonate marks
	var/datum/callback/detonate_check
	/// Last target we hit
	var/mob/living/last_target
	/// Time of last hit
	var/last_hit_time = 0
	/// Max time between hits to detonate
	var/hit_window = 1.5 SECONDS

/datum/component/kinetic_gauntlets/Initialize(detonation_damage = 50, backstab_bonus = 30, recharge_time = 1.5 SECONDS, datum/callback/attack_check = null, datum/callback/detonate_check = null)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	src.detonation_damage = detonation_damage
	src.backstab_bonus = backstab_bonus
	src.recharge_time = recharge_time
	src.attack_check = attack_check
	src.detonate_check = detonate_check

/datum/component/kinetic_gauntlets/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(on_update_overlays))
	RegisterSignal(parent, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK, PROC_REF(on_attack))
	RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, PROC_REF(on_afterattack))

/datum/component/kinetic_gauntlets/Destroy(force)
	QDEL_LIST(trophies)
	attack_check = null
	detonate_check = null
	last_target = null
	return ..()

/datum/component/kinetic_gauntlets/proc/on_examine(obj/item/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	var/total_force = source.force + detonation_damage
	var/backstab_force = total_force + backstab_bonus

	examine_list += span_notice("Mark a large creature with a destabilizing force with right-click, then hit them in melee to do <b>[total_force]</b> damage.")
	examine_list += span_notice("Does <b>[backstab_force]</b> damage if the target is backstabbed, instead of <b>[total_force]</b>.")

	for(var/obj/item/crusher_trophy/trophy as anything in trophies)
		examine_list += span_notice("It has \a [trophy] attached, which causes [trophy.effect_desc()].")

/datum/component/kinetic_gauntlets/proc/on_update_overlays(atom/source, list/overlays)
	SIGNAL_HANDLER

	if(!charged)
		overlays += "[source.icon_state]_uncharged"

/datum/component/kinetic_gauntlets/proc/on_attackby(datum/source, obj/item/attacking_item, mob/user, params)
	SIGNAL_HANDLER

	if(attacking_item.tool_behaviour == TOOL_CROWBAR)
		if(!LAZYLEN(trophies))
			to_chat(user, span_warning("There are no trophies on [source]."))
			return COMPONENT_NO_AFTERATTACK

		to_chat(user, span_notice("You remove [source]'s trophies."))
		attacking_item.play_tool_sound(source)
		for(var/obj/item/crusher_trophy/trophy as anything in trophies)
			trophy.remove_from(parent, user)
		return COMPONENT_NO_AFTERATTACK

	if(istype(attacking_item, /obj/item/crusher_trophy))
		var/obj/item/crusher_trophy/trophy = attacking_item

		for(var/obj/item/crusher_trophy/existing_trophy as anything in trophies)
			if(istype(existing_trophy, trophy.denied_type) || istype(trophy, existing_trophy.denied_type))
				to_chat(user, span_warning("You can't seem to attach [trophy] to [source]. Maybe remove a few trophies?"))
				return COMPONENT_NO_AFTERATTACK

		if(!user.transferItemToLoc(trophy, parent))
			return COMPONENT_NO_AFTERATTACK

		trophies += trophy
		to_chat(user, span_notice("You attach [trophy] to [source]."))
		return COMPONENT_NO_AFTERATTACK

/datum/component/kinetic_gauntlets/proc/on_attack(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER

	if(attack_check && !attack_check.Invoke(user))
		return COMPONENT_CANCEL_ATTACK_CHAIN

	var/datum/status_effect/crusher_damage/damage_effect = target.has_status_effect(/datum/status_effect/crusher_damage) || target.apply_status_effect(/datum/status_effect/crusher_damage)
	var/target_health_before = target.health

	for(var/obj/item/crusher_trophy/trophy as anything in trophies)
		trophy.on_melee_hit(target, user)

	if(!QDELETED(damage_effect) && !QDELETED(target))
		damage_effect.total_damage += source.force + (target_health_before - target.health)

	var/datum/status_effect/crusher_mark/mark = target.has_status_effect(/datum/status_effect/crusher_mark)
	if(mark && detonate_check?.Invoke(user))
		var/current_time = world.time
		if(last_target == target && (current_time - last_hit_time) <= hit_window)
			var/boosted_mark = mark.boosted
			if(target.remove_status_effect(mark))
				detonate_mark(target, user, boosted_mark)
			last_target = null
			last_hit_time = 0
		else
			last_target = target
			last_hit_time = current_time

/datum/component/kinetic_gauntlets/proc/on_afterattack(obj/item/source, mob/living/target, mob/living/user, click_parameters)
	SIGNAL_HANDLER
	return

/datum/component/kinetic_gauntlets/proc/fire_kinetic_blast(atom/target, mob/living/user, list/modifiers)
	if(!charged)
		return FALSE

	var/turf/proj_turf = user.loc
	if(!isturf(proj_turf))
		return FALSE

	var/obj/projectile/destabilizer/projectile = new(proj_turf)
	projectile.icon = 'icons/obj/weapons/guns/projectiles.dmi'
	projectile.icon_state = "pulse1"

	for(var/obj/item/crusher_trophy/trophy as anything in trophies)
		trophy.on_projectile_fire(projectile, user)

	projectile.aim_projectile(target, user, modifiers)
	projectile.firer = user
	projectile.fired_from = parent

	playsound(user, 'sound/items/weapons/plasma_cutter.ogg', 100, TRUE)
	projectile.fire()

	charged = FALSE
	var/atom/parent_atom = parent
	parent_atom.update_appearance()
	attempt_recharge()
	return TRUE

/datum/component/kinetic_gauntlets/proc/attempt_recharge(custom_time)
	if(!custom_time)
		custom_time = recharge_time

	deltimer(charge_timer)
	charge_timer = addtimer(CALLBACK(src, PROC_REF(recharge_complete)), custom_time, TIMER_STOPPABLE)

/datum/component/kinetic_gauntlets/proc/recharge_complete()
	if(!charged)
		charged = TRUE
		var/atom/parent_atom = parent
		parent_atom.update_appearance()
		playsound(parent_atom.loc, 'sound/items/weapons/kinetic_reload.ogg', 60, TRUE)

/datum/component/kinetic_gauntlets/proc/detonate_mark(mob/living/target, mob/living/user, boosted = FALSE)
	var/datum/status_effect/crusher_damage/damage_effect = target.has_status_effect(/datum/status_effect/crusher_damage) || target.apply_status_effect(/datum/status_effect/crusher_damage)

	var/target_health = target.health

	for(var/obj/item/crusher_trophy/trophy as anything in trophies)
		trophy.on_mark_detonation(target, user)

	if(QDELETED(target))
		return

	if(!QDELETED(damage_effect))
		damage_effect.total_damage += target_health - target.health

	new /obj/effect/temp_visual/kinetic_blast(get_turf(target))

	var/backstabbed = FALSE
	var/combined_damage = detonation_damage
	var/def_check = target.getarmor(type = BOMB)

	if(check_behind(user, target) || boosted)
		backstabbed = TRUE
		combined_damage += backstab_bonus
		playsound(user, 'sound/items/weapons/kinetic_accel.ogg', 100, TRUE)

	if(!QDELETED(damage_effect))
		damage_effect.total_damage += combined_damage

	SEND_SIGNAL(user, COMSIG_LIVING_CRUSHER_DETONATE, target, parent, backstabbed)

	target.apply_damage(combined_damage, BRUTE, blocked = def_check)

	var/target_turf = get_turf(target)
	var/user_turf = get_turf(user)
	if(target_turf && user_turf && !target.anchored)
		step(target, get_dir(user, target))
		step(user, get_dir(target, user))
