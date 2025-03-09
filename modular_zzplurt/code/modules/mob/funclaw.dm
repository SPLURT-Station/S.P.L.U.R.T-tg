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
	//Someone other than me is gonna have to give the mobs lewd stuff. -Evan
	/*
	var/charging = FALSE
	var/has_penis = FALSE
	var/has_butt = FALSE
	var/has_breasts = FALSE
	var/has_vagina = FALSE
	*/

/mob/living/basic/deathclaw/Initialize(mapload)
	. = ..()

/mob/living/basic/deathclaw/hostile
	icon_state = "newclaw"
	ai_controller = /datum/ai_controller/basic_controller/simple_hostile
	/*
	var/base_state = "newclaw"
	var/cock_state = "newclaw_cocked"
	var/cock_shown = FALSE
	*/

/mob/living/basic/deathclaw/hostile/alphaclaw
	name = "Alpha Funclaw"
	icon_state = "alphaclaw"
	ai_controller = /datum/ai_controller/basic_controller/simple_hostile_obstacles
	//base_state = "alphaclaw"
	//cock_state = "alphaclaw_cocked"

/mob/living/basic/deathclaw/hostile/death()
	..()
	gib()

/*
/mob/living/basic/hostile/deathclaw/funclaw/gentle/newclaw/proc/show_cock()
	if (cock_shown)
		return
	cock_shown = TRUE
	icon_state = cock_state
	visible_message("<font color=purple><b>\The [src]</b>'s cock unsheathes.</font>")

/mob/living/basic/hostile/deathclaw/funclaw/gentle/newclaw/proc/hide_cock()
	if (!cock_shown)
		return
	cock_shown = FALSE
	icon_state = base_state
	visible_message("<font color=purple><b>\The [src]</b>'s cock slowly retracts back into its sheath.</font>")

/mob/living/basic/hostile/deathclaw/funclaw/gentle/newclaw/handle_post_sex(amount, orifice, mob/living/partner)
	..()
	if (lust > 0)
		show_cock()
	else
		hide_cock()
*/
/mob/living/basic/deathclaw/funclaw/
	name = "Docile Deathclaw"
	simulated_genitals = list(
		ORGAN_SLOT_PENIS = TRUE,
		ORGAN_SLOT_ANUS = TRUE
	)
	gold_core_spawnable = FRIENDLY_SPAWN

/mob/living/basic/deathclaw/funclaw/femclaw
	icon_state = "femclaw"
	gender = FEMALE
	name = "Docile Breasted Funclaw"
	desc = "She's large and in charge."
	maxHealth = 400
	health = 400
	armour_penetration = 45
	simulated_genitals = list(
		ORGAN_SLOT_PENIS = FALSE,
		ORGAN_SLOT_ANUS = TRUE,
		ORGAN_SLOT_VAGINA = TRUE,
		ORGAN_SLOT_BREASTS = TRUE
	)

/mob/living/basic/deathclaw/funclaw/femclaw/mommyclaw
	icon_state = "mommyclaw"
	desc = "A machine that turns her victim's pelv<b>is</b> into pelv<b>was</b>."
	name = "Mommy Funclaw"
	maxHealth = 1200
	health = 1200
	obj_damage = 145
	armour_penetration = 80
	melee_damage_lower = 80
	melee_damage_upper = 80
