#define WENDIGO_SCREAM_COOLDOWN (10 SECONDS)
#define WENDIGO_STOMP_COOLDOWN (8 SECONDS)

/mob/living/basic/wendigo
	name = "Wendigo"
	desc = "A terrifying, emaciated monstrosity of ice and hunger. Its very presence chills the blood."
	icon = 'icons/mob/simple/icemoon/icemoon_monsters.dmi'
	icon_state = "demonic_miner" // Fixed invisible icon
	icon_living = "demonic_miner"
	icon_dead = "demonic_miner_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	maxHealth = 2500
	health = 2500
	speed = 2
	melee_damage_lower = 40
	melee_damage_upper = 40
	armour_penetration = 40
	obj_damage = 80
	attack_verb_continuous = "mauls"
	attack_verb_simple = "maul"
	attack_sound = 'sound/items/weapons/bite.ogg'
	faction = list("wendigo")
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile_obstacles
	gold_core_spawnable = HOSTILE_SPAWN
	butcher_results = list(/obj/item/reagent_containers/food/drinks/bottle/wendigo_blood = 1,
							/obj/item/stack/sheet/animalhide = 4,
							/obj/item/stack/sheet/bone = 8)

	var/next_stomp = 0
	var/next_scream = 0

/mob/living/basic/wendigo/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SNOWSTORM_IMMUNE, INNATE_TRAIT)
	var/datum/action/cooldown/mob_cooldown/charge/basic_charge/charge = new(src)
	charge.Grant(src)
	ai_controller.set_blackboard_key(BB_GENERIC_ACTION, charge)

/mob/living/basic/wendigo/death()
	playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE, falloff_distance = 10) // Placeholder
	..()
	gib()

// We hook into melee_attack to randomly trigger abilities since building complex AI behaviors from scratch
// can be verbose. This is a common pattern for simple bosses.
/mob/living/basic/wendigo/melee_attack(atom/target, list/modifiers, ignore_cooldown)
	. = ..()
	if(.) // Attack succeeded
		if(world.time > next_scream && prob(20))
			do_scream()
		else if(world.time > next_stomp && prob(30))
			do_stomp()

/mob/living/basic/wendigo/proc/do_scream()
	visible_message(span_warning("[src] lets out a blood-curdling scream!"))
	playsound(src, 'sound/mobs/humanoids/human/scream/malescream_1.ogg', 100, TRUE)
	for(var/mob/living/M in oview(7, src))
		if(M.stat != DEAD && !HAS_TRAIT(M, TRAIT_DEAF))
			to_chat(M, span_userdanger("The horrific sound disorients you!"))
	next_scream = world.time + WENDIGO_SCREAM_COOLDOWN

/mob/living/basic/wendigo/proc/do_stomp()
	visible_message(span_warning("[src] stomps the ground with earth-shattering force!"))
	playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
	for(var/mob/living/M in oview(3, src))
		if(M.stat != DEAD)
			var/throwtarget = get_edge_target_turf(src, get_dir(src, M))
			M.throw_at(throwtarget, 4, 2, src)
			M.apply_damage(15, BRUTE)
			M.Knockdown(40)
			to_chat(M, span_userdanger("The shockwave knocks you off your feet!"))
	next_stomp = world.time + WENDIGO_STOMP_COOLDOWN
