/datum/component/pregnancy
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// Type of baby that pops out, anything but humans will not use DNA properly - Must be /mob/living subtype
	var/mob/living/baby_type = /mob/living/carbon/human
	/// Type of egg that pops out, should be an /obj/item/food/egg subtype but you don't *have* to
	var/atom/movable/egg_type = /obj/item/food/egg/oviposition

	/// A copy of the mother's DNA *at the time of insemination*
	var/datum/dna/mother_dna
	/// A copy of the father's DNA *at the time of insemination*
	var/datum/dna/father_dna

	/// Name is not actually stored in the DNA, do not ask
	var/mother_name = "CHUNGUS"
	/// Name is not actually stored in the DNA, do not ask
	var/father_name = "SLUGMA"
	/// Name of the baby, set to null for ghost player choice
	var/baby_name

	/// Skin used for the egg in case this is oviposition
	var/egg_skin

	/// Distribution of genes between mother and father
	var/pregnancy_genetic_distribution = PREGNANCY_GENETIC_DISTRIBUTION_DEFAULT

	/// A set of flags for how the pregnancy should behave, this is generally gonna be set based on the mother's preferences
	var/pregnancy_flags = NONE

	/// How long until the baby is ready to do hard labor
	var/pregnancy_duration = PREGNANCY_DURATION_DEFAULT

	/// How long until the egg hatches
	var/pregnancy_egg_duration = PREGNANCY_EGG_DURATION

	/// Current progress of pregnancy, in deciseconds
	var/pregnancy_progress = 0

	/// Current stage of pregnancy
	var/pregnancy_stage = 0

	/// This is dumb but did we have a belly before gregnancy? How big was it?
	var/previous_belly_size = null

/datum/component/pregnancy/Initialize(mob/living/mother, mob/living/father, baby_type, egg_type)
	// You can impregnate floor tiles if you want but areas and datums is where it gets stupid
	if(!isatom(parent) || isarea(parent))
		return COMPONENT_INCOMPATIBLE

	if(ispath(baby_type, /mob/living))
		src.baby_type = baby_type
	else if(baby_type)
		stack_trace("Invalid baby_type given to pregnancy component!")
		return COMPONENT_INCOMPATIBLE
	else if(mother)
		src.baby_type = mother.type

	if(ispath(egg_type, /atom/movable))
		src.egg_type = egg_type
	else if(egg_type)
		stack_trace("Invalid egg_type given to pregnancy component!")
		return COMPONENT_INCOMPATIBLE

	mother_dna = new()
	if(ishuman(mother))
		var/mob/living/carbon/human/baby_momma = mother
		baby_momma.dna.copy_dna(mother_dna)
	else
		mother_dna.initialize_dna(random_blood_type())

	father_dna = new()
	if(ishuman(father))
		var/mob/living/carbon/human/baby_daddy = father
		baby_daddy.dna.copy_dna(father_dna)
	else
		father_dna.initialize_dna(random_blood_type())

/datum/component/pregnancy/RegisterWithParent()
	var/mob/living/baby_momma = parent
	RegisterSignal(parent, SIGNAL_ADDTRAIT(TRAIT_INFERTILE), PROC_REF(on_infertile))
	if(istype(baby_momma))
		RegisterSignal(parent, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attacked_by))
		RegisterSignal(parent, COMSIG_LIVING_HEALTHSCAN, PROC_REF(on_health_scan))

		var/client/preference_source = GET_CLIENT(baby_momma)
		if(preference_source)
			pregnancy_flags = NONE
			if(preference_source.prefs.read_preference(/datum/preference/toggle/pregnancy/oviposition))
				pregnancy_flags |= PREGNANCY_FLAG_OVIPOSITION
			if(preference_source.prefs.read_preference(/datum/preference/toggle/pregnancy/cryptic))
				pregnancy_flags |= PREGNANCY_FLAG_CRYPTIC
			if(preference_source.prefs.read_preference(/datum/preference/toggle/pregnancy/belly_inflation))
				pregnancy_flags |= PREGNANCY_FLAG_BELLY_INFLATION

			pregnancy_duration = preference_source.prefs.read_preference(/datum/preference/numeric/pregnancy/duration) * PREGNANCY_DURATION_DIVIDER
			pregnancy_genetic_distribution = preference_source.prefs.read_preference(/datum/preference/numeric/pregnancy/genetic_distribution)
	else
		RegisterSignal(parent, COMSIG_ATOM_BREAK, PROC_REF(on_atom_break))
		RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
		RegisterSignal(parent, SIGNAL_ADDTRAIT(TRAIT_WAS_RENAMED), PROC_REF(on_renamed))
		RegisterSignal(parent, SIGNAL_REMOVETRAIT(TRAIT_WAS_RENAMED), PROC_REF(on_renamed_removed))

	START_PROCESSING(SSobj, src)

/datum/component/pregnancy/UnregisterFromParent()
	UnregisterSignal(parent, SIGNAL_ADDTRAIT(TRAIT_INFERTILE))
	if(isliving(parent))
		UnregisterSignal(parent, list(
			COMSIG_LIVING_HEALTHSCAN,
			COMSIG_ATOM_ATTACKBY,
		))

		var/mob/living/baby_momma = parent
		baby_momma.clear_alert(ALERT_PREGNANCY)

		var/obj/item/organ/genital/belly/belly = baby_momma.get_organ_slot(ORGAN_SLOT_BELLY)
		if(istype(belly))
			if(previous_belly_size)
				belly.set_size(previous_belly_size)
			else
				belly.Remove(baby_momma)
				qdel(belly)
	else
		UnregisterSignal(parent, list(
			COMSIG_ATOM_BREAK,
			COMSIG_ATOM_EXAMINE,
			SIGNAL_ADDTRAIT(TRAIT_WAS_RENAMED),
			SIGNAL_REMOVETRAIT(TRAIT_WAS_RENAMED),
		))

	QDEL_NULL(mother_dna)
	QDEL_NULL(father_dna)

	previous_belly_size = null

	STOP_PROCESSING(SSobj, src)

/datum/component/pregnancy/process(seconds_per_tick)
	if(!isliving(parent))
		pregnancy_progress += (seconds_per_tick SECONDS)
		var/previous_stage = pregnancy_stage
		pregnancy_stage = min(FLOOR((pregnancy_progress / pregnancy_duration) * 5, 1), 5)
		if(pregnancy_stage >= 5)
			var/atom/thingamabob = parent
			if(previous_stage < 5)
				thingamabob.audible_message(span_warning("[thingamabob] starts shaking and rumbling!"))
			else
				give_birth(get_turf(thingamabob))
				qdel(src)
		return

	if(HAS_TRAIT(parent, TRAIT_STASIS))
		return

	pregnancy_progress += seconds_per_tick
	var/previous_stage = pregnancy_stage
	pregnancy_stage = min(FLOOR((pregnancy_progress / pregnancy_duration) * 5, 1), 5)

	var/mob/living/baby_momma = parent
	if(pregnancy_stage >= 2)
		if(previous_stage < 2)
			baby_momma.throw_alert(ALERT_PREGNANCY, /atom/movable/screen/alert/status_effect/pregnancy)
			to_chat(baby_momma, span_warning("You can feel some pressure build up against your chest cavity."))
		//big wave of nausea every 40 seconds or so
		else
			if(SPT_PROB(3, seconds_per_tick))
				baby_momma.adjust_disgust(30)
				to_chat(baby_momma, span_warning("Something squirms inside you."))

	if(pregnancy_stage >= 3)
		if(previous_stage < 3)
			if(pregnancy_flags & PREGNANCY_FLAG_BELLY_INFLATION)
				var/obj/item/organ/genital/belly/belly = baby_momma.get_organ_slot(ORGAN_SLOT_BELLY)
				if(istype(belly))
					previous_belly_size = belly.genital_size
					if(belly.genital_size < 4)
						belly.set_size(4)
						to_chat(baby_momma, span_warning("Your [belly] balloons in size as your [pregnancy_flags & PREGNANCY_FLAG_OVIPOSITION ? "egg" : "baby"] grows."))
		else if(baby_momma.getStaminaLoss() < 50)
			baby_momma.adjustStaminaLoss(2.5 * seconds_per_tick)

	if(pregnancy_stage >= 5)
		if(previous_stage < 5)
			baby_momma.add_mood_event("preggers", /datum/mood_event/pregnant_labor)
			baby_momma.adjustStaminaLoss(rand(50, 100))
			baby_momma.emote("scream")
			to_chat(baby_momma, span_userdanger("Your water broke! You need to lay down and squeeze the [pregnancy_flags & PREGNANCY_FLAG_OVIPOSITION ? "egg" : "baby"] out!"))
		else
			if((baby_momma.body_position != LYING_DOWN) || !SPT_PROB(10, seconds_per_tick))
				//constant nausea
				baby_momma.adjust_disgust(3 * seconds_per_tick)
				if((baby_momma.getStaminaLoss() < 100) && SPT_PROB(10, seconds_per_tick))
					baby_momma.emote("scream")
					baby_momma.adjustStaminaLoss("You REALLY need to give birth!")
			else
				var/baby_species = "animal"
				if(ishuman(baby_momma))
					var/mob/living/carbon/human/human_momma = baby_momma
					baby_species = LOWER_TEXT(human_momma.dna.species.name)
				baby_momma.visible_message(\
					span_nicegreen("[baby_momma] gives birth to \a [baby_species] [pregnancy_flags & PREGNANCY_FLAG_OVIPOSITION ? "egg" : "baby"]!"), \
					span_nicegreen("You give birth to \a [baby_species] [pregnancy_flags & PREGNANCY_FLAG_OVIPOSITION ? "egg" : "baby"]!"))

				var/obj/item/organ/genital/belly/belly = baby_momma.get_organ_slot(ORGAN_SLOT_BELLY)
				if(istype(belly) && !isnull(previous_belly_size))
					belly.set_size(previous_belly_size)

				if(pregnancy_flags & PREGNANCY_FLAG_OVIPOSITION)
					INVOKE_ASYNC(src, PROC_REF(lay_egg), get_turf(baby_momma), baby_species, egg_skin)
				else
					INVOKE_ASYNC(src, PROC_REF(give_birth), get_turf(baby_momma))
				if(!QDELETED(src))
					qdel(src)
				baby_momma.add_mood_event("preggers", (pregnancy_flags & PREGNANCY_FLAG_OVIPOSITION ? /datum/mood_event/pregnant_relief/egg : /datum/mood_event/pregnant_relief))

/datum/component/pregnancy/proc/lay_egg(atom/location, egg_species, egg_skin = src.egg_skin)
	var/atom/movable/egg = new egg_type(location)
	if(istype(egg, /obj/item/food/egg/oviposition))
		var/obj/item/food/egg/oviposition/actually_an_egg = egg
		actually_an_egg.name = "[egg_species || "nondescript"] egg"
		if(egg_skin)
			var/egg_icon_state = GLOB.pregnancy_egg_skins[egg_skin]
			if(egg_icon_state)
				actually_an_egg.icon_state = egg_icon_state
				actually_an_egg.base_icon_state = egg_icon_state
				actually_an_egg.update_appearance()

	var/datum/component/pregnancy/new_preggers = egg.AddComponent(/datum/component/pregnancy, baby_type = src.baby_type, egg_type = src.egg_type)
	if(!new_preggers)
		return

	mother_dna.copy_dna(new_preggers.mother_dna)
	mother_name = src.mother_name
	father_dna.copy_dna(new_preggers.father_dna)
	father_name = src.father_name
	new_preggers.pregnancy_flags = (src.pregnancy_flags & ~PREGNANCY_FLAG_OVIPOSITION)
	new_preggers.pregnancy_duration = src.pregnancy_egg_duration
	new_preggers.pregnancy_egg_duration = src.pregnancy_egg_duration

/datum/component/pregnancy/proc/give_birth(atom/location)
	var/mob/living/babby = new baby_type(location)
	if(ishuman(babby))
		var/mob/living/carbon/human/human_babby = babby
		determine_baby_dna(human_babby)
		if(baby_name)
			human_babby.real_name = baby_name
			human_babby.name = baby_name
			human_babby.updateappearance()
		babby.set_resting(TRUE, silent = TRUE, instant = TRUE)
	babby.AdjustUnconscious(30 SECONDS)

	playsound(parent, 'sound/effects/splat.ogg', 80, vary = TRUE)

	babby.AddComponent(\
		/datum/component/ghost_direct_control,\
		ban_type = ROLE_SENTIENCE,\
		role_name = "Offspring of [mother_name || "someone"][father_name ? " and [father_name]" : ""]",\
		poll_question = "Do you want to play as [mother_name || "someone"]'s offspring?[baby_name ? " Your name will be [baby_name]" : ""]",\
		poll_candidates = TRUE,\
		poll_length = 30 SECONDS,\
		assumed_control_message = "You are the son (or daughter) of [mother_name || "someone"][father_name ? " and [father_name]" : ""]!",\
		poll_ignore_key = POLL_IGNORE_PREGNANCY,\
		after_assumed_control = baby_name ? null : CALLBACK(src, TYPE_PROC_REF(/mob/living, post_pregnancy_possession)),\
	)

	var/atom/atom_parent = parent
	if(atom_parent.uses_integrity)
		atom_parent.atom_break(BRUTE)

/datum/component/pregnancy/proc/determine_baby_dna(mob/living/carbon/human/babby)
	babby.set_hairstyle(pick("Bedhead", "Bedhead 2", "Bedhead 3"), update = FALSE)
	babby.set_facial_hairstyle("Shaved", update = FALSE)
	babby.underwear = "Nude"
	babby.undershirt = "Nude"
	babby.socks = "Nude"
	babby.updateappearance()

/datum/component/pregnancy/proc/try_rename_baby(mob/user)
	var/target_name = reject_bad_name(tgui_input_text(src, "What will the name of [mother_name || "someone"]'s offspring?", "The miracle of birth"))
	if(!target_name || !user.Adjacent(parent))
		return

	baby_name = target_name

	var/atom/baby_momma = parent
	baby_momma.visible_message(span_notice("[user] writes \"[target_name]\" on [baby_momma]'s belly."), \
								span_notice("[user] writes \"[target_name]\" on your belly."))

/datum/component/pregnancy/proc/on_attacked_by(datum/source, obj/item/pen, mob/living/attacker, params)
	SIGNAL_HANDLER

	if(attacker.combat_mode || !istype(pen, /obj/item/pen) || (attacker.zone_selected != BODY_ZONE_PRECISE_GROIN))
		return

	INVOKE_ASYNC(src, PROC_REF(try_rename_baby), attacker)

/datum/component/pregnancy/proc/on_health_scan(datum/source, list/render_list, advanced, mob/user, mode, tochat)
	SIGNAL_HANDLER

	if(pregnancy_flags & PREGNANCY_FLAG_CRYPTIC)
		return

	if(pregnancy_stage >= 5)
		render_list += conditional_tooltip("<span class='alert ml-1'>Subject is going into labor!</span>", "Patient will suffer from extreme nausea and fatigue until they deliver their baby.", tochat)
	else if((pregnancy_stage >= 2) || advanced)
		render_list += conditional_tooltip("<span class='alert ml-1'>Subject is impregnated.</span>", "Wait until patient goes into labor, or perform an abortion.", tochat)
	render_list += "<br>"

/datum/component/pregnancy/proc/on_atom_break(atom/source, damage_flag)
	SIGNAL_HANDLER

	qdel(src)

/datum/component/pregnancy/proc/on_examine(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(pregnancy_stage >= 5)
		examine_list += span_boldwarning("[source] [source.p_are()] gonna hatch soon!")
	else if(pregnancy_stage >= 4)
		examine_list += span_notice("[source] [source.p_are()] pretty close to hatching.")
	else
		examine_list += span_notice("[source] [source.p_are()] not ready to hatch yet.")

/datum/component/pregnancy/proc/on_renamed(atom/source)
	SIGNAL_HANDLER

	baby_name = reject_bad_name(source.name)

/datum/component/pregnancy/proc/on_renamed_removed(atom/source)
	SIGNAL_HANDLER

	baby_name = null

/datum/component/pregnancy/proc/on_infertile(atom/source)
	SIGNAL_HANDLER

	if(iscarbon(source))
		var/mob/living/carbon/abortos = source
		abortos.vomit(vomit_flags = MOB_VOMIT_STUN | MOB_VOMIT_HARM | MOB_VOMIT_BLOOD, lost_nutrition = 20)
		to_chat(abortos, span_userdanger("Your belly shrivels up!"))
	qdel(src)

/mob/living/proc/post_pregnancy_possession(mob/harbinger)
	return

/mob/living/carbon/human/post_pregnancy_possession(mob/harbinger)
	var/target_name = reject_bad_name(tgui_input_text(src, "What will be your name?", "The miracle of birth"))
	if(!target_name)
		return

	real_name = target_name
	name = real_name
	updateappearance()

/**
 * Who is the liar but he who denies that Jesus is the Christ? This is the antichrist, he who denies the Father and the Son.
 * - John 2:22
 */
/atom/movable/screen/alert/status_effect/pregnancy
	name = "Pregnant"
	desc = "Something rumbles inside you."
	icon = 'modular_zzplurt/icons/hud/screen_alert.dmi'
	icon_state = "baby"
