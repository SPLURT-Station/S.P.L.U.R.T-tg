/datum/design/implant_gfluid
	name = "Genital Fluid Implant Case"
	desc = "A glass case containing a Genital Fluid Infuser implant."
	id = "implant_gfluid"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass = SMALL_MATERIAL_AMOUNT * 5)
	build_path = /obj/item/implantcase/genital_fluid
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_HEALTH
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/cybernetic_brain_cortical
	name = "Cortical Cybernetic Brain"
	desc = "An advanced cybernetic brain with enhanced cortical capabilities."
	id = "cybernetic_brain_cortical"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 15 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT*3
	)
	build_path = /obj/item/organ/brain/cybernetic/cortical
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

// Abductor Beaker
/datum/design/abductorbeaker
	name = "Abductor Beaker"
	desc = "A abductor beaker, powered by experimental alien technology and Element Cuban combined with the Compound Pete. Can hold up to 400 units."
	id = "abductorbeaker"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/plastic =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/diamond =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/bluespace =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/alloy/alien =HALF_SHEET_MATERIAL_AMOUNT)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	build_path = /obj/item/reagent_containers/cup/beaker/abductor
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE
