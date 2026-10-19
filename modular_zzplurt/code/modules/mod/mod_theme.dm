/datum/mod_theme/asset_protection
	name = "aegis"
	desc = "A high-tech, questionably affordable armored suit derived from the Apocryphal, designed for Nanotrasen Asset Protection."
	extended_desc = "A sleek black and green armored MODsuit developed for Nanotrasen Asset Protection. \
		A derivative of the infamous Apocryphal, the Aegis retains much of its predecessor's protective \
		capabilities and advanced tactical systems, albeit with a few corners cut in the name of \
		corporate cost efficiency. Lighter armor plating and less sophisticated defensive systems make \
		it somewhat less capable in a direct confrontation, but its improved actuators and enhanced \
		mobility ensure the wearer can keep up with whatever, or whoever, they're being paid to protect. \
		Still more than enough suit to ruin someone's day. After all, preventing an incident is considerably \
		cheaper than explaining one to Central Command."
	armor_type = /datum/armor/mod_theme_aegis

/datum/armor/mod_theme_aegis
	melee = 60
	bullet = 50
	laser = 50
	energy = 50
	bomb = 60
	bio = 100
	fire = 100
	acid = 100
	wound = 25

/datum/mod_theme/blueshield
	desc = "A prototype armored MODsuit derived from the Magnate-class, repurposed for Nanotrasen station Blueshields."
	extended_desc = "A bulky blue armored MODsuit issued to station Blueshields tasked with protecting Nanotrasen's command personnel. \
		A predecessor to the more refined Magnate-class, this suit trades advanced features and module capacity for \
		reliable, if somewhat outdated, protective systems. Its reinforced plating and insulated inner armor provide \
		decent protection against corrosive liquids, explosive blasts, fires, and electrical shocks, though it falls \
		short of the protection offered by its more expensive successors. The blue-tinted visor obscures the wearer's \
		identity, adding an imposing presence to an already conspicuous suit. It may lack the sophistication of newer \
		models, but when the Captain is getting shot at, nobody is going to complain about the budget. Well, almost nobody."
	variants = list(
		"praetorian" = list(
			MOD_ICON_OVERRIDE = 'modular_zzplurt/icons/obj/clothing/modsuit/mod_clothing.dmi',
			MOD_WORN_ICON_OVERRIDE = 'modular_zzplurt/icons/mob/clothing/modsuit/mod_clothing.dmi',
			/obj/item/clothing/head/mod = list(
				UNSEALED_LAYER = null,
				UNSEALED_CLOTHING = SNUG_FIT|THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE|HEADINTERNALS,
				UNSEALED_INVISIBILITY = HIDEEARS|HIDEHAIR,
				SEALED_INVISIBILITY = HIDEFACIALHAIR|HIDEMASK|HIDEEYES|HIDEFACE|HIDESNOUT,
				SEALED_COVER = HEADCOVERSMOUTH|HEADCOVERSEYES|PEPPERPROOF,
				UNSEALED_MESSAGE = HELMET_UNSEAL_MESSAGE,
				SEALED_MESSAGE = HELMET_SEAL_MESSAGE,
			),
			/obj/item/clothing/suit/mod = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				SEALED_INVISIBILITY = HIDEJUMPSUIT,
				UNSEALED_MESSAGE = CHESTPLATE_UNSEAL_MESSAGE,
				SEALED_MESSAGE = CHESTPLATE_SEAL_MESSAGE,
			),
			/obj/item/clothing/gloves/mod = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				CAN_OVERSLOT = TRUE,
				UNSEALED_MESSAGE = GAUNTLET_UNSEAL_MESSAGE,
				SEALED_MESSAGE = GAUNTLET_SEAL_MESSAGE,
			),
			/obj/item/clothing/shoes/mod = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				CAN_OVERSLOT = TRUE,
				UNSEALED_MESSAGE = BOOT_UNSEAL_MESSAGE,
				SEALED_MESSAGE = BOOT_SEAL_MESSAGE,
			),
		),
	)
