/obj/item/organ/genital
	var/always_accessible = FALSE
	var/written_text = ""

/obj/item/organ/genital/is_exposed()
	if(always_accessible)
		return TRUE
	return ..()

/obj/item/organ/genital/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	var/size_mod = 1
	if(DNA?.holder)
		size_mod = get_size(DNA.holder) || 1
	internal_fluid_maximum = internal_fluid_maximum * size_mod

// Layer offsets for genitals are defined upstream in modular_skyrat genitals.dm
