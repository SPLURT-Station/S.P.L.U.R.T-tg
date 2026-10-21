/datum/unit_test/borg_comms
	abstract_type = /datum/unit_test/borg_comms
	var/radio_heard = 0
	var/local_heard = 0
	var/radio_received = 0
	var/radio_sent = 0
	var/list/temporary_players

/datum/unit_test/borg_comms/Destroy()
	for(var/mob/player as anything in temporary_players)
		GLOB.player_list -= player
	return ..()

/datum/unit_test/borg_comms/proc/make_borg(turf/location)
	var/mob/living/silicon/robot/borg = allocate(/mob/living/silicon/robot/comms_test, location || run_loc_floor_bottom_left, null, null, FALSE, FALSE)
	borg.mock_client = new /datum/client_interface()
	return borg

/datum/unit_test/borg_comms/proc/watch_hearing(mob/listener)
	RegisterSignal(listener, COMSIG_MOVABLE_HEAR, PROC_REF(on_hear))

/datum/unit_test/borg_comms/proc/on_hear(datum/source, list/hearing_args)
	SIGNAL_HANDLER
	if(hearing_args[HEARING_RADIO_FREQ])
		radio_heard++
	else
		local_heard++

/datum/unit_test/borg_comms/proc/on_receive(datum/source, list/data)
	SIGNAL_HANDLER
	radio_received++

/datum/unit_test/borg_comms/proc/on_send(datum/source, mob/living/user, message, channel)
	SIGNAL_HANDLER
	radio_sent++

/datum/unit_test/borg_comms/proc/tune_radio(obj/item/radio/device)
	device.special_channels |= RADIO_SPECIAL_CENTCOM
	device.set_frequency(FREQ_CENTCOM)
	device.set_listening(TRUE)

/datum/unit_test/borg_comms/proc/add_binary_listener(mob/listener)
	if(!(listener in GLOB.player_list))
		LAZYADD(temporary_players, listener)
		GLOB.player_list += listener

// Records eligibility at the actual robot_talk distribution loop; no client output is faked.
/mob/living/silicon/robot/comms_test
	var/binary_deliveries = 0
	var/radio_audio_checks = 0
	var/radio_audio_allowed = 0

/mob/living/silicon/robot/comms_test/binarycheck()
	. = ..()
	if(.)
		binary_deliveries++

/mob/living/silicon/robot/comms_test/can_receive_radio_communications()
	radio_audio_checks++
	. = ..()
	if(.)
		radio_audio_allowed++

/datum/unit_test/borg_comms/integrated_radio/Run()
	var/mob/living/carbon/human/consistent/speaker = allocate(__IMPLIED_TYPE__)
	var/mob/living/silicon/robot/borg = make_borg(locate(run_loc_floor_bottom_left.x + 10, run_loc_floor_bottom_left.y, run_loc_floor_bottom_left.z))
	var/obj/item/radio/transmitter = allocate(__IMPLIED_TYPE__)
	tune_radio(transmitter)
	tune_radio(borg.radio)
	watch_hearing(borg)
	RegisterSignal(borg.radio, COMSIG_RADIO_RECEIVE_MESSAGE, PROC_REF(on_receive))
	transmitter.talk_into(speaker, "Communications baseline.")
	TEST_ASSERT(radio_received > 0 && radio_heard > 0, "The baseline real radio broadcast must reach the integrated receiver and borg Hear")
	radio_received = 0
	radio_heard = 0
	borg.set_comms_muted(TRUE)
	transmitter.talk_into(speaker, "Muted integrated receiver.")
	TEST_ASSERT(!radio_received && !radio_heard, "Muted integrated radio must not receive or deliver the broadcast")
	borg.set_comms_muted(FALSE)
	transmitter.talk_into(speaker, "Communications restored.")
	TEST_ASSERT(radio_received > 0 && radio_heard > 0, "Unmuting must restore actual radio reception")

/datum/unit_test/borg_comms/nearby_radio/Run()
	var/mob/living/carbon/human/consistent/speaker = allocate(__IMPLIED_TYPE__)
	var/mob/living/silicon/robot/borg = make_borg(locate(run_loc_floor_bottom_left.x + 10, run_loc_floor_bottom_left.y, run_loc_floor_bottom_left.z))
	var/obj/item/radio/transmitter = allocate(__IMPLIED_TYPE__)
	var/obj/item/radio/nearby = allocate(__IMPLIED_TYPE__, get_turf(borg))
	tune_radio(transmitter)
	tune_radio(nearby)
	watch_hearing(borg)
	RegisterSignal(nearby, COMSIG_RADIO_RECEIVE_MESSAGE, PROC_REF(on_receive))
	borg.set_comms_muted(TRUE)
	transmitter.talk_into(speaker, "Nearby receiver bypass attempt.")
	TEST_ASSERT(radio_received > 0, "The independent nearby radio must still receive the actual broadcast")
	TEST_ASSERT(!radio_heard, "A nearby radio must not bypass the borg's communications switch")
	borg.set_comms_muted(FALSE)
	transmitter.talk_into(speaker, "Nearby receiver restored.")
	TEST_ASSERT(radio_heard > 0, "Unmuting must restore nearby radio hearing")

/datum/unit_test/borg_comms/local_conversation/Run()
	var/mob/living/silicon/robot/borg = make_borg()
	var/mob/living/carbon/human/consistent/human = allocate(__IMPLIED_TYPE__)
	human.mock_client = new /datum/client_interface()
	watch_hearing(borg)
	borg.set_comms_muted(TRUE)
	human.say("Local conversation remains available.")
	TEST_ASSERT(local_heard > 0, "Muted borg must still hear real nearby speech")
	local_heard = 0
	human.whisper("Local whisper remains available.")
	TEST_ASSERT(local_heard > 0, "Muted borg must still hear nearby whispers")
	UnregisterSignal(borg, COMSIG_MOVABLE_HEAR)
	watch_hearing(human)
	local_heard = 0
	borg.say("The borg can still reply locally.")
	TEST_ASSERT(local_heard > 0, "Muting must not prevent the borg's local reply from reaching a human")
	TEST_ASSERT(!HAS_TRAIT(borg, TRAIT_DEAF), "The communications switch must not deafen the borg")

/datum/unit_test/borg_comms/transmission/Run()
	var/mob/living/silicon/robot/borg = make_borg()
	var/obj/item/radio/receiver = allocate(__IMPLIED_TYPE__, locate(run_loc_floor_bottom_left.x + 10, run_loc_floor_bottom_left.y, run_loc_floor_bottom_left.z))
	tune_radio(borg.radio)
	tune_radio(receiver)
	RegisterSignal(receiver, COMSIG_RADIO_RECEIVE_MESSAGE, PROC_REF(on_receive))
	RegisterSignal(borg.radio, COMSIG_RADIO_NEW_MESSAGE, PROC_REF(on_send))
	borg.set_comms_muted(TRUE)
	borg.radio.talk_into(borg, "Disabled radio transmission.")
	TEST_ASSERT(!radio_sent && !radio_received, "Muted integrated radio must reject transmission before emitting its signal")
	borg.radio.talk_into_impl(borg, "Previously queued transmission.", null, list(), borg.get_selected_language(), list())
	TEST_ASSERT(!radio_received, "Asynchronous transmission entry must recheck the switch")
	TEST_ASSERT(borg.radio("Radio prefix.", list(MODE_HEADSET = TRUE), list(), borg.get_selected_language()) & NOPASS, "Muted radio-prefixed speech must be consumed without falling back to local speech")
	borg.set_comms_muted(FALSE)
	borg.radio.talk_into(borg, "Restored transmission.")
	TEST_ASSERT(radio_sent > 0 && radio_received > 0, "Unmuting must restore actual integrated radio transmission")

	// The normal radio UI can disable subspace mode. With no telecomms response,
	// talk_into_impl schedules its real fallback callback for two seconds later.
	qdel(borg.radio)
	var/obj/item/radio/borg/comms_test/fallback_radio = allocate(__IMPLIED_TYPE__, borg)
	borg.radio = fallback_radio
	fallback_radio.subspace_transmission = FALSE
	fallback_radio.special_channels = NONE
	fallback_radio.set_frequency(FREQ_CTF_RED)
	receiver.special_channels = NONE
	receiver.set_frequency(FREQ_CTF_RED)
	radio_received = 0
	fallback_radio.talk_into(borg, "Delayed fallback baseline.")
	TEST_ASSERT(!radio_received && !fallback_radio.fallback_attempts, "Fallback baseline must be queued, not an immediate telecomms broadcast")
	sleep(3 SECONDS) // Real two-second timer, with one second of scheduling margin.
	TEST_ASSERT(fallback_radio.fallback_attempts == 1 && !fallback_radio.last_fallback_was_done, "The real fallback callback must execute for an undelivered signal")
	TEST_ASSERT(radio_received > 0, "Unmuted fallback must reach the actual receiver")

	radio_received = 0
	fallback_radio.talk_into(borg, "Mute before queued fallback.")
	TEST_ASSERT(!radio_received && fallback_radio.fallback_attempts == 1, "The second fallback must still be pending before muting")
	borg.set_comms_muted(TRUE)
	sleep(3 SECONDS)
	TEST_ASSERT(fallback_radio.fallback_attempts == 2 && !fallback_radio.last_fallback_was_done, "Muted case must reach the real queued callback, not pass by skipping the timer")
	TEST_ASSERT(!radio_received, "Muting after transmission is queued must suppress its delayed broadcast")

	borg.set_comms_muted(FALSE)
	fallback_radio.talk_into(borg, "Delayed fallback restored.")
	TEST_ASSERT(!radio_received && fallback_radio.fallback_attempts == 2, "Restored fallback must also take the delayed path")
	sleep(3 SECONDS)
	TEST_ASSERT(fallback_radio.fallback_attempts == 3 && !fallback_radio.last_fallback_was_done && radio_received > 0, "Unmuting must restore actual delayed fallback delivery")

/datum/unit_test/borg_comms/binary_routing/Run()
	var/mob/living/silicon/robot/sender = make_borg()
	var/mob/living/silicon/robot/comms_test/listener = make_borg()
	var/mob/living/silicon/robot/comms_test/control = make_borg()
	add_binary_listener(listener)
	add_binary_listener(control)
	sender.robot_talk("Binary baseline.")
	TEST_ASSERT(listener.binary_deliveries > 0 && control.binary_deliveries > 0, "Actual binary distribution must include both listeners initially")
	listener.binary_deliveries = 0
	control.binary_deliveries = 0
	listener.set_comms_muted(TRUE)
	sender.robot_talk("Binary recipient muted.")
	TEST_ASSERT(!listener.binary_deliveries && control.binary_deliveries > 0, "Binary routing must skip only the muted borg")
	control.binary_deliveries = 0
	sender.set_comms_muted(TRUE)
	sender.robot_talk("Binary sender muted.")
	TEST_ASSERT(!control.binary_deliveries, "Muted sender must not distribute a binary message")
	sender.set_comms_muted(FALSE)
	listener.set_comms_muted(FALSE)
	sender.robot_talk("Binary restored.")
	TEST_ASSERT(listener.binary_deliveries > 0 && control.binary_deliveries > 0, "Unmuting must restore actual binary distribution")

/datum/unit_test/borg_comms/settings_and_replacement/Run()
	var/mob/living/silicon/robot/borg = make_borg()
	TEST_ASSERT(/mob/living/silicon/robot/verb/toggle_comms in borg.verbs, "Borg must expose the communications verb")
	INVOKE_GAME_VERB(borg, borg, /mob/living/silicon/robot, toggle_comms)
	TEST_ASSERT(borg.comms_muted, "The real game verb must disable communications")
	INVOKE_GAME_VERB(borg, borg, /mob/living/silicon/robot, toggle_comms)
	TEST_ASSERT(!borg.comms_muted, "The real game verb must re-enable communications")
	QDEL_NULL(borg.radio.keyslot)
	borg.radio.keyslot = new /obj/item/encryptionkey/headset_eng(borg.radio)
	borg.radio.recalculateChannels()
	TEST_ASSERT(borg.radio.channels[RADIO_CHANNEL_ENGINEERING], "Engineering key must enable its real channel before testing preservation")
	borg.radio.channels[RADIO_CHANNEL_ENGINEERING] = 0
	borg.radio.set_listening(FALSE)
	borg.radio.set_broadcasting(FALSE)
	borg.set_comms_muted(TRUE)
	borg.set_comms_muted(FALSE)
	TEST_ASSERT(!borg.radio.get_listening() && !borg.radio.get_broadcasting(), "Unmuting must preserve independently disabled microphone and speaker")
	TEST_ASSERT(borg.radio.channels[RADIO_CHANNEL_ENGINEERING] == 0, "Unmuting must not enable a disabled channel")
	borg.radio.set_on(FALSE)
	borg.set_comms_muted(TRUE)
	borg.set_comms_muted(FALSE)
	TEST_ASSERT(!borg.radio.is_on(), "Unmuting must not power on disabled hardware")
	borg.radio.set_on(TRUE)
	TEST_ASSERT(!borg.radio.get_listening() && !borg.radio.get_broadcasting(), "Hardware recovery must retain the user's independent preferences")
	borg.set_comms_muted(TRUE)
	qdel(borg.radio)
	borg.radio = new /obj/item/radio/borg(borg)
	tune_radio(borg.radio)
	TEST_ASSERT(!borg.radio.can_receive(FREQ_CENTCOM, RADIO_NO_Z_LEVEL_RESTRICTION), "Replacing the integrated radio must not bypass the master switch")
	borg.radio.set_on(FALSE)
	borg.radio.set_on(TRUE)
	TEST_ASSERT(!borg.radio.can_receive(FREQ_CENTCOM, RADIO_NO_Z_LEVEL_RESTRICTION), "Hardware off/on must not bypass the master switch")
	borg.set_comms_muted(FALSE)
	TEST_ASSERT(borg.radio.can_receive(FREQ_CENTCOM, RADIO_NO_Z_LEVEL_RESTRICTION), "The replacement radio must work after unmuting")

/datum/unit_test/borg_comms/tts_dispatch_gates/Run()
	TEST_ASSERT(!can_hear_radio_tts(null, FREQ_COMMON), "A missing radio TTS recipient must remain safely ineligible")
	var/mob/living/silicon/robot/comms_test/borg = make_borg()
	borg.set_comms_muted(TRUE)
	TEST_ASSERT(!can_hear_radio_tts(borg, FREQ_COMMON), "Muted borg must be excluded at radio TTS recipient selection")
	TEST_ASSERT(borg.radio_audio_checks == 1 && !borg.radio_audio_allowed, "Radio TTS selection must consult the communications switch")
	borg.radio_audio_checks = 0
	// Exercise the real queued playback dispatcher without HTTP requests or synthesized audio.
	SStts.play_tts(WEAKREF(borg.radio), list(borg), sound(), sound(), borg.get_selected_language(), ignore_observers = TRUE, volume_signal = COMSIG_MOB_TTS_RADIO_VOLUME_PREFERENCE_APPLIED)
	TEST_ASSERT(borg.radio_audio_checks == 1 && !borg.radio_audio_allowed, "Already queued radio playback must recheck and reject a now-muted recipient")
	borg.radio_audio_checks = 0
	SStts.play_tts(WEAKREF(borg), list(borg), sound(), sound(), borg.get_selected_language(), ignore_observers = TRUE)
	TEST_ASSERT(!borg.radio_audio_checks, "Local speech playback must not use the radio mute gate")
	borg.set_comms_muted(FALSE)
	SStts.play_tts(WEAKREF(borg.radio), list(borg), sound(), sound(), borg.get_selected_language(), ignore_observers = TRUE, volume_signal = COMSIG_MOB_TTS_RADIO_VOLUME_PREFERENCE_APPLIED)
	TEST_ASSERT(borg.radio_audio_checks == 1 && borg.radio_audio_allowed == 1, "Unmuting must allow queued radio playback through the communications gate")

// Observe the real delayed fallback entry and then execute its complete production path.
/obj/item/radio/borg/comms_test
	var/fallback_attempts = 0
	var/last_fallback_was_done = FALSE

/obj/item/radio/borg/comms_test/backup_transmission(datum/signal/subspace/vocal/signal)
	fallback_attempts++
	last_fallback_was_done = !!signal.data["done"]
	return ..()
