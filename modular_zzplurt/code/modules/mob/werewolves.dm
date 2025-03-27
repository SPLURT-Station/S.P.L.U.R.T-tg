/mob/living/basic/werewolf
	name = "Werewolf"
	desc = "A massive, wolfish creature with powerful muscles, razor-sharp claws, and aggression to match."
	icon = 'modular_zzplurt/icons/mob/weres/werewolf.dmi'
	icon_state = "Werewolf_idle"
	icon_dead = "Werewolf_dead"
	pixel_x = -16
	gender = MALE
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	ai_controller = /datum/ai_controller/basic_controller/
	speak_emote = list("growls", "howls")
	speed = 1
	see_in_dark = 8
	butcher_results = list(/obj/item/food/meat/slab/ = 4,
							/obj/item/stack/sheet/animalhide = 2,
							/obj/item/stack/sheet/bone = 4)
	attack_verb_continuous = "claws"
	maxHealth = 500
	health = 500
	obj_damage = 60
	armour_penetration = 30
	melee_damage_lower = 56
	melee_damage_upper = 56
	faction = list("werewolves")
	unsuitable_atmos_damage = 5
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/basic/werewolf/Initialize(mapload)
	. = ..()

/mob/living/basic/werewolf/hostile
	ai_controller = /datum/ai_controller/basic_controller/simple_hostile

/mob/living/basic/werewolf/hostile/icewolf
	name = "Ice-bound Werewolf"
	desc = "A massive, white, wolfish creature with powerful muscles, icicle-sharp claws, and aggression to match."
	icon_state = "Ice_Wolf_idle"
	icon_dead = "Ice_Wolf_dead"

/mob/living/basic/werewolf/hostile/alphawolf
	name = "Alpha Werewolf"
	ai_controller = /datum/ai_controller/basic_controller/simple_hostile_obstacles

/mob/living/basic/werewolf/hostile/death()
	..()

/mob/living/basic/werewolf/funwolf/
	name = "Docile Werewolf"
	desc = "A massive, wolfish creature with powerful muscles, razor-sharp claws, and aggression to match. His sheath is lipsticking."
	simulated_genitals = list(
		ORGAN_SLOT_PENIS = TRUE,
		ORGAN_SLOT_ANUS = TRUE
	)
	gold_core_spawnable = FRIENDLY_SPAWN

/mob/living/basic/werewolf/funwolf/alpha
	desc = "I hope you enjoy being stuck on a knot for 5 hours."
	name = "Alpha Werewolf"
	maxHealth = 1200
	health = 1200
	obj_damage = 145
	armour_penetration = 80
	melee_damage_lower = 80
	melee_damage_upper = 80

/mob/living/basic/werewolf/funwolf/bitch
	gender = FEMALE
	name = "Werewolf Bitch"
	desc = "Look at her massive tracts of land."
	maxHealth = 400
	health = 400
	armour_penetration = 45
	simulated_genitals = list(
		ORGAN_SLOT_PENIS = FALSE,
		ORGAN_SLOT_ANUS = TRUE,
		ORGAN_SLOT_VAGINA = TRUE,
		ORGAN_SLOT_BREASTS = TRUE
	)

/mob/living/basic/werewolf/funwolf/mosley
	name = "Mosley?"
	desc = "Oh hey look it's the server best boy."
	icon_state = "The_Mosley_idle"
	icon_dead = "The_Mosley_dead"

/mob/living/basic/werewolf/funwolf/hellhound
	name = "Hellhound"
	desc = "A hellish red beast from the pits of tartarus, looking to desecrate any virgins it comes across."
	icon_state = "Hell_Hound_idle"
	icon_dead = "Hell_Hound_dead"

/mob/living/basic/werewolf/funwolf/hellhound/loona
	name = "Hellhound Bitch"
	desc = "A hellish red beast from the pits of tartarus, looking to desecrate any virgins it comes across. It has tits."
	gender = FEMALE
	simulated_genitals = list(
		ORGAN_SLOT_PENIS = FALSE,
		ORGAN_SLOT_ANUS = TRUE,
		ORGAN_SLOT_VAGINA = TRUE,
		ORGAN_SLOT_BREASTS = TRUE
	)
