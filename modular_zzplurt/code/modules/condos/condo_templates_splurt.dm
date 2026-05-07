#define GHC_MISC "Misc"
#define GHC_APARTMENT "Apartment"
#define GHC_BEACH "Beach"
#define GHC_STATION "Station"
#define GHC_WINTER "Winter"
#define GHC_SPECIAL "Special"

/// SPLURT categories for upstream Bubber condo templates.
/datum/map_template/condo/alleyway
	category = GHC_MISC

/datum/map_template/condo/apartment
	category = GHC_APARTMENT

/datum/map_template/condo/beach_condo
	category = GHC_BEACH

/datum/map_template/condo/blueshift_dorms_four
	category = GHC_APARTMENT

/datum/map_template/condo/cabin_woods
	category = GHC_APARTMENT

/datum/map_template/condo/corpo
	category = GHC_STATION

/datum/map_template/condo/corposyndi
	category = GHC_STATION

/datum/map_template/condo/cultcave
	category = GHC_SPECIAL

/datum/map_template/condo/deepspace_pod
	category = GHC_STATION

/datum/map_template/condo/deepspace_ship
	category = GHC_STATION

/datum/map_template/condo/dstwo_condo
	category = GHC_STATION

/datum/map_template/condo/engineering
	category = GHC_STATION

/datum/map_template/condo/eva
	category = GHC_STATION

/datum/map_template/condo/evacstat
	category = GHC_STATION

/datum/map_template/condo/fast_food
	category = GHC_MISC

/datum/map_template/condo/foxbar
	category = GHC_MISC

/datum/map_template/condo/gm_condo
	category = GHC_APARTMENT

/datum/map_template/condo/grotto
	category = GHC_BEACH

/datum/map_template/condo/grottoalt
	category = GHC_BEACH

/datum/map_template/condo/hilberts_hotel
	category = GHC_APARTMENT

/datum/map_template/condo/hospital
	category = GHC_STATION

/datum/map_template/condo/kinodertoten
	category = GHC_MISC

/datum/map_template/condo/lodge_pool
	category = GHC_BEACH

/datum/map_template/condo/manor_hall
	category = GHC_APARTMENT

/datum/map_template/condo/medieval_bog
	category = GHC_SPECIAL

/datum/map_template/condo/necropolis
	category = GHC_SPECIAL

/datum/map_template/condo/nightclub
	category = GHC_MISC

/datum/map_template/condo/oasis
	category = GHC_BEACH

/datum/map_template/condo/oasisalt
	category = GHC_BEACH

/datum/map_template/condo/ocean_view
	category = GHC_BEACH

/datum/map_template/condo/ouroboros_dorms_four
	category = GHC_APARTMENT

/datum/map_template/condo/planar_soil
	category = GHC_SPECIAL

/datum/map_template/condo/poole
	category = GHC_BEACH

/datum/map_template/condo/prison
	category = GHC_SPECIAL

/datum/map_template/condo/public_library
	category = GHC_MISC

/datum/map_template/condo/serenity_cabin_four
	category = GHC_APARTMENT

/datum/map_template/condo/ship_bridge
	category = GHC_STATION

/datum/map_template/condo/snowglobe_dorms_four
	category = GHC_WINTER

/datum/map_template/condo/station_arrivals
	category = GHC_STATION

/datum/map_template/condo/stationside
	category = GHC_STATION

/datum/map_template/condo/synopcenter
	category = GHC_STATION

/datum/map_template/condo/winterwoods
	category = GHC_WINTER

/datum/map_template/condo/xeno_resin
	category = GHC_SPECIAL

/// SPLURT condo template ports from legacy Hilbert-specific template definitions.
/// These keep custom room maps available through the condos-backed infinidorm flow.

/datum/map_template/condo/mountainside_skyscraper
	name = "Skyscraper Apartment"
	mappath = "_maps/splurt/templates/apartment_skyscraper.dmm"
	landing_zone_x_offset = 17
	landing_zone_y_offset = 3
	category = GHC_APARTMENT

/datum/map_template/condo/splurt_occult_hideout
	name = "Occult Hideout"
	mappath = "_maps/splurt/templates/apartment_occult_lair.dmm"
	landing_zone_x_offset = 14
	landing_zone_y_offset = 15
	category = GHC_APARTMENT

/datum/map_template/condo/splurt_dusked_oasis
	name = "Dusked Oasis"
	mappath = "_maps/splurt/templates/apartment_dusk_oasis.dmm"
	landing_zone_x_offset = 15
	landing_zone_y_offset = 2
	category = GHC_BEACH

/datum/map_template/condo/mountainside_apartment
	name = "Mountainside Apartment (SPLURT)"
	mappath = "_maps/splurt/templates/apartment_mountainside.dmm"
	landing_zone_x_offset = 14
	landing_zone_y_offset = 4
	category = GHC_SPECIAL

/datum/map_template/condo/splurt_city_apartment
	name = "City Apartment"
	mappath = "_maps/splurt/templates/apartment_city.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8
	category = GHC_APARTMENT

/datum/map_template/condo/splurt_jungle_paradise
	name = "Jungle Paradise"
	mappath = "_maps/splurt/templates/apartment_jungle.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8
	category = GHC_BEACH

/datum/map_template/condo/splurt_snowy_cabin
	name = "Snowy Cabin"
	mappath = "_maps/splurt/templates/apartment_winter.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8
	category = GHC_WINTER

/datum/map_template/condo/splurt_survival_capsule
	name = "Survival Capsule"
	mappath = "_maps/splurt/templates/apartment_capsule.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8
	category = GHC_MISC

/datum/map_template/condo/splurt_apartment_two
	name = "Apartment 2"
	mappath = "_maps/splurt/templates/apartment_2.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8
	category = GHC_APARTMENT

/datum/map_template/condo/splurt_apartment_three
	name = "Apartment 3"
	mappath = "_maps/splurt/templates/apartment_3.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8
	category = GHC_APARTMENT

/datum/map_template/condo/splurt_bar_lounge
	name = "Bar Lounge"
	mappath = "_maps/splurt/templates/apartment_bar.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8
	category = GHC_APARTMENT

/datum/map_template/condo/splurt_forest_picnic
	name = "Forest Picnic"
	mappath = "_maps/splurt/templates/apartment_forest.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8
	category = GHC_BEACH

/datum/map_template/condo/splurt_garden
	name = "Garden"
	mappath = "_maps/splurt/templates/apartment_garden.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8
	category = GHC_MISC

/datum/map_template/condo/splurt_top_security_prison
	name = "Top Security Prison"
	mappath = "_maps/splurt/templates/apartment_prison.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8
	category = GHC_SPECIAL

/datum/map_template/condo/splurt_sauna
	name = "Sauna"
	mappath = "_maps/splurt/templates/apartment_sauna.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8
	category = GHC_MISC

/datum/map_template/condo/splurt_zaks_dnd_house
	name = "Zak's D&D House"
	mappath = "_maps/splurt/templates/apartment_donator_zak_dnd_house.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8
	category = GHC_SPECIAL
	donator_tier = DONATOR_TIER_1
	ckeywhitelist = list("drarielpro")

/datum/map_template/condo/splurt_deters_lair
	name = "Deter's Lair"
	mappath = "_maps/splurt/templates/apartment_donator_ss14.dmm"
	landing_zone_x_offset = 13
	landing_zone_y_offset = 12
	category = GHC_SPECIAL
	donator_tier = DONATOR_TIER_1
	ckeywhitelist = list("girko", "moldb")

/datum/map_template/condo/mountainside_dragonlair
	name = "Dragon Cave Lair"
	mappath = "_maps/splurt/templates/apartment_dragonslair.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8
	category = GHC_MISC

/datum/map_template/condo/mountainside_fortuneteller
	name = "Arcane Library"
	mappath = "_maps/splurt/templates/apartment_fortuneteller.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8
	category = GHC_MISC

/datum/map_template/condo/splurt_serenity_two_shuttle
	name = "Serenity II Shuttle"
	mappath = "_maps/splurt/templates/apartment_shuttle_serenity2.dmm"
	landing_zone_x_offset = 8
	landing_zone_y_offset = 8
	category = GHC_STATION

/datum/map_template/condo/splurt_observation_outpost
	name = "Observation Outpost"
	mappath = "_maps/splurt/templates/apartment_winter_outpost.dmm"
	landing_zone_x_offset = 11
	landing_zone_y_offset = 2
	category = GHC_WINTER

/datum/map_template/condo/splurt_xenomorph_infested_mines
	name = "Xenomorph-Infested Mines"
	mappath = "_maps/splurt/templates/apartment_xenonest.dmm"
	landing_zone_x_offset = 3
	landing_zone_y_offset = 10
	category = GHC_STATION

/datum/map_template/condo/splurt_modern_gym
	name = "Modern Gym"
	mappath = "_maps/splurt/templates/apartment_modern_gym.dmm"
	landing_zone_x_offset = 16
	landing_zone_y_offset = 8
	category = GHC_STATION

/datum/map_template/condo/splurt_lone_house
	name = "A Lone House"
	mappath = "_maps/splurt/templates/apartment_house.dmm"
	landing_zone_x_offset = 13
	landing_zone_y_offset = 2
	category = GHC_APARTMENT

/datum/map_template/condo/splurt_lone_house_night
	name = "A Lone House At Night"
	mappath = "_maps/splurt/templates/apartment_house_night.dmm"
	landing_zone_x_offset = 13
	landing_zone_y_offset = 2
	category = GHC_APARTMENT

/datum/map_template/condo/splurt_lone_house_lavaland
	name = "A Lone House On Lavaland"
	mappath = "_maps/splurt/templates/apartment_house_lava.dmm"
	landing_zone_x_offset = 13
	landing_zone_y_offset = 2
	category = GHC_APARTMENT

/datum/map_template/condo/splurt_abandoned_shuttle
	name = "Abandoned Shuttle"
	mappath = "_maps/splurt/templates/apartment_spaceruin.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8
	category = GHC_MISC

/datum/map_template/condo/splurt_kiss
	name = "City Apartment (Empty)"
	mappath = "_maps/splurt/templates/apartment_kiss.dmm"
	landing_zone_x_offset = 23
	landing_zone_y_offset = 15
	category = GHC_APARTMENT

/datum/map_template/condo/splurt_morgue
	name = "Mortician's Office"
	mappath = "_maps/splurt/templates/apartment_morgue.dmm"
	landing_zone_x_offset = 22
	landing_zone_y_offset = 10
	category = GHC_SPECIAL

#undef GHC_APARTMENT
#undef GHC_BEACH
#undef GHC_MISC
#undef GHC_STATION
#undef GHC_WINTER
#undef GHC_SPECIAL
