//Dildo changes.
/obj/item/dildo
	var/hole = CUM_TARGET_VAGINA

/obj/item/dildo/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	var/possessive_verb = user.p_their()
	var/message = ""
	var/lust_amt = 0
	var/organ //SPLURT edit

	if(ishuman(M) && (M?.client?.prefs?.toggles & VERB_CONSENT))
		switch(user.zone_selected)
			if(BODY_ZONE_PRECISE_GROIN)
				switch(hole)
					if(CUM_TARGET_VAGINA)
						var/has_vagina = M.has_vagina()
						if(has_vagina == TRUE || has_vagina == HAS_EXPOSED_GENITAL)
							message = (user == M) ? pick("fucks [possessive_verb] own pussy with \the [src]","shoves \the [src] into [possessive_verb] pussy", "jams \the [src] into [possessive_verb] pussy") : pick("fucks [M] right in the pussy with \the [src]", "jams \the [src] right into [M]'s pussy")
							lust_amt = NORMAL_LUST
							organ = CUM_TARGET_VAGINA //SPLURT edit
					if(CUM_TARGET_ANUS)
						var/has_anus = M.has_anus()
						if(has_anus == TRUE || has_anus == HAS_EXPOSED_GENITAL)
							message = (user == M) ? pick("fucks [possessive_verb] own ass with \the [src]","shoves \the [src] into [possessive_verb] ass", "jams \the [src] into [possessive_verb] ass") : pick("fucks [M]'s asshole with \the [src]", "jams \the [src] into [M]'s ass")
							lust_amt = NORMAL_LUST
							organ = CUM_TARGET_ANUS //SPLURT edit
			if(BODY_ZONE_PRECISE_MOUTH)
				if(M.has_mouth() && !M.is_mouth_covered())
					message = (user == M) ? pick("fucks [possessive_verb] own mouth with \the [src]", "shoves \the [src] into [possessive_verb] mouth", "jams \the [src] into [possessive_verb] mouth") : pick("fucks [M]'s mouth with \the [src]", "jams \the [src] into [M]'s mouth")
	if(message)
		user.visible_message(span_lewd("[user] [message]."))
		M.handle_post_sex(lust_amt, null, user, organ) //SPLURT edit
		playsound(loc, pick('modular_sand/sound/interactions/bang4.ogg',
							'modular_sand/sound/interactions/bang5.ogg',
							'modular_sand/sound/interactions/bang6.ogg'), 70, 1, -1)
	else if(user.a_intent == INTENT_HARM)
		return ..()

/obj/item/dildo/attack_self(mob/living/carbon/human/user as mob)
	hole = hole == CUM_TARGET_VAGINA ? CUM_TARGET_ANUS : CUM_TARGET_VAGINA
	to_chat(user, span_notice("Now targetting \the [hole]."))

//begin redds code
/obj/item/dildo/cyborg
	name = "F.I.S.T.R. Machine"
	desc = "Fully Integrated Sexual Tension Relief Machine"
//end redds code

/obj/item/pneumatic_cannon/dildo
	color = "#FFC0CB"
	name = "pneumatic cannon"
	desc = "A pneumatic cannon with a picture of a bus printed on the side that resembles an A-shape."
	automatic = TRUE
	selfcharge = TRUE
	gasPerThrow = 0
	checktank = FALSE
	fire_mode = PCANNON_FIFO
	throw_amount = 1
	maxWeightClass = 60
	var/static/list/dildo_typecache = typecacheof(/obj/item/dildo)
	charge_type = /obj/item/dildo

/obj/item/pneumatic_cannon/dildo/Initialize(mapload)
	. = ..()
	allowed_typecache = dildo_typecache
