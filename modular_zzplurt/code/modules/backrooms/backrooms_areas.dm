/area/awaymission/secret/powered/backrooms
	name = "The backrooms"
	area_flags = NO_BOH|HIDDEN_AREA|NOTELEPORT|QUIET_LOGS|BLOCK_SUICIDE

	ambientsounds = list('modular_zzplurt/sound/ambience/backrooms_level0.ogg')
	max_ambience_cooldown = 0
	min_ambience_cooldown = 0


/area/awaymission/secret/powered/backrooms/Entered(atom/movable/arrived, area/old_area)
	. = ..()
	if(isliving(arrived))
		var/mob/living/living = arrived
		living.add_fov_trait(REF(src), FOV_180_DEGREES)
		force_ambience_on(living)

/area/awaymission/secret/powered/backrooms/Exited(atom/movable/gone, direction)
	. = ..()
	if(isliving(gone))
		var/mob/living/living = gone
		living.remove_fov_trait(REF(src), FOV_180_DEGREES)
		restore_ambience_pref(living)

/**
 * Signs a client up for ambience while they are down here, whatever their preferences say.
 *
 * SSambience only ever looks at clients in its listening list, and a player who has turned their
 * ambience volume down to zero has been taken out of it entirely - so overriding play_ambience()
 * below is not on its own enough to reach them. Undone by restore_ambience_pref() on the way out.
 *
 * Safe to call more than once, and called again once the exiled actually has a client: a body is
 * moved down here before the mind is put in it, so Entered() alone fires while there is nobody home.
 */
/area/awaymission/secret/powered/backrooms/proc/force_ambience_on(mob/living/living)
	var/client/listener = living?.client
	if(isnull(listener))
		return

	if(SSambience.ambience_listening_clients[listener] > world.time)
		return

	SSambience.ambience_listening_clients[listener] = world.time

/// Puts a client back to whatever they actually chose, once they are out from under this.
/area/awaymission/secret/powered/backrooms/proc/restore_ambience_pref(mob/living/living)
	var/client/listener = living?.client
	if(isnull(listener))
		return

	listener.update_ambience_pref(listener.prefs?.read_preference(/datum/preference/numeric/volume/sound_ambience_volume))

/**
 * Played at a flat volume, deliberately ignoring the ambience volume preference.
 *
 * The hum down here is not set dressing. It is most of what tells anyone they are still in the
 * backrooms rather than anywhere else, and someone who turned station ambience off months ago should
 * not be exiled into silence for it. Nothing else about their sound settings is touched.
 */
/area/awaymission/secret/powered/backrooms/play_ambience(mob/listening_mob, sound/override_sound, volume = 27)
	var/sound/new_sound = override_sound || pick(ambientsounds)
	if(!new_sound)
		return 1 MINUTES

	new_sound = sound(new_sound, repeat = 0, wait = 0, volume = volume, channel = CHANNEL_AMBIENCE)
	SEND_SOUND(listening_mob, new_sound)

	var/sound_length = SSsounds.get_sound_length(new_sound.file)
	if(!sound_length)
		stack_trace("backrooms play_ambience failed to get soundlength from [new_sound] with a file of [new_sound.file].")

	return sound_length + rand(min_ambience_cooldown, max_ambience_cooldown)


