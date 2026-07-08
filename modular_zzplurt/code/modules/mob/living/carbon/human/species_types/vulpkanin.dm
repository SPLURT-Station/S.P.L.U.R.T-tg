/obj/item/organ/tongue/vulpkanin/Initialize(mapload) //speech bubble addition
	. = ..()
	AddComponent(/datum/component/bubble_icon_override, "vulpkanin", BUBBLE_ICON_PRIORITY_ORGAN)