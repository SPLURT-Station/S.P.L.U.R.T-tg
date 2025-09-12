/mob/dead/new_player/get_title_html()
	. = ..()
	if(SSticker.current_state == GAME_STATE_STARTUP || findtext(SStitle.splashscreen_name, "has_title"))
		return

