/obj/item/storage/box/centcom_kit
	name = "box"
	desc = "A expensive, sturdy box."
	icon = 'modular_zzplurt/icons/obj/storage.dmi'
	icon_state = "centbox"
	illustration = "writing_cent"

/obj/item/storage/box/centcom_kit/imp_deathrattle
	name = "deathrattle implant box"
	desc = "Contains eight linked deathrattle implants."
	illustration = "implant"

/obj/item/storage/box/centcom_kit/imp_deathrattle/PopulateContents()
	new /obj/item/implanter(src)

	var/datum/deathrattle_group/standard/group = new

	var/implants = list()
	for(var/j in 1 to 8)
		var/obj/item/implantcase/deathrattle/case = new (src)
		implants += case.imp

	for(var/i in implants)
		group.register(i)
	desc += " The implants are registered to the \"[group.name]\" group."

/obj/item/storage/box/centcom_kit/emps
	name = "box of emp grenades"
	desc = "A box with 8 emp grenades."
	illustration = "emp"

/obj/item/storage/box/centcom_kit/emps/PopulateContents()
	for(var/i in 1 to 8)
		new /obj/item/grenade/empgrenade(src)

/obj/item/storage/box/centcom_kit/grenades
	name = "box of frag grenades"
	desc = "A box with 8 frag grenades."
	illustration = "grenade"

/obj/item/storage/box/centcom_kit/grenades/PopulateContents()
	for(var/i in 1 to 8)
		new /obj/item/grenade/frag(src)

/obj/item/storage/box/centcom_kit/advmeds
	name = "box of premium medicine"
	desc = "Contains a large number of beakers filled with premium medical supplies."
	illustration = "beaker"

/obj/item/storage/box/centcom_kit/advmeds/PopulateContents()
	var/list/items_inside = list(
		/obj/item/reagent_containers/cup/beaker/meta/omnizine = 1,
		/obj/item/reagent_containers/cup/beaker/meta/sal_acid = 1,
		/obj/item/reagent_containers/cup/beaker/meta/oxandrolone = 1,
		/obj/item/reagent_containers/cup/beaker/meta/pen_acid = 1,
		/obj/item/reagent_containers/cup/beaker/meta/atropine = 1,
		/obj/item/reagent_containers/cup/beaker/meta/salbutamol = 1,
		/obj/item/reagent_containers/cup/beaker/meta/rezadone = 1,
	)
	generate_items_inside(items_inside, src)

/obj/item/storage/box/centcom_kit/spacesuit
	name = "space suit and helmet box"
	desc = "Contains a CentCom space suit and helmet."
	illustration = "centsuit"
	storage_type = /datum/storage/box/centcom_space

/obj/item/storage/box/centcom_kit/spacesuit/PopulateContents()
	new /obj/item/clothing/suit/space/centcom(src)
	new /obj/item/clothing/head/helmet/space/centcom(src)

/datum/storage/box/centcom_space
	max_specific_storage = WEIGHT_CLASS_NORMAL

/datum/storage/box/centcom_space/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	set_holdable(list(
		/obj/item/clothing/suit/space/centcom,
		/obj/item/clothing/head/helmet/space/centcom
	))

/obj/item/storage/box/centcom_kit/spacesuit/armored
	name = "armored space suit and helmet box"
	desc = "Contains a heavily padded and armored CentCom space suit and helmet."

/obj/item/storage/box/centcom_kit/spacesuit/armored/PopulateContents()
	new /obj/item/clothing/suit/space/centcom/combat(src)
	new /obj/item/clothing/head/helmet/space/centcom/combat(src)

/obj/item/storage/box/centcom_kit/spacesuit/command
	name = "command space suit and helmet box"
	desc = "Contains a heavily padded and armored CentCom space suit and helmet meant for a high member of command."

/obj/item/storage/box/centcom_kit/spacesuit/command/PopulateContents()
	new /obj/item/clothing/suit/space/centcom/command(src)
	new /obj/item/clothing/head/helmet/space/centcom/command(src)

/obj/item/storage/box/centcom_kit/spacesuit/surplus
	name = "old dusty space suit and helmet box"
	desc = "Contains a CentCom space suit and helmet, the box is old and aged, and caked in a thick layer of dust."

/obj/item/storage/box/centcom_kit/spacesuit/surplus/PopulateContents()
	new /obj/item/clothing/suit/space/centcom/surplus(src)
	new /obj/item/clothing/head/helmet/space/centcom/surplus(src)
