// Core code edits

// Extra Inventory stuff — *_obj bridges live on upstream clothing/ accessory paths
/datum/sprite_accessory/clothing/underwear
	/// Briefs object to which the accessory is linked
	var/obj/item/clothing/underwear/briefs/briefs_obj
	/// If it's generated from a briefs object
	var/from_object = FALSE

/datum/sprite_accessory/clothing/undershirt
	/// Shirt object to which the accessory is linked
	var/obj/item/clothing/underwear/shirt/shirt_obj
	/// If it's generated from a shirt object
	var/from_object = FALSE

/datum/sprite_accessory/clothing/bra
	/// Bra object to which the accessory is linked
	var/obj/item/clothing/underwear/shirt/bra/bra_obj
	/// If it's generated from a bra object
	var/from_object = FALSE

/datum/sprite_accessory/clothing/socks
	/// Socks object to which the accessory is linked
	var/obj/item/clothing/underwear/socks/socks_obj
	/// If it's generated from a socks object
	var/from_object = FALSE
