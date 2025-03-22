#define GHC_MISC "Misc"
#define GHC_APARTMENT "Apartment"
#define GHC_BEACH "Beach"
#define GHC_STATION "Station"
#define GHC_WINTER "Winter"
#define GHC_SPECIAL "Special"

/datum/map_template/ghost_cafe_rooms
	category = GHC_MISC

/datum/map_template/ghost_cafe_rooms/apartment
	category = GHC_APARTMENT

/datum/map_template/ghost_cafe_rooms/beach_condo
	category = GHC_BEACH

/datum/map_template/ghost_cafe_rooms/stationside
	category = GHC_STATION

/datum/map_template/ghost_cafe_rooms/library
	category = GHC_APARTMENT

/datum/map_template/ghost_cafe_rooms/cultcave
	category = GHC_SPECIAL

/datum/map_template/ghost_cafe_rooms/winterwoods
	category = GHC_WINTER

/datum/map_template/ghost_cafe_rooms/evacuationstation
	category = GHC_SPECIAL

/datum/map_template/ghost_cafe_rooms/prisoninfdorm
	category = GHC_SPECIAL

/datum/map_template/ghost_cafe_rooms/corporateoffice
	category = GHC_APARTMENT

/datum/map_template/ghost_cafe_rooms/recwing
	category = GHC_APARTMENT

/datum/map_template/ghost_cafe_rooms/grotto
	category = GHC_SPECIAL

/datum/map_template/ghost_cafe_rooms/grotto2
	category = GHC_SPECIAL

// SPLURT's custom room templates

/datum/map_template/ghost_cafe_rooms/apartment_city
	name = "City Apartment"
	mappath = "_maps/splurt/templates/apartment_city.dmm"
	category = GHC_APARTMENT

/datum/map_template/ghost_cafe_rooms/apartment_jungle
	name = "Jungle Paradise"
	mappath = "_maps/splurt/templates/apartment_jungle.dmm"
	category = GHC_BEACH

/datum/map_template/ghost_cafe_rooms/apartment_snow
	name = "Snowy Cabin"
	mappath = "_maps/splurt/templates/apartment_winter.dmm"
	category = GHC_WINTER

/datum/map_template/ghost_cafe_rooms/apartment_lavaland
	name = "Survival Capsule"
	mappath = "_maps/splurt/templates/apartment_capsule.dmm"
	category = GHC_MISC

#undef GHC_MISC
#undef GHC_APARTMENT
#undef GHC_BEACH
#undef GHC_STATION
#undef GHC_WINTER
#undef GHC_SPECIAL
