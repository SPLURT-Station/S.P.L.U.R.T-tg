/datum/toolgun_mode/color_mode
	name = "Покраска"
	desc = "Режим покраски обьектов. Может покрасить что и кого угодно!"
	mode_key = "color"

	var/selected_color = "#FFFFFF"

/datum/toolgun_mode/color_mode/main_act(atom/target, mob/user)
	if(!isatom(target))
		return FALSE
	animate(target, color = selected_color, time = 3)
	return TRUE

/datum/toolgun_mode/color_mode/secondnary_act(atom/target, mob/user)
	if(!isatom(target))
		return FALSE
	target.color = initial(target.color)
	return TRUE

/datum/toolgun_mode/color_mode/ui_data(mob/user)
	. = ..()
	.["selected_color"] = selected_color

/datum/toolgun_mode/color_mode/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("pick_color")
			var/chosen_color = tgui_color_picker(usr, "Select object color", "Toolgun color mode", selected_color)
			if(chosen_color)
				selected_color = chosen_color
			return TRUE
		if("set_color")
			var/new_color = trimtext(params["color"])
			if(length(new_color))
				selected_color = new_color
			return TRUE
	return ..()

/datum/toolgun_mode/resize_mode
	name = "Resize mode"
	desc = "LMB resizes target object. RMB resets scale."
	mode_key = "resize"

	var/scale_value = 1

/datum/toolgun_mode/resize_mode/main_act(atom/target, mob/user)
	if(!isobj(target))
		return FALSE
	var/matrix/new_transform = matrix()
	new_transform.Scale(scale_value, scale_value)
	target.transform = new_transform
	return TRUE

/datum/toolgun_mode/resize_mode/secondnary_act(atom/target, mob/user)
	if(!isobj(target))
		return FALSE
	target.transform = initial(target.transform)
	return TRUE

/datum/toolgun_mode/resize_mode/ui_data(mob/user)
	. = ..()
	.["scale_value"] = scale_value

/datum/toolgun_mode/resize_mode/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("set_scale")
			var/new_scale = text2num(params["scale"])
			if(!isnum(new_scale))
				return TRUE
			scale_value = clamp(new_scale, 0.2, 5)
			return TRUE
	return ..()
