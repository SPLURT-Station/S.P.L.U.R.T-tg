#define GHC_MISC "Misc"
#define GHC_APARTMENT "Apartment"
#define GHC_BEACH "Beach"
#define GHC_STATION "Station"
#define GHC_WINTER "Winter"
#define GHC_SPECIAL "Special"

/// SPLURT condo template ports from legacy Hilbert-specific template definitions.
/// These keep custom room maps available through the condos-backed infinidorm flow.

/datum/map_template/condo/splurt_skyscraper_apartment
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

/datum/map_template/condo/splurt_mountainside_apartment
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

/datum/map_template/condo/splurt_dragon_cave_lair
	name = "Dragon Cave Lair"
	mappath = "_maps/splurt/templates/apartment_dragonslair.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8
	category = GHC_MISC

/datum/map_template/condo/splurt_arcane_library
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

#undef GHC_MISC
#undef GHC_APARTMENT
#undef GHC_BEACH
#undef GHC_STATION
#undef GHC_WINTER
#undef GHC_SPECIAL
