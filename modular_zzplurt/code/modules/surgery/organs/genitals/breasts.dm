/obj/item/organ/genital/breasts/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	if(DNA.features["breasts_fluid"])
		internal_fluid_datum = DNA.features["breasts_fluid"]
