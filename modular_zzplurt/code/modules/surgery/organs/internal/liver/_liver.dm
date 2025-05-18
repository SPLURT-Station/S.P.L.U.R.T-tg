/obj/item/organ/liver/examine(mob/user)
	. = ..()

	if(HAS_MIND_TRAIT(user, TRAIT_ENTRAILS_READER) || isobserver(user))
		if(HAS_TRAIT(src, TRAIT_CARGO_METABOLISM))
			. += span_info("The liver is dotted with ripped chunks of cardboard and wrapping paper, implying this is what remains of a <em>cargonian</em>'s liver.")
