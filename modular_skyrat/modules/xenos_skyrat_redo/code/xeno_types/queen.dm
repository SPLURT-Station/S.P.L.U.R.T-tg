/// SKYRAT MODULE SKYRAT_XENO_REDO

/mob/living/carbon/alien/adult/skyrat/queen
	name = "alien queen"
	desc = "A hulking beast of an alien, for some reason this one seems more important than the others, you should probably quit staring at it and do something."
	caste = "queen"
	maxHealth = 500
	status_flags = NONE //can't shove or KO the queen, kiddo.
	health = 500
	icon_state = "alienqueen"
	melee_damage_lower = 30
	melee_damage_upper = 35
	default_organ_types_by_slot = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/alien,
		ORGAN_SLOT_XENO_HIVENODE = /obj/item/organ/alien/hivenode,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/alien,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/alien,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/alien,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/alien,
		ORGAN_SLOT_XENO_PLASMAVESSEL = /obj/item/organ/alien/plasmavessel/large/queen,
		ORGAN_SLOT_XENO_RESINSPINNER = /obj/item/organ/alien/resinspinner,
		ORGAN_SLOT_XENO_NEUROTOXINGLAND = /obj/item/organ/alien/neurotoxin/queen,
		ORGAN_SLOT_XENO_EGGSAC = /obj/item/organ/alien/eggsac
	)

/mob/living/carbon/alien/adult/skyrat/queen/Initialize(mapload)
	. = ..()
	var/static/list/innate_actions = list(
		/datum/action/cooldown/spell/aoe/repulse/xeno/skyrat_tailsweep/hard_throwing,
		/datum/action/cooldown/alien/skyrat/queen_screech,
	)
	grant_actions_by_list(innate_actions)

	REMOVE_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

	add_movespeed_modifier(/datum/movespeed_modifier/alien_big)

/mob/living/carbon/alien/adult/skyrat/queen/alien_talk(message, shown_name = name)
	..(message, shown_name, TRUE)

/obj/item/organ/alien/neurotoxin/queen
	name = "neurotoxin gland"
	icon_state = "neurotox"
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = ORGAN_SLOT_XENO_NEUROTOXINGLAND
	actions_types = list(
		/datum/action/cooldown/alien/acid/skyrat,
		/datum/action/cooldown/alien/acid/skyrat/lethal,
		/datum/action/cooldown/alien/acid/corrosion,
	)

/mob/living/carbon/alien/adult/skyrat/queen/death(gibbed)
	if(stat == DEAD)
		return

	for(var/mob/living/carbon/carbon_mob in GLOB.alive_mob_list)
		if(carbon_mob == src)
			continue

		var/obj/item/organ/alien/hivenode/node = carbon_mob.get_organ_by_type(/obj/item/organ/alien/hivenode)

		if(istype(node))
			node.queen_death()

	return ..()

/datum/action/cooldown/alien/skyrat/queen_screech
	name = "Deafening Screech"
	desc = "Let out a screech so deafeningly loud that anything with the ability to hear around you will likely be incapacitated for a short time."
	button_icon_state = "screech"
	cooldown_time = 5 MINUTES

/datum/action/cooldown/alien/skyrat/queen_screech/Activate()
	. = ..()
	var/mob/living/carbon/alien/adult/skyrat/queenie = owner
	playsound(queenie, 'modular_skyrat/modules/xenos_skyrat_redo/sound/alien_queen_screech.ogg', 100, FALSE, 8, 0.9)
	queenie.create_shriekwave()
	shake_camera(owner, 2, 2)

	for(var/mob/living/carbon/human/screech_target in get_hearers_in_view(7, get_turf(queenie)))
		screech_target.soundbang_act(intensity = 3, stun_pwr = 80, damage_pwr = 5, deafen_pwr = 10) // Only being deaf or in space with protection will save you
		shake_camera(screech_target, 4, 3)
		to_chat(screech_target, span_doyourjobidiot("[queenie] lets out a deafening screech!"))

	return TRUE

/mob/living/carbon/alien/adult/skyrat/proc/create_shriekwave()
	remove_overlay(HALO_LAYER)
	overlays_standing[HALO_LAYER] = image("icon" = 'modular_skyrat/modules/xenos_skyrat_redo/icons/big_xenos.dmi', "icon_state" = "shriek_waves") //Ehh, suit layer's not being used.
	apply_overlay(HALO_LAYER)
	addtimer(CALLBACK(src, PROC_REF(remove_shriekwave)), 3 SECONDS)

/mob/living/carbon/alien/adult/skyrat/proc/remove_shriekwave()
	remove_overlay(HALO_LAYER)
