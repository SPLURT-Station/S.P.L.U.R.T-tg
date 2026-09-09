// SPLURT carpets ported from oldbase.
// Their sprites use the legacy pre-bitmask layout (one full-tile state per
// .dmi instead of base_icon_state-N corner states), so they are registered as
// static, non-smoothing turfs.

/turf/open/floor/carpet/blackred
	icon = 'modular_zzplurt/icons/turf/floors/carpet_blackred.dmi'
	icon_state = "carpet"
	smoothing_flags = NONE
	floor_tile = /obj/item/stack/tile/carpet/blackred

/turf/open/floor/carpet/blackred/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/carpet/monochrome
	icon = 'modular_zzplurt/icons/turf/floors/carpet_monochrome.dmi'
	icon_state = "carpet"
	smoothing_flags = NONE
	floor_tile = /obj/item/stack/tile/carpet/monochrome

/turf/open/floor/carpet/monochrome/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/carpet/arcade
	icon = 'modular_zzplurt/icons/turf/floors_splurt.dmi'
	icon_state = "arcade"
	smoothing_flags = NONE
	floor_tile = /obj/item/stack/tile/carpet/arcade
