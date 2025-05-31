/**
 * Who is the liar but he who denies that Jesus is the Christ? This is the antichrist, he who denies the Father and the Son.
 * - John 2:22
 */
/datum/status_effect/pregnancy
	id = "pregnancy"
	duration = STATUS_EFFECT_PERMANENT //not actually permanent, but only clears once we actually deliver the egg
	tick_interval = 2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/pregnancy
	remove_on_fullheal = FALSE

	/// Type of baby that pops out, anything but humans will not use DNA properly - Must be /mob/living subtype
	var/mob/living/baby_type = /mob/living/carbon/human
	/// Type of egg that pops out, should be an /obj/item/food/egg subtype but you don't *have* to
	var/atom/movable/egg_type = /obj/item/food/egg/oviposition

	/// A copy of the mother's DNA *at the time of insemination*
	var/datum/dna/mother_dna
	/// A copy of the father's DNA *at the time of insemination*
	var/datum/dna/father_dna

	/// Name is not actually stored in the DNA, do not ask
	var/mother_name
	/// Name is not actually stored in the DNA, do not ask
	var/father_name
	/// Name of the baby, set to null for ghost player choice
	var/baby_name

	/// Skin used for the egg (see lewd_items/pregnancy.dm)
	var/egg_skin

	/// Distribution of genes between mother and father
	var/pregnancy_genetic_distribution = PREGNANCY_GENETIC_DISTRIBUTION_DEFAULT

	/// A set of flags for how the pregnancy should behave, this is generally gonna be set based on the mother's preferences
	var/pregnancy_flags = NONE

	/// How long until hard labor
	var/pregnancy_duration = PREGNANCY_DURATION_DEFAULT * PREGNANCY_DURATION_MULTIPLIER

	/// Current progress of pregnancy, in deciseconds
	var/pregnancy_progress = 0

	/// Current stage of pregnancy
	var/pregnancy_stage = 0

	/// This is dumb but did we have a belly before gregnancy? How big was it?
	var/previous_belly_size = null

/datum/status_effect/pregnancy/Destroy()
	if(owner)
		UnregisterSignal(owner, list(\
			SIGNAL_ADDTRAIT(TRAIT_INFERTILE),\
			COMSIG_ATOM_ATTACKBY,\
			COMSIG_LIVING_DEATH,\
			COMSIG_LIVING_HEALTHSCAN,\
		))
		var/obj/item/organ/genital/belly/belly = owner.get_organ_slot(ORGAN_SLOT_BELLY)
		if(istype(belly))
			if(!isnull(previous_belly_size))
				belly.set_size(previous_belly_size)
			else
				belly.Remove(owner)
				qdel(belly)
		owner.clear_mood_event("pregnancy")
	return ..()

/datum/status_effect/pregnancy/on_creation(mob/living/new_owner, mob/living/mother, mob/living/father, baby_type, egg_type)
	if(ispath(baby_type, /mob/living))
		src.baby_type = baby_type

	if(ispath(egg_type, /atom/movable))
		src.egg_type = egg_type

	mother_dna = new()
	if(ishuman(mother))
		var/mob/living/carbon/human/baby_momma = mother
		baby_momma.dna.update_dna_identity()
		baby_momma.dna.copy_dna(mother_dna)
		mother_name = baby_momma.real_name
	else
		mother_dna.initialize_dna(random_human_blood_type())

	father_dna = new()
	if(ishuman(father))
		var/mob/living/carbon/human/baby_daddy = father
		baby_daddy.dna.update_dna_identity()
		baby_daddy.dna.copy_dna(father_dna)
		father_name = baby_daddy.real_name
	else
		father_dna.initialize_dna(random_human_blood_type())

	inherit_preferences(new_owner)
	. = ..()
	if(QDELETED(src))
		return

	RegisterSignal(new_owner, SIGNAL_ADDTRAIT(TRAIT_INFERTILE), PROC_REF(on_infertile))
	RegisterSignal(new_owner, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attacked_by))
	RegisterSignal(new_owner, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	RegisterSignal(new_owner, COMSIG_LIVING_HEALTHSCAN, PROC_REF(on_health_scan))

/datum/status_effect/pregnancy/proc/inherit_preferences(mob/living/gestator)
	var/client/preference_source = GET_CLIENT(gestator)
	if(!preference_source)
		return FALSE

	pregnancy_flags = NONE
	if(preference_source.prefs.read_preference(/datum/preference/toggle/pregnancy/cryptic))
		pregnancy_flags |= PREGNANCY_FLAG_CRYPTIC
	if(preference_source.prefs.read_preference(/datum/preference/toggle/pregnancy/belly_inflation))
		pregnancy_flags |= PREGNANCY_FLAG_BELLY_INFLATION
	if(preference_source.prefs.read_preference(/datum/preference/toggle/pregnancy/inert))
		pregnancy_flags |= PREGNANCY_FLAG_INERT

	pregnancy_duration = preference_source.prefs.read_preference(/datum/preference/numeric/pregnancy/duration) * PREGNANCY_DURATION_MULTIPLIER

/datum/status_effect/pregnancy/proc/try_rename_baby(mob/user)
	var/target_name = reject_bad_name(tgui_input_text(src, "What will the name of [mother_name || "someone"]'s offspring?", "The miracle of birth"))
	if(!target_name || !user.Adjacent(owner))
		return

	baby_name = target_name
	owner.visible_message(span_notice("[user] writes \"[target_name]\" on [owner]'s belly."), \
								span_notice("[user] writes \"[target_name]\" on your belly."))

/datum/status_effect/pregnancy/proc/on_death(datum/source)
	SIGNAL_HANDLER

	qdel(src)

/datum/status_effect/pregnancy/proc/on_attacked_by(datum/source, obj/item/pen, mob/living/attacker, params)
	SIGNAL_HANDLER

	if(attacker.combat_mode || !istype(pen, /obj/item/pen) || (attacker.zone_selected != BODY_ZONE_PRECISE_GROIN))
		return

	INVOKE_ASYNC(src, PROC_REF(try_rename_baby), attacker)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/status_effect/pregnancy/proc/on_health_scan(datum/source, list/render_list, advanced, mob/user, mode, tochat)
	SIGNAL_HANDLER

	if(pregnancy_flags & PREGNANCY_FLAG_CRYPTIC)
		return

	if(pregnancy_stage >= 5)
		render_list += conditional_tooltip("<span class='alert ml-1'>Subject is going into labor!</span>", "Patient will suffer from extreme nausea and fatigue until they deliver their baby.", tochat)
	else if((pregnancy_stage >= 2) || advanced)
		render_list += conditional_tooltip("<span class='alert ml-1'>Subject is pregnant[advanced ? " (Stage [pregnancy_stage])" : "."]</span>", "Wait until patient goes into labor, or perform an abortion.", tochat)
	render_list += "<br>"

/datum/status_effect/pregnancy/proc/on_infertile(atom/source)
	SIGNAL_HANDLER

	if(iscarbon(source))
		var/mob/living/carbon/abortos = source
		abortos.vomit(vomit_flags = MOB_VOMIT_STUN | MOB_VOMIT_HARM | MOB_VOMIT_BLOOD, lost_nutrition = 20)
		to_chat(abortos, span_userdanger("Your belly shrivels up!"))
	qdel(src)

/datum/status_effect/pregnancy/tick(seconds_between_ticks)
	. = ..()

	pregnancy_progress += (seconds_between_ticks SECONDS)
	var/previous_stage = pregnancy_stage
	pregnancy_stage = min(FLOOR((pregnancy_progress / pregnancy_duration) * 5, 1), 5)

	if(pregnancy_stage >= 2)
		if(previous_stage < 2)
			to_chat(owner, span_warning("You can feel some pressure build up against your chest cavity."))
		//big wave of nausea every 40 seconds or so
		else
			if(SPT_PROB(1.5, seconds_between_ticks))
				owner.adjust_disgust(30)
				to_chat(owner, span_warning("Something [pick("squirms", "shakes", "kicks")] inside you."))

	if(pregnancy_stage >= 3)
		if(previous_stage < 3)
			if(pregnancy_flags & PREGNANCY_FLAG_BELLY_INFLATION)
				var/obj/item/organ/genital/belly/belly = owner.get_organ_slot(ORGAN_SLOT_BELLY)
				if(istype(belly))
					previous_belly_size = belly.genital_size
					if(belly.genital_size < 4)
						belly.set_size(4)
						to_chat(owner, span_warning("Your [belly] balloons in size as your egg grows."))
		else if(owner.getStaminaLoss() < 50)
			owner.adjustStaminaLoss(2.5 * seconds_between_ticks)

	if(pregnancy_stage >= 5)
		if(previous_stage < 5)
			owner.add_mood_event("preggers", /datum/mood_event/pregnant_labor)
			owner.adjustStaminaLoss(rand(50, 100))
			owner.emote("scream")
			to_chat(owner, span_userdanger("Your water broke! You need to lay down and squeeze the egg out!"))
		else
			var/can_deliver = (owner.body_position == LYING_DOWN)
			if(can_deliver && ishuman(owner))
				var/mob/living/carbon/human/human_momma = owner
				var/obj/item/bodypart/covered = human_momma.get_bodypart(deprecise_zone(BODY_ZONE_PRECISE_GROIN))
				can_deliver = (!covered || !length(human_momma.get_clothing_on_part(covered)))
			if((owner.body_position != LYING_DOWN) || !SPT_PROB(5, seconds_between_ticks))
				//constant nausea
				owner.adjust_disgust(3 * seconds_between_ticks)
				if((owner.getStaminaLoss() < 100) && SPT_PROB(5, seconds_between_ticks))
					owner.emote("scream")
					to_chat(owner, "You REALLY need to give birth!")
			else
				var/egg_species = "animal"
				if(ishuman(owner) && ispath(baby_type, /mob/living/carbon/human))
					var/mob/living/carbon/human/human_momma = owner
					egg_species = LOWER_TEXT(human_momma.dna.species.name)
				else
					egg_species = LOWER_TEXT(initial(baby_type.name))
				owner.visible_message(\
					span_nicegreen("[owner] gives birth to \a [egg_species] egg!"), \
					span_nicegreen("You give birth to \a [egg_species] egg!"))

				var/obj/item/organ/genital/belly/belly = owner.get_organ_slot(ORGAN_SLOT_BELLY)
				if(istype(belly) && !isnull(previous_belly_size))
					belly.set_size(previous_belly_size)

				lay_egg(get_turf(owner), egg_species, egg_skin)
				owner.add_mood_event("preggers", /datum/mood_event/pregnant_relief)
				if(!QDELETED(src))
					qdel(src)

/datum/status_effect/pregnancy/proc/lay_egg(atom/location, egg_species, egg_skin = src.egg_skin)
	var/atom/movable/egg = new egg_type(location)
	if(istype(egg, /obj/item/food/egg/oviposition))
		var/obj/item/food/egg/oviposition/actually_an_egg = egg
		actually_an_egg.name = "[egg_species || "nondescript"] egg"
		if(egg_skin)
			var/egg_icon_state = GLOB.pregnancy_egg_skins[egg_skin]
			if(egg_icon_state)
				actually_an_egg.icon_state = egg_icon_state
				actually_an_egg.base_icon_state = egg_icon_state
				actually_an_egg.update_appearance(UPDATE_ICON)

	if(pregnancy_flags & PREGNANCY_FLAG_INERT)
		return

	var/mob/living/bouncing_baby_boy = new baby_type(location)
	if(ishuman(bouncing_baby_boy))
		var/mob/living/carbon/human/real_boy = bouncing_baby_boy
		determine_baby_dna(real_boy, src.mother_dna, src.father_dna, src.pregnancy_genetic_distribution)
		if(baby_name)
			real_boy.real_name = baby_name
			real_boy.name = baby_name
			real_boy.updateappearance()
		real_boy.set_resting(new_resting = TRUE, silent = TRUE, instant = TRUE)
	bouncing_baby_boy.AdjustUnconscious(30 SECONDS)

	egg.AddComponent(/datum/component/pregnant, bouncing_baby_boy, mother_name, father_name, baby_name, mother_dna, father_dna, pregnancy_genetic_distribution)

/atom/movable/screen/alert/status_effect/pregnancy
	name = "Pregnant"
	desc = "Something grows inside you."
	icon = 'modular_zzplurt/icons/hud/screen_alert.dmi'
	icon_state = "baby"
