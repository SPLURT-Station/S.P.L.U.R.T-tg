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

#undef VETTED_TOML_FILE
