//SPLURT EDIT - Flavor-only override on upstream /obj/item/organ/genital/butt
/obj/item/organ/genital/butt
	icon = 'modular_zzplurt/icons/obj/medical/organs/butt.dmi'

/obj/item/organ/genital/butt/get_description_string(datum/sprite_accessory/genital/gas)
	var/size_name
	var/butt_style = gas ? LOWER_TEXT(gas.icon_state) : LOWER_TEXT(genital_name)
	switch(round(genital_size))
		if(1)
			size_name = "average"
		if(2)
			size_name = "sizable"
		if(3)
			size_name = "squeezable"
		if(4)
			size_name = "hefty"
		if(5)
			size_name = pick("massive", "very generous")
		if(6)
			size_name = pick("gigantic", "big bubbly", "enormous")
		if(7)
			size_name = pick("unfathomably large", "extreme")
		if(8)
			size_name = pick("absolute dumptruck", "humongous", "dummy thick")
		else
			size_name = "nonexistent"

	return "You see a [butt_style] of [size_name] asscheeks."

/datum/bodypart_overlay/mutant/genital/butt/get_overlay(obj/item/bodypart/limb, layer_index, layer_real)
	. = ..()
	var/mob/living/carbon/human/wearer = limb?.owner
	var/is_tesh = (limb?.limb_id == SPECIES_TESHARI) || (wearer && isteshari(wearer))
	if(!is_tesh || !islist(.))
		return .

	var/tesh_behind_layer = (layer_index == EXTERNAL_ADJACENT && !istype(wearer?.wear_suit, /obj/item/clothing/suit/mod)) ? -(BODY_BEHIND_LAYER + BUTT_LAYER_OFFSET) : null
	for(var/mutable_appearance/butt_appearance as anything in .)
		butt_appearance.pixel_z -= 3
		if(!isnull(tesh_behind_layer))
			butt_appearance.layer = tesh_behind_layer

/datum/bodypart_overlay/mutant/genital/butt/icon_render_key(obj/item/bodypart/limb)
	. = ..()
	if((limb?.limb_id == SPECIES_TESHARI) || (limb?.owner && isteshari(limb.owner)))
		. += "teshari"

