//basically an altered ability of the ice demon teleport

/datum/action/cooldown/mob_cooldown/spriggan_teleport
	name = "Bluespace Teleport"
	desc = "Teleport towards a destination target!"
	button_icon = 'icons/obj/ore.dmi'
	button_icon_state = "bluespace_crystal"
	cooldown_time = 15 SECONDS
	///time delay before teleport
	var/time_delay = 3 SECONDS

/datum/action/cooldown/mob_cooldown/spriggan_teleport/Activate(atom/target_atom)
	if(isclosedturf(get_turf(target_atom)))
		owner.balloon_alert(owner, "blocked!")
		return FALSE
	animate(owner, transform = matrix().Scale(0.8), time = time_delay, easing = SINE_EASING, flags = ANIMATION_PARALLEL)
	if(!do_after(owner, time_delay, null))
		animate(owner, transform = matrix(), time = 0)
		return FALSE
	teleport_to_turf(target_atom)
	StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/spriggan_teleport/proc/teleport_to_turf(atom/target)
	animate(owner, transform = matrix(), time = 3 SECONDS, easing = SINE_EASING, flags = ANIMATION_PARALLEL)
	do_teleport(teleatom = owner, destination = target, channel = TELEPORT_CHANNEL_BLUESPACE, forced = TRUE)

/datum/action/cooldown/mob_cooldown/spriggan_sight

	name = "Clerical Sight"
	desc = "Grants the ability to see through walls and other obstacles."
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "adjust_vision"
	cooldown_time = 5 SECONDS
	click_to_activate = FALSE
	shared_cooldown = NONE
	var/sight_enabled = FALSE

/datum/action/cooldown/mob_cooldown/spriggan_sight/Activate(atom/target_atom)
	sight_enabled = !sight_enabled
	if(sight_enabled)
		owner.sight = SEE_TURFS | SEE_MOBS
		owner.lighting_cutoff_red = 15
		owner.lighting_cutoff_green = 55
		owner.lighting_cutoff_blue = 20
		owner.balloon_alert(owner, "you can now see in the dark and through walls!")
		StartCooldown()
	else
		owner.sight = initial(owner.sight)
		owner.lighting_cutoff_red = initial(owner.lighting_cutoff_red)
		owner.lighting_cutoff_green = initial(owner.lighting_cutoff_green)
		owner.lighting_cutoff_blue = initial(owner.lighting_cutoff_blue)
		owner.balloon_alert(owner, "your clerical sight fades.")
	owner.update_sight()
	return TRUE

/datum/action/cooldown/mob_cooldown/spriggan_light
	name = "Leading Light"
	desc = "Emits a dim green glow around us."
	button_icon = 'icons/ui_icons/antags/heretic/knowledge.dmi'
	button_icon_state = "node_slide"
	cooldown_time = 5 SECONDS
	click_to_activate = FALSE
	shared_cooldown = NONE
	var/light_enabled = FALSE

/datum/action/cooldown/mob_cooldown/spriggan_light/Activate(atom/target_atom)
	light_enabled = !light_enabled
	if(light_enabled)
		owner.set_light(l_range = 3, l_power = 1.5, l_color = LIGHT_COLOR_ELECTRIC_GREEN, l_on = TRUE)
		owner.balloon_alert(owner, "you emit a dim green glow.")
		StartCooldown()
	else
		owner.set_light(l_range = 0)
		owner.balloon_alert(owner, "your dim green glow fades.")
	return TRUE
