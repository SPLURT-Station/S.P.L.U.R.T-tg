/*!
 * Megafauna Integration for Kinetic Gauntlets
 *
 * Extends megafauna achievement system to recognize kinetic gauntlets
 * as crusher weapons for appropriate achievements.
 */

/mob/living/simple_animal/hostile/megafauna/grant_achievement(medaltype, scoretype, crusher_kill, list/grant_achievement = list())
	if(!achievement_type || (flags_1 & ADMIN_SPAWNED_1) || !SSachievements.achievements_enabled)
		return FALSE

	if(!grant_achievement.len)
		for(var/mob/living/L in view(7,src))
			grant_achievement += L

	for(var/mob/living/L in grant_achievement)
		if(L.stat || !L.client)
			continue

		L.add_mob_memory(/datum/memory/megafauna_slayer, antagonist = src)
		L.client.give_award(/datum/award/achievement/boss/boss_killer, L)
		L.client.give_award(achievement_type, L)

		if(crusher_kill && is_using_crusher_weapon(L))
			L.client.give_award(crusher_achievement_type, L)

		L.client.give_award(/datum/award/score/boss_score, L)
		L.client.give_award(score_achievement_type, L)

	return TRUE

/mob/living/simple_animal/hostile/megafauna/proc/is_using_crusher_weapon(mob/living/user)
	var/obj/item/held_item = user.get_active_held_item()

	if(istype(held_item, /obj/item/kinetic_crusher))
		return TRUE

	if(istype(held_item, /obj/item/kinetic_gauntlet))
		return TRUE

	if(held_item?.GetComponent(/datum/component/kinetic_gauntlets))
		return TRUE

	return FALSE
