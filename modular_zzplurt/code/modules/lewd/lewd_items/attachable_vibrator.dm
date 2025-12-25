// Plug13 integration for vibrating egg
// Uses defines from modular_skyrat's attachable_vibrator.dm - redefined here for compilation order safety
#define EGGVIB_LOW "low"
#define EGGVIB_MEDIUM "medium"
#define EGGVIB_HIGH "high"

/obj/item/clothing/sextoy/eggvib/process(seconds_per_tick)
	. = ..()
	if(!toy_on)
		return
	var/mob/living/carbon/human/target = loc
	if(!istype(target))
		return
	var/obj/item/organ/genital/genital = target.get_organ_slot(current_equipped_slot)
	if(!genital)
		return
	switch(vibration_mode)
		if(EGGVIB_LOW)
			target.plug13_genital_emote(genital, PLUG13_STRENGTH_LOW, PLUG13_DURATION_SHORT)
		if(EGGVIB_MEDIUM)
			target.plug13_genital_emote(genital, PLUG13_STRENGTH_NORMAL, PLUG13_DURATION_SHORT)
		if(EGGVIB_HIGH)
			target.plug13_genital_emote(genital, PLUG13_STRENGTH_MEDIUM, PLUG13_DURATION_SHORT)

#undef EGGVIB_LOW
#undef EGGVIB_MEDIUM
#undef EGGVIB_HIGH
