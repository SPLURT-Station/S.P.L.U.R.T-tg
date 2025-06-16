/obj/structure/mystery_box/fishing/activate(mob/living/user)
	if(SEND_SIGNAL(src, COMSIG_FISHING_MYSTERY_BOX_ACTIVATE, user) & COMPONENT_CANCEL_MYSTERY_BOX)
		return
	return ..()
