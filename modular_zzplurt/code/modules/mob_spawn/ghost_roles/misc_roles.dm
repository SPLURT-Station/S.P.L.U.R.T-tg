/obj/effect/mob_spawn/ghost_role/human/lostcargoqm
	prompt_name = "a lost freighter Captain"
	mob_name = "Freighter Captain"

/datum/outfit/freighter_boss
	name = "Freighter Captain"

/obj/item/card/id/away/freightcrew
	desc = "An ID card marked with the rank of Freighter Crew."

/obj/item/card/id/away/freightmine
	desc = "An ID card marked with the rank of Freighter Excavator."

/obj/item/card/id/away/silver/freightqm
	name = "Freighter Captain ID"
	desc = "An ID card marked with the rank of Freighter Captain."

/obj/effect/mob_spawn/ghost_role/human/vortex_bartender
	name = "CentCom Shuttle Bartender"
	desc = "Seems like there's somebody inside, peacefully sleeping."
	icon = 'modular_skyrat/modules/cryosleep/icons/cryogenics.dmi'
	icon_state = "cryopod"
	prompt_name = "CentCom bartender"
	you_are_text = "You are a intern-level employee for Nanotrasen's CentCom division, employed to bartend for the evacuation shuttle."
	flavour_text = "Your employers sent you to a state-of-the-art luxury evacuation shuttle, you were tasked with bartending for the crew until docked at Central Command."
	important_text = "You are NOT crew, do not interact with the round in any way, or inmpede any actions, all you are to do is bartend."
	spawner_job_path = /datum/job/bartender
	quirks_enabled = TRUE
	random_appearance = FALSE
	loadout_enabled = FALSE
	outfit = /datum/outfit/vortex_bartender
	allow_custom_character = ALL

/obj/effect/mob_spawn/ghost_role/human/vortex_bartender/allow_spawn(mob/user, silent = FALSE)
	// Call parent checks first
	if(!..())
		return FALSE

	// Ensure shuttle exists
	if(!SSshuttle || !SSshuttle.emergency)
		return FALSE

	// Check shuttle mode/state
	if(SSshuttle.emergency.mode != SHUTTLE_DOCKED)
		if(!silent)
			to_chat(user, span_warning("You can only take this role once the emergency shuttle has docked!"))
		return FALSE

	return TRUE

/obj/effect/mob_spawn/ghost_role/human/vortex_bartender/proc/announce_role_available()
	for(var/mob/dead/observer/G in GLOB.dead_mob_list)
		to_chat(G, span_notice("A new ghost role is now available: [prompt_name]! (Emergency shuttle has docked)"))

/datum/outfit/vortex_bartender
	name = "Vortex-Class CentCom Bartender"
	uniform = /obj/item/clothing/under/rank/centcom/official/turtleneck
	suit = /obj/item/clothing/suit/armor/vest/alt
	back = /obj/item/storage/backpack/satchel/leather
	shoes = /obj/item/clothing/shoes/laceup
	ears = /obj/item/radio/headset/headset_cent
	glasses = /obj/item/clothing/glasses/sunglasses/reagent
	gloves = /obj/item/clothing/gloves/color/black
	l_pocket = /obj/item/modular_computer/pda/heads
	id = /obj/item/card/id/advanced/centcom
	id_trim = /datum/id_trim/centcom/bartender

/datum/outfit/vortex_bartender/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/card/id/id_card = H.wear_id
	if(istype(id_card))
		id_card.registered_name = H.real_name
		id_card.update_label()
		id_card.update_icon()

	return ..()
