#define VV_HK_OMe "ome"

/obj/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_OMe, "Object Emote")

/obj/vv_do_topic(list/href_list)
	. = ..()
	if(!.)
		return
	if(href_list[VV_HK_OMe])
		return SSadmin_verbs.dynamic_invoke_verb(usr, /datum/admin_verb/object_me, src)

ADMIN_VERB_AND_CONTEXT_MENU(object_me, R_FUN, "OMe", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, obj/speaker in world)
	var/emote = tgui_input_text(user, "What do you want the emote to be?", "Do Emote", encode = FALSE)
	if(!emote)
		return
	speaker.visible_message(
		message = emote,
		blind_message = null,
		visible_message_flags = EMOTE_MESSAGE,
		separation = " "
	)
	log_admin("[key_name(user)] made [speaker] at [AREACOORD(speaker)] emote \"[emote]\"")
	message_admins(span_adminnotice("[key_name_admin(user)] made [speaker] at [AREACOORD(speaker)] emote \"[emote]\""))
	BLACKBOX_LOG_ADMIN_VERB("Object Emote")

#undef VV_HK_OMe
