/mob/living/silicon/robot
	var/genital_sheath_visible = FALSE
	var/genital_balls_visible = FALSE
	var/genital_vagina_visible = FALSE

/mob/living/silicon/robot/verb/toggle_genital_sheath()
	set name = "Toggle Sheath"
	set category = "IC"
	set desc = "Toggle the visibility of your sheath."

	if(stat == DEAD)
		return

	genital_sheath_visible = !genital_sheath_visible
	to_chat(src, span_notice("You [genital_sheath_visible ? "extend" : "retract"] your sheath."))
	update_genitals()

/mob/living/silicon/robot/verb/toggle_genital_balls()
	set name = "Toggle Balls"
	set category = "IC"
	set desc = "Toggle the visibility of your balls."

	if(stat == DEAD)
		return

	genital_balls_visible = !genital_balls_visible
	to_chat(src, span_notice("You [genital_balls_visible ? "extend" : "retract"] your balls."))
	update_genitals()

/mob/living/silicon/robot/verb/toggle_genital_vagina()
	set name = "Toggle Vagina"
	set category = "IC"
	set desc = "Toggle the visibility of your vagina."

	if(stat == DEAD)
		return

	genital_vagina_visible = !genital_vagina_visible
	to_chat(src, span_notice("You [genital_vagina_visible ? "open" : "close"] your vagina."))
	update_genitals()

/mob/living/silicon/robot/proc/update_genitals()
	cut_overlays()
	var/list/overlays_to_add = list()
	
	if(genital_sheath_visible)
		var/mutable_appearance/sheath_overlay = mutable_appearance('icons/mob/silicon/robot_genitals.dmi', "sheath")
		overlays_to_add += sheath_overlay
	
	if(genital_balls_visible)
		var/mutable_appearance/balls_overlay = mutable_appearance('icons/mob/silicon/robot_genitals.dmi', "balls")
		overlays_to_add += balls_overlay
	
	if(genital_vagina_visible)
		var/mutable_appearance/vagina_overlay = mutable_appearance('icons/mob/silicon/robot_genitals.dmi', "vagina")
		overlays_to_add += vagina_overlay
	
	if(overlays_to_add.len)
		add_overlay(overlays_to_add)

/mob/living/silicon/robot/update_icons()
	. = ...()
	update_genitals()