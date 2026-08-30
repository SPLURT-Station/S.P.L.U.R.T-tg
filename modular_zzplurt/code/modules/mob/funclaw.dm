/mob/living/basic/deathclaw
	name = "deathclaw"
	desc = "A massive, reptilian creature with powerful muscles, razor-sharp claws, and aggression to match."
	icon = 'modular_zzplurt/icons/mob/claws/funclaws.dmi'
	icon_state = "deathclaw"
	icon_living = "deathclaw"
	icon_dead = "deathclaw_dead"
	pixel_x = -16
	gender = MALE
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	ai_controller = /datum/ai_controller/basic_controller/
	speak_emote = list("growls", "roars")
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
	faction = list("deathclaw")
	unsuitable_atmos_damage = 5
	gold_core_spawnable = HOSTILE_SPAWN
	/// Resting sprite for deathclaw variants with a sheath animation.
	var/sheathed_icon_state
	/// Aroused sprite for deathclaw variants with a sheath animation.
	var/aroused_icon_state

/mob/living/basic/deathclaw/Initialize(mapload)
	. = ..()

/mob/living/basic/deathclaw/set_arousal(amount)
	. = ..()
	update_arousal_icon_state()

/// Keeps the living icon in sync so revival and other appearance refreshes preserve the sheath state.
/mob/living/basic/deathclaw/proc/update_arousal_icon_state()
	if(!sheathed_icon_state || !aroused_icon_state || stat == DEAD)
		return
	var/desired_icon_state = arousal > AROUSAL_MINIMUM ? aroused_icon_state : sheathed_icon_state
	if(icon_living == desired_icon_state)
		return
	icon_living = desired_icon_state
	icon_state = desired_icon_state
	if(arousal > AROUSAL_MINIMUM)
		visible_message(span_lewd("[src]'s cock unsheathes."))
	else
		visible_message(span_lewd("[src]'s cock retracts into its sheath."))

/mob/living/basic/deathclaw/hostile
	icon_state = "newclaw"
	icon_living = "newclaw"
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile
	sheathed_icon_state = "newclaw"
	aroused_icon_state = "newclaw_cocked"
	simulated_genitals = list(
		ORGAN_SLOT_PENIS = TRUE,
		ORGAN_SLOT_ANUS = TRUE
	)

/mob/living/basic/deathclaw/hostile/alphaclaw
	name = "Alpha Funclaw"
	icon_state = "alphaclaw"
	icon_living = "alphaclaw"
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile_obstacles
	sheathed_icon_state = "alphaclaw"
	aroused_icon_state = "alphaclaw_cocked"

/mob/living/basic/deathclaw/hostile/death()
	..()
	gib()

/mob/living/basic/deathclaw/funclaw/
	name = "Docile Deathclaw"
	icon_state = "newclaw"
	icon_living = "newclaw"
	sheathed_icon_state = "newclaw"
	aroused_icon_state = "newclaw_cocked"
	simulated_genitals = list(
		ORGAN_SLOT_PENIS = TRUE,
		ORGAN_SLOT_ANUS = TRUE
	)
	gold_core_spawnable = FRIENDLY_SPAWN

/mob/living/basic/deathclaw/funclaw/femclaw
	icon_state = "femclaw"
	icon_living = "femclaw"
	gender = FEMALE
	name = "Docile Breasted Funclaw"
	desc = "She's large and in charge."
	maxHealth = 400
	health = 400
	armour_penetration = 45
	sheathed_icon_state = null
	aroused_icon_state = null
	simulated_genitals = list(
		ORGAN_SLOT_PENIS = FALSE,
		ORGAN_SLOT_ANUS = TRUE,
		ORGAN_SLOT_VAGINA = TRUE,
		ORGAN_SLOT_BREASTS = TRUE
	)

/mob/living/basic/deathclaw/funclaw/femclaw/mommyclaw
	icon_state = "mommyclaw"
	icon_living = "mommyclaw"
	desc = "A machine that turns her victim's pelv<b>is</b> into pelv<b>was</b>."
	name = "Mommy Funclaw"
	maxHealth = 1000
	health = 1000
	obj_damage = 145
	armour_penetration = 30
	melee_damage_lower = 40
	melee_damage_upper = 40
