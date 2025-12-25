/// Maps an organ slot to its corresponding Plug13 emote type
/// Returns null if the organ slot doesn't map to any emote
/proc/organ_slot_to_plug13_emote(organ_slot)
	switch(organ_slot)
		// Front/groin emotes
		if(ORGAN_SLOT_PENIS, ORGAN_SLOT_TESTICLES, ORGAN_SLOT_VAGINA, ORGAN_SLOT_WOMB, ORGAN_SLOT_SLIT, ORGAN_SLOT_SHEATH)
			return PLUG13_EMOTE_GROIN
		// Back/rear emotes
		if(ORGAN_SLOT_ANUS, ORGAN_SLOT_BUTT)
			return PLUG13_EMOTE_ANUS
		// Chest emotes
		if(ORGAN_SLOT_BREASTS, ORGAN_SLOT_NIPPLES, ORGAN_SLOT_BELLY)
			return PLUG13_EMOTE_CHEST
	return null

/// Sends a Plug13 emote based on a genital organ
/mob/living/proc/plug13_genital_emote(obj/item/organ/genital/genital, lust, duration = PLUG13_DURATION_NORMAL)
	if(!client?.plug13?.is_connected)
		return

	var/emote_target = organ_slot_to_plug13_emote(genital.slot)
	if(isnull(emote_target))
		return

	client.plug13.send_emote(emote_target, clamp(lust, 10, 100), duration)
