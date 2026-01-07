/// Energistics school. 6 spells
/// Spark - creates sparks at the chosen location
/// Discharge - grants mana in exchange for discharging a battery cell/APC
/// Laser - shoots out a concentrated, though still weak photon beam.
/// Disrupt - creates an EMP blast with extremely small radius.
/// Elecrocute - grants the shock touch mutation
/// Freeze - encapsulates the target in ice for a short amount of time.

// Add the energistics school
/mob/living/carbon/human/proc/try_add_energistics_school(tier = 0, additional_school = 0)
	if(tier >= 0)
		var/datum/action/new_action = new /datum/action/cooldown/spell/touch/psyonic/psyonic_discharge(src.mind || src, tier, additional_school)
		new_action.Grant(src)
		var/datum/action/new_action2 = new /datum/action/cooldown/spell/pointed/psyonic/psyonic_spark(src.mind || src, tier, additional_school)
		new_action2.Grant(src)
	if(tier >= 1)
		var/datum/action/new_action = new /datum/action/cooldown/spell/basic_projectile/psyonic_laser(src.mind || src, tier, additional_school)
		new_action.Grant(src)
	if(tier >= 2)
		var/datum/action/new_action = new /datum/action/cooldown/spell/touch/psyonic/psyonic_emp(src.mind || src, tier, additional_school)
		new_action.Grant(src)
	if(tier >= 3)
		var/datum/action/new_action = new /datum/action/cooldown/spell/psyonic/psionic_electrocute(src.mind || src, tier, additional_school)
		new_action.Grant(src)
	if(tier >= 4)
		var/datum/action/new_action = new /datum/action/cooldown/spell/pointed/projectile/psyonic/psyonic_freeze(src.mind || src)
		new_action.Grant(src)

// Discharge APC and battery cells in exchange for mana
/datum/action/cooldown/spell/touch/psyonic/psyonic_discharge
	name = "Psyonic Discharge"
	desc = "Try to discharge battery and convert electricity into raw psyonic energy."
	button_icon = 'modular_skyrat/modules/aesthetics/cells/cell.dmi'
	button_icon_state = "icell"
	cooldown_time = 30 SECONDS
	mana_cost = 0
	stamina_cost = 15
	hand_path = /obj/item/melee/touch_attack/psyonic_mending
	draw_message = span_notice("You ready your hand to discharge an energy source.")
	drop_message = span_notice("You lower your hand.")
	can_cast_on_self = FALSE

/datum/action/cooldown/spell/touch/psyonic/psyonic_discharge/is_valid_target(atom/cast_on)
	return isatom(cast_on)

/datum/action/cooldown/spell/touch/psyonic/psyonic_discharge/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/mendicant)
	if(HAS_TRAIT(mendicant, TRAIT_MINDSHIELD)) // Womp womp
		to_chat(mendicant, span_warning("As soon as you touch [victim], your energy dissipates without a trace. Mindshield implant messes up your concentration."))
		return FALSE
	if(istype(victim, /obj/item/stock_parts/power_store) || istype(victim, /obj/machinery/power/apc))
		owner.visible_message(span_warning("[owner] presses their hands against [victim]."),
							  span_notice("You press your hands against [victim]."),
							  blind_message = span_hear("You hear electrical crackling."))
		if(do_after(mendicant, 2.5 SECONDS, victim, IGNORE_SLOWDOWNS, TRUE))
			var/datum/quirk/psyonic/quirk_holder = mendicant.get_quirk(/datum/quirk/psyonic)
			if(!quirk_holder)
				return FALSE
			if(istype(victim, /obj/item/stock_parts/power_store))
				var/obj/item/stock_parts/power_store/batt = victim
				var/to_charge = (batt.charge / STANDARD_CELL_VALUE)
				batt.use(batt.charge(), TRUE)
				quirk_holder.mana_level = clamp(quirk_holder.mana_level + to_charge, 0, quirk_holder.max_mana)
			else if(istype(victim, /obj/machinery/power/apc))
				var/obj/machinery/power/apc/target_apc = victim
				var/obj/item/stock_parts/power_store/batt = target_apc.cell
				if(!batt)
					to_chat(owner, span_notice("There is no battery in this APC."))
					return FALSE
				var/to_charge = (batt.charge() / (STANDARD_BATTERY_CHARGE/10))
				batt.use(batt.charge(), TRUE)
				quirk_holder.mana_level = clamp(quirk_holder.mana_level + to_charge, 0, quirk_holder.max_mana)
			else
				to_chat(owner, span_notice("You fail to discharge energy."))
		return TRUE
	else
		return FALSE

// Creates sparks at chosen location
/datum/action/cooldown/spell/pointed/psyonic/psyonic_spark
	name = "Psyonic Spark"
	desc = "Cause some sparks to appear at a place of your choice."
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "blessed"
	cooldown_time = 1 SECONDS
	mana_cost = 10
	active_msg = "You prepare to cast sparks..."

/datum/action/cooldown/spell/pointed/psyonic/psyonic_spark/is_valid_target(atom/cast_on)
	if(!isturf(cast_on))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/pointed/psyonic/psyonic_spark/cast(turf/cast_on)
	. = ..()
	var/mob/living/carbon/human/caster = owner
	caster.emote_snap()
	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(5, 1, cast_on)
	sparks.attach(cast_on)
	sparks.start()
	drain_mana()
	return TRUE

// Shoots out a photon beam, essentially acts like a flash
/datum/action/cooldown/spell/basic_projectile/psyonic_laser
	name = "Photon Laser"
	desc = "Channels psyonic energy into a weak concentrated photon beam."
	button_icon = 'icons/obj/weapons/guns/projectiles.dmi'
	button_icon_state = "solarflare"
	cooldown_time = 0 SECONDS
	spell_requirements = NONE
	mana_cost = 10
	projectile_type = /obj/projectile/energy/photon

/datum/action/cooldown/spell/basic_projectile/psyonic_laser/cast(atom/cast_on)
	var/mob/living/carbon/human/caster = owner
	var/datum/quirk/psyonic/quirk_holder = caster.get_quirk(/datum/quirk/psyonic)
	if(!(quirk_holder && (quirk_holder.mana_level - mana_cost) >= 0))
		return FALSE
	else
		quirk_holder.mana_level -= mana_cost
	..()

// Creates EMP on hit location
/datum/action/cooldown/spell/touch/psyonic/psyonic_emp
	name = "Psyonic EMP"
	desc = "Cause a small, localized EMP blast."
	button_icon = 'icons/obj/weapons/grenade.dmi'
	button_icon_state = "emp"
	cooldown_time = 15 SECONDS
	mana_cost = 40
	stamina_cost = 40
	hand_path = /obj/item/melee/touch_attack/psyonic_mending
	draw_message = span_notice("You ready your hand to cause an EMP.")
	drop_message = span_notice("You lower your hand.")
	can_cast_on_self = TRUE

/datum/action/cooldown/spell/touch/psyonic/psyonic_emp/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/mendicant)
	if(isatom(victim))
		empulse(victim, 1, cast_power/2)
		drain_mana()
		return TRUE
	else
		return FALSE

// grants Shock Touch mutation
/datum/action/cooldown/spell/psyonic/psionic_electrocute
	name = "Psyonic Shock Touch"
	desc = "Force yourself to receive the Shock Touch mutation."
	cooldown_time = 60 SECONDS
	mana_cost = 60
	stamina_cost = 60

/datum/action/cooldown/spell/psyonic/psionic_electrocute/is_valid_target(atom/cast_on)
	return !issynthetic(cast_on)

/datum/action/cooldown/spell/psyonic/psionic_electrocute/cast(mob/living/cast_on)
	. = ..()
	if(!ishuman(cast_on))
		return FALSE
	var/mob/living/carbon/human/to_mutate = cast_on
	if(!to_mutate.can_mutate())
		return FALSE
	to_mutate.dna.add_mutation(/datum/mutation/shock, MUTATION_SOURCE_MUTATOR)
	drain_mana()
	return TRUE

// shoots out the watches projectile, freezing target. Costs nearly the entire mana pool
/datum/action/cooldown/spell/pointed/projectile/psyonic/psyonic_freeze
	name = "Psyonic Freeze"
	desc = "Shoot out a freezing shard at the target, encasing them in an ice prison."
	button_icon = 'icons/effects/freeze.dmi'
	button_icon_state = "ice_cube"
	cooldown_time = 1 SECONDS
	mana_cost = 80
	cast_range = 9
	active_msg = "You prepare to shoot the ice shard..."
	deactive_msg = "You relax."
	projectile_type = /obj/projectile/temp/watcher/psyonic_freeze

/datum/action/cooldown/spell/pointed/projectile/psyonic/psyonic_freeze/is_valid_target(atom/cast_on)
	if(!isliving(cast_on))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/pointed/projectile/psyonic/psyonic_freeze/cast(mob/living/cast_on)
	drain_mana()
	. = ..()
	return TRUE

// Separate type, as the original ice_wing doesn't freeze the target, even though it should
/obj/projectile/temp/watcher/psyonic_freeze
	name = "freezing blast"
	damage = 0 // No damage, only freezes

/obj/projectile/temp/watcher/psyonic_freeze/apply_status(mob/living/target)
	if(HAS_TRAIT(target, TRAIT_RESISTCOLD)) // In here the original ice_wing has an extra !
		return
	target.apply_status_effect(/datum/status_effect/freon/watcher/psyonic_freeze)

/datum/status_effect/freon/watcher/psyonic_freeze
	duration = 40 // deciseconds
	can_melt = TRUE
