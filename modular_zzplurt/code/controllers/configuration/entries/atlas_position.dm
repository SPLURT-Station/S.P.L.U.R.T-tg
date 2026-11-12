/// Seconds between rough position updates pushed to each client's tgui panel, which forwards them to the
/// player's optional websocket relay (chat settings -> Websocket) while it is connected. 0 disables them.
/datum/config_entry/number/atlas_position_interval
	default = 5
	integer = FALSE
	min_val = 0

/// Radius in tiles of the random offset applied to every reported position, so tools only get a rough estimate.
/datum/config_entry/number/atlas_position_fuzz_radius
	default = 1
	integer = TRUE
	min_val = 0
