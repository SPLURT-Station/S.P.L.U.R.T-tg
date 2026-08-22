#define TECHWEB_NODE_KHARA_START "evt_khara_start"
#define TECHWEB_NODE_KHARA_BASIC "evt_khara_basic"
#define TECHWEB_NODE_KHARA_INITIAL_INFECTION "evt_khara_initinfection"
#define TECHWEB_NODE_KHARA_AMMUNITION_BASIC "evt_khara_combat"
#define TECHWEB_NODE_KHARA_AMMUNITION_ADVANCED "evt_khara_combatadv"
#define TECHWEB_NODE_KHARA_POSITIVE_BASIC "evt_khara_med_basic"
#define TECHWEB_NODE_KHARA_POSITIVE_ADVANCED "evt_khara_med_advanced"


/datum/design/khara_express_test
	name = "Khara Express Test"
	desc = "The design for a simple lab capable of quickly detecting the presence of Khara antibodies in the blood."
	id = "khara_test"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 1.5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 2,
	)
	build_path = /obj/item/khara_express_test
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/obj/item/khara_express_test
	name = "Khara Express Test"
	desc = "A simple device that is essentially a microscopic laboratory, \
			capable of checking the reaction of organic matter to cells infected with the 'Khara' virus."
	force = 0
	throwforce = 0
	icon = 'fenysha_events/icons/items/devices.dmi'
	icon_state = "kharatest"

	w_class = WEIGHT_CLASS_TINY

	var/disease_path = /datum/disease/khara
	VAR_PRIVATE/used = FALSE


/obj/item/khara_express_test/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!is_reagent_container(tool))
		return ..()
	if(used)
		balloon_alert_to_viewers("Tester already used!")
		return
	perform_test(tool, user)

/obj/item/khara_express_test/proc/perform_test(obj/item/reagent_containers/container, mob/living/user)
	if(container.reagents.total_volume == 0)
		balloon_alert_to_viewers("Sample is empty!")
		return

	if(!container.reagents.has_reagent(/datum/reagent/blood))
		balloon_alert_to_viewers("No blood present in sample!")
		return

	if(!do_after(user, 3 SECONDS, src))
		return

	var/has_khara = FALSE
	for(var/datum/reagent/blood/blood_reagent as anything in container.reagents.reagent_list)
		if(!istype(blood_reagent))
			continue

		var/list/viruses = blood_reagent.data?["viruses"]
		if(!length(viruses))
			continue

		for(var/datum/disease/D as anything in viruses)
			if(istype(D, disease_path))
				has_khara = TRUE

	used = TRUE
	if(has_khara)
		balloon_alert_to_viewers("Hostile pathogen detected!")
		icon_state = "kharatest_bad"
		playsound(src, 'sound/machines/beep/twobeep.ogg', vol = 50, vary = TRUE)
	else
		balloon_alert_to_viewers("Sample is clean!")
		icon_state = "kharatest_good"
		playsound(src, 'sound/machines/buzz/buzz-two.ogg', vol = 40, vary = TRUE)

	update_appearance()

/datum/design/ranged_experi_scanner
	name = "Remote Scanner"
	desc = "An advanced remote scanner that lets you scan targets from a distance. How convenient!"
	id = "ranged_experiscaner"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = COIN_MATERIAL_AMOUNT * 2,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/ranged_experi_scanner
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE


/obj/item/ranged_experi_scanner
	name = "Experi-Scanner"
	desc = "A handheld scanner used for completing the many experiments of modern science."
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'fenysha_events/icons/items/devices.dmi'
	icon_state = "ranged_scaner"
	inhand_icon_state = "export_scanner"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	sound_vary = TRUE
	pickup_sound = SFX_GENERIC_DEVICE_PICKUP
	drop_sound = SFX_GENERIC_DEVICE_DROP

	var/max_distance = 5
	var/datum/component/experiment_handler/handler = null

/obj/item/ranged_experi_scanner/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/ranged_experi_scanner/LateInitialize()
	var/static/list/handheld_signals = list(
		COMSIG_ITEM_PRE_ATTACK = TYPE_PROC_REF(/datum/component/experiment_handler, try_run_handheld_experiment),
		COMSIG_ITEM_AFTERATTACK = TYPE_PROC_REF(/datum/component/experiment_handler, ignored_handheld_experiment_attempt),
	)
	handler = AddComponent(/datum/component/experiment_handler, \
		allowed_experiments = list(/datum/experiment/scanning, /datum/experiment/physical), \
		disallowed_traits = EXPERIMENT_TRAIT_DESTRUCTIVE, \
		config_flags = EXPERIMENT_CONFIG_ALWAYS_ANNOUNCE, \
		experiment_signals = handheld_signals, \
	)

/obj/item/ranged_experi_scanner/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(QDELETED(interacting_with) || QDELETED(user) || user.stat != CONSCIOUS)
		return
	if(get_dist(get_turf(src), interacting_with) > max_distance)
		balloon_alert(user, "Too far away!")
		return
	handler.try_run_handheld_experiment(src, interacting_with, user, modifiers)

/**
 * Experiment: Scanning blood samples with the Khara virus
 */
/datum/experiment/scanning/blood_khara
	name = "Scanning Blood Samples with the Khara Virus"
	description = "Scan blood samples containing the Khara virus."
	exp_tag = "Blood Scanning"
	allowed_experimentors = list(/obj/item/experi_scanner, /obj/item/ranged_experi_scanner, /obj/item/scanner_wand)
	required_atoms = list(/obj/item/reagent_containers = 1)
	/// Required virus
	var/datum/disease/required_disease = /datum/disease/khara

/datum/experiment/scanning/blood_khara/final_contributing_index_checks(datum/component/experiment_handler/experiment_handler, atom/target, typepath)
	. = ..()
	if(!.)
		return FALSE
	if(!istype(target, /obj/item/reagent_containers))
		return FALSE
	return is_valid_scan_target(experiment_handler, target)

/datum/experiment/scanning/blood_khara/proc/is_valid_scan_target(datum/component/experiment_handler/experiment_handler, obj/item/reagent_containers/container)
	SHOULD_CALL_PARENT(TRUE)
	if(container.reagents.total_volume == 0)
		experiment_handler.announce_message("Blood sample is empty!")
		return FALSE

	if(!container.reagents.has_reagent(/datum/reagent/blood))
		experiment_handler.announce_message("No blood present in sample!")
		return FALSE

	for(var/datum/reagent/blood/blood_reagent as anything in container.reagents.reagent_list)
		if(!istype(blood_reagent))
			continue

		var/list/viruses = blood_reagent.data?["viruses"]
		if(!length(viruses))
			continue

		for(var/datum/disease/D as anything in viruses)
			if(istype(D, required_disease))
				return TRUE

	experiment_handler.announce_message("Khara virus not detected in blood sample!")
	return FALSE

/datum/experiment/scanning/blood_khara/serialize_progress_stage(atom/target, list/seen_instances)
	return EXPERIMENT_PROG_INT("Scan [required_atoms[target]] blood samples with the [required_disease::name] virus.", \
		seen_instances.len, required_atoms[target])

/**
 * Experiment: Scanning an infected human (visible Khara disease)
 */
/datum/experiment/scanning/infected_human
	name = "Scanning an Infected Human"
	description = "Scan a living human afflicted by the Khara virus."
	allowed_experimentors = list(/obj/item/experi_scanner, /obj/item/ranged_experi_scanner, /obj/item/scanner_wand)
	required_atoms = list(/mob/living/carbon/human = 1)
	/// Required virus
	var/datum/disease/required_disease = /datum/disease/khara
	/// Minimum disease stage
	var/required_stage = 1
	/// Whether the disease must be visible (TRUE = no invisibility flags)
	var/required_visible = TRUE

/datum/experiment/scanning/infected_human/final_contributing_index_checks(datum/component/experiment_handler/experiment_handler, atom/target, typepath)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(target))
		return FALSE
	return is_valid_scan_target(experiment_handler, target)

/datum/experiment/scanning/infected_human/proc/is_valid_scan_target(datum/component/experiment_handler/experiment_handler, mob/living/carbon/human/target)
	SHOULD_CALL_PARENT(TRUE)
	if(target.stat == DEAD)
		experiment_handler.announce_message("Target is dead!")
		return FALSE

	if(!length(target.diseases))
		experiment_handler.announce_message("Target has no active diseases!")
		return FALSE

	for(var/datum/disease/D as anything in target.diseases)
		if(!istype(D, required_disease))
			continue

		// Visibility check
		if(required_visible && D.visibility_flags)
			continue

		// Stage check
		if(D.stage >= required_stage)
			return TRUE

		experiment_handler.announce_message("Virus stage is insufficient! Stage [required_stage] is required at minimum.")
		return FALSE

	experiment_handler.announce_message("The [required_disease::name] virus was not detected!")
	return FALSE

/datum/experiment/scanning/infected_human/serialize_progress_stage(atom/target, list/seen_instances)
	var/visible_text = required_visible ? " (the virus must be visible when scanned)" : ""
	return EXPERIMENT_PROG_INT("Scan a human infected with the [required_disease::name] virus, at stage [required_stage] or higher.[visible_text]", \
		seen_instances.len, required_atoms[target])

/datum/experiment/scanning/infected_human/late_khara
	required_stage = 7

/datum/experiment/scanning/infected_human/true_khara
	required_disease = /datum/disease/true_khara

/**
 * Experiment: Scanning creatures afflicted by Khara
 */
/datum/experiment/scanning/khara_creature
	name = "Scanning Khara-Afflicted Creatures"
	description = "Scan creatures that have been turned by the Khara virus."
	performance_hint = "Khara-afflicted creatures are mostly made of muscle tissue. They are easy to slow down with shock weapons."
	allowed_experimentors = list(/obj/item/experi_scanner, /obj/item/ranged_experi_scanner, /obj/item/scanner_wand)

	var/required_count = 3
	var/required_cast = KHARA_CAST_LESSER
	var/mob/living/basic/khara_mutant/restricted_type = null
	var/exploration_text = "The most primitive forms will do - for example, flesh spiders."

/datum/experiment/scanning/khara_creature/New(datum/techweb/techweb)
	required_atoms = list(/mob/living/basic/khara_mutant = required_count)
	return ..()

/datum/experiment/scanning/khara_creature/final_contributing_index_checks(datum/component/experiment_handler/experiment_handler, atom/target, typepath)
	. = ..()
	if(!.)
		return FALSE
	if(!istype(target, /mob/living/basic/khara_mutant))
		return FALSE
	return is_valid_scan_target(experiment_handler, target)

/datum/experiment/scanning/khara_creature/proc/is_valid_scan_target(datum/component/experiment_handler/experiment_handler, mob/living/basic/khara_mutant/target)
	SHOULD_CALL_PARENT(TRUE)
	if(restricted_type && !istype(target, restricted_type))
		experiment_handler.announce_message("Unsuitable mutant type!")
		return FALSE

	if(target.cast != required_cast)
		experiment_handler.announce_message("Mutant belongs to a different caste!")
		return FALSE

	return TRUE

/datum/experiment/scanning/khara_creature/serialize_progress_stage(atom/target, list/seen_instances)
	return EXPERIMENT_PROG_INT("Scan [required_atoms[target]] Khara-afflicted of the [required_cast] caste. [exploration_text]", \
		seen_instances.len, required_atoms[target])

/datum/experiment/scanning/khara_creature/adapted
	required_cast = KHARA_CAST_ADAPTED
	required_count = 2
	exploration_text = "Adapted forms will do - reapers and arachnids."

/datum/experiment/scanning/khara_creature/assimilating
	required_cast = KHARA_CAST_ASSIMILATING
	required_count = 1
	exploration_text = "Assimilating forms will do - spreaders."


/datum/aas_config_entry/khara_research
	name = "Science Alert: Khara Research Progress"
	modifiable = FALSE
	announcement_lines_map = list(
		"Message" = "New information about the Khara virus has been obtained: \"%KHARA_DATA\""
	)
	vars_and_tooltips_map = list(
		"KHARA_DATA" = "will be replaced with the research text"
	)


/datum/techweb_node/khara
	var/document_to_spawn = null
	var/research_text = null

/datum/techweb_node/khara/on_station_research(atom/research_source)
	. = ..()
	var/channels_to_use = announce_channels
	if(istype(research_source, /obj/machinery/computer/rdconsole))
		var/obj/machinery/computer/rdconsole/console = research_source
		var/obj/item/circuitboard/computer/rdconsole/board = console.circuit
		if(board.obj_flags & EMAGGED)
			channels_to_use = list(RADIO_CHANNEL_COMMON)

	if(length(channels_to_use) && research_text)
		aas_config_announce(/datum/aas_config_entry/khara_research, list("KHARA_DATA" = research_text), null, channels_to_use)

	if(document_to_spawn && research_source)
		research_source.visible_message(span_notice("An important research document is being printed!"))
		new document_to_spawn(get_turf(research_source))


// RESEARCH NODES + CORRESPONDING DOCUMENTS


/datum/techweb_node/khara_start
	id = TECHWEB_NODE_KHARA_START
	starting_node = TRUE
	display_name = "Information on the Existence of the Khara Virus"
	description = "You have obtained data on the existence of the Khara virus in the world."
	experiments_to_unlock = list(/datum/experiment/scanning/blood_khara)

/datum/techweb_node/khara/khara_basic
	id = TECHWEB_NODE_KHARA_BASIC
	display_name = "Basic Information on the Khara Virus"
	description = "Preliminary data on the Khara virus and its characteristics has been obtained."
	prereq_ids = list(TECHWEB_NODE_CHEM_SYNTHESIS, TECHWEB_NODE_KHARA_START)
	design_ids = list(
		"khara_test",
		"ranged_experiscaner",
	)

	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	required_experiments = list(/datum/experiment/scanning/blood_khara)
	announce_channels = list(RADIO_CHANNEL_MEDICAL, RADIO_CHANNEL_SCIENCE)
	document_to_spawn = /obj/item/paper/khara_basic_research

	research_text = "Preliminary research has shown that the Khara virus possesses an extremely high resistance to temperature changes, \
					especially to high values. However, radioactive radiation has a pronounced negative effect on infected cells. \
					Administering technetium-99 to a patient can significantly slow the progression of the disease."

/obj/item/paper/khara_basic_research
	name = "Report: Basic Research on the Khara Virus"
	default_raw_text = \
	"<center><b>RESEARCH DEPARTMENT REPORT</b></center>\
	<BR>\
	<b>Subject:</b> Basic information on the Khara virus<BR>\
	<BR>\
	Preliminary research has shown that the Khara virus possesses an extremely high resistance to temperature changes, especially to high values. However, radioactive radiation has a pronounced negative effect on infected cells. Administering technetium-99 to a patient can significantly slow the progression of the disease.\
	<BR><BR>\
	<b>CLASSIFIED - LEVEL III</b><BR>\
	This document is confidential. Copying is prohibited. Discussion outside of scientific and medical personnel is prohibited. Leaving it unguarded is prohibited.\
	<BR><BR>\
	- Research Department"

/datum/techweb_node/khara/khara_initial_infection
	id = TECHWEB_NODE_KHARA_INITIAL_INFECTION
	display_name = "Mechanism of Khara Virus Development"
	description = "Information on the virus's development within the body and methods of countering it has been obtained."
	prereq_ids = list(TECHWEB_NODE_KHARA_BASIC, TECHWEB_NODE_MEDBAY_EQUIP_ADV)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS * 2)
	required_experiments = list(/datum/experiment/scanning/infected_human, /datum/experiment/scanning/khara_creature)
	announce_channels = list(RADIO_CHANNEL_MEDICAL, RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SECURITY)
	document_to_spawn = /obj/item/paper/khara_initial_infection_research
	experiments_to_unlock = list(/datum/experiment/scanning/khara_creature/adapted)

	research_text = "Study of living and infected samples revealed that certain chemicals can effectively counter Khara creatures. \
					Anacea, haloperidol and rezadone are able to reverse the development of infected cells and partially heal the sick. \
					In addition, mutant tissue is highly susceptible to physical damage - melee weapons are especially effective against them."

/obj/item/paper/khara_initial_infection_research
	name = "Report: Mechanism of Khara Virus Development"
	default_raw_text = \
	"<center><b>RESEARCH DEPARTMENT REPORT</b></center>\
	<BR>\
	<b>Subject:</b> Mechanism of Khara virus development and methods of countering it<BR>\
	<BR>\
	Study of living and infected samples revealed that certain chemicals can effectively counter Khara creatures. Anacea, haloperidol and rezadone are able to reverse the development of infected cells and partially heal the sick. In addition, mutant tissue is highly susceptible to physical damage - melee weapons are especially effective against them.\
	<BR><BR>\
	<b>CLASSIFIED - LEVEL III</b><BR>\
	This document is confidential. Copying is prohibited. Discussion outside of scientific and medical personnel is prohibited. Leaving it unguarded is prohibited.\
	<BR><BR>\
	- Research Department"

/datum/techweb_node/khara/khara_ammunition_basic
	id = TECHWEB_NODE_KHARA_AMMUNITION_BASIC
	display_name = "Basic Weaponry Against the Khara-Infected"
	description = "Blueprints for special ammunition and weapons for fighting the afflicted have been obtained."
	design_ids = list(
		"anti_khara_ammunition",
		"anti_khara_weapon_sword",
	)
	prereq_ids = list(TECHWEB_NODE_KHARA_INITIAL_INFECTION, TECHWEB_NODE_BEAM_WEAPONS)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS * 3)
	required_experiments = list(/datum/experiment/scanning/khara_creature/adapted)
	announce_channels = list(RADIO_CHANNEL_MEDICAL, RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SECURITY, RADIO_CHANNEL_COMMON, RADIO_CHANNEL_SUPPLY)
	document_to_spawn = /obj/item/paper/khara_ammunition_basic_research
	experiments_to_unlock = list(/datum/experiment/scanning/khara_creature/assimilating)

	research_text = "Further study of high-caste mutants showed that all Khara-afflicted possess a collective consciousness and are able \
					to exchange information at a distance. This made it possible to create ammunition that picks up this signal and deals \
					damage exclusively to Khara creatures, ignoring ordinary humans. In addition, a line of special Anti-Khara weapons is now available for fabrication."

/obj/item/paper/khara_ammunition_basic_research
	name = "Report: Basic Weaponry Against Khara"
	default_raw_text = \
	"<center><b>RESEARCH DEPARTMENT REPORT</b></center>\
	<BR>\
	<b>Subject:</b> Basic weaponry against the Khara-infected<BR>\
	<BR>\
	Further study of high-caste mutants showed that all Khara-afflicted possess a collective consciousness and are able to exchange information at a distance. This made it possible to create ammunition that picks up this signal and deals damage exclusively to Khara creatures, ignoring ordinary humans. In addition, a line of special Anti-Khara weapons is now available for fabrication.\
	<BR><BR>\
	<b>CLASSIFIED - LEVEL IV</b><BR>\
	This document is confidential. Copying is prohibited. Discussion outside of scientific and security personnel is prohibited. Leaving it unguarded is prohibited.\
	<BR><BR>\
	- Research Department"

/datum/techweb_node/khara/khara_ammunition_advanced
	id = TECHWEB_NODE_KHARA_AMMUNITION_ADVANCED
	display_name = "Advanced Anti-Khara Weaponry"
	description = "Blueprints for advanced weapons to destroy large colonies of the infected have been obtained."
	prereq_ids = list(TECHWEB_NODE_KHARA_AMMUNITION_BASIC)
	design_ids = list(
		"anti_khara_grenade",
		"anti_khara_weapon_greatsword",
		"anti_khara_weapon_spear",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS * 4)
	required_experiments = list(/datum/experiment/scanning/khara_creature/assimilating)
	announce_channels = list(RADIO_CHANNEL_SUPPLY, RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SECURITY)
	document_to_spawn = /obj/item/paper/khara_ammunition_advanced_research

	research_text = "Study of the most massive mutants made it possible to synthesize blueprints for advanced grenades that generate a special energy field \
					in which the Khara infection cannot survive. As well as the most advanced melee weapon."

/obj/item/paper/khara_ammunition_advanced_research
	name = "Report: Advanced Anti-Khara Weaponry"
	default_raw_text = \
	"<center><b>RESEARCH DEPARTMENT REPORT</b></center>\
	<BR>\
	<b>Subject:</b> Advanced weaponry against Khara colonies<BR>\
	<BR>\
	Study of the most massive mutants made it possible to synthesize blueprints for advanced grenades that generate a special energy field in which the Khara infection cannot survive.\
	<BR><BR>\
	<b>CLASSIFIED - LEVEL IV</b><BR>\
	This document is confidential. Copying is prohibited. Discussion outside of scientific and security personnel is prohibited. Leaving it unguarded is prohibited.\
	<BR><BR>\
	- Research Department"

/datum/techweb_node/khara/khara_positive_basic
	id = TECHWEB_NODE_KHARA_POSITIVE_BASIC
	display_name = "Alternative Development of the Khara Virus"
	description = "Information on the positive mutations caused by the virus has been obtained."
	prereq_ids = list(TECHWEB_NODE_KHARA_INITIAL_INFECTION)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS * 3)
	announce_channels = list(RADIO_CHANNEL_MEDICAL, RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SECURITY, RADIO_CHANNEL_COMMON)
	document_to_spawn = /obj/item/paper/khara_positive_basic_research
	experiments_to_unlock = list(/datum/experiment/scanning/infected_human/true_khara, /datum/experiment/scanning/infected_human/late_khara)

	research_text = "Despite the high level of danger, the Khara virus in rare cases triggers the opposite reaction. \
					Some organisms, instead of mutations, gain outstanding physical abilities. The probability of a positive mutation is extremely low and \
					strongly depends on the individual characteristics of the subject. Study of reborn subjects must be continued.\
					Their distinguishing feature is completely white eyes."

/obj/item/paper/khara_positive_basic_research
	name = "Report: Alternative Development of the Khara Virus"
	default_raw_text = \
	"<center><b>RESEARCH DEPARTMENT REPORT</b></center>\
	<BR>\
	<b>Subject:</b> Alternative development of the Khara virus<BR>\
	<BR>\
	Despite the high level of danger, the Khara virus in rare cases triggers the opposite reaction. Some organisms, instead of mutations, gain outstanding physical abilities. The probability of a positive mutation is extremely low and strongly depends on the individual characteristics of the subject. Study of reborn subjects must be continued. Their distinguishing feature is completely white eyes.\
	<BR><BR>\
	<b>CLASSIFIED - LEVEL IV</b><BR>\
	This document is confidential. Copying is prohibited. Discussion outside of scientific and medical personnel is prohibited. Leaving it unguarded is prohibited.\
	<BR><BR>\
	- Research Department"

/datum/techweb_node/khara/khara_positive_advanced
	id = TECHWEB_NODE_KHARA_POSITIVE_ADVANCED
	display_name = "Those Reborn by the Khara Virus"
	description = "Detailed information on the positive effect of the virus and its use."
	prereq_ids = list(TECHWEB_NODE_KHARA_POSITIVE_BASIC)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS * 2)
	announce_channels = list(RADIO_CHANNEL_MEDICAL, RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SECURITY, RADIO_CHANNEL_COMMON)
	document_to_spawn = /obj/item/paper/khara_positive_advanced_research
	required_experiments = list(/datum/experiment/scanning/infected_human/true_khara)

	research_text = "In extremely rare cases the Khara virus actually acts as a cure. High intelligence, \
					superior physical qualities and strong personality traits significantly increase the chance of rebirth. \
					Reborn subjects appear to possess virtual immortality. \
					The only way to stop the regeneration is to sever the head or remove the brain."

/obj/item/paper/khara_positive_advanced_research
	name = "Report: Those Reborn by the Khara Virus"
	default_raw_text = \
	"<center><b>RESEARCH DEPARTMENT REPORT</b></center>\
	<BR>\
	<b>Subject:</b> Those reborn by the Khara virus<BR>\
	<BR>\
	In extremely rare cases the Khara virus actually acts as a cure. High intelligence, superior physical qualities and strong personality traits significantly increase the chance of rebirth. Reborn subjects appear to possess virtual immortality. The only way to stop the regeneration is to sever the head or remove the brain.\
	<BR><BR>\
	<b>CLASSIFIED - LEVEL V</b><BR>\
	This document is confidential. Copying is prohibited. Discussion outside of scientific and medical personnel is prohibited. Leaving it unguarded is prohibited.\
	<BR><BR>\
	- Research Department"
