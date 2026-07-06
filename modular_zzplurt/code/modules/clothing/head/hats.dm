/obj/item/clothing/head/slouch_hat
	name = "Slouch hat"
	desc = "An Australian Military slouch hat with one side turned up... Smells faintly of Kangaroos."
	icon = 'modular_zzplurt/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'
	icon_state = "slouch"
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/obj/item/clothing/head/lawdog
	name = "Law dog"
	desc = "Hat of the old west law bringers like bass reeves and wyatt erp."
	icon = 'modular_zzplurt/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'
	icon_state = "lawdog"
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/obj/item/clothing/head/gunfighter
	name = "Gun fighter"
	desc = "One hell of a bastard wears this hat upon their head... with its hat band made out of bullet casings folks can tell you mean business."
	icon = 'modular_zzplurt/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'
	icon_state = "gunfighter"
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/obj/item/clothing/head/invisihat
	name = "invisifiber hat"
	desc = "A hat made of transparent fibers, often used with reinforcement kits."
	icon = 'modular_zzplurt/icons/obj/clothing/head.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'
	icon_state = "hat_transparent"
	worn_icon_state = "none"

/obj/item/clothing/head/beret/black
	name = "black beret"
	greyscale_colors = COLOR_ALMOST_BLACK

/obj/item/clothing/head/beret/purple
	name = "purple beret"
	greyscale_colors = COLOR_PURPLE

/obj/item/clothing/head/beret/blue
	name = "blue beret"
	greyscale_colors = COLOR_BLUE_LIGHT

//
/obj/item/clothing/head/caphat/formal/fedcover
	name = "Federation Officer's Cap"
	armor_type = /datum/armor/none
	desc = "An officer's cap that demands discipline from the one who wears it."
	icon = 'modular_zzplurt/icons/obj/clothing/trek_item_icon.dmi'
	icon_state = "fedcapofficer"
	worn_icon = 'modular_zzplurt/icons/mob/clothing/trek_mob_icon.dmi'

//Variants
/obj/item/clothing/head/caphat/formal/fedcover/medsci
	icon_state = "fedcapsci"

/obj/item/clothing/head/caphat/formal/fedcover/eng
	icon_state = "fedcapeng"

/obj/item/clothing/head/caphat/formal/fedcover/sec
	icon_state = "fedcapsec"

/obj/item/clothing/head/caphat/formal/fedcover/black
	icon_state = "fedcapblack"

//
/obj/item/clothing/head/kepi
	name = "kepi"
	desc = "A white cap with visor. Oui oui, mon capitane!"
	icon = 'modular_zzplurt/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'
	icon_state = "kepi"

//
/obj/item/clothing/head/kepi/orvi
	name = "\improper Federation kepi"
	desc = "A visored cap worn by all officers since 2550s."
	icon_state = "kepi_ass"

/obj/item/clothing/head/kepi/orvi/command
	icon_state = "kepi_com"

/obj/item/clothing/head/kepi/orvi/sec
	icon_state = "kepi_sec"

/obj/item/clothing/head/kepi/orvi/eng
	icon_state = "kepi_eng"

/obj/item/clothing/head/kepi/orvi/medsci
	icon_state = "kepi_medsci"

/obj/item/clothing/head/kepi/orvi/service
	icon_state = "kepi_srv"

//
/obj/item/clothing/head/widered
	name = "Wide red hat"
	desc = "It is both wide, and red. Stylish!"
	icon_state = "widehat_red"
	icon = 'modular_zzplurt/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'

//donor thing for fabricator
/obj/item/clothing/head/costume/maid_headband/syndicate/donor
	name = "tactical maid headband"
	desc = "Tacticute modified to fit certain shadekins."

/obj/item/clothing/head/beret/sec/splurt
	name = "security beret"
	desc = "A robust beret with the security insignia emblazoned on it. Uses reinforced fabric to offer sufficient protection."
	icon = 'modular_zzplurt/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'
	icon_state = "security_beret"
	post_init_icon_state = null
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null
	armor_type = /datum/armor/cosmetic_sec
	strip_delay = 6 SECONDS
	dog_fashion = null
	flags_1 = NONE

/obj/item/clothing/head/beret/sec/splurt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/security_beret)

/datum/atom_skin/security_beret
	abstract_type = /datum/atom_skin/security_beret

/datum/atom_skin/security_beret/default
	preview_name = "Default Variant"
	new_icon_state = "security_beret"

/datum/atom_skin/security_beret/alt
	preview_name = "Black Variant"
	new_icon_state = "security_beret_alt"

/obj/item/clothing/head/beret/sec/splurt/warden
	name = "warden's beret"
	desc = "A robust beret with the silver security insignia emblazoned on it. Uses reinforced fabric to offer sufficient protection."
	icon_state = "security_warden_beret"
	armor_type = /datum/armor/hats_warden

/obj/item/clothing/head/beret/sec/splurt/warden/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/warden_beret)

/datum/atom_skin/warden_beret
	abstract_type = /datum/atom_skin/warden_beret

/datum/atom_skin/warden_beret/default
	preview_name = "Default Variant"
	new_icon_state = "security_warden_beret"

/datum/atom_skin/warden_beret/alt
	preview_name = "Black Variant"
	new_icon_state = "security_warden_beret_alt"

/obj/item/clothing/head/beret/sec/splurt/hos
	name = "head of security's beret"
	desc = "A robust beret with the golden security insignia emblazoned on it. Uses reinforced fabric to offer sufficient protection."
	icon_state = "security_hos_beret"
	armor_type = /datum/armor/hats_hos

/obj/item/clothing/head/beret/sec/splurt/hos/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hos_beret)

/datum/atom_skin/hos_beret
	abstract_type = /datum/atom_skin/hos_beret

/datum/atom_skin/hos_beret/default
	preview_name = "Default Variant"
	new_icon_state = "security_hos_beret"

/datum/atom_skin/hos_beret/alt
	preview_name = "Black Variant"
	new_icon_state = "security_hos_beret_alt"

/obj/item/clothing/head/security_garrison
	name = "security garrison cap"
	desc = "A garrison cap usually worn by old Solarian military personnel, this one is painted in security colors and has security insignia."
	icon = 'modular_zzplurt/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'
	icon_state = "sec_garrison"
	armor_type = /datum/armor/cosmetic_sec
	strip_delay = 6 SECONDS
	dog_fashion = null
	flags_1 = null

/obj/item/clothing/head/security_garrison/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/security_garrison)

/datum/atom_skin/security_garrison
	abstract_type = /datum/atom_skin/security_garrison

/datum/atom_skin/security_garrison/default
	preview_name = "Default Variant"
	new_icon_state = "sec_garrison"

/datum/atom_skin/security_garrison/alt
	preview_name = "Black Variant"
	new_icon_state = "sec_garrison_alt"

/obj/item/clothing/head/security_garrison/warden
	name = "warden's garrison cap"
	desc = "A garrison cap usually worn by old Solarian military personnel, this one is painted in security colors and has silver security insignia."
	icon_state = "sec_warden_garrison"
	armor_type = /datum/armor/hats_warden
	strip_delay = 6 SECONDS

/obj/item/clothing/head/security_garrison/warden/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/warden_garrison)

/datum/atom_skin/warden_garrison
	abstract_type = /datum/atom_skin/warden_garrison

/datum/atom_skin/warden_garrison/default
	preview_name = "Default Variant"
	new_icon_state = "sec_warden_garrison"

/datum/atom_skin/warden_garrison/alt
	preview_name = "Black Variant"
	new_icon_state = "sec_warden_garrison_alt"

/obj/item/clothing/head/hats/warden
	icon = 'icons/obj/clothing/head/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/hats.dmi'
	icon_state = "policehelm"

/obj/item/clothing/head/security_garrison/ntps
	name = "\improper Nanotrasen private security garrison cap"
	desc = "A gray garrison cap dawned with classic security red insigna on the front, it looks formal AND fashionable! \
		Sometimes. At least it has some armor plating in it."
	icon = 'modular_zzplurt/icons/obj/clothing/head.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/head.dmi'
	icon_state = "ntps_garrison"
	armor_type = /datum/armor/head_helmet

/obj/item/clothing/head/soft/sec/ntps
	name = "\improper Nanotrasen private security cap"
	desc = "A gray cap with a classic security red Nanotrasen logo on the front, it looks fashionable! At least it has \
		some armor plating in it."
	icon = 'modular_zzplurt/icons/obj/clothing/head.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/head.dmi'
	icon_state = "ntpssoft"
	soft_type = "ntps"
	armor_type = /datum/armor/head_helmet

/obj/item/clothing/head/beret/sec/ntps
	name = "\improper Nanotrasen private security beret"
	desc = "A gray beret dawned with classic security red insigna on the front, it looks formal AND fashionable! \
		Sometimes. At least it has some armor plating in it."
	icon = 'modular_zzplurt/icons/obj/clothing/head.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/head.dmi'
	icon_state = "ntps_beret"
	post_init_icon_state = null
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null
	armor_type = /datum/armor/head_helmet

/obj/item/clothing/head/beret/sec/ntps/captain
	name = "\improper Nanotrasen private security captain beret"
	desc = "A gray beret dawned with a golden badge on the front, it looks formal, protective AND fashionable! \
		Sometimes. At least it has some heavy armor plating in it."
	icon = 'modular_zzplurt/icons/obj/clothing/head.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/head.dmi'
	icon_state = "ntps_beret_cpt"
	post_init_icon_state = null
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null
	armor_type = /datum/armor/hats_hos

/obj/item/clothing/head/hats/hos/cap/captain
	name = "\improper Nanotrasen private security captain cap"
	desc = "A gray peaked cap dawned with a golden badge on the front, it looks formal, protective AND fashionable! \
		Sometimes. At least it has some heavy armor plating in it."
	icon = 'modular_zzplurt/icons/obj/clothing/head.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/head.dmi'
	icon_state = "ntps_cap"
	armor_type = /datum/armor/hats_hos
