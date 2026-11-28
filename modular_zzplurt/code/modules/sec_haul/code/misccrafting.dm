/datum/crafting_recipe/splurt_large_casing_pouch
	name = "revolver casing pouch"
	result = /obj/item/storage/pouch/extended_casing_pouch
	reqs = list(
		/obj/item/stack/sheet/leather = 12,
		/obj/item/stack/sheet/iron = 6,
	)
	time = 5 SECONDS
	category = CAT_EQUIPMENT
	crafting_flags = parent_type::crafting_flags | CRAFT_COLLECT_REQUIREMENTS
