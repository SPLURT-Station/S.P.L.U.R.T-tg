/// Minimum pressure of gases passing through the turbine
#define MINIMUM_TURBINE_PRESSURE 0.01
/// Returns the maximum pressure if it is below the value
#define PRESSURE_MAX(value) (max((value), MINIMUM_TURBINE_PRESSURE))
/// Minimum temperature for hot steam (in Kelvin, >373K for boiling water)
#define MIN_STEAM_TEMPERATURE 400

// Base class for train steam turbine parts
/obj/machinery/power/train_turbine
	name = "train steam turbine part"
	desc = "A component of the train's steam turbine. Consists of an inlet compressor, a core, and an outlet stator. Runs on hot water vapor, exhausts CO₂ into the atmosphere and cooled water through liquid pipes."
	icon = 'icons/obj/machines/engine/turbine.dmi'
	density = TRUE
	resistance_flags = FIRE_PROOF
	can_atmos_pass = ATMOS_PASS_DENSITY
	processing_flags = START_PROCESSING_MANUALLY

	/// Efficiency of this part (depends on installed upgrades)
	var/efficiency = 0.5
	/// Installed module (upgrade)
	var/obj/item/turbine_parts/installed_part
	/// Path to the module that can be installed
	var/obj/item/turbine_parts/part_path
	/// Internal gas mixture
	var/datum/gas_mixture/machine_gasmix
	/// Theoretical gas volume inside the part
	var/gas_theoretical_volume = 1000  // Base value, overridden in children

	/// Reference to the turbine core (shared by all parts)
	var/obj/machinery/power/train_turbine/core_rotor/rotor

/obj/machinery/power/train_turbine/Initialize(mapload)
	. = ..()
	machine_gasmix = new()
	machine_gasmix.volume = gas_theoretical_volume

	if(mapload && part_path)
		installed_part = new part_path(src)
		efficiency = installed_part?.get_tier_value(TURBINE_MAX_EFFICIENCY) || efficiency

	air_update_turf(TRUE)
	update_appearance(UPDATE_OVERLAYS)
	register_context()

/obj/machinery/power/train_turbine/Destroy()
	air_update_turf(TRUE)
	QDEL_NULL(installed_part)
	QDEL_NULL(machine_gasmix)
	if(rotor)
		rotor.deactivate_parts()
	return ..()

/obj/machinery/power/train_turbine/proc/is_active()
	return rotor?.active || FALSE

/// Transfers gases from one mixture to another, accounting for work and thermal effects
/obj/machinery/power/train_turbine/proc/transfer_gases(datum/gas_mixture/input_mix, datum/gas_mixture/output_mix, work_amount_to_remove = 0, intake_size = 1)
	var/output_pressure = PRESSURE_MAX(output_mix.return_pressure())
	var/datum/gas_mixture/transferred_gases = input_mix.pump_gas_to(output_mix, input_mix.return_pressure() * intake_size)
	if(!transferred_gases)
		return 0

	var/work_done = QUANTIZE(transferred_gases.total_moles()) * R_IDEAL_GAS_EQUATION * transferred_gases.temperature * log((transferred_gases.volume * PRESSURE_MAX(transferred_gases.return_pressure())) / (output_mix.volume * output_pressure)) * TURBINE_WORK_CONVERSION_MULTIPLIER
	if(work_amount_to_remove)
		work_done -= work_amount_to_remove

	var/output_mix_heat_capacity = output_mix.heat_capacity()
	if(!output_mix_heat_capacity)
		return 0
	work_done = min(work_done, (output_mix_heat_capacity * output_mix.temperature - output_mix_heat_capacity * TCMB) / TURBINE_HEAT_CONVERSION_MULTIPLIER)
	output_mix.temperature = max((output_mix.temperature * output_mix_heat_capacity + work_done * TURBINE_HEAT_CONVERSION_MULTIPLIER) / output_mix_heat_capacity, TCMB)
	return work_done


/obj/machinery/power/train_turbine/inlet_compressor
	name = "train turbine inlet compressor"
	desc = "The inlet part of the train's steam turbine. Connects to pipes for the supply of hot water vapor."
	icon_state = "inlet_compressor"
	base_icon_state = "inlet_compressor"
	part_path = /obj/item/turbine_parts/compressor
	gas_theoretical_volume = 1000

	/// Steam intake regulator (0.01–1.0)
	var/intake_regulator = 0.5
	/// Compressor work this tick
	var/compressor_work = 0
	/// Pressure after the compressor
	var/compressor_pressure = MINIMUM_TURBINE_PRESSURE
	/// Atmos connector for the inlet pipes
	var/datum/gas_machine_connector/connector

/obj/machinery/power/train_turbine/inlet_compressor/post_machine_initialize()
	. = ..()
	var/connector_dir = REVERSE_DIR(dir)
	connector = new(loc, src, connector_dir, CELL_VOLUME * 0.5)
	connector.gas_connector.dir = connector_dir
	connector.gas_connector.initialize_directions = connector_dir

/obj/machinery/power/train_turbine/inlet_compressor/Destroy()
	QDEL_NULL(connector)
	return ..()

/obj/machinery/power/train_turbine/inlet_compressor/proc/compress_gases()
	compressor_work = 0
	compressor_pressure = MINIMUM_TURBINE_PRESSURE

	if(!connector)
		return 0

	var/datum/gas_mixture/pipe_mix = connector.gas_connector.airs[1]
	if(!pipe_mix)
		return 0

	var/has_steam = pipe_mix.has_gas(/datum/gas/water_vapor, 1)
	var/temperature = pipe_mix.temperature
	if(!has_steam || temperature < MIN_STEAM_TEMPERATURE)
		return 0

	compressor_work = transfer_gases(pipe_mix, machine_gasmix, intake_size = intake_regulator)
	compressor_pressure = PRESSURE_MAX(machine_gasmix.return_pressure())

	return temperature


/datum/looping_sound/turbine_loop
	mid_sounds = 'fenysha_events/sounds/turbine_loop.ogg'
	mid_length = 3 SECONDS
	volume = 60
	falloff_exponent = 3
	ignore_walls = FALSE


/obj/machinery/power/train_turbine/core_rotor
	name = "train turbine core (rotor)"
	desc = "The central part of the train's steam turbine. Controls RPM, temperature, and power generation. The higher the RPM, the more power - but also the greater the risk of overheating and destruction."
	icon_state = "core_rotor"
	base_icon_state = "core_rotor"
	part_path = /obj/item/turbine_parts/rotor
	gas_theoretical_volume = 3000

	var/active = FALSE
	var/rpm = 0
	var/max_rpm = 7000
	var/produced_energy = 0
	var/max_temperature = 1000
	var/efficiency_rate = 120
	var/work_time = 0
	var/damage = 0
	var/damage_archived = 0
	var/all_parts_connected = FALSE

	var/steam_consumption_rate = 0.1
	/// Water reagent recovered per mole of steam consumed. Set to 1/(heater moles-per-unit) so the
	/// steam→water→steam loop conserves mass; the 0.9 multiplier at the call site is the 10% loop loss.
	var/water_production_rate = 0.1
	/// Moles of steam pulled per second at full regulator + full target RPM. Sets the looped water volume. (Tune for balance.)
	var/steam_flow_scale = 400
	/// RPM produced per (mole/sec of steam × K of superheat above the minimum). (Tune for balance.)
	var/power_per_throughput = 1

	/// Target RPM as % of maximum (0–1). Set from the control panel.
	var/target_rpm = 0

	var/datum/looping_sound/turbine_loop/soundloop
	/// References to the adjacent parts
	var/obj/machinery/power/train_turbine/inlet_compressor/compressor
	var/obj/machinery/power/train_turbine/turbine_outlet/turbine

	COOLDOWN_DECLARE(turbine_damage_alert)
	COOLDOWN_DECLARE(turbine_effects_update)

/obj/machinery/power/train_turbine/core_rotor/Initialize(mapload)
	. = ..()
	new /obj/item/paper/guides/jobs/atmos/train_turbine(loc)
	SStrain_controller.train_engine = src
	soundloop = new(src)
	connect_to_network()

/obj/machinery/power/train_turbine/core_rotor/Destroy()
	. = ..()
	SStrain_controller.train_engine = null
	QDEL_NULL(soundloop)

/obj/machinery/power/train_turbine/core_rotor/post_machine_initialize()
	. = ..()
	activate_parts()

/obj/machinery/power/train_turbine/core_rotor/begin_processing()
	. = ..()

/obj/machinery/power/train_turbine/core_rotor/end_processing()
	. = ..()
	soundloop.stop()

/obj/machinery/power/train_turbine/core_rotor/is_active()
	return active

/obj/machinery/power/train_turbine/core_rotor/multitool_act(mob/living/user, obj/item/multitool/multitool)
	. = ITEM_INTERACT_FAILURE
	multitool.buffer = src
	activate_parts(user)
	balloon_alert(user, "Turbine core saved to the multitool buffer.")
	return ITEM_INTERACT_SUCCESS

/obj/machinery/power/train_turbine/core_rotor/proc/update_effects()
	var/work_procentage = clamp(rpm / (max_rpm * 0.9), 0, 1)
	if(work_procentage < 0.1)
		soundloop.stop()
		return
	if(!soundloop.timer_id)
		soundloop.start()
	if(work_procentage >= 0.85 && soundloop.volume != 70)
		soundloop.volume = 100
		soundloop.extra_range = 10
	else if(work_procentage >= 0.4 && soundloop.volume != 50)
		soundloop.volume = 60
		soundloop.extra_range = 5
	else if(work_procentage >= 0.2 && soundloop.volume != 30)
		soundloop.volume = 40
		soundloop.extra_range = 0
	else if(work_procentage >= 0.1 && soundloop.volume != 20)
		soundloop.volume = 20
		soundloop.extra_range = 0
	else
		soundloop.extra_range = 0

	if(work_procentage >= 0.95)
		Shake(2, 1, 3 SECONDS)
		compressor.Shake(2, 1, 3 SECONDS)
		turbine.Shake(2, 1, 3 SECONDS)

/obj/machinery/power/train_turbine/core_rotor/process(seconds_per_tick)
	if((!active || !all_parts_connected || !powered(ignore_use_power = TRUE)) && rpm <= 0)
		work_time = 0
		deactivate_parts()
		return PROCESS_KILL

	var/target_flow_multiplier = target_rpm / max_rpm
	var/inlet_temperature = compressor.compress_gases()
	if(!inlet_temperature || inlet_temperature < MIN_STEAM_TEMPERATURE)
		rpm = max(rpm - 50 * seconds_per_tick, 0)
		produced_energy = 0
		return

	var/datum/gas_mixture/compressor_gas = compressor.machine_gasmix
	var/available_steam = compressor_gas.gases[/datum/gas/water_vapor]?[MOLES] || 0

	if(available_steam < 0.05)
		rpm = max(rpm - 500 * seconds_per_tick, 0)
		produced_energy = 0
		return

	// Steam we want to pull this tick (regulator knob × RPM throttle) vs. what's actually in the compressor.
	// Power is gated by the steam we ACTUALLY consume, so you can't spin up without real throughput.
	var/steam_demand = steam_consumption_rate * compressor.intake_regulator * steam_flow_scale * target_flow_multiplier * seconds_per_tick
	var/steam_consumed = min(available_steam, steam_demand)

	compressor_gas.gases[/datum/gas/water_vapor][MOLES] -= steam_consumed
	compressor_gas.garbage_collect()

	var/total_efficiency = (compressor.efficiency + efficiency + turbine.efficiency) / 3

	// Enthalpy-flux model: power scales with the steam mass flow × how superheated it is.
	// steam_consumed is per-tick, so divide back out to a per-second rate to stay tick-length independent.
	var/steam_rate = steam_consumed / seconds_per_tick
	var/temp_factor = max(inlet_temperature - MIN_STEAM_TEMPERATURE, 0)
	var/base_power = steam_rate * temp_factor * power_per_throughput * total_efficiency

	// target_rpm is an upper throttle limit set on the console, NOT a free power source: the turbine
	// can only spin up to what the current steam throughput sustains. Trickle steam => base_power ~0 => no power.
	var/rpm_ceiling = min(base_power, target_rpm)
	rpm = lerp(rpm, rpm_ceiling, 0.1)
	// Output power depends only on the current RPM
	produced_energy = rpm * efficiency_rate * total_efficiency

	turbine.produce_water(steam_consumed * water_production_rate * 0.9)
	machine_gasmix.temperature = lerp(machine_gasmix.temperature, inlet_temperature * 0.8 + T20C * 0.2, 0.05)

	var/overheat = max(machine_gasmix.temperature - max_temperature, 0)
	if(overheat > 0)
		damage += overheat * 0.02 * seconds_per_tick
		if(damage > damage_archived + 1 && COOLDOWN_FINISHED(src, turbine_damage_alert))
			COOLDOWN_START(src, turbine_damage_alert, 10 SECONDS)
			playsound(src, 'sound/machines/engine_alert/engine_alert1.ogg', 100, FALSE)
			balloon_alert_to_viewers("OVERHEAT! Integrity [get_integrity()]%")

	var/safe_threshold = max_rpm * 0.9
	if(rpm > safe_threshold)
		damage += (rpm - safe_threshold) * 0.001 * seconds_per_tick
		if(damage > damage_archived + 1 && COOLDOWN_FINISHED(src, turbine_damage_alert))
			COOLDOWN_START(src, turbine_damage_alert, 10 SECONDS)
			playsound(src, 'sound/machines/engine_alert/engine_alert1.ogg', 100, FALSE)
			balloon_alert_to_viewers("Critical RPM! Integrity [get_integrity()]%")

	if(COOLDOWN_FINISHED(src, turbine_effects_update))
		COOLDOWN_START(src, turbine_effects_update, 3 SECONDS)
		update_effects()

	if(get_integrity() <= 0)
		explosion(src, devastation_range = 0, heavy_impact_range = 2, light_impact_range = 4)
		deactivate_parts()
		qdel(src)
		return PROCESS_KILL

	work_time += seconds_per_tick
	add_avail(produced_energy * (1 + 0.1 * (work_time / (15 * 60))))
	apply_thrust_to_train()


/obj/machinery/power/train_turbine/core_rotor/get_integrity()
	return max(round(100 - (damage / 500) * 100, 0.01), 0)


/obj/machinery/power/train_turbine/core_rotor/proc/activate_parts(mob/user, check_only = FALSE)
	if(!check_only)
		compressor = locate() in orange(1, src)
		turbine = locate() in orange(1, src)

	if(QDELETED(compressor) || QDELETED(turbine))
		balloon_alert(user, "parts missing!")
		return FALSE

	target_rpm = min(target_rpm, max_rpm)
	all_parts_connected = TRUE

	if(!check_only)
		compressor.rotor = src
		turbine.rotor = src
		max_temperature = 1000 + installed_part?.get_tier_value(TURBINE_MAX_TEMP) * 0.1 || 0
		max_rpm = 5950 + installed_part?.get_tier_value(TURBINE_MAX_RPM) * 0.001 || 0
		efficiency = (compressor.efficiency + turbine.efficiency) / 3

	return TRUE


/obj/machinery/power/train_turbine/core_rotor/proc/deactivate_parts()
	active = FALSE
	all_parts_connected = FALSE
	rpm = 0
	produced_energy = 0
	compressor?.rotor = null
	turbine?.rotor = null
	compressor = null
	turbine = null
	end_processing()


/obj/machinery/power/train_turbine/core_rotor/proc/toggle_power(force_off = FALSE)
	if(force_off || active)
		if(!active)
			return
		active = FALSE
		end_processing()
	else
		if(!activate_parts(check_only = TRUE))
			return
		active = TRUE
		begin_processing()
	update_appearance(UPDATE_OVERLAYS)
	compressor?.update_appearance(UPDATE_OVERLAYS)
	turbine?.update_appearance(UPDATE_OVERLAYS)


/obj/machinery/power/train_turbine/core_rotor/proc/emergency_vent()
	if(!active || !turbine)
		return
	/*
	if(full_dump)
		rpm *= 0.5  // Sharp drop in RPM
		balloon_alert_to_viewers("emergency vent activated!")
	*/


/obj/machinery/power/train_turbine/core_rotor/proc/apply_thrust_to_train()
	// Train thrust logic should go here


// ====================================================================
// Outlet part: Stator (Turbine Outlet)
// ====================================================================
/obj/machinery/power/train_turbine/turbine_outlet
	name = "train turbine outlet stator"
	desc = "The outlet part of the train's steam turbine. Exhausts CO₂ into the atmosphere and routes cooled water through liquid pipes."
	icon_state = "inlet_compressor"
	base_icon_state = "inlet_compressor"
	part_path = /obj/item/turbine_parts/stator
	gas_theoretical_volume = 6000

	var/turf/open/output_turf
	var/datum/component/plumbing/steam_turbine/plumbing


/obj/machinery/power/train_turbine/turbine_outlet/Initialize(mapload)
	. = ..()
	reagents = new(1000)
	reagents.my_atom = src

	plumbing = AddComponent(/datum/component/plumbing/steam_turbine)
	plumbing.enable()

/obj/machinery/power/train_turbine/turbine_outlet/Destroy()
	QDEL_NULL(plumbing)
	return ..()

/obj/machinery/power/train_turbine/turbine_outlet/proc/produce_water(amount)
	reagents.add_reagent(/datum/reagent/water, amount)


/datum/component/plumbing/steam_turbine
	supply_connects = NORTH | SOUTH


/obj/machinery/computer/train_turbine_computer
	name = "train turbine control console"
	desc = "A computer for controlling the train's steam turbine. Tracks RPM, temperature, pressure, and integrity - like a nuclear reactor from Barotrauma, only steam-powered."
	icon_screen = "turbinecomp"
	icon_keyboard = "tech_key"
	var/datum/weakref/rotor_ref
	var/mapping_id


/obj/machinery/computer/train_turbine_computer/post_machine_initialize()
	. = ..()
	if(!mapping_id)
		return
	for(var/obj/machinery/power/train_turbine/core_rotor/main as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/power/train_turbine/core_rotor))
		if(main.id_tag != mapping_id)
			continue
		register_machine(main)
		break


/obj/machinery/computer/train_turbine_computer/multitool_act(mob/living/user, obj/item/multitool/multitool)
	. = ITEM_INTERACT_FAILURE
	if(!istype(multitool.buffer, /obj/machinery/power/train_turbine/core_rotor))
		to_chat(user, span_notice("The multitool buffer contains an incompatible device..."))
		return
	if(rotor_ref)
		to_chat(user, span_notice("Changing the console's bluespace network..."))
	if(!do_after(user, 0.2 SECONDS, src))
		return

	playsound(get_turf(user), 'sound/machines/click.ogg', 10, TRUE)
	register_machine(multitool.buffer)
	to_chat(user, span_notice("You linked the console to the turbine core from the multitool buffer."))
	return ITEM_INTERACT_SUCCESS


/obj/machinery/computer/train_turbine_computer/proc/register_machine(obj/machinery/power/train_turbine/core_rotor/machine)
	rotor_ref = WEAKREF(machine)


/obj/machinery/computer/train_turbine_computer/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	var/obj/machinery/power/train_turbine/core_rotor/main_control = rotor_ref?.resolve()
	if(!main_control.activate_parts(user, check_only = TRUE))
		main_control.activate_parts(user)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TrainTurbineComputer", name)
		ui.open()


/obj/machinery/computer/train_turbine_computer/ui_data(mob/user)
	. = list()

	var/obj/machinery/power/train_turbine/core_rotor/main_control = rotor_ref?.resolve()
	if(QDELETED(main_control) || !main_control.all_parts_connected)
		.["connected"] = FALSE
		return
	var/datum/gas_mixture/pipe_mix = main_control.compressor?.connector?.gas_connector?.airs[1]
	.["compressor_too_cold"] = pipe_mix.temperature < MIN_STEAM_TEMPERATURE || FALSE
	.["connected"] = TRUE
	.["active"] = main_control.active
	.["rpm"] = main_control.rpm
	.["power"] = energy_to_power(main_control.produced_energy)
	.["integrity"] = main_control.get_integrity()
	.["max_rpm"] = main_control.max_rpm
	.["max_temperature"] = main_control.max_temperature

	// Temperatures by section
	.["inlet_temp"] = main_control.compressor?.machine_gasmix?.temperature || T20C
	.["rotor_temp"] = main_control.machine_gasmix?.temperature || T20C
	.["outlet_temp"] = main_control.turbine?.machine_gasmix?.temperature || T20C

	// Pressures by section
	.["compressor_pressure"] = main_control.compressor?.compressor_pressure || MINIMUM_TURBINE_PRESSURE
	.["rotor_pressure"] = main_control.machine_gasmix?.return_pressure() || MINIMUM_TURBINE_PRESSURE
	.["outlet_water_volume"] = main_control.turbine?.reagents.total_volume || 0

	.["regulator"] = main_control.compressor?.intake_regulator || 0.5
	.["target_rpm"] = main_control.target_rpm
	.["steam_consumption"] = main_control.steam_consumption_rate
	.["water_production"] = main_control.water_production_rate


/obj/machinery/computer/train_turbine_computer/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	var/obj/machinery/power/train_turbine/core_rotor/main_control = rotor_ref?.resolve()
	if(!main_control)
		return FALSE

	switch(action)
		if("toggle_power")
			if(!main_control.active)
				if(!main_control.activate_parts(usr, check_only = TRUE))
					return FALSE
			else if(main_control.rpm > 0)
				return FALSE
			main_control.toggle_power()
			return TRUE

		if("regulate")
			var/val = params["regulate"]
			if(isnull(val))
				return FALSE
			main_control.compressor.intake_regulator = clamp(text2num(val), 0.01, 1)
			return TRUE

		if("set_target_rpm")
			var/val = text2num(params["target"])
			if(isnull(val))
				return FALSE
			main_control.target_rpm = clamp(val, 0, main_control.max_rpm)
			return TRUE

		if("adjust_steam_rate")
			var/adjust = text2num(params["adjust"])
			if(isnull(adjust))
				return FALSE
			main_control.steam_consumption_rate = clamp(main_control.steam_consumption_rate + adjust, 0.01, 2)
			return TRUE

		if("emergency_vent")
			main_control.emergency_vent()
			return TRUE


/obj/item/paper/guides/jobs/atmos/train_turbine
	name = "Paper - \"Quick Guide to the Train Turbine!\""
	default_raw_text = "<B>How to operate the train's steam turbine</B><BR>\
	- Secure a canister of hot water vapor with a wrench in front of the inlet compressor.<BR>\
	- Turn on the temperature heaters, activate the pump, and set the required pressure depending on the desired power output.<BR>\
	- For water recirculation: pry open the floor with a crowbar and make sure the liquid pipes are connected to the stator outlet.<BR>\
	- Replace the standard outlet with the special turbine outlet (using a wrench).<BR>\
	- Load plasma sheets into the heaters, connect the water supply from the north.<BR>\
	- The heaters convert liquid water back into steam.<BR>\
	- Use the control console: set the target RPM, adjust the intake, and watch the temperature and pressure.<BR>\
	- Balance power and temperature - overheating quickly destroys the turbine!<BR>\
	- There is an emergency vent for rapid cooling.<BR>\
	- The turbine returns cooled water for reuse.<BR>\
	- The steam must be hot enough (>400K), otherwise the compressor won't accept it.<BR>\
	- Special acceleration mechanism: every 15 minutes of continuous operation, power increases by 10%."

#undef PRESSURE_MAX
#undef MINIMUM_TURBINE_PRESSURE
#undef MIN_STEAM_TEMPERATURE


/// Minimum temperature for plasma combustion
#define MIN_PLASMA_COMBUSTION_TEMP 373 // K (100°C)
/// Energy released by burning one plasma sheet (joules)
#define PLASMA_SHEET_BURN_ENERGY 100000
/// Volume of the water chamber (reagents)
#define HEATER_WATER_VOLUME 1000
/// Temperature at which water boils into steam
#define WATER_BOIL_TEMP 373 // K
/// Plasma consumption rate (sheets/tick, fractional value)
#define PLASMA_SHEET_CONSUMPTION_RATE 0.01 // Slow "burning" of a sheet

// Train heater: burns plasma sheets to turn water into steam
/obj/machinery/plumbing/train_heater
	name = "train plasma heater"
	desc = "A device that burns plasma sheets to boil water into steam, which is then fed into the train's turbine. Insert plasma, connect liquid pipes for the water supply and gas pipes for the steam outlet."
	icon = 'fenysha_events/icons/machinery/thermomachine.dmi'
	icon_state = "thermo_base"
	base_icon_state = "thermo_base"
	can_atmos_pass = ATMOS_PASS_DENSITY
	buffer = HEATER_WATER_VOLUME

	/// Whether the heater is active
	var/active = FALSE
	/// Current chamber temperature
	var/temperature = T20C
	/// Target temperature
	var/target_temperature = 500 // K
	/// Internal gas mixture for the steam outlet
	var/datum/gas_mixture/internal_gasmix
	/// Atmos connector for the steam outlet
	var/datum/gas_machine_connector/steam_output
	/// Plumbing component for the water inlet
	var/datum/component/plumbing/heater_plumbing
	/// Stack of plasma sheets inside
	var/obj/item/stack/sheet/mineral/plasma/plasma_stack
	/// Maximum number of plasma sheets the heater can hold
	var/max_plasma_sheets = 50

/obj/machinery/plumbing/train_heater/Initialize(mapload)
	. = ..() // /obj/machinery/plumbing handles reagent creation (buffer), anchoring and context
	internal_gasmix = new
	internal_gasmix.volume = 500 // For steam

	// Plumbing - water inlet
	heater_plumbing = AddComponent( \
		/datum/component/plumbing/heater_plumbing, \
		ducting_layer = THIRD_DUCT_LAYER, \
	)
	heater_plumbing.enable()

	// Atmos connector - steam outlet only
	steam_output = new(loc, src, dir, CELL_VOLUME * 0.5)

	air_update_turf(TRUE)
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/plumbing/train_heater/Destroy()
	QDEL_NULL(internal_gasmix)
	QDEL_NULL(steam_output)
	QDEL_NULL(heater_plumbing)
	if(plasma_stack)
		plasma_stack.forceMove(loc)
		plasma_stack = null
	return ..()

/obj/machinery/plumbing/train_heater/examine(mob/user)
	. = ..()
	if(plasma_stack)
		. += span_notice("Inside are [plasma_stack.amount] sheets.")
	else
		. += span_notice("No plasma sheets loaded. Insert fuel to operate.")
	. += span_notice("The device is [active ? "active" : "off"].")
	. += span_notice("The thermostat reads: [round(temperature, 1)] K ([round(temperature - T0C, 1)]°C).")
	. += span_notice("Steam output is [steam_output.gas_connector?.airs[1]?.total_moles() || 0] moles.")


/obj/machinery/plumbing/train_heater/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/stack/sheet/mineral/plasma))
		var/obj/item/stack/sheet/mineral/plasma/incoming = item
		var/current_amount = plasma_stack?.amount || 0
		var/free_space = max_plasma_sheets - current_amount
		if(free_space <= 0)
			balloon_alert(user, "heater full!")
			return TRUE

		var/to_load = min(incoming.amount, free_space)
		if(plasma_stack)
			// Top up the existing stack and consume the inserted sheets.
			plasma_stack.add(to_load)
			incoming.use(to_load)
			balloon_alert(user, "loaded [to_load] sheet\s ([plasma_stack.amount]/[max_plasma_sheets])")
		else if(to_load >= incoming.amount)
			// The whole stack fits - just move it in.
			if(!user.transferItemToLoc(incoming, src))
				return TRUE
			plasma_stack = incoming
			balloon_alert(user, "loaded [plasma_stack.amount] sheet\s ([plasma_stack.amount]/[max_plasma_sheets])")
		else
			// Only part of the stack fits - split off what we can hold.
			var/obj/item/stack/sheet/mineral/plasma/loaded = incoming.split_stack(to_load)
			loaded.forceMove(src)
			plasma_stack = loaded
			balloon_alert(user, "loaded [to_load] sheet\s ([plasma_stack.amount]/[max_plasma_sheets])")

		update_appearance(UPDATE_OVERLAYS)
		return TRUE
	return ..()


/obj/machinery/plumbing/train_heater/attack_hand(mob/living/user, list/modifiers)
	toggle_active(user)
	return TRUE


/obj/machinery/plumbing/train_heater/proc/toggle_active(mob/user)
	if(!anchored)
		balloon_alert(user, "anchor first!")
		return
	if(!plasma_stack || plasma_stack.amount <= 0)
		balloon_alert(user, "no plasma fuel!")
		return
	if(!reagents.has_reagent(/datum/reagent/water, 10))
		balloon_alert(user, "no water to heat!")
		return
	active = !active
	if(active)
		begin_processing()
	else
		active = FALSE
	balloon_alert(user, active ? "activated" : "turned off")
	update_appearance(UPDATE_OVERLAYS)


/obj/machinery/plumbing/train_heater/process(seconds_per_tick)
	if(!active && temperature > T20C)
		temperature = max(temperature - 1 * seconds_per_tick, T20C)
		if(temperature <= T20C)
			temperature = T20C
			end_processing()
		return

	if((!active || !powered(ignore_use_power = TRUE) || !plasma_stack || plasma_stack.amount <= 0) && temperature <= T20C)
		active = FALSE
		end_processing()
		return PROCESS_KILL

	var/plasma_consumed = min(PLASMA_SHEET_CONSUMPTION_RATE * seconds_per_tick, plasma_stack.amount)
	plasma_stack.use(plasma_consumed)
	var/energy_generated = plasma_consumed * PLASMA_SHEET_BURN_ENERGY

	if(temperature < target_temperature)
		temperature += 5 * energy_generated * seconds_per_tick

	if(temperature < MIN_PLASMA_COMBUSTION_TEMP)
		return

	if(reagents.has_reagent(/datum/reagent/water, 10) && temperature >= WATER_BOIL_TEMP)
		var/water_boiled = min(reagents.get_reagent_amount(/datum/reagent/water), 10 * seconds_per_tick)
		reagents.remove_reagent(/datum/reagent/water, water_boiled)
		ADD_GAS(/datum/gas/water_vapor, internal_gasmix.gases)
		internal_gasmix.gases[/datum/gas/water_vapor][MOLES] += water_boiled * 10
		temperature += energy_generated / (reagents.heat_capacity() + internal_gasmix.heat_capacity()) * seconds_per_tick

		internal_gasmix.temperature = temperature
		var/datum/gas_mixture/steam_mix = steam_output.gas_connector.airs[1]
		if(steam_mix)
			internal_gasmix.pump_gas_to(steam_mix, internal_gasmix.return_pressure())
		Shake(pixelshiftx = 1, pixelshifty = 0, duration = 1 SECONDS)


/datum/component/plumbing/heater_plumbing
	demand_connects = NORTH | SOUTH


/datum/component/plumbing/heater_plumbing/Initialize(ducting_layer)
	. = ..()
	if(!istype(parent, /obj/machinery/plumbing/train_heater))
		return COMPONENT_INCOMPATIBLE


/obj/machinery/computer/train_heater_computer
	name = "train heater control console"
	desc = "A control panel for the plasma heater used to produce steam."
	icon_screen = "heater_comp"
	icon_keyboard = "tech_key"
	var/datum/weakref/heater_ref
	var/mapping_id

// Instruction paper
/obj/item/paper/guides/jobs/atmos/train_heater
	name = "Paper - \"Quick Guide to the Train Heater!\""
	default_raw_text = "<B>How to operate the train's plasma heater</B><BR>\
	- Load plasma sheets as fuel.<BR>\
	- Connect liquid pipes for the water supply.<BR>\
	- Connect gas pipes for the steam outlet.<BR>\
	- Activate the device - the plasma will start burning and the water will turn into steam.<BR>"

#undef MIN_PLASMA_COMBUSTION_TEMP
#undef PLASMA_SHEET_BURN_ENERGY
#undef HEATER_WATER_VOLUME
#undef WATER_BOIL_TEMP
#undef PLASMA_SHEET_CONSUMPTION_RATE
