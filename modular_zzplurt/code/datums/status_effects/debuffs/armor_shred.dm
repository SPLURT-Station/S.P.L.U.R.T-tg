/datum/status_effect/armorshred
	id = "armorshred"
	status_type = STATUS_EFFECT_REPLACE // Prevents stacking, but allows for armour shredding to be changed if the new one is stronger.
	alert_type = /atom/movable/screen/alert/status_effect/armorshred
	duration = 6 SECONDS // Default duration of the effect.
	processing_speed = STATUS_EFFECT_NORMAL_PROCESS
	/// How much armour is reduced by this effect.
	var/shredding_strength = 0

/datum/status_effect/ants/on_creation(mob/living/new_owner, amount_left)
	if(isnum(amount_left) && new_owner.stat < HARD_CRIT)
		if(new_owner.stat < UNCONSCIOUS) // Unconscious people won't get messages
			to_chat(new_owner, span_userdanger("Your armour is shredded!"))
		ants_remaining += amount_left
	. = ..()

/datum/status_effect/ants/refresh(effect, amount_left)
	var/mob/living/carbon/human/victim = owner
	if(isnum(amount_left) && ants_remaining >= 1 && victim.stat < HARD_CRIT)
		if(victim.stat < UNCONSCIOUS) // Unconscious people won't get messages
			if(!prob(1)) // 99%
				to_chat(victim, span_userdanger("You're covered in MORE ants!"))
			else // 1%
				victim.say("AAHH! THIS SITUATION HAS ONLY BEEN MADE WORSE WITH THE ADDITION OF YET MORE ANTS!!", forced = /datum/status_effect/ants)
		ants_remaining += amount_left
	. = ..()

/datum/status_effect/ants/on_remove()
	ants_remaining = 0
	to_chat(owner, span_notice("All of the ants are off of your body!"))
	UnregisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT)
	. = ..()

/datum/status_effect/ants/get_examine_text()
	return span_warning("[owner.p_They()] [owner.p_are()] covered in ants!")

/datum/status_effect/ants/tick(seconds_between_ticks)
	var/mob/living/carbon/human/victim = owner
	victim.apply_damage(max(0.1, round((ants_remaining * damage_per_ant), 0.1)) * seconds_between_ticks, BRUTE, spread_damage = TRUE) //Scales with # of ants (lowers with time). Roughly 10 brute over 50 seconds.
	if(victim.stat <= SOFT_CRIT) //Makes sure people don't scratch at themselves while they're in a critical condition
		if(prob(15))
			switch(rand(1,2))
				if(1)
					victim.say(pick(ant_debuff_speech), forced = /datum/status_effect/ants)
				if(2)
					victim.emote("scream")
		if(prob(50)) // Most of the damage is done through random chance. When tested yielded an average 100 brute with 200u ants.
			switch(rand(1,50))
				if (1 to 8) //16% Chance
					to_chat(victim, span_danger("You scratch at the ants on your scalp!."))
					owner.apply_damage(0.4 * seconds_between_ticks, BRUTE, BODY_ZONE_HEAD)
				if (9 to 29) //40% chance
					to_chat(victim, span_danger("You scratch at the ants on your arms!"))
					owner.apply_damage(1.2 * seconds_between_ticks, BRUTE, pick(GLOB.arm_zones))
				if (30 to 49) //38% chance
					to_chat(victim, span_danger("You scratch at the ants on your leg!"))
					owner.apply_damage(1.2 * seconds_between_ticks, BRUTE, pick(GLOB.leg_zones))
				if(50) // 2% chance
					to_chat(victim, span_danger("You rub some ants away from your eyes!"))
					victim.set_eye_blur_if_lower(6 SECONDS)
					ants_remaining -= 5 // To balance out the blindness, it'll be a little shorter.
	ants_remaining--
	if(ants_remaining <= 0 || victim.stat >= HARD_CRIT)
		qdel(src) //If this person has no more ants on them or are dead, they are no longer affected.

/atom/movable/screen/alert/status_effect/armorshred
	name = "Armour Shredded!"
	desc = span_warning("Your armour is less effective!")
	icon_state = "antalert"
