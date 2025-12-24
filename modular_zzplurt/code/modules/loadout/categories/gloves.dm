/datum/loadout_item/gloves/tactical_maid //Donor thing for splurt
	name = "Tactical Maid Gloves"
	item_path = /obj/item/clothing/gloves/tactical_maid
	donator_only = TRUE
	ckeywhitelist = list("fabricatorgeneral")

/datum/loadout_item/gloves/insulated_maid_gloves //Donor thing for splurt
	name = "Tactical Maid Gloves"
	item_path = /obj/item/clothing/gloves/combat/maid
	donator_only = TRUE
	restricted_roles = list(ALL_JOBS_ENGINEERING)
	ckeywhitelist = list("fabricatorgeneral")
