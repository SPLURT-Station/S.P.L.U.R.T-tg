#define MOVEDELAY_ANGRY 3.8 //movespeed buff due to armor slowdown - originally 4.5
#define MOVEDELAY_SAFETY 2.12 //movespeed buff due to armor slowdown - originally 2.5

/obj/vehicle/sealed/mecha/justice
	movedelay = MOVEDELAY_SAFETY

/obj/vehicle/sealed/mecha/justice/set_safety(mob/user)
	. = ..()

	if(weapons_safety)
		movedelay = MOVEDELAY_SAFETY
	else
		movedelay = MOVEDELAY_ANGRY

	update_equipment_slowdown()

/datum/armor/mecha_justice
	melee = 15 //original: 30
	bullet = 10 //original: 20
	laser = 10 //original: 20

#undef MOVEDELAY_ANGRY
#undef MOVEDELAY_SAFETY
