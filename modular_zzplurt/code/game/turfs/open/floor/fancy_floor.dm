/turf/open/floor/bamboo/lavaland
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS

/turf/open/floor/wood/shadow
	desc = "Stylish shadow wood."
	icon = 'modular_zzplurt/icons/turf/floors.dmi'
	icon_state = "shadow_wood"
	floor_tile = /obj/item/stack/tile/wood/shadow

/turf/open/floor/wood/shadow/broken_states()
	return list("shadow_wood-broken", "shadow_wood-broken2", "shadow_wood-broken3", "shadow_wood-broken4", "shadow_wood-broken5", "shadow_wood-broken6", "shadow_wood-broken7")
