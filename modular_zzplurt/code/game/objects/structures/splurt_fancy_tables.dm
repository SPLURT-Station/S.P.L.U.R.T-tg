// SPLURT fancy tables ported from oldbase.
// Their sprites use the legacy pre-bitmask layout (one full-table state per
// .dmi instead of base_icon_state-N corner states), so they are registered as
// static, non-smoothing tables mirroring the old icon_state.

/obj/structure/table/wood/fancy/blackred
	icon_state = "fancy_table_blackred"
	base_icon_state = "fancy_table_blackred"
	buildstack = /obj/item/stack/tile/carpet/blackred
	icon = 'modular_zzplurt/icons/obj/smooth_structures/fancy_table_blackred.dmi'
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null

/obj/structure/table/wood/fancy/monochrome
	icon_state = "fancy_table_monochrome"
	base_icon_state = "fancy_table_monochrome"
	buildstack = /obj/item/stack/tile/carpet/monochrome
	icon = 'modular_zzplurt/icons/obj/smooth_structures/fancy_table_monochrome.dmi'
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null
