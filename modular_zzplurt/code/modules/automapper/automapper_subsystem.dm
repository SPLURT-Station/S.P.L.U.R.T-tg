/// Returns automapper TOML files in load order.
/datum/controller/subsystem/automapper/proc/get_automapper_config_files()
	return list(
		"_maps/bubber/automapper/automapper_config.toml",
		"_maps/splurt/automapper/automapper_config.toml",
	)

/proc/apply_automapper_template_overrides(list/loaded_templates, list/template_overrides, config_file)
	if(!isnull(template_overrides) && !islist(template_overrides))
		CRASH("Automapper config [config_file] template_overrides value must be a list!")

	if(!islist(template_overrides))
		return

	for(var/template in template_overrides)
		var/list/template_override = template_overrides[template]
		if(!islist(template_override))
			CRASH("Automapper config [config_file] template override [template] must be a list!")

		var/list/loaded_template = loaded_templates[template]
		if(!islist(loaded_template))
			CRASH("Automapper config [config_file] tried to override missing template [template]!")

		for(var/override_key in template_override)
			loaded_template[override_key] = template_override[override_key]

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

		apply_automapper_template_overrides(loaded_templates, config_data["template_overrides"], config_file)
	return SS_INIT_SUCCESS
