/datum/augment_item/implant
	category = AUGMENT_CATEGORY_IMPLANTS

/datum/augment_item/implant/apply(mob/living/carbon/human/H, character_setup = FALSE, datum/preferences/prefs)
	if(character_setup)
		return
	var/obj/item/organ/new_organ = new path()
	new_organ.Insert(H,FALSE,FALSE)

//BRAIN IMPLANTS
/datum/augment_item/implant/brain
	slot = AUGMENT_SLOT_BRAIN_IMPLANT

//CHEST IMPLANTS
/datum/augment_item/implant/chest
	slot = AUGMENT_SLOT_CHEST_IMPLANT

//LEFT ARM IMPLANTS
/datum/augment_item/implant/l_arm
	slot = AUGMENT_SLOT_LEFT_ARM_IMPLANT

/datum/augment_item/implant/l_arm/razor_claws
	name = "Left Razor Claws"
	cost = 4
	path = /obj/item/organ/cyberimp/arm/toolkit/razor_claws/left_arm

/datum/augment_item/implant/l_arm/rope
	name = "Left Climbing Hook"
	cost = 1
	path = /obj/item/organ/cyberimp/arm/toolkit/rope/left_arm

//RIGHT ARM IMPLANTS
/datum/augment_item/implant/r_arm
	slot = AUGMENT_SLOT_RIGHT_ARM_IMPLANT

/datum/augment_item/implant/r_arm/razor_claws
	name = "Right Razor Claws"
	cost = 4
	path = /obj/item/organ/cyberimp/arm/toolkit/razor_claws/right_arm

/datum/augment_item/implant/r_arm/rope
	name = "Right Climbing Hook"
	cost = 1
	path = /obj/item/organ/cyberimp/arm/toolkit/rope/right_arm

//EYES IMPLANTS
/datum/augment_item/implant/eyes
	slot = AUGMENT_SLOT_EYES_IMPLANT

/datum/augment_item/implant/eyes/civhud
	name = "Civilian HUD Implant"
	cost = 4
	path = /obj/item/organ/cyberimp/eyes/hud/civilian

//MOUTH IMPLANTS
/datum/augment_item/implant/mouth
	slot = AUGMENT_SLOT_MOUTH_IMPLANT

/datum/augment_item/implant/mouth/breathing_tube
	name = "Breathing Tube"
	cost = 2
	path = /obj/item/organ/cyberimp/mouth/breathing_tube
