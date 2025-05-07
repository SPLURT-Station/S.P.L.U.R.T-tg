/mob/living/basic/chryssalid
	name = "chryssalid"
	desc = "Screech!"
	icon = 'modular_zzplurt/icons/mobs/chryssalid.dmi'
	pixel_x = -16
	base_pixel_x = -16
	icon_state = "chryssalid"
	icon_living = "chryssalid"
	icon_dead = "chryssalid_dead"
	gender = NEUTER
	status_flags = CANPUSH
	butcher_results = list(
		/obj/item/food/meat/slab/xeno = 4,
		/obj/item/stack/sheet/animalhide/xeno = 1,
	)

	maxHealth = 125
	health = 125
	bubble_icon = "alien"
	combat_mode = TRUE
	faction = list(ROLE_ALIEN)

	// Going for orange here
	lighting_cutoff_red = 65
	lighting_cutoff_green = 25
	lighting_cutoff_blue = 5
	unique_name = TRUE

	basic_mob_flags = FLAMMABLE_MOB
	obj_damage = 75
	bare_wound_bonus = 15

	speak_emote = list("screeches")
	speed = -0.2
	melee_attack_cooldown = 1 SECONDS
	gold_core_spawnable = HOSTILE_SPAWN
	melee_damage_lower = 37
	melee_damage_upper = 37
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"

	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW
	death_sound = 'sound/mobs/non-humanoids/hiss/hiss6.ogg'
	death_message = "lets out a waning guttural screech, green blood bubbling from its maw..."

	habitable_atmos = null
	unsuitable_atmos_damage = FALSE
	unsuitable_heat_damage = 20

	ai_controller = /datum/ai_controller/basic_controller/alien

	///List of loot items to drop when deleted, if this is set then we apply DEL_ON_DEATH
	var/list/loot

/mob/living/basic/chryssalid/Initialize(mapload)
	. = ..()
	if(length(loot))
		basic_mob_flags |= DEL_ON_DEATH
		loot = string_list(loot)
		AddElement(/datum/element/death_drops, loot)
	AddElement(/datum/element/footstep, footstep_type = FOOTSTEP_MOB_CLAW)
	AddComponent(/datum/component/seethrough_mob)
	add_traits(list(TRAIT_VENTCRAWLER_ALWAYS), INNATE_TRAIT)

/mob/living/basic/chryssalid/create_splatter(splatter_dir)
	new /obj/effect/temp_visual/dir_setting/bloodsplatter/xenosplatter(get_turf(src), splatter_dir)
