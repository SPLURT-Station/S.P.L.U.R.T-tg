/mob/dead/new_player/Topic(href, list/href_list)
	//maturity check
	if(!client?.maturity_prompt_whitelist && !SSmaturity_guard.age_check(src))
		return

	//discord check
	var/vibe_check = SSdiscord?.check_login(src)
	if(isnull(vibe_check))
		to_chat(usr, span_notice("The server is still starting up. Please wait... "))
		return
	if(href_list["observe"] || href_list["toggle_ready"] || href_list["late_join"])
		if(!vibe_check)
			to_chat(src, span_warning("You must link your discord account to your ckey in order to join the game. Join our <a style=\"color: #ff00ff;\" href=\"[CONFIG_GET(string/discord_link)]\">discord</a> and open a verification ticket [CONFIG_GET(string/verification_channel) ? "as indicated in #[CONFIG_GET(string/verification_channel)] " : ""]. It won't take you more than two minutes :)<br>Ahelp or ask staff in the discord if this is an error."))
			return
	. = ..()

/mob/dead/new_player/update_title_screen()
	. = ..()
	if((client?.prefs?.read_preference(/datum/preference/toggle/hide_splashscreen) || (!client?.maturity_prompt_whitelist && CONFIG_GET(flag/age_prompt_system))) && SStitle.current_title_screen != DEFAULT_TITLE_SCREEN_IMAGE && SStitle.current_title_screen != DEFAULT_TITLE_LOADING_SCREEN)
		src << browse(DEFAULT_TITLE_SCREEN_IMAGE, "file=loading_screen.gif;display=0")
