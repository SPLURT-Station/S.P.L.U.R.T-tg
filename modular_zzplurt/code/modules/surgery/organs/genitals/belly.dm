//SPLURT EDIT - Flavor-only override on upstream /obj/item/organ/genital/belly
/obj/item/organ/genital/belly/get_description_string(datum/sprite_accessory/genital/gas)
	var/size_name
	switch(round(genital_size))
		if(1)
			size_name = "average"
		if(2)
			size_name = "round"
		if(3)
			size_name = "squishable"
		if(4)
			size_name = "fat"
		if(5)
			size_name = "sagging"
		if(6)
			size_name = "gigantic"
		if(7 to INFINITY)
			size_name = pick("massive", "unfathomably bulging", "enormous", "very generous", "humongous", "big bubbly")
		else
			size_name = "nonexistent"

	desc = "You see a [size_name] [round(genital_size) >= 4 ? "belly, it bounces around and gurgles as [owner] walks" : "belly in [owner?.p_their() ? owner?.p_their() : "their"] midsection"]."
