#ifndef SPECIES_MANTLED_BEAST
#define SPECIES_MANTLED_BEAST "mantled_beast"
#endif

/datum/body_marking/mantled_beast
	icon = 'modular_splurt/icons/mob/markings/mantled_beast_markings.dmi'
	species_allowed = list(SPECIES_MANTLED_BEAST)
	apply_restrictions = TRUE
	direct_icon_state = TRUE
	affected_bodyparts = CHEST
	gendered = FALSE

/datum/body_marking/mantled_beast/chest_diamond
	name = "Mantled Beast Chest Diamond"
	icon_state = "chest_diamond"
	default_color = "#FFFFFF"
	always_color_customizable = TRUE

/datum/body_marking/mantled_beast/waist_stripe
	name = "Mantled Beast Waist Stripe"
	icon_state = "waist_stripe"
	default_color = "#000000"

/datum/body_marking/mantled_beast/tail_stripe
	name = "Mantled Beast Tail Stripe"
	icon_state = "tail_stripe"
	default_color = "#FFFFFF"
	always_color_customizable = TRUE
	render_layer = -BODY_FRONT_LAYER
