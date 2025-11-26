/datum/voucher_set/yog_knights
	blackbox_key = "sec_melee_redeemed"
/*
We like the Knights in AR, but using that name doesn't feel right.
So let's come up with our own name, thematic to what we've been doing
Yog Knights, Ugora Orbit Knights of Yog.
*/

/datum/voucher_set/yog_knights/daisho
	name = "Security Daisho"
	description = "A set of sword and baton with a dual sheath belt harness. This replaces your standard security belt"
	icon = 'modular_zzplurt/master_files/icons/obj/clothing/job/belts.dmi'
	icon_state = "secdaisho"
	set_items = list(
		/obj/item/storage/belt/secdaisho/full,
	)

/datum/voucher_set/yog_knight/tanto_belt
	name = "Standard Belt with Knife"
	description = "Your standard trustworthy belt, always reliable. Comes with a knife"
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "security"
	set_items = list(
		/obj/item/storage/belt/security/full,
	)

/obj/item/melee_voucher
	name = "security utility belt voucher"
	desc = "A card with rudimentary identification on it, this one redeems security belts. Use it on a peacekeeping equipment vendor."
	icon = 'modular_zzplurt/modules/modular_weapons/icons/obj/company_and_or_faction_based/ugora_orbit/voucher.dmi'
	icon_state = "melee_voucher"
	w_class = WEIGHT_CLASS_SMALL
	//Should we allow multiple usage? It could be handy for putting entire loadout into one with decrementing charge
	var/amount = 1

//Below are just the pod beacon but with the pod code stripped down. Because we can't use the vendor for redemption due to a bug

/obj/item/melee_voucher/interact(mob/user)
	. = ..()
	if(!can_use_voucher(user))
		return

	open_options_menu(user)
	spawn_option(choice_path, user)

/obj/item/melee_voucher/proc/generate_display_names()
	return list()

/obj/item/melee_voucher/proc/can_use_voucher(mob/living/user)
	if(user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return TRUE

	playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 40, TRUE)
	return FALSE


/obj/item/melee_voucher/proc/open_options_menu(mob/living/user)
	var/list/display_names = generate_display_names()
	if(!length(display_names))
		return
	var/choice = tgui_input_list(user, "What kind of armament are you looking for?", "Select an Item", display_names)
	if(isnull(choice) || isnull(display_names[choice]))
		return
	if(!can_use_voucher(user))
		return

	consume_use(display_names[choice], user)

/*
So this doesn't actually work, yet. and I'll uncomment this when it does.

//Code to redeem new items at the mining vendor using the suit voucher
//More items can be added in the lists and in the if statement.
/obj/machinery/vending/security/proc/redeem_melee_voucher(obj/item/melee_voucher/voucher, mob/redeemer)
	var/items = list(
		"Security Daisho" = image(icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi', icon_state = "secdaisho"),
		"Security Belt + Tanto" = image(icon = 'icons/obj/clothing/suits/utility.dmi', icon_state = "security"),
	)

	var/selection = show_radial_menu(redeemer, src, items, require_near = TRUE, tooltips = TRUE)
	if(!selection || !Adjacent(redeemer) || QDELETED(voucher) || voucher.loc != redeemer)
		return
	var/drop_location = drop_location()
	switch(selection)
		if("Security Daisho")
			new /obj/item/storage/belt/secdaisho/full(drop_location)
		if("Security Belt + Tanto")
			new /obj/item/storage/belt/security/full(drop_location)

	SSblackbox.record_feedback("tally", "melee_voucher_redeemed", 1, selection)
	qdel(voucher)
*/
