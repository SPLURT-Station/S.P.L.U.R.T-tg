/datum/controller/subsystem/title
	var/list/title_screen_names = list()
	var/splashscreen_name

/datum/controller/subsystem/title/Initialize()
	. = ..()
	if(!CONFIG_GET(string/splashscreen_webserver_path))
		return
	var/list/provisional_title_screens = flist("[global.config.directory]/title_screens/images/")
	for(var/screen in provisional_title_screens)
		var/splashscreen_file = "[global.config.directory]/title_screens/images/[screen]"
		fcopy(fcopy_rsc(splashscreen_file), "[CONFIG_GET(string/splashscreen_webserver_path)]/[screen]")

/datum/controller/subsystem/title/change_title_screen(new_screen)
	. = ..()
	if(new_screen)
		return
	if(current_title_screen == DEFAULT_TITLE_SCREEN_IMAGE)
		return
	splashscreen_name = title_screen_names[current_title_screen]
