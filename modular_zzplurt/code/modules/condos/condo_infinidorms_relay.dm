/// Infinidorm relay – looks like the real cafe_condo_teleporter but routes
/// all interactions to the true hotel ball on the same map.
/obj/machinery/cafe_condo_teleporter/relay
	name = "infinidorm relay"
	desc = "A shimmering relay that links directly to the main infinidorm network."

/obj/machinery/cafe_condo_teleporter/relay/attack_hand(mob/living/user, list/modifiers)
	var/obj/machinery/cafe_condo_teleporter/real_ball = locate(/obj/machinery/cafe_condo_teleporter) in world
	if(!real_ball || real_ball == src)
		to_chat(user, span_warning("The relay pulses faintly, but you can't sense the main hotel network."))
		return
	real_ball.ui_interact(user)
