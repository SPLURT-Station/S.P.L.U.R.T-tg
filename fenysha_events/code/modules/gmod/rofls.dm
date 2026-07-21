GLOBAL_LIST_INIT(streamers, list(
	"livrah",
	"mooniverse",
	"truecomrade",
	"alcoreru",
))

#define TRAIT_ROFLS_ZAKONCHILIS "rofls_are_over_lets_disperse"
#define ZTRAIT_SSCONSTRUCT "Debug construct"

#define NEW_COOL_MOTO (span_notice("\
[span_big("Player conduct on the cc220 server")] \n \
1.1. Insulting admins is forbidden, as is the abuse of pastes on the server. \n \
1.2. Use of robust is forbidden for those who do not meet the server's 220+ age restriction. \n \
1.3. Forbidden: use of heavy robust, pasting music into voice/text chat, non-RP conversations, as well as commands/binds. \n \
1.4. Forbidden: incitement and provocative actions on the server | Pasting | zetks | sleep | Voting to change the map, etc. \n \
1.5. Discussing administration actions is forbidden, as is acting on behalf of the administration. \n \n \
Punishment: Microphone and Chat muting for ketchup for a duration at the Administrator's discretion. \n \n \
Use of forbidden WORDS and other player violations on the server. \n \
2.1. Forbidden: use of [span_red("Livrah | Curse | Robust Club | Ahahaha oooo fuck | Sanabi | give him a chair")] \n \
2.2. Forbidden: interfering with the gameplay | Throwing highrisks into inaccessible places | Killing the streamer | Deliberately blinding moths | Applying porn/erotic spray \n \
2.3. Advertising is forbidden on the server (Any links and IP addresses - associated with the Robust Club project). \n \
2.4. Metagaming is forbidden on the server (Any hints in chat, as well as using outside means of communication). \n \n \
Punishment: Blocking server access for a duration at the Administrator's discretion, minimum 220 days. \n \n \
Player behavior on the server. \n \
3.1. Forbidden: abusing server commands for one's own purposes, as well as spam. \n \
Punishment: Disabling the ability to use server robust. \n \n \
3.2. Forbidden: using zetks, sleep, ocean_fish, impersonating player nicknames, as well as administrators. \n \
Punishment: Setting the nickname to Lampus with no ability to change it. \n \n \
"))


/datum/preference/toggle/streamer_mode
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "stremer_mode"
	savefile_identifier = PREFERENCE_PLAYER
	default_value = FALSE



/obj/effect/landmark/spawnpoint
	name = "Consturct spawnpoint"

/datum/controller/subsystem/april_rofls
	name = "ROFLs and how to understand them"
	ss_flags = SS_NO_FIRE

	dependencies = list(
		/datum/controller/subsystem/mapping,
		/datum/controller/subsystem/daylight,
	)

	// Clients who heard the new greeting sound for the first time and also SAW NEW_COOL_MOTO
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
	to_chat(world, span_bold(span_adminsay("[joining.name] has joined the server!")))

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


ADMIN_VERB(give_everyonetoolgun, R_ADMIN, "Give Everyone Toolguns", "Gives all players toolguns and optionally an objective to stay alive", "Event.Construct")
	if(!check_rights(R_ADMIN))
		return

	var/color = tgui_alert(usr, "Are you sure?", "Give Everyone Toolguns", list("Yes", "No"))
	if(color != "Yes")
		return
	var/give_antag = tgui_alert(usr, "Give an objective to stay alive?", "Give Everyone Toolguns", list("Yes", "No"))

	for(var/mob/living/carbon/human/H in GLOB.alive_player_list)
		if(!is_station_level(H.z))
			continue
		H.put_in_active_hand(new /obj/item/toolgun/spawn_only, TRUE, TRUE)
		if(give_antag == "Yes")
			var/datum/antagonist/custom/survivor = new()
			survivor.name = "Survivor"
			var/datum/objective/custom/rip_and_tear = new()
			rip_and_tear.explanation_text = "Be the last survivor on the station by killing all the other players."
			survivor.objectives += rip_and_tear
			H.mind.add_antag_datum(survivor)

/datum/emote/living/chillman
	name = "Chill!"
	key = "chill"
	key_third_person = "chills"
	sound = 'fenysha_events/sounds/effects/emotes/emote_chill.mp3'
	message = "shouts, 'CHILL'!"

/datum/emote/living/cowboy
	name = "Cowboy!"
	key = "cowboy"
	key_third_person = "cawboy"
	sound = 'fenysha_events/sounds/effects/emotes/emote_cowboy.mp3'
	message = "shouts, 'COWBOY'!"

/datum/emote/living/godlike
	name = "Godlike!"
	key = "imgodlike"
	key_third_person = "imgodlike"
	sound = 'fenysha_events/sounds/effects/emotes/emote_godlike.mp3'
	message = "shouts, 'DIVINE'!"

/datum/emote/living/headshot
	name = "Headshot!!"
	key = "headshot"
	key_third_person = "headshot"
	sound = 'fenysha_events/sounds/effects/emotes/emote_headshote.wav'
	message = "shouts, 'HEADSHOT'!"
