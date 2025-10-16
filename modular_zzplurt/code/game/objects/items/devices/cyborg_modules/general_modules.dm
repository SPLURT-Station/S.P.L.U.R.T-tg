/obj/item/borg/apparatus/update_appearance()
	. = ..()
	vis_contents = list()
	if(stored)
		modify_appearance(stored, TRUE)
		vis_contents += stored

/obj/item/borg/apparatus/dropped(mob/user, silent)
	if(stored)
		modify_appearance(stored, FALSE)
		stored.forceMove(user.drop_location())
	else
		. = ..()

/obj/item/borg/apparatus/proc/modify_appearance(obj/item, minify = FALSE)
	var/matrix/new_transform = new
	if(minify)
		new_transform.Scale(0.5, 0.5)
		item.transform = new_transform
		item.pixel_x = 8
		item.pixel_y = -8
		item.plane = FLOAT_PLANE
	else
		new_transform.Scale(1, 1)
		item.transform = new_transform
		item.pixel_x = initial(item.pixel_x)
		item.pixel_y = initial(item.pixel_y)
		item.plane = initial(item.plane)

/obj/item/borg/apparatus/sheet_manipulator/modify_appearance(obj/item, minify = FALSE)
	var/matrix/new_transform = new
	if(minify)
		new_transform.Scale(0.8, 0.8)
		item.transform = new_transform
		item.pixel_y = 2
		item.pixel_x = 0
		item.plane = FLOAT_PLANE -1
		item.layer = FLOAT_LAYER
	else
		new_transform.Scale(1, 1)
		item.transform = new_transform
		item.pixel_y = initial(item.pixel_y)
		item.pixel_x = initial(item.pixel_x)
		item.plane = initial(item.plane)
		item.layer = initial(item.layer)

/obj/item/borg/apparatus/sheet_manipulator/update_overlays()
	. = ..()
	var/mutable_appearance/arm = mutable_appearance(icon, "borg_stack_apparatus_arm1")
	if(stored)
		arm.icon_state = "borg_stack_apparatus_arm2"
		icon_state = "borg_stack_apparatus_arm1"
	else
		icon_state = "borg_stack_apparatus"
	. += arm

/obj/item/borg/apparatus/examine(mob/user)
	. = ..()
	if(stored)
		. += "<span class='notice'>It is holding [icon2html(stored, user)] [stored].</span>"
	. += span_notice("<i>Alt-click</i> will drop the currently held item. ")

/obj/item/robot_model/engineering/New()
	basic_modules += list(
		/obj/item/borg/cyborg_inducer
	)
	. = ..()

/obj/item/borg/apparatus/engineering/New()
	storable += list(
		/obj/item/circuitboard,
		/obj/item/stock_parts,
		/obj/item/assembly,
	)
	. = ..()
