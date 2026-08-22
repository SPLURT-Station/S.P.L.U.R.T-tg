/obj/item/organ/genital/testicles/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	if(DNA.features["testicles_fluid"])
		internal_fluid_datum = DNA.features["testicles_fluid"]

// SPLURT pair/sheath DMIs use ADJ, Skyrat/Bubber DMIs use FRONT. Draw both so neither set is blank.
/datum/bodypart_overlay/mutant/genital/testicles
	layers = list(EXTERNAL_ADJACENT = BALLS_LAYER_FRONT, EXTERNAL_FRONT = BALLS_LAYER_FRONT, EXTERNAL_BEHIND = BODY_BEHIND_LAYER)
