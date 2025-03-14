/obj/item/organ/genital/vagina/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	if(DNA.features["vagina_fluid"])
		internal_fluid_datum = DNA.features["vagina_fluid"]
