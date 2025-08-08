/obj/item/bodypart/chest
	/// The offset datum for our accessory overlay.
	var/datum/worn_feature_offset/worn_accessory_offset

/obj/item/bodypart/chest/Destroy(force)
	QDEL_NULL(worn_accessory_offset)
	return ..()

/obj/item/bodypart/head
	///Override of the eyes icon file, used for Vox and maybe more in the future - The future is now, with Teshari using it too
	var/eyes_icon
