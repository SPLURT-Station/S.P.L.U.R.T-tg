/mob/living/basic/white_wolf
	name = "white wolf"
	desc = "A beast that survives by feasting on weaker opponents, they're much stronger with numbers."
	icon = 'icons/mob/icemoon/icemoon_monsters.dmi'
	icon_state = "whitewolf"
	icon_living = "whitewolf"
	icon_dead = "whitewolf_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	friendly_verb_continuous = "howls at"
	friendly_verb_simple = "howl at"
	speak_emote = list("howls")
	speed = 5
	maxHealth = 130
	health = 130
	obj_damage = 15
	melee_damage_lower = 7.5
	melee_damage_upper = 7.5
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/items/weapons/bite.ogg'
	butcher_results = list(/obj/item/food/meat/slab/ = 2,
							/obj/item/stack/sheet/animalhide = 1)
	faction = list("white_wolf_pack")
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/basic/white_wolf/Initialize(mapload)
	. = ..()
	// To simulate the dodge_prob from the old simple_animal, we can use an evasion component if it exists,
	// but for now we'll stick to standard combat mechanics to match other basic mobs.
	// We use simple_hostile which inherently supports pack hunting via faction.

/mob/living/basic/white_wolf/death()
	playsound(src, 'sound/effects/splat.ogg', 100, TRUE)
	..()
	gib()

/mob/living/basic/white_wolf/pack_leader
	name = "Alpha White Wolf"
	desc = "The leader of the pack, larger and far more dangerous."
	maxHealth = 300
	health = 300
	speed = 4
	melee_damage_lower = 15
	melee_damage_upper = 20
	obj_damage = 30
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile_obstacles

/mob/living/basic/white_wolf/funwolf
	name = "Docile White Wolf"
	desc = "A beast that survives by feasting on weaker opponents. Its sheath is notably visible."
	ai_controller = /datum/ai_controller/basic_controller/
	gold_core_spawnable = FRIENDLY_SPAWN
	simulated_genitals = list(
		ORGAN_SLOT_PENIS = TRUE,
		ORGAN_SLOT_ANUS = TRUE
	)
