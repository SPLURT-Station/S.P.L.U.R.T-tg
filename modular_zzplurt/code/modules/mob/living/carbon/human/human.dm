/mob/living/carbon/human
	/// Are we currently in combat focus?
	var/combat_focus = FALSE

/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/skirt_peeking)
	AddElement(/datum/element/mob_holder/micro)
	RegisterSignal(src, COMSIG_HUMAN_PREFS_APPLIED, PROC_REF(on_preference_applied))

/mob/living/carbon/human/Topic(href, href_list)
	. = ..()

	if(href_list["lookup_info"])
		switch(href_list["lookup_info"])
			if("genitals")
				var/list/line = list()
				for(var/obj/item/bodypart/body_part as anything in bodyparts)
					if(!is_body_part_exposed(body_part.body_part))
						continue
					if(body_part.written_text)
						line += "<span class='notice'>[p_They()] [p_have()] \"[html_encode(body_part.written_text)]\" written on [p_their()] [parse_zone(body_part.body_zone)].</span>"
				if(length(line))
					to_chat(usr, span_notice("[jointext(line, "\n")]"))

/mob/living/carbon/human/wash(clean_types)
	. = ..()
	for(var/obj/item/bodypart/body_part as anything in bodyparts)
		if(body_part.written_text)
			body_part.written_text = ""
	for(var/obj/item/organ/genital/genital in organs)
		if(genital.written_text)
			genital.written_text = ""

/mob/living/carbon/human/on_entered(datum/source, mob/living/carbon/human/moving)
	. = ..()
	if(istype(moving) && resting && resolve_intent_name(moving.combat_mode) != "help")
		moving.handle_micro_bump_other(src)
