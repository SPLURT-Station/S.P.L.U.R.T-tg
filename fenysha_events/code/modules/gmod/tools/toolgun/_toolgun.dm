/obj/item/toolgun
	name = "Туллган"
	desc = "Странный револьер с кучей проводов и дисплеем приделанным к его основанию!"
	icon = 'fenysha_events/icons/items/tools/gmod_tools.dmi'
	icon_state = "toolgun"
	inhand_icon_state = "toolgun"
	lefthand_file = 'fenysha_events/icons/items/inhand/tools/gmod_tools_left.dmi'
	righthand_file = 'fenysha_events/icons/items/inhand/tools/gmod_tools_right.dmi'
	demolition_mod = 0.5
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 1
	throw_range = 1
	drop_sound = 'sound/items/handling/tools/screwdriver_drop.ogg'
	pickup_sound = 'fenysha_events/sounds/tools/phystools/toolgun_select.ogg'
	resistance_flags = INDESTRUCTIBLE


	/// The mode that is chosen at the moment
	var/datum/toolgun_mode/selected_mode
	/// Available modes
	var/list/datum/toolgun_mode/available_modes = list(
		/datum/toolgun_mode/spawning/objects,
		/datum/toolgun_mode/color_mode,
		/datum/toolgun_mode/resize_mode,
		/datum/toolgun_mode/spawning/build_mode,
		/datum/toolgun_mode/spawning/mobs,
	)
	/// The datum of the beam
	var/datum/beam/work_beam
	var/use_cooldown = 0.5 SECONDS

	COOLDOWN_DECLARE(sound_cd)
	COOLDOWN_DECLARE(work_cd)

/obj/item/toolgun/Initialize(mapload)
	. = ..()
	if(length(available_modes))
		select_mode_by_path(available_modes[1], null, TRUE)

/obj/item/toolgun/examine(mob/user)
	. = ..()
	. += span_notice("Используй в руке, чтобы изменить режим работы!")
	if(!selected_mode)
		. += span_notice("Режим не выбран!")
		return
	. += span_notice(selected_mode.desc)

	if(!user?.client?.holder)
		. += span_boldwarning("\n Кажется у меня не должно его быть!")

/obj/item/toolgun/examine_more(mob/user)
	. = ..()
	. += span_notice("Ты надеялся увидеть тут что-то? Серьезно? Как наивно с твоей стороны \
					послушай друг, здесь ничего нет. Вообще ничего нет, я говорю тебе - абсолютно ничего. \
					даже не пытайся искать тут что-нибудь. Ты меня слышишь? Даже не пытайся. Ты все равно ничего не найдешь.")

/obj/item/toolgun/click_alt(mob/user)
	return ..()

/obj/item/toolgun/attack_self(mob/user)
	. = ..()
	if(!selected_mode)
		return
	selected_mode.use_act(user)

/obj/item/toolgun/ui_state(mob/user)
	return GLOB.hands_state

/obj/item/toolgun/ui_interact(mob/user, datum/tgui/ui)
	if(!selected_mode)
		if(!length(available_modes))
			balloon_alert(user, "mode is not selected")
			return
		select_mode_by_path(available_modes[1], user, TRUE)
	selected_mode.ui_interact(user, ui)

/obj/item/toolgun/ui_static_data(mob/user)
	if(!selected_mode)
		return list()
	return selected_mode.ui_static_data(user)

/obj/item/toolgun/ui_data(mob/user)
	if(!selected_mode)
		return list()
	var/list/mode_data = selected_mode.ui_data(user)
	mode_data["available_modes"] = get_mode_entries()
	mode_data["selected_mode_key"] = selected_mode.mode_key
	return mode_data

/obj/item/toolgun/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(COOLDOWN_FINISHED(src, sound_cd))
		playsound(src, 'fenysha_events/sounds/tools/phystools/toolgun_select.ogg', 20)
		COOLDOWN_START(src, sound_cd, 1 SECONDS)

	if(action == "select_mode")
		var/selected_key = trimtext(params["mode_key"])
		if(!length(selected_key))
			return TRUE
		for(var/path in available_modes)
			var/datum/toolgun_mode/mode_path = path

			if(initial(mode_path.mode_key) != selected_key)
				continue
			select_mode_by_path(mode_path, usr)
			ui.send_full_update(force = TRUE)
			return TRUE
		return TRUE
	if(!selected_mode)
		return TRUE
	return selected_mode.ui_act(action, params, ui, state)

/obj/item/toolgun/ranged_interact_with_atom(atom/target, mob/user, list/modifiers)
	if(!COOLDOWN_FINISHED(src, work_cd))
		return ITEM_INTERACT_SUCCESS

	if(!selected_mode)
		return
	if(!selected_mode.main_act(target, user))
		playsound(user, 'fenysha_events/sounds/tools/phystools/toolgun_error.ogg', 100, TRUE)
		return ITEM_INTERACT_SUCCESS
	do_work_effect(target, user)
	playsound(user, 'fenysha_events/sounds/tools/phystools/toolgun_shot1.ogg', 100, TRUE)
	COOLDOWN_START(src, work_cd, use_cooldown)
	return ITEM_INTERACT_SUCCESS

/obj/item/toolgun/ranged_interact_with_atom_secondary(atom/target, mob/user, proximity_flag, list/modifiers)
	if(!COOLDOWN_FINISHED(src, work_cd))
		return ITEM_INTERACT_SUCCESS

	if(!selected_mode)
		return
	if(!selected_mode.secondnary_act(target, user))
		playsound(user, 'fenysha_events/sounds/tools/phystools/toolgun_error.ogg', 100, TRUE)
		return ITEM_INTERACT_SUCCESS
	do_work_effect(target, user)
	playsound(user, 'fenysha_events/sounds/tools/phystools/toolgun_shot1.ogg', 100, TRUE)

	COOLDOWN_START(src, work_cd, use_cooldown)
	return ITEM_INTERACT_SUCCESS

/obj/item/toolgun/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return ranged_interact_with_atom(interacting_with, user, modifiers)

/obj/item/toolgun/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	return ranged_interact_with_atom_secondary(interacting_with, user, FALSE, modifiers)

/obj/item/toolgun/proc/do_work_effect(atom/target, mob/user)
	if(!target)
		return
	work_beam = user.Beam(target, "light_beam", time = 3)

/obj/item/toolgun/proc/select_mode_by_path(mode_path, mob/user, silent = FALSE)
	if(!mode_path)
		return FALSE
	if(selected_mode)
		qdel(selected_mode)
	selected_mode = new mode_path
	selected_mode.our_tool = src
	if(user)
		selected_mode.on_selected(user)
	if(!silent && user)
		playsound(user, 'fenysha_events/sounds/tools/phystools/toolgun_select.ogg', 100, TRUE)
	return TRUE

/obj/item/toolgun/proc/get_mode_entries()
	var/list/entries = list()
	for(var/path in available_modes)
		var/datum/toolgun_mode/mode_path = path
		entries += list(list(
			"mode_key" = "[initial(mode_path.mode_key)]",
			"name" = "[initial(mode_path.name)]",
		))
	return entries


/obj/item/toolgun/spawn_only
	name = "Туллган - ослабленный"
	available_modes = list(/datum/toolgun_mode/spawning/objects)
