/// Armored roaches opt into the normal armor datum used by their sealed MODsuits.
/// Basic mobs otherwise return zero projectile armor, so both hooks are needed.
/mob/living/basic/cockroach
	var/responsory_armor_enabled = FALSE

/mob/living/basic/cockroach/getarmor(def_zone, type)
	if(!responsory_armor_enabled || isnull(type))
		return ..()
	return get_armor_rating(type)

/mob/living/basic/cockroach/check_projectile_armor(def_zone, obj/projectile/impacting_projectile, is_silent)
	if(!responsory_armor_enabled)
		return ..()
	return run_armor_check(def_zone, impacting_projectile.armor_flag, "", "", impacting_projectile.armour_penetration, "", is_silent, impacting_projectile.weak_against_armour)

/// Called before parent initialization so no atmosphere/temperature elements are installed.
/// SPACEWALK supplies fuel-free zero-G propulsion without changing movement on floors.
/mob/living/basic/cockroach/proc/enable_modsuit_space_support()
	habitable_atmos = null
	unsuitable_atmos_damage = 0
	minimum_survivable_temperature = 0
	maximum_survivable_temperature = INFINITY
	unsuitable_cold_damage = 0
	unsuitable_heat_damage = 0
	pressure_resistance = 200
	add_traits(list(TRAIT_SPACEWALK, TRAIT_FREE_HYPERSPACE_MOVEMENT, TRAIT_RESISTCOLD), INNATE_TRAIT)

/// A sewer-shaped roach in responsory colors with a miniature Hyeseong rifle.
/mob/living/basic/cockroach/laseroach/responsoroach
	name = "responsoroach"
	desc = "A cockroach in the colors of a responsory MODsuit, carrying a tiny Hyeseong modular laser rifle."
	icon = 'modular_zzplurt/icons/mob/living/basic/vermin/cockroach/responsoroach.dmi'
	icon_state = "responsoroach"
	icon_living = "responsoroach"
	icon_dead = "responsoroach_dead"
	health = 15
	maxHealth = 15
	armor_type = /datum/armor/mod_theme_responsory
	responsory_armor_enabled = TRUE
	laser_projectile_type = /obj/projectile/beam/laser/hellfire
	laser_burst_shots = 3
	laser_burst_interval = 0.2 SECONDS
	ranged_cooldown = 2 SECONDS
	minion_path = null

/mob/living/basic/cockroach/laseroach/responsoroach/Initialize(mapload)
	enable_modsuit_space_support()
	return ..()

/// No gun component or ranged AI is installed on the unarmed subtype.
/mob/living/basic/cockroach/laseroach/responsoroach/unarmed
	name = "unarmed responsoroach"
	desc = "An armored cockroach in the colors of a responsory MODsuit. It appears to have misplaced its rifle."
	icon_state = "responsoroach_unarmed"
	icon_living = "responsoroach_unarmed"
	icon_dead = "responsoroach_unarmed_dead"
	laser_attacks_enabled = FALSE
	ai_controller = /datum/ai_controller/basic_controller/cockroach/aggro
	melee_damage_lower = 2
	melee_damage_upper = 4
	obj_damage = 5
	melee_attack_cooldown = 0.8 SECONDS

/mob/living/basic/cockroach/laseroach/responsoroach/commander
	name = "commander responsoroach"
	desc = "A blue-accented responsoroach carrying a tiny Hyeseong rifle. It seems to be in charge."
	icon_state = "responsoroach_commander"
	icon_living = "responsoroach_commander"
	icon_dead = "responsoroach_commander_dead"

/mob/living/basic/cockroach/laseroach/responsoroach/security
	name = "security responsoroach"
	desc = "A red-accented responsoroach carrying a tiny Hyeseong rifle."
	icon_state = "responsoroach_security"
	icon_living = "responsoroach_security"
	icon_dead = "responsoroach_security_dead"

/mob/living/basic/cockroach/laseroach/responsoroach/medic
	name = "medic responsoroach"
	desc = "A pale-accented responsoroach carrying a tiny Hyeseong rifle. Its treatment plan appears questionable."
	icon_state = "responsoroach_medic"
	icon_living = "responsoroach_medic"
	icon_dead = "responsoroach_medic_dead"

/mob/living/basic/cockroach/laseroach/responsoroach/engineer
	name = "engineer responsoroach"
	desc = "A yellow-accented responsoroach carrying a tiny Hyeseong rifle."
	icon_state = "responsoroach_engineer"
	icon_living = "responsoroach_engineer"
	icon_dead = "responsoroach_engineer_dead"

/mob/living/basic/cockroach/laseroach/responsoroach/janitor
	name = "janitor responsoroach"
	desc = "A purple-accented responsoroach carrying a tiny Hyeseong rifle. Pest control has taken a strange turn."
	icon_state = "responsoroach_janitor"
	icon_living = "responsoroach_janitor"
	icon_dead = "responsoroach_janitor_dead"

/mob/living/basic/cockroach/laseroach/responsoroach/clown
	name = "clown responsoroach"
	desc = "A pink-accented responsoroach carrying a tiny Hyeseong rifle. Honk."
	icon_state = "responsoroach_clown"
	icon_living = "responsoroach_clown"
	icon_dead = "responsoroach_clown_dead"

/// Inherit the real hauberoach's melee, caltrops, and anti-squashing spike callback.
/// Its sprite uses the unarmed responsoroach body plus the original hauberoach spike.
/mob/living/basic/cockroach/hauberoach/responsoroach
	name = "hauberesponsoroach"
	desc = "A responsory-colored cockroach with a tiny spiked helmet. Mind your step."
	icon = 'modular_zzplurt/icons/mob/living/basic/vermin/cockroach/responsoroach.dmi'
	icon_state = "hauberesponsoroach"
	icon_living = "hauberesponsoroach"
	icon_dead = "hauberesponsoroach_dead"
	health = 15
	maxHealth = 15
	armor_type = /datum/armor/mod_theme_responsory
	responsory_armor_enabled = TRUE
	minion_path = null

/mob/living/basic/cockroach/hauberoach/responsoroach/Initialize(mapload)
	enable_modsuit_space_support()
	return ..()
