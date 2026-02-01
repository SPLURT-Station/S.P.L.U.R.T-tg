/obj/item/organ/brain/synth/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/bubble_icon_override, "robot", BUBBLE_ICON_PRIORITY_ORGAN)
