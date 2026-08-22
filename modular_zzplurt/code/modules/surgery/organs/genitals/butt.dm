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
