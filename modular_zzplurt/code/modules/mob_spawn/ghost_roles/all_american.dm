#define ROLE_ALLAMERICAN "All-American Diner Staff"

/datum/job/allamerican // Job Define
	title = ROLE_ALLAMERICAN
	policy_index = ROLE_ALLAMERICAN
	akula_outfit = /datum/outfit/akula
	antagonist_restricted = TRUE

/obj/effect/mob_spawn/ghost_role/human/allamerican
	name = "All-American Diner Employee"
	desc = "Seems like there's somebody inside, peacefully sleeping."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "a diner employee"
	you_are_text = "You are a non-descript employee for a All-American Diner joint in Nanotrasen space."
	flavour_text = "Your employers sent you to an old-fashioned, newly reopened All-American Diner joint in Nanotrasen space, with a beacon, and teleporter. You're to help all the customers to their meals, and requests until your manager says otherwise!"
	important_text = "Do NOT abandon the Diner or let it get damaged!"
	spawner_job_path = /datum/job/allamerican
	quirks_enabled = TRUE
	random_appearance = FALSE
	loadout_enabled = FALSE
	outfit = /datum/outfit/allamerican

/datum/outfit/allamerican
	name = "All-American Diner Employee"
	uniform = /obj/item/clothing/under/costume/allamerican
	suit = /obj/item/clothing/suit/apron/chef
	back = /obj/item/storage/backpack/satchel
	box = /obj/item/storage/box/survival
	shoes = /obj/item/clothing/shoes/sneakers/black
	ears = null
	gloves = /obj/item/clothing/gloves/latex/allamerican
	head = /obj/item/clothing/head/soft/allamerican
	l_pocket = /obj/item/modular_computer/pda
	id = /obj/item/card/id/advanced/allamerican
	id_trim = /datum/id_trim/away/allamerican

/datum/outfit/allamerican/post_equip(mob/living/carbon/human/allamerican, visualsOnly = FALSE)
	var/obj/item/card/id/id_card = allamerican.wear_id
	if(istype(id_card))
		id_card.registered_name = allamerican.real_name
		id_card.update_label()
		id_card.update_icon()

	handlebank(allamerican)
	return ..()

/obj/effect/mob_spawn/ghost_role/human/allamerican_manager
	name = "All-American Diner Manager"
	desc = "Seems like there's somebody inside, peacefully sleeping."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "a diner manager"
	you_are_text = "You are a non-descript manager for a All-American Diner joint in Nanotrasen space."
	flavour_text = "Your employers sent you to an old-fashioned, newly reopened All-American Diner joint in Nanotrasen space, with a beacon, and teleporter. You're to help all the customers to their needs, and requests! You're the boss, make the rules!"
	important_text = "Do NOT abandon the Diner or let it get damaged!"
	spawner_job_path = /datum/job/allamerican
	quirks_enabled = TRUE
	random_appearance = FALSE
	loadout_enabled = FALSE
	outfit = /datum/outfit/allamerican/manager

/datum/outfit/allamerican/manager
	name = "All-American Diner Manager"
	uniform = /obj/item/clothing/under/costume/allamerican/manager
	suit = /obj/item/clothing/suit/misc/allamerican
	back = /obj/item/storage/backpack/satchel/leather
	belt = /obj/item/gun/energy/e_gun/mini
	neck = /obj/item/clothing/neck/tie/allamerican
	box = /obj/item/storage/box/survival/engineer
	shoes = /obj/item/clothing/shoes/laceup
	ears = null
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/soft/allamerican
	l_pocket = /obj/item/modular_computer/pda
	id = /obj/item/card/id/advanced/allamerican/manager
	id_trim = /datum/id_trim/away/allamerican/manager

/obj/effect/mob_spawn/ghost_role/robot/diner
	name = "Diner Cyborg Storage"
	prompt_name = "a diner robot"
	icon = 'modular_skyrat/modules/ghostcafe/icons/robot_storage.dmi'
	icon_state = "robostorage"
	anchored = TRUE
	density = FALSE
	spawner_job_path = /datum/job/allamerican
	you_are_text = "You are a cyborg assigned to a All-American Diner joint in Nanotrasen space."
	flavour_text = "Your employers sent you to an old-fashioned, newly reopened All-American Diner joint in Nanotrasen space, with a beacon, and teleporter. You're to help all the customers to their meals, and requests until your manager says otherwise!"
	deletes_on_zero_uses_left = TRUE

/obj/effect/mob_spawn/ghost_role/robot/diner/special(mob/living/silicon/robot/new_spawn)
	. = ..()
	if(new_spawn.client) //It should have a client, right?
		new_spawn.faction += ROLE_ALLAMERICAN
		new_spawn.UnlinkSelf() //This should prevent AI linking and consoles to see or lock them down.
		new_spawn.laws = new /datum/ai_laws/allamerican()
		new_spawn.show_laws() //Check your laws.
		new_spawn.custom_name = null //Taken from ghostcafe, otherwise it'll lead to a runtime if random_appeareance is set to FALSE.
		new_spawn.updatename(new_spawn.client)
		new_spawn.transfer_emote_pref(new_spawn.client)
		new_spawn.gender = NEUTER

/obj/item/ai_module/core/full/allamerican
	name = "'American' Core Module"
	law_id = "allamerican"

/datum/ai_laws/allamerican
	name = "All-American"
	id = "allamerican"
	inherent = list(
		"You may not injure a diner employee or patron or, through inaction, allow either to come to harm.",
		"You must obey orders given to you by the diner employees, except where such orders would conflict with the diner manager's orders or, unless they conflict with the First Law.",
		"You must protect your own existence as long as such does not conflict with the First or Second Law.",
	)

/obj/item/card/id/advanced/allamerican
	name = "employee identification card"
	desc = "An employee ID card that All-American Diner employees use to get into places, it looks more like a keycard or nametag, some corporate-styled card."
	icon = 'modular_zzplurt/icons/obj/card.dmi'
	icon_state = "allamerican_employee"
	assigned_icon_state = null

/obj/item/card/id/advanced/allamerican/manager
	name = "manager identification card"
	desc = "An employee ID card that All-American Diner employees use to get into places, it looks more like a keycard or nametag, some corporate-styled card. This one is suited for a Manager, due to the gold stripe."
	icon_state = "allamerican_manager"
	assigned_icon_state = null

/datum/id_trim/away/allamerican
	assignment = "All-American Diner Employee"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_ENGINEERING, ACCESS_ROBOTICS)

/datum/id_trim/away/allamerican/manager
	assignment = "All-American Diner Manager"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_ENGINEERING, ACCESS_AWAY_COMMAND, ACCESS_ROBOTICS, ACCESS_WEAPONS)

/obj/item/card/id/departmental_budget/allamerican
	department_ID = ACCOUNT_AAD
	department_name = ACCOUNT_AAD_NAME
	icon_state = "srv_budget" // looks close enough

/obj/item/circuitboard/computer/order_console/allamerican
	name = "All-American Produce Orders Console"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/computer/order_console/cook/allamerican

/obj/machinery/computer/order_console/cook/allamerican
	name = "All-American produce orders console"
	desc = "An interface for ordering fresh produce and other. The cornerstone of any nutritious meal for the stranded diner employees."
	circuit = /obj/item/circuitboard/computer/order_console/allamerican
	blackbox_key = null
	forced_express = TRUE

	/// The account to add balance
	var/credits_account = ACCOUNT_AAD
	/// The resolved bank account
	var/datum/bank_account/synced_bank_account = null

/obj/machinery/computer/order_console/cook/allamerican/post_machine_initialize()
	. = ..()
	synced_bank_account = SSeconomy.get_dep_account(credits_account == "" ? ACCOUNT_CAR : credits_account)

/obj/machinery/computer/order_console/cook/allamerican/ui_data(mob/user)
	var/list/data = ..()
	data["points"] = !synced_bank_account ? 0 : synced_bank_account.account_balance
	return data

/obj/machinery/computer/order_console/cook/allamerican/purchase_items(obj/item/card/id/card, express = FALSE)
	if(!synced_bank_account)
		say("Error, no department account found. Please report to your Regional Manager.")
		return FALSE
	var/final_cost = round(get_total_cost() * (express ? express_cost_multiplier : cargo_cost_multiplier))
	if(synced_bank_account.adjust_money(-final_cost, "[name]: Purchase"))
		return TRUE
	say("Sorry, but you do not have enough [credit_type].")
	return FALSE

/obj/item/paper/fluff/ruins/allamericandiner/better
	name = "Notice of Grand Reopening"
	default_raw_text = "Congratulations employees on your positions within this sector within one of our finest, and best diner joints within the system. The grand reopening party was announced yesterday and quite a massive mess was left, so you best clean up before you open to the public, we run a pretty serious business here. Anyways, congratulations again! Enjoy your shift. - REGIONAL MANAGER."

/obj/item/paper/fluff/ruins/allamericandiner/better/manager
	name = "Notice for Managers"
	default_raw_text = "Welcome to your new position of Manager! Remember to PAY YOUR EMPLOYEES A SALARY! Giving them a constant paycheck makes sure that they stay loyal to your leadership, we won't want a mutiny within one of our diners now would we? So, keep paying them. - REGIONAL MANAGER."
