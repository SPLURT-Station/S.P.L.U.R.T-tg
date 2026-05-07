/obj/item/organ/tongue/lizard/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/bubble_icon_override, "lizor", BUBBLE_ICON_PRIORITY_ORGAN)
