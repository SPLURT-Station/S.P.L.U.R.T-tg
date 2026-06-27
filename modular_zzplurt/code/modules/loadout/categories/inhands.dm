/datum/loadout_item/inhand/toolbox/New(category)
	LAZYADD(blacklisted_roles, ROLE_PERSISTENCE)
	. = ..()

/*
PLASMAMAN ENVIROSUIT KITS
SPECIES RESTRICTED
*/

/datum/loadout_item/inhand/envirokit_orange
	name = "Envirosuit Kit: Orange"
	item_path = /obj/item/storage/box/envirosuit
	restricted_species = list(SPECIES_PLASMAMAN)

/datum/loadout_item/inhand/envirokit_black
	name = "Envirosuit Kit: Black"
	item_path = /obj/item/storage/box/envirosuit/black
	restricted_species = list(SPECIES_PLASMAMAN)

/datum/loadout_item/inhand/envirokit_white
	name = "Envirosuit Kit: White"
	item_path = /obj/item/storage/box/envirosuit/white
	restricted_species = list(SPECIES_PLASMAMAN)

/datum/loadout_item/inhand/envirokit_khaki
	name = "Envirosuit Kit: Khaki"
	item_path = /obj/item/storage/box/envirosuit/khaki
	restricted_species = list(SPECIES_PLASMAMAN)

/datum/loadout_item/inhand/envirokit_slacks
	name = "Envirosuit Kit: Formal Enviroslacks"
	item_path = /obj/item/storage/box/envirosuit/slacks
	restricted_species = list(SPECIES_PLASMAMAN)

/datum/loadout_item/inhand/envirokit_prototype
	name = "Envirosuit Kit: Protoype"
	item_path = /obj/item/storage/box/envirosuit/prototype
	restricted_species = list(SPECIES_PLASMAMAN)
