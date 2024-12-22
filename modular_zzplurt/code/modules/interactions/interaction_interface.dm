/mob/proc/try_interaction()
	return

/*
/mob/living/carbon/human/MouseDrop(var/mob/living/carbon/human/dropped_on, mob/living/carbon/human/user as mob)
	if(src != dropped_on && !src.restrained())
		try_interaction(dropped_on)
		return
	return ..()
*/

/mob/living/silicon/robot/verb/toggle_gender() //Change to add silicon genderchanges. Experimental.
	set category = "IC"
	set name = "Set Gender"
	set desc = "Allows you to set your gender."
	if(stat != CONSCIOUS)
		to_chat(usr, "<span class='warning'>You cannot toggle your gender while unconcious!</span>")
		return

	var/choice = alert(src, "Select Gender.", "Gender", "Both", "Male", "Female")
	switch(choice)
		if("Both")
			src.has_penis = TRUE
			src.has_vagina = TRUE
		if("Male")
			src.has_penis = TRUE
			src.has_vagina = FALSE
		if("Female")
			src.has_penis = FALSE
			src.has_vagina = TRUE

/mob/living/carbon/human/click_ctrl_shift(mob/user) //We have to remove the can_interact check from humans.
	user.try_interaction(src)
	return

/mob/living/verb/interact_with()
	set name = "Interact With"
	set desc = "Perform an interaction with someone."
	set category = "IC"
	set src in view()

	usr.mind.interaction_holder.target = src
	if(!usr.mind.interaction_holder.self)
		usr.mind.interaction_holder.self = usr
	usr.mind.interaction_holder.ui_interact(usr)

/*
/atom/movable/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(can_buckle && buckled_mob)
		if(user_unbuckle_mob(user))
			return 1
/atom/movable/MouseDrop_T(mob/living/carbon/human/M, mob/living/carbon/human/user)
	. = ..()
	if(can_buckle && istype(M) && !buckled_mob)
		if(user_buckle_mob(M, user))
			return 1
*/

/datum/mind
	var/datum/interaction_menu/interaction_holder

/datum/mind/New(key)
	. = ..()
	interaction_holder = new(src)

/datum/interaction_menu
	var/mob/living/self
	var/mob/living/target

/datum/interaction_menu/ui_state(mob/user)
	return GLOB.conscious_state

/datum/interaction_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MobInteraction", "Interactions")
		ui.open()

/datum/interaction_menu/ui_data(mob/user)
	var/list/data = list()
	data["isTargetSelf"] = target == self
	data["interactingWith"] = target != self ? "Interacting with \the [target]..." : "Interacting with yourself..."
	data["selfAttributes"] = self.list_interaction_attributes(self)
	if(target != self)
		data["theirAttributes"] = target.list_interaction_attributes(self)

	make_interactions()
	var/list/sent_interactions = list()
	for(var/interaction_key in interactions)
		var/datum/interaction/I = interactions[interaction_key]
		if(I.evaluate_user(self, action_check = FALSE) && I.evaluate_target(self, target))
			if(I.user_is_target == TRUE && target != self)
				continue
			var/list/interaction = list()
			interaction += I.command
			interaction += I.description
			if(istype(I, /datum/interaction/lewd))
				var/datum/interaction/lewd/O = I
				if(O.extreme)
					interaction += 2
				else
					interaction += 1
			else
				interaction += 0
			sent_interactions += list(interaction)
	data["interactions"] = sent_interactions

	return data

/datum/interaction_menu/ui_act(action, params)
	if(..())
		return
	if(action)
		for(var/i in interactions)
			var/datum/interaction/o = interactions[i]
			if(o.command == action)
				o.do_action(self, target)
				return TRUE
	else
		stack_trace("[self] used action [action ? action : "null"] on [target]")
