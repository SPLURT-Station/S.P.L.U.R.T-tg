/obj/item/storage/belt/security/webbing/assetprot
	name = "asset protection webbing"
	desc = "A tactical chest rig issued to fit security equipment, the added holster seems to help fit sidearms too."
	icon = 'modular_zzplurt/icons/obj/storage.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/belt.dmi'
	icon_state = "cc_webbing"
	worn_icon_state = "cc_webbing"
	storage_type = /datum/storage/security_belt/webbing/holster

/obj/item/storage/belt/security/webbing/assetprot/full/PopulateContents()
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/grenade/flashbang(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/melee/baton/security/loaded(src)
	new /obj/item/restraints/legcuffs/bola/energy(src)
	new /obj/item/restraints/legcuffs/bola/energy(src)
	update_appearance()
