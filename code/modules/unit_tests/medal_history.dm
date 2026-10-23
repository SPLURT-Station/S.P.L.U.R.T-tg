/// Current-round history must follow successful, first-time awards, not display names or item ownership.
/datum/unit_test/medal_history
	var/datum/splurt_medal_history/saved_history
	var/list/saved_commendations

/datum/unit_test/medal_history/New()
	. = ..()
	saved_history = GLOB.splurt_medal_history
	GLOB.splurt_medal_history = allocate(/datum/splurt_medal_history)
	saved_commendations = GLOB.commendations
	GLOB.commendations = list()

/datum/unit_test/medal_history/Destroy()
	GLOB.splurt_medal_history = saved_history
	saved_history = null
	GLOB.commendations = saved_commendations
	saved_commendations = null
	return ..()

/datum/unit_test/medal_history/Run()
	test_identity_and_snapshots()
	test_first_attachment_and_transfer()
	test_non_awards()
	test_shared_state_write_rejected()

/datum/unit_test/medal_history/proc/make_person(owner_key, display_name)
	var/mob/living/carbon/human/consistent/person = allocate(__IMPLIED_TYPE__)
	person.real_name = display_name
	person.mind = allocate(/datum/mind, owner_key)
	return person

/datum/unit_test/medal_history/proc/test_identity_and_snapshots()
	var/datum/splurt_medal_history/history = allocate(__IMPLIED_TYPE__)
	var/mob/living/carbon/human/giver = make_person("GiverOne", "Same Name")
	var/mob/living/carbon/human/recipient = make_person("RecipientOne", "Same Name")
	var/datum/splurt_medal_entry/first = new(giver, recipient, "<b>Medal & one</b>", "<script>alert('x')</script>")
	history.entries += first
	var/datum/splurt_medal_entry/second = new(giver, recipient, "Second medal", "Second reason")
	history.entries += second

	var/list/recipient_data = history.records_for("RecipientOne")
	var/list/received = recipient_data["received"]
	TEST_ASSERT_EQUAL(length(received), 2, "Two medals must retain two separate received records")
	TEST_ASSERT_EQUAL(length(recipient_data["given"]), 0, "A same-name recipient must not inherit the giver's records")
	var/list/giver_data = history.records_for("giverone")
	TEST_ASSERT_EQUAL(length(giver_data["given"]), 2, "The giver must retain both given records")
	TEST_ASSERT_EQUAL(length(giver_data["received"]), 0, "Same-name giver must not inherit recipient records")
	var/list/stranger_data = history.records_for("Stranger")
	TEST_ASSERT_EQUAL(length(stranger_data["received"]), 0, "Uninvolved accounts must not receive records")
	TEST_ASSERT_EQUAL(length(stranger_data["given"]), 0, "Uninvolved accounts must not give records")
	var/list/no_client_data = history.ui_data(recipient)
	TEST_ASSERT_EQUAL(length(no_client_data["received"]), 0, "A mob without a connected client must not obtain UI records from its mind key")
	var/list/anonymous_data = history.records_for(null)
	TEST_ASSERT_EQUAL(length(anonymous_data["received"]), 0, "Missing identity must fail closed")

	var/list/row = received[1]
	TEST_ASSERT_EQUAL(row["medal"], "<b>Medal & one</b>", "TGUI receives text, not preformatted HTML")
	TEST_ASSERT_EQUAL(row["reason"], "<script>alert('x')</script>", "The frontend must render hostile strings as text")
	TEST_ASSERT(!("giver_ckey" in row) && !("recipient_ckey" in row), "Record payload must not disclose identity keys")
	giver.real_name = "Changed Name"
	recipient.real_name = "Changed Name"
	recipient.mind.key = "ReplacementPlayer"
	var/list/after_change = history.records_for("recipientone")
	var/list/after_received = after_change["received"]
	TEST_ASSERT_EQUAL(length(after_received), 2, "Original account keeps history after character/key changes")
	var/list/after_row = after_received[1]
	TEST_ASSERT_EQUAL(after_row["recipient"], "Same Name", "Names must be award-time snapshots")
	var/list/replacement_data = history.records_for("ReplacementPlayer")
	TEST_ASSERT_EQUAL(length(replacement_data["received"]), 0, "New body owner must not inherit old account history")
	TEST_ASSERT_EQUAL(length(history.entries), 2, "Repeated reads must not mutate the history")
	TEST_ASSERT_EQUAL(first.recipient_ckey, "recipientone", "Disconnected participants use their mind's canonical identity")

/datum/unit_test/medal_history/proc/test_first_attachment_and_transfer()
	var/mob/living/carbon/human/giver = make_person("GiverTwo", "Giver")
	var/mob/living/carbon/human/recipient = make_person("RecipientTwo", "Recipient")
	var/obj/item/clothing/under/uniform = allocate(/obj/item/clothing/under/color/grey, recipient)
	var/obj/item/clothing/accessory/medal/medal = allocate(__IMPLIED_TYPE__)
	medal.commendation_message = "A real first award"
	TEST_ASSERT(giver.put_in_hands(medal), "Giver must hold medal before using the authoritative attach flow")
	var/before = length(GLOB.splurt_medal_history.entries)
	TEST_ASSERT(uniform.attach_accessory(medal, giver, attach_message = FALSE), "Award attachment should succeed")
	TEST_ASSERT_EQUAL(length(GLOB.splurt_medal_history.entries), before + 1, "One successful award should append exactly one entry")
	TEST_ASSERT_NULL(medal.pending_medal_history, "The published entry must be consumed")
	var/datum/splurt_medal_entry/entry = GLOB.splurt_medal_history.entries[before + 1]
	TEST_ASSERT_EQUAL(entry.giver_ckey, "givertwo", "The actual giver identity must be captured")
	TEST_ASSERT_EQUAL(entry.recipient_ckey, "recipienttwo", "The actual recipient identity must be captured")

	uniform.remove_accessory(medal)
	medal.forceMove(run_loc_floor_bottom_left)
	TEST_ASSERT(giver.put_in_hands(medal), "Giver must hold the transferred medal")
	TEST_ASSERT(uniform.attach_accessory(medal, giver, attach_message = FALSE), "Physical re-pin remains allowed")
	TEST_ASSERT_EQUAL(length(GLOB.splurt_medal_history.entries), before + 1, "Re-pinning an awarded medal must not add an event")
	uniform.remove_accessory(medal)
	medal.forceMove(run_loc_floor_bottom_left)
	var/mob/living/carbon/human/other = make_person("OtherRecipient", "Recipient")
	var/obj/item/clothing/under/other_uniform = allocate(/obj/item/clothing/under/color/grey, other)
	TEST_ASSERT(giver.put_in_hands(medal), "Giver must hold medal before transfer")
	TEST_ASSERT(other_uniform.attach_accessory(medal, giver, attach_message = FALSE), "Medal transfer should remain allowed")
	TEST_ASSERT_EQUAL(length(GLOB.splurt_medal_history.entries), before + 1, "Transfer must not create a new award")
	var/list/other_data = GLOB.splurt_medal_history.records_for("OtherRecipient")
	TEST_ASSERT_EQUAL(length(other_data["received"]), 0, "Owning somebody else's medal grants no history access")

/datum/unit_test/medal_history/proc/test_non_awards()
	var/mob/living/carbon/human/giver = make_person("GiverThree", "Giver")
	var/mob/living/carbon/human/recipient = make_person("RecipientThree", "Recipient")
	var/obj/item/clothing/under/uniform = allocate(/obj/item/clothing/under/color/grey, recipient)
	var/obj/item/clothing/accessory/medal/no_attacher = allocate(__IMPLIED_TYPE__)
	var/before = length(GLOB.splurt_medal_history.entries)
	TEST_ASSERT(uniform.attach_accessory(no_attacher, null, attach_message = FALSE), "No-attacher physical attachment remains valid")
	TEST_ASSERT_EQUAL(length(GLOB.splurt_medal_history.entries), before, "No-attacher path is not an award")
	var/obj/item/clothing/accessory/medal/self_medal = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT(recipient.put_in_hands(self_medal), "Recipient must hold self medal")
	TEST_ASSERT(uniform.attach_accessory(self_medal, recipient, attach_message = FALSE), "Self attachment remains valid")
	TEST_ASSERT_EQUAL(length(GLOB.splurt_medal_history.entries), before, "Self attachment is not an award")

	var/obj/item/clothing/accessory/medal/failed = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT(giver.put_in_hands(failed), "Giver must hold failed medal")
	uniform.max_number_of_accessories = 0
	TEST_ASSERT(!uniform.attach_accessory(failed, giver, attach_message = FALSE), "Capacity failure must reject attachment")
	TEST_ASSERT_EQUAL(length(GLOB.splurt_medal_history.entries), before, "Failed attachment must not append history")
	TEST_ASSERT_NULL(failed.pending_medal_history, "Failed prechecks must not stage a record")

	uniform.max_number_of_accessories = 5
	var/obj/item/clothing/accessory/medal/staged = allocate(__IMPLIED_TYPE__)
	staged.commendation_message = "Staged but never attached"
	TEST_ASSERT(staged.try_attach(uniform, giver), "Successful try_attach should stage only")
	TEST_ASSERT_EQUAL(length(GLOB.splurt_medal_history.entries), before, "try_attach alone must not publish history")
	TEST_ASSERT_NOTNULL(staged.pending_medal_history, "A valid first award should stage a record")
	qdel(staged)
	TEST_ASSERT_EQUAL(length(GLOB.splurt_medal_history.entries), before, "Deleting an uncommitted medal must not publish")

/// Exercise the real generic TGUI handler, not ui_act: read-only UIs must reject shared writes.
/datum/unit_test/medal_history/proc/test_shared_state_write_rejected()
	var/datum/splurt_medal_history/history = allocate(__IMPLIED_TYPE__)
	var/mob/living/carbon/human/giver = make_person("R1Giver", "Same Name")
	var/mob/living/carbon/human/recipient = make_person("R1Recipient", "Same Name")
	var/datum/splurt_medal_entry/entry = new(giver, recipient, "R1 medal", "R1 reason")
	history.entries += entry
	TEST_ASSERT_EQUAL(history.ui_status(null, GLOB.always_state), UI_CLOSE, "No user must never gain read or write access")
	TEST_ASSERT_EQUAL(history.ui_status(recipient, GLOB.always_state), UI_CLOSE, "A disconnected mob must not be promoted by always_state")

	var/datum/tgui/ui = allocate(__IMPLIED_TYPE__, recipient, history, "MyMedals")
	// Unit fixtures have no connected client. Inject the connected read-only status to test the actual framework gate.
	// Native two-client coverage must separately verify ui_status returns UI_UPDATE for connected users.
	ui.status = UI_UPDATE
	ui.on_message("setSharedState", null, list("key" = "r1_marker", "value" = "forged value"))
	TEST_ASSERT_NULL(history.tgui_shared_states, "Generic setSharedState must not create shared state at UI_UPDATE")
	var/list/recipient_data = history.records_for("r1recipient")
	var/list/giver_data = history.records_for("r1giver")
	TEST_ASSERT_EQUAL(length(recipient_data["received"]), 1, "Read-only status must retain the recipient's records")
	TEST_ASSERT_EQUAL(length(recipient_data["given"]), 0, "Recipient must not receive same-name giver records")
	TEST_ASSERT_EQUAL(length(giver_data["given"]), 1, "Read-only status must retain the giver's records")
	TEST_ASSERT_EQUAL(length(giver_data["received"]), 0, "Giver must not receive same-name recipient records")

	// Positive control: this same real handler can write when explicitly given interactive authority.
	ui.status = UI_INTERACTIVE
	ui.on_message("setSharedState", null, list("key" = "r1_marker", "value" = "control value"))
	TEST_ASSERT_NOTNULL(history.tgui_shared_states, "Interactive control must reach the generic shared-state branch")
	TEST_ASSERT_EQUAL(history.tgui_shared_states["r1_marker"], "control value", "Control write should be visible on this isolated fixture")
	ui.status = UI_UPDATE
	ui.on_message("setSharedState", null, list("key" = "r1_marker", "value" = "replacement value"))
	TEST_ASSERT_EQUAL(history.tgui_shared_states["r1_marker"], "control value", "Read-only status must also reject overwriting existing shared state")
	TEST_ASSERT_EQUAL(length(history.entries), 1, "Neither rejected messages nor the control may modify medal entries")
