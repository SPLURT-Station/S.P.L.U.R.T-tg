/obj/projectile/generate_hitscan_tracers(impact_point = TRUE, impact_visual = TRUE, duration = PROJECTILE_TRACER_DURATION) // Adds duration customization (defaults to standard).
	if (!length(beam_points))
		return

	if (impact_point)
		create_hitscan_point(impact = TRUE)

	if (tracer_type)
		var/list/passed_turfs = list()
		for (var/beam_point in beam_points)
			generate_tracer(beam_point, passed_turfs, duration)

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
		QDEL_IN(muzzle_effect, duration)

	if (impact_type && impact_visual)
		var/atom/movable/impact_effect = new impact_type(loc)
		last_point.move_atom_to_src(impact_effect)
		var/matrix/matrix = new
		matrix.Turn(angle)
		impact_effect.transform = matrix
		impact_effect.color =  color
		impact_effect.set_light(impact_light_range, impact_light_intensity, impact_light_color_override || color)
		QDEL_IN(impact_effect, duration)

/obj/projectile/generate_tracer(datum/point/start_point, list/passed_turfs, duration = PROJECTILE_TRACER_DURATION) // Ditto.
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

	QDEL_IN(tracer_effect, duration)

	if (!hitscan_light_range || !hitscan_light_intensity)
		return

	var/list/turf/light_line = get_line(start_point.return_turf(), end_point.return_turf())
	for (var/turf/light_turf as anything in light_line)
		if (passed_turfs[light_turf])
			continue
		passed_turfs[light_turf] = TRUE
		QDEL_IN(new /obj/effect/abstract/projectile_lighting(light_turf, hitscan_light_color_override || color, hitscan_light_range, hitscan_light_intensity), duration)
