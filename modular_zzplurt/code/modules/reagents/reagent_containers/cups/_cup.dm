/obj/item/reagent_containers/cup/beaker/abductor
	name = "abductor beaker"
	desc = "A abductor beaker, powered by experimental alien technology \
		and Element Cuban combined with the Compound Pete. Can hold up to \
		400 units."
	icon = 'modular_zzplurt/icons/obj/medical/chemical.dmi'
	icon_state = "beakerabductor"
	inhand_icon_state = "beaker_abductor"
	custom_materials = list(/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/plastic = SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/diamond = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/bluespace = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/alloy/alien = HALF_SHEET_MATERIAL_AMOUNT)
	volume = 400
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,50,100,300,400)
	can_lid = FALSE
