// CO2 tanks for CO2 breathers, mainly for exotic respiration

/obj/item/tank/internals/co2 // big boy, 70l, not beltsize, currently not spawned anywhere but hey feel free
	name = "CO2 tank"
	desc = "A tank of CO2, for crew who don't breathe the standard air mix."
	icon = 'modular_zzplurt/icons/obj/canisters.dmi'
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/equipment/tanks_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/equipment/tanks_righthand.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/belt.dmi'
	worn_icon_state = "co2" // using the worn/inhand icons for the smaller tanks because this isn't getting spawned anywhere right now
	inhand_icon_state = "co2" // if you're spawning this somewhere, maybe change that!
	icon_state = "co2_large"
	force = 10
	distribute_pressure = 16

/obj/item/tank/internals/co2/populate_gas()
	air_contents.assert_gas(/datum/gas/carbon_dioxide)
	air_contents.gases[/datum/gas/carbon_dioxide][MOLES] = (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/co2/full/populate_gas()
	air_contents.assert_gas(/datum/gas/carbon_dioxide)
	air_contents.gases[/datum/gas/carbon_dioxide][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/co2/belt // little guy, 12l, beltsize, spawns on exoresp-havers
	desc = "A small tank of CO2, for crew who don't breathe the standard air mix."
	icon_state = "co2_extended"
	slot_flags = ITEM_SLOT_BELT
	force = 5
	volume = 12
	w_class = WEIGHT_CLASS_SMALL

/obj/item/tank/internals/co2/belt/full/populate_gas()
	air_contents.assert_gas(/datum/gas/carbon_dioxide)
	air_contents.gases[/datum/gas/carbon_dioxide][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/co2/belt/emergency // littlest guy, 3l, beltsize, doesn't spawn
	name = "emergency CO2 tank"
	desc = "Used for emergencies. Contains very little CO2, so try to conserve it until you actually need it."
	icon_state = "co2"
	volume = 3

/obj/item/tank/internals/co2/belt/emergency/populate_gas()
	air_contents.assert_gas(/datum/gas/carbon_dioxide)
	air_contents.gases[/datum/gas/carbon_dioxide][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)
