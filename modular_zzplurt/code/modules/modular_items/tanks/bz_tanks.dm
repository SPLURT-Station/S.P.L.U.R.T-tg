// BZ tanks for BZ breathers, mainly for exotic respiration

/obj/item/tank/internals/bz // big boy, 70l, not beltsize, currently not spawned anywhere but hey feel free
	name = "BZ tank"
	desc = "A tank of BZ, for crew who don't breathe the standard air mix."
	icon = 'modular_zzplurt/icons/obj/canisters.dmi'
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/equipment/tanks_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/equipment/tanks_righthand.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/belt.dmi'
	worn_icon_state = "bz" // using the worn/inhand icons for the smaller tanks because this isn't getting spawned anywhere right now
	inhand_icon_state = "bz" // if you're spawning this somewhere, maybe change that!
	icon_state = "bz_large"
	force = 10
	distribute_pressure = 6 // adheres to the needed pressure for bz breathers

/obj/item/tank/internals/bz/populate_gas()
	air_contents.assert_gas(/datum/gas/bz)
	air_contents.gases[/datum/gas/bz][MOLES] = (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/bz/full/populate_gas()
	air_contents.assert_gas(/datum/gas/bz)
	air_contents.gases[/datum/gas/bz][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/bz/belt // little guy, 12l, beltsize, spawns on exoresp-havers
	desc = "A small tank of BZ, for crew who don't breathe the standard air mix."
	icon_state = "bz_extended"
	slot_flags = ITEM_SLOT_BELT
	force = 5
	volume = 12
	w_class = WEIGHT_CLASS_SMALL

/obj/item/tank/internals/bz/belt/full/populate_gas()
	air_contents.assert_gas(/datum/gas/bz)
	air_contents.gases[/datum/gas/bz][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/bz/belt/emergency // littlest guy, 3l, beltsize, doesn't spawn
	name = "emergency BZ tank"
	desc = "Used for emergencies. Contains very little BZ, so try to conserve it until you actually need it."
	icon_state = "bz"
	volume = 3

/obj/item/tank/internals/bz/belt/emergency/populate_gas()
	air_contents.assert_gas(/datum/gas/bz)
	air_contents.gases[/datum/gas/bz][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)
