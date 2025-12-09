/mob/living/basic/zombie_interdyne
	name = "BASE MOB"
	desc = "One of the unfortunate Interdyne employees who fell to the Romerol virus."
	icon = 'icons/mob/simple/simple_human.dmi'
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	sentience_type = SENTIENCE_HUMANOID
	maxHealth = 100
	health = 100
	melee_damage_lower = 21
	melee_damage_upper = 21
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/effects/hallucinations/growl1.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
	combat_mode = TRUE
	speed = 4
	status_flags = CANPUSH | CANSTUN
	death_message = "collapses to the ground."
	unsuitable_atmos_damage = 0
	unsuitable_cold_damage = 0
	faction = list(FACTION_HOSTILE)
	basic_mob_flags = DEL_ON_DEATH
	ai_controller = /datum/ai_controller/basic_controller/zombie
	/// Outfit the zombie spawns with for visuals.
	var/outfit = /datum/outfit/corpse_doctor
	/// Chance to spread zombieism on hit
	/// Only for admins because we don't actually want romerol to get into the round from space ruins generally speaking
	var/infection_chance = 0

/mob/living/basic/zombie_interdyne/melee_attack(atom/target, list/modifiers, ignore_cooldown)
	. = ..()
	if (!. || !infection_chance || !ishuman(target) || !prob(infection_chance))
		return
	try_to_zombie_infect(target)

/obj/effect/mob_spawn/corpse/human/interdyne
	name = "Interdyne Doctor"
	outfit = /datum/outfit/interdynecorpse
	icon_state = "corpsedoctor"

/obj/effect/mob_spawn/corpse/human/zombie/interdyne
	name = "Infected Interdyne Doctor"
	mob_species = /datum/species/zombie
	outfit = /datum/outfit/interdynecorpse

/mob/living/basic/zombie_interdyne/doctor
	name = "Shambling Doctor"
	outfit = /datum/outfit/interdynecorpse

/mob/living/basic/zombie_interdyne/doctor/Initialize(mapload)
	. = ..()
	apply_dynamic_human_appearance(src, outfit, /datum/species/zombie, bloody_slots = ITEM_SLOT_OCLOTHING)
	AddElement(/datum/element/death_drops, string_list(list(/obj/effect/mob_spawn/corpse/human/zombie/interdyne)))

/datum/outfit/interdynecorpse
	name = "Interdyne Doctor Corpse"
	uniform = /obj/item/clothing/under/syndicate/scrubs
	suit = /obj/item/clothing/suit/toggle/labcoat/interdyne
	belt = /obj/item/storage/belt/medical/paramedic
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/latex/nitrile/ntrauma
	ears = /obj/item/radio/headset/syndicateciv
	head = /obj/item/clothing/head/utility/surgerycap/purple
	mask = /obj/item/clothing/mask/surgical
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/advanced/black/syndicate_command
	id_trim = /datum/id_trim/syndicom/interdyne_research/doctor

/obj/effect/mob_spawn/corpse/human/interdyne/geneticist
	name = "Interdyne Geneticist"
	outfit = /datum/outfit/interdynegeneticcorpse
	icon_state = "corpsescientist"

/obj/effect/mob_spawn/corpse/human/zombie/interdyne/geneticist
	name = "Infected Interdyne Geneticist"
	mob_species = /datum/species/zombie
	outfit = /datum/outfit/interdynegeneticcorpse

/mob/living/basic/zombie_interdyne/geneticist
	name = "Shambling Geneticist"
	outfit = /datum/outfit/interdynegeneticcorpse

/mob/living/basic/zombie_interdyne/geneticist/Initialize(mapload)
	. = ..()
	apply_dynamic_human_appearance(src, outfit, /datum/species/zombie, bloody_slots = ITEM_SLOT_OCLOTHING)
	AddElement(/datum/element/death_drops, string_list(list(/obj/effect/mob_spawn/corpse/human/zombie/interdyne/geneticist)))

/datum/outfit/interdynegeneticcorpse
	name = "Interdyne Geneticist Corpse"
	uniform = /obj/item/clothing/under/syndicate/scrubs
	suit = /obj/item/clothing/suit/toggle/labcoat/interdyne
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	ears = /obj/item/radio/headset/syndicateciv
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/advanced/black/syndicate_command
	id_trim = /datum/id_trim/syndicom/interdyne_research/geneticist

/obj/effect/mob_spawn/corpse/human/interdyne/engineer
	name = "Interdyne Engineer"
	outfit = /datum/outfit/interdyneengineercorpse
	icon_state = "corpseengineer"

/obj/effect/mob_spawn/corpse/human/zombie/interdyne/engineer
	name = "Infected Interdyne Engineer"
	mob_species = /datum/species/zombie
	outfit = /datum/outfit/interdyneengineercorpse

/mob/living/basic/zombie_interdyne/engineer
	name = "Shambling Engineer"
	outfit = /datum/outfit/interdyneengineercorpse

/mob/living/basic/zombie_interdyne/engineer/Initialize(mapload)
	. = ..()
	apply_dynamic_human_appearance(src, outfit, /datum/species/zombie, bloody_slots = ITEM_SLOT_OCLOTHING)
	AddElement(/datum/element/death_drops, string_list(list(/obj/effect/mob_spawn/corpse/human/zombie/interdyne/engineer)))

/datum/outfit/interdyneengineercorpse
	name = "Interdyne Engineer Corpse"
	uniform = /obj/item/clothing/under/syndicate/skyrat/overalls
	belt = /obj/item/storage/belt/utility/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/syndicateciv
	head = /obj/item/clothing/head/soft/sec/syndicate
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/advanced/black/syndicate_command
	id_trim = /datum/id_trim/syndicom/interdyne_research/engineer

/obj/effect/mob_spawn/corpse/human/interdyne/chemist
	name = "Interdyne Chemist"
	outfit = /datum/outfit/interdynechemistcorpse
	icon_state = "corpsedoctor"

/obj/effect/mob_spawn/corpse/human/zombie/interdyne/chemist
	name = "Infected Interdyne Chemist"
	mob_species = /datum/species/zombie
	outfit = /datum/outfit/interdynechemistcorpse

/mob/living/basic/zombie_interdyne/chemist
	name = "Shambling Chemist"
	outfit = /datum/outfit/interdynechemistcorpse

/mob/living/basic/zombie_interdyne/chemist/Initialize(mapload)
	. = ..()
	apply_dynamic_human_appearance(src, outfit, /datum/species/zombie, bloody_slots = ITEM_SLOT_OCLOTHING)
	AddElement(/datum/element/death_drops, string_list(list(/obj/effect/mob_spawn/corpse/human/zombie/interdyne/chemist)))

/datum/outfit/interdynechemistcorpse
	name = "Interdyne Chemist Corpse"
	uniform = /obj/item/clothing/under/syndicate/scrubs
	suit = /obj/item/clothing/suit/bio_suit/general
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/latex
	ears = /obj/item/radio/headset/syndicateciv
	head = /obj/item/clothing/head/bio_hood/general
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/advanced/black/syndicate_command
	id_trim = /datum/id_trim/syndicom/interdyne_research/chemist

/obj/effect/mob_spawn/corpse/human/interdyne/cargo
	name = "Interdyne Cargo Technician"
	outfit = /datum/outfit/interdynecargocorpse
	icon_state = "corpsecargotech"

/obj/effect/mob_spawn/corpse/human/zombie/interdyne/cargo
	name = "Infected Interdyne Cargo Technician"
	mob_species = /datum/species/zombie
	outfit = /datum/outfit/interdynecargocorpse

/mob/living/basic/zombie_interdyne/cargo
	name = "Shambling Cargo Technicain"
	outfit = /datum/outfit/interdynecargocorpse

/mob/living/basic/zombie_interdyne/cargo/Initialize(mapload)
	. = ..()
	apply_dynamic_human_appearance(src, outfit, /datum/species/zombie, bloody_slots = ITEM_SLOT_OCLOTHING)
	AddElement(/datum/element/death_drops, string_list(list(/obj/effect/mob_spawn/corpse/human/zombie/interdyne/cargo)))

/datum/outfit/interdynecargocorpse
	name = "Interdyne Cargo Technician Corpse"
	uniform = /obj/item/clothing/under/syndicate/skyrat/overalls
	suit = /obj/item/clothing/suit/armor/vest/alt
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/syndicateciv
	head = /obj/item/clothing/head/soft/black
	mask = /obj/item/clothing/mask/gas/syndicate
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/advanced/black/syndicate_command
	id_trim = /datum/id_trim/syndicom/interdyne_research/cargo

/obj/effect/mob_spawn/corpse/human/interdyne/head
	name = "Interdyne Medical Director"
	outfit = /datum/outfit/interdyneheadcorpse
	icon_state = "corpsedoctor"

/datum/outfit/interdyneheadcorpse
	name = "Interdyne Medical Director Corpse"
	uniform = /obj/item/clothing/under/syndicate/skyrat/tactical
	suit = /obj/item/clothing/suit/toggle/labcoat/skyrat/regular
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/syndicateciv/command/empty
	head = /obj/item/clothing/head/hats/hos/beret/syndicate
	mask = /obj/item/clothing/mask/gas/syndicate
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/advanced/black/syndicate_command
	id_trim = /datum/id_trim/syndicom/interdyne_research/medicaldirector

/obj/effect/mob_spawn/corpse/human/zombie/interdyne/patient
	name = "Interdyne Patient Zero Corpse"
	mob_species = /datum/species/zombie
	outfit = /datum/outfit/interdynepatient

/mob/living/basic/zombie_interdyne/patient
	name = "Patient Zero"
	outfit = /datum/outfit/interdynepatient

/mob/living/basic/zombie_interdyne/patient/Initialize(mapload)
	. = ..()
	apply_dynamic_human_appearance(src, outfit, /datum/species/zombie, bloody_slots = ITEM_SLOT_OCLOTHING)
	AddElement(/datum/element/death_drops, string_list(list(/obj/effect/mob_spawn/corpse/human/zombie/interdyne/patient)))

/datum/outfit/interdynepatient
	name = "Interdyne Patient Zero Corpse"
	uniform = null
	suit = /obj/item/clothing/suit/toggle/labcoat/hospitalgown
	shoes = null
	gloves = null
	ears = null
	head = null
	mask = null
	back = null
	id = null
	id_trim = null

/obj/item/radio/headset/syndicateciv/command/empty
	name = "Syndicate command headset"
	desc = "A commanding headset to gather your minions. Protects the ears from flashbangs."
	command = TRUE
	keyslot = null
