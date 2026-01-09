#define IS_HYPNOTIZED(mob) (mob?.mind?.has_antag_datum(/datum/antagonist/hypnotized))

/// Coercion school. 7 spells
/// Psyonic assay - scans whether or not the target has psyonic abilities
/// Psyonic focus - heals brain and traumas
/// Psyonic mind read - advanced mind reаd(Works same as the gene mutation, but + job + memories). Granted to psychologists ONLY and only if they're a psycaster
/// Psyonic agony - single-use stun baton
/// Psyonic spasm - stuns for half a second, forces to drop everything from hands
/// Psyonic hypnosis - hypnotizes target with the phrase that the psycaster chose. ERP IS BAD. DO NOT ERP.
/// P.S. Apparently, originally this was supposed to be full-on mind control.
/// Psyonic blind - temporarily blinds the target

// tinfoil hat check. Protects from some coercion spells =)
/mob/living/carbon/human/proc/is_wearing_tinfoil_hat()
	if(istype(head, /obj/item/clothing/head/costume/foilhat))
		return TRUE
	return FALSE

// Add coercion school
/mob/living/carbon/human/proc/try_add_coercion_school(tier = 0, additional_school = 0)
	if(tier >= 0)
		var/datum/action/new_action = new /datum/action/cooldown/spell/touch/psyonic/psyonic_assay(src.mind || src, tier, additional_school)
		new_action.Grant(src)
	if(tier >= 1)
		var/datum/action/new_action = new /datum/action/cooldown/spell/pointed/psyonic/psyonic_focus(src.mind || src, tier, additional_school)
		new_action.Grant(src)
	if(tier >= 2)
		if(HAS_MIND_TRAIT(src, TRAIT_MADNESS_IMMUNE)) // aka psychologist
			var/datum/action/new_action = new /datum/action/cooldown/spell/touch/psyonic/psyonic_mind_read(src.mind || src, tier, additional_school)
			new_action.Grant(src)
		var/datum/action/new_action2 = new /datum/action/cooldown/spell/touch/psyonic/psyonic_hypnosis(src.mind || src, tier, additional_school)
		new_action2.Grant(src)
	if(tier >= 3)
		var/datum/action/new_action = new /datum/action/cooldown/spell/touch/psyonic/psyonic_agony(src.mind || src, tier, additional_school)
		new_action.Grant(src)
		var/datum/action/new_action2 = new /datum/action/cooldown/spell/pointed/psyonic/psyonic_spasm(src.mind || src, tier, additional_school)
		new_action2.Grant(src)
	if(tier >= 4) // Being able to cast blindness for ~15 seconds is crazy.
		var/datum/action/new_action = new /datum/action/cooldown/spell/pointed/psyonic/psyonic_blind(src.mind || src, tier, additional_school)
		new_action.Grant(src)

// Spell to check if the target has psyonic abilities
/datum/action/cooldown/spell/touch/psyonic/psyonic_assay
	name = "Psyonic Assay"
	desc = "Check if the target is a psyonic."
	button_icon = 'icons/obj/medical/organs/organs.dmi'
	button_icon_state = "brain"
	cooldown_time = 3 SECONDS
	mana_cost = 5
	stamina_cost = 0
	target_msg = "You get a brief headache, but it quickly fades."
	hand_path = /obj/item/melee/touch_attack/psyonic_mending
	draw_message = span_notice("You ready your hand to cleanse the patient.")
	drop_message = span_notice("You lower your hand.")
	can_cast_on_self = TRUE

/datum/action/cooldown/spell/touch/psyonic/psyonic_assay/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/mendicant)
	if(ishuman(victim))
		var/mob/living/carbon/human/human_victim = victim
		if(human_victim.can_block_magic(antimagic_flags))
			to_chat(human_victim, span_notice("A psycaster nearby tries to check you for psyonic abilities."))
		else
			to_chat(human_victim, span_warning(target_msg))
		owner.visible_message(span_warning("[owner] presses a thumb onto [victim]'s forehead."),
							  span_notice("You press your thumb onto [victim]'s forehead and begin reading them."))
		to_chat(victim, span_danger("[owner] presses a thumb onto your forehead and holds it there. It burns sligthly!"))
		if(do_after(mendicant, 6 SECONDS, human_victim, IGNORE_SLOWDOWNS, TRUE))
			read_psyonic_level(human_victim)
		drain_mana()
		return TRUE
	else
		return FALSE

/datum/action/cooldown/spell/touch/psyonic/psyonic_assay/proc/read_psyonic_level(mob/living/carbon/human/patient)
	if(issynthetic(patient) && secondary_school != "Psychokinesis")
		to_chat(owner, span_notice("All I see is... Numbers. This doesn't work on synths."))
		return FALSE

	if(patient.ispsyonic())
		var/datum/quirk/psyonic/target_quirk = patient.get_quirk(/datum/quirk/psyonic)
		owner.visible_message(span_notice("[owner] backs off from [patient]."),
							  span_cyan("Target is a psycaster from the school of [target_quirk.school]. [patient.p_Their()] class is [target_quirk.psyonic_level_string]"))
	else
		owner.visible_message(span_notice("[owner] backs off from [patient]."),
							  span_cyan("Target is not a psycaster."))

// Tending brains and braintraumas
/datum/action/cooldown/spell/pointed/psyonic/psyonic_focus
	name = "Psyonic Focus"
	desc = "Try to restore the patient's brain to its natural, initial condition, fixing brain damage. Has a chance to heal traumas. May be cast over distance."
	button_icon = 'icons/obj/medical/organs/organs.dmi'
	button_icon_state = "brain-smooth"
	cooldown_time = 1 SECONDS
	mana_cost = 40
	target_msg = "You feel like something is messing with your brain..."
	active_msg = "You prepare to tend to someone's mind..."

/datum/action/cooldown/spell/pointed/psyonic/psyonic_focus/New(Target)
	. = ..()
	if(secondary_school == "Redaction")
		cast_power += 1

/datum/action/cooldown/spell/pointed/psyonic/psyonic_focus/is_valid_target(atom/cast_on)
	if(!ishuman(cast_on))
		return FALSE
	if(issynthetic(cast_on) && secondary_school != "Psychokinesis")
		to_chat(owner, span_notice("I don't know how to work with synths."))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/psyonic/psyonic_focus/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(cast_on.can_block_magic(antimagic_flags))
		to_chat(cast_on, span_notice("Your mind is being healed by a psycaster nearby."))
	else
		to_chat(cast_on, span_warning(target_msg))
	owner.Beam(cast_on, icon_state = "blood_light", time = 5 SECONDS)
	owner.visible_message(span_warning("[owner] seems to concentrate on something..."),
						  span_notice("You start concentrating your energy to heal [cast_on]'s brain."))
	if(!do_after(owner, 5 SECONDS, cast_on, IGNORE_SLOWDOWNS | IGNORE_TARGET_LOC_CHANGE, TRUE))
		accident_harm(cast_on)
	else
		fix_brainz(cast_on)
	drain_mana()
	return TRUE

/datum/action/cooldown/spell/pointed/psyonic/psyonic_focus/proc/fix_brainz(mob/living/carbon/human/cast_on)
	var/b_damage = cast_on.get_organ_loss(ORGAN_SLOT_BRAIN)
	if(b_damage > 0)
		cast_on.adjust_organ_loss(ORGAN_SLOT_BRAIN, -10 * cast_power)

	var/traumas = cast_on.get_traumas()
	if(traumas)
		var/datum/brain_trauma/trauma = pick(traumas)
		if(trauma.resilience != TRAUMA_RESILIENCE_ABSOLUTE)
			cast_on.cure_trauma_type(resilience = trauma.resilience)
	cast_on.apply_status_effect(/datum/status_effect/drugginess, 20 SECONDS)

/datum/action/cooldown/spell/pointed/psyonic/psyonic_focus/proc/accident_harm(mob/living/carbon/human/cast_on)
	cast_on.adjust_organ_loss(ORGAN_SLOT_BRAIN, 15 * cast_power, 101)
	to_chat(cast_on, span_bolddanger("You head bursts in pain!"))

// Reads the mind. Returns last saylogs, intent, real name, memories, job hint, and a hint whether or not they're a certain antag.
/datum/action/cooldown/spell/touch/psyonic/psyonic_mind_read
	name = "Psyonic Mind Read"
	desc = "Rudely intrude into the target's thoughts."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "mindread"
	cooldown_time = 3 SECONDS
	mana_cost = 40
	stamina_cost = 40
	target_msg = "You feel an outside presence in your head!"

	hand_path = /obj/item/melee/touch_attack/psyonic_mending
	draw_message = span_notice("You ready your hand to read someone's mind.")
	drop_message = span_notice("You lower your hand.")
	can_cast_on_self = FALSE

/datum/action/cooldown/spell/touch/psyonic/psyonic_mind_read/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/mendicant)
	if(ishuman(victim))
		var/mob/living/carbon/human/human_victim = victim
		if(human_victim.is_wearing_tinfoil_hat())
			to_chat(human_victim, span_clockred("Your tinfoil hat vibrates, protecting your brain from some kind of invisible rays!"))
			to_chat(owner, span_clockred("As soon as you touch [human_victim]'s head, suddenly, pictures of your own mind appear! Looks like the tinfoil hat on their head is interfering!"))
			drain_mana()
			return TRUE
		if(human_victim.mind && human_victim.stat != DEAD)
			if(human_victim.can_block_magic(antimagic_flags))
				to_chat(human_victim, span_bolddanger("A psycaster nearby tries to read your mind!"))
			else
				to_chat(human_victim, span_warning(target_msg))
			owner.visible_message(span_warning("[owner] presses a thumb onto [victim]'s forehead."),
								span_notice("You press your thumb onto [victim]'s forehead and begin reading their mind."))
			to_chat(victim, span_danger("[owner] presses a thumb onto your forehead and holds it there. It burns sligthly!"))
			if(do_after(mendicant, 10 SECONDS, human_victim, IGNORE_SLOWDOWNS, TRUE))
				read_mind(human_victim)
			drain_mana()
			return TRUE
		else
			return FALSE
	else
		return FALSE

/datum/action/cooldown/spell/touch/psyonic/psyonic_mind_read/proc/read_mind(mob/living/carbon/human/patient)
	if(patient.can_block_magic(MAGIC_RESISTANCE_MIND, charge_cost = 0))
		to_chat(owner, span_warning("As you reach into [patient]'s mind, \
			you are stopped by a mental blockage. It seems you've been foiled."))
		return

	if(issynthetic(patient) && secondary_school != "Psychokinesis")
		to_chat(owner, span_notice("It's all binary numbers. How am I supposed to get info out of this tin can?"))
		return

	var/text_to_show = ""

	var/list/recent_speech = patient.copy_recent_speech(copy_amount = 10)
	if(length(recent_speech))
		text_to_show += span_boldnotice("You catch some drifting memories of their past conversations...") + "<br>"
		for(var/spoken_memory in recent_speech)
			text_to_show += span_notice("[spoken_memory]") + "<br>"

	text_to_show += span_notice("You find that their intent is to [patient.combat_mode ? "harm" : "help"]...") + "<br>"
	text_to_show += span_notice("You uncover that [patient.p_their()] true identity is [patient.mind.name].") + "<br>"
	if(cast_power >= 3)
		text_to_show += span_notice("You can vaguely read their memories: ") + boxed_message(span_italics(get_memories(patient)))
	text_to_show += span_notice("You try to read their job: ") + boxed_message(span_italics(get_job_fluff(patient)))
	if(patient.mind.enslaved_to || IS_HYPNOTIZED(patient))
		text_to_show += span_boldnotice("[patient.p_Their()] will is not free.") + "<br>"
	var/datum/mind/mind_to_read = patient.mind
	if(prob(20 * cast_power) && mind_to_read.antag_datums)
		if(IS_WIZARD(patient))
			text_to_show += span_notice("You can feel strong magical potential pulsing in this individual.") + "<br>"
		else if(IS_HERETIC(patient))
			text_to_show += span_notice("Reality bends around you and goes back to normal, as you try to read [patient.p_their()] mind.") + "<br>"
			var/mob/living/carbon/human/human_owner = owner
			human_owner.add_mood_event("gates_of_mansus", /datum/mood_event/gates_of_mansus)
		else if(IS_CULTIST(patient))
			text_to_show += span_red("Your mind is assaulted with torrents of blood and gore, as you try to dig deeper.") + "<br>"
		else // It's easy enough to spot a cultist/heretic/wizard as-is, all this does is adds extra flavour to magically-capable folks
			text_to_show += span_notice("You also can feel something hidden within [patient.p_their()] mind, but it's not readable.") + "<br>"

	to_chat(owner, boxed_message(span_infoplain(text_to_show)))

// Returns a hint about target's job
/datum/action/cooldown/spell/touch/psyonic/psyonic_mind_read/proc/get_job_fluff(mob/living/carbon/human/patient)
	var/datum/mind/mind_to_read = patient.mind
	var/datum/job/patient_job = mind_to_read.assigned_role
	var/text_to_return = ""
	if(patient_job.departments_bitflags & DEPARTMENT_BITFLAG_SECURITY)
		text_to_return += "This person's job involves beating up children and kittens." + "<br>"
	else if(patient_job.departments_bitflags & DEPARTMENT_BITFLAG_CENTRAL_COMMAND)
		text_to_return += "This person is has the greatest authority on this station." + "<br>"
	else if(patient_job.departments_bitflags & DEPARTMENT_BITFLAG_CAPTAIN)
		text_to_return += "This person is likely to have megalomania." + "<br>"
	else if(patient_job.departments_bitflags & DEPARTMENT_BITFLAG_COMMAND)
		text_to_return += "This person's calling is commanding others." + "<br>"
	else if(patient_job.departments_bitflags & DEPARTMENT_BITFLAG_SERVICE)
		text_to_return += "This person's labor is about servicing others." + "<br>"
	else if(patient_job.departments_bitflags & DEPARTMENT_BITFLAG_CARGO)
		text_to_return += "This person's job involves a lot of physical work." + "<br>"
	else if(patient_job.departments_bitflags & DEPARTMENT_BITFLAG_ENGINEERING)
		text_to_return += "This person keeps the station alive." + "<br>"
	else if(patient_job.departments_bitflags & DEPARTMENT_BITFLAG_SCIENCE)
		text_to_return += "This person is a nerd." + "<br>"
	else if(patient_job.departments_bitflags & DEPARTMENT_BITFLAG_MEDICAL)
		text_to_return += "This person is accustomed with wounds, blood and anatomy." + "<br>"
	else if(patient_job.departments_bitflags & DEPARTMENT_BITFLAG_SILICON)
		text_to_return += "This is a cyborg, doing cyborg things." + "<br>"
	else if(patient_job.departments_bitflags & DEPARTMENT_BITFLAG_ASSISTANT)
		text_to_return += "This person's mind reeks of freedom." + "<br>"
	else
		text_to_return += "This person is truly free. They are not obligated with any duties." + "<br>"

	return span_notice(text_to_return)

// Returns mind's memories. OP against traitors, as the uplink password is stored there, as well as the bank ID.
/datum/action/cooldown/spell/touch/psyonic/psyonic_mind_read/proc/get_memories(mob/living/carbon/human/patient)
	var/datum/mind/mind_to_read = patient.mind
	if(mind_to_read)
		var/itogo_text = ""
		for(var/key in mind_to_read.memories)
			var/datum/memory/mem = mind_to_read.memories[key]
			itogo_text += mem.name + "<br>"
		if(itogo_text == "")
			itogo_text = "[patient.p_Their()] head is empty."
		return itogo_text
	else
		return "I can't read [patient.p_their()] memories. Maybe there are none?" + "<br>"

// Single-use stun baton. Vanishes after a single hit
/datum/action/cooldown/spell/touch/psyonic/psyonic_agony
	name = "Psyonic Agony"
	desc = "Deals pain."
	button_icon = 'icons/obj/weapons/baton.dmi'
	button_icon_state = "stunbaton_active"
	cooldown_time = 0.5 SECONDS
	mana_cost = 40
	stamina_cost = 0
	hand_path = /obj/item/melee/touch_attack/psyonic_mending
	draw_message = span_notice("You ready your hand to deal pain.")
	drop_message = span_notice("You lower your hand.")
	can_cast_on_self = TRUE // :)

/datum/action/cooldown/spell/touch/psyonic/psyonic_agony/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/mendicant)
	if(ishuman(victim))
		var/mob/living/carbon/human/human_victim = victim
		if(human_victim.is_wearing_tinfoil_hat())
			to_chat(human_victim, span_clockred("Your tinfoil hat vibrates, protecting your brain from some kind of invisible rays!"))
			to_chat(owner, span_clockred("As soon as you touch [human_victim], your own body hurts like hell! Looks like the tinfoil hat on their head is interfering!"))
			psyonic_attack(owner)
			drain_mana()
			return TRUE
		if(human_victim.can_block_magic(antimagic_flags))
			to_chat(human_victim, span_notice("A psycaster nearby tries to attack you, yet fails."))
			to_chat(owner, span_notice("You can't attack them. They have some kind of protection."))
			return FALSE
		if(issynthetic(human_victim) && secondary_school != "Psychokinesis")
			human_victim.visible_message(span_danger("[owner] slaps [human_victim] with their hand. Nothing happens. Wow!"),
									span_warning("You slap [human_victim], but nothing happens. You cannot transfer your energy through metal."),
									blind_message = span_hear("You hear a slap."))
			return FALSE
		else
			to_chat(human_victim, span_warning("Pain floods your body as soon as [owner] touches you!"))
		psyonic_attack(human_victim)
		log_combat(owner, human_victim, "psyonically stunned")
		drain_mana()
		return TRUE
	else
		return FALSE

// hit proc
/datum/action/cooldown/spell/touch/psyonic/psyonic_agony/proc/psyonic_attack(mob/living/carbon/human/patient)
	patient.apply_damage(35, STAMINA) // normal stun batong
	addtimer(CALLBACK(src, PROC_REF(apply_stun_effect), patient), 2 SECONDS)

/datum/action/cooldown/spell/touch/psyonic/psyonic_agony/proc/apply_stun_effect(mob/living/carbon/human/patient)
	patient.visible_message(span_danger("[owner] slaps [patient] with his hand, sparks flying out of it!"),
							span_warning("You slap [patient], stunning him."),
							blind_message = span_hear("You hear a slap and an electrical crackling afterwards."))
	var/trait_check = HAS_TRAIT(patient, TRAIT_BATON_RESISTANCE) //var since we check it in out to_chat as well as determine stun duration
	if(!patient.IsKnockdown())
		to_chat(patient, span_warning("Your muscles seize, making you collapse[trait_check ? ", but your body quickly recovers..." : "!"]"))

	if(!trait_check)
		patient.Knockdown((cast_power/2) SECONDS)

// Stuns for a short time and forces to drop items from hands
/datum/action/cooldown/spell/pointed/psyonic/psyonic_spasm
	name = "Psyonic Spasm"
	desc = "Activate neurons in the target's mucles, briefly stunning them and forcing to drop everything in their hands. Can be cast over distance. Silent."
	button_icon = 'modular_zzplurt/modules/psyonics/icons/actions.dmi'
	button_icon_state = "spasm"
	cooldown_time = 1 SECONDS
	mana_cost = 40
	target_msg = "Your muscles spasm!"
	active_msg = "You prepare to stun a target..."

/datum/action/cooldown/spell/pointed/psyonic/psyonic_spasm/New(Target)
	. = ..()
	if(secondary_school == "Energistics")
		cast_power += 1

/datum/action/cooldown/spell/pointed/psyonic/psyonic_spasm/is_valid_target(atom/cast_on)
	if(!ishuman(cast_on))
		return FALSE
	if(issynthetic(cast_on) && secondary_school != "Psychokinesis")
		to_chat(owner, span_notice("I don't know how to work with synths."))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/psyonic/psyonic_spasm/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(cast_on.is_wearing_tinfoil_hat())
		to_chat(cast_on, span_clockred("Your tinfoil hat vibrates, protecting your brain from some kind of invisible rays!"))
		to_chat(owner, span_clockred("As soon as you try to spasm [cast_on], your own body twitches! Looks like the tinfoil hat on their head is interfering!"))
		drain_mana()
		stun(owner)
		return TRUE
	if(cast_on.can_block_magic(antimagic_flags))
		to_chat(cast_on, span_warning("Your body is assaulted with psyonic energy!"))
	else
		to_chat(cast_on, span_warning(target_msg))
	log_combat(owner, cast_on, "psyonically spasmed")
	stun(cast_on)
	drain_mana()
	return TRUE

// stun itself
/datum/action/cooldown/spell/pointed/psyonic/psyonic_spasm/proc/stun(mob/living/carbon/human/cast_on)
	cast_on.Stun(0.2 SECONDS * cast_power)

/**
 * Hypnotizes target with the braintrauma
 *
 * Conditions:
 * * 30 seconds of preparation
 * * in aggressive grab
 * * without neither the psycaster nor the victim moving
 */
/datum/action/cooldown/spell/touch/psyonic/psyonic_hypnosis
	name = "Psyonic Hypnosis"
	desc = "Implant a looping pattern into the target's head."
	button_icon = 'modular_zzplurt/modules/psyonics/icons/actions.dmi'
	button_icon_state = "hypno"
	cooldown_time = 10 SECONDS

	mana_cost = 25 // Costs little
	stamina_cost = 50 // But leaves you exhausted
	target_msg = "You get a spiking headache!"

	hand_path = /obj/item/melee/touch_attack/psyonic_mending
	draw_message = span_notice("You ready your hand to hypnotize the target.")
	drop_message = span_notice("You lower your hand.")
	can_cast_on_self = FALSE // No

/datum/action/cooldown/spell/touch/psyonic/psyonic_hypnosis/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/mendicant)
	if(ishuman(victim) && mendicant.grab_state == GRAB_AGGRESSIVE && mendicant.pulling == victim)
		var/mob/living/carbon/human/human_victim = victim
		if(human_victim.is_wearing_tinfoil_hat())
			to_chat(human_victim, span_clockred("Your tinfoil hat vibrates, protecting your brain from some kind of invisible rays!"))
			to_chat(owner, span_clockred("As soon as you touch [human_victim]'s head, you feel incredibly sleepy! Looks like the tinfoil hat on their head is interfering!"))
			drain_mana()
			addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living, Stun), 60, TRUE, TRUE), 15)
			return TRUE
		if(HAS_MIND_TRAIT(human_victim, TRAIT_UNCONVERTABLE)) // Can't penetrate mindshield
			to_chat(owner, span_warning("Victim's mind is too strong for you to penetrate."))
			return FALSE
		if(human_victim.can_block_magic(antimagic_flags))
			to_chat(human_victim, span_boldwarning("A psycaster nearby tries to hypnotize you!"))
		else
			to_chat(human_victim, span_warning(target_msg))
		owner.visible_message(span_warning("[owner] firmly grabs [victim]'s head and begins creepely staring into their eyes."),
							  span_notice("You grab [victim]'s head and begin implanting a thought into them."))
		var/player_input = tgui_input_text(mendicant, "Hypnophrase", "Input the hypnophrase", max_length = MAX_MESSAGE_LEN)
		if(!player_input)
			return FALSE
		if(do_after(mendicant, (10 - cast_power) SECONDS, human_victim, IGNORE_SLOWDOWNS, TRUE))
			hypnotize(human_victim, player_input)
		else
			to_chat(owner, span_warning("You failed to hypnotize the victim."))
		drain_mana()
		return TRUE
	else
		to_chat(owner, span_notice("You need to aggressively grab the target to hypnotize them."))
		return FALSE

/datum/action/cooldown/spell/touch/psyonic/psyonic_hypnosis/proc/hypnotize(mob/living/carbon/human/patient, hypnophrase)
	patient.cure_trauma_type(/datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_SURGERY)

	owner.log_message("hypnotised [key_name(patient)] with the phrase '[hypnophrase]'", LOG_ATTACK, color="red")

	patient.log_message("has been hypnotised by the phrase '[hypnophrase]' spoken by [key_name(owner)]", LOG_VICTIM, color="orange", log_globally = FALSE)

	addtimer(CALLBACK(patient, TYPE_PROC_REF(/mob/living/carbon, gain_trauma), /datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_SURGERY, hypnophrase), 1 SECONDS)
	addtimer(CALLBACK(patient, TYPE_PROC_REF(/mob/living, Stun), 60, TRUE, TRUE), 15)

// Blinds the target for 15 seconds on distance, max psyonics level ability
/datum/action/cooldown/spell/pointed/psyonic/psyonic_blind
	name = "Psyonic Blind"
	desc = "Interfere with the way neuron signals are transmitted in the target's eyes."
	button_icon_state = "blind"
	ranged_mousepointer = 'icons/effects/mouse_pointers/blind_target.dmi'
	cooldown_time = 1 SECONDS
	mana_cost = 60
	target_msg = "You eyes hurt!"
	active_msg = "You prepare to blind a target..."

/datum/action/cooldown/spell/pointed/psyonic/psyonic_blind/is_valid_target(atom/cast_on)
	if(!ishuman(cast_on))
		return FALSE
	else
		var/mob/living/carbon/human/victim = cast_on
		if(victim.is_blind())
			to_chat(owner, span_notice("[victim] is already blind."))
			return FALSE
	if(issynthetic(cast_on) && secondary_school != "Psychokinesis")
		to_chat(owner, span_notice("I don't know how to work with synths."))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/psyonic/psyonic_blind/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(cast_on.is_wearing_tinfoil_hat())
		to_chat(cast_on, span_clockred("Your tinfoil hat vibrates, protecting your brain from some kind of invisible rays!"))
		to_chat(owner, span_clockred("As soon as you try to blind [cast_on], you lose vision! Looks like the tinfoil hat on their head is interfering!"))
		drain_mana()
		blind(owner)
		return TRUE
	if(cast_on.can_block_magic(antimagic_flags))
		to_chat(cast_on, span_warning("Your eyes are burnt with psyonic energy!"))
	else
		to_chat(cast_on, span_warning(target_msg))
	log_combat(owner, cast_on, "psyonically blinded")
	blind(cast_on)
	drain_mana()
	return TRUE

/datum/action/cooldown/spell/pointed/psyonic/psyonic_blind/proc/blind(mob/living/carbon/human/cast_on)
	cast_on.adjust_temp_blindness( (10 + cast_power * 2) SECONDS)

#undef IS_HYPNOTIZED
