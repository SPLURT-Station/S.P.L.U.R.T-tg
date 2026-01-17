#define ROLE_MOFFUCHIS "Moffuchi's Pizzaria Staff"

/datum/job/moffuchis // Job Define
	title = ROLE_MOFFUCHIS
	policy_index = ROLE_MOFFUCHIS
	akula_outfit = /datum/outfit/akula
	antagonist_restricted = TRUE

/obj/effect/mob_spawn/ghost_role/human/moffuchis
	name = "Moffuchi's Pizzaria Employee"
	desc = "An occupied cryopod, under all that frost you can see a figure, wearing an employee uniform. It seems to be attempting to wake them up."
	icon = 'modular_skyrat/modules/cryosleep/icons/cryogenics.dmi'
	icon_state = "cryopod"
	prompt_name = "a pizzaria employee"
	you_are_text = "You are a non-descript employee for an old pizzaria on the Icemoon."
	flavour_text = "Your employers sent you to an old, rundown family-run pizzaria joint on the Icemoon, with a beacon, and teleporter. You heard news that Nanotrasen had begun plasma mining nearby, you were freed from cryogenics to bank on these possible new customers. You're to help all the customers to their meals, and requests until your manager says otherwise!"
	important_text = "Do NOT abandon the Pizzaria or let it get damaged!"
	spawner_job_path = /datum/job/moffuchis
	quirks_enabled = TRUE
	random_appearance = FALSE
	loadout_enabled = FALSE
	outfit = /datum/outfit/moffuchis

/obj/effect/mob_spawn/ghost_role/human/moffuchis/Destroy()
	new/obj/machinery/cryopod/moffuchi(drop_location())
	return ..()

/obj/machinery/cryopod/moffuchi
	dir = 4

/datum/outfit/moffuchis
	name = "Moffuchi's Pizzaria Employee"
	uniform = /obj/item/clothing/under/costume/moffuchis
	suit = /obj/item/clothing/suit/toggle/moffuchis
	back = /obj/item/storage/backpack/satchel/blueshield
	neck = /obj/item/clothing/neck/scarf/cyan
	box = /obj/item/storage/box/survival
	shoes = /obj/item/clothing/shoes/sneakers/black
	ears = null
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/soft/moffuchis
	l_pocket = /obj/item/modular_computer/pda
	id = /obj/item/card/id/advanced/moffuchis
	id_trim = /datum/id_trim/away/moffuchis

/datum/outfit/moffuchis/post_equip(mob/living/carbon/human/moffuchis, visualsOnly = FALSE)
	var/obj/item/card/id/id_card = moffuchis.wear_id
	if(istype(id_card))
		id_card.registered_name = moffuchis.real_name
		id_card.update_label()
		id_card.update_icon()

	handlebank(moffuchis)
	return ..()

/obj/effect/mob_spawn/ghost_role/human/moffuchis_manager
	name = "Moffuchi's Pizzaria Manager"
	desc = "An occupied cryopod, under all that frost you can see a figure, wearing an employee uniform. It seems to be attempting to wake them up."
	icon = 'modular_skyrat/modules/cryosleep/icons/cryogenics.dmi'
	icon_state = "cryopod"
	prompt_name = "a pizzaria manager"
	you_are_text = "You are a non-descript manager for an old pizzaria on the Icemoon."
	flavour_text = "Your employers sent you to an old, rundown family-run pizzaria joint on the Icemoon, with a beacon, and teleporter. You heard news that Nanotrasen had begun plasma mining nearby, you were freed from cryogenics to bank on these possible new customers. You're to help all the customers to their needs, and requests! You're the boss, make the rules!"
	important_text = "Do NOT abandon the Pizzaria or let it get damaged!"
	spawner_job_path = /datum/job/moffuchis
	quirks_enabled = TRUE
	random_appearance = FALSE
	loadout_enabled = FALSE
	outfit = /datum/outfit/moffuchis/manager

/obj/effect/mob_spawn/ghost_role/human/moffuchis_manager/Destroy()
	new/obj/machinery/cryopod/moffuchi(drop_location())
	return ..()

/datum/outfit/moffuchis/manager
	name = "Moffuchi's Pizzaria Manager"
	uniform = /obj/item/clothing/under/costume/moffuchis/manager
	suit = /obj/item/clothing/suit/toggle/jacket/zubber/bomber/science/coroner
	back = /obj/item/storage/backpack/satchel/leather
	neck = /obj/item/clothing/neck/scarf/cyan
	box = /obj/item/storage/box/survival/engineer
	shoes = /obj/item/clothing/shoes/laceup
	ears = null
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/color/black
	head = null
	l_pocket = /obj/item/modular_computer/pda
	id = /obj/item/card/id/advanced/moffuchis/manager
	id_trim = /datum/id_trim/away/moffuchis/manager

/obj/item/card/id/advanced/moffuchis
	name = "employee identification card"
	desc = "An employee ID card that Moffuchi's Pizzaria employees use to get into places, it looks more like a keycard or nametag, some corporate-styled card."
	icon = 'modular_zzplurt/icons/obj/card.dmi'
	icon_state = "moffuchis_employee"
	assigned_icon_state = null

/obj/item/card/id/advanced/moffuchis/manager
	name = "manager identification card"
	desc = "An employee ID card that Moffuchi's Pizzaria employees use to get into places, it looks more like a keycard or nametag, some corporate-styled card. This one is suited for a Manager, due to the gold stripe."
	icon_state = "moffuchis_manager"

/datum/id_trim/away/moffuchis
	assignment = "Moffuchi's Pizzaria Employee"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_ENGINEERING, ACCESS_ROBOTICS)

/datum/id_trim/away/moffuchis/manager
	assignment = "Moffuchi's Pizzaria Manager"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_ENGINEERING, ACCESS_AWAY_COMMAND, ACCESS_ROBOTICS, ACCESS_WEAPONS)

/obj/item/paper/fluff/ruins/moffuchis_pizza
	name = "Notice of Reassignment"
	default_raw_text = "Congratulations employees on your positions within this sector within one of our forgotten joints on the Icemoon! We've decided to get you up out of cryo due to the recent Nanotrasen Corp activity! This means potential customers, try to get a good profit for us. In other news, exterminators were called yesterday, and dealt with the spider infestation. Do keep in mind that there MAY be some surviving spiders. Anyways! Keep in mind that quite a massive mess was left, so you best clean up before you open to the public, this place has been left to gather dust for a while. Anyways, congratulations again! Enjoy your shift. - MOFFUCHI PIZZA REGIONAL MANAGEMENT."

/obj/machinery/computer/centcom_announcement/moffuchis
	name = "moffuchi's pizza advertisement console"
	desc = "A console used for making priority Internal Affairs Collegium dispatch reports."
	req_access = list(ACCESS_AWAY_COMMAND)
	circuit = null
	command_name = "Moffuchi's Pizzaria Advertisement"
	report_sound = 'sound/announcer/announcement/announce_dig.ogg'

/obj/item/card/id/departmental_budget/moffuchis
	department_ID = ACCOUNT_AAD
	department_name = "Moffuchi's Pizzaria Budget"
	icon_state = "srv_budget" // looks close enough

/obj/item/circuitboard/computer/order_console/moffuchis
	name = "Moffuchi's Pizzaria Orders Console"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/computer/order_console/cook/moffuchis

/obj/machinery/computer/order_console/cook/moffuchis
	name = "Moffuchi's Pizzaria produce orders console"
	desc = "An interface for ordering fresh produce and other. The cornerstone of any nutritious meal for the stranded pizza employees."
	circuit = /obj/item/circuitboard/computer/order_console/moffuchis
	blackbox_key = null
	forced_express = TRUE

	/// The account to add balance
	var/credits_account = ACCOUNT_AAD
	/// The resolved bank account
	var/datum/bank_account/synced_bank_account = null

/obj/machinery/computer/order_console/cook/moffuchis/post_machine_initialize()
	. = ..()
	synced_bank_account = SSeconomy.get_dep_account(credits_account == "" ? ACCOUNT_CAR : credits_account)

/obj/machinery/computer/order_console/cook/moffuchis/ui_data(mob/user)
	var/list/data = ..()
	data["points"] = !synced_bank_account ? 0 : synced_bank_account.account_balance
	return data

/obj/machinery/computer/order_console/cook/moffuchis/purchase_items(obj/item/card/id/card, express = FALSE)
	if(!synced_bank_account)
		say("Error, no department account found. Please report to your Regional Manager.")
		return FALSE
	var/final_cost = round(get_total_cost() * (express ? express_cost_multiplier : cargo_cost_multiplier))
	if(synced_bank_account.adjust_money(-final_cost, "[name]: Purchase"))
		return TRUE
	say("Sorry, but you do not have enough [credit_type].")
	return FALSE

/obj/structure/closet/secure_closet/personal/cabinet/moffuchis
	name = "manager's personal cabinet"
	req_access = list(ACCESS_AWAY_COMMAND)

/obj/structure/closet/secure_closet/personal/cabinet/moffuchis/PopulateContents()
	new /obj/item/storage/backpack/satchel/leather/withwallet(src)
	new /obj/item/instrument/piano_synth(src)
	new /obj/item/clothing/shoes/winterboots/ice_boots/eva(src)
	new /obj/item/crowbar(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/clothing/under/costume/moffuchis/manager(src)
	new /obj/item/clothing/suit/toggle/jacket/zubber/bomber/science/coroner(src)
	new /obj/item/clothing/head/soft/moffuchis(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/neck/scarf/cyan(src)
