/datum/body_marking/tertiary/hawk
	name = "Hawk Talon"
	icon_state = "hawk"
	affected_bodyparts = LEG_RIGHT | LEG_LEFT
	icon = 'modular_zzplurt/icons/mob/body_markings/tertiary_markings.dmi'

// Mantled Beast markings - bounty #1066
/datum/body_marking_set/mantled_beast
	name = "Mantled Beast"
	body_marking_list = list("Mantled Beast Head", "Mantled Beast Diamond Color", "Mantled Beast Chest")

/datum/body_marking/mantled_beast
	icon = 'modular_zzplurt/icons/mob/body_markings/mantled_beast_markings.dmi'
	recommended_species = list(SPECIES_MAMMAL, SPECIES_HUMAN, SPECIES_HUMANOID)
	default_color = DEFAULT_PRIMARY

/datum/body_marking/mantled_beast/head
	name = "Mantled Beast Head"
	icon_state = "mantled_beast"
	affected_bodyparts = HEAD

/datum/body_marking/mantled_beast/diamond_color
	name = "Mantled Beast Diamond Color"
	icon_state = "mantled_beast_diamond_color"
	default_color = DEFAULT_SECONDARY
	affected_bodyparts = HEAD

/datum/body_marking/mantled_beast/chest
	name = "Mantled Beast Chest"
	icon_state = "mantled_beast"
	affected_bodyparts = CHEST
	gendered = FALSE
