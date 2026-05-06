/datum/crafting_recipe/holy_handcuffs
	name = "Holy Handcuffs"
	result = /obj/item/restraints/handcuffs/holy
	reqs = list(
		/obj/item/restraints/handcuffs = 1,
		/obj/item/stack/sheet/mineral/silver = 5
	)
	tool_paths = list(
		/obj/item/book/bible
	)
	time = 10 SECONDS
	category = CAT_TOOLS

/obj/item/restraints/handcuffs/holy
	name = "holy handcuffs"
	desc = "A heavy pair of holy manacles, much less sturdy than they seem. \
	While lacking in physical restraining power, they prevent those they restrain from undergoing unholy acts, such as a Lycan transformation."
	icon_state = "holy"
	icon = 'modular_zzplurt/icons/obj/weapons/restraints.dmi'
	custom_materials = list(/datum/material/silver= SMALL_MATERIAL_AMOUNT * 5)
	breakouttime = 20 SECONDS // kinda flimsy

/obj/item/restraints/handcuffs/holy/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, MAGIC_RESISTANCE_HOLY)
