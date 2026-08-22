/**
 * Outfit of mom's friend's son
 */

/obj/item/clothing/suit/armor/combine
	name = "Combine suit"
	desc = "An ultra-durable, indestructible suit that can protect from absolutely anything. \
			It is made of a rare material - adminium, which has been reinforced with vibecodium."
	armor_type = /datum/armor/immune
	allowed = list(
		/obj/item/toolgun,
		/obj/item/physgun,
	)

	icon = 'fenysha_events/icons/items/clothing/gmod_clothing.dmi'
	worn_icon = 'fenysha_events/icons/items/clothing/onmob/gmod_clothing.dmi'
	icon_state = "elite_combine"
	worn_icon_state = "elite_combine"

	body_parts_covered = ALL
	cold_protection = ALL
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = ALL
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	strip_delay = 20 SECONDS
	equip_delay_other = 20 SECONDS
	max_integrity = INFINITY
	resistance_flags = INDESTRUCTIBLE
	flags_inv = HIDEJUMPSUIT|HIDEGLOVES|HIDESHOES|HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDEHEADGEAR

	flags_1 = SUPERMATTER_IGNORES_1|PREVENT_CONTENTS_EXPLOSION_1
	flash_protect = FLASH_PROTECTION_WELDER_HYPER_SENSITIVE
	clothing_flags = LAVAPROTECT|STOPSPRESSUREDAMAGE|BLOCK_GAS_SMOKE_EFFECT|PLASMAMAN_PREVENT_IGNITION
	clothing_traits	= list(
		TRAIT_STRONG_GRABBER,
		TRAIT_STRONGPULL,
		TRAIT_BATON_RESISTANCE,
		TRAIT_SLEEPIMMUNE,
		TRAIT_STUNIMMUNE,
		TRAIT_AIRLOCK_SHOCKIMMUNE,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOHUNGER,
		TRAIT_TOXIMMUNE,
		TRAIT_NO_SLIP_WATER,
		TRAIT_NO_SLIP_ICE,
		TRAIT_FAST_CUFFING,
		TRAIT_QUICK_CARRY,
		TRAIT_MADNESS_IMMUNE,
		TRAIT_RADIMMUNE,
		TRAIT_PUSHIMMUNE,
	)

/obj/item/clothing/suit/armor/combine/stalker
	name = "Stalker suit"
	icon_state = "elite_combine"
	worn_icon_state = "elite_combine"


/obj/item/clothing/under/male07
	name = "Civilian suit"
	desc = "A simple suit that can protect against light blows and cuts. \
			It is made of an ordinary material that has no special properties."

	icon = 'fenysha_events/icons/items/clothing/gmod_clothing.dmi'
	worn_icon = 'fenysha_events/icons/items/clothing/onmob/gmod_clothing.dmi'
	icon_state = "citizen"
	worn_icon_state = "citizen"

/obj/item/clothing/under/male07/chell
	name = "Test subject suit"
	desc = "A bright and comfortable jumpsuit, used by test subjects! Seems like it's worth looking for a portal gun to go with it!"
	icon_state = "chell"
	worn_icon_state = "chell"

/obj/item/clothing/glasses/debug/architector
	icon_state = "sun"
	inhand_icon_state = "sun"
	flash_protect = FLASH_PROTECTION_WELDER_HYPER_SENSITIVE

/datum/storage/gmod_bag
	max_specific_storage = WEIGHT_CLASS_GIGANTIC
	max_total_storage = 100
	max_slots = 100
	allow_big_nesting = TRUE

/obj/item/storage/backpack/satchel/construct
	name = "Architect's backpack"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	item_flags = NO_MAT_REDEMPTION
	armor_type = /datum/armor/immune
	storage_type = /datum/storage/gmod_bag
	pickup_sound = null
	drop_sound = null

/datum/outfit/ss_construct
	name = "gmod construct"

	id = /obj/item/card/id/advanced/chameleon/elite
	glasses = /obj/item/clothing/glasses/debug/architector
	ears = /obj/item/radio/headset/heads/captain/alt
	uniform = /obj/item/clothing/under/male07
	back = /obj/item/storage/backpack/satchel/construct
	shoes = /obj/item/clothing/shoes/chameleon/noslip

	backpack_contents = list(
		/obj/item/crowbar/red/caravan = 1,
		/obj/item/physgun/advanced = 1,
		/obj/item/toolgun = 1,
		/// /obj/item/gun/ballistic/automatic/pistol/gp9 = 1,
		/obj/item/gun/ballistic/revolver/reverse/mateba = 1,
		/obj/item/gun/ballistic/shotgun/automatic/combat = 1,
		/obj/item/gun/ballistic/automatic/wt550 = 1,
		/obj/item/gun/ballistic/rifle/rebarxbow/syndie = 1,
		/obj/item/gun/ballistic/rocketlauncher/unrestricted = 1,
		/obj/item/uplink/debug = 1,
		/obj/item/uplink/nuclear/debug = 1,
		/obj/item/broadcast_camera = 1,
		/obj/item/reagent_containers/cup/bottle/adminordrazine = 1,
	)
	implants = list(
		/obj/item/implant/death_sound,
	)

	var/list/abilities_to_give = list(
		/datum/action/cooldown/noclip,
	)

/datum/outfit/ss_construct/equip(mob/living/carbon/human/user, visuals_only)
	. = ..()
	if(visuals_only)
		return

	for(var/type in abilities_to_give)
		if(!ispath(type, /datum/action))
			continue
		var/datum/action/action_instance = new type()
		action_instance.Grant(user)


/datum/outfit/ss_construct/admin
	name = "gmod construct (admin)"

	id = /obj/item/card/id/advanced/debug
	suit = /obj/item/clothing/suit/armor/combine

	backpack_contents = list(
		/obj/item/physgun/advanced/admin = 1,
		/obj/item/toolgun = 1,
		/obj/item/uplink/debug = 1,
		/obj/item/uplink/nuclear/debug = 1,
	)


/obj/item/implant/death_sound
	name = "death sound implant"
	actions_types = null
	var/sound_to_play = 'fenysha_events/sounds/effects/gmod_death.ogg'
	var/volume = 40

/obj/item/implant/death_sound/implant(mob/living/target, mob/user, silent, force)
	. = ..()
	if(!.)
		return
	RegisterSignal(imp_in, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/obj/item/implant/death_sound/removed(mob/living/source, silent, special)
	UnregisterSignal(imp_in, COMSIG_LIVING_DEATH)
	. = ..()

/obj/item/implant/death_sound/activate()
	. = ..()
	if(sound_to_play)
		playsound(get_turf(imp_in), sound_to_play, volume)

/obj/item/implant/death_sound/proc/on_death(mob/user)
	SIGNAL_HANDLER

	activate()
