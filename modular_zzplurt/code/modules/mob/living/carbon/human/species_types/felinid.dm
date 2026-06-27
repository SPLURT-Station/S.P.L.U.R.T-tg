/obj/item/organ/tongue/cat/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/bubble_icon_override, "cat", BUBBLE_ICON_PRIORITY_ORGAN)
