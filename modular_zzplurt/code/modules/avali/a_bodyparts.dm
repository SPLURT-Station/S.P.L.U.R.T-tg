#define AVALI_BRUTE_MODIFIER 0.8
#define AVALI_BURN_MODIFIER 1.2
#define AVALI_PUNCH_LOW 2
#define AVALI_PUNCH_HIGH 6

/obj/item/bodypart/head/mutant/avali
	icon_greyscale = BODYPART_ICON_AVALI
	eyes_icon = 'modular_zzplurt/code/modules/avali/sprites/avali_eyes.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = SPECIES_AVALI
	brute_modifier = AVALI_BRUTE_MODIFIER
	burn_modifier = AVALI_BURN_MODIFIER
	head_flags = HEAD_EYESPRITES|HEAD_EYECOLOR|HEAD_EYEHOLES|HEAD_DEBRAIN

/obj/item/bodypart/chest/mutant/avali
	icon_greyscale = BODYPART_ICON_AVALI
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = SPECIES_AVALI
	brute_modifier = AVALI_BRUTE_MODIFIER
	burn_modifier = AVALI_BURN_MODIFIER

/obj/item/bodypart/arm/left/mutant/avali
	icon_greyscale = BODYPART_ICON_AVALI
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = SPECIES_AVALI
	unarmed_damage_low = AVALI_PUNCH_LOW
	unarmed_damage_high = AVALI_PUNCH_HIGH
	brute_modifier = AVALI_BRUTE_MODIFIER
	burn_modifier = AVALI_BURN_MODIFIER

/obj/item/bodypart/arm/right/mutant/avali
	icon_greyscale = BODYPART_ICON_AVALI
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = SPECIES_AVALI
	unarmed_damage_low = AVALI_PUNCH_LOW
	unarmed_damage_high = AVALI_PUNCH_HIGH
	brute_modifier = AVALI_BRUTE_MODIFIER
	burn_modifier = AVALI_BURN_MODIFIER

/obj/item/bodypart/leg/left/mutant/avali
	icon_greyscale = BODYPART_ICON_AVALI
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = SPECIES_AVALI
	digitigrade_type = /obj/item/bodypart/leg/left/digitigrade/avali
	brute_modifier = AVALI_BRUTE_MODIFIER
	burn_modifier = AVALI_BURN_MODIFIER

/obj/item/bodypart/leg/right/mutant/avali
	icon_greyscale = BODYPART_ICON_AVALI
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = SPECIES_AVALI
	digitigrade_type = /obj/item/bodypart/leg/right/digitigrade/avali
	brute_modifier = AVALI_BRUTE_MODIFIER
	burn_modifier = AVALI_BURN_MODIFIER

/obj/item/bodypart/leg/left/digitigrade/avali
	icon_greyscale = BODYPART_ICON_AVALI
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	base_limb_id = SPECIES_AVALI
	brute_modifier = AVALI_BRUTE_MODIFIER
	burn_modifier = AVALI_BURN_MODIFIER

/obj/item/bodypart/leg/right/digitigrade/avali
	icon_greyscale = BODYPART_ICON_AVALI
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	base_limb_id = SPECIES_AVALI
	brute_modifier = AVALI_BRUTE_MODIFIER
	burn_modifier = AVALI_BURN_MODIFIER
