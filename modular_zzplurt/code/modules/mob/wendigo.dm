/// SPLURT's custom wendigo, originally implemented by MosleyTheMalO and Comicao1.
/// Adapted from VENUS Station's snowflake carbon mob to the current basic mob and simulated genital systems.
/mob/living/basic/wendigo
	name = "wendigo"
	desc = "A towering horned creature adapted to the cold, with an imposing frame and an unnervingly intelligent gaze."
	icon = 'modular_zzplurt/icons/mobs/wendigo.dmi'
	icon_state = "reference"
	icon_living = "reference"
	icon_dead = "reference"
	basic_mob_flags = FLIP_ON_DEATH
	gender = FEMALE
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	ai_controller = /datum/ai_controller/basic_controller
	speak_emote = list("growls", "snorts")
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	attack_sound = 'sound/effects/magic/demon_attack1.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW
	maxHealth = 200
	health = 200
	melee_damage_lower = 15
	melee_damage_upper = 20
	obj_damage = 20
	see_in_dark = 8
	faction = list("wendigo")
	unsuitable_atmos_damage = 5
	gold_core_spawnable = FRIENDLY_SPAWN
	simulated_genitals = list(
		ORGAN_SLOT_PENIS = TRUE,
		ORGAN_SLOT_ANUS = TRUE,
		ORGAN_SLOT_BREASTS = TRUE,
		ORGAN_SLOT_BELLY = TRUE,
		ORGAN_SLOT_BUTT = TRUE
	)

/mob/living/basic/wendigo/Initialize(mapload)
	. = ..()
	add_traits(list(TRAIT_SNOWSTORM_IMMUNE), INNATE_TRAIT)

/mob/living/basic/wendigo/hostile
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile
	gold_core_spawnable = HOSTILE_SPAWN
