/*
 * Rough player position updates for external map tools such as the SPLURT atlas.
 *
 * tgui-panel forwards every message the server sends it to the player's optional
 * websocket relay (chat settings -> Websocket), so a periodic "player/position"
 * message is all a local map tool needs. No client-side changes are involved.
 */

/datum/tgui_panel
	/// Looping timer behind the position updates, TIMER_ID_NULL while they are not running.
	var/position_timer_id = TIMER_ID_NULL

/datum/tgui_panel/on_message(type, payload)
	. = ..()
	if(type == "ready")
		start_position_updates()

/datum/tgui_panel/Del()
	stop_position_updates()
	return ..()

/datum/tgui_panel/proc/start_position_updates()
	stop_position_updates()
	var/interval = CONFIG_GET(number/atlas_position_interval)
	if(interval <= 0)
		return
	position_timer_id = addtimer(CALLBACK(src, PROC_REF(send_position)), interval SECONDS, TIMER_LOOP | TIMER_STOPPABLE)

/datum/tgui_panel/proc/stop_position_updates()
	if(position_timer_id == TIMER_ID_NULL)
		return
	deltimer(position_timer_id)
	position_timer_id = TIMER_ID_NULL

/**
 * private
 *
 * Sends the client's own mob position to the panel, offset by a random amount.
 */
/datum/tgui_panel/proc/send_position()
	if(!client)
		stop_position_updates()
		return
	if(!is_ready())
		return
	var/turf/location = get_turf(client.mob)
	if(!location)
		return
	// The reported tile is deliberately offset by a random amount inside the configured radius.
	// Whatever listens on the websocket (map tools, but also any automation or bot) only ever gets
	// a rough estimate of where the player is, never exact coordinates.
	var/radius = CONFIG_GET(number/atlas_position_fuzz_radius)
	window.send_message("player/position", list(
		"x" = clamp(location.x + rand(-radius, radius), 1, world.maxx),
		"y" = clamp(location.y + rand(-radius, radius), 1, world.maxy),
		"z" = location.z,
		"radius" = radius,
		"map" = SSmapping.current_map?.map_name,
		"round_id" = GLOB.round_id,
	))
