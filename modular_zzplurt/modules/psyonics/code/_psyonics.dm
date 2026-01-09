// Base classes etc

/datum/action/cooldown/spell
	// How much mana does it cost to cast a spell?
	var/mana_cost = 10
	// How much stamina does it cost to cast a spell?
	var/stamina_cost = 0
	// What do we tell the target on cast?
	var/target_msg
	// Cast power
	var/cast_power = 0
	// Secondary school, may grant extra abilities on combinations
	var/secondary_school = 0

// Item summon/conjure spells
/datum/action/cooldown/spell/conjure_item/psyonic
	delete_old = FALSE
	delete_on_failure = TRUE
	requires_hands = TRUE
	// Psyonics mainly can't be blocked, but they do show up a message to those who can
	antimagic_flags = MAGIC_RESISTANCE_MIND
	spell_requirements = NONE
	cooldown_reduction_per_rank = 0 SECONDS

/datum/action/cooldown/spell/conjure_item/psyonic/New(Target, power, additional_school)
	. = ..()
	cast_power = power
	secondary_school = additional_school

// Checking if we have enough mana
/datum/action/cooldown/spell/proc/check_for_mana()
	var/mob/living/carbon/human/caster = owner
	var/datum/quirk/psyonic/quirk_holder = caster.get_quirk(/datum/quirk/psyonic)
	if(quirk_holder && (quirk_holder.mana_level - mana_cost) >= 0)
		return TRUE
	else
		return FALSE

// Draining psycaster's mana
/datum/action/cooldown/spell/proc/drain_mana(forced = FALSE)
	var/mob/living/carbon/human/caster = owner
	var/datum/quirk/psyonic/quirk_holder = caster.get_quirk(/datum/quirk/psyonic)
	caster.adjust_stamina_loss(stamina_cost, forced = TRUE)
	if(quirk_holder && (quirk_holder.mana_level - mana_cost) >= 0)
		quirk_holder.mana_level -= mana_cost
		return TRUE
	else if (forced)
		quirk_holder.mana_level = 0
		return TRUE
	else
		return FALSE

/datum/action/cooldown/spell/conjure_item/psyonic/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE

	if(!check_for_mana())
		return FALSE
	else
		return TRUE

/datum/action/cooldown/spell/conjure_item/psyonic/cast(atom/cast_on)
	drain_mana()
	return ..()

// For spells that get applied through press of a button, aka genes
/datum/action/cooldown/spell/psyonic
	// Psyonics mainly can't be blocked, but they do show up a message to those who can
	antimagic_flags = MAGIC_RESISTANCE_MIND

	school = SCHOOL_UNSET
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	cooldown_reduction_per_rank = 0 SECONDS

/datum/action/cooldown/spell/psyonic/New(Target, power, additional_school)
	. = ..()
	cast_power = power
	secondary_school = additional_school

/datum/action/cooldown/spell/psyonic/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE

	if(!check_for_mana())
		return FALSE
	else
		return TRUE

// Shooty spells
/datum/action/cooldown/spell/pointed/projectile/psyonic
	// Psyonics mainly can't be blocked, but they do show up a message to those who can
	antimagic_flags = MAGIC_RESISTANCE_MIND

	school = SCHOOL_UNSET
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	cooldown_reduction_per_rank = 0 SECONDS

/datum/action/cooldown/spell/pointed/projectile/psyonic/New(Target, power, additional_school)
	. = ..()
	cast_power = power
	secondary_school = additional_school

/datum/action/cooldown/spell/pointed/projectile/psyonic/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE

	if(!check_for_mana())
		return FALSE
	else
		return TRUE

// Targeted spells, aka the caster selects a target on long range
/datum/action/cooldown/spell/pointed/psyonic
	// Psyonics mainly can't be blocked, but they do show up a message to those who can
	antimagic_flags = MAGIC_RESISTANCE_MIND
	school = SCHOOL_UNSET
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	cooldown_reduction_per_rank = 0 SECONDS

/datum/action/cooldown/spell/pointed/psyonic/New(Target, power, additional_school)
	. = ..()
	cast_power = power
	secondary_school = additional_school

/datum/action/cooldown/spell/pointed/psyonic/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE

	if(!check_for_mana())
		return FALSE
	else
		return TRUE

// Spells that you gotta touch something with
/datum/action/cooldown/spell/touch/psyonic
	// Psyonics mainly can't be blocked, but they do show up a message to those who can
	antimagic_flags = MAGIC_RESISTANCE_MIND
	school = SCHOOL_UNSET
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

/datum/action/cooldown/spell/touch/psyonic/New(Target, power, additional_school)
	. = ..()
	cast_power = power
	secondary_school = additional_school

/datum/action/cooldown/spell/touch/psyonic/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE

	if(!check_for_mana())
		return FALSE
	else
		return TRUE

/datum/action/cooldown/spell/touch/psyonic/create_hand(mob/living/carbon/cast_on)
	. = ..()
	if(!.)
		return .
	var/obj/item/bodypart/transfer_limb = cast_on.get_active_hand()
	if(IS_ROBOTIC_LIMB(transfer_limb))
		to_chat(cast_on, span_notice("You fail to channel your psyonic powers through your inorganic hand."))
		return FALSE

	return TRUE

/particles/droplets/psyonic
	icon = 'icons/effects/particles/generic.dmi'
	icon_state = list("dot"=2,"drop"=1)
	width = 32
	height = 36
	count = 20
	spawning = 0.2
	lifespan = 1.5 SECONDS
	fade = 0.5 SECONDS
	color = "#00a2ff"
	position = generator(GEN_BOX, list(-9,-9,0), list(9,18,0), NORMAL_RAND)
	scale = generator(GEN_VECTOR, list(0.9,0.9), list(1.1,1.1), NORMAL_RAND)
	gravity = list(0, 0.95)

// Checking if the human has the psyonics quirk
/mob/living/carbon/human/proc/ispsyonic()
	if(has_quirk(/datum/quirk/psyonic))
		return TRUE
	return FALSE
