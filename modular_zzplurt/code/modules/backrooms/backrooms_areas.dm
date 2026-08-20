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

/// Signs a client up for ambience whatever their preferences say. SSambience only looks at clients in
/// its listening list, and a zero ambience volume takes them out of it entirely, so the
/// play_ambience() override below cannot reach them on its own. Idempotent; also called once the
/// exiled has a client, since the body is moved down here before the mind is put in it.
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

/// Flat volume, deliberately ignoring the ambience volume preference - the hum is most of what tells
/// anyone they are still down here. Nothing else about their sound settings is touched.
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


