/obj/item/pen/attack(mob/living/M, mob/living/user, params)
	. = ..()

	if(!. || !istype(M) || !istype(user) || force || resolve_intent_name(user.combat_mode) == INTENT_HARM)
		return

	INVOKE_ASYNC(src, PROC_REF(write_on_bodypart), M, user, params) // Necessary because signals??????

/obj/item/pen/proc/write_on_bodypart(mob/living/M, mob/living/user, params)
	var/obj/item/bodypart/selected_bodypart = null

	var/list/obj/item/organ/genital/possible_genitals = list()
	for(var/genital_slot in GLOB.possible_genitals)
		var/obj/item/organ/genital/ORG = M.get_organ_slot(genital_slot)
		if(ORG?.bodypart_overlay.sprite_datum.is_hidden(M))
			continue
		possible_genitals += ORG

	if(length(possible_genitals))
		selected_bodypart = tgui_input_list(user, "Select a genital to write on (or none to write on [user == M ? "your" : "[M]'s"] [user.zone_selected])", "Bodywriting", possible_genitals)

	if(!selected_bodypart)
		var/obj/item/bodypart/BP = M.get_bodypart(user.zone_selected)
		if(!BP)
			return
		selected_bodypart = M.is_body_part_exposed(BP.body_part) ? BP : null

	if(!selected_bodypart)
		return

	var/writing = tgui_input_text(user, "Add writing, doesn't replace current text", "Writing on [selected_bodypart.name]")
	if(!writing)
		return
	to_chat(user, span_notice("You write [writing] on [user == M ? "your" : "[M]'s"] [selected_bodypart.name]."))
	selected_bodypart.written_text += writing
