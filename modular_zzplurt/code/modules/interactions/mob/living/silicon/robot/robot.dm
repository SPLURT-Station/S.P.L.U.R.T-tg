/// Allows "cyborg" players to change gender at will
/mob/living/silicon/robot/verb/toggle_gender()
	set name = "Set Gender"
	set desc = "Allows you to set your gender."

	if(stat != CONSCIOUS)
		to_chat(usr, span_warning("You cannot toggle your gender while unconcious!"))
		return

	var/choice = tgui_alert(usr, "Select Gender.", "Gender", list("Both", "Male", "Female"))
	switch(choice)
		if("Both")
			has_penis = TRUE
			has_vagina = TRUE
		if("Male")
			has_penis = TRUE
			has_vagina = FALSE
		if("Female")
			has_penis = FALSE
			has_vagina = TRUE
