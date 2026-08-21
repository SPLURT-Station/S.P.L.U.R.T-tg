/obj/item/organ/genital/anus/get_description_string(datum/sprite_accessory/genital/gas)
	var/u_His = owner?.p_their() || "their"
	var/anus_style = gas ? LOWER_TEXT(gas.icon_state) : LOWER_TEXT(genital_name)

	desc = "You see [u_His] squishy [anus_style] pucker parting [u_His] asscheeks"

/obj/item/organ/genital/anus/get_sprite_size_string()
	. = "[genital_type]_[floor(genital_size)]"
	if(uses_skintones)
		. += "_s"

/obj/item/organ/genital/anus/build_from_dna(datum/dna/DNA, associated_key)
	set_size(DNA.features["butt_size"]) // yes
	uses_skin_color = DNA.features["anus_uses_skincolor"]

	return ..()

/datum/bodypart_overlay/mutant/genital/anus
	layers = EXTERNAL_FRONT

/datum/bodypart_overlay/mutant/genital/anus/get_image(image_layer, obj/item/bodypart/limb)
	if(!sprite_datum)
		CRASH("Trying to call get_image() on [type] while it didn't have a sprite_datum. This shouldn't happen, report it as soon as possible.")

	var/gender = limb?.limb_gender || "m"
	var/list/icon_state_builder = list()
	icon_state_builder += sprite_datum.gender_specific ? gender : "m"
	icon_state_builder += feature_key
	icon_state_builder += get_base_icon_state()
	icon_state_builder += mutant_bodyparts_layertext(image_layer)
	icon_state_builder += "primary"

	return mutable_appearance(sprite_datum.icon, icon_state_builder.Join("_"), layer = image_layer)
