/obj/item/organ/tongue/moth/Initialize(mapload) //speech bubble addition
	. = ..()
	AddComponent(/datum/component/bubble_icon_override, "moff", BUBBLE_ICON_PRIORITY_ORGAN)
