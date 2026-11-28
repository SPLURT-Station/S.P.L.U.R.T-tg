//These bits should be archived incase someone want to try anything with it but they're fully functional
/obj/item/splurtweaponspawner_case
	name = "security sidearm case"
	desc = "contains your standard issue lethal security armament to be carried at all time. Use in hand to assemble"
	icon = 'modular_zzplurt/icons/obj/weapons/sec_haul/gun_case.dmi'
	icon_state = "secsidearm"
	worn_icon = 'modular_skyrat/modules/modular_weapons/icons/mob/worn/cases.dmi'
	worn_icon_state = "darkcase"
	material_flags = NONE
	w_class = WEIGHT_CLASS_NORMAL
	var/redeemed = FALSE

/obj/item/splurtweaponspawner_case/click_alt(mob/user)
	try_redeem(user)
	return CLICK_ACTION_SUCCESS

/obj/item/splurtweaponspawner_case/attack_self(mob/user)
	try_redeem(user)

/obj/item/splurtweaponspawner_case/proc/try_redeem(mob/user)
	if(redeemed || QDELETED(src))
		return
	if(!isliving(user))
		return
	var/mob/living/redeemer = user
	if(redeemer.incapacitated)
		return

	var/static/list/options
	if(!options)

		var/datum/radial_menu_choice/ladon_option = new
		ladon_option.image = image(icon = 'modular_zubbers/icons/obj/weapons/melee.dmi', icon_state = "cc-sheath-full")
		ladon_option.info = span_boldnotice("Standard Issue 9x17mm Handgun commonly found in the hands of Romulus Federal Police Force, although considered woefully underpowered for modern armour, many swear by the rapid reload system and double stacked magazine.")

		var/datum/radial_menu_choice/protector_option = new
		protector_option.image = image(icon = 'modular_zubbers/icons/obj/weapons/melee.dmi', icon_state = "admiral-sheath-full")
		protector_option.info = span_boldnotice("Revolver Model 10. The cylinder is fixed and cannot be openned, forcing all reload to be done one cartridge at a time. While the design heavily simplified production cost it is inferior to some other obtainable revolver of the station. Comes with ammunition pouch to be attached to the pocket.")

		var/datum/radial_menu_choice/lasgun_option = new
		lasgun_option.image = image(icon = 'icons/obj/weapons/guns/energy.dmi', icon_state = "mini")
		lasgun_option.info = span_boldnotice("Nanotrasen In-house production! a laser pistol with non-removable cell holding 10 shot, weaker than its full sized counterpart but faster to recharge, comes with a holster that can hold disabler.")

		var/datum/radial_menu_choice/ntsp_option = new
		ntsp_option.image = image(icon = 'modular_zubbers/icons/obj/weapons/guns/ballistic.dmi', icon_state = "niimconsultantrevolver")
		ntsp_option.info = span_boldnotice("This option forego a lethal sidearm in favours of having more ammo for your enforcer/lancer hardlight weapon system, contains 5 small pack and a tuner for switching frequency.")

		options = list(
			"Ladon 9x17mm Handgun" = ladon_option,
			"Protector .40 Revolver" = protector_option,
			"Laser Pistol" = lasgun_option,
			"NT .22 Hardlight Ammo Pack" = ntsp_option,
		)

	var/selection = show_radial_menu(redeemer, src, options, custom_check = CALLBACK(src, PROC_REF(check_redeem_menu), redeemer), radius = 38, require_near = TRUE, tooltips = TRUE)
	if(!selection || redeemed || QDELETED(src))
		return

	var/spawn_path
	switch(selection)
		if("Ladon 9x17mm Handgun")
			spawn_path = /obj/item/storage/toolbox/guncase/skyrat/pistol/security/splurt/ladon
		if("Protector .45 Revolver")
			spawn_path = /obj/item/storage/toolbox/guncase/skyrat/pistol/security/splurt/protector
		if("Laser Pistol")
			spawn_path = /obj/item/storage/belt/holster/energy/laser_pistol
		if("NT .22 Hardlight Ammo Pack")
			spawn_path = /obj/item/storage/toolbox/guncase/skyrat/pistol/security/splurt/energy_pack
		else
			return

	redeemed = TRUE
	var/obj/item/chosen_item = new spawn_path(drop_location())
	redeemer.put_in_hands(chosen_item)
	balloon_alert(redeemer, "selected [LOWER_TEXT(selection)]")
	qdel(src)

/obj/item/splurtweaponspawner_case/proc/check_redeem_menu(mob/living/redeemer)
	if(!istype(redeemer))
		return FALSE
	if(redeemer.incapacitated)
		return FALSE
	if(QDELETED(src) || redeemed)
		return FALSE
	if(!redeemer.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/storage/toolbox/guncase/skyrat/pistol/security/splurt
	name = "generic gunset"

	icon = 'modular_zzplurt/icons/obj/weapons/sec_haul/gun_case.dmi'
	icon_state = "secsidearm"

/obj/item/storage/toolbox/guncase/skyrat/pistol/security/splurt/ladon
	name = "ladon gunset"

	weapon_to_spawn = /obj/item/gun/ballistic/automatic/pistol/sec_glock
	extra_to_spawn = /obj/item/ammo_box/magazine/security

/obj/item/storage/toolbox/guncase/skyrat/pistol/security/splurt/protector
	name = "protector gunset"

	weapon_to_spawn = /obj/item/gun/ballistic/revolver/protector_revolver
	extra_to_spawn = /obj/item/ammo_box/speedloader/c45rt

/obj/item/storage/toolbox/guncase/skyrat/pistol/security/splurt/energy_pack
	name = "Hardlight energy pack"
	icon = 'modular_zzplurt/icons/obj/weapons/sec_haul/gun_case.dmi'
	icon_state = "secsidearm_energy"
/obj/item/storage/toolbox/guncase/skyrat/pistol/security/splurt/energy_pack/PopulateContents()
	new /obj/item/ammo_box/magazine/recharge/ntusp(src)
	new /obj/item/ammo_box/magazine/recharge/ntusp(src)
	new /obj/item/ammo_box/magazine/recharge/ntusp(src)
	new /obj/item/ntusp_conversion_kit(src)
