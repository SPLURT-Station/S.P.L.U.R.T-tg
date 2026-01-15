/// MKUltra command helper coverage for SPLURT extensions.

// Provide a local fallback when FULLY_ENTHRALLED is not pulled in by test defines.
#ifdef FULLY_ENTHRALLED
#define MKU_FULLY_ENTHRALLED FULLY_ENTHRALLED
#else
#define MKU_FULLY_ENTHRALLED 3
#endif

/// Pet chip should be our Mk.2 variant.
/datum/unit_test/mkultra_pet_chip_mk2_name
	focus = TRUE
/datum/unit_test/mkultra_pet_chip_mk2_name/Run()
	var/obj/item/skillchip/mk2pet/chip = new
	TEST_ASSERT(findtext(chip.name, "Mk.2"), "MKUltra pet chip should be the Mk.2 variant")

// Simple enthrall stubs so we can exercise MKUltra helpers without wiring the full chem flow.
/datum/status_effect/chem/enthrall/unit_test
	/// Capture the master provided via apply_status_effect for test helpers.
/datum/status_effect/chem/enthrall/unit_test/New(mob/living/carbon/human/owner, mob/living/master)
		enthrall_mob = master
		enthrall_ckey = master?.ckey || "unit-test"
		enthrall_gender = "master"
		phase = MKU_FULLY_ENTHRALLED
		lewd = TRUE
		mental_capacity = 500
		return ..()

/datum/status_effect/chem/enthrall/unit_test/on_apply()
		return TRUE

/datum/status_effect/chem/enthrall/pet_chip/unit_test
/datum/status_effect/chem/enthrall/pet_chip/unit_test/New(mob/living/carbon/human/owner, mob/living/master)
		enthrall_mob = master
		enthrall_ckey = master?.ckey || "unit-test"
		enthrall_gender = "master"
		phase = MKU_FULLY_ENTHRALLED
		lewd = TRUE
		distance_mood_enabled = FALSE
		return ..()

/datum/status_effect/chem/enthrall/pet_chip/unit_test/on_apply()
		return TRUE

/datum/status_effect/chem/enthrall/pet_chip/mk2/unit_test
/datum/status_effect/chem/enthrall/pet_chip/mk2/unit_test/New(mob/living/carbon/human/owner, mob/living/master)
		enthrall_mob = master
		enthrall_ckey = master?.ckey || "unit-test"
		enthrall_gender = "master"
		phase = MKU_FULLY_ENTHRALLED
		lewd = TRUE
		distance_mood_enabled = FALSE
		cooldown = 0
		return ..()

/datum/status_effect/chem/enthrall/pet_chip/mk2/unit_test/on_apply()
		return TRUE

/datum/unit_test/mkultra_cum_lock
	focus = TRUE
/datum/unit_test/mkultra_cum_lock/Run()
	var/mob/living/carbon/human/humanoid = allocate(/mob/living/carbon/human/consistent)
	TEST_ASSERT(!HAS_TRAIT(humanoid, TRAIT_NEVERBONER), "Cum lock should start inactive")

	mkultra_set_cum_lock(humanoid, TRUE)
	TEST_ASSERT(HAS_TRAIT(humanoid, TRAIT_NEVERBONER), "Cum lock should add climax-blocking trait")
	TEST_ASSERT(mkultra_cum_locks[humanoid], "Cum lock map should track locked humanoid")

	mkultra_set_cum_lock(humanoid, FALSE)
	TEST_ASSERT(!HAS_TRAIT(humanoid, TRAIT_NEVERBONER), "Cum lock should remove climax-blocking trait on clear")
	TEST_ASSERT(!(humanoid in mkultra_cum_locks), "Cum lock map should drop humanoid on clear")

/// Arousal lock forces penis arousal state and cleans up state.
/datum/unit_test/mkultra_arousal_lock
	focus = TRUE
/datum/unit_test/mkultra_arousal_lock/Run()
	var/mob/living/carbon/human/humanoid = allocate(/mob/living/carbon/human/consistent)
	var/obj/item/organ/genital/penis/penis = humanoid.get_organ_slot(ORGAN_SLOT_PENIS)
	if(!penis)
		penis = allocate(/obj/item/organ/genital/penis)
		penis.Insert(humanoid, special = TRUE, movement_flags = DELETE_IF_REPLACED)
	penis.aroused = AROUSAL_NONE

	mkultra_set_arousal_lock(humanoid, "hard")
	TEST_ASSERT_EQUAL(penis.aroused, AROUSAL_FULL, "Hard lock should force full arousal")
	TEST_ASSERT(mkultra_arousal_locks[humanoid] == "hard", "Lock map should store hard state")

	mkultra_set_arousal_lock(humanoid, "limp")
	TEST_ASSERT_EQUAL(penis.aroused, AROUSAL_NONE, "Limp lock should force no arousal")
	TEST_ASSERT(mkultra_arousal_locks[humanoid] == "limp", "Lock map should store limp state")

	mkultra_clear_arousal_lock(humanoid)
	TEST_ASSERT(!(humanoid in mkultra_arousal_locks), "Clearing arousal lock should remove map entry")

/// Heat toggle applies/removes hypersexual quirk and tracks state.
/datum/unit_test/mkultra_heat_toggle
	focus = TRUE
/datum/unit_test/mkultra_heat_toggle/Run()
	var/mob/living/carbon/human/humanoid = allocate(/mob/living/carbon/human/consistent)
	if(humanoid.has_quirk(/datum/quirk/hypersexual))
		humanoid.remove_quirk(/datum/quirk/hypersexual)

	mkultra_set_heat(humanoid, TRUE)
	TEST_ASSERT(humanoid.has_quirk(/datum/quirk/hypersexual), "Heat toggle should add hypersexual quirk")
	TEST_ASSERT(mkultra_heat_states[humanoid], "Heat state map should track humanoid when on")

	mkultra_set_heat(humanoid, FALSE)
	TEST_ASSERT(!humanoid.has_quirk(/datum/quirk/hypersexual), "Heat toggle should remove hypersexual quirk")
	TEST_ASSERT(!(humanoid in mkultra_heat_states), "Heat state map should drop humanoid when off")

/// Well trained toggle applies/removes quirk and tracks state.
/datum/unit_test/mkultra_well_trained_toggle
	focus = TRUE
/datum/unit_test/mkultra_well_trained_toggle/Run()
	var/mob/living/carbon/human/humanoid = allocate(/mob/living/carbon/human/consistent)
	if(humanoid.has_quirk(/datum/quirk/well_trained))
		humanoid.remove_quirk(/datum/quirk/well_trained)

	mkultra_set_well_trained(humanoid, TRUE)
	TEST_ASSERT(humanoid.has_quirk(/datum/quirk/well_trained), "Well trained toggle should add quirk")
	TEST_ASSERT(mkultra_well_trained_states[humanoid], "Well trained map should track humanoid when on")

	mkultra_set_well_trained(humanoid, FALSE)
	TEST_ASSERT(!humanoid.has_quirk(/datum/quirk/well_trained), "Well trained toggle should remove quirk")
	TEST_ASSERT(!(humanoid in mkultra_well_trained_states), "Well trained map should drop humanoid when off")

/// Sissy mode applies limp arousal lock, well-trained quirk, and tracks state; clearing removes everything.
/datum/unit_test/mkultra_sissy_mode
	focus = TRUE
/datum/unit_test/mkultra_sissy_mode/Run()
	var/mob/living/carbon/human/master = allocate(/mob/living/carbon/human/consistent)
	var/mob/living/carbon/human/humanoid = allocate(/mob/living/carbon/human/consistent)
	var/obj/item/organ/genital/penis/penis = humanoid.get_organ_slot(ORGAN_SLOT_PENIS)
	if(!penis)
		penis = allocate(/obj/item/organ/genital/penis)
		penis.Insert(humanoid, special = TRUE, movement_flags = DELETE_IF_REPLACED)

	humanoid.apply_status_effect(/datum/status_effect/chem/enthrall/unit_test, master)
	var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
	enthrall_chem.enthrall_mob = master
	enthrall_chem.lewd = TRUE
	enthrall_chem.phase = MKU_FULLY_ENTHRALLED
	mkultra_start_sissy(humanoid, master)
	TEST_ASSERT(mkultra_sissy_states[humanoid], "Sissy start should record state for humanoid")
	TEST_ASSERT(humanoid.has_quirk(/datum/quirk/well_trained), "Sissy start should grant well-trained quirk")
	TEST_ASSERT_EQUAL(penis.aroused, AROUSAL_NONE, "Sissy start should limp-lock the penis")

	mkultra_clear_sissy(humanoid)
	TEST_ASSERT(!(humanoid in mkultra_sissy_states), "Sissy clear should drop tracking state")
	TEST_ASSERT(!humanoid.has_quirk(/datum/quirk/well_trained), "Sissy clear should remove well-trained quirk")
	TEST_ASSERT(!(humanoid in mkultra_arousal_locks), "Sissy clear should remove arousal lock entry")

/// Sissy-friendly filter matches girly gear names and rejects neutral ones.
/datum/unit_test/mkultra_sissy_friendly_filter
	focus = TRUE
/datum/unit_test/mkultra_sissy_friendly_filter/Run()
	var/obj/item/clothing/under/plain = allocate(/obj/item/clothing/under/color/grey)
	plain.name = "janitor jumpsuit"
	TEST_ASSERT(!mkultra_is_sissy_friendly(plain), "Neutral clothing should not be sissy friendly")
	var/obj/item/clothing/under/dress = allocate(/obj/item/clothing/under/color/blue)
	dress.name = "latex maid dress"
	TEST_ASSERT(mkultra_is_sissy_friendly(dress), "Feminine clothing names should be sissy friendly")

/// Strip-all helper should drop all worn gear (except held items) and report count.
/datum/unit_test/mkultra_strip_all_helper
	focus = TRUE
/datum/unit_test/mkultra_strip_all_helper/Run()
	var/mob/living/carbon/human/humanoid = allocate(/mob/living/carbon/human/consistent)
	var/obj/item/clothing/under/color/grey/under = allocate(/obj/item/clothing/under/color/grey)
	var/obj/item/clothing/shoes/sneakers/black/shoes = allocate(/obj/item/clothing/shoes/sneakers/black)
	humanoid.equip_to_slot_or_del(under, ITEM_SLOT_ICLOTHING)
	humanoid.equip_to_slot_or_del(shoes, ITEM_SLOT_FEET)
	var/removed = mkultra_strip_all(humanoid)
	TEST_ASSERT(removed >= 2, "Strip-all should remove worn clothing")
	TEST_ASSERT(!humanoid.get_item_by_slot(ITEM_SLOT_ICLOTHING) && !humanoid.get_item_by_slot(ITEM_SLOT_FEET), "Strip-all should leave slots empty")

/// Mk.2 enthralls should route modular commands; base enthralls should ignore them.
/datum/unit_test/mkultra_modular_dispatch_mk2
	focus = TRUE
/datum/unit_test/mkultra_modular_dispatch_mk2/Run()
	var/mob/living/carbon/human/master = allocate(/mob/living/carbon/human/consistent)
	var/mob/living/carbon/human/pet = allocate(/mob/living/carbon/human/consistent)
	// Ensure both are in range for get_hearers_in_view.
	master.forceMove(locate(1, 1, 1))
	pet.forceMove(locate(1, 2, 1))
	pet.apply_status_effect(/datum/status_effect/chem/enthrall/pet_chip/mk2/unit_test, master)
	var/datum/status_effect/chem/enthrall/pet_chip/mk2/unit_test/effect = pet.has_status_effect(/datum/status_effect/chem/enthrall/pet_chip/mk2/unit_test)
	TEST_ASSERT(effect, "Mk.2 unit test effect should be applied")
	var/result = mkultra_handle_base_commands("mkdebug phase 1", master)
	TEST_ASSERT_EQUAL(effect.phase, 1, "Mk.2 enthrall should be handled by modular commands")
	TEST_ASSERT_EQUAL(result, 0, "Modular handling should short-circuit base commands")

/datum/unit_test/mkultra_modular_dispatch_mk1
	focus = TRUE
/datum/unit_test/mkultra_modular_dispatch_mk1/Run()
	var/mob/living/carbon/human/master = allocate(/mob/living/carbon/human/consistent)
	var/mob/living/carbon/human/pet = allocate(/mob/living/carbon/human/consistent)
	master.forceMove(locate(1, 1, 1))
	pet.forceMove(locate(1, 2, 1))
	pet.apply_status_effect(/datum/status_effect/chem/enthrall/unit_test, master)
	var/datum/status_effect/chem/enthrall/unit_test/effect = pet.has_status_effect(/datum/status_effect/chem/enthrall/unit_test)
	TEST_ASSERT(effect, "Mk.1 unit test effect should be applied")
	var/old_phase = effect.phase
	var/result = mkultra_handle_base_commands("mkdebug phase 1", master)
	TEST_ASSERT_EQUAL(effect.phase, old_phase, "Non-Mk.2 enthralls should ignore modular-only commands")
	TEST_ASSERT_EQUAL(result, 0, "Base handler should still return even when nothing processed")

/// Piss-self command forces bladder urination when enthralled and enough urine is stored.
/datum/unit_test/mkultra_piss_self_command
	focus = TRUE
/datum/unit_test/mkultra_piss_self_command/Run()
	var/mob/living/carbon/human/master = allocate(/mob/living/carbon/human/consistent)
	var/mob/living/carbon/human/humanoid = allocate(/mob/living/carbon/human/consistent)
	humanoid.apply_status_effect(/datum/status_effect/chem/enthrall/unit_test, master)
	var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
	enthrall_chem.enthrall_mob = master
	enthrall_chem.lewd = TRUE
	enthrall_chem.phase = MKU_FULLY_ENTHRALLED
	var/obj/item/organ/bladder/bladder = humanoid.get_organ_slot(ORGAN_SLOT_BLADDER)
	bladder.stored_piss = bladder.piss_dosage * 2
	var/success = process_mkultra_command_piss_self("piss yourself", master, list(humanoid), 1)
	TEST_ASSERT(success, "Piss-self command should be handled")
	TEST_ASSERT(bladder.stored_piss < bladder.piss_dosage * 2, "Piss-self should reduce stored piss")

/// Pet tether toggle should flip distance mood for pet chip enthralls.
/datum/unit_test/mkultra_pet_tether_toggle
	focus = TRUE
/datum/unit_test/mkultra_pet_tether_toggle/Run()
	var/mob/living/carbon/human/master = allocate(/mob/living/carbon/human/consistent)
	var/mob/living/carbon/human/pet = allocate(/mob/living/carbon/human/consistent)
	pet.apply_status_effect(/datum/status_effect/chem/enthrall/pet_chip/unit_test, master)
	var/datum/status_effect/chem/enthrall/pet_chip/enthrall_chem = pet.has_status_effect(/datum/status_effect/chem/enthrall/pet_chip)
	enthrall_chem.enthrall_mob = master
	enthrall_chem.lewd = TRUE
	enthrall_chem.phase = MKU_FULLY_ENTHRALLED
	var/enabled = process_mkultra_command_pet_tether("tether mood on", master, list(pet), 1)
	TEST_ASSERT(enabled, "Pet tether enable should be handled")
	TEST_ASSERT(enthrall_chem.distance_mood_enabled, "Pet tether enable should set distance mood on")
	process_mkultra_command_pet_tether("tether mood off", master, list(pet), 1)
	TEST_ASSERT(!enthrall_chem.distance_mood_enabled, "Pet tether disable should set distance mood off")
