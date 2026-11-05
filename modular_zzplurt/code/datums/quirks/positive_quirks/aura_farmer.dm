// aura farming! lets you smoke without consequences!

/datum/quirk/aura_farmer
	name = "Aura Farmer"
	desc = "The harmful effects of cigarettes cannot penetrate your effortless cool factor."
	icon = FA_ICON_SMOG
	value = 2
	mob_trait = TRAIT_AURA_FARMER
	gain_text = span_notice("You feel hard-boiled.")
	lose_text = span_notice("You feel soft-boiled once more.")
	medical_record_text = "Patient is SO fucking cool."
	hardcore_value = -1

/datum/quirk/aura_farmer/add(client/client_source)
	. = ..()
	// quirks are on body, but addiction is on mind, so we clear it when a mind gets transferred in
	RegisterSignals(quirk_holder, list(COMSIG_MOB_MIND_INITIALIZED, COMSIG_MOB_MIND_TRANSFERRED_INTO), PROC_REF(on_mind_changed))
	clear_nicotine_dependence()

/datum/quirk/aura_farmer/remove()
	UnregisterSignal(quirk_holder, list(COMSIG_MOB_MIND_INITIALIZED, COMSIG_MOB_MIND_TRANSFERRED_INTO))
	return ..()

/datum/quirk/aura_farmer/proc/on_mind_changed(datum/source)
	SIGNAL_HANDLER
	clear_nicotine_dependence()

/datum/quirk/aura_farmer/proc/clear_nicotine_dependence()
	quirk_holder.mind?.remove_addiction_points(/datum/addiction/nicotine, MAX_ADDICTION_POINTS)

// addiction is of the mind but aura is of the body
/datum/mind/add_addiction_points(type, amount)
	if(type == /datum/addiction/nicotine && amount > 0 && current && HAS_TRAIT(current, TRAIT_AURA_FARMER))
		return
	return ..()

/mob/living/carbon
	/// keeps track of the puff we're currently handling and is cleared when handle_reagents() returns
	var/datum/smoking_puff_context/smoking_puff_context

// see handle_reagents() in code/game/objects/items/cigarettes.dm for why this needs finangling
// in order, it exposes you to the chemicals, damages your lungs, then transfers the chemicals into you
// we only block the lung damage in the middle. poisoned cigs should still do their thing
// this will need a look if upstream ever refactors smoking code for some reason
/datum/smoking_puff_context
	/// the cig this puff came from
	var/obj/item/cigarette/cigarette
	/// its reagent holder so other chems don't trip protection
	var/datum/reagents/reagent_holder
	/// if a callback starts another puff we need to put the first one back afterwards
	var/datum/smoking_puff_context/previous_context
	/// exposure can cause more exposure so we wait for the outer call to finish before arming
	var/exposure_depth = 0
	/// only the first exposure gets to arm this (and not once reagent transfer has started)
	var/awaiting_exposure = TRUE
	/// lets us skip one lung adjustment and then immediately switches itself off
	var/armed = FALSE

/datum/smoking_puff_context/Destroy()
	cigarette = null
	reagent_holder = null
	previous_context = null
	return ..()

// clean up after ourselves even if the parent runtimes so as not to grant anybody Invincible Lungs
/datum/smoking_puff_context/proc/finish(mob/living/carbon/smoker)
	armed = FALSE
	awaiting_exposure = FALSE
	if(!QDELETED(smoker) && smoker.smoking_puff_context == src)
		smoker.smoking_puff_context = previous_context
	qdel(src)

/obj/item/cigarette/handle_reagents(seconds_per_tick)
	// accounting for gas mask cigs
	var/obj/item/worn_item = src
	if(istype(loc, /obj/item/clothing/mask/gas))
		worn_item = loc
	var/mob/living/carbon/smoker = worn_item.loc
	if(!istype(smoker) || smoker.get_item_by_slot(ITEM_SLOT_MASK) != worn_item || !HAS_TRAIT(smoker, TRAIT_AURA_FARMER))
		return ..()

	var/datum/smoking_puff_context/context = new
	context.cigarette = src
	context.reagent_holder = reagents
	context.previous_context = smoker.smoking_puff_context
	smoker.smoking_puff_context = context
	try
		. = ..()
	catch(var/exception/error)
		context.finish(smoker)
		throw error // clean up but don't eat the error
	context.finish(smoker)

/datum/reagents/expose(atom/target, methods = TOUCH, volume_modifier = 1, show_message = 1, list/datum/reagent/r_to_expose = null)
	if(!iscarbon(target))
		return ..()
	var/mob/living/carbon/smoker = target
	var/datum/smoking_puff_context/context = smoker.smoking_puff_context
	if(!context || !context.awaiting_exposure || context.reagent_holder != src || !(methods & INHALE))
		return ..()

	context.exposure_depth++
	context.armed = FALSE
	try
		. = ..()
	catch(var/exception/error)
		context.exposure_depth--
		context.awaiting_exposure = FALSE
		throw error
	context.exposure_depth--
	if(!context.exposure_depth && context.awaiting_exposure && !QDELETED(smoker) && smoker.smoking_puff_context == context && !QDELETED(context.cigarette))
		context.awaiting_exposure = FALSE
		context.armed = TRUE

/mob/living/carbon/adjust_organ_loss(slot, amount, maximum, required_organ_flag = NONE)
	if(slot == ORGAN_SLOT_LUNGS && smoking_puff_context?.armed)
		smoking_puff_context.armed = FALSE
		if(amount > 0 && HAS_TRAIT(src, TRAIT_AURA_FARMER))
			return FALSE
	return ..()

/datum/reagents/trans_to(
	atom/target,
	amount = 1,
	multiplier = 1,
	datum/reagent/target_id,
	preserve_data = TRUE,
	no_react = FALSE,
	mob/transferred_by,
	remove_blacklisted = FALSE,
	methods = NONE,
	show_message = TRUE,
	ignore_stomach = FALSE,
	copy_only = FALSE
)
	if(iscarbon(target))
		var/mob/living/carbon/smoker = target
		var/datum/smoking_puff_context/context = smoker.smoking_puff_context
		if(context?.reagent_holder == src)
			// missing lungs and robolungs skip the damage call so we disarm here too. transfer still runs
			context.armed = FALSE
			context.awaiting_exposure = FALSE
	return ..()
