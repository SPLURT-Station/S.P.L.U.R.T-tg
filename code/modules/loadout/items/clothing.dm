// Adding the items to the loadout system. 
// This assumes the standard TG-style loadout datum structure.

/datum/loadout_item/under/security_blue
	name = "Security Uniform (Blue)"
	path = /obj/item/clothing/under/rank/security/blue
	restricted_roles = list("Security Officer", "Warden", "Head of Security")

/datum/loadout_item/under/security_white
	name = "Security Uniform (White)"
	path = /obj/item/clothing/under/rank/security/white
	restricted_roles = list("Security Officer", "Warden", "Head of Security")
