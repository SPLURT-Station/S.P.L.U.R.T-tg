GLOBAL_LIST_INIT(streamers, list(
	"livrah",
	"mooniverse",
	"truecomrade",
	"alcoreru",
))

#define TRAIT_ROFLS_ZAKONCHILIS "рофлы_закончились_расходимся"
#define ZTRAIT_SSCONSTRUCT "Debug construct"

#define NEW_COOL_MOTO (span_notice("\
[span_big("Общение игрока на сервере cc220")] \n \
1.1. Запрещено оскорбление админов, а так же злоупотребление пастами на сервере. \n \
1.2. Запрещено использование робаста при не достижении возрастных ограничений сервера 220+. \n \
1.3. Запрещено использование сильногоS робаста, пастинг голосовой/текстовый чат музыкой, разговорами не по нон рп, а так же командами/биндами. \n \
1.4. Запрещено подстрекательство и провокационные действия на сервере | Пастиг | зетки | сон | Голосование за смену карты и тд. \n \
1.5. Запрещено обсуждать действия администрации, а так же вести свою деятельность от лица администрации. \n \n \
Наказание: Отключение Микрофона и Чата кетчупу на срок по решению Администратора. \n \n \
Использование запрещенных СЛОВ и сторонние нарушения игрока на сервере. \n \
2.1. Запрещено использование [span_red("Ливрах | Проклятье | Робаст клаб | Ахахахах оооо бля | Санаби | дайте ему стул")] \n \
2.2. Запрещено мешать игровому процессу | Закидывать хайриски в недоступные места | Убийство стримера | Намеренное ослепление моли | Нанесение порно/эротического спрея \n \
2.3. Запрещена реклама на сервере (Любые ссылки и IP Адреса - Связанных с проектом Robust Club). \n \
2.4. Запрещен метагейм на сервере (Любые подсказки в чат, а так же использование сторонних способов связи). \n \n \
Наказание: Блокировка доступа к серверу на срок по решению Администратора минимум 220 деней. \n \n \
Поведение игрока на сервере. \n \
3.1. Запрещено злоупотребление серверными командами в своих целях, а так же спам. \n \
Наказание: Отключение возможности использовать робаст сервера. \n \n \
3.2. Запрещено использовать зетки, сон, ocean_fish, пародировать ники игроков, а так же администраторов. \n \
Наказание: Установка ника Лампус без возможности смены. \n \n \
"))


/datum/preference/toggle/streamer_mode
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "stremer_mode"
	savefile_identifier = PREFERENCE_PLAYER
	default_value = FALSE



/obj/effect/landmark/spawnpoint
	name = "Consturct spawnpoint"

/datum/controller/subsystem/april_rofls
	name = "Рофлы и как их понимать"
	ss_flags = SS_NO_FIRE

	dependencies = list(
		/datum/controller/subsystem/mapping,
		/datum/controller/subsystem/daylight,
	)

	// Клиенты, что впервые услышали новый звук приветствия а так же УВИДЕЛИ NEW_COOL_MOTO
	var/list/client_first_moto = list()
	var/are_we_ready = FALSE
	var/we_cooking = FALSE

/datum/controller/subsystem/april_rofls/Initialize()
	var/list/map_traits = SSmapping.current_map.traits[1]
	if(!map_traits || !islist(map_traits))
		return
	var/is_consturct = map_traits[ZTRAIT_SSCONSTRUCT] || FALSE
	if(!is_consturct)
		return SS_INIT_NO_NEED

	we_cooking = TRUE
	update_tittle_screen()
	RegisterSignal(SSticker, COMSIG_TICKER_ENTER_PREGAME, PROC_REF(on_enter_pregame))
	RegisterSignal(SSdcs, COMSIG_GLOBAL_PLAYER_SETUP_FINISHED, PROC_REF(on_player_join))
	RegisterSignal(SSdcs, COMSIG_GLOB_CLIENT_CONNECT, PROC_REF(on_client_login))


/datum/controller/subsystem/april_rofls/proc/update_tittle_screen()
	var/custom_css = file('fenysha_events/html/gmod_tittle.css')
	if(custom_css)
		SStitle.current_title_screen = new(styles = custom_css)
		SStitle.current_title_screen.title_css = custom_css
	SStitle.set_title_image_silent('fenysha_events/icons/lobby/construct.png')
	for(var/client/C in GLOB.clients)
		SStitle.show_title_screen_to(C)

/datum/controller/subsystem/april_rofls/proc/on_player_join(datum/dcs, mob/living/joining)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(teleport_to_consturct), joining)

/datum/controller/subsystem/april_rofls/proc/teleport_to_consturct(mob/living/joining)
	var/job_spawn_title = joining?.mind?.assigned_role?.title
	var/obj/effect/landmark/start/spawnpoint
	var/obj/effect/landmark/reserv_spawnpoint = null
	for(var/obj/effect/landmark/start/spawn_point as anything in GLOB.start_landmarks_list)
		if(spawn_point.name == job_spawn_title)
			spawnpoint = spawn_point
	if(!spawnpoint)
		reserv_spawnpoint = locate(/obj/effect/landmark/spawnpoint) in GLOB.landmarks_list
	var/turf/target_turf = spawnpoint ? get_turf(spawnpoint) : get_turf(reserv_spawnpoint)
	if(!target_turf)
		message_admins("Failed to spawn new character for [ADMIN_LOOKUPFLW(joining)]")
		return
	equip_mob(joining)

	joining.forceMove(target_turf)
	to_chat(world, span_bold(span_adminsay("[joining.name] присоеденился к серверу!")))

/datum/controller/subsystem/april_rofls/proc/equip_mob(mob/living/joining)
	var/datum/outfit/ss_construct/cool_outfit = new()
	joining.drop_everything(TRUE, TRUE, TRUE)
	cool_outfit.equip(joining)

/datum/controller/subsystem/april_rofls/proc/on_client_login(datum/dcs, client/client)
	SIGNAL_HANDLER

	if(!client || !are_we_ready)
		return

	addtimer(CALLBACK(src, PROC_REF(send_cool_moto), client.mob), 3 SECONDS)

/datum/controller/subsystem/april_rofls/proc/send_cool_moto(mob/send_to, ingore_first_time = FALSE)
	SIGNAL_HANDLER

	if(!are_we_ready || !send_to.client)
		return
	if(client_first_moto[send_to.client] && !ingore_first_time)
		return

	to_chat(send_to, NEW_COOL_MOTO)
	SEND_SOUND(send_to, 'fenysha_events/sounds/effects/construct_hello.ogg')
	if(!ingore_first_time)
		client_first_moto[send_to.client] = TRUE

/datum/controller/subsystem/april_rofls/proc/on_enter_pregame()
	SIGNAL_HANDLER
	are_we_ready = TRUE

	for(var/client/C in GLOB.clients)
		if(C && C.mob)
			send_cool_moto(C.mob)


/datum/controller/subsystem/vote/initiate_vote(vote_type, vote_initiator_name, mob/vote_initiator, forced)
	. = ..()
	for(var/client/new_voter as anything in GLOB.clients)
		if(new_voter.prefs.read_preference(/datum/preference/toggle/streamer_mode))
			continue
		SEND_SOUND(new_voter, sound('fenysha_events/sounds/effects/startvote.ogg'))


/datum/controller/subsystem/vote/end_vote()
	. = ..()
	for(var/client/new_voter as anything in GLOB.clients)
		if(new_voter.prefs.read_preference(/datum/preference/toggle/streamer_mode))
			continue
		SEND_SOUND(new_voter, sound('fenysha_events/sounds/effects/endvote.ogg'))


ADMIN_VERB(give_everyonetoolgun, R_ADMIN, "Выдать всем туллганы", "Выдает всем игрокам туллганы и на выбор цель на остаться в живых", "Event.Construct")
	if(!check_rights(R_ADMIN))
		return

	var/color = tgui_alert(usr, "Вы уверены?", "Выдать всем туллганы", list("Да", "Нет"))
	if(color != "Да")
		return
	var/give_antag = tgui_alert(usr, "Выдать цель остаться в живых?", "Выдать всем туллганы", list("Да", "Нет"))

	for(var/mob/living/carbon/human/H in GLOB.alive_player_list)
		if(!is_station_level(H.z))
			continue
		H.put_in_active_hand(new /obj/item/toolgun/spawn_only, TRUE, TRUE)
		if(give_antag == "Да")
			var/datum/antagonist/custom/survivor = new()
			survivor.name = "Выживший"
			var/datum/objective/custom/rip_and_tear = new()
			rip_and_tear.explanation_text = "Останьтесь последним выжившим на станции, убив всех остальных игроков."
			survivor.objectives += rip_and_tear
			H.mind.add_antag_datum(survivor)

/datum/emote/living/chillman
	name = "Спокойствие!"
	key = "chill"
	key_third_person = "chills"
	sound = 'fenysha_events/sounds/effects/emotes/emote_chill.mp3'
	message = "Выкрикивает, 'СПОКОЙСТВИЕ'!"

/datum/emote/living/cowboy
	name = "Ковбой!"
	key = "cowboy"
	key_third_person = "cawboy"
	sound = 'fenysha_events/sounds/effects/emotes/emote_cowboy.mp3'
	message = "Выкрикивает, 'КОВБОЙ'!"

/datum/emote/living/godlike
	name = "Богоподобно!"
	key = "imgodlike"
	key_third_person = "imgodlike"
	sound = 'fenysha_events/sounds/effects/emotes/emote_godlike.mp3'
	message = "Выкрикивает, 'БОЖЕСТВЕННО'!"

/datum/emote/living/headshot
	name = "В голову!!"
	key = "headshot"
	key_third_person = "headshot"
	sound = 'fenysha_events/sounds/effects/emotes/emote_headshote.wav'
	message = "Выкрикивает, 'В ГОЛОВУ'!"
