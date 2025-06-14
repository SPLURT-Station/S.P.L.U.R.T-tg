#define GHC_MISC "Misc"
#define GHC_APARTMENT "Apartment"
#define GHC_BEACH "Beach"
#define GHC_STATION "Station"
#define GHC_WINTER "Winter"
#define GHC_SPECIAL "Special"

/datum/map_template/ghost_cafe_rooms
	var/category = GHC_MISC //Room categorizing
	var/donator_tier = DONATOR_TIER_NONE //For donator rooms
	var/list/ckeywhitelist = list() //For ckey locked donator rooms

/datum/map_template/ghost_cafe_rooms/New(path, rename, cache)
	. = ..()
	if(LAZYLEN(ckeywhitelist) && !donator_tier)
		donator_tier = DONATOR_TIER_1

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

/datum/map_template/ghost_cafe_rooms/foxbar
	category = GHC_APARTMENT

/datum/map_template/ghost_cafe_rooms/nightclub
	category = GHC_STATION

/datum/map_template/ghost_cafe_rooms/eva
	category = GHC_STATION

/datum/map_template/ghost_cafe_rooms/oasis
	category = GHC_BEACH

/datum/map_template/ghost_cafe_rooms/oasisalt
	category = GHC_BEACH

// SPLURT's custom room templates

/datum/map_template/ghost_cafe_rooms/apartment_skyscraper
	name = "Skyscraper Apartment"
	mappath = "_maps/splurt/templates/apartment_skyscraper.dmm"
	category = GHC_APARTMENT

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

/datum/map_template/ghost_cafe_rooms/apartment_2
	name = "Apartment 2"
	mappath = "_maps/splurt/templates/apartment_2.dmm"
	category = GHC_APARTMENT

/datum/map_template/ghost_cafe_rooms/apartment_3
	name = "Apartment 3"
	mappath = "_maps/splurt/templates/apartment_3.dmm"
	category = GHC_APARTMENT

/datum/map_template/ghost_cafe_rooms/apartment_bar
	name = "Bar Lounge"
	mappath = "_maps/splurt/templates/apartment_bar.dmm"
	category = GHC_APARTMENT

/datum/map_template/ghost_cafe_rooms/apartment_forest
	name = "Forest Picnic"
	mappath = "_maps/splurt/templates/apartment_forest.dmm"
	category = GHC_BEACH

/datum/map_template/ghost_cafe_rooms/apartment_garden
	name = "Garden"
	mappath = "_maps/splurt/templates/apartment_garden.dmm"
	category = GHC_MISC

/datum/map_template/ghost_cafe_rooms/apartment_prison_cell
	name = "Top Security Prison"
	mappath = "_maps/splurt/templates/apartment_prison.dmm"
	category = GHC_SPECIAL

/datum/map_template/ghost_cafe_rooms/apartment_sauna
	name = "Sauna"
	mappath = "_maps/splurt/templates/apartment_sauna.dmm"
	category = GHC_MISC

/datum/map_template/ghost_cafe_rooms/dnd_house
	name = "Zak's D&D House"
	mappath = "_maps/splurt/templates/apartment_donator_zak_dnd_house.dmm"
	ckeywhitelist = list("drarielpro")
	category = GHC_SPECIAL

/datum/map_template/ghost_cafe_rooms/apartment_dragonslair
	name = "Dragon Cave Lair"
	mappath = "_maps/splurt/templates/apartment_dragonslair.dmm"
	category = GHC_MISC

/datum/map_template/ghost_cafe_rooms/apartment_fortuneteller
	name = "Arcane Library"
	mappath = "_maps/splurt/templates/apartment_fortuneteller.dmm"
	category = GHC_MISC

#undef GHC_MISC
#undef GHC_APARTMENT
#undef GHC_BEACH
#undef GHC_STATION
#undef GHC_WINTER
#undef GHC_SPECIAL
