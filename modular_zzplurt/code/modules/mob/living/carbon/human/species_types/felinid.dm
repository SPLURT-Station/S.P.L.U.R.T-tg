/obj/item/organ/brain/xeno_hybrid/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/bubble_icon_override, "felinid", BUBBLE_ICON_PRIORITY_ORGAN)
