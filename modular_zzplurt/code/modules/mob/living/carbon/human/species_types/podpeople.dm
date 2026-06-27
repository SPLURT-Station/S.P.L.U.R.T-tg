/obj/item/organ/tongue/pod/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/bubble_icon_override, "plant", BUBBLE_ICON_PRIORITY_ORGAN)
