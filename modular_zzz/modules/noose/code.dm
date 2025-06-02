/obj/structure/chair/noose
	name = "noose"
	desc = "The noose suspended from... Do we even have a ceiling?"
	icon_state = "noose"
	icon = 'modular_zzz/icons/noose/objects.dmi'
	layer = FLY_LAYER
	var/image/over

/obj/structure/chair/noose/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/wirecutters))
		user.visible_message("[user] cuts the noose.", span_notice("Cutting the noose."))
		if(has_buckled_mobs())
			for(var/m in buckled_mobs)
				var/mob/living/buckled_mob = m
				if(buckled_mob.has_gravity())
					buckled_mob.visible_message(span_danger("[buckled_mob] falls to the floor!") ,\
						span_userdanger("Falling to the floor!"))
					buckled_mob.adjustBruteLoss(10)
		var/obj/item/stack/cable_coil/C = new(get_turf(src))
		C.amount = 25
		qdel(src)
		return
	..()

/obj/structure/chair/noose/Initialize(mapload)
	. = ..()
	pixel_y += 16
	over = image(icon, "noose_overlay")
	over.layer = FLY_LAYER
	add_overlay(over)

/obj/structure/chair/noose/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/chair/noose/post_buckle_mob(mob/living/M)
	if(has_buckled_mobs())
		src.layer = MOB_LAYER
		START_PROCESSING(SSobj, src)
		M.dir = SOUTH
		animate(M, pixel_y = initial(pixel_y) + 8, time = 8, easing = LINEAR_EASING)
	else
		layer = initial(layer)
		STOP_PROCESSING(SSobj, src)
		M.pixel_x = initial(M.pixel_x)
		pixel_x = initial(pixel_x)
		M.pixel_y = M.base_pixel_y

/obj/structure/chair/noose/user_unbuckle_mob(mob/living/M,mob/living/user)
	if(has_buckled_mobs())
		if(M != user && user)
			user.visible_message(span_notice("[user] starts loosing the noose around [M]'s neck...") ,\
				span_notice("Starting to loosen the noose around [M]'s neck..."))
			if(!do_after(user, 100, M))
				return
			user.visible_message(span_notice("[user] loosed the noose around [M]'s neck!") ,\
				span_notice("loosed the noose around [M]'s neck!"))
		else
			M.visible_message(\
				span_warning("[M] twitches, wanting to get out of the noose!") ,\
				span_notice("Twitching, wanting to get out of the noos..."))
			if(!do_after(M, 150, target = src))
				if(M && M.buckled)
					to_chat(M, span_warning("I CAN'T!"))
				return
			if(!M.buckled)
				return
			M.visible_message(\
				span_warning("[user] removes the noose from [M]'s neck.") ,\
				span_notice("Removing the noose from my neck!"))
			M.Knockdown(60)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			H.noosed = FALSE
		unbuckle_all_mobs(force=1)
		M.pixel_z = initial(M.pixel_z)
		pixel_z = initial(pixel_z)
		add_fingerprint(user)

/obj/structure/chair/noose/user_buckle_mob(mob/living/carbon/human/M, mob/user, check_loc = TRUE)
	if(!in_range(user, src) || user.stat || !iscarbon(M))
		return FALSE

	if (!M.get_bodypart("head"))
		to_chat(user, span_warning("[M] without a head!"))
		return FALSE

	if(M.loc != src.loc)
		return FALSE //Работает в одном тайтле.

	add_fingerprint(user)

	M.visible_message(\
		span_danger("[user] tries to put a noose around [M]'s neck!"),\
		span_userdanger("[user] trying to put a noose around my neck!"))
	if(user != M)
		to_chat(user, span_notice("It will take some time..."))
	if(do_after(user, user == M ? 10:100, M))
		if(buckle_mob(M))
			user.visible_message(span_warning("[user] hangs [M != user ? "[M]" : "yourself"]!"),\
				span_userdanger("[M != user ? "[user] hangs me" : "Hanging myself"]!"))
			playsound(user.loc, 'modular_zzz/sounds/noose/noosed.ogg', 50, 1, -1)
			log_combat(user, M, "hanged", src)
			M.noosed = TRUE
			return TRUE
	user.visible_message(span_warning("[user] can't put a noose around [M]'s neck!"),\
		span_warning("Can't get the noose around [M]'s neck!"))
	log_combat(user, M, "tried to hang", src)
	return FALSE


/obj/structure/chair/noose/process()
	if(!has_buckled_mobs())
		STOP_PROCESSING(SSobj, src)
		return
	for(var/m in buckled_mobs)
		var/mob/living/buckled_mob = m
		if(pixel_x >= 0)
			animate(src, pixel_x = -3, time = 45, easing = ELASTIC_EASING)
			animate(m, pixel_x = -3, time = 45, easing = ELASTIC_EASING)
		else
			animate(src, pixel_x = 3, time = 45, easing = ELASTIC_EASING)
			animate(m, pixel_x = 3, time = 45, easing = ELASTIC_EASING)
		if(buckled_mob.has_gravity())
			if(!buckled_mob.get_bodypart(BODY_ZONE_HEAD))
				unbuckle_all_mobs(TRUE)
				STOP_PROCESSING(SSobj, src)
				return
			buckled_mob.adjustOxyLoss(5)
			if(prob(40) && buckled_mob.stat == CONSCIOUS)
				buckled_mob.emote("gasp")
			if(prob(20))
				var/flavor_text = list(span_suicide("[buckled_mob] twitches [buckled_mob.p_their()] legs in agony.") ,\
					span_suicide("[buckled_mob] trying to get out of the loop, twitching merrily.") ,\
					span_suicide("[buckled_mob] sways back and forth, gradually slowing down."))
				if(buckled_mob.stat == DEAD)
					flavor_text = list(span_suicide("[buckled_mob] swings sluggishly on a noose.") ,\
						span_suicide("[buckled_mob]'s gaze is directed into emptiness."))
				if(prob(5))
					buckled_mob.visible_message(pick(flavor_text))
				playsound(buckled_mob.loc, 'modular_zzz/sounds/noose/noose_idle.ogg', 30, 1, -3)

/mob/living/carbon/human
	var/noosed = FALSE

/mob/living/carbon/human/proc/checknoosedrop()
	if(noosed)
		for(var/obj/structure/chair/noose/noose in loc)
			noose.unbuckle_all_mobs(force = 1)
