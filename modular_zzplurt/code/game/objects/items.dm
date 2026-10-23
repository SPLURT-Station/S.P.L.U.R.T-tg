/obj/item
	// Extra inventory
	var/hide_underwear_examine = FALSE
	/// Underwear and extra slots
	var/extra_slot_flags = NONE

/obj/item/update_slot_icon()
	. = ..()
	if(!ismob(loc))
		return
	var/mob/owner = loc
	var/flags = extra_slot_flags
	// Extra inventory
	if((flags & ITEM_SLOT_UNDERWEAR) && (flags & ITEM_SLOT_EXTRA))
		owner.update_worn_underwear()
	if((flags & ITEM_SLOT_SOCKS) && (flags & ITEM_SLOT_EXTRA))
		owner.update_worn_socks()
	if((flags & ITEM_SLOT_SHIRT) && (flags & ITEM_SLOT_EXTRA))
		owner.update_worn_shirt()
	if((flags & ITEM_SLOT_BRA) && (flags & ITEM_SLOT_EXTRA))
		owner.update_worn_bra()
	if((flags & ITEM_SLOT_EARS_RIGHT))
		owner.update_worn_ears_extra()
	if((flags & ITEM_SLOT_WRISTS) && (flags & ITEM_SLOT_EXTRA))
		owner.update_worn_wrists()
	//

/obj/item/examine(mob/user)
	. = ..()
	var/legality_text = get_legality_examine_text(user)
	if(legality_text)
		. += legality_text

/// Returns true if this item should display contraband legality flavor text when examined.
/obj/item/proc/is_examine_contraband()
	if(HAS_TRAIT(src, TRAIT_CONTRABAND))
		return TRUE
	if(SStraitor && is_contraband())
		return TRUE
	var/static/list/contraband_examine_typecache = typecacheof(list(
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/clothing/under/syndicate,
		/obj/item/food/drug,
		/obj/item/food/grown/cannabis,
		/obj/item/gun/ballistic/automatic/pistol/contraband,
		/obj/item/gun/ballistic/automatic/pistol/deagle/contraband,
		/obj/item/storage/fancy/cigarettes/cigpack_shadyjims,
		/obj/item/storage/fancy/cigarettes/cigpack_syndicate,
		/obj/item/storage/pill_bottle/aranesp,
		/obj/item/storage/pill_bottle/happy,
		/obj/item/storage/pill_bottle/lsd,
		/obj/item/storage/pill_bottle/stimulant,
		/obj/item/storage/pill_bottle/zoom,
		/obj/item/toy/cards/deck/syndicate,
	))
	return is_type_in_typecache(src, contraband_examine_typecache)

/// Returns examine flavor text describing whether this item is legal to possess or carry at the current station security alert level.
/obj/item/proc/get_legality_examine_text(mob/user)
	var/alert_number = SSsecurity_level ? SSsecurity_level.get_current_level_as_number() : SEC_LEVEL_GREEN
	var/alert_name = capitalize(SSsecurity_level ? SSsecurity_level.get_current_level_as_text() : "green")

	if(is_examine_contraband())
		if(alert_number >= SEC_LEVEL_DELTA)
			return span_warning("<b>Contraband:</b> This item is classified as illegal contraband under Space Law, though standard enforcement is suspended during <b>[alert_name] Alert</b>.")
		return span_warning("<b>Contraband:</b> Possession or carry of this item is strictly prohibited under Space Law during <b>[alert_name] Alert</b> without Security confiscation or Command authorization.")

	if(!(item_flags & NEEDS_PERMIT))
		return null

	var/pin_note = ""
	if(isgun(src))
		var/obj/item/gun/examined_gun = src
		if(istype(examined_gun.pin, /obj/item/firing_pin/alert_level))
			var/obj/item/firing_pin/alert_level/alert_pin = examined_gun.pin
			var/required_alert_text = capitalize(SSsecurity_level?.number_level_to_text(alert_pin.desired_minimium_alert) || "elevated")
			if(alert_number >= alert_pin.desired_minimium_alert)
				pin_note = " Its alert-level firing pin is <b>unlocked</b> at the current alert level."
			else
				pin_note = " Its alert-level firing pin is <b>locked</b> until <b>[required_alert_text] Alert</b> or higher."
		else if(istype(examined_gun.pin, /obj/item/firing_pin/permit_pin))
			if(GLOB.permit_pin_unrestricted || (examined_gun.pin.obj_flags & EMAGGED))
				pin_note = " Its permit-locked firing pin is currently <b>unrestricted</b>."
			else
				pin_note = " Its firing pin requires a valid weapons permit on your ID card to fire on-station."
		else if(istype(examined_gun.pin, /obj/item/firing_pin/implant/mindshield))
			pin_note = " Its firing pin is keyed to mindshield-implanted Security and Command personnel."

	if(alert_number <= SEC_LEVEL_GREEN)
		return span_notice("<b>Restricted Weapon ([alert_name] Alert):</b> Carrying this item openly is restricted; possession requires a valid weapons permit or Security authorization, and lethal arms must remain holstered or secured.[pin_note]")

	if(alert_number in list(SEC_LEVEL_BLUE, SEC_LEVEL_VIOLET, SEC_LEVEL_ORANGE))
		return span_notice("<b>Restricted Weapon ([alert_name] Alert):</b> Possession and carry require a valid weapons permit or Security authorization; authorized personnel may carry sidearms, subject to security searches.[pin_note]")

	if(alert_number in list(SEC_LEVEL_AMBER, SEC_LEVEL_RED))
		return span_notice("<b>Restricted Weapon ([alert_name] Alert):</b> Security and Command personnel are authorized to openly carry and deploy lethal weaponry; civilian possession requires a valid weapons permit or direct authorization.[pin_note]")

	return span_notice("<b>Restricted Weapon ([alert_name] Alert):</b> Standard weapon carry restrictions are lifted during a station-wide emergency.[pin_note]")
