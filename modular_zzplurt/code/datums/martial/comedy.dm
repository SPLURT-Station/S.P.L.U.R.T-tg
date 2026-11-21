// close quarters comedy
// cqc but only the clown and the mime can use it, and only against each other

/datum/martial_art/cqc/comedy
	name = "Close Quarters Comedy"

/datum/martial_art/cqc/comedy/proc/is_nemesis(mob/living/attacker, atom/target) // is that motherfucker FUNNY?
	if (!attacker?.mind || !isliving(target))
		return FALSE
	var/mob/living/livetarget = target
	if (!livetarget?.mind)
		return FALSE
	var/datum/job/attackerjob = attacker.mind.assigned_role
	var/datum/job/targetjob = livetarget.mind.assigned_role
	if (istype(attackerjob, /datum/job/clown))
		return  istype(targetjob, /datum/job/mime)
	if (istype(attackerjob, /datum/job/mime))
		return  istype(targetjob, /datum/job/clown)
	return FALSE

// little helper so after_spawn() getting called multiple times doesn't duplicate cqc
/mob/living/proc/becomefunny() // please become funny
	if (locate(/datum/martial_art/cqc/comedy) in martial_arts)
		return // don't learn cqcomedy twice
	var/datum/martial_art/cqc/comedy/style = new(src)
	if (!style.teach(src)) // teach cqcomedy to the mob
		qdel(style)

/datum/job/clown/after_spawn(mob/living/spawned, client/player_client)
    . = ..()
    spawned.becomefunny()

/datum/job/mime/after_spawn(mob/living/spawned, client/player_client)
    . = ..()
    spawned.becomefunny()

/datum/martial_art/cqc/comedy/can_use(mob/living/martial_artist, atom/target = null) // target-aware can_use proc so we can check if that motherfucker is funny
	if (isnull(target))
		return ..() // inherited cqc procs that don't pass a target just call parent
	return ..() && is_nemesis(martial_artist, target)

// wire it all up
/datum/martial_art/cqc/comedy/unarmed_strike(mob/living/source, atom/attack_target, proximity, modifiers)
	if(!can_use(source, attack_target))
		return NONE
	return ..()

/datum/martial_art/cqc/comedy/attempt_grab(mob/living/source, mob/living/grabbing)
	if(!can_use(source, grabbing))
		return NONE
	return ..()

/datum/martial_art/cqc/comedy/check_block(mob/living/cqc_user, atom/movable/hitby, damage, attack_text, attack_type, ...)
	var/mob/living/attacker = GET_ASSAILANT(hitby)
	if (!attacker ||!can_use(cqc_user, attacker))
		return NONE
	return ..()

/datum/martial_art/cqc/comedy/on_attackby(mob/living/cqc_user, obj/item/attack_weapon, mob/attacker, list/modifiers)
	if (!attacker ||!can_use(cqc_user, attacker))
		return NONE
	return ..()

/datum/martial_art/cqc/comedy/smash_table(mob/living/source, mob/living/pushed_mob, obj/structure/table/table)
	if (!pushed_mob || !can_use(source, pushed_mob))
		return NONE
	return ..()

