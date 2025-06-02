/obj/item/jukebox
	name = "Handled Jukebox"
	desc = "A classic music player."
	icon_state = "raiqbawks"
	base_icon_state = "raiqbawks"
	inhand_icon_state = "raiqbawks"
	icon = 'modular_zzz/icons/obj/boombox.dmi'
	righthand_file = 'modular_zzz/icons/obj/boombox_righthand.dmi'
	lefthand_file = 'modular_zzz/icons/obj/boombox_lefthand.dmi'
	verb_say = "states"
	/// Cooldown between "Error" sound effects being played
	COOLDOWN_DECLARE(jukebox_error_cd)
	/// Cooldown between being allowed to play another song
	COOLDOWN_DECLARE(jukebox_song_cd)
	COOLDOWN_DECLARE(add_to_queue_cd)
	/// TimerID to when the current song ends
	var/song_timerid
	/// The actual music player datum that handles the music
	var/datum/jukebox/music_player

/obj/item/jukebox/Initialize(mapload)
	. = ..()
	music_player = new(src)

/obj/item/jukebox/process()
	if(music_player?.active_song_sound)
		if(world.time >= music_player.stop_time)
			var/datum/track/last_track = music_player.selection
			music_player.active_song_sound = null
			music_player.selection = null
			if(last_track && music_player.sound_loops)
				activate_music(last_track)
			else if(music_player.queuedplaylist_songnames.len)
				activate_music()
			else
				playsound(src,'sound/machines/terminal/terminal_off.ogg',50,1)
				update_icon()
				music_player.stop_time = 0
				stop_music()

/obj/item/jukebox/Destroy()
	stop_music()
	QDEL_NULL(music_player)
	return ..()

/obj/item/jukebox/update_icon_state()
	icon_state = "[base_icon_state][music_player.active_song_sound ? "-active" : null]"
	return ..()

/obj/item/jukebox/ui_status(mob/user, datum/ui_state/state)
	if(isobserver(user))
		return ..()
	if(!allowed(user))
		to_chat(user,span_warning("Error: Access Denied."))
		user.playsound_local(src, 'sound/machines/compiler/compiler-failure.ogg', 25, TRUE)
		return UI_CLOSE
	if(!length(music_player.songs))
		to_chat(user,span_warning("Error: No music tracks have been authorized for your station. Petition Central Command to resolve this issue."))
		user.playsound_local(src, 'sound/machines/compiler/compiler-failure.ogg', 25, TRUE)
		return UI_CLOSE
	return ..()

/obj/item/jukebox/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Jukebox", name)
		ui.open()

/obj/item/jukebox/ui_data(mob/user)
	return music_player.get_ui_data()

/obj/item/jukebox/ui_act(action, list/params,  datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle")
			if(isnull(music_player.active_song_sound))
				if(!COOLDOWN_FINISHED(src, jukebox_song_cd))
					to_chat(usr, span_warning("Error: The device is still resetting from the last activation, \
						it will be ready again in [DisplayTimeText(COOLDOWN_TIMELEFT(src, jukebox_song_cd))]."))
					if(COOLDOWN_FINISHED(src, jukebox_error_cd))
						playsound(src, 'sound/machines/compiler/compiler-failure.ogg', 33, TRUE)
						COOLDOWN_START(src, jukebox_error_cd, 15 SECONDS)
					return TRUE

				activate_music()
			else
				stop_music()

			return TRUE

		if("add_to_queue")
			// Проверяем, если кулдаун еще не закончился, блокируем действие
			if(!COOLDOWN_FINISHED(src, add_to_queue_cd))
				to_chat(usr, span_warning("Пожалуйста, подождите перед добавлением следующего трека."))
				return TRUE

			var/selected = params["track"]
			music_player.queuedplaylist_songnames += selected
			say("[selected] has been added to the queue.")
			COOLDOWN_START(src, add_to_queue_cd, 10 DECISECONDS)
			return TRUE

		if ("random_song")
			music_player.queuedplaylist_songnames += pick(music_player.songs)
			return TRUE

		if("select_track")
			if(!isnull(music_player.active_song_sound))
				to_chat(usr, span_warning("Error: You cannot change the song until the current one is over."))
				return TRUE

			var/datum/track/new_song = music_player.songs[params["track"]]
			if(QDELETED(src) || !istype(new_song, /datum/track))
				return TRUE

			music_player.selection = new_song
			return TRUE

		if("set_volume")
			var/new_volume = params["volume"]
			if(new_volume == "reset")
				music_player.set_volume_to_max()
			if(new_volume == "max")
				music_player.set_volume_to_max()
			else if(new_volume == "min")
				music_player.set_new_volume(0)
			else if(isnum(text2num(new_volume)))
				music_player.set_new_volume(text2num(new_volume))
			return TRUE

		if("repeat")
			music_player.sound_loops = !music_player.sound_loops
			return TRUE

/obj/item/jukebox/proc/activate_music(track = null)
	// Проверяем, если уже есть активная музыка, ничего не делаем
	if(!isnull(music_player.active_song_sound))
		return FALSE

	// Если передан трек, устанавливаем его, иначе берем первый из очереди
	if(track)
		music_player.selection = track
	else if(music_player.queuedplaylist_songnames.len)
		music_player.selection = music_player.songs[music_player.queuedplaylist_songnames[1]]
	else
		return FALSE// Если нет трека для воспроизведения, ничего не делаем

	// Рассчитываем время остановки на основе длительности текущего трека
	music_player.stop_time = world.time + music_player.selection.song_length
	say("Сейчас играет: [music_player.selection.song_name]")
	// Если трек взят из очереди, удаляем его из списка
	if(!track)
		music_player.queuedplaylist_songnames.Cut(1, 2)

	// Запускаем музыку
	music_player.start_music()

	// Обновляем состояние и запускаем процессинг
	update_appearance(UPDATE_ICON_STATE)
	START_PROCESSING(SSobj, src)

	return TRUE

/obj/item/jukebox/proc/stop_music()
	if(!isnull(song_timerid))
		deltimer(song_timerid)

	STOP_PROCESSING(SSobj, src)
	music_player.unlisten_all()
	music_player.selection = null
	music_player.sound_loops = FALSE

	if(!QDELING(src))
		COOLDOWN_START(src, jukebox_song_cd, 10 SECONDS)
		playsound(src,'sound/machines/terminal/terminal_off.ogg',50,TRUE)
		update_appearance(UPDATE_ICON_STATE)
	return TRUE
