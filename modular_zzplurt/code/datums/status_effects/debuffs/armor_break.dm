/datum/status_effect/armorbreak
	id = "armorbreak"
	status_type = STATUS_EFFECT_REPLACE // Prevents stacking, but allows for armour breaking to be changed if the new one is different.
	alert_type = /atom/movable/screen/alert/status_effect/armorbreak
	duration = 3 SECONDS // Default duration of the effect.
	remove_on_fullheal = TRUE
	processing_speed = STATUS_EFFECT_NORMAL_PROCESS
	// How much armour is reduced by this effect. (technically, it is a multiplier on damage taken, but since negative armour is possible, it effectively reduces armour effectiveness)
	// Only applies to brute, burn, and stamina damage.
	// 1.5 = +50% damage taken, 2 = +100% damage taken, etc
	var/breaking_strength = 1.1

/atom/movable/screen/alert/status_effect/armorbreak
	name = "Armor Chip"
	desc = "Your armor has been mildly weakened!"
	icon_state = "armorchip" // WIP.

/datum/status_effect/armorbreak/crack
	alert_type = /atom/movable/screen/alert/status_effect/armorbreak/crack
	duration = 6 SECONDS
	breaking_strength = 1.25

/atom/movable/screen/alert/status_effect/armorbreak/crack
	name = "Armor Crack"
	desc = "Your armor has been weakened!"
	icon_state = "armorcrack" // WIP.

/datum/status_effect/armorbreak/bbreak // "bbreak" is a term used for "break" in armor breaking context because the code freaks out if you use "break" directly.
	alert_type = /atom/movable/screen/alert/status_effect/armorbreak/bbreak
	duration = 9 SECONDS
	breaking_strength = 1.5

/atom/movable/screen/alert/status_effect/armorbreak/bbreak
	name = "Armor Break"
	desc = "Your armor has been severely weakened!"
	icon_state = "armorbreak" // WIP.

/datum/status_effect/armorbreak/shatter
	alert_type = /atom/movable/screen/alert/status_effect/armorbreak/shatter
	duration = 12 SECONDS
	breaking_strength = 2

/atom/movable/screen/alert/status_effect/armorbreak/shatter
	name = "Armor Shatter"
	desc = "Your armor has been completely destroyed!"
	icon_state = "armorshatter" // WIP.

/datum/status_effect/armorbreak/on_apply()
	to_chat(owner, span_userdanger("Your armor's effectiveness has been reduced!"))
	var/mob/living/carbon/human/carbon_owner = owner
	carbon_owner.physiology.brute_mod *= breaking_strength
	carbon_owner.physiology.burn_mod *= breaking_strength
	carbon_owner.physiology.stamina_mod *= breaking_strength
	if(breaking_strength > 1.3) // AKA: Break or shatter causes excessive bleeding.
		carbon_owner.physiology.bleed_mod += 0.5
	return ..()

/datum/status_effect/armorbreak/on_remove()
	var/mob/living/carbon/human/carbon_recoverer = owner
	carbon_recoverer.physiology.brute_mod /= breaking_strength
	carbon_recoverer.physiology.burn_mod /= breaking_strength
	carbon_recoverer.physiology.stamina_mod /= breaking_strength
	if(breaking_strength > 1.3)
		carbon_recoverer.physiology.bleed_mod -= 0.5
	return ..()
