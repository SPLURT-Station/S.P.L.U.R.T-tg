/obj/item/clothing/suit/armor/inteq
	name = "InteQ armor vest"
	desc = "Strict black armor vest. Well, at least you won't die immediately."
	icon = 'modular_zzz/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzz/icons/mob/clothing/suits.dmi'
	worn_icon_digi = 'modular_zzz/icons/mob/clothing/suits.dmi'
	icon_state = "armor"

/obj/item/clothing/suit/armor/inteq/honorable_vanguard
	name = "InteQ black armored coat"
	desc = "Lush overcoat with fur around the neck. Has armor plates in its composition."
	icon_state = "armor_inteq_honorable_battlecoat"

/obj/item/mod/module/energy_shield/inteq
	shield_icon = "shield-yellow"

/obj/item/mod/control/pre_equipped/inteqe
	theme = /datum/mod_theme/inteqe
	starting_frequency = MODLINK_FREQ_CENTCOM
	applied_cell = /obj/item/stock_parts/power_store/cell/bluespace
	applied_modules = list(
		/obj/item/mod/module/storage/syndicate,
		/obj/item/mod/module/emp_shield,
		/obj/item/mod/module/magnetic_harness,
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/jump_jet,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/dna_lock,
		/obj/item/mod/module/hat_stabilizer/syndicate,
	)
	default_pins = list(
		/obj/item/mod/module/armor_booster,
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/jump_jet,
	)

/datum/mod_theme/inteqe
	name = "inteq"
	desc = "An elite suit developed by PMC InteQ engineers, offering upgraded armor values."
	extended_desc = "A huge upgrade of the syndicate suit, featuring a bulkier build and a matte dark color scheme, \
		this suit is only produced for InteQ Vanguards and heavily weaponized strike teams. \
		It comes built with a secondary layering of ceramic and Kevlar into the plating providing it with \
		exceptionally better protection along with fire and acid proofing."
	default_skin = "inteqe"
	armor_type = /datum/armor/mod_theme_responsory
	resistance_flags = FIRE_PROOF|ACID_PROOF
	atom_flags = PREVENT_CONTENTS_EXPLOSION_1
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	complexity_max = DEFAULT_MAX_COMPLEXITY + 3
	siemens_coefficient = 0
	slowdown_deployed = 0
	ui_theme = "inteq"
	inbuilt_modules = list(/obj/item/mod/module/armor_booster, /obj/item/mod/module/energy_shield/inteq)
	allowed_suit_storage = list(
		/obj/item/restraints/handcuffs,
		/obj/item/assembly/flash,
		/obj/item/melee/baton,
		/obj/item/melee/energy/sword,
		/obj/item/shield/energy,
	)
	variants = list(
		"inteqe" = list(
		MOD_ICON_OVERRIDE = 'modular_zzz/icons/obj/clothing/suits/mod.dmi',
		MOD_WORN_ICON_OVERRIDE = 'modular_zzz/icons/mob/clothing/suits/mod.dmi',
			/obj/item/clothing/head/mod = list(
				UNSEALED_LAYER = NECK_LAYER,
				UNSEALED_CLOTHING = SNUG_FIT,
				SEALED_CLOTHING = THICKMATERIAL|STOPSPRESSUREDAMAGE|BLOCK_GAS_SMOKE_EFFECT|HEADINTERNALS,
				UNSEALED_INVISIBILITY = HIDEFACIALHAIR,
				SEALED_INVISIBILITY = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT,
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
