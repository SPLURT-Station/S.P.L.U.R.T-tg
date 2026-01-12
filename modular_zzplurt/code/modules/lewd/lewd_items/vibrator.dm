// Plug13 integration for vibrator
// Uses defines from modular_skyrat's vibrator.dm - redefined here for compilation order safety
#define VIB_LOW "low"
#define VIB_MEDIUM "medium"
#define VIB_HIGH "hard"

/obj/item/clothing/sextoy/vibrator/process(seconds_per_tick)
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
		if(VIB_LOW)
			target.plug13_genital_emote(genital, PLUG13_STRENGTH_LOW, PLUG13_DURATION_SHORT)
		if(VIB_MEDIUM)
			target.plug13_genital_emote(genital, PLUG13_STRENGTH_NORMAL, PLUG13_DURATION_SHORT)
		if(VIB_HIGH)
			target.plug13_genital_emote(genital, PLUG13_STRENGTH_MEDIUM, PLUG13_DURATION_SHORT)

#undef VIB_LOW
#undef VIB_MEDIUM
#undef VIB_HIGH
