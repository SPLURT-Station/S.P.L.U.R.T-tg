/mob/living/basic/trooper/mercenary
	name = "\improper Mercenary"
	desc = "A mercenary trooper, they follow where the paycheck leads."
	speed = 1
	maxHealth = 120
	health = 120
	melee_damage_lower = 10
	melee_damage_upper = 15
	faction = list(ROLE_DEATHSQUAD)
	corpse = /obj/effect/mob_spawn/corpse/human/mercenary
	mob_spawner = /obj/effect/mob_spawn/corpse/human/mercenary
	ai_controller = /datum/ai_controller/basic_controller/trooper
	death_message = "collapses to the ground."
