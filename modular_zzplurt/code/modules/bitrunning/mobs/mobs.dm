/mob/living/basic/construct/juggernaut/angelic/bitrunning
	maxHealth = 300
	health = 300
	obj_damage = 40
	move_force = MOVE_FORCE_VERY_STRONG
	faction = list(FACTION_NEUTRAL)
	construct_spells = list(
		/datum/action/cooldown/spell/basic_projectile/juggernaut/bitrunning,
		/datum/action/cooldown/spell/forcewall/cult/bitrunning,
		/datum/action/cooldown/spell/conjure/cult_wall,
	)
	smashes_walls = FALSE //Added via Initialize() instead

/mob/living/basic/construct/juggernaut/angelic/bitrunning/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/wall_tearer, allow_reinforced = TRUE)

/mob/living/basic/construct/wraith/angelic/bitrunning
	maxHealth = 150
	health = 150
	faction = list(FACTION_NEUTRAL)
	construct_spells = list(
		/datum/action/cooldown/mob_cooldown/sneak/bitrunning,
		/datum/action/cooldown/mob_cooldown/dash,
		/datum/action/cooldown/spell/aoe/magic_missile/lesser,
	)

/datum/action/cooldown/spell/basic_projectile/juggernaut/bitrunning
	name = "Tweaked Gauntlet Echo"
	cooldown_time = 15 SECONDS

/datum/action/cooldown/spell/forcewall/cult/bitrunning
	name = "Tweaked Shield"
	cooldown_time = 10 SECONDS

/datum/action/cooldown/mob_cooldown/sneak/bitrunning
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "deploy_box"
	sneak_alpha = 50

/mob/living/basic/tree/palm
	name = "palm tree"
	desc = "A tree straight from the tropics."
	icon = 'icons/obj/fluff/beach2.dmi'
	icon_state = "palm1"
	icon_state = "palm1"
	icon_living = "palm1"
	icon_dead = "palm1"
	icon_gib = "palm1"
	health_doll_icon = "palm1"
	faction = list(FACTION_NEUTRAL)
	maxHealth = 100
	health = 100
	paralyze_prob = 0
	paralyze_value = 0
	anger_boost = 0

/mob/living/basic/mimic/crate/minor_illusion
	faction = list(FACTION_NEUTRAL)
	speed = 1
	maxHealth = 100
	health = 100

/mob/living/basic/mimic/watermelon
	name = "watermelon"
	desc = "It's full of watery goodness. <br>\
	This one has been trained to become a competition-grade racer."
	icon = 'icons/obj/service/hydroponics/harvest.dmi'
	icon_state = "watermelon"
	icon_state = "watermelon"
	icon_living = "watermelon"
	icon_dead = "watermelon"
	icon_gib = "watermelon"
	health_doll_icon = "watermelon"
	faction = list(FACTION_NEUTRAL)
	attack_verb_simple = "collide with"
	attack_verb_continuous = "collides with"
	melee_damage_lower = 5
	melee_damage_upper = 9
	obj_damage = 5
	speed = 0
	maxHealth = 50
	health = 50

/mob/living/basic/mimic/watermelon/Initialize(mapload)
	. = ..()
	var/static/list/loot = list(
		/obj/effect/gibspawner/generic,
		/obj/item/food/watermelonslice,
	)
	AddElement(/datum/element/death_drops, loot)
