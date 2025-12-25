/mob/living/proc/plug13_genital_emote(obj/item/organ/genital/genital, lust, duration = PLUG13_DURATION_NORMAL)

	if (!client?.plug13.is_connected)
		return

	var/emote_target = null
	switch (genital.slot)
		if (ORGAN_SLOT_PENIS, ORGAN_SLOT_TESTICLES, ORGAN_SLOT_VAGINA, ORGAN_SLOT_WOMB)
			emote_target = PLUG13_EMOTE_GROIN
		if (ORGAN_SLOT_ANUS, ORGAN_SLOT_BUTT)
			emote_target = PLUG13_EMOTE_ANUS
		if (ORGAN_SLOT_BREASTS, ORGAN_SLOT_BELLY)
			emote_target = PLUG13_EMOTE_CHEST

	if (isnull(emote_target))
		return

	client.plug13.send_emote(emote_target, clamp(lust, 10, 100), duration)
