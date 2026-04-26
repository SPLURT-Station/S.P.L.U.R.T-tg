// N2O tanks for N2O breathers, mainly for exotic respiration

/obj/item/tank/internals/n2o // big boy, 70l, not beltsize, currently not spawned anywhere but hey feel free
	name = "N2O tank"
	desc = "A tank of N2O, for crew who don't breathe the standard air mix."
	icon = 'modular_zzplurt/icons/obj/canisters.dmi'
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/equipment/tanks_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/equipment/tanks_righthand.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/belt.dmi'
	worn_icon_state = "n2o" // using the worn/inhand icons for the smaller tanks because this isn't getting spawned anywhere right now
	inhand_icon_state = "n2o" // if you're spawning this somewhere, maybe change that!
	icon_state = "n2o_large"
	force = 10
	distribute_pressure = 16

/obj/item/tank/internals/n2o/populate_gas()
	air_contents.assert_gas(/datum/gas/nitrous_oxide)
	air_contents.gases[/datum/gas/nitrous_oxide][MOLES] = (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/n2o/full/populate_gas()
	air_contents.assert_gas(/datum/gas/nitrous_oxide)
	air_contents.gases[/datum/gas/nitrous_oxide][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/n2o/belt // little guy, 12l, beltsize, spawns on exoresp-havers
	desc = "A small tank of N2O, for crew who don't breathe the standard air mix."
	icon_state = "n2o_extended"
	slot_flags = ITEM_SLOT_BELT
	force = 5
	volume = 12
	w_class = WEIGHT_CLASS_SMALL

/obj/item/tank/internals/n2o/belt/full/populate_gas()
	air_contents.assert_gas(/datum/gas/nitrous_oxide)
	air_contents.gases[/datum/gas/nitrous_oxide][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/n2o/belt/emergency // littlest guy, 3l, beltsize, doesn't spawn
	name = "emergency N2O tank"
	desc = "Used for emergencies. Contains very little N2O, so try to conserve it until you actually need it."
	icon_state = "n2o"
	volume = 3

/obj/item/tank/internals/n2o/belt/emergency/populate_gas()
	air_contents.assert_gas(/datum/gas/nitrous_oxide)
	air_contents.gases[/datum/gas/nitrous_oxide][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)
