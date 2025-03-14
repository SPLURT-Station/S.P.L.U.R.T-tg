/obj/item/organ/genital
	var/always_accessible = FALSE

/obj/item/organ/genital/is_exposed()
	if(always_accessible)
		return TRUE
	return ..()

/obj/item/organ/genital/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	internal_fluid_maximum = internal_fluid_maximum * (DNA.features["body_size"] || 1)

/datum/bodypart_overlay/mutant/genital
	var/layer_offset = 0

/datum/bodypart_overlay/mutant/genital/bitflag_to_layer(layer)
	. = ..()
	. -= layer_offset

/datum/bodypart_overlay/mutant/genital/mutant_bodyparts_layertext(layer)
	layer += layer_offset
	. = ..()

/datum/bodypart_overlay/mutant/genital/penis
	layer_offset = PENIS_LAYER_OFFSET

/datum/bodypart_overlay/mutant/genital/vagina
	layer_offset = VAGINA_LAYER_OFFSET

/datum/bodypart_overlay/mutant/genital/testicles
	layer_offset = TESTICLES_LAYER_OFFSET

/datum/bodypart_overlay/mutant/genital/womb
	layer_offset = VAGINA_LAYER_OFFSET

/datum/bodypart_overlay/mutant/genital/anus
	layer_offset = ANUS_LAYER_OFFSET

/datum/bodypart_overlay/mutant/genital/breasts
	layer_offset = BREASTS_LAYER_OFFSET

/datum/bodypart_overlay/mutant/genital/belly
	layer_offset = BELLY_LAYER_OFFSET

/datum/bodypart_overlay/mutant/genital/butt
	layer_offset = BUTT_LAYER_OFFSET


