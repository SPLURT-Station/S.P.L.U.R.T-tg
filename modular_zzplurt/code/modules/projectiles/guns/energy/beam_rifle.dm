/obj/item/gun/energy/event_horizon
	name = "\improper Pulsar hyper-resonance beam rifle"
	desc = "While the masterminds of the Event Horizon chased oblivion, the team behind the Pulsar sought control. Developed in the wake of anti-existential deployment backlash, this weapon represents a more measured apocalypse. This weapon melts everything in its path with the precision of a scalpel and the elegance of a dying star."
	icon = 'modular_zzplurt/icons/obj/weapons/guns/energy.dmi'
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_righthand.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/back.dmi'

/obj/item/ammo_casing/energy/event_horizon
	select_name = "hyper-resonant"

/obj/projectile/beam/event_horizon
	name = "hyper-resonant beam"
	damage = 100
	projectile_piercing = PASSMOB|PASSVEHICLE
	max_pierces = 3
	armour_penetration = 30
	jitter = 5 SECONDS
	hitscan_light_intensity = 3
	hitscan_light_range = 0.75
	hitscan_light_color_override = COLOR_BLUE_LIGHT

/obj/projectile/beam/event_horizon/generate_hitscan_tracers(impact_point = TRUE, impact_visual = TRUE)
	if (!length(beam_points))
		return

	if (impact_point)
		create_hitscan_point(impact = TRUE)

	if (tracer_type)
		var/list/passed_turfs = list()
		for (var/beam_point in beam_points)
			generate_tracer(beam_point, passed_turfs)

	if (muzzle_type && !spawned_muzzle)
		spawned_muzzle = TRUE
		var/datum/point/start_point = beam_points[1]
		var/atom/movable/muzzle_effect = new muzzle_type(loc)
		start_point.move_atom_to_src(muzzle_effect)
		var/matrix/matrix = new
		matrix.Turn(original_angle)
		muzzle_effect.transform = matrix
		muzzle_effect.color =  color
		muzzle_effect.set_light(muzzle_flash_range, muzzle_flash_intensity, muzzle_flash_color_override || color)
		QDEL_IN(muzzle_effect, 2.4 SECONDS)

	if (impact_type && impact_visual)
		var/atom/movable/impact_effect = new impact_type(loc)
		last_point.move_atom_to_src(impact_effect)
		var/matrix/matrix = new
		matrix.Turn(angle)
		impact_effect.transform = matrix
		impact_effect.color =  color
		impact_effect.set_light(impact_light_range, impact_light_intensity, impact_light_color_override || color)
		QDEL_IN(impact_effect, 2.4 SECONDS)

/obj/projectile/beam/event_horizon/generate_tracer(datum/point/start_point, list/passed_turfs)
	if (isnull(beam_points[start_point]))
		return

	var/datum/point/end_point = beam_points[start_point]
	var/datum/point/midpoint = point_midpoint_points(start_point, end_point)
	var/obj/effect/projectile/tracer/tracer_effect = new tracer_type(midpoint.return_turf())
	tracer_effect.apply_vars(
		angle_override = angle_between_points(start_point, end_point),
		p_x = midpoint.pixel_x,
		p_y = midpoint.pixel_y,
		color_override = color,
		scaling = pixel_length_between_points(start_point, end_point) / ICON_SIZE_ALL
	)
	SET_PLANE_EXPLICIT(tracer_effect, GAME_PLANE, src)

	QDEL_IN(tracer_effect, 2.4 SECONDS)

	if (!hitscan_light_range || !hitscan_light_intensity)
		return

	var/list/turf/light_line = get_line(start_point.return_turf(), end_point.return_turf())
	for (var/turf/light_turf as anything in light_line)
		if (passed_turfs[light_turf])
			continue
		passed_turfs[light_turf] = TRUE
		QDEL_IN(new /obj/effect/abstract/projectile_lighting(light_turf, hitscan_light_color_override || color, hitscan_light_range, hitscan_light_intensity), 2.4 SECONDS)

/obj/effect/projectile/tracer/tracer/beam_rifle
	icon = 'modular_zzplurt/icons/obj/weapons/guns/projectiles_tracer.dmi'
	icon_state = "pulsar_beam"

/obj/projectile/beam/event_horizon/on_hit(atom/target, blocked, pierce_hit)
	. = ..()

	if(. == BULLET_ACT_HIT)
		explosion(src, heavy_impact_range = 1, light_impact_range = 2, flame_range = 2, flash_range = 2, adminlog = FALSE)

/datum/crafting_recipe/beam_rifle
	name = "Pulsar hyper-resonance beam rifle"
	reqs = list(
		/obj/item/assembly/signaler/anomaly/flux = 1,
		/obj/item/assembly/signaler/anomaly/grav = 1,
		/obj/item/assembly/signaler/anomaly/bluespace = 1,
		/obj/item/weaponcrafting/gunkit/beam_rifle = 1,
		/obj/item/gun/energy/e_gun = 1,
	)

/obj/item/weaponcrafting/gunkit/beam_rifle
	name = "\improper Pulsar hyper-resonance beam rifle part kit"
	desc = "A lattice of advanced alloys and stubborn physics, forged not to contain power, but to politely ask it to stay put. A lesson in humility, written in plasma."

/datum/design/beamrifle
	name = "Pulsar Hyper-Resonance Beam Rifle Part Kit"
	desc = "A tidy box of parts engineered to vaporize problems at the speed of light. Comes with instructions, regrets, and a small sticker that says 'Handle With Awe.'"
