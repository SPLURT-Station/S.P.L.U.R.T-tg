/obj/item/disk/bitrunning/item/domaindrop
	name = "recovered bitrunning data: bad coding"
	w_class = WEIGHT_CLASS_SMALL
	selectable_items = list(
		/obj/item/paper/paperslip/bitrunning_error,
	)


/obj/item/disk/bitrunning/item/domaindrop/trapper
	name = "recovered bitrunning data: trapping gear"
	selectable_items = list(
		/obj/item/storage/toolbox/beartrapper,
	)

/obj/item/disk/bitrunning/item/domaindrop/nagant
	name = "recovered bitrunning data: nagant revolver"
	selectable_items = list(
		/obj/item/gun/ballistic/revolver/nagant,
	)


// Much easier to break out of and slow you down less, but can be thrown for easy deployment and stored like grenades
/obj/item/restraints/legcuffs/beartrap/compact
	name = "compact bear trap"
	desc = "A lightweight beartrap for rapid deployment and storage, at the cost of power. Effective on most legged creatures."
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 2
	throw_range = 6
	slowdown = 5
	breakouttime = 6 SECONDS
	trap_damage = 10

/obj/item/storage/toolbox/beartrapper
	name = "trapper's toolbox"
	desc = "A simple grey toolbox storing several combat beartraps."

/obj/item/storage/toolbox/beartrapper/PopulateContents()
	new /obj/item/restraints/legcuffs/beartrap/compact(src)
	new /obj/item/restraints/legcuffs/beartrap/compact(src)
	new /obj/item/restraints/legcuffs/beartrap/compact(src)
	new /obj/item/restraints/legcuffs/beartrap/compact(src)
	new /obj/item/restraints/legcuffs/beartrap/compact(src)
	new /obj/item/restraints/handcuffs/cable/zipties(src)
	new /obj/item/restraints/handcuffs/cable/zipties(src)
