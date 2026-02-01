/obj/item/organ/tongue/aquatic/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/bubble_icon_override, "fish", BUBBLE_ICON_PRIORITY_ORGAN)
