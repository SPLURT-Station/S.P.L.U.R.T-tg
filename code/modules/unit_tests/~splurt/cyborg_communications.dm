/// Muting disconnects both radio directions and binary, without changing saved radio settings.
/datum/unit_test/cyborg_communications

/datum/unit_test/cyborg_communications/Run()
	var/mob/living/silicon/robot/borg = EASY_ALLOCATE()
	var/obj/item/radio/borg/borg_radio = borg.radio
	TEST_ASSERT_NOTNULL(borg_radio, "Cyborg should have its built-in radio.")
	TEST_ASSERT(borg.binarycheck(), "A normal cyborg should initially have binary access.")
	TEST_ASSERT(borg_radio.can_receive(FREQ_COMMON, RADIO_NO_Z_LEVEL_RESTRICTION), "A normal cyborg should initially receive common radio.")

	// A non-default microphone setting and a disabled channel must survive a mute/unmute cycle.
	borg_radio.set_broadcasting(FALSE)
	borg_radio.channels[RADIO_CHANNEL_ENGINEERING] = FALSE
	borg_radio.channels[RADIO_CHANNEL_MEDICAL] = TRUE
	TEST_ASSERT(borg_radio.can_receive(FREQ_MEDICAL, RADIO_NO_Z_LEVEL_RESTRICTION), "An enabled department channel should initially receive radio.")
	var/list/saved_channels = borg_radio.channels.Copy()
	var/saved_frequency = borg_radio.get_frequency()
	borg.__gvb_toggle_communications(list())
	TEST_ASSERT(borg.communications_muted, "The command should mute communications.")
	TEST_ASSERT(!borg.binarycheck(), "Muted cyborgs must not receive or send binary messages.")
	TEST_ASSERT(!borg_radio.can_receive(FREQ_COMMON, RADIO_NO_Z_LEVEL_RESTRICTION), "Muted cyborgs must not receive common radio.")
	TEST_ASSERT(!borg_radio.can_receive(FREQ_MEDICAL, RADIO_NO_Z_LEVEL_RESTRICTION), "Muted cyborgs must not receive an enabled department radio channel.")
	TEST_ASSERT_EQUAL(borg_radio.talk_into_impl(borg, "test", null, list(), null, list()), NONE, "Muted cyborgs must not transmit radio.")
	TEST_ASSERT(borg_radio.get_listening(), "Muting must preserve the radio's listener preference.")

	borg.__gvb_toggle_communications(list())
	TEST_ASSERT(!borg.communications_muted, "The command should reconnect communications.")
	TEST_ASSERT(borg.binarycheck(), "Unmuting should restore binary access.")
	TEST_ASSERT(borg_radio.can_receive(FREQ_COMMON, RADIO_NO_Z_LEVEL_RESTRICTION), "Unmuting should restore common radio reception.")
	TEST_ASSERT(!borg_radio.get_broadcasting(), "Unmuting must not enable a microphone the player disabled.")
	TEST_ASSERT_EQUAL(borg_radio.get_frequency(), saved_frequency, "The tuned frequency must not change.")
	TEST_ASSERT_EQUAL(length(borg_radio.channels), length(saved_channels), "Muting must not add or remove channels.")
	for(var/channel in saved_channels)
		TEST_ASSERT_EQUAL(borg_radio.channels[channel], saved_channels[channel], "The channel preference for [channel] must not change.")

/// The command works without a radio and cannot be used while incapacitated.
/datum/unit_test/cyborg_communications_unavailable

/datum/unit_test/cyborg_communications_unavailable/Run()
	var/mob/living/silicon/robot/borg = EASY_ALLOCATE()
	QDEL_NULL(borg.radio)
	borg.__gvb_toggle_communications(list())
	TEST_ASSERT(borg.communications_muted, "A cyborg without a radio can still mute binary.")
	TEST_ASSERT(!borg.binarycheck(), "Binary should stay muted without a radio.")
	borg.__gvb_toggle_communications(list())
	TEST_ASSERT(!borg.communications_muted, "A cyborg without a radio can reconnect.")
	borg.Paralyze(10 SECONDS)
	borg.__gvb_toggle_communications(list())
	TEST_ASSERT(!borg.communications_muted, "Incapacitated cyborgs must not change communications.")

/// A user mute must never undo an independent radio shutdown.
/datum/unit_test/cyborg_communications_radio_off

/datum/unit_test/cyborg_communications_radio_off/Run()
	var/mob/living/silicon/robot/borg = EASY_ALLOCATE()
	borg.radio.set_on(FALSE)
	borg.__gvb_toggle_communications(list())
	borg.__gvb_toggle_communications(list())
	TEST_ASSERT(!borg.radio.is_on(), "Unmuting must not power on a radio that was switched off.")
	TEST_ASSERT(!borg.radio.get_listening(), "An independently disabled radio must remain silent.")
