/obj/item/reagent_containers/attack(mob/living/target_mob, mob/living/user, obj/target)
	var/original_gulp_size = gulp_size

	if(!canconsume(target_mob, user))
		return ..()

	if(!spillable)
		return ..()

	if(!reagents || !reagents.total_volume)
		return ..()

	if(!istype(target_mob))
		return ..()

	if(target_mob == user && user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		user.visible_message("<span class='notice'>[user] starts chugging [src].</span>", \
			"<span class='notice'>You start chugging [src].</span>")
		if(!do_after(user, 3 SECONDS, target_mob))
			return
		if(!reagents || !reagents.total_volume)
			return
		gulp_size = reagents.total_volume
		user.visible_message(span_notice("[user] chugs [src]."), \
			span_notice("You chug [src]."))

	. = ..()

	gulp_size = original_gulp_size
