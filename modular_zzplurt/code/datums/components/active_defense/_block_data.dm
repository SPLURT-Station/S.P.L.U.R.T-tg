/// Stores data related to active parrying and blocking mechanics.
/// !!! NOTE: INCOMPATIBLE WITH item.block_chance! !!!
/datum/active_defense_data
	////////// ACTIVE BLOCKING //////////
	/// The dirs of the attack we'll allow the block to happen at. Point of reference is north.
	var/allowed_block_dirs = NORTH_JUNCTION | NORTHEAST_JUNCTION | NORTHWEST_JUNCTION
	/// The traits we apply to the user when active blocking.
	var/list/block_traits = null

	/// Upper bound of damage block, anything above this will go right through.
	var/block_damage_limit = 80
	/// Amount of "free" damage blocking absorbs. Damage absorbed doesn't get converted into stamina.
	var/block_damage_absorption = 10
	/// Ratio of damage to allow through above absorption and below limit. Multiplied by damage to determine how much to let through. Lower is better.
	var/block_damage_multiplier = 0.5

	////////// ACTIVE PARRYING //////////
	/// The windup length of the parry.
	var/parry_windup
	/// The length of the
	var/parry_window_length




/*
	/////////// BLOCKING ////////////

	/// NOTE: FOR ATTACK_TYPE_DEFINE, you MUST wrap it in "[DEFINE_HERE]"! The defines are bitflags, and therefore, NUMBERS!

	/// See defines. Point of reference is someone facing north.
	var/can_block_directions = BLOCK_DIR_NORTH | BLOCK_DIR_NORTHEAST | BLOCK_DIR_NORTHWEST
	/// Attacks we can block
	var/can_block_attack_types = ALL
	/// Our slowdown added while blocking
	var/block_slowdown = 1
	/// Clickdelay added to user after block ends
	var/block_end_click_cd_add = 0
	/// Disallow attacking during block
	var/block_lock_attacking = TRUE
	/// Disallow sprinting during block
	var/block_lock_sprinting = FALSE
	/// The priority we get in [mob/do_run_block()] while we're being used to parry.
	var/block_active_priority = BLOCK_PRIORITY_ACTIVE_BLOCK
	/// Windup before we have our blocking active.
	var/block_start_delay = 5

	/// Amount of "free" damage blocking absorbs
	var/block_damage_absorption = 10
	/// Override absorption, list("[ATTACK_TYPE_DEFINE]" = absorption), see [block_damage_absorption]
	var/list/block_damage_absorption_override

	/// Ratio of damage to allow through above absorption and below limit. Multiplied by damage to determine how much to let through. Lower is better.
	var/block_damage_multiplier = 0.5
	/// Override damage overrun efficiency, list("[ATTACK_TYPE_DEFINE]" = absorption), see [block_damage_efficiency]
	var/list/block_damage_multiplier_override

	/// Upper bound of damage block, anything above this will go right through.
	var/block_damage_limit = 80
	/// Override upper bound of damage block, list("[ATTACK_TYPE_DEFINE]" = absorption), see [block_damage_limit]
	var/list/block_damage_limit_override

	/// The blocked variable of on_hit() on projectiles is impacted by this. Higher is better, 0 to 100, percentage.
	var/block_projectile_mitigation = 50

	/*
	 * NOTE: Overrides for attack types for most the block_stamina variables were removed,
	 * because at the time of writing nothing needed to use it. Add them if you need it,
	 * it should be pretty easy, just copy [active_block_damage_mitigation]
	 * for how to override with list.
	 */

	/// Default damage-to-stamina coefficient, higher is better. This is based on amount of damage BLOCKED, not initial damage, to prevent damage from "double dipping".
	var/block_stamina_efficiency = 2
	/// Override damage-to-stamina coefficient, see [block_efficiency], this should be list("[ATTACK_TYPE_DEFINE]" = coefficient_number)
	var/list/block_stamina_efficiency_override
	/// Ratio of stamina incurred by blocking that goes to the arm holding the object instead of the chest. Has no effect if this is not held in hand.
	var/block_stamina_limb_ratio = 0.5
	/// Ratio of stamina incurred by chest (so after [block_stamina_limb_ratio] runs) that is buffered.
	var/block_stamina_buffer_ratio = 1

	/// Stamina dealt directly via UseStaminaBuffer() per SECOND of block.
	var/block_stamina_cost_per_second = 1
	/// Prevent stamina buffer regeneration while block?
	var/block_no_stambuffer_regeneration = TRUE
	/// Prevent stamina regeneration while block?
	var/block_no_stamina_regeneration = FALSE

	/// Bitfield for attack types that we can block while down. This will work in any direction.
	var/block_resting_attack_types_anydir = ATTACK_TYPE_MELEE | ATTACK_TYPE_UNARMED | ATTACK_TYPE_TACKLE
	/// Bitfield for attack types that we can block while down but only in our normal directions.
	var/block_resting_attack_types_directional = ATTACK_TYPE_PROJECTILE | ATTACK_TYPE_THROWN
	/// Multiplier to stamina damage taken for attacks blocked while downed.
	var/block_resting_stamina_penalty_multiplier = 1.5
	/// Override list for multiplier to stamina damage taken for attacks blocked while down. list("[ATTACK_TYPE_DEFINE]" = multiplier_number)
	var/list/block_resting_stamina_penalty_multiplier_override

	/// Sounds for blocking
	var/list/block_sounds = list('sound/block_parry/block_metal1.ogg' = 1, 'sound/block_parry/block_metal1.ogg' = 1)

	// Autoblock
	// Other than for overrides, this mostly just reads from the above vars
	/// Can this item automatically block?
	var/block_automatic_enabled = TRUE
	/// Directions that you can autoblock in. Null to default to normal directions.
	var/block_automatic_directions = null
	/// Effectiveness multiplier for automated block. Only applies to efficiency, absorption and limits stay the same!
	var/block_automatic_mitigation_multiplier = 0.33
	/// Stamina cost multiplier for automated block
	var/block_automatic_stamina_multiplier = 1

	/////////// PARRYING ////////////
	/// Priority for [mob/do_run_block()] while we're being used to parry.
	//  None - Parry is always highest priority!
	/// Parry doesn't work if you aren't able to otherwise attack due to clickdelay
	var/parry_respect_clickdelay = FALSE
	/// Parry stamina cost
	var/parry_stamina_cost = 5
	/// Attack types we can block
	var/parry_attack_types = ALL
	/// Parry flags
	var/parry_flags = PARRY_DEFAULT_HANDLE_FEEDBACK

	/// Parry windup duration in deciseconds. 0 to this is windup, afterwards is main stage.
	var/parry_time_windup = 0
	/// Parry spindown duration in deciseconds. main stage end to this is the spindown stage, afterwards the parry fully ends.
	var/parry_time_spindown = 3
	/// Main parry window in deciseconds. This is between [parry_time_windup] and [parry_time_spindown]
	var/parry_time_active = 5
	// Visual overrides
	/// If set, overrides visual duration of windup
	var/parry_time_windup_visual_override
	/// If set, overrides visual duration of active period
	var/parry_time_active_visual_override
	/// If set, overrides visual duration of spindown
	var/parry_time_spindown_visual_override
	/// Perfect parry window in deciseconds from the start of the main window. 3 with main 5 = perfect on third decisecond of main window.
	var/parry_time_perfect = 2.5
	/// Time on both sides of perfect parry that still counts as part of the perfect window.
	var/parry_time_perfect_leeway = 1
	/// [parry_time_perfect_leeway] override for attack types, list("[ATTACK_TYPE_DEFINE]" = deciseconds)
	var/list/parry_time_perfect_leeway_override
	/// Parry "efficiency" falloff in percent per decisecond once perfect window is over.
	var/parry_imperfect_falloff_percent = 20
	/// [parry_imperfect_falloff_percent] override for attack types, list("[ATTACK_TYPE_DEFINE]" = deciseconds)
	var/list/parry_imperfect_falloff_percent_override
	/// Efficiency in percent on perfect parry.
	var/parry_efficiency_perfect = 120
	/// Override for attack types, list("[ATTACK_TYPE_DEFINE]" = perecntage) for perfect efficiency.
	var/parry_efficiency_perfect_override
	/// Parry effect data.
	var/list/parry_data = list(
		PARRY_COUNTERATTACK_MELEE_ATTACK_CHAIN = 1
		)
	/// Efficiency must be at least this to be considered successful
	var/parry_efficiency_considered_successful = 0.1
	/// Efficiency must be at least this to run automatic counterattack
	var/parry_efficiency_to_counterattack = INFINITY
	/// Maximum attacks to parry successfully or unsuccessfully (but not efficiency < 0) during active period, hitting this immediately ends the sequence.
	var/parry_max_attacks = INFINITY
	/// Visual icon state override for parrying
	var/parry_effect_icon_state = "parry_bm_hold"
	/// Parrying cooldown, separate of clickdelay. It must be this much deciseconds since their last parry for them to parry with this object.
	var/parry_cooldown = 0
	/// Parry start sound
	var/parry_start_sound = 'sound/block_parry/sfx-parry.ogg'
	/// Sounds for parrying
	var/list/parry_sounds = list('sound/block_parry/block_metal1.ogg' = 1, 'sound/block_parry/block_metal1.ogg' = 1)
	/// Stagger duration post-parry if you fail to parry an attack
	var/parry_failed_stagger_duration = 3.5 SECONDS
	/// Clickdelay duration post-parry if you fail to parry an attack
	var/parry_failed_clickcd_duration = 0 SECONDS
	/// Parry cooldown post-parry if failed. This is ADDED to parry_cooldown!!!
	var/parry_failed_cooldown_duration = 3.5 SECONDS

	// Advanced
	/// Flags added to return value
	var/perfect_parry_block_return_flags = NONE
	var/imperfect_parry_block_return_flags = NONE
	var/failed_parry_block_return_flags = NONE
	/// List appended to block return
	var/perfect_parry_block_return_list
	var/imperfect_parry_block_return_list
	var/failed_parry_block_return_list
	/// Allow multiple counterattacks per parry sequence. Bad idea.
	var/parry_allow_repeated_counterattacks = FALSE

	// Auto parry
	// Anything not specified like cooldowns/clickdelay respecting is pulled from above.
	/// Can this data automatically parry? This is off by default because this is something that requires thought to balance.
	var/parry_automatic_enabled = FALSE
	/// Hard autoparry cooldown
	var/autoparry_cooldown_absolute = 7.5 SECONDS
	/// Autoparry : Simulate a parry sequence starting at a certain tick, or simply simulate a single attack parry?
	var/autoparry_sequence_simulation = FALSE
	// Single attack simulation:
	/// Single attack autoparry - efficiency
	var/autoparry_single_efficiency = 75
	/// Single attack autoparry - efficiency overrides by attack type, see above
	var/list/autoparry_single_efficiency_override
	// Parry sequence simulation:
	/// Decisecond of sequence to start on. -1 to start to 0th tick of active parry window.
	var/autoparry_sequence_start_time = -1
	// Clickdelay/cooldown settings not included, as well as whether or not to lock attack/sprinting/etc. They will be pulled from the above.

	/// ADVANCED - Autoparry requirement for time since last moused over for a specific object
	var/autoparry_mouse_delay_maximum = 0.35 SECONDS
