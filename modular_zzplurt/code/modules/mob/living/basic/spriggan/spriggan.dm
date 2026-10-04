//defines for the spriggan abilities
#define SPRIGGAN_TELEPORT_ABILITY "spriggan_teleport"
#define SPRIGGAN_SIGHT_ABILITY "spriggan_sight"
#define SPRIGGAN_LIGHT_ABILITY "spriggan_light"

/// A random ghost role that can be spawned; can float around and heal people.
/mob/living/basic/spriggan

	name = "Wandering Dryad"
	desc = "A creature made up of warped vinery and petrified oak. It possesses a form comparable to that of a female humanoid, and between the openings in its wooden exterior is an arcane glow of some sort."
	icon = 'modular_zzplurt/icons/mobs/spriggan.dmi'
	icon_state = "spriggan"
	icon_living = "spriggan"
	icon_dead = "spriggan_dead"
	icon_gib = "syndicate_gib"
	gender = FEMALE
	status_flags = CANPUSH
	butcher_results = list(
		/obj/item/stack/sheet/mineral/wood
)

	pixel_x = -15
	base_pixel_x = -15
	maptext_height = 64
	maptext_width = 64

	mob_biotypes = MOB_SPECIAL
	maxHealth = 100
	health = 100
	obj_damage = 35
	melee_damage_upper = 10
	melee_damage_lower = 10
	attack_vis_effect = ATTACK_EFFECT_CLAW
	melee_attack_cooldown = 1.2 SECONDS
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	death_message = "quickly withers and crumples over, dead."
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	combat_mode = TRUE
	damage_coeff = list(BRUTE = 0.7, BURN = 1, TOX = 0.7, STAMINA = 0, OXY = 0)

	basic_mob_flags = FLAMMABLE_MOB
	faction = list(FACTION_CARP)
	gold_core_spawnable = FRIENDLY_SPAWN

	habitable_atmos = null
	minimum_survivable_temperature = 0
	maximum_survivable_temperature = 1500
	unsuitable_cold_damage = 0
	unsuitable_heat_damage = 0
	unsuitable_atmos_damage = FALSE
	pressure_resistance = 200

	hud_type = /datum/hud/dextrous

	// variable from the guardian support type, used to determine how much healing is done per hit
	var/healing_amount = 5

	// the color of the overlay while regenerating health
	var/regenerate_colour = LIGHT_COLOR_ELECTRIC_GREEN

	var/heal_sound = 'sound/items/weapons/shrink_hit.ogg'

	var/poll_ghosts = FALSE

/mob/living/basic/spriggan/Initialize(mapload)
	ADD_TRAIT(src, TRAIT_FREE_HYPERSPACE_MOVEMENT, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)
	. = ..()
	ADD_TRAIT(src, TRAIT_RESISTCOLD, INNATE_TRAIT)

	AddComponent(/datum/component/ghost_direct_control,\
		poll_candidates = FALSE,\
		role_name = "the Wandering Dryad",\
		assumed_control_message = "You are the last of your kind. Roam the Cosmos in search of purpose. Aid and try to understand other lifeforms.",\
	)

//lets the dryan teleport around
	var/static/list/innate_actions = list(
		/datum/action/cooldown/mob_cooldown/spriggan_teleport = SPRIGGAN_TELEPORT_ABILITY,
		/datum/action/cooldown/mob_cooldown/spriggan_sight = SPRIGGAN_SIGHT_ABILITY,
		/datum/action/cooldown/mob_cooldown/spriggan_light = SPRIGGAN_LIGHT_ABILITY,
	)
	grant_actions_by_list(innate_actions)

//lets it have hands
	AddElement(/datum/element/dextrous, hud_type = hud_type)
//cant use guns or anything though
	AddElement(/datum/element/pick_and_drop_only)

	// Another altered component from the voidwalker mob, it lets it heal 1 burn/brute per second anywhere
	AddComponent(/datum/component/regenerator, brute_per_second = 1, burn_per_second = 1, outline_colour = regenerate_colour,)

	//keeps it without gravity at all times, and allows it to float around
	AddElement(/datum/element/simple_flying)
	//healing component from the Guardian/Support/Holoparasite code, lets it heal people with a right click
	AddComponent(\
		/datum/component/healing_touch,\
		heal_brute = healing_amount,\
		heal_burn = healing_amount,\
		heal_tox = healing_amount,\
		heal_oxy = healing_amount,\
		heal_time = 0,\
		action_text = "",\
		complete_text = "",\
		required_modifier = RIGHT_CLICK,\
		after_healed = CALLBACK(src, PROC_REF(after_healed)),\
	)

	ADD_TRAIT(src, TRAIT_MEDICAL_HUD, INNATE_TRAIT)
	update_appearance(UPDATE_OVERLAYS)

/mob/living/basic/spriggan/death(gibbed)
	. = ..()
	if(.)
		update_appearance(UPDATE_OVERLAYS)

/mob/living/basic/spriggan/update_overlays() //adds its sparkly overlays on spawn and deletes them on death
	. = ..()
	if(stat == DEAD)
		return

	. += mutable_appearance(icon, "spriggan-glow")
	. += mutable_appearance(icon, "spriggan-glow-particles")

/// Called after we heal someone, show some visuals
/mob/living/basic/spriggan/proc/after_healed(mob/living/healed)
	do_attack_animation(healed, ATTACK_EFFECT_PUNCH)
	healed.visible_message(
		message = span_notice("[src] heals [healed]!"),
		self_message = span_userdanger("[src] heals you!"),
		vision_distance = COMBAT_MESSAGE_RANGE,
		ignored_mobs = src,
	)
	to_chat(src, span_notice("You heal [healed]!"))
	playsound(healed, heal_sound, 50, TRUE, TRUE, frequency = 1) //-1 frequency plays the sound in reverse, also from the Guardian/Support code

// adds bloodsplatter when attacked
/mob/living/basic/chryssalid/create_splatter(splatter_dir)
	new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(src), splatter_dir, BLOOD_COLOR_XENO)

#undef SPRIGGAN_TELEPORT_ABILITY
#undef SPRIGGAN_SIGHT_ABILITY
#undef SPRIGGAN_LIGHT_ABILITY
