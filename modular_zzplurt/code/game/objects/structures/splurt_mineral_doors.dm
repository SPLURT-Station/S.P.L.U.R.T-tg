// SPLURT rustic wood door ported from oldbase.

/obj/structure/mineral_door/woodrustic
	name = "rustic wood door"
	icon = 'modular_zzplurt/icons/obj/doors/mineral_doors_splurt.dmi'
	icon_state = "woodrustic"
	openSound = 'sound/effects/doorcreaky.ogg'
	closeSound = 'sound/effects/doorcreaky.ogg'
	sheetType = /obj/item/stack/sheet/mineral/wood
	sheetAmount = 10
	max_integrity = 200
	rad_insulation = RAD_VERY_LIGHT_INSULATION

// Appended to the wood sheet recipe list at global init (this file is
// included after the core sheet_types.dm).
GLOB.wood_recipes += list( \
	new /datum/stack_recipe("rustic wooden door", /obj/structure/mineral_door/woodrustic, 10, time = 2 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
)
