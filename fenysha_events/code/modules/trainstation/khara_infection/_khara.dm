#define KHARA_SPREADING_MODIFIER 1.4
#define KHARA_FINAL_EMERGENCE_DELAY (30 SECONDS)
#define KHARA_EMERGENCE_BRUTE_DAMAGE 200
#define KHARA_TUMOR_THRESHOLD_STAGE 5

/datum/disease/khara
	name = "Khara Infection"
	desc = "An incurable, contagious pathogen. Khara develops in the host's nervous system and bloodstream, rapidly mutating cells. \
			Outwardly the infection resembles cancer. Multiple fast-growing malignant tumors appear in the patient's body. \
			During the first three stages certain reagents can slow or partially reverse the development of the disease. \
			In the later stages this effect is significantly weaker. \
			Once fully developed, the host's body will be destroyed by a new life form that has formed inside it."
	form = "Bioengineered disease"
	agent = "Veral khara spores"
	visibility_flags = HIDDEN_SCANNER|HIDDEN_PANDEMIC
	spread_flags = DISEASE_SPREAD_SPECIAL|DISEASE_SPREAD_AIRBORNE
	stage_prob = 13
	max_stages = 7
	spread_text = "Veral khara spores (contact + miasma in the late stages)"
	cure_text = "Incurable. Rezadone and haloperidol can slow / partially reverse progression. \
				The toxin anacea destroys the spores extremely effectively. Technetium-99 significantly enhances the effect of anacea."
	viable_mobtypes = list(/mob/living/carbon/human)
	bypasses_immunity = TRUE
	severity = DISEASE_SEVERITY_BIOHAZARD
	process_dead = FALSE
	spreading_modifier = KHARA_SPREADING_MODIFIER
	cures = list()

	var/stage_process = 0
	var/base_stage_speed = 0.9

	var/list/inverters = list(
		/datum/reagent/medicine/rezadone = 1,
		/datum/reagent/medicine/haloperidol = 3,
		/datum/reagent/toxin/anacea = 6.5,
	)
	var/invert_catalyst = /datum/reagent/inverse/technetium
	var/thing_emerg = /mob/living/basic/khara_mutant/flesh_human
	var/emerged = FALSE

	COOLDOWN_DECLARE(stage_process_cd)
	COOLDOWN_DECLARE(organ_failure_cd)
	COOLDOWN_DECLARE(miasma_spread_cd)
	COOLDOWN_DECLARE(tumor_pain_cd)
	COOLDOWN_DECLARE(crack_bones_cd)

	var/emerging = FALSE



/datum/disease/khara/infect(mob/living/infectee, make_copy)
	for(var/datum/disease/D in infectee.diseases)
		if(istype(D, /datum/disease/true_khara))
			qdel(src)
			return
	. = ..()
	if(!.)
		return
	if(make_reborn_roll())
		return

	stage = 1
	stage_process = 0
	var/obj/item/organ/brain/brain = infectee.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(brain)
		brain.AddComponent(/datum/component/khara_disease, /datum/disease/khara)

/datum/disease/khara/cure(add_resistance)
	var/obj/item/organ/brain/brain = affected_mob.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(brain && brain.GetComponent(/datum/component/khara_disease))
		qdel(brain.GetComponent(/datum/component/khara_disease))
	to_chat(affected_mob, span_big(span_boldnicegreen("The Khara recedes... for now.")))
	. = ..()

/datum/disease/khara/update_stage(new_stage)
	if(stage_process < 100 && new_stage > stage)
		return FALSE
	. = ..()
	if(!.)
		return
	stage_process = 0
	switch(new_stage)
		if(1 to 3)
			visibility_flags = HIDDEN_SCANNER|HIDDEN_PANDEMIC
			process_dead = FALSE
			spreading_modifier = KHARA_SPREADING_MODIFIER
		if(4)
			to_chat(affected_mob, span_userdanger("Something heavy and wrong pulses deep inside your belly..."))
			spreading_modifier *= 0.6
			process_dead = TRUE
			visibility_flags = NONE
			spreading_modifier = KHARA_SPREADING_MODIFIER * 1.2
		if(5)
			to_chat(affected_mob, span_userdanger("Your skin swells and writhes - something is growing far too fast!"))
			spreading_modifier = KHARA_SPREADING_MODIFIER * 1.4
		if(6)
			to_chat(affected_mob, span_userdanger("Your bones crack and break under unthinkable internal pressure!"))
			spreading_modifier = KHARA_SPREADING_MODIFIER * 1.6
		if(7)
			to_chat(affected_mob, span_userdanger("Everything inside you is moving. It wants out."))
			affected_mob.Shake(duration = 2 SECONDS)
			spreading_modifier = KHARA_SPREADING_MODIFIER * 2
	affected_mob.update_health_hud()


/datum/disease/khara/proc/get_slowing_modifier()
	var/base = base_stage_speed

	if(HAS_TRAIT(affected_mob, TRAIT_VIRUS_RESISTANCE))
		base -= 0.2

	if(affected_mob.has_reagent(invert_catalyst, 1, TRUE))
		base -= 0.4

	var/area/our_area = get_area(affected_mob)
	if(HAS_TRAIT(our_area, TRAIT_AREA_MORPENGINE))
		base -= 0.5

	return max(base, 0.1)


/datum/disease/khara/proc/stage_evolution_process(seconds_per_tick)
	var/base = get_slowing_modifier()
	var/area/our_area = get_area(affected_mob)
	var/protected_area = HAS_TRAIT(our_area, TRAIT_AREA_MORPENGINE)

	var/healing = 0
	for(var/inverter in inverters)
		if(affected_mob.has_reagent(inverter, 1, TRUE))
			healing += inverters[inverter]

	if(healing > 0 && stage >= 4 && !protected_area)
		healing *= 0.6
	else if(protected_area)
		healing *= 1.2

	if(stage >= 7 && base > 0.1)
		healing = 0

	var/stage_step = base - healing
	stage_process = min(stage_process + (stage_step * seconds_per_tick), 100)
	if(stage_process <= 0 && stage > 1)
		update_stage(stage - 1)
		stage_process = 0

/datum/disease/khara/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return
	if(ishuman(affected_mob))
		var/obj/item/organ/brain/brain = affected_mob.get_organ_slot(ORGAN_SLOT_BRAIN)
		if(!brain.GetComponent(/datum/component/khara_disease))
			brain.AddComponent(/datum/component/khara_disease, /datum/disease/khara)

	if(emerging)
		return

	var/host_dead = affected_mob.stat == DEAD

	if(COOLDOWN_FINISHED(src, stage_process_cd))
		stage_evolution_process(seconds_per_tick)
		var/next_tick = host_dead ? 5 SECONDS : 3 SECONDS
		COOLDOWN_START(src, stage_process_cd, next_tick)

	var/area/our_area = get_area(affected_mob)
	var/protected_area = HAS_TRAIT(our_area, TRAIT_AREA_MORPENGINE)

	switch(stage)
		if(1)
			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.emote("cough")
			if(SPT_PROB(6, seconds_per_tick))
				to_chat(affected_mob, span_warning("You feel a strange warmth spreading beneath your skin..."))
			if(SPT_PROB(4, seconds_per_tick))
				to_chat(affected_mob, span_notice("There's a faint tingling in your [pick("wrists","fingers","knees")]..."))

		if(2 to 3)
			if(SPT_PROB(5 + stage, seconds_per_tick))
				to_chat(affected_mob, span_warning("A dull, throbbing pain blossoms somewhere inside you."))
			if(SPT_PROB(4, seconds_per_tick))
				to_chat(affected_mob, span_warning("Your head feels heavy, your temples are pounding..."))
				affected_mob.adjust_confusion(4)

			if(SPT_PROB(3, seconds_per_tick))
				affected_mob.adjust_brute_loss(1.2, forced = TRUE)

			if(SPT_PROB(3.5, seconds_per_tick))
				to_chat(affected_mob, span_warning("Your joints [pick("ache","creak","feel rusted")]..."))
				affected_mob.adjust_stamina_loss(6)

		if(4)
			if(SPT_PROB(3, seconds_per_tick))
				to_chat(affected_mob, span_danger("You feel something hard and wrong growing inside your [pick("chest", "belly", "side")]."))

			if(SPT_PROB(6, seconds_per_tick))
				var/obj/item/bodypart/affecting = affected_mob.get_bodypart(pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
				if(affecting)
					to_chat(affected_mob, span_warning("A sharp pain flares up in your [affecting.name]!"))
					affecting.receive_damage(5, 0, wound_bonus = CANT_WOUND)

			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.adjust_brute_loss(rand(2,5), forced = TRUE)

			// Trembling hands -> dropping items
			if(SPT_PROB(4.5, seconds_per_tick) && affected_mob.get_active_hand())
				to_chat(affected_mob, span_warning("Your fingers suddenly go numb and won't obey you..."))
				affected_mob.dropItemToGround(affected_mob.get_active_held_item())
				affected_mob.emote("gasp")

			if(SPT_PROB(5, seconds_per_tick) && COOLDOWN_FINISHED(src, tumor_pain_cd))
				affected_mob.emote("scream")
				to_chat(affected_mob, span_userdanger("You feel something inside your [pick("chest", "right arm", "left arm")] pulse painfully."))
				affected_mob.adjust_brute_loss(rand(5, 15), forced = TRUE)
				COOLDOWN_START(src, tumor_pain_cd, rand(25, 45) SECONDS)

		if(5)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_userdanger("Your flesh swells monstrously - something is alive inside!"))
				affected_mob.adjust_brute_loss(rand(5, 10), forced = TRUE)

			if(SPT_PROB(4, seconds_per_tick))
				to_chat(affected_mob, span_warning("Your head is splitting, flashes flicker before your eyes..."))
				affected_mob.adjust_confusion(6)
				affected_mob.adjust_eye_blur(8)

			if(SPT_PROB(3.5, seconds_per_tick))
				to_chat(affected_mob, span_warning("Your legs give way, your joints feel like they're melting..."))
				affected_mob.AdjustKnockdown(rand(15, 30))
				affected_mob.adjust_stamina_loss(10)

			if(SPT_PROB(3, seconds_per_tick))
				damage_random_organ(rand(8, 14))

			if(SPT_PROB(5, seconds_per_tick) && COOLDOWN_FINISHED(src, miasma_spread_cd))
				if(protected_area)
					to_chat(affected_mob, span_userdanger("You feel a thick miasma rising in your throat, but something keeps it from escaping!"))
					affected_mob.adjust_stamina_loss(5)
				else
					spread_khara_miasma()
				COOLDOWN_START(src, miasma_spread_cd, rand(60, 180) SECONDS)

		if(6)
			if(SPT_PROB(4, seconds_per_tick))
				to_chat(affected_mob, span_bolddanger("Your ribs groan and shift - something is forcing them apart!"))

			if(SPT_PROB(6, seconds_per_tick))
				affected_mob.adjust_brute_loss(rand(6,11), forced = TRUE)

			if(SPT_PROB(4.5, seconds_per_tick))
				to_chat(affected_mob, span_warning("Your hands are shaking so badly you can't hold anything..."))
				if(affected_mob.get_active_held_item())
					affected_mob.dropItemToGround(affected_mob.get_active_held_item(), TRUE)

			if(SPT_PROB(2, seconds_per_tick))
				affected_mob.vomit(VOMIT_CATEGORY_BLOOD|VOMIT_CATEGORY_KNOCKDOWN, lost_nutrition = FALSE)

			if(SPT_PROB(5, seconds_per_tick) && COOLDOWN_FINISHED(src, crack_bones_cd))
				affected_mob.emote("scream")
				affected_mob.adjust_brute_loss(8, forced = TRUE)
				COOLDOWN_START(src, crack_bones_cd, rand(30, 60) SECONDS)

			if(SPT_PROB(2.5, seconds_per_tick) && COOLDOWN_FINISHED(src, miasma_spread_cd))
				if(protected_area)
					to_chat(affected_mob, span_userdanger("You feel a thick miasma rising in your throat, but something keeps it from escaping!"))
					affected_mob.adjust_stamina_loss(5)
				else
					spread_khara_miasma()
				COOLDOWN_START(src, miasma_spread_cd, rand(60, 180) SECONDS)

		if(7)
			if(!COOLDOWN_FINISHED(src, organ_failure_cd) && stage_process < 100)
				return
			if(protected_area && (affected_mob.stat != DEAD))
				if(SPT_PROB(5, seconds_per_tick))
					to_chat(affected_mob, span_userdanger("You feel your body is ready to burst, but something is keeping it from happening!"))
					affected_mob.emote("scream")
					affected_mob.adjust_brute_loss(5, forced = TRUE)
					new /obj/effect/temp_visual/morph_engine_block(get_turf(affected_mob))
				return
			if(make_reborn_roll())
				return

			to_chat(affected_mob, span_boldnicegreen("The pain recedes! Everything is fine."))
			visibility_flags = HIDDEN_SCANNER|HIDDEN_PANDEMIC
			affected_mob.update_health_hud()

			emerging = TRUE
			addtimer(CALLBACK(src, PROC_REF(perform_emergence)), KHARA_FINAL_EMERGENCE_DELAY)


/datum/disease/khara/proc/make_garanted_reborn()
	ADD_TRAIT(affected_mob, TRAIT_GRANTEDKHARA_REBORN, REF(src))
	make_reborn_roll()

/// Runs the rolls for whether the sick host will be reborn as a perfect human instead of dying
/datum/disease/khara/proc/make_reborn_roll()
	var/roll_chance = 3
	var/roll_attempts = 3
	if(stage == 7)
		roll_chance += 2

	var/datum/mind/mind = affected_mob.mind

	if(mind)
		for(var/i in mind.known_skills)
			if(mind.known_skills[i][SKILL_LVL] >= SKILL_LEVEL_EXPERT)
				roll_chance += mind.known_skills[i][SKILL_LVL] - 3
				roll_attempts += 1

		var/datum/job/job = mind.assigned_role
		if(job)
			if(job.job_flags & JOB_HEAD_OF_STAFF)
				roll_chance += 3
				roll_attempts += 1
			if(istype(job, /datum/job/captain))
				roll_chance += 10
				roll_attempts += 2
			if((DEPARTMENT_MEDICAL in job.departments_list) || (DEPARTMENT_SCIENCE in job.departments_list))
				roll_chance += 5
			roll_attempts += 1

		if(mind.antag_datums)
			var/antag_datums = length(affected_mob.mind.antag_datums)
			roll_chance += 5 * antag_datums
			roll_attempts += antag_datums

	if(HAS_TRAIT(affected_mob, TRAIT_CURSED))
		roll_chance += 20
	if(HAS_TRAIT(affected_mob, TRAIT_CRITICAL_CONDITION))
		roll_chance += 5
		roll_attempts += 1
	if(HAS_TRAIT(affected_mob, TRAIT_PACIFISM))
		roll_chance += 15
	if(HAS_TRAIT(affected_mob, TRAIT_GRANTEDKHARA_REBORN))
		roll_chance += 100

	var/datum/language_holder/languages = affected_mob.get_language_holder()
	if(languages)
		var/understood = languages.understood_languages ? length(languages.understood_languages) : 0
		if(understood > 3)
			roll_chance += min(20, understood)

	for(var/i = 1 to roll_attempts)
		if(prob(roll_chance))
			addtimer(CALLBACK(affected_mob, TYPE_PROC_REF(/mob/living, ForceContractDisease), new /datum/disease/true_khara(), TRUE, TRUE), 1)
			message_admins("[ADMIN_LOOKUPFLW(affected_mob)] was converted to reborn via khara infection with chance [roll_chance]%.")
			cure()
			return TRUE
	return FALSE

/datum/disease/khara/proc/perform_emergence()
	if(QDELETED(affected_mob))
		return
	visibility_flags = NONE
	affected_mob.visible_message(span_userdanger("[affected_mob]'s body convulses in terrible spasms - something is tearing its way out!"), span_userdanger("It's all over."))
	affected_mob.Paralyze(30 SECONDS)
	affected_mob.Knockdown(30 SECONDS)
	affected_mob.Shake(duration = 10 SECONDS)
	var/mob/dead/observer/chosen = SSpolling.poll_ghost_candidates(
		poll_time = 10 SECONDS,
		role_name_text = "Reborn [affected_mob]",
		alert_pic = thing_emerg,
		amount_to_pick = 1
	)
	if(chosen)
		chosen.ManualFollow(affected_mob)

	for(var/i = 1 to rand(3, 6))
		affected_mob.spray_blood(rand(GLOB.cardinals), rand(2, 3))
		sleep(1.5 SECONDS)
		affected_mob.apply_damage(KHARA_EMERGENCE_BRUTE_DAMAGE/10, BRUTE, wound_bonus = 70, spread_damage = TRUE)
		affected_mob.Shake()

	affected_mob.visible_message(
		span_userdanger("[affected_mob]'s chest bursts in a fountain of blood and entrails, and a hideous creature breaks free!"),
		span_userdanger("Your body explodes from within - you are no more.")
	)
	sleep(0.2 SECONDS)
	emerged = TRUE
	affected_mob.apply_damage(KHARA_EMERGENCE_BRUTE_DAMAGE, BRUTE, wound_bonus = 70, spread_damage = TRUE)
	if(thing_emerg)
		var/mob/living/creature = new thing_emerg(get_turf(affected_mob))
		if(chosen && chosen.client)
			creature.key = chosen.key

	log_virus("[key_name(affected_mob)] was consumed and torn apart by Khara in [loc_name(affected_mob)]")
	affected_mob.investigate_log("died from the Khara infection (consumed and torn apart).", INVESTIGATE_DEATHS)
	affected_mob.gib(DROP_ALL_REMAINS)
	spread_khara_miasma(TRUE)

/datum/disease/khara/proc/spread_khara_miasma(force = FALSE)
	if(!force)
		var/obj/item/organ/lungs/l = affected_mob.get_organ_slot(ORGAN_SLOT_LUNGS)
		if(!l || !(l.organ_flags & ORGAN_ORGANIC))
			return FALSE
		var/obj/item/clothing/mask/mask = affected_mob.wear_mask
		if(mask && mask.flags_cover & MASKCOVERSMOUTH)
			return FALSE

	do_chem_smoke(3, affected_mob, get_turf(affected_mob), /datum/reagent/toxin/khara, 10, log = FALSE, amount = 12, smoke_type = /datum/effect_system/fluid_spread/smoke/chem/khara)
	affected_mob.emote("cough")
	affected_mob.Shake()
	return TRUE


/datum/disease/khara/proc/damage_random_organ(dmg)
	if(affected_mob.stat == DEAD)
		return
	var/obj/item/organ/O = pick(affected_mob.organs)
	if(!O || !(O.organ_flags & ORGAN_ORGANIC))
		return
	O.apply_organ_damage(dmg)
	if(O.organ_flags & ORGAN_FAILING)
		to_chat(affected_mob, span_userdanger("Your [O.name] feels like it's being crushed from the inside!"))

#undef KHARA_SPREADING_MODIFIER
#undef KHARA_FINAL_EMERGENCE_DELAY
#undef KHARA_EMERGENCE_BRUTE_DAMAGE
#undef KHARA_TUMOR_THRESHOLD_STAGE



/datum/component/khara_disease
	VAR_PRIVATE/mob/living/carbon/current_mob = null
	VAR_PRIVATE/obj/item/organ/brain/brain_parent = null
	VAR_PRIVATE/disease_type

/datum/component/khara_disease/Initialize(disease_path = /datum/disease/khara)
	if(!istype(parent, /obj/item/organ/brain))
		return COMPONENT_INCOMPATIBLE

	brain_parent = parent
	if(!brain_parent.owner || !iscarbon(brain_parent.owner))
		return COMPONENT_INCOMPATIBLE

	if(!ispath(disease_path, /datum/disease))
		return COMPONENT_INCOMPATIBLE

	disease_type = disease_path

	register_to_mob(brain_parent.owner)

/datum/component/khara_disease/RegisterWithParent()
	RegisterSignal(brain_parent, COMSIG_ORGAN_BEING_REPLACED, PROC_REF(on_brain_replaced))
	START_PROCESSING(SSprocessing, src)

/datum/component/khara_disease/UnregisterFromParent()
	if(current_mob)
		unregister_from_host(current_mob)
	UnregisterSignal(brain_parent, list(COMSIG_ORGAN_BEING_REPLACED))
	STOP_PROCESSING(SSprocessing, src)

/datum/component/khara_disease/proc/register_to_mob(mob/living/carbon/new_host)
	if(!new_host || !iscarbon(new_host))
		return

	current_mob = new_host
	new_host.ForceContractDisease(new disease_type(), del_on_fail = TRUE)
	RegisterSignal(current_mob, COMSIG_LIVING_REVIVE, PROC_REF(on_host_revived))

/datum/component/khara_disease/proc/unregister_from_host(mob/living/carbon/old_host)
	UnregisterSignal(old_host, COMSIG_LIVING_REVIVE)
	current_mob = null

/datum/component/khara_disease/proc/on_host_revived(mob/living/source, full_heal, admin_revive)
	SIGNAL_HANDLER
	if(current_mob)
		current_mob.ForceContractDisease(new disease_type(), del_on_fail = TRUE)

/datum/component/khara_disease/proc/on_brain_replaced(obj/item/organ/brain/old_brain, obj/item/organ/brain/new_brain)
	SIGNAL_HANDLER

	new_brain.AddComponent(/datum/component/khara_disease, disease_path = disease_type)
	qdel(src)

/datum/component/khara_disease/process(seconds_per_tick)
	if(!current_mob)
		if(!brain_parent || QDELETED(brain_parent))
			qdel(src)
			return PROCESS_KILL

		var/mob/living/current = brain_parent.owner
		if(!current || iscameramob(current))
			return
		register_to_mob(current)
		return
	else if((!brain_parent.owner && current_mob) || (brain_parent.owner != current_mob))
		on_brain_removed()
		register_to_mob(brain_parent.owner)
		return

/datum/component/khara_disease/proc/on_brain_removed()
	if(!current_mob)
		return

	if(disease_type == /datum/disease/khara)
		current_mob.visible_message(span_userdanger("That was a bad idea!"))
		current_mob.apply_damage(500, BRUTE, forced = TRUE, spread_damage = TRUE, wound_bonus = 100)

		var/datum/disease/khara/khara = null
		for(var/datum/disease/D in current_mob.diseases)
			if(istype(D, /datum/disease/khara))
				khara = D
				break
		if(khara && !khara.emerged)
			khara.emerging = TRUE
			khara.stage = 7
			khara.stage_process = 100
			ASYNC
				khara.perform_emergence()

	else if(disease_type == /datum/disease/true_khara)
		for(var/datum/disease/D in current_mob.diseases)
			if(istype(D, /datum/disease/true_khara))
				D.cure()
				break
		current_mob.ForceContractDisease(new disease_type(), del_on_fail = TRUE)
	unregister_from_host(current_mob)

/datum/component/khara_disease/proc/on_brain_implanted()
	SIGNAL_HANDLER
	register_to_mob(brain_parent.owner)

/datum/antagonist/khara_member
	name = "Reborn"
	roundend_category = "Reborn by Khara"
	antagpanel_category = "Reborn"
	antag_moodlet = /datum/mood_event/ling
	show_to_ghosts = TRUE

/datum/antagonist/khara_member/on_gain()
	forge_objectives()
	. = ..()

/datum/antagonist/khara_member/forge_objectives()
	var/datum/objective/custom/be_badass = new()
	be_badass.name = "Ignore"
	be_badass.explanation_text = "Stay out of the troubles of the unreborn. It is no longer your concern!"

	var/datum/objective/custom/assimilation = new()
	assimilation.name = "Assimilate"
	assimilation.explanation_text = "Make it so that other people can be reborn too!"

	objectives += assimilation
	objectives += be_badass

/datum/disease/true_khara
	name = "True Khara Infection"
	desc = "The symbiotic Veral khara pathogen - a panacea. \
			Instead of destroying, it fuses with the host's body, enhancing it in every way: accelerating regeneration, \
			increasing strength, speed and endurance, fully curing other diseases and making the body more perfect."
	form = "Bioengineered symbiotic infection"
	agent = "Symbiotic Veral khara spores"
	visibility_flags = HIDDEN_SCANNER
	spread_flags = DISEASE_SPREAD_SPECIAL
	cure_chance = 0
	stage_prob = 100
	max_stages = 1
	process_dead = TRUE
	spread_text = "Does not spread"
	cure_text = "Incurable"
	viable_mobtypes = list(/mob/living/carbon/human)
	bypasses_immunity = TRUE
	severity = DISEASE_SEVERITY_POSITIVE
	spreading_modifier = 0

	var/static/given_traits = list(
		TRAIT_STRONG_GRABBER,
		TRAIT_STRONG_STOMACH,
		TRAIT_STRONGPULL,
		TRAIT_BATON_RESISTANCE,
		TRAIT_SLEEPIMMUNE,
		TRAIT_STUNIMMUNE,
		TRAIT_AIRLOCK_SHOCKIMMUNE,
		TRAIT_STABLEHEART,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOHUNGER,
		TRAIT_TOXIMMUNE,
		TRAIT_NO_SLIP_WATER,
		TRAIT_NO_SLIP_ICE,
		TRAIT_FAST_CUFFING,
		TRAIT_QUICK_CARRY,
		TRAIT_MADNESS_IMMUNE,
		TRAIT_RADIMMUNE,
		TRAIT_PUSHIMMUNE,
		TRAIT_NO_BREATHLESS_DAMAGE,
		TRAIT_NOHARDCRIT,
		TRAIT_NOFAT,
		TRAIT_NOFEAR_HOLDUPS,
		TRAIT_NOCRITDAMAGE,
		TRAIT_KHARAMUTANT,
		TRAIT_EVIL,
	)

	COOLDOWN_DECLARE(heal_cd)


/datum/disease/true_khara/register_disease_signals()
	. = ..()
	if(isnull(affected_mob))
		return
	RegisterSignal(affected_mob, COMSIG_ATOM_EXAMINE, PROC_REF(on_host_examine))

/datum/disease/true_khara/unregister_disease_signals()
	. = ..()
	if(affected_mob)
		UnregisterSignal(affected_mob, COMSIG_ATOM_EXAMINE)

/datum/disease/true_khara/proc/on_host_examine(source, mob/examiner, list/examine_text)
	SIGNAL_HANDLER
	if(!affected_mob.is_eyes_covered())
		examine_text += span_notice("[affected_mob.p_theirs()] eyes are <b>white</b>.")

/datum/disease/true_khara/cure(add_resistance)
	var/obj/item/organ/brain/brain = affected_mob.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(brain)
		return // Only severing the head allows a cure, that's how it is

	affected_mob.visible_message(span_danger("The symbiosis with the true Khara is broken! The body weakens..."))
	affected_mob.apply_damage(300, BRUTE, forced = TRUE, spread_damage = TRUE)
	affected_mob.remove_traits(given_traits, REF(src))

	if(affected_mob?.mind)
		affected_mob?.mind?.remove_antag_datum(/datum/antagonist/khara_member)

	if(ishuman(affected_mob))
		var/mob/living/carbon/human/H = affected_mob
		H.dna.species.name = initial(H.dna.species.name)
		H.set_eye_color(COLOR_RED, COLOR_WHITE)
	qdel(affected_mob.GetComponent(/datum/component/khara_hivemind))
	return ..(FALSE)

/datum/disease/true_khara/infect(mob/living/infectee, make_copy)
	. = ..()
	to_chat(infectee, span_boldnicegreen("You feel your body growing stronger - and all your ailments recede, your condition improves."))
	infectee.revive(HEAL_DAMAGE)
	var/obj/item/organ/brain/brain = infectee.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(brain)
		brain.AddComponent(/datum/component/khara_disease, /datum/disease/true_khara)

	var/mob/living/carbon/human/perfect_human = infectee
	perfect_human.add_traits(given_traits, REF(src))
	perfect_human.set_eye_color(COLOR_GNOME_WHITE, COLOR_GNOME_WHITE)
	perfect_human.add_faction(FACTION_KHARA)
	perfect_human.AddComponent(\
		/datum/component/khara_hivemind, \
		cast = KHARA_CAST_ADAPTED, \
	)
	perfect_human?.mind.add_antag_datum(/datum/antagonist/khara_member)

/datum/disease/true_khara/stage_act(seconds_per_tick)
	if(ishuman(affected_mob))
		var/obj/item/organ/brain/brain = affected_mob.get_organ_slot(ORGAN_SLOT_BRAIN)
		if(!brain.GetComponent(/datum/component/khara_disease))
			brain.AddComponent(/datum/component/khara_disease, /datum/disease/true_khara)

	if(HAS_TRAIT(affected_mob, TRAIT_STASIS))
		return

	if(COOLDOWN_FINISHED(src, heal_cd))
		heal_host()
		COOLDOWN_START(src, heal_cd, 2 SECONDS)

/datum/disease/true_khara/proc/heal_host()
	var/host_dead = affected_mob.stat == DEAD
	var/heal = 5
	if(affected_mob.has_reagent(/datum/reagent/toxin/khara))
		heal *= 2

	if(host_dead)
		heal *= 0.5

	affected_mob.heal_overall_damage(heal, heal, heal, updating_health = TRUE, forced = TRUE)
	if(affected_mob.get_oxy_loss() != 0)
		affected_mob.set_oxy_loss(0)
	for(var/obj/item/organ/O in affected_mob.organs)
		if(O.damage >= 5)
			O.set_organ_damage(clamp(max(0, O.damage - heal), 0, 100))
		if(isbrain(O))
			var/obj/item/organ/brain/brain = O
			if(brain.traumas)
				for(var/datum/brain_trauma/T in brain.get_traumas_type())
					if(prob(15))
						qdel(T)

	if(affected_mob.get_blood_volume() < affected_mob.default_blood_volume)
		affected_mob.adjust_blood_volume(5 * heal)

	if(affected_mob.all_wounds)
		for(var/datum/wound/W in affected_mob.all_wounds)
			if(prob(15))
				W.remove_wound_from_victim()

	for(var/datum/disease/D in affected_mob.diseases)
		if(D != src)
			D.cure()

	if(host_dead)
		try_revive()

/datum/disease/true_khara/proc/try_revive()
	var/should_revive = TRUE
	if(!affected_mob.get_organ_slot(ORGAN_SLOT_BRAIN))
		should_revive = FALSE
	if(affected_mob.get_total_damage() > 50)
		should_revive = FALSE
	if(HAS_TRAIT(affected_mob, TRAIT_STASIS))
		should_revive = FALSE

	if(!should_revive)
		return

	affected_mob.revive(HEAL_DAMAGE|HEAL_TRAUMAS|HEAL_BLOOD|HEAL_TEMP, excess_healing = 50, force_grab_ghost = TRUE)
	affected_mob.visible_message(span_danger("[affected_mob]'s body regenerates as [affected_mob.p_they()] rises, getting back up onto their feet!"), \
								span_danger("You rise from the dead - the Khara restores you!"))


/datum/weather/khara_infection
	name = "Khara Fog"
	desc = "A thick fog filled with Khara spores..."

	telegraph_message = span_userdanger("A fog filled with Khara spores descends from the sky!")
	telegraph_duration = 30 SECONDS

	weather_message = span_userdanger("A thick, acrid fog descends from the sky. Time to switch to an internal air supply!")
	weather_overlay = "dust_med"
	weather_color = COLOR_MAROON

	end_message = span_userdanger("The fog disperses!")
	end_duration = 0 SECONDS

	area_type = /area
	protected_areas = list(/area/space)
	target_trait = ZTRAIT_STATION

	use_glow = FALSE
	weather_flags = (WEATHER_MOBS | WEATHER_ENDLESS)


/datum/weather/khara_infection/New(z_levels, list/weather_data)
	. = ..()
	weather_reagent_holder = new(null)
	weather_reagent_holder.create_reagents(WEATHER_REAGENT_VOLUME, NO_REACT)
	weather_reagent_holder.reagents.add_reagent(/datum/reagent/toxin/khara, WEATHER_REAGENT_VOLUME)
	weather_reagent_holder.reagents.set_temperature(weather_temperature)

/datum/weather/khara_infection/weather_act_mob(mob/living/victim)
	if(!ishuman(victim))
		return
	var/mob/living/carbon/human/human = victim
	if(human.stat == DEAD)
		return

	var/does_breath = FALSE
	if(human.external && human.external.breathing_mob == human)
		does_breath = FALSE
	else if(human.internal && human.internal.breathing_mob == human)
		does_breath = FALSE
	else if(HAS_TRAIT(human, TRAIT_NOBREATH))
		does_breath = FALSE
	else
		var/obj/item/organ/lungs/lungs = human.get_organ_slot(ORGAN_SLOT_LUNGS)
		if(lungs && (lungs.organ_flags & ORGAN_ORGANIC))
			does_breath = TRUE

	var/obj/item/clothing/suit = human.wear_suit
	var/obj/item/clothing/mask = human.is_mouth_covered(ITEM_SLOT_MASK)
	var/total_prot = (suit?.get_armor_rating(BIO) + mask?.get_armor_rating(BIO))
	if(!does_breath && total_prot >= 80)
		return
	if(human.has_reagent(/datum/reagent/toxin/khara, 10))
		return // already enough

	weather_reagent_holder.reagents.expose(human, VAPOR|INHALE, show_message = TRUE)
