/obj/effect/mob_spawn/ghost_role/human/ash_walkers_slave
	name = "Necropolis Slave Casket"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "oldpod"
	prompt_name = "a ashwalkers slave"
	you_are_text = "You are a slave of the Necropolis and the Ash Walkers that protect it."
	flavour_text = "It is in your best interest to comply with any orders given by your superiors, the desire to escape \
	should be minimized under most circumstances."
	important_text = "You MUST submit an Opfor or Adminhelp to defy your superiors and/or escape!"
	outfit = /datum/outfit/ashwalker/slave
	spawner_job_path = /datum/job/ash_walker
	random_appearance = FALSE
	var/datum/team/ashwalkers/team

/obj/effect/mob_spawn/ghost_role/human/ash_walkers_slave/special(mob/living/new_spawn)
	quirks_enabled = TRUE

	. = ..()

	if(!HAS_TRAIT(new_spawn, TRAIT_ROBOTIC_DNA_ORGANS))
		var/obj/item/organ/lungs/lavaland/lungs = new /obj/item/organ/lungs/lavaland()
		lungs.replace_into(new_spawn)
		var/obj/item/organ/eyes/night_vision/ashwalker/eyes = new /obj/item/organ/eyes/night_vision/ashwalker()
		eyes.replace_into(new_spawn)
		var/obj/item/organ/tongue/lizard/tongue = new /obj/item/organ/tongue/lizard()
		tongue.replace_into(new_spawn)
		var/obj/item/organ/brain/primitive/brain = new /obj/item/organ/brain/primitive()
		brain.replace_into(new_spawn)
	else
		new_spawn.put_in_hands(new /obj/item/stock_parts/power_store/cell/infinite/abductor(new_spawn))

	new_spawn.grant_language(/datum/language/draconic, source = LANGUAGE_SPAWNER)
	new_spawn.grant_language(/datum/language/ashtongue, source = LANGUAGE_SPAWNER)
	new_spawn.remove_language(/datum/language/common)

	new_spawn.mind.add_antag_datum(/datum/antagonist/ashwalker, team)
	team.players_spawned += (new_spawn.ckey)

	to_chat(new_spawn, "<b>Drag the corpses of men and beasts to your nest. It will absorb them to create more of your kind. Invade the strange structure of the outsiders if you must. Do not cause unnecessary destruction, as littering the wastes with ugly wreckage is certain to not gain you favor. Glory to the Necropolis!</b>")

/datum/outfit/ashwalker/slave
	name = "Ash Walker - Slave"
	head = null
	uniform = /obj/item/clothing/under/costume/loincloth
	undershirt = null
	underwear = null
	socks = null
