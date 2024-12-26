/datum/interaction/lewd/fingerass_self
	description = "Finger yourself."
	interaction_sound = null
	required_from_user = INTERACTION_REQUIRE_HANDS
	required_from_user_exposed = INTERACTION_REQUIRE_ANUS
	interaction_flags = INTERACTION_FLAG_OOC_CONSENT | INTERACTION_FLAG_USER_IS_TARGET
	max_distance = 0
	write_log_user = "fingered self"
	write_log_target = null

/datum/interaction/lewd/fingerass_self/display_interaction(mob/living/user)
	var/t_His = user.p_their()
	var/t_Him = user.p_them()

	user.visible_message(span_lewd("<b>\The [user]</b> [pick(
		"fingers [t_Him]self.",
		"fingers [t_His] asshole.",
		"fingers [t_Him]self hard.")]"), ignored_mobs = user.get_unconsenting())
	playlewdinteractionsound(get_turf(user), 'modular_zzplurt/sound/interactions/champ_fingering.ogg', 50, 1, -1)
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_HAND, user)

/datum/interaction/lewd/finger_self
	description = "Finger your own pussy."
	required_from_user = INTERACTION_REQUIRE_HANDS
	required_from_user_exposed = INTERACTION_REQUIRE_VAGINA
	interaction_sound = null
	interaction_flags = INTERACTION_FLAG_OOC_CONSENT | INTERACTION_FLAG_USER_IS_TARGET
	max_distance = 0
	write_log_user = "fingered own pussy"
	write_log_target = null
	additional_details = list(
		INTERACTION_FILLS_CONTAINERS
	)

/datum/interaction/lewd/finger_self/display_interaction(mob/living/user)
	var/t_His = user.p_their()

	var/obj/item/reagent_containers/liquid_container

	var/obj/item/cached_item = user.get_active_held_item()
	if(istype(cached_item, /obj/item/reagent_containers))
		liquid_container = cached_item
	else
		cached_item = user.pulling
		if(istype(cached_item, /obj/item/reagent_containers))
			liquid_container = cached_item

	var/message = pick(
		"fingers [t_His] pussy deep",
		"fingers [t_His] pussy",
		"plays with [t_His] pussy",
		"fingers [t_His] own pussy hard")
	if(!user.is_fucking(user, CUM_TARGET_HAND, user.getorganslot(ORGAN_SLOT_VAGINA)))
		user.set_is_fucking(user, CUM_TARGET_HAND, user.getorganslot(ORGAN_SLOT_VAGINA))

	if(liquid_container)
		message += " over \the [liquid_container]"

	user.visible_message(span_lewd("<b>\The [user]</b> [message]."), ignored_mobs = user.get_unconsenting())
	playlewdinteractionsound(get_turf(user), 'modular_sand/sound/interactions/champ_fingering.ogg', 50, 1, -1)
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_HAND, liquid_container ? liquid_container : user)
