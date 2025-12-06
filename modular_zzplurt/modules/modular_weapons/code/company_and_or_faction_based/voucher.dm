/datum/voucher_set/yog_knights
	blackbox_key = "sec_melee_redeemed"
/*
We like the Knights in AR, but using that name doesn't feel right.
So let's come up with our own name, thematic to what we've been doing
Kayian Janissary.
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
	name = "Standard Belt with Dagger"
	description = "Your standard trustworthy belt, always reliable. Comes with a dagger"
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "security"
	set_items = list(
		/obj/item/storage/belt/security/full,
	)
// When a fix from upstream get merged we can simply use the proper voucher
/obj/item/melee_voucher
	name = "security utility belt voucher"
	desc = "A card with basic identification marking on it, this one redeems security belts. Use in hand."
	icon = 'modular_zzplurt/modules/modular_weapons/icons/obj/company_and_or_faction_based/ugora_orbit/voucher.dmi'
	icon_state = "melee_voucher"
	w_class = WEIGHT_CLASS_SMALL
	//Should we allow multiple usage? It could be handy for putting entire loadout into one with decrementing charge
	var/amount = 1

/obj/item/melee_voucher/attack_self(mob/living/user)
	var/list/melee_spawnables = list(
		/obj/item/storage/belt/secdaisho/full = image(icon = 'modular_skyrat/master_files/icons/obj/clothing/suits.dmi', icon_state = "blackdaisho"),
		/obj/item/storage/belt/security/full = image(icon = 'icons/obj/clothing/suits/utility.dmi', icon_state = "security"),
	)
	var/pick = show_radial_menu(user, src, melee_spawnables, radius = 36, require_near = TRUE, tooltips = TRUE)
	if(!pick)
		return
	var/to_spawn = pick(melee_spawnables)
	switch(pick)
		if("Security Dual Sheath Belt")
			new /obj/item/storage/belt/secdaisho/full(loc)
			to_chat(user, span_warning("You have chosen the path of devotion, mastery of your sword is paramount to the brutal arithmetic of combat. It is slow to swing but effective at finishing off wounded enemy, your baton does not knock down, but will knock item out of a staggered target."))
		if("Security Belt + Dagger, Recommended")
			new /obj/item/storage/belt/security/full(loc)
			to_chat(user, span_warning("You have chosen the path of faith, you put trust in those around you and value the status quo above challenging it, your standard belt kit is there alongside a weak dagger that works best when striking from behind, or against an opponent that is on the floor."))
	new to_spawn(loc)
	amount -= 1
	if(!amount)
		qdel(src)
	return ITEM_INTERACT_SUCCESS

/*
So this doesn't actually work, yet. and I'll uncomment this when it does.
Because we currently do not have the fix merged!

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
