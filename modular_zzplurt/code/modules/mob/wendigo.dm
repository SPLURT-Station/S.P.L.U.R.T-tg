/mob/living/basic/wendigo
	name = "Wendigo"
	desc = "A tall, skeletal beast with the skull of a deer, driven by endless hunger."
	icon = 'modular_zzplurt/icons/mobs/wendigo.dmi'
	icon_state = "wendigo"
	icon_living = "wendigo"
	icon_dead = "wendigo_dead"
	pixel_x = -16
	gender = MALE
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST, MOB_UNDEAD)
	ai_controller = /datum/ai_controller/basic_controller/
	speak_emote = list("screeches", "shrieks")
	speed = 1
	see_in_dark = 8
	butcher_results = list(
	    /obj/item/food/meat/slab = 4,
	    /obj/item/stack/sheet/animalhide = 2,
	    /obj/item/stack/sheet/bone = 6
	)
	attack_verb_continuous = "rends"
	attack_verb_simple = "rend"
	maxHealth = 600
	health = 600
	obj_damage = 70
	armour_penetration = 35
	melee_damage_lower = 50
	melee_damage_upper = 50
	faction = list("wendigo")
	unsuitable_atmos_damage = 5
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/basic/wendigo/Initialize(mapload)
	. = ..()

/mob/living/basic/wendigo/hostile
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile

/mob/living/basic/wendigo/hostile/alpha
	name = "Alpha Wendigo"
	icon_state = "alpha_wendigo"
	maxHealth = 1200
	health = 1200
	obj_damage = 120
	armour_penetration = 50
	melee_damage_lower = 70
	melee_damage_upper = 70

/mob/living/basic/wendigo/funwendigo
	name = "Docile Wendigo"
	desc = "A tall, skeletal beast with the skull of a deer. Despite its terrifying appearance, it seems strangely... affectionate."
	simulated_genitals = list(
	    ORGAN_SLOT_PENIS = TRUE,
	    ORGAN_SLOT_ANUS = TRUE
	)
	gold_core_spawnable = FRIENDLY_SPAWN

/mob/living/basic/wendigo/funwendigo/femwendigo
	name = "Wendigo Matriarch"
	desc = "A towering female wendigo, her bony frame adorned with tattered fur. Her gaze is eerily gentle."
	gender = FEMALE
	icon_state = "fem_wendigo"
	simulated_genitals = list(
	    ORGAN_SLOT_PENIS = FALSE,
	    ORGAN_SLOT_ANUS = TRUE,
	    ORGAN_SLOT_VAGINA = TRUE,
	    ORGAN_SLOT_BREASTS = TRUE
	)
	maxHealth = 500
	health = 500
	armour_penetration = 40
