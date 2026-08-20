/turf/closed/indestructible/backrooms
	icon = 'modular_zzplurt/icons/turf/walls/backrooms_wall.dmi'
	base_icon_state = "backrooms_wall"
	icon_state = "backrooms_wall-0"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_WALLS

	baseturfs = /turf/open/indestructible/backrooms

/turf/closed/indestructible/backrooms/CanPass(atom/movable/mover, border_dir)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/turf/open/indestructible/backrooms
	name = "Carpet"
	icon = 'modular_zzplurt/icons/turf/backrooms.dmi'
	icon_state = "backrooms_carpet"

	baseturfs = /turf/open/indestructible/backrooms

GLOBAL_LIST_EMPTY(backrooms_fall_points)

/obj/effect/mapping_helpers/backrooms_fall_point
	name = "backrooms fall point"
	icon_state = "merge_conflict_marker"
	alpha = 0
	late = TRUE
	mouse_opacity = FALSE

/obj/effect/mapping_helpers/backrooms_fall_point/Initialize(mapload)
	. = ..()
	if(!mapload)
		return
	GLOB.backrooms_fall_points += src

/obj/effect/mapping_helpers/backrooms_fall_point/Destroy()
	GLOB.backrooms_fall_points -= src
	return ..()


/obj/machinery/light/backrooms
	name = "Backrooms Light"
	desc = "An unnaturally stable fluorescent light. It never seems to flicker or burn out."
	icon_state = "tube"
	base_state = "tube"
	brightness = 9
	bulb_power = 1.5
	bulb_colour = "#fff9c4"

	break_if_moved = FALSE
	uses_integrity = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	flags_1 = SUPERMATTER_IGNORES_1

	status = LIGHT_OK
	start_with_cell = FALSE
	no_low_power = TRUE
	nightshift_allowed = FALSE

	var/always_powered = TRUE
	var/static/list/all_backrooms_lights = list()

/obj/machinery/light/backrooms/Initialize(mapload)
	. = ..()

	on = TRUE
	status = LIGHT_OK

	UnregisterSignal(src, COMSIG_GLOB_GREY_TIDE_LIGHT)
	UnregisterSignal(src, COMSIG_LIGHT_EATER_ACT)

	all_backrooms_lights += src

/obj/machinery/light/backrooms/Destroy()
	all_backrooms_lights -= src
	return ..()

/obj/machinery/light/backrooms/post_machine_initialize()
	. = ..()
	on = TRUE
	status = LIGHT_OK
	update()

/obj/machinery/light/backrooms/update(trigger, instant, play_sound)
	on = TRUE
	status = LIGHT_OK
	low_power_mode = FALSE
	major_emergency = FALSE
	flickering = FALSE

	set_light(
		l_range = brightness,
		l_power = bulb_power,
		l_color = bulb_colour
	)

	update_appearance()
	update_current_power_usage()

/obj/machinery/light/backrooms/has_power()
	return TRUE

/obj/machinery/light/backrooms/turned_off()
	return FALSE

/obj/machinery/light/backrooms/has_emergency_power(power_usage_amount)
	return TRUE

/obj/machinery/light/backrooms/use_emergency_power(power_usage_amount)
	return TRUE

/obj/machinery/light/backrooms/break_light_tube(skip_sound_and_sparks = FALSE)
	return

/obj/machinery/light/backrooms/burn_out()
	return

/obj/machinery/light/backrooms/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	return

/obj/machinery/light/backrooms/on_light_eater(obj/machinery/light/source, datum/light_eater)
	return COMPONENT_BLOCK_LIGHT_EATER

/obj/machinery/light/backrooms/grey_tide(datum/source, list/grey_tide_areas)
	return

/obj/machinery/light/backrooms/attack_hand_secondary(mob/living/carbon/human/user, list/modifiers)
	to_chat(user, span_warning("The [fitting] seems to be fused into the fixture. You can't remove it."))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/light/backrooms/attackby(obj/item/tool, mob/living/user, list/modifiers, list/attack_modifiers)
	if(istype(tool, /obj/item/light))
		to_chat(user, span_warning("There's no way to replace the bulb in this fixture."))
		return

	if(tool.tool_behaviour == TOOL_SCREWDRIVER)
		to_chat(user, span_warning("The casing is completely sealed. You can't open it."))
		return

	return ..()

/obj/machinery/light/backrooms/examine(mob/user)
	. = ..()
	. += span_notice("The light inside looks permanently fused to the fixture. It shows no signs of ever burning out.")

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/light/backrooms, 0)
