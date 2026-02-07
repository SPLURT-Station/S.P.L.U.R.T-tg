/// Amount of blood taken from a target on bite
#define BLOODFLEDGE_DRAIN_AMT 50
/// Base amount of time to bite a target before adjustments
#define BLOODFLEDGE_DRAIN_TIME 30 // Three seconds
/// Cooldown for the bite ability
#define BLOODFLEDGE_COOLDOWN_BITE 60 // Six seconds
/// Cooldown for the revive ability
#define BLOODFLEDGE_COOLDOWN_REVIVE 3000 // Five minutes
/// Cooldown for the analyze ability
#define BLOODFLEDGE_COOLDOWN_ANALYZE 50 // Five seconds
/// How much blood can be held after biting
#define BLOODFLEDGE_BANK_CAPACITY (BLOODFLEDGE_DRAIN_AMT * 2)
/// How much damage is healed in a coffin
#define BLOODFLEDGE_HEAL_AMT -2
/// Amount to increase healing speed per unique blood DNA
#define BLOODFLEDGE_HEAL_AMT_BONUS -0.05
/// How much to multiply healing by while weakened by desperation
#define BLOODFLEDGE_HEAL_PENALTY_DESPERATE 0.5
/// List of traits inherent to bloodfledges
#define BLOODFLEDGE_TRAITS list(TRAIT_NOTHIRST, TRAIT_DRINKS_BLOOD, TRAIT_NO_BLOOD_REGEN)
/// Delay between activating revive and actually getting up
#define BLOODFLEDGE_REVIVE_DELAY 200
/// Minimum amount of blood required for revivals
#define BLOODFLEDGE_REVIVE_MINIMUM_VOLUME BLOOD_VOLUME_OKAY
/// Amount of blood volume the target is left with after reviving
#define BLOODFLEDGE_REVIVE_AFTER_BLOOD_VOLUME BLOODFLEDGE_REVIVE_MINIMUM_VOLUME
/// Default description for revive ability
#define BLOODFLEDGE_REVIVE_DESC_BASE /datum/action/cooldown/bloodfledge/revive::desc
/// First description addendum for revive ability
#define BLOODFLEDGE_REVIVE_DESC_1 "<br><br>Must first be unlocked by obtaining [BLOODFLEDGE_DNA_BONUS_1] unique blood samples!"
/// Second description addendum for revive ability
#define BLOODFLEDGE_REVIVE_DESC_2 "<br><br>Currently requires a closed coffin. Upgraded at [BLOODFLEDGE_DNA_BONUS_2] unique blood samples."
/// Third description addendum for revive ability
#define BLOODFLEDGE_REVIVE_DESC_3 "<br><br>Fully upgraded!"
/// Blood volume threshold at which trait owner enters desperate mode
#define BLOODFLEDGE_DESPERATE_THRESHOLD_START BLOOD_VOLUME_SAFE
/// Blood volume threshold at which desperation is cleared
#define BLOODFLEDGE_DESPERATE_THRESHOLD_END BLOOD_VOLUME_NORMAL
/// Amount of nanites to be transferred when biting a target
#define BLOODFLEDGE_NANITE_TRANSFER_AMOUNT 5 // Similar to nanite sting
/// Minimum amount of blood required to process blood loss
#define BLOODFLEDGE_BLOODLOSS_LIMIT BLOODFLEDGE_DESPERATE_THRESHOLD_START
/// Amount to reduce blood loss by per unique blood DNA
#define BLOODFLEDGE_BLOODLOSS_REDUCTION 0.01
/// Intensity multiplier applied to normal Blood Deficiency rate
#define BLOODFLEDGE_BLOODLOSS_RATE_MOD 0.5
/// Number of unique blood DNA for first bonus
#define BLOODFLEDGE_DNA_BONUS_1 3
/// Number of unique DNA for second bonus
#define BLOODFLEDGE_DNA_BONUS_2 6

/// Messages used when the holder runs low on blood
#define BLOODFLEDGE_DESPERATE_MESSAGES pick(\
	"You feel the edges of your mind fraying, a dark hunger nudging them inward...",\
	"Distant memories of salt and iron press at the tip of your tongue...",\
	"A crimson memory washes over your mind, mapping a single, simple need...",\
	"The control you held slips in small increments; the scent of blood is a clear, steady pull...",\
	)
/// Warning message for non-organic holders
#define BLOODFLEDGE_WARNING_NONORGANIC "As a non-organic lifeform, your structure is only able to support limited sanguine abilities! Regeneration and revival are not possible."
/// Warning message for Hemophages
#define BLOODFLEDGE_WARNING_HEMOPHAGE "As a Hemophage already in possession of your tumor, you've neglected to learn some redundant bloodfledge abilities."

// Special testing-only overrides
#ifdef TESTING
#undef BLOODFLEDGE_DRAIN_TIME
#undef BLOODFLEDGE_COOLDOWN_BITE
#undef BLOODFLEDGE_COOLDOWN_REVIVE
#undef BLOODFLEDGE_COOLDOWN_ANALYZE
#undef BLOODFLEDGE_REVIVE_DELAY
#undef BLOODFLEDGE_DNA_BONUS_1
#undef BLOODFLEDGE_DNA_BONUS_2
#define BLOODFLEDGE_DRAIN_TIME 10
#define BLOODFLEDGE_COOLDOWN_BITE 10
#define BLOODFLEDGE_COOLDOWN_REVIVE 10
#define BLOODFLEDGE_COOLDOWN_ANALYZE 10
#define BLOODFLEDGE_REVIVE_DELAY 10
#define BLOODFLEDGE_DNA_BONUS_1 1
#define BLOODFLEDGE_DNA_BONUS_2 2
#endif

/datum/quirk/item_quirk/bloodfledge
	name = "Bloodfledge"
	desc = "You are apprentice sanguine sorcerer endowed with vampiric power similar to a Hemophage. While not truly undead, many of the same conditions still apply."
	value = 4
	gain_text = span_notice("A sanguine blessing flows through your body, granting it new strength.")
	lose_text = span_notice("The sanguine blessing fades away...")
	medical_record_text = "Patient appears to possess a paranormal connection to otherworldly forces."
	mob_trait = TRAIT_BLOODFLEDGE
	hardcore_value = -2
	icon = FA_ICON_CHAMPAGNE_GLASSES

	/// Is the holder currently desperate for blood?
	var/is_desperate = FALSE
	/// Amount of healing applied during coffin use
	var/heal_amount = BLOODFLEDGE_HEAL_AMT
	/// List of unique DNA strings that have been successfully fed from
	var/list/bitten_targets
	/// Amount of blood lost per process before changes
	var/bloodloss_amount = BLOOD_DEFICIENCY_MODIFIER

// Check if this quirk is valid for the species
/datum/quirk/item_quirk/bloodfledge/is_species_appropriate(datum/species/mob_species)
	// Define species traits
	var/datum/species_traits = GLOB.species_prototypes[mob_species].inherent_traits

	// Check for no blood
	if(TRAIT_NOBLOOD in species_traits)
		return FALSE

	// Return default
	return ..()

/datum/quirk/item_quirk/bloodfledge/add(client/client_source)
	// Define quirk mob
	var/mob/living/carbon/human/quirk_mob = quirk_holder

	// Define if antagonists are enabled
	var/storyteller_antags = (SSgamemode?.storyteller?.storyteller_type & STORYTELLER_TYPE_ANTAGS)

	// Check if antagonists are disabled for this round
	if(!storyteller_antags)
		// Register examine text
		// Could be used to reveal imposter crew
		RegisterSignal(quirk_holder, COMSIG_ATOM_EXAMINE, PROC_REF(quirk_examine_bloodfledge))

	// Register wooden stake interaction
	RegisterSignal(quirk_holder, COMSIG_MOB_STAKED, PROC_REF(on_staked))

	// Add quirk language
	quirk_mob.grant_language(/datum/language/vampiric, ALL, LANGUAGE_QUIRK)

	// Add quirk traits
	quirk_mob.add_traits(BLOODFLEDGE_TRAITS, TRAIT_BLOODFLEDGE)

	// Add a memory and inform them of their blood type
	quirk_mob.mind.add_memory(/datum/memory/key/quirk_bloodfledge, blood_type = quirk_mob.dna.blood_type)
	to_chat(quirk_mob, "You remember that your blood type is [quirk_mob.dna.blood_type]")

	// Add profane penalties
	quirk_holder.AddElementTrait(TRAIT_CHAPEL_WEAKNESS, TRAIT_BLOODFLEDGE, /datum/element/chapel_weakness)
	quirk_holder.AddElementTrait(TRAIT_HOLYWATER_WEAKNESS, TRAIT_BLOODFLEDGE, /datum/element/holywater_weakness)

	/**
	 * Hemophage Filter
	 * Anything past this point should NOT be used by Hemophage hybrids
	 */
	if(ishemophage(quirk_mob))
		// Ignore proceeding code
		return

	// Register blood consumption interaction
	RegisterSignal(quirk_holder, COMSIG_REAGENT_ADD_BLOOD, PROC_REF(on_consume_blood))

	// Check for organic biotype
	if(quirk_mob.mob_biotypes & MOB_ORGANIC)
		// Register coffin interaction
		RegisterSignal(quirk_holder, COMSIG_ENTER_COFFIN, PROC_REF(on_enter_coffin))

	// Register changes to blood
	RegisterSignal(quirk_holder, COMSIG_HUMAN_ON_HANDLE_BLOOD, PROC_REF(on_handle_blood))

	// Set skin tone, if possible
	if(HAS_TRAIT(quirk_mob, TRAIT_USES_SKINTONES) && !(quirk_mob.skin_tone != initial(quirk_mob.skin_tone)))
		quirk_mob.skin_tone = "albino"
		quirk_mob.dna.update_ui_block(/datum/dna_block/identity/skin_tone)

	// Add vampiric biotype
	quirk_mob.mob_biotypes |= MOB_VAMPIRIC

	// Set starting bloodloss amount
	bloodloss_amount = (quirk_mob.dna?.species?.blood_deficiency_drain_rate * BLOODFLEDGE_BLOODLOSS_RATE_MOD)

/datum/quirk/item_quirk/bloodfledge/post_add()
	. = ..()

	// Debug output
	#ifdef TESTING
	to_chat(quirk_holder, span_boldwarning("TESTING: You are currently using Bloodfledge in <b>TESTING MODE</b>. Functionality may differ."))
	#endif

	// Define quirk mob
	var/mob/living/carbon/human/quirk_mob = quirk_holder

	// Teach how to make the Hemorrhagic Sanguinizer
	quirk_mob.mind?.teach_crafting_recipe(/datum/crafting_recipe/emag_bloodfledge)

	// Redundant Hemophage check
	// Placed here to preserve ability icon ordering
	if(!ishemophage(quirk_mob))
		// Define and grant ability Bite
		var/datum/action/cooldown/bloodfledge/bite/act_bite = new
		act_bite.Grant(quirk_mob)

	// Check for non-organic mob
	// Robotic and other mobs have technical issues with adjusting damage
	if(!(quirk_mob.mob_biotypes & MOB_ORGANIC))
		// Warn user
		to_chat(quirk_mob, span_boldwarning(BLOODFLEDGE_WARNING_NONORGANIC))

	// User is organic
	else
		// Define and grant ability Revive
		var/datum/action/cooldown/bloodfledge/revive/act_revive = new
		act_revive.Grant(quirk_mob)

		// Temporarily disable the ability
		// This is re-enabled by progression system
		act_revive.disable()

		// Add first description addendum
		act_revive.desc = BLOODFLEDGE_REVIVE_DESC_BASE + BLOODFLEDGE_REVIVE_DESC_1

		// Update button description
		act_revive.build_all_button_icons(UPDATE_BUTTON_NAME)

	// Define and grant ability Analyze
	var/datum/action/cooldown/bloodfledge/analyze/act_analyze = new
	act_analyze.Grant(quirk_mob)

	/**
	 * Hemophage Filter
	 * Anything past this point should NOT be used by Hemophage hybrids
	 */
	if(ishemophage(quirk_mob))
		// Warn user about feature overlap
		to_chat(quirk_mob, span_boldwarning(BLOODFLEDGE_WARNING_HEMOPHAGE))

		// Ignore remaining features
		return

	// Define owner tongue
	var/obj/item/organ/tongue/target_tongue = quirk_holder.get_organ_slot(ORGAN_SLOT_TONGUE)

	// Check if tongue exists
	if(target_tongue)
		// Force preference for bloody food
		target_tongue.disliked_foodtypes &= ~BLOODY
		target_tongue.liked_foodtypes |= BLOODY

// Processing is currently only used for coffin healing
/datum/quirk/item_quirk/bloodfledge/process(seconds_per_tick)
	// Define potential coffin
	var/quirk_coffin = quirk_holder.loc

	// Check if the current area is a coffin
	if(!istype(quirk_coffin, /obj/structure/closet/crate/coffin))
		// Warn user
		to_chat(quirk_holder, span_warning("Your connection to the Geometer is broken upon leaving the coffin!"))

		// Stop processing and return
		STOP_PROCESSING(SSquirks, src)
		return

	// Define quirk mob
	var/mob/living/carbon/human/quirk_mob = quirk_holder

	// Quirk mob must be injured
	if(quirk_mob.health >= quirk_mob.maxHealth)
		// Warn user
		to_chat(quirk_mob, span_notice("[quirk_coffin] does nothing more to help you, as your body is fully mended."))

		// Stop processing and return
		STOP_PROCESSING(SSquirks, src)
		return

	// Check if blood volume is high enough
	if(quirk_mob.blood_volume <= BLOODFLEDGE_DESPERATE_THRESHOLD_START)
		// Warn user
		to_chat(quirk_mob, span_warning("[quirk_coffin] requires blood to operate, which you are currently lacking. Your connection to the Geometer fades once again."))

		// Stop processing and return
		STOP_PROCESSING(SSquirks, src)
		return

	// Define initial health
	var/health_start = quirk_mob.health

	// Define health needing updates
	var/need_mob_update = FALSE

	// Queue healing compatible damage types
	need_mob_update += quirk_holder.adjust_brute_loss(heal_amount, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
	need_mob_update += quirk_holder.adjust_fire_loss(heal_amount, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
	need_mob_update += quirk_holder.adjust_tox_loss(heal_amount, updating_health = FALSE, required_biotype = MOB_ORGANIC, forced = TRUE)
	need_mob_update += quirk_holder.adjust_oxy_loss(heal_amount, updating_health = FALSE, required_biotype = MOB_ORGANIC)

	// Check if healing will be applied
	if(need_mob_update)
		// Update health
		quirk_holder.updatehealth()

	// No healing will occur
	else
		// Warn user
		to_chat(quirk_mob, span_warning("[quirk_coffin] cannot mend any more damage to your body."))

		// Stop processing and return
		STOP_PROCESSING(SSquirks, src)
		return

	// Determine healed amount
	var/health_restored = quirk_mob.health - health_start

	// Remove a resource as compensation for healing
	// Amount is equal to healing done
	quirk_mob.blood_volume -= (health_restored*-1)


/datum/quirk/item_quirk/bloodfledge/remove()
	// Define quirk mob
	var/mob/living/carbon/human/quirk_mob = quirk_holder

	if(QDELETED(quirk_mob))
		return

	// Remove quirk ability action datums
	var/datum/action/cooldown/bloodfledge/revive/act_revive = locate() in quirk_mob.actions
	act_revive?.Remove(quirk_mob)

	// Remove quirk language
	quirk_mob.remove_language(/datum/language/vampiric, ALL, LANGUAGE_QUIRK)

	// Unregister quirk signals
	UnregisterSignal(quirk_holder, COMSIG_ATOM_EXAMINE)
	UnregisterSignal(quirk_holder, COMSIG_MOB_STAKED)
	UnregisterSignal(quirk_holder, COMSIG_REAGENT_ADD_BLOOD)
	UnregisterSignal(quirk_holder, COMSIG_ENTER_COFFIN)
	UnregisterSignal(quirk_holder, COMSIG_HUMAN_ON_HANDLE_BLOOD)

	// Remove quirk traits
	quirk_mob.remove_traits(BLOODFLEDGE_TRAITS, TRAIT_BLOODFLEDGE)
	//REMOVE_TRAIT(quirk_mob, TRAIT_NOTHIRST, ROUNDSTART_TRAIT)

	// Remove Analyze ability action datum
	var/datum/action/cooldown/bloodfledge/analyze/act_analyze = locate() in quirk_mob.actions
	act_analyze?.Remove(quirk_mob)

	// Remove quirk-issued profane penalties
	REMOVE_TRAIT(quirk_holder, TRAIT_CHAPEL_WEAKNESS, TRAIT_BLOODFLEDGE)
	REMOVE_TRAIT(quirk_holder, TRAIT_HOLYWATER_WEAKNESS, TRAIT_BLOODFLEDGE)

	/**
	 * Hemophage Filter
	 * Anything past this point should NOT be used by Hemophage hybrids
	 */
	if(ishemophage(quirk_mob))
		return

	// Remove bite ability action datum
	var/datum/action/cooldown/bloodfledge/bite/act_bite = locate() in quirk_mob.actions
	act_bite?.Remove(quirk_mob)

	// Check if species should still be vampiric
	if(!(quirk_mob.dna?.species?.inherent_biotypes & MOB_VAMPIRIC))
		// Remove vampiric biotype
		quirk_mob.mob_biotypes -= MOB_VAMPIRIC

	// Remove desperation
	remove_desperate()

/datum/quirk/item_quirk/bloodfledge/add_unique(client/client_source)
	// Define quirk mob
	var/mob/living/carbon/human/quirk_mob = quirk_holder

	// Create vampire ID card
	var/obj/item/card/id/advanced/quirk/bloodfledge/id_vampire = new(get_turf(quirk_mob))

	// Define default card type name
	var/card_name_type = "Blood"

	// Define possible blood prefix
	var/blood_prefix = quirk_mob.get_blood_prefix()

	// Check if species blood prefix was returned
	if(blood_prefix)
		// Set new card type
		card_name_type = blood_prefix

	// Define operative alias
	var/operative_alias = client_source?.prefs?.read_preference(/datum/preference/name/operative_alias)
	var/datum/preference/name/operative_alias/pref_operative_alias = GLOB.preference_entries[/datum/preference/name/operative_alias]

	// Update card information
	// Try to use operative name
	if(operative_alias && pref_operative_alias.is_accessible(client_source?.prefs))
		id_vampire.registered_name = operative_alias

	// Fallback to default name
	else
		id_vampire.registered_name = quirk_mob.real_name

	// Attempt to set chronological age
	if(quirk_mob.chrono_age)
		id_vampire.registered_age = quirk_mob.chrono_age

	// Set assignment overrides
	id_vampire.assignment = "[card_name_type]fledge"
	id_vampire.trim?.assignment = "[card_name_type]fledge"

	// Update label
	id_vampire.update_label()

	// Check for bank account
	if(quirk_mob.account_id)
		// Define bank account
		var/datum/bank_account/account = SSeconomy.bank_accounts_by_id["[quirk_mob.account_id]"]

		// Add to cards list
		account.bank_cards += src

		// Assign account
		id_vampire.registered_account = account

	// Give ID card
	give_item_to_holder(id_vampire,
		list(
			LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
			LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
			LOCATION_BACKPACK = ITEM_SLOT_BACK,
			LOCATION_HANDS = ITEM_SLOT_HANDS,
		)
	)

/**
 * Special examine text for Bloodfledges
 * * Displays hunger or blood volume level notices
 * * Indicates that the holder has a usable revive ability
 * * Indicates if the holder is currently desperate for blood
*/
/datum/quirk/item_quirk/bloodfledge/proc/quirk_examine_bloodfledge(atom/examine_target, mob/living/carbon/human/examiner, list/examine_list)
	SIGNAL_HANDLER

	// Check if human examiner exists
	if(!istype(examiner))
		return

	// Check if examiner is dumb
	if(HAS_TRAIT(examiner, TRAIT_DUMB))
		// Return with no effects
		return

	// Define quirk mob
	var/mob/living/carbon/human/quirk_mob = quirk_holder

	// Define pronouns
	var/holder_they = quirk_holder.p_They()
	var/holder_their = quirk_holder.p_Their()
	var/holder_are = quirk_holder.p_are()

	// Check if dead
	if((quirk_holder.stat >= DEAD))
		// Check if revival is possible
		// This is not a comprehensive check of conditions
		if(quirk_holder.can_be_revived())
			// Add potential revival text
			examine_list += span_info("[holder_their] body radiates an unnatural energy, as though [quirk_holder.p_they()] could spring to life at any moment...")

	// Define hunger texts
	var/examine_hunger_public
	var/examine_hunger_secret

	// Check blood value levels (based on blood.dm)
	switch(quirk_mob.blood_volume)
		// Lethal dosage of blood
		if(BLOOD_VOLUME_EXCESS to INFINITY)
			examine_hunger_secret = "[holder_they] [quirk_holder.p_have()] committed a fatal sin of gluttony!"

		// Too much
		if(BLOOD_VOLUME_MAXIMUM to BLOOD_VOLUME_EXCESS)
			examine_hunger_secret = "[holder_they] [quirk_holder.p_have()] taken more than [quirk_holder.p_their()] share of blood!"

		// Not enough, but safe
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			examine_hunger_secret = "[holder_their] aura is weaker than normal."

		// Not enough, becoming dangerous
		if(BLOOD_VOLUME_RISKY to BLOOD_VOLUME_OKAY)
			examine_hunger_secret = "[holder_their] bloodthirst is obvious even at a glance!"
			examine_hunger_public = "[holder_they] seem[quirk_holder.p_s()] on edge from something."

		// Dangerously low
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_RISKY)
			examine_hunger_secret = "[holder_they] [holder_are] desperately blood starved!"
			examine_hunger_public = "[holder_they] [holder_are] radiating an aura of frenzied desperation."

		// Critcally low, near death
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			examine_hunger_secret = "[holder_they] [holder_are] soon to be reclaimed by the sanguine curse!"

		// Instant death
		if(-INFINITY to BLOOD_VOLUME_SURVIVE)
			examine_hunger_secret = "[holder_they] [holder_are] a desperate fool."

		// Invalid blood value
		else
			// Return with no message
			return

	// Check if examiner shares the quirk
	if(isbloodfledge(examiner))
		// Add detection text
		examine_list += span_info("[holder_their] hunger makes it easy to identify [quirk_holder.p_them()] as a fellow sanguine!")

		// Add hunger text
		examine_list += span_cult(examine_hunger_secret)

		// Check if currently desperate
		if(is_desperate)
			// Add desperation text
			examine_list += span_warning("[holder_they] radiate[quirk_holder.p_s()] an aura of bloodthirsty desperation.")

	// Check if public hunger text exists
	else
		// Add hunger text
		examine_list += span_warning(examine_hunger_public)

/**
 * Coffin check for Bloodfledges. Enables quirk processing if all conditions pass.
 *
 * Requires the following
 * * Organic mob biotype
 * * No HOLY anti-magic
 * * No garlic reagent
 * * No stake embedded
*/
/datum/quirk/item_quirk/bloodfledge/proc/on_enter_coffin(mob/living/carbon/target, obj/structure/closet/crate/coffin/coffin, mob/living/carbon/user)
	SIGNAL_HANDLER

	// Check for organic user
	if(!(user.mob_biotypes & MOB_ORGANIC))
		// Warn user and return
		to_chat(quirk_holder, span_warning("Your body don't respond to [coffin]'s sanguine connection! Regeneration will not be possible."))
		return

	// Check for holy anti-magic
	if(user.can_block_magic(MAGIC_RESISTANCE_HOLY))
		// Warn user and return
		to_chat(quirk_holder, span_warning("[coffin] fails to form a connection with your body amidst the strong magical interference!!"))
		return

	// Check for garlic
	if(user.has_reagent(/datum/reagent/consumable/garlic, 5))
		// Warn user and return
		to_chat(quirk_holder, span_warning("The Allium Sativum in your system interferes with your regeneration!"))
		return

	// Check for stake
	if(user.am_staked())
		// Warn user and return
		to_chat(quirk_holder, span_warning("Your body cannot regenerate while impaled with a stake!"))
		return

	// User is allowed to heal!

	// Alert user
	to_chat(quirk_holder, span_good("[coffin] begins to mend your body!"))

	// Start processing
	START_PROCESSING(SSquirks, src)

/**
 * Staked interaction for Bloodfledges
 * * Causes instant death if the target is unconscious
 * * Warns normally if the target is conscious
*/
/datum/quirk/item_quirk/bloodfledge/proc/on_staked(atom/target, forced)
	SIGNAL_HANDLER

	// Check if unconscious
	if(quirk_holder.IsSleeping() || quirk_holder.stat >= UNCONSCIOUS)
		// Warn the user
		to_chat(target, span_userdanger("You have been staked while unconscious!"))

		// Kill the user
		quirk_holder.death()

		// Log the death
		quirk_holder.investigate_log("Died as a bloodfledge from staking.", INVESTIGATE_DEATHS)

		// Do nothing else
		return

	// User is conscious
	// Warn the user of staking
	to_chat(target, span_userdanger("You have been staked! Your powers are useless while it remains in place."))
	target.balloon_alert(target, "you have been staked!")

/**
 * Blood nourishment for Bloodfledges
 * * Checks if the blood was synthesized or from an invalid mob
 * * Checks if the owner tried to drink their own blood
*/
/datum/quirk/item_quirk/bloodfledge/proc/on_consume_blood(mob/living/target, datum/reagent/blood/handled_reagent, amount, data)
	SIGNAL_HANDLER

	// Check for data
	if(!data)
		// Log warning and return
		log_game("[quirk_holder] attempted to ingest blood that had no data!")
		return

	// Define blood DNA
	var/blood_DNA = data["blood_DNA"]

	// Check for valid DNA
	if(!blood_DNA)
		// Warn user
		to_chat(quirk_holder, span_warning("Something about that blood tasted terribly wrong..."))

		// Add mood penalty
		quirk_holder.add_mood_event(QMOOD_BFLED_DRANK_BLOOD_FAKE, /datum/mood_event/bloodfledge/drankblood/blood_fake)

		// End here
		return

	// Debug output
	#ifdef TESTING
	to_chat(quirk_holder, span_boldwarning("TESTING: Ingested DNA is: [blood_DNA]"))
	#endif

	// Define quirk mob
	var/mob/living/carbon/human/quirk_mob = quirk_holder

	// Define quirk mob's DNA
	var/quirk_mob_dna = quirk_mob?.dna?.unique_enzymes

	// Debug output
	#ifdef TESTING
	to_chat(quirk_holder, span_boldwarning("TESTING: Your DNA is: [quirk_mob_dna]"))
	#endif

	// Check for own blood
	if(blood_DNA == quirk_mob_dna)
		// Warn user
		to_chat(quirk_holder, span_warning("You should know better than to drink your own blood..."))

		// Add mood penalty
		quirk_holder.add_mood_event(QMOOD_BFLED_DRANK_BLOOD_SELF, /datum/mood_event/bloodfledge/drankblood/blood_self)

		// End here
		return

	// Add new blood DNA to list
	add_dna(blood_DNA)

	// Hemophage filter
	if(ishemophage(quirk_mob))
		// Ignore proceeding code
		return

	// Recheck if desperation should apply
	recheck_desperate()

/**
 * Blood update signal handler for Bloodfledges
 * * Checks if blood volume has hit certain thresholds
 * * Sets desperate to enabled or disabled based on threshold
*/
/datum/quirk/item_quirk/bloodfledge/proc/on_handle_blood(datum/source, seconds_per_tick, times_fired)
	SIGNAL_HANDLER

	// Check if bloodloss is low enough
	if(!bloodloss_amount)
		// Alert user
		to_chat(quirk_holder, span_boldnicegreen("The Geomancer recognizes you as a devoted follower. The blood tithe is no longer required!"))

		// Stop handling blood
		UnregisterSignal(quirk_holder, COMSIG_HUMAN_ON_HANDLE_BLOOD)  // May conflict with Blood Deficiency

		// Ignore remaining proc
		return

	// Check if currently conscious
	// Desperation is less important if so
	if(quirk_holder.stat != CONSCIOUS)
		return

	// Define current blood volume
	var/target_volume = quirk_holder.blood_volume

	// Check if blood volume is high enough
	if(target_volume > BLOODFLEDGE_BLOODLOSS_LIMIT)
		// Reduce blood volume by upkeep cost amount
		quirk_holder.blood_volume = max(BLOODFLEDGE_BLOODLOSS_LIMIT, quirk_holder.blood_volume - bloodloss_amount * seconds_per_tick)

		// Reset variable
		target_volume = quirk_holder.blood_volume

	// Handle changes to the desperation state
	recheck_desperate()

/// Proc for assigning or unassigning the desperation state
/datum/quirk/item_quirk/bloodfledge/proc/recheck_desperate()
	// Check if not already desperate
	if(!is_desperate)
		// Check if blood volume is below threshold
		if(quirk_holder.blood_volume <= BLOODFLEDGE_DESPERATE_THRESHOLD_START)
			// Start effect
			set_desperate()

	// Target is already desperate
	else
		// Check if blood volume is above threshold
		if(quirk_holder.blood_volume >= BLOODFLEDGE_DESPERATE_THRESHOLD_END)
			// End effect
			remove_desperate()

/**
 * Proc for adding new DNA to the remembered list.
 * When DNA count is high enough, grant special bonuses.
 */
/datum/quirk/item_quirk/bloodfledge/proc/add_dna(blood_DNA)
	// Ignore this while testing
	#ifndef TESTING
	// Check if DNA was already present in list
	if(blood_DNA in bitten_targets)
		// Do nothing
		return
	#endif

	// Add new DNA to list
	LAZYADD(bitten_targets, blood_DNA)

	// Define number of unique targets
	var/bitten_count = length(bitten_targets)

	// Debug output
	#ifdef TESTING
	to_chat(quirk_holder, span_boldwarning("TESTING: You have consumed [bitten_count] unique DNA."))
	#endif

	// Reduce blood loss per unique DNA, down to 0
	bloodloss_amount = max(0, (bloodloss_amount - BLOODFLEDGE_BLOODLOSS_REDUCTION))

	// Proceeding code is reliant on having revive and healing functions
	// Non-organic holders do not have this functions, and can be skipped
	if(!(quirk_holder.mob_biotypes & MOB_ORGANIC))
		// Debug output
		#ifdef TESTING
		to_chat(quirk_holder, span_boldwarning("TESTING: You are non-organic, and cannot benefit from most progression mechanics.\nCurrent bloodloss: [bloodloss_amount]."))
		#endif

		// End early
		return

	// Slightly increase healing speed per unique DNA
	// Capped at a 50% bonus after ten unique targets
	heal_amount = max((BLOODFLEDGE_HEAL_AMT*1.5), (heal_amount + BLOODFLEDGE_HEAL_AMT_BONUS))

	// Debug output
	#ifdef TESTING
	to_chat(quirk_holder, span_boldwarning("TESTING: Bloodfledge bonuses\nCurrent bloodloss: [bloodloss_amount].\nCurrent heal speed: [heal_amount]."))
	#endif

	// Check DNA count for unique bonuses
	switch(bitten_count)
		// Bonus 1: Enable revive ability
		if(BLOODFLEDGE_DNA_BONUS_1)
			// Alert user
			to_chat(quirk_holder, span_boldnicegreen("Your connection to the Geomancer grows stronger. Self-revival is now possible."))

			// Enable self-revive ability
			var/datum/action/cooldown/bloodfledge/revive/act_revive = locate() in quirk_holder.actions
			act_revive?.enable()

			// Set second description addendum
			act_revive?.desc = BLOODFLEDGE_REVIVE_DESC_BASE + BLOODFLEDGE_REVIVE_DESC_2

			// Update button description
			act_revive?.build_all_button_icons(UPDATE_BUTTON_NAME)

		// Bonus 2: Remove coffin requirement for revives
		if(BLOODFLEDGE_DNA_BONUS_2)
			// Alert user
			to_chat(quirk_holder, span_boldnicegreen("You become aware of the station's leylines. A closed coffin is no longer required to self-revive!"))

			// Remove coffin requirement from self-revive
			var/datum/action/cooldown/bloodfledge/revive/act_revive = locate() in quirk_holder.actions
			act_revive?.require_coffin = FALSE

			// Set third description addendum
			act_revive?.desc = BLOODFLEDGE_REVIVE_DESC_BASE + BLOODFLEDGE_REVIVE_DESC_3

			// Update button description
			act_revive?.build_all_button_icons(UPDATE_BUTTON_NAME)
//
// Bloodfledge actions
//

// Action: Base
/datum/action/cooldown/bloodfledge
	name = "Broken Bloodfledge Ability"
	desc = "You shouldn't be seeing this!"
	background_icon = 'modular_zubbers/icons/mob/actions/bloodsucker.dmi'
	background_icon_state = "vamp_power_off"
	button_icon = 'modular_zubbers/icons/mob/actions/bloodsucker.dmi'
	button_icon_state = "power_feed"
	buttontooltipstyle = "cult"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED | AB_CHECK_PHASED

/**
 * Check if Bloodfledge power is allowed to be used
 *
 * Requires the following:
 * * No HOLY anti-magic
 * * No garlic reagent
 * * No stake embedded
 * * Not just a brain
*/
/datum/action/cooldown/bloodfledge/proc/can_use(mob/living/carbon/action_owner)
	// Check for deleted owner
	if(QDELETED(owner))
		return FALSE

	// Check if action owner exists
	if(!istype(action_owner))
		return FALSE

	// Check for holiness
	if(owner.can_block_magic(MAGIC_RESISTANCE_HOLY))
		// Warn user and return
		to_chat(owner, span_warning("A holy force prevents you from using your powers!"))
		owner.balloon_alert(owner, "holy interference!")
		return FALSE

	// Check for garlic
	if(action_owner.has_reagent(/datum/reagent/consumable/garlic, 5))
		// Warn user and return
		to_chat(owner, span_warning("The Allium Sativum in your system is stifling your powers!"))
		owner.balloon_alert(owner, "garlic interference!")
		return FALSE

	// Check for stake
	if(action_owner.am_staked())
		to_chat(owner, span_warning("Your powers are useless while you have a stake in your chest!"))
		owner.balloon_alert(owner, "staked!")
		return FALSE

	// Check if just a brain
	if(isbrain(owner))
		to_chat(owner, span_warning("You think extra hard about how you can't do this right now!"))
		owner.balloon_alert(owner, "just a brain!")
		return FALSE

	// Action can be used
	return TRUE

// Action: Bite
/datum/action/cooldown/bloodfledge/bite
	name = "Fledgling Bite"
	desc = "Sink your fangs into the person you are grabbing, and attempt to drink their blood."
	button_icon_state = "power_feed"
	cooldown_time = BLOODFLEDGE_COOLDOWN_BITE

	/// How long it takes to bite a target
	var/time_interact = BLOODFLEDGE_DRAIN_TIME

	/// Reagent holder, used to change reaction type
	var/datum/reagents/blood_bank

// Corrupted tongue variant
/datum/action/cooldown/bloodfledge/bite/corrupted_tongue
	name = "Sanguine Bite"

/datum/action/cooldown/bloodfledge/bite/Grant()
	. = ..()

	// Create reagent holder
	blood_bank = new(BLOODFLEDGE_BANK_CAPACITY)

	// Check for voracious
	if(HAS_TRAIT(owner, TRAIT_VORACIOUS))
		// Make times twice as fast
		cooldown_time *= 0.5
		time_interact*= 0.5

/datum/action/cooldown/bloodfledge/bite/Activate()
	// Check if powers are allowed
	if(!can_use(owner))
		return FALSE

	// Define action owner carbon mob
	var/mob/living/carbon/action_owner = owner

	// Check for any grabbed target
	if(!action_owner.pulling)
		// Warn the user, then return
		//to_chat(action_owner, span_warning("You need a victim first!"))
		action_owner.balloon_alert(action_owner, "need a victim!")
		return FALSE

	// Check for muzzle
	// Unimplemented here
	/*
	if(action_owner.is_muzzled())
		// Warn the user, then return
		to_chat(action_owner, span_warning("You can't bite things while muzzled!"))
		owner.balloon_alert(owner, "muzzled!")
		return FALSE
	*/

	// Check for covered mouth
	if(action_owner.is_mouth_covered())
		// Warn the user, then return
		to_chat(action_owner, span_warning("You can't bite things with your mouth covered!"))
		owner.balloon_alert(owner, "mouth covered!")
		return FALSE

	// Limit maximum blood volume
	if(action_owner.blood_volume >= BLOOD_VOLUME_MAXIMUM)
		// Warn the user, then return
		to_chat(action_owner, span_warning("Your body contains too much blood to drain any more."))
		owner.balloon_alert(owner, "too full!")
		return

	// Limit maximum potential blood volume
	if(action_owner.blood_volume + BLOODFLEDGE_DRAIN_AMT >= BLOOD_VOLUME_MAXIMUM)
		// Warn the user, then return
		to_chat(action_owner, span_warning("You body would become overwhelmed by draining any more blood."))
		owner.balloon_alert(owner, "too full!")
		return

	// Define pulled target
	var/pull_target = action_owner.pulling

	// Define bite target
	var/mob/living/carbon/human/bite_target

	/// Does action owner dumb has the dumb trait, or is currently desperate? Changes the result of some failure interactions.
	var/action_owner_dumb = (HAS_TRAIT(action_owner, TRAIT_DUMB) || HAS_TRAIT(action_owner, TRAIT_BLOODFLEDGE_DESPERATE))

	/// Is the action owner evil? Changes some interactions.
	var/action_owner_evil = HAS_TRAIT(action_owner, TRAIT_EVIL)

	// Face the target
	action_owner.face_atom(pull_target)

	// Check if the target is carbon
	if(iscarbon(pull_target))
		// Set the bite target
		bite_target = pull_target

	// Or cocooned carbon
	else if(istype(pull_target,/obj/structure/spider/cocoon))
		// Define if cocoon has a valid target
		// This cannot use pull_target
		var/possible_cocoon_target = locate(/mob/living/carbon/human) in action_owner.pulling.contents

		// Check defined cocoon target
		if(possible_cocoon_target)
			// Set the bite target
			bite_target = possible_cocoon_target

	// Or a blood tomato
	else if(istype(pull_target,/obj/item/food/grown/tomato/blood))
		// Set message based on dumbness
		var/message_tomato_suffix = (action_owner_dumb ? ", and absorb it\'s delicious vegan-friendly blood!" : "! It's not very nutritious.")
		// Warn the user, then return
		to_chat(action_owner, span_danger("You plunge your fangs into [pull_target][message_tomato_suffix]"))
		return

		// This doesn't actually interact with the item

	// Or none of the above
	else
		// Set message based on dumbness
		var/message_invalid_target = (action_owner_dumb ? "You bite at [pull_target], but nothing seems to happen" : "You can't drain blood from [pull_target]!")
		// Warn the user, then return
		to_chat(action_owner, span_warning(message_invalid_target))
		return

	// Define selected zone
	var/target_zone = action_owner.zone_selected

	// Check if target can be penetrated
	// Bypass pierce immunity so feedback can be provided later
	if(!bite_target.can_inject(action_owner, target_zone))
		// Warn the user, then return
		to_chat(action_owner, span_warning("There\'s no exposed flesh or thin material in that region of [bite_target]'s body. You're unable to bite them!"))
		return

	// Check targeted body part
	var/obj/item/bodypart/bite_bodypart = bite_target.get_bodypart(target_zone)

	// Define zone name
	var/target_zone_name = "flesh"

	/// Does the target zone have unique interactions?
	var/target_zone_effects = FALSE

	/**
	* If targeted zone should be checked
	* * Uses dismember check to determine if it can be missing.
	* * Missing limbs are assumed to be dismembered.
	*/
	var/target_zone_check = bite_bodypart?.can_dismember() || TRUE

	// Set zone name based on region
	// Also checks for some protections
	switch(target_zone)
		if(BODY_ZONE_HEAD)
			target_zone_name = "neck"

		if(BODY_ZONE_CHEST)
			target_zone_name = "shoulder"

		if(BODY_ZONE_L_ARM)
			target_zone_name = "left arm"

		if(BODY_ZONE_R_ARM)
			target_zone_name = "right arm"

		if(BODY_ZONE_L_LEG)
			target_zone_name = "left thigh"

		if(BODY_ZONE_R_LEG)
			target_zone_name = "right thigh"

		if(BODY_ZONE_PRECISE_EYES)
			// Check if eyes exist and are exposed
			if(!bite_target.has_eyes() == REQUIRE_GENITAL_EXPOSED)
				// Warn user and return
				to_chat(action_owner, span_warning("You can't find [bite_target]'s eyes to bite them!"))
				owner.balloon_alert(owner, "no eyes?")
				return

			// Set region data normally
			target_zone_name = "eyes"
			target_zone_check = FALSE
			target_zone_effects = TRUE

		if(BODY_ZONE_PRECISE_MOUTH)
			// Check if mouth is covered
			if(bite_target.is_mouth_covered())
				to_chat(action_owner, span_warning("You can't reach [bite_target]'s lips to bite them!"))
				owner.balloon_alert(owner, "no lips?")
				return

			// Set region data normally
			target_zone_name = "lips"
			target_zone_check = FALSE
			target_zone_effects = TRUE

		if(BODY_ZONE_PRECISE_GROIN)
			target_zone_name = "groin"
			target_zone_check = FALSE

		if(BODY_ZONE_PRECISE_L_HAND)
			target_zone_name = "left wrist"

		if(BODY_ZONE_PRECISE_R_HAND)
			target_zone_name = "right wrist"

		if(BODY_ZONE_PRECISE_L_FOOT)
			target_zone_name = "left ankle"

		if(BODY_ZONE_PRECISE_R_FOOT)
			target_zone_name = "right ankle"

	// Check if target should be checked
	if(target_zone_check)
		// Check if bodypart exists
		if(!bite_bodypart)
			// Warn user and return
			to_chat(action_owner, span_warning("[bite_target] doesn't have a [target_zone_name] for you to bite!"))
			owner.balloon_alert(owner, "no [target_zone_name]?")
			return

		// Check if bodypart is organic
		if(!IS_ORGANIC_LIMB(bite_bodypart))
			// Display local message
			action_owner.visible_message(span_danger("[action_owner] tries to bite [bite_target]'s [target_zone_name], but is unable to penetrate the mechanical prosthetic!"), span_warning("You attempt to bite [bite_target]'s [target_zone_name], but can't penetrate the mechanical prosthetic!"), ignored_mobs=bite_target)

			// Warn user
			to_chat(bite_target, span_warning("[action_owner] tries to bite your [target_zone_name], but is unable to penetrate the mechanical prosthetic!"))

			// Play metal hit sound
			playsound(bite_target, "sound/effects/clang.ogg", 30, 1, -2)

			// Start cooldown early to prevent spam
			StartCooldown()

			// Return without further effects
			return

	// Check for anti-magic
	if(bite_target.can_block_magic(MAGIC_RESISTANCE_HOLY))
		// Check for a dumb user
		if(action_owner_dumb)
			// Display local message
			action_owner.visible_message(span_danger("[action_owner] tries to bite [bite_target]'s [target_zone_name], but bursts into flames just as [action_owner.p_they()] come[action_owner.p_s()] into contact with [bite_target.p_them()]!"), span_userdanger("Surges of pain course through your body as you attempt to bite [bite_target]! What were you thinking?"), ignored_mobs=bite_target)

			// Warn target
			to_chat(bite_target, span_warning("[action_owner] tries to bite you, but bursts into flames just as [action_owner.p_they()] come[action_owner.p_s()] into contact with you!"))

			// Stop grabbing
			action_owner.stop_pulling()

			// Ignite action owner
			action_owner.adjust_fire_stacks(2)
			action_owner.ignite_mob()

			// Return with no further effects
			return

		// Warn the user and target, then return
		to_chat(bite_target, span_warning("[action_owner] tries to bite your [target_zone_name], but stops before touching you!"))
		to_chat(action_owner, span_warning("[bite_target] is blessed! You stop just in time to avoid catching fire."))
		return

	// Check for SSD player using indicator
	// If so, warn the user and return
	if(bite_target.ssd_indicator)
		// Check if evil for unique message
		if(action_owner_evil)
			to_chat(action_owner, span_warning("Feeding from [bite_target] while [bite_target.p_theyre()] suffering from Space Sleep Disorder is beneath you. Find a victim more worthy of your embrace."))

		// Non-evil holder
		else
			to_chat(action_owner, span_warning("You can't bring yourself to bite [bite_target] while [bite_target.p_theyre()] suffering from Space Sleep Disorder."))

		// Abort action
		return

	// Check for mind-gone player
	// If so, warn the user and return
	// This should only occur when inhabiting a "temporary body" (ex. bitrunning)
	if(HAS_TRAIT(bite_target, TRAIT_MIND_TEMPORARILY_GONE))
		// Check if evil for unique message
		if(action_owner_evil)
			to_chat(action_owner, span_warning("[bite_target] is currently unworthy of serving your thirst! Try again later."))

		// Non-evil holder
		else
			to_chat(action_owner, span_warning("Something feels off about [bite_target]. You decide not to bite [bite_target.p_them()] right now."))

		// Abort action
		return

	// Check for garlic in the bloodstream
	if(bite_target.has_reagent(/datum/reagent/consumable/garlic, 5))
		// Check for a dumb user
		if(action_owner_dumb)
			// Display local message
			action_owner.visible_message(span_danger("[action_owner] tries to bite [bite_target]'s [target_zone_name], but immediately recoils in disgust upon touching [bite_target.p_them()]!"), span_userdanger("An intense wave of disgust washes over your body as you attempt to bite [bite_target]! What were you thinking?"), ignored_mobs=bite_target)

			// Warn target
			to_chat(bite_target, span_warning("[action_owner] tries to bite your [target_zone_name], but recoils in disgust just as [action_owner.p_they()] come[action_owner.p_s()] into contact with you!"))

			// Stop grabbing
			action_owner.stop_pulling()

			// Add disgust
			action_owner.adjust_disgust(10)

			// Vomit
			action_owner.vomit()

			// Return with no further effects
			return

		// Warn the user and target, then return
		to_chat(bite_target, span_warning("[action_owner] leans in to bite your [target_zone_name], but is warded off by your Allium Sativum!"))
		to_chat(action_owner, span_warning("You sense that [bite_target] is protected by Allium Sativum, and refrain from biting [bite_target.p_them()]."))
		return

	// Define bite target's blood volume
	var/target_blood_volume = bite_target.blood_volume

	// Check for sufficient blood volume
	if(target_blood_volume < BLOODFLEDGE_DRAIN_AMT)
		// Warn the user, then return
		to_chat(action_owner, span_warning("There's not enough blood in [bite_target]!"))
		return

	// Check if total blood would become too low
	if((target_blood_volume - BLOODFLEDGE_DRAIN_AMT) <= BLOOD_VOLUME_OKAY)
		// Check for a dumb user
		if(action_owner_dumb)
			// Warn the user, but allow
			to_chat(action_owner, span_warning("You pay no attention to [bite_target]'s blood volume, and bite [bite_target.p_their()] [target_zone_name] without hesitation."))

		// Check for an evil user
		else if(action_owner_evil)
			// Warn the user, but allow
			to_chat(action_owner, span_warning("You sense that [bite_target] is running low on blood, but bite into [bite_target.p_their()] [target_zone_name] regardless."))

		// Check for aggressive grab
		else if(action_owner.grab_state < GRAB_AGGRESSIVE)
			// Warn the user, then return
			to_chat(action_owner, span_warning("You sense that [bite_target] is running low on blood. You'll need a tighter grip on [bite_target.p_them()] to continue."))
			return

		// Check for pacifist
		else if(HAS_TRAIT(action_owner, TRAIT_PACIFISM))
			// Warn the user, then return
			to_chat(action_owner, span_warning("You can't drain any more blood from [bite_target] without hurting [bite_target.p_them()]!"))
			return

	// Check for pierce immunity
	if(HAS_TRAIT(bite_target, TRAIT_PIERCEIMMUNE))
		// Display local chat message
		action_owner.visible_message(span_danger("[action_owner] tries to bite down on [bite_target]'s [target_zone_name], but can't seem to pierce [bite_target.p_them()]!"), span_danger("You try to bite down on [bite_target]'s [target_zone_name], but are completely unable to pierce [bite_target.p_them()]!"), ignored_mobs=bite_target)

		// Warn bite target
		to_chat(bite_target, span_userdanger("[action_owner] tries to bite your [target_zone_name], but is unable to piece you!"))

		// Return without further effects
		return

	// Check for target zone special effects
	if(target_zone_effects)
		// Check if biting eyes or mouth
		if((target_zone == BODY_ZONE_PRECISE_EYES) || (target_zone == BODY_ZONE_PRECISE_MOUTH))
			// Check if biting target with proto-type face
			// Snout type is a string that cannot use subtype search
			if(findtext(bite_target.dna?.features["snout"], "Synthetic Lizard"))
				// Display local chat message
				action_owner.visible_message(span_notice("[action_owner]'s fangs clank harmlessly against [bite_target]'s face-screen!"), span_notice("Your fangs clank harmlessly against [bite_target]'s face-screen!"), ignored_mobs=bite_target)

				// Alert bite target
				to_chat(bite_target, span_notice("[action_owner]'s fangs clank harmlessly against your face-screen"))

				// Play glass tap sound
				playsound(bite_target, 'sound/effects/glass/glasshit.ogg', 50, 1, -2)

				// Start cooldown early to prevent spam
				StartCooldown()

				// Return without further effects
				return

		// Check for strange bite regions
		switch(target_zone)
			// Zone is eyes
			if(BODY_ZONE_PRECISE_EYES)
				// Define target's eyes
				var/obj/item/organ/eyes/target_eyes = bite_target.get_organ_slot(ORGAN_SLOT_EYES)

				// Check if eyes exist
				// This should always be the case since eyes exposed was checked above
				if(!target_eyes)
					// Warn user and return
					to_chat(bite_target, span_userdanger("Something has gone terribly wrong with [bite_target]'s eyes! Please report this to a coder!"))
					return

				// Check for cybernetic eyes
				if(IS_ROBOTIC_ORGAN(target_eyes))
					// Warn users and return
					to_chat(action_owner, span_danger("Your fangs aren't powerful enough to penetrate robotic eyes!"))
					to_chat(bite_target, span_danger("[action_owner] tries to bite into your [target_eyes], but can't break through!"))
					return

				// Display warning
				to_chat(bite_target, span_userdanger("Your [target_eyes] rupture in pain as [action_owner]'s fangs pierce their surface!"))

				// Blur vision equal to drunkenness
				bite_target.adjust_eye_blur_up_to(4 SECONDS, 20 SECONDS)

				// Add organ damage
				target_eyes.apply_organ_damage(rand(10, 20))

			// Zone is mouth
			if(BODY_ZONE_PRECISE_MOUTH)
				// Cause temporary stuttering
				bite_target.set_stutter_if_lower(10 SECONDS)

	// Display local chat message
	action_owner.visible_message(span_danger("[action_owner] bites down on [bite_target]'s [target_zone_name]!"), span_danger("You bite down on [bite_target]'s [target_zone_name]!"), ignored_mobs=bite_target)

	// Play a bite sound effect
	playsound(action_owner, 'sound/items/weapons/bite.ogg', 30, 1, -2)

	// Warn bite target
	to_chat(bite_target, span_userdanger("[action_owner] has bitten your [target_zone_name], and is trying to drain your blood!"))

	// Try to perform action timer
	if(!do_after(action_owner, time_interact, target = bite_target))
		// When failing
		// Display a local chat message
		action_owner.visible_message(span_danger("[action_owner]'s fangs are prematurely torn from [bite_target]'s [target_zone_name], spilling some of [bite_target.p_their()] blood!"), span_danger("Your fangs are prematurely torn from [bite_target]'s [target_zone_name], spilling some of [bite_target.p_their()] blood!"), ignored_mobs=bite_target)

		// Warn bite target
		to_chat(bite_target, span_userdanger("[action_owner]\'s fangs are prematurely torn from your [target_zone_name], spilling some of your blood!"))

		// Bite target "drops" 20% of the blood
		// This creates large blood splatter
		bite_target.bleed((BLOODFLEDGE_DRAIN_AMT*0.2), FALSE)

		// Play splatter sound
		playsound(get_turf(target), 'sound/effects/splat.ogg', 40, 1)

		// Check for masochism
		if(!HAS_TRAIT(bite_target, TRAIT_MASOCHISM))
			// Force bite_target to play the scream emote
			bite_target.emote("scream")

		// Log the biting action failure
		log_combat(action_owner,bite_target,"bloodfledge bitten (interrupted)")

		// Add target's blood to quirk holder and themselves
		bite_target.add_mob_blood(bite_target)
		action_owner.add_mob_blood(bite_target)

		// Check if body part is valid for bleeding
		// This reuses the dismember-able check
		if(target_zone_check)
			// Cause minor bleeding
			bite_bodypart.adjustBleedStacks(2)

			// Apply minor damage
			bite_bodypart.receive_damage(brute = rand(4,8), sharpness = SHARP_POINTY)

		// Add negative mood event for failure
		// Ignored if the holder is a sadist
		if(!HAS_TRAIT(bite_target, TRAIT_SADISM))
			// Uses different flavor text for evil holder
			if(action_owner_evil)
				action_owner.add_mood_event(QMOOD_BFLED_BITE_INTERRUPT, /datum/mood_event/bloodfledge/drankblood/bite_failed/evil)
			else
				action_owner.add_mood_event(QMOOD_BFLED_BITE_INTERRUPT, /datum/mood_event/bloodfledge/drankblood/bite_failed)

		// Start cooldown early
		// This is to prevent bite interrupt spam
		StartCooldown()

		// Return
		return

	else
		/// Is this valid nourishing blood? Does not grant nutrition if FALSE.
		var/blood_valid = TRUE

		/// Should blood be transferred anyway? Used when blood_valid is FALSE.
		var/blood_transfer = FALSE

		/// Name of exotic blood substitute determined by species
		var/blood_name = "blood"

		// Define blood types for owner and target
		var/datum/blood_type/target_blood = bite_target.dna?.blood_type
		var/datum/blood_type/owner_blood = action_owner.dna?.blood_type

		// Check if target has blood type
		if(target_blood)
			// Define if owner and target blood types match
			var/blood_type_match = (owner_blood.id == target_blood.id)

			// Check if types matched
			if(blood_type_match)
				// Add positive mood
				action_owner.add_mood_event(QMOOD_BFLED_DRANK_MATCH, /datum/mood_event/bloodfledge/drankblood/exotic_matched)

			// Set blood name from datum
			blood_name = target_blood.name

			/*
			 * Check blood type specific effects
			 *
			 * Set blood_valid FALSE if this is exotic non-blood
			 *
			 * Set blood_transfer TRUE if the reagent should be added directly to the owner
			 * This is to apply penalties for exotic dangerous bloods
			 *
			 * Add a mood event if exotic blood types do not match
			 *
			*/
			switch(target_blood.reagent_type)
				// Synthetic blood
				if(/datum/reagent/fuel/oil)
					blood_valid = FALSE
					if(!blood_type_match)
						action_owner.add_mood_event(QMOOD_BFLED_DRANK_SYNTH, /datum/mood_event/bloodfledge/drankblood/synth)

				// Slime blood
				if(/datum/reagent/toxin/slimejelly)
					blood_valid = FALSE
					blood_transfer = TRUE
					if(!blood_type_match)
						action_owner.add_mood_event(QMOOD_BFLED_DRANK_SLIME, /datum/mood_event/bloodfledge/drankblood/slime)

				// Podperson blood
				if(/datum/reagent/water)
					blood_valid = FALSE
					action_owner.add_mood_event(QMOOD_BFLED_DRANK_POD, /datum/mood_event/bloodfledge/drankblood/podperson)

				// Snail blood
				if(/datum/reagent/lube)
					blood_valid = FALSE
					if(!blood_type_match)
						action_owner.add_mood_event(QMOOD_BFLED_DRANK_SNAIL, /datum/mood_event/bloodfledge/drankblood/snail)

				// Skrell blood
				if(/datum/reagent/copper)
					blood_valid = FALSE
					if(!blood_type_match)
						action_owner.add_mood_event(QMOOD_BFLED_DRANK_SKREL, /datum/mood_event/bloodfledge/drankblood/skrell)

				// Xenomorph Hybrid blood
				if(/datum/reagent/toxin/acid)
					blood_valid = FALSE
					blood_transfer = TRUE
					if(!blood_type_match)
						action_owner.add_mood_event(QMOOD_BFLED_DRANK_XENO, /datum/mood_event/bloodfledge/drankblood/xeno)

				// Ethereal Blood
				if(/datum/reagent/colorful_reagent)
					blood_valid = FALSE
					blood_transfer = TRUE
					action_owner.add_mood_event(QMOOD_BFLED_DRANK_ETHER, /datum/mood_event/bloodfledge/drankblood/ethereal)

		// Check if bite target has any blood
		// Checked later since some species have NOBLOOD and exotic blood type
		else if(HAS_TRAIT(bite_target, TRAIT_NOBLOOD))
			// Warn the user and target
			to_chat(bite_target, span_warning("[action_owner] bit your [target_zone_name] in an attempt to drain your blood, but couldn't find any!"))
			to_chat(action_owner, span_warning("[bite_target] doesn't have any blood to drink!"))

			// Start cooldown early to prevent sound spam
			StartCooldown()

			// Return without effects
			return

		// End of exotic blood checks

		// Define user's remaining capacity to absorb blood
		var/blood_volume_difference = BLOOD_VOLUME_MAXIMUM - action_owner.blood_volume
		var/drained_blood = min(target_blood_volume, BLOODFLEDGE_DRAIN_AMT, blood_volume_difference)

		// Transfer reagents from target to action owner
		// Limited to a maximum 10% of bite amount (default 10u)
		bite_target.reagents.trans_to(action_owner, (drained_blood*0.1))

		// Alert the bite target and local user of success
		// Yes, this is AFTER the message for non-valid blood
		to_chat(bite_target, span_danger(span_warning("[action_owner] has taken some of your blood!")))
		to_chat(action_owner, span_notice(span_good("You've drained some of [bite_target]'s [blood_name] blood!")))

		// Check if action owner received valid blood
		if(blood_valid)
			// Add blood reagent to reagent holder
			blood_bank.add_reagent(/datum/reagent/blood/, drained_blood, bite_target.get_blood_data())

			// Transfer reagent to action owner
			blood_bank.trans_to(action_owner, drained_blood, methods = INGEST)

			// Remove all reagents
			blood_bank.remove_all()

		// Check if blood transfer should occur
		else if(blood_transfer)
			// Check if action holder's blood volume limit was exceeded
			if(action_owner.blood_volume >= BLOOD_VOLUME_MAXIMUM)
				// Warn user
				to_chat(action_owner, span_warning("You body cannot integrate any more [blood_name] blood. The remainder will be lost."))

			// Blood volume limit was not exceeded
			else
				// Alert user
				to_chat(action_owner, span_notice("You body integrates the [blood_name] blood directly, instead of processing it normally."))

			// Transfer blood directly
			bite_target.transfer_blood_to(action_owner, drained_blood, TRUE)

			// Set drain amount to none
			// This prevents double removal
			drained_blood = 0

		// Valid blood was not received
		// No direct blood transfer occurred
		else
			// Warn user of failure
			to_chat(action_owner, span_warning("Your body cannot process the [blood_name]!"))

		// Remove blood from bite target
		bite_target.blood_volume = clamp(target_blood_volume - drained_blood, 0, BLOOD_VOLUME_MAXIMUM)

		// Play a heartbeat sound effect
		// This was changed to match bloodsucker
		playsound(action_owner, 'sound/effects/singlebeat.ogg', 30, 1, -2)

		// Log the biting action success
		log_combat(action_owner,bite_target,"bloodfledge bitten (successfully), transferring [blood_name]")

		// Mood events
		// Check if bite target is dead or undead
		if((bite_target.stat >= DEAD) || (bite_target.mob_biotypes & MOB_UNDEAD))
			// Warn the user
			to_chat(action_owner, span_warning("The rotten [blood_name] blood tasted foul."))

			// Add disgust
			action_owner.adjust_disgust(10)

			// Cause negative mood
			action_owner.add_mood_event(QMOOD_BFLED_DRANK_DEAD, /datum/mood_event/bloodfledge/drankblood/dead)

		// Check if bite target's blood has been depleted
		if(!bite_target.blood_volume)
			// Warn the user
			to_chat(action_owner, span_warning("You've depleted [bite_target]'s [blood_name] supply!"))

			// Check if not evil
			if(!action_owner_evil)
				// Cause negative mood
				action_owner.add_mood_event(QMOOD_BFLED_DRANK_KILL, /datum/mood_event/bloodfledge/drankblood/killed)

		// Check if bite target has cursed blood
		if(HAS_TRAIT(bite_target, TRAIT_CURSED_BLOOD))
			/// Does action owner have the cursed blood quirk?
			var/owner_cursed = HAS_TRAIT(action_owner, TRAIT_CURSED_BLOOD)

			// Set chat message based on action owner's trait status
			var/warn_message = (owner_cursed ? "You taste the unholy touch of a familiar curse in [bite_target]\'s blood." : "You experience a sensation of intense dread just after drinking from [bite_target]. Something about their blood feels... wrong.")

			// Alert user in chat
			to_chat(action_owner, span_notice(warn_message))

			// Set mood type based on curse status
			var/mood_type = (owner_cursed ? /datum/mood_event/bloodfledge/drankblood/cursed_good : /datum/mood_event/bloodfledge/drankblood/cursed_bad)

			// Cause mood event
			action_owner.add_mood_event(QMOOD_BFLED_DRANK_CURSE, mood_type)

		// Try to transfer target's nanites
		transfer_nanites(action_owner, bite_target)

		// Start cooldown
		StartCooldown()

/// Proc for Bloodfledge copying target's nanites
/datum/action/cooldown/bloodfledge/bite/proc/transfer_nanites(mob/living/carbon/action_owner, mob/living/carbon/human/bite_target)
	// Check if both mobs exist
	if(!(istype(action_owner) && istype(bite_target)))
		return

	// Check if owner can have nanites
	if(!CAN_HAVE_NANITES(action_owner))
		return

	// Check if bite target has nanites
	if(!SEND_SIGNAL(bite_target, COMSIG_HAS_NANITES))
		return

	// Check if action owner already had nanites
	// Please don't replace their settings if they do
	if(SEND_SIGNAL(action_owner, COMSIG_HAS_NANITES))
		return

	// Define bite target's nanites
	var/datum/component/nanites/target_nanites = bite_target.GetComponent(/datum/component/nanites)

	// Inject nanites into owner using matching cloud ID
	action_owner.AddComponent(/datum/component/nanites, BLOODFLEDGE_NANITE_TRANSFER_AMOUNT, target_nanites.cloud_id)

	// Debug output
	#ifdef TESTING
	to_chat(action_owner, span_boldwarning("TESTING: Gained [BLOODFLEDGE_NANITE_TRANSFER_AMOUNT] nanites with cloud ID: [target_nanites.cloud_id]"))
	#endif

	// Log nanite transfer
	action_owner.investigate_log("inherited the nanites of [key_name(bite_target)] with cloud ID [target_nanites.cloud_id] by using supernatural methods at [AREACOORD(bite_target)].", INVESTIGATE_NANITES)
	log_combat(action_owner,bite_target, "inherited nanites from", null, "using the Bloodfledge quirk Bite action.")

// Action: Revive
/datum/action/cooldown/bloodfledge/revive
	name = "Fledgling Revive"
	desc = "Sacrifice a large volume of blood to escape death."
	button_icon_state = "power_strength"
	cooldown_time = BLOODFLEDGE_COOLDOWN_REVIVE

	// Override flags
	check_flags = AB_CHECK_PHASED

	/// Should this ability require being in a closed coffin?
	var/require_coffin = TRUE

/datum/action/cooldown/bloodfledge/revive/Activate()
	// Check if powers are allowed
	if(!can_use(owner))
		return FALSE

	// Early check for being dead
	// Users are most likely to click this while alive
	if(owner.stat != DEAD)
		// Warn user and return
		//to_chat(action_owner, "You can't use this ability while alive!")
		owner.balloon_alert(owner, "not dead!")
		return

	/// Define failure messages. Will not revive if any failure message is set.
	var/revive_failed

	// Condition: Mob isn't in a closed coffin
	if(require_coffin && (!istype(owner.loc, /obj/structure/closet/crate/coffin)))
		revive_failed += "\n- You need to be in a closed coffin!"

	// Define mob
	var/mob/living/carbon/human/action_owner = owner

	// Condition: Insufficient blood volume
	if(action_owner.blood_volume < BLOODFLEDGE_REVIVE_MINIMUM_VOLUME)
		revive_failed += "\n- You don't have enough blood left!"

	// Condition: Can be revived
	// This is used by revive(), and must be checked here to prevent false feedback
	if(!action_owner.can_be_revived())
		revive_failed += "\n- Your body is too weak to sustain life!"

	// Condition: Damage limit, brute
	if(action_owner.get_brute_loss() >= MAX_REVIVE_BRUTE_DAMAGE)
		revive_failed += "\n- Your body is too battered!"

	// Condition: Damage limit, burn
	if(action_owner.get_fire_loss() >= MAX_REVIVE_FIRE_DAMAGE)
		revive_failed += "\n- Your body is too badly burned!"

	// Condition: Suicide
	if(HAS_TRAIT(action_owner, TRAIT_SUICIDED))
		revive_failed += "\n- You chose this path."

	// Condition: Do Not Revive quirk
	if(HAS_TRAIT(action_owner, TRAIT_DNR))
		revive_failed += "\n- You only had one chance."

	// Unimplemented here
	/*
	// Condition: No revivals
	if(HAS_TRAIT(action_owner, TRAIT_NOCLONE))
		revive_failed += "\n- You only had one chance."

	// Condition: Demonic contract
	if(action_owner.hellbound)
		revive_failed += "\n- The soul pact must be honored."
	*/

	// Check for failure
	if(revive_failed)
		// Set combined message
		revive_failed = span_warning("You can't revive right now because: [revive_failed]")

		// Alert user in chat of failure
		to_chat(action_owner, revive_failed)

		// Return
		return

	// Alert nearby players that we are about to revive

	// Play revival imminent sound
	playsound(action_owner, 'sound/effects/singlebeat.ogg', 30, 1, -2)

	// Display local chat message
	action_owner.visible_message(span_notice("[action_owner]'s body begins to twitch and radiate an ominous aura."), span_warning("You begin gathering the strength to revive."))

	// Attempt to revive after a timer
	if(!do_after(action_owner, BLOODFLEDGE_REVIVE_DELAY, action_owner, list(IGNORE_USER_LOC_CHANGE, IGNORE_TARGET_LOC_CHANGE, IGNORE_SLOWDOWNS, IGNORE_INCAPACITATED)))
		// Alert user in chat and return
		to_chat(action_owner, span_warning("Something has interrupted your revival!"))
		return FALSE

	// Recheck if ability should be usable
	if(!can_use(owner) || action_owner.get_brute_loss() >= MAX_REVIVE_BRUTE_DAMAGE || action_owner.get_fire_loss() >= MAX_REVIVE_FIRE_DAMAGE)
		return FALSE

	// Remove oxygen damage
	action_owner.adjust_oxy_loss(-100, updating_health = FALSE)

	// Heal and revive the action owner
	action_owner.heal_and_revive()

	// Check if health is too low to use revive()
	// Obsolete as of heal_and_revive
	/*
	if(action_owner.health <= HEALTH_THRESHOLD_DEAD)
		// Set health high enough to revive
		// Based on defib.dm

		// Define damage values
		var/damage_brute = action_owner.get_brute_loss()
		var/damage_burn = action_owner.get_fire_loss()
		var/damage_tox = action_owner.get_tox_loss()
		var/damage_oxy = action_owner.get_oxy_loss()
		var/damage_brain = action_owner.get_organ_loss(ORGAN_SLOT_BRAIN)

		// Define total damage
		var/damage_total = damage_brute + damage_burn + damage_tox + damage_oxy + damage_brain

		// Define to prevent redundant math
		// Equal to HALFWAYCRITDEATH in defib.dm
		var/health_half_crit = action_owner.health - ((HEALTH_THRESHOLD_CRIT + HEALTH_THRESHOLD_DEAD) * 0.5)

		// Adjust damage types
		action_owner.adjust_oxy_loss(health_half_crit * (damage_oxy / damage_total), updating_health = FALSE)
		action_owner.adjust_tox_loss(health_half_crit * (damage_tox / damage_total), updating_health = FALSE)
		action_owner.adjust_fire_loss(health_half_crit * (damage_burn / damage_total), updating_health = FALSE)
		action_owner.adjust_brute_loss(health_half_crit * (damage_brute / damage_total), updating_health = FALSE)
		action_owner.adjust_organ_loss(ORGAN_SLOT_BRAIN, health_half_crit * (damage_brain / damage_total))

		// Update health
		action_owner.updatehealth()

	// Check if revival is possible
	// This is used by revive(), and must be checked here to prevent false feedback
	if(!action_owner.can_be_revived())
		// Warn user
		to_chat(action_owner, span_warning("Despite your body's best attempts at mending, it remains too weak to revive! Something this terrible shouldn't be possible!"))

		// Start cooldown anyway, since healing was performed
		StartCooldown()

		// Return without revival
		return
	*/

	// Revive the action owner
	//action_owner.revive()

	// Alert the user in chat of success
	action_owner.visible_message(span_notice("An ominous energy radiates from the [action_owner.loc]..."), span_warning("You've expended most of your blood to bring your body back to life!"))

	// Warn user about revive policy
	to_chat(action_owner, span_userdanger("[CONFIG_GET(string/blackoutpolicy)]"))

	// Log the revival
	action_owner.log_message("revived using a bloodfledge quirk ability.", LOG_GAME)

	// Play a haunted sound effect
	playsound(action_owner, 'sound/effects/pope_entry.ogg', 30, 1, -2)

	// Check if hemophage
	if(ishemophage(action_owner))
		// Set blood volume level
		// Value increased to prevent instant death for hemophages
		action_owner.blood_volume = min(action_owner.blood_volume, BLOODFLEDGE_REVIVE_MINIMUM_VOLUME)

	// Non-hemophage
	else
		// Set blood volume level
		action_owner.blood_volume = min(action_owner.blood_volume, BLOODFLEDGE_REVIVE_AFTER_BLOOD_VOLUME)

	// Apply dizzy effect
	action_owner.adjust_dizzy_up_to(20 SECONDS, 60 SECONDS)

	// Start cooldown
	StartCooldown()

// Action: Analyze
/datum/action/cooldown/bloodfledge/analyze
	name = "Fledgling Analyze"
	desc = "Peer through the Geometer's eyes to gain insight on another individual's blood."
	button_icon_state = "power_mez"
	cooldown_time = BLOODFLEDGE_COOLDOWN_ANALYZE
	click_to_activate = TRUE

// Set button activation
/datum/action/cooldown/bloodfledge/analyze/set_click_ability(mob/on_who)
	. = ..()

	// Check parent function
	if (!.)
		return

	// Alert user in chat
	to_chat(on_who, span_notice("Your mind reaches into the higher planes, preparing to sense more about others."))

	// Put code for updating icon here

// Unset button activation
/datum/action/cooldown/bloodfledge/analyze/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	. = ..()

	// Check parent function
	if (!.)
		return

	// Check if cooldown should be refunded
	if(refund_cooldown)
		// Alert user in chat
		to_chat(on_who, span_notice("You decide not to sense anything about blood for now."))

	// Put code for updating icon here

// Activate ability
/datum/action/cooldown/bloodfledge/analyze/Activate(atom/cast_on)
	// Check if powers are allowed
	if(!can_use(owner))
		return FALSE

	// Define owner and target
	var/mob/living/carbon/human/human_target = cast_on
	var/mob/living/carbon/human/human_caster = owner

	// Check if owner and target are valid
	if(!ishuman(human_target) || !human_caster || human_target == human_caster)
		// Alert user in chat and return
		to_chat(owner, span_warning("That isn't a valid analyze target!"))
		return FALSE

	// Check for holiness
	if(human_target.can_block_magic(MAGIC_RESISTANCE_HOLY))
		// Start cooldown with half duration
		StartCooldown(cooldown_time / 2)

		// Warn user and return
		to_chat(human_caster, fieldset_block(span_yellow_flashy("Analysis Results"), "A strange power is protecting " + span_yellow_flashy("[human_target]") + "!\nYou cannot determine anything about " + human_target.p_them() + "!", "boxed_message red_box"))
		return TRUE

	// Define target pronouns
	var/t_their = human_target.p_Their()

	// Define blood types and volume
	var/datum/blood_type/target_bloodtype = human_target.get_bloodtype()
	var/datum/blood_type/caster_bloodtype = human_caster.get_bloodtype()
	var/target_blood_volume = human_target.blood_volume

	// Define default non-bloodtype response
	var/output = "[t_their] [target_bloodtype] blood may or may not be compatible with your body."

	// Ensure caster actually has a blood type
	if(!isnull(caster_bloodtype))
		// Define default has-bloodtype response
		output = "[t_their] [target_bloodtype] blood is " + span_boldwarning("incompatible") + " with yours."

		// Check if blood type matches
		if(target_bloodtype == caster_bloodtype)
			output = "[t_their] [target_bloodtype] blood is a " + span_nicegreen("perfect match") + " with yours!"

		// Blood type does not match
		// Check if blood type is compatible
		else if(target_bloodtype.type_key() in human_caster.get_bloodtype().compatible_types)
			output = "[t_their] [target_bloodtype] blood is safe for you to consume."

	// Check target blood volume
	switch(target_blood_volume)
		// Lethal dosage of blood
		if(BLOOD_VOLUME_EXCESS to INFINITY)
			output += span_boldnicegreen("\n[t_their] body is a swollen balloon of rich blood begging to be siphoned!")

		// Too much
		if(BLOOD_VOLUME_MAXIMUM to BLOOD_VOLUME_EXCESS)
			output += span_boldnicegreen("\n[t_their] body is overrun with excessive blood! You would be doing [human_target.p_them()] a favor!")

		// Very high volume
		if(BLOOD_VOLUME_SLIME_SPLIT to BLOOD_VOLUME_MAXIMUM)
			output += span_nicegreen("\n[t_their] body sloshes with excess blood, calling out your name.")

		// High volume
		if(BLOOD_VOLUME_SAFE to BLOOD_VOLUME_SLIME_SPLIT)
			output += "\n[t_their] veins run rich with blood, ripe for the taking."

		// Not enough, but safe
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			output += span_warning("\n[t_their] blood runs thinner than normal. Be careful with [human_target.p_them()].")

		// Not enough, becoming dangerous
		if(BLOOD_VOLUME_RISKY to BLOOD_VOLUME_OKAY)
			output += span_warning("\n[t_their] heart struggles against a thiner blood supply!")

		// Dangerously low
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_RISKY)
			output += span_boldwarning("\n[t_their] heart is beating faster against a dangerously low blood supply.")

		// Critcally low, near death
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			output += span_boldwarning("\n[t_their] heartbeat thrashes wildly, desperately trying to offset a critical blood shortage.")

		// Instant death
		if(-INFINITY to BLOOD_VOLUME_SURVIVE)
			output += span_boldwarning("\n[t_their] body is a shriveled sack of dry flesh.")

	// Check if examiner shares the quirk
	if(isbloodfledge(human_target))
		// Add detection text
		output += "\n" + span_warning("[human_target.p_Theyre()] a fellow sanguine sorcerer! You probably shouldn't feed from [human_target.p_them()].")

	// Alert user of results
	to_chat(human_caster, fieldset_block("Analysis Results", output, "boxed_message red_box"))

	// Start cooldown and return
	StartCooldown()
	return TRUE

//
// Bloodfledge memory
//

//Create a memory of the bloodfledge's blood type, for easy access
/datum/memory/key/quirk_bloodfledge
	var/blood_type

/datum/memory/key/quirk_bloodfledge/New(
	datum/mind/memorizer_mind,
	atom/protagonist,
	atom/deuteragonist,
	atom/antagonist,
	blood_type,
)
	src.blood_type = blood_type
	return ..()

/datum/memory/key/quirk_bloodfledge/get_names()
	return list("[protagonist_name] becomes aware of their blood type, [blood_type].")

/datum/memory/key/quirk_bloodfledge/get_starts()
	return list(
		"Their cursed blood, singing to them. [blood_type]",
	)

/**
 * Desperation Effect
 * Triggered by having low blood volume
 */

/// Proc for add Bloodfledge desperation effects
/datum/quirk/item_quirk/bloodfledge/proc/set_desperate()
	// Check if already desperate
	if(is_desperate)
		// Do nothing
		return

	// Check if conscious
	if(quirk_holder.stat == CONSCIOUS)
		// Alert user in chat
		to_chat(quirk_holder, span_warning("[BLOODFLEDGE_DESPERATE_MESSAGES]"))

	// Set desperation variable
	is_desperate = TRUE

	// Add desperate trait
	// This makes bite interactions act less cautiously
	ADD_TRAIT(quirk_holder, TRAIT_BLOODFLEDGE_DESPERATE, TRAIT_BLOODFLEDGE)

	// Add negative mood effect
	quirk_holder.add_mood_event(QMOOD_BFLED_CRAVE, /datum/mood_event/bloodfledge/blood_craving)

	// Reduce healing amount
	heal_amount *= BLOODFLEDGE_HEAL_PENALTY_DESPERATE

/// Proc to remove Bloodfledge desperation effects
/datum/quirk/item_quirk/bloodfledge/proc/remove_desperate()
	// Check if desperate
	if(!is_desperate)
		// Do nothing
		return

	// Set desperate variable
	is_desperate = FALSE

	// Remove desperate trait
	REMOVE_TRAIT(quirk_holder, TRAIT_BLOODFLEDGE_DESPERATE, TRAIT_BLOODFLEDGE)

	// Add positive mood event
	quirk_holder.add_mood_event(QMOOD_BFLED_CRAVE, /datum/mood_event/bloodfledge/blood_satisfied)

	// Reset heal amount
	heal_amount /= BLOODFLEDGE_HEAL_PENALTY_DESPERATE

#undef BLOODFLEDGE_DRAIN_AMT
#undef BLOODFLEDGE_DRAIN_TIME
#undef BLOODFLEDGE_COOLDOWN_BITE
#undef BLOODFLEDGE_COOLDOWN_REVIVE
#undef BLOODFLEDGE_COOLDOWN_ANALYZE
#undef BLOODFLEDGE_BANK_CAPACITY
#undef BLOODFLEDGE_HEAL_AMT
#undef BLOODFLEDGE_HEAL_AMT_BONUS
#undef BLOODFLEDGE_HEAL_PENALTY_DESPERATE
#undef BLOODFLEDGE_TRAITS
#undef BLOODFLEDGE_REVIVE_DELAY
#undef BLOODFLEDGE_REVIVE_MINIMUM_VOLUME
#undef BLOODFLEDGE_REVIVE_AFTER_BLOOD_VOLUME
#undef BLOODFLEDGE_REVIVE_DESC_BASE
#undef BLOODFLEDGE_REVIVE_DESC_1
#undef BLOODFLEDGE_REVIVE_DESC_2
#undef BLOODFLEDGE_REVIVE_DESC_3
#undef BLOODFLEDGE_DESPERATE_THRESHOLD_START
#undef BLOODFLEDGE_DESPERATE_THRESHOLD_END
#undef BLOODFLEDGE_NANITE_TRANSFER_AMOUNT
#undef BLOODFLEDGE_BLOODLOSS_LIMIT
#undef BLOODFLEDGE_BLOODLOSS_REDUCTION
#undef BLOODFLEDGE_BLOODLOSS_RATE_MOD
#undef BLOODFLEDGE_DNA_BONUS_1
#undef BLOODFLEDGE_DNA_BONUS_2
#undef BLOODFLEDGE_DESPERATE_MESSAGES
#undef BLOODFLEDGE_WARNING_NONORGANIC
#undef BLOODFLEDGE_WARNING_HEMOPHAGE
