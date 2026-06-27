// alternate versions of the plasma and nitrogen tanks for the exotic respiration quirk, with higher pressures to accomodate exoresp breathers

/obj/item/tank/internals/nitrogen/belt/full/highpressure
	distribute_pressure = 16

/obj/item/tank/internals/plasmaman/belt/full/highpressure
	distribute_pressure = 16
	volume = 12 // stock plasmaman tank is 6l, but all the other exotic tanks are 12l, so consistency. also, plasmamen breathe at 4kpa and exoresp breathers do it at 16, which makes a 6l tank woefully inadequate
	desc = "A small tank of plasma, for crew who don't breathe the standard air mix." // original plasma tank desc explicitly mentions plasmamen, better to make it more generic
