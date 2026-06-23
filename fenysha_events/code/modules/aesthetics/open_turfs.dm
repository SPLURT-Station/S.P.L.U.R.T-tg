/turf/open/misc/asteroid/snow/indestructible
	gender = PLURAL
	name = "снег" // snow
	desc = "Красивый снег! Не слишком холодно." // Pretty snow! It's not too cold.
	baseturfs = /turf/open/misc/asteroid/snow/indestructible
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	slowdown = 1
	planetary_atmos = FALSE

/turf/open/misc/asteroid/snow/indestructible/planet
	baseturfs = /turf/open/misc/asteroid/snow/indestructible/planet
	planetary_atmos = TRUE


/turf/open/indestructible/cobble
	name = "булыжная дорожка" // cobblestone path
	desc = "Простая, но красивая дорожка из камней разного размера." // A simple but beautiful path made of various sized stones.
	icon = 'fenysha_events/icons/turf/floors/floors.dmi'
	icon_state = "cobble"
	baseturfs = /turf/open/indestructible/cobble
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_turf = FALSE

/turf/open/indestructible/cobble/side
	icon_state = "cobble_side"

/turf/open/indestructible/cobble/corner
	icon_state = "cobble_corner"
