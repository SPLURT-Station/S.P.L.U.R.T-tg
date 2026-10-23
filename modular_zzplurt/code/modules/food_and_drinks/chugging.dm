/obj/item/reagent_containers/cup
	var/beingChugged = FALSE // For checking

/obj/item/reagent_containers/cup/try_drink(mob/living/target_mob, mob/living/user, obj/target)
	var/original_gulp_size = gulp_size

	if(!canconsume(target_mob, user))
		return ..()

	if(!is_drainable())
		return ..()

	if(!reagents || !reagents.total_volume)
		return ..()

	/* //already being checked in canconsume
	if(!istype(target_mob))
		return ..()
	*/

	if(target_mob == user && user.zone_selected == BODY_ZONE_PRECISE_MOUTH && !beingChugged)
		beingChugged = TRUE
		user.visible_message(span_notice("[user] starts chugging [src]."), \
			span_notice("You start chugging [src]."))
		if(!do_after(user, 3 SECONDS, target_mob))
			beingChugged = FALSE
			return
		if(!reagents || !reagents.total_volume)
			beingChugged = FALSE
			return
		gulp_size = 50
		user.visible_message(span_notice("[user] chugs [src]."), \
			span_notice("You chug [src]."))
		beingChugged = FALSE

	. = ..()

	gulp_size = original_gulp_size
