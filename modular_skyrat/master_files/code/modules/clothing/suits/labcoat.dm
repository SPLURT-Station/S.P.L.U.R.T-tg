/obj/item/clothing/suit/toggle/labcoat
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/toggle/labcoat/Initialize(mapload)
	. = ..()
	allowed += list(/obj/item/flashlight, /obj/item/hypospray, /obj/item/storage/hypospraykit)

/obj/item/clothing/suit/toggle/labcoat/skyrat
	name = "SR LABCOAT SUIT DEBUG"
	desc = "REPORT THIS IF FOUND"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits/labcoat.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suits/labcoat.dmi'
	icon_state = null //Keeps this from showing up under the chameleon hat
//SPLURT EDIT START
/obj/item/clothing/suit/toggle/labcoat/skyrat/fancy
	name = "Greyscale Fancy Labcoat"
	desc = "Throughout the test of determination, many have sought after such a fancy labcoat, one that was filled with many colors and wears."
	icon_state = "fancy_labcoat"
	greyscale_config = /datum/greyscale_config/fancy_labcoat
	greyscale_config_worn = /datum/greyscale_config/fancy_labcoat/worn
	greyscale_config_worn_teshari = /datum/greyscale_config/fancy_labcoat/worn/teshari
	post_init_icon_state = "fancy_labcoat"
	greyscale_colors = "#EEEEEE#4A77A1"
	gets_cropped_on_taurs = FALSE
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/toggle/labcoat/skyrat/fancy/rd
//SPLURT EDIT END
	name = "research directors labcoat"
	desc = "A Nanotrasen standard labcoat for certified Research Directors. It has an extra plastic-latex lining on the outside for more protection from chemical and viral hazards."
	greyscale_colors = "#B347A1#EEEEEE" //SPLURT EDIT, ORIGINAL: icon_state = "labcoat_rd_w"
	gets_cropped_on_taurs = FALSE
	body_parts_covered = CHEST|ARMS|LEGS
	armor_type = /datum/armor/skyrat_rd

/obj/item/clothing/suit/toggle/labcoat/skyrat/rd
	parent_type = /obj/item/clothing/suit/toggle/labcoat/skyrat/fancy/rd

/datum/armor/skyrat_rd
	melee = 5
	bio = 80
	fire = 80
	acid = 70

/obj/item/clothing/suit/toggle/labcoat/skyrat/fancy/regular //SPLURT EDIT, ORIGINAL: /obj/item/clothing/suit/toggle/labcoat/skyrat/regular
	name = "researcher's labcoat"
	desc = "A Nanotrasen standard labcoat for researchers in the scientific field."
	greyscale_colors = "#EEEEEE#B347A1" //SPLURT EDIT, ORIGINAL: icon_state = "labcoat_regular"
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/suit/toggle/labcoat/skyrat/fancy/pharmacist //SPLURT EDIT, ORIGINAL: /obj/item/clothing/suit/toggle/labcoat/chemist/skyrat/pharmacist
	name = "pharmacist's labcoat"
	desc = "A standard labcoat for chemistry which protects the wearer from acid spills."
	/*SPLURT REMOVAL START
	icon_state = "labcoat_pharm"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits/labcoat.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suits/labcoat.dmi'
	post_init_icon_state = null
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null
	SPLURT REMOVAL END*/
	greyscale_colors = "#EEEEEE#E6935C" //SPLURT ADDITION
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/suit/toggle/labcoat/skyrat/highvis
	name = "high vis labcoat"
	desc = "A high visibility vest for emergency responders, intended to draw attention away from the blood."
	icon_state = "labcoat_highvis"
	blood_overlay_type = "armor"

/obj/item/clothing/suit/toggle/labcoat/skyrat/highvis/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha)

//SPLURT ADDITION START
/obj/item/clothing/suit/toggle/labcoat/skyrat/fancy/geneticist
	name = "geneticist's labcoat"
	desc = "A standard labcoat for geneticist."
	greyscale_colors = "#EEEEEE#7497C0"
	gets_cropped_on_taurs = FALSE
//SPLURT ADDITION END

/obj/item/clothing/suit/toggle/labcoat/hospitalgown //Intended to keep patients modest while still allowing for surgeries
	name = "hospital gown"
	desc = "A complicated drapery with an assortment of velcros and strings, designed to keep a patient modest during medical stay and surgeries."
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/hospitalgown"
	post_init_icon_state = "labcoat_job"
	greyscale_config = /datum/greyscale_config/labcoat
	greyscale_config_worn = /datum/greyscale_config/labcoat/worn
	greyscale_colors = "#478294#478294#478294#478294"
	toggle_noun = "drapes"
	body_parts_covered = NONE //Allows surgeries despite wearing it; hiding genitals is handled in /datum/sprite_accessory/genital/is_hidden() (Only place it'd work sadly)
	armor_type = /datum/armor/none
	equip_delay_other = 8

//SPLURT EDIT START
/obj/item/clothing/suit/toggle/labcoat/skyrat/fancy/roboticist
	name = "roboticist's labcoat"
	desc = "A standard labcoat for roboticist."
	greyscale_colors = "#2F2E31#A52F29"
	gets_cropped_on_taurs = FALSE
//SPLURT EDIT END

/obj/item/clothing/suit/toggle/labcoat/medical //Renamed version of the Genetics labcoat for more generic medical purposes; just a subtype of /labcoat/ for the TG files
	name = "medical labcoat"
	desc = "A suit that protects against minor chemical spills. Has a blue stripe on the shoulder."
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/medical"
	post_init_icon_state = "labcoat_job"
	greyscale_config = /datum/greyscale_config/labcoat
	greyscale_config_worn = /datum/greyscale_config/labcoat/worn
	greyscale_config_worn_teshari = /datum/greyscale_config/labcoat/worn/teshari //tacks teshari override onto labcoats
	greyscale_colors = "#EEEEEE#4A77A1#4A77A1#7095C2"

/obj/item/clothing/suit/toggle/labcoat/science
	greyscale_config_worn_teshari = /datum/greyscale_config/labcoat/worn/teshari //tacks teshari override onto labcoats

/obj/item/clothing/suit/toggle/labcoat/coroner
	greyscale_config_worn_teshari = /datum/greyscale_config/labcoat/worn/teshari //tacks teshari override onto labcoats

/obj/item/clothing/suit/toggle/labcoat/virologist
	greyscale_config_worn_teshari = /datum/greyscale_config/labcoat/worn/teshari //tacks teshari override onto labcoats

/obj/item/clothing/suit/toggle/labcoat/genetics
	greyscale_config_worn_teshari = /datum/greyscale_config/labcoat/worn/teshari //tacks teshari override onto labcoats

/obj/item/clothing/suit/toggle/labcoat/chemist
	greyscale_config_worn_teshari = /datum/greyscale_config/labcoat/worn/teshari //tacks teshari override onto labcoats

/obj/item/clothing/suit/toggle/labcoat/interdyne
	greyscale_config_worn_teshari = /datum/greyscale_config/labcoat/worn/teshari //tacks teshari override onto labcoats

/obj/item/clothing/suit/toggle/labcoat/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/handheld_soulcatcher,
	)

//SPLURT ADDITION START
/obj/item/clothing/suit/toggle/labcoat/skyrat/fancy/pharmacist/Initialize(mapload)
	. = ..()
	allowed += /obj/item/storage/bag/chemistry
//SPLURT ADDITION END
