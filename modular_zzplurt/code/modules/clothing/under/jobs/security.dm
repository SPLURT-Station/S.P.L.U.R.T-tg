// SKYRAT, BUT REDSEC UNIFORMS INSTEAD.

// SECURITY OFFICER
/obj/item/clothing/under/rank/security/suit
	name = "security suit"
	desc = "A sleek, formal three-piece suit with a red suit jacket dawned with security insignia, not guaranteed to be good to run in!"
	icon = 'modular_zzplurt/icons/obj/clothing/under/security.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/under/security.dmi'
	icon_state = "security_suit"
	can_adjust = TRUE
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/rank/security/peacekeeper/trousers
	name = "security trousers"
	desc = "Some security combat trousers. Probably should pair it with a vest for safety."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/under/security.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/under/security.dmi'
	icon_state = "workpants_red"
	body_parts_covered = GROIN|LEGS
	can_adjust = FALSE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	female_sprite_flags = FEMALE_UNIFORM_NO_BREASTS

/obj/item/clothing/under/rank/security/trousers/shorts
	name = "security shorts"
	desc = "Some security combat shorts. Definitely should pair it with a vest for safety."
	icon_state = "workshorts_red"

/obj/item/clothing/under/rank/security/miniskirt
	name = "security miniskirt"
	desc = "This miniskirt was originally featured in a gag calendar, but entered official use once they realized its potential for arid climates."
	icon_state = "miniskirt_red"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	gets_cropped_on_taurs = FALSE
	can_adjust = TRUE
	body_parts_covered = GROIN | LEGS

/obj/item/clothing/under/rank/security/battledress
	name = "security battle dress"
	desc = "An asymmetrical, unisex uniform with the legs replaced by a utility skirt. Now in security red!"
	worn_icon_state = "security_skirt_redsec"
	icon_state = "security_skirt_redsec"
	can_adjust = TRUE
	alt_covers_chest = FALSE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

// WARDEN
/obj/item/clothing/under/rank/security/warden/suit
	name = "warden's suit"
	desc = "A sleek, formal three-piece suit with a red suit jacket dawned with security insignia, not guaranteed to be good to run in!"
	icon = 'modular_zzplurt/icons/obj/clothing/under/security.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/under/security.dmi'
	icon_state = "security_suit"
	can_adjust = TRUE
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/rank/security/warden/battledress
	name = "warden battle dress"
	desc = "An asymmetrical, unisex uniform with the legs replaced by a utility skirt. This version is specifically designed for the warden!"
	worn_icon_state = "security_skirt_warden"
	icon_state = "security_skirt_warden"
	can_adjust = TRUE
	alt_covers_chest = FALSE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

// HEAD OF SECURITY
/obj/item/clothing/under/rank/security/head_of_security/suit
	name = "head of security's suit"
	desc = "A sleek, formal three-piece suit with a red suit jacket dawned with security insignia, not guaranteed to be good to run in!"
	icon = 'modular_zzplurt/icons/obj/clothing/under/security.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/under/security.dmi'
	icon_state = "security_suit"
	can_adjust = TRUE
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/rank/security/head_of_security/battledress
	name = "head of security battle dress"
	desc = "An asymmetrical, unisex uniform with the legs replaced by a utility skirt. This version is specifically designed for the head of security!"
	worn_icon_state = "security_skirt_hos"
	icon_state = "security_skirt_hos"
	can_adjust = TRUE
	alt_covers_chest = FALSE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
