// Focused bounty delivery: custom, spawnable mob variants from SPLURT.
// Existing parents remain the source of truth; these subtypes reuse their
// AI, loot and lifecycle instead of duplicating implementation.

/mob/living/basic/mining/wolf/hostile
	can_tame = FALSE
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/basic/mining/wolf/funwolf
	name = "Docile Funwolf"
	desc = "A large, social wolf that can be befriended and cared for."
	simulated_genitals = list(ORGAN_SLOT_PENIS = TRUE, ORGAN_SLOT_ANUS = TRUE)
	gold_core_spawnable = FRIENDLY_SPAWN

/mob/living/basic/mining/wolf/funwolf/female
	name = "Docile She-wolf"
	gender = FEMALE
	simulated_genitals = list(ORGAN_SLOT_PENIS = FALSE, ORGAN_SLOT_ANUS = TRUE, ORGAN_SLOT_VAGINA = TRUE, ORGAN_SLOT_BREASTS = TRUE)

/mob/living/basic/mining/wolf/funwolf/alpha
	name = "Alpha Funwolf"
	maxHealth = 520
	health = 520
	melee_damage_lower = 28
	melee_damage_upper = 28

/mob/living/simple_animal/hostile/megafauna/wendigo/funwendigo
	name = "Docile Wendigo"
	desc = "A powerful wendigo variant configured as a friendly event spawn."
	simulated_genitals = list(ORGAN_SLOT_PENIS = TRUE, ORGAN_SLOT_ANUS = TRUE)
	gold_core_spawnable = FRIENDLY_SPAWN

/mob/living/simple_animal/hostile/megafauna/wendigo/funwendigo/female
	name = "Docile She-wendigo"
	gender = FEMALE
	simulated_genitals = list(ORGAN_SLOT_PENIS = FALSE, ORGAN_SLOT_ANUS = TRUE, ORGAN_SLOT_VAGINA = TRUE, ORGAN_SLOT_BREASTS = TRUE)

/mob/living/simple_animal/hostile/megafauna/wendigo/funwendigo/alpha
	name = "Alpha Wendigo"
	maxHealth = 3200
	health = 3200
	melee_damage_lower = 55
	melee_damage_upper = 55
	gold_core_spawnable = HOSTILE_SPAWN