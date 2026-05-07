/// Returns automapper TOML files in load order.
/proc/get_automapper_config_files()
	return list(
		"_maps/bubber/automapper/automapper_config.toml",
		"_maps/splurt/automapper/automapper_config.toml",
	)

/datum/controller/subsystem/automapper/Initialize()
	loaded_config = list("templates" = list())
	var/list/loaded_templates = loaded_config["templates"]

	for(var/config_file in get_automapper_config_files())
		if(!fexists(config_file))
			CRASH("Automapper could not find TOML config [config_file]!")

		var/list/config_data = rustg_read_toml_file(config_file)
		if(!islist(config_data))
			CRASH("Automapper could not read TOML config [config_file]!")

		var/list/config_templates = config_data["templates"]
		if(!islist(config_templates))
			CRASH("Automapper config [config_file] did not contain a templates list!")

		for(var/template in config_templates)
			if(!isnull(loaded_templates[template]))
				CRASH("Duplicate automapper template [template] found in [config_file]!")
			loaded_templates[template] = config_templates[template]

	return SS_INIT_SUCCESS
