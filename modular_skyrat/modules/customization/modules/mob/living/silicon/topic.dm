/mob/living/silicon/Topic(href, href_list)
	. = ..()
	//SPLURT ADDITION START
	if(href_list["lookup_info"] == "genitals" && iscyborg(src))
		var/mob/living/silicon/robot/cyborg = src
		var/list/description_lines = cyborg.get_visible_cyborg_genital_descriptions()
		if(length(description_lines))
			to_chat(usr, span_notice("[jointext(description_lines, "\n")]") )
	//SPLURT ADDITION END
	if(href_list["lookup_info"] == "open_examine_panel")
		examine_panel.holder = src
		examine_panel.ui_interact(usr) //datum has a tgui component, here we open the window
	if(href_list["temporary_flavor"]) // we need this here because tg code doesnt call parent in /mob/living/silicon/Topic()
		show_temp_ftext(usr)
