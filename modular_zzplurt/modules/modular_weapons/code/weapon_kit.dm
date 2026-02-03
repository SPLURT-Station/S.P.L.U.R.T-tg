/obj/item/weaponcrafting/gunkit/oscula
	name = "oscillating sword (lethal/anchoring)"
	desc = "A large suitcase containing disposable tools and upgraded emitter for the mark 1 resonance blade."

/datum/crafting_recipe/oscillating_sword
	name = "Oscillating Sword"
	result = /obj/item/melee/reverbing_blade/oscula
	reqs = list(
		/obj/item/melee/reverbing_blade = 1,
		/obj/item/weaponcrafting/gunkit/oscula = 1,
	)
	time = 10 SECONDS
	category = CAT_WEAPON_MELEE
