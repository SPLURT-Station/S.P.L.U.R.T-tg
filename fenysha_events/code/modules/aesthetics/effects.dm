/obj/effect/overlay/water
	name = "вода" // water
	icon = 'fenysha_events/icons/unique/pool.dmi'
	icon_state = "bottom"
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	plane = ABOVE_GAME_PLANE

/obj/effect/overlay/water/top
	icon_state = "top"
	layer = BELOW_MOB_LAYER
	plane = GAME_PLANE


//ОБШИВКА //SIDING

/obj/effect/turf_decal/siding
	icon = 'fenysha_events/icons/turf/decals/bubber.dmi'

/obj/effect/turf_decal/siding/wood
	icon = 'fenysha_events/icons/turf/decals/bubber.dmi'
	icon_state = "siding_wood"
	color = "#653923"

//standard

/obj/effect/turf_decal/siding/thinplating
	color = "#757476"

/obj/effect/turf_decal/siding/thinplating_new
	color = "#757476"

/obj/effect/turf_decal/siding/wideplating
	color = "#757476"

/obj/effect/turf_decal/siding/wideplating_new
	color = "#757476"

//темный //темный //dark

/obj/effect/turf_decal/siding/dark
	color = "#3d3e44"

/obj/effect/turf_decal/siding/thinplating/dark
	color = "#3d3e44"

/obj/effect/turf_decal/siding/thinplating_new/dark
	color = "#3d3e44"

/obj/effect/turf_decal/siding/wideplating/dark
	color = "#3d3e44"

/obj/effect/turf_decal/siding/wideplating_new/dark
	color = "#3d3e44"

//светлый //light

/obj/effect/turf_decal/siding/light
	color = "#e2e2e2"

/obj/effect/turf_decal/siding/thinplating/light
	color = "#e2e2e2"

/obj/effect/turf_decal/siding/thinplating_new/light
	color = "#e2e2e2"

/obj/effect/turf_decal/siding/wideplating/light
	color = "#e2e2e2"

/obj/effect/turf_decal/siding/wideplating_new/light
	color = "#e2e2e2"


/obj/effect/turf_decal/stripes/blue
	icon_state = "warningline_blue"
	icon = 'fenysha_events/icons/turf/decals/skyrat_blue.dmi'

/obj/effect/turf_decal/stripes/blue/line
	icon_state = "warningline_blue"

/obj/effect/turf_decal/stripes/blue/end
	icon_state = "warn_end_blue"

/obj/effect/turf_decal/stripes/blue/corner
	icon_state = "warninglinecorner_blue"

/obj/effect/turf_decal/stripes/blue/box
	icon_state = "warn_box_blue"

/obj/effect/turf_decal/stripes/blue/full
	icon_state = "warn_full_blue"

/obj/effect/turf_decal/bot_blue
	icon = 'fenysha_events/icons/turf/decals/skyrat_blue.dmi'
	icon_state = "bot_blue"

/obj/effect/turf_decal/caution/stand_clear/blue
	icon = 'fenysha_events/icons/turf/decals/skyrat_blue.dmi'
	icon_state = "stand_clear_blue"

/obj/effect/turf_decal/arrows/blue
	icon = 'fenysha_events/icons/turf/decals/skyrat_blue.dmi'
	icon_state = "arrows_blue"

/obj/effect/turf_decal/box/blue
	icon = 'fenysha_events/icons/turf/decals/skyrat_blue.dmi'
	icon_state = "box_blue"

/obj/effect/turf_decal/box/blue/corners
	icon = 'fenysha_events/icons/turf/decals/skyrat_blue.dmi'
	icon_state = "box_corners_blue"


/obj/effect/turf_decal/delivery/blue
	icon = 'fenysha_events/icons/turf/decals/skyrat_blue.dmi'
	icon_state = "delivery_blue"

/obj/effect/turf_decal/caution/blue
	icon = 'fenysha_events/icons/turf/decals/skyrat_blue.dmi'
	icon_state = "caution_blue"


// Полная заслуга принадлежит VG station за эти ассеты. https://github.com/vgstation-coders/vgstation13
// Все предметы в этом .dm и связанном .dmi были созданы VG station и вся заслуга принадлежит им.

// -<| ВАЖНАЯ ЗАМЕТКА МАППЕРА |>-
// Измените переменную 'color' на любом белом спрайте, чтобы просто перекрасить его!

/obj/effect/turf_decal/vg_decals
	icon = 'fenysha_events/icons/turf/decals/vgstation_decals.dmi'
	icon_state = "no"

// НАЧАЛО НОМЕРОВ // NUMBERS START

/obj/effect/turf_decal/vg_decals/numbers
	icon_state = "no"

/obj/effect/turf_decal/vg_decals/numbers/one
	icon_state = "1"

/obj/effect/turf_decal/vg_decals/numbers/two
	icon_state = "2"

/obj/effect/turf_decal/vg_decals/numbers/three
	icon_state = "3"

/obj/effect/turf_decal/vg_decals/numbers/four
	icon_state = "4"

/obj/effect/turf_decal/vg_decals/numbers/five
	icon_state = "5"

/obj/effect/turf_decal/vg_decals/numbers/six
	icon_state = "6"

/obj/effect/turf_decal/vg_decals/numbers/seven
	icon_state = "7"

/obj/effect/turf_decal/vg_decals/numbers/eight
	icon_state = "8"

/obj/effect/turf_decal/vg_decals/numbers/nine
	icon_state = "9"

/obj/effect/turf_decal/vg_decals/numbers/zero
	icon_state = "0"

// КОНЕЦ НОМЕРОВ // NUMBERS END

// НАЧАЛО АТМОСФЕРЫ // ATMOS START

/obj/effect/turf_decal/vg_decals/atmos
	icon_state = "no"

/obj/effect/turf_decal/vg_decals/atmos/oxygen
	icon_state = "oxygen"

/obj/effect/turf_decal/vg_decals/atmos/carbon_dioxide
	icon_state = "carbon_dioxide"

/obj/effect/turf_decal/vg_decals/atmos/nitrogen
	icon_state = "nitrogen"

/obj/effect/turf_decal/vg_decals/atmos/air
	icon_state = "air"

/obj/effect/turf_decal/vg_decals/atmos/nitrous_oxide
	icon_state = "nitrous_oxide"

/obj/effect/turf_decal/vg_decals/atmos/plasma
	icon_state = "plasma"

/obj/effect/turf_decal/vg_decals/atmos/mix
	icon_state = "mix"

// КОНЕЦ АТМОСФЕРЫ // ATMOS END

// НАЧАЛО ОТДЕЛА // DEPARTMENT START

/obj/effect/turf_decal/vg_decals/department/hop
	icon_state = "hop"

/obj/effect/turf_decal/vg_decals/department/bar
	icon_state = "bar"

/obj/effect/turf_decal/vg_decals/department/cargo
	icon_state = "cargo"

/obj/effect/turf_decal/vg_decals/department/med
	icon_state = "med"

/obj/effect/turf_decal/vg_decals/department/sci
	icon_state = "sci"

/obj/effect/turf_decal/vg_decals/department/sec
	icon_state = "sec"

/obj/effect/turf_decal/vg_decals/department/mining
	icon_state = "mine"

/obj/effect/turf_decal/vg_decals/department/zoo
	icon_state = "zoo"

// КОНЕЦ ОТДЕЛА // DEPARTMENT END

// РАЗНОЕ НАЧАЛО // MISC START

/obj/effect/turf_decal/vg_decals/no
	icon_state = "no"

/obj/effect/turf_decal/vg_decals/radiation_huge
	icon_state = "radiation_huge"

/obj/effect/turf_decal/vg_decals/radiation
	icon_state = "radiation"

/obj/effect/turf_decal/vg_decals/radiation_custom
	icon_state = "radiation-w"

// РАЗНОЕ КОНЕЦ // MISC END

