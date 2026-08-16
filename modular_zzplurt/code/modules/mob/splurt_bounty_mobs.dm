// Custom SPLURT mob variants for bounty #30.
// These subtypes reuse the upstream mob implementations, including their AI,
// attacks, loot, and lifecycle hooks.

/mob/living/basic/mining/wolf/hostile
	can_tame = FALSE
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/basic/mining/wolf/funwolf
	name = "docile funwolf"
	desc = "A large, social wolf that can be befriended and cared for."
	gold_core_spawnable = FRIENDLY_SPAWN
	faction = list(FACTION_NEUTRAL)

/mob/living/basic/mining/wolf/funwolf/female
	name = "docile she-wolf"
	gender = FEMALE

/mob/living/basic/mining/wolf/funwolf/alpha
	name = "alpha funwolf"
	maxHealth = 520
	health = 520
	melee_damage_lower = 28
	melee_damage_upper = 28

/mob/living/simple_animal/hostile/megafauna/wendigo/funwendigo
	name = "docile wendigo"
	desc = "A powerful wendigo variant configured as a friendly event spawn."
	faction = list(FACTION_NEUTRAL)
	gold_core_spawnable = FRIENDLY_SPAWN

/mob/living/simple_animal/hostile/megafauna/wendigo/funwendigo/female
	name = "docile she-wendigo"
	gender = FEMALE

/mob/living/simple_animal/hostile/megafauna/wendigo/funwendigo/alpha
	name = "alpha wendigo"
	maxHealth = 3200
	health = 3200
	melee_damage_lower = 55
	melee_damage_upper = 55
	gold_core_spawnable = HOSTILE_SPAWN

