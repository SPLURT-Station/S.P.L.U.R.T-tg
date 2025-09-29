/datum/quirk/vacuum_resistance
	name = "Vacuum Adaptation"
	desc = "Your body is specially adapted to temporarily withstand cold zero-pressure environments.\
	You still need a source of breathable air, however."
	value = 8
	quirk_flags = QUIRK_HUMAN_ONLY | QUIRK_PROCESSES
	gain_text = span_notice("Your physique attunes to the silence of space.")
	lose_text = span_notice("Your physiology reverts as your space faring gifts lay dormant once more.")
	medical_record_text = "Patient's body has an adaptation increasing survivability in zero-pressure environments."
	mob_trait = TRAIT_RESISTCOLD
	hardcore_value = -6
	icon = FA_ICON_ROCKET
	mail_goodies = list (
		/obj/item/storage/box/emergency_spacesuit = 1
	)

/datum/quirk/vacuum_resistance/process(seconds_per_tick)
	var/mob/living/carbon/human/holder = quirk_holder

	var/turf/loc = holder.loc
	var/datum/gas_mixture/environment = loc.return_air()
	if(environment)
		var/pressure = environment.return_pressure()
		var/adjusted_pressure = holder.calculate_affecting_pressure(pressure)
		if(adjusted_pressure > HAZARD_LOW_PRESSURE)
			if(HAS_TRAIT(holder, TRAIT_VACUUM_RESISTANCE_FATIGUE))
				REMOVE_TRAIT(holder, TRAIT_VACUUM_RESISTANCE_FATIGUE, TEMPORARY_VACUUM_RES_TRAIT)
			if(holder.has_status_effect(/datum/status_effect/temporary_pressure_resistance))
				holder.remove_status_effect(/datum/status_effect/temporary_pressure_resistance)
		else if(!HAS_TRAIT(holder, TRAIT_VACUUM_RESISTANCE_FATIGUE) && !holder.has_status_effect(/datum/status_effect/temporary_pressure_resistance))
			holder.apply_status_effect(/datum/status_effect/temporary_pressure_resistance)


/datum/status_effect/temporary_pressure_resistance
	id = "temp_pressure_resist"
	duration = 2 MINUTES
	show_duration = TRUE

	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/temporary_pressure_resistance

/datum/status_effect/temporary_pressure_resistance/on_apply()
	. = ..()
	owner.add_traits(list(TRAIT_RESISTLOWPRESSURE), TEMPORARY_VACUUM_RES_TRAIT)

/datum/status_effect/temporary_pressure_resistance/on_remove()
	. = ..()
	owner.remove_traits(list(TRAIT_RESISTLOWPRESSURE), TEMPORARY_VACUUM_RES_TRAIT)
	ADD_TRAIT(owner, TRAIT_VACUUM_RESISTANCE_FATIGUE, TEMPORARY_VACUUM_RES_TRAIT)

/atom/movable/screen/alert/status_effect/temporary_pressure_resistance
	name = "Low pressure resistance"
	desc = "Your body is fighting to resist the low pressure outside, it can't stay like this for long though."
	icon = 'modular_zzplurt/icons/hud/screen_alert.dmi'
	icon_state = "low_press_res"
