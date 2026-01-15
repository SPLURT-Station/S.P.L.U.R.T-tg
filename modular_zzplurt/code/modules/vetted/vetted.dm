#define VETTED_TOML_FILE "[global.config.directory]/splurt/roles.toml"

/datum/controller/subsystem/player_ranks/get_user_vetted_status_hot(ckey)
	if(IsAdminAdvancedProcCall())
		return
	if(!rustg_file_exists(VETTED_TOML_FILE))
		return ..()
	var/list/vetted = rustg_read_toml_file(VETTED_TOML_FILE)["vetted"]
	if(vetted && vetted.Find(ckey))
		return TRUE
	. = ..()

/datum/controller/subsystem/player_ranks/proc/check_vetted(mob/player)
	. = TRUE
	if(!CONFIG_GET(flag/age_gate_bunker)) //If age gate bunker is not enabled
		return TRUE
	if(!initialized) //If subsystem hasn't started
		return null
	if(!player?.client) //Safety check
		return FALSE
	if(player.client?.ckey in GLOB.vetted_passthrough) //If they have bypass
		return TRUE
	if(is_vetted(player.client, admin_bypass = FALSE)) //If they are vetted
		return TRUE
	return FALSE //Not vetted and bunker is enabled

#undef VETTED_TOML_FILE
