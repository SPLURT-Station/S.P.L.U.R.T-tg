/obj/item/storage/toolbox/guncase/skyrat/mps5
	name = "MP-S5 VIG Submachine Gun case"
	icon = 'modular_zzplurt/icons/obj/weapons/sec_haul/gun_case.dmi'
	icon_state = "seclongarm"

/obj/item/storage/toolbox/guncase/skyrat/mps5/PopulateContents()
	new /obj/item/gun/ballistic/automatic/mps5(src)
	new /obj/item/ammo_box/magazine/mps5(src)
	new /obj/item/ammo_box/magazine/mps5(src)

/obj/item/storage/toolbox/guncase/skyrat/pistol/ntusp
	icon = 'modular_zzplurt/icons/obj/weapons/sec_haul/gun_case.dmi'
	icon_state = "secsidearm_energy"

/obj/item/storage/toolbox/guncase/skyrat/pistol/ntmp5
	icon = 'modular_zzplurt/icons/obj/weapons/sec_haul/gun_case.dmi'
	icon_state = "seclongarm_energy"
