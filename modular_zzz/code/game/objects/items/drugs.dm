#define DRUGS_SOURCE "drugs"

/datum/reagent/drug/zvezdochka
	name = "Zvezdochka"
	description = "Реверс-инжениринг версия старого советского психотропного вещества. По крайней мере попытка."
	color = "#f00aef"

/datum/chemical_reaction/zvezdochka
	results = list(/datum/reagent/drug/zvezdochka = 5)
	required_reagents = list(/datum/reagent/medicine/sal_acid = 1, /datum/reagent/medicine/oxandrolone = 1, /datum/reagent/medicine/pen_acid = 1, /datum/reagent/toxin/mindbreaker = 2)
	mix_message = "Смесь бурно реагирует, оставляя после себя несколько красных кристаллических осколков."
	required_temp = 390

/datum/reagent/drug/zvezdochka/on_mob_metabolize(mob/living/M)
	. = ..()

	M.add_client_colour(/datum/client_colour/zvezdochka, DRUGS_SOURCE)
	var/sound/sound = sound(pick('modular_zzz/sounds/LYENEN.ogg', 'modular_zzz/sounds/LYENEN2.ogg'), TRUE)
	sound.environment = 35
	sound.volume = 30
	SEND_SOUND(M.client, sound)

	return

/datum/hallucination/delusion/preset/zvezdochka
	delusion_icon_file = 'modular_zzz/icons/stars.dmi'
	delusion_icon_state = "star1"
	delusion_name = "demon"

/datum/hallucination/delusion/preset/zvezdochka/start()
	delusion_icon_state = pick("star1","star2")
	return ..()

/datum/reagent/drug/zvezdochka/on_mob_life(mob/living/M)

	var/high_message = pick("ЗВЁЗДОЧКИ", "ЛЕНИН", "КОММУНИЗМ", "КАЙФ")

	if(prob(30))
		to_chat(M, span_notice("<i> ... [high_message] ... </i>"))
		M.adjustToxLoss(-4 * REM, 0)
		M.adjustBruteLoss(-4 * REM, 0)
		M.adjustFireLoss(-4 * REM, 0)
		M.adjustOxyLoss(-12 * REM, 0)

		M.adjust_jitter(rand(0,2))
		M.adjust_dizzy(rand(0,2))

	M.cause_hallucination(/datum/hallucination/delusion/preset/zvezdochka, "ЗВЁЗДОЧКА")

	if(prob(65))
		var/image/trip_img = image('modular_zzz/icons/stars.dmi', get_turf(pick(view(7, M))), pick("star1","star2"), CURSE_LAYER)
		if(M.client)
			M.client.images += trip_img
		spawn(rand(30,50))
			if(M.client)
				M.client.images -= trip_img
			QDEL_NULL(trip_img)
	..()

/datum/reagent/drug/zvezdochka/on_mob_end_metabolize(mob/living/M)
	M.remove_client_colour(DRUGS_SOURCE)
	DIRECT_OUTPUT(M.client, sound(null))
	..()

/datum/client_colour/zvezdochka
	color = list(rgb(255,15,15), rgb(15,225,15), rgb(15,15,255), rgb(0,0,0))
	priority = 6

/obj/item/reagent_containers/applicator/pill/zvezdochka
	name = "Zvezdochka"
	desc = "Не похоже на мазь."
	icon_state = "pill7"
	list_reagents = list(/datum/reagent/drug/zvezdochka = 25)

/obj/item/storage/pill_bottle/zvezdochka
	name = "Mazz Zvezdochka"
	desc = "Может вызвать ожог глаз. По крайней мере в старой инструкции так было написано."

/obj/item/storage/pill_bottle/zvezdochka/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/applicator/pill/zvezdochka(src)

/datum/reagent/drug/pendosovka
	name = "Pendosovka"
	description = "Реверс-инжениринг версия старого капиталистического психотропного вещества. По крайней мере попытка."
	color = "#4463a7"

/datum/chemical_reaction/pendosovka
	results = list(/datum/reagent/drug/pendosovka = 5)
	required_reagents = list(/datum/reagent/medicine/sal_acid = 1, /datum/reagent/medicine/oxandrolone = 1, /datum/reagent/medicine/pen_acid = 1, /datum/reagent/consumable/nutriment/liquid_burger = 2)
	mix_message = "Смесь бурно реагирует, оставляя после себя несколько синих кристаллических осколков."
	required_temp = 390

/datum/reagent/consumable/nutriment/liquid_burger
	name = "Liquid Burger"
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	// reagent_state = LIQUID
	nutriment_factor = 25 * REAGENTS_METABOLISM
	color = "#4463a7"

/datum/chemical_reaction/liquid_burger
	results = list(/datum/reagent/consumable/nutriment/liquid_burger = 5)
	required_reagents = list(/datum/reagent/medicine/c2/synthflesh = 1, /datum/reagent/consumable/space_cola = 1)
	mix_message = "Смесь бурно реагирует, оставляя после себя огромную кучу микро-мини-нано бургеров."

/datum/chemical_reaction/solid_burger
	required_reagents = list(/datum/reagent/consumable/nutriment/liquid_burger = 10)
	required_temp = 450
	mix_message = "Смесь бурно реагирует, оставляя после себя огромный сочный бургер."

/datum/chemical_reaction/solid_burger/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to multiplier)
		var/list/burgers = subtypesof(/obj/item/food/burger)
		playsound(location, 'sound/effects/phasein.ogg', 100, 1)
		var/random_burger = pick(burgers)
		new random_burger(location)

/datum/reagent/drug/pendosovka/on_mob_metabolize(mob/living/M)
	. = ..()

	M.add_client_colour(/datum/client_colour/pendosovka, DRUGS_SOURCE)
	var/sound/sound = sound(pick('modular_zzz/sounds/CAPITAL1.ogg', 'modular_zzz/sounds/CAPITAL2.ogg'), TRUE)
	sound.environment = 45
	sound.volume = 40
	SEND_SOUND(M.client, sound)

	return

/datum/hallucination/delusion/preset/pendosovka
	delusion_icon_file = 'modular_zzz/icons/stars.dmi'
	delusion_icon_state = "star1"
	delusion_name = "demon"

/datum/hallucination/delusion/preset/pendosovka/start()
	delusion_icon_state = pick("star1","star3")
	return ..()

/datum/reagent/drug/pendosovka/on_mob_life(mob/living/M)

	var/high_message = pick("ДЕНЬГИ", "ОРЁЛ", "КАПИТАЛИЗМ", "КАЙФ")

	if(prob(30))
		to_chat(M, span_notice("<i> ... [high_message] ... </i>"))
		M.adjustToxLoss(-4 * REM, 0)
		M.adjustBruteLoss(-4 * REM, 0)
		M.adjustFireLoss(-4 * REM, 0)
		M.adjustOxyLoss(-12 * REM, 0)

		M.adjust_jitter(rand(0,2))
		M.adjust_dizzy(rand(0,2))

	M.cause_hallucination(/datum/hallucination/delusion/preset/pendosovka, "ПЕНДОСОВКА")

	if(prob(65))
		var/image/trip_img = image('modular_zzz/icons/stars.dmi', get_turf(pick(view(7, M))), pick("star1", "star3"), CURSE_LAYER)
		if(M.client)
			M.client.images += trip_img
		spawn(rand(30,50))
			if(M.client)
				M.client.images -= trip_img
			QDEL_NULL(trip_img)
	..()

/datum/reagent/drug/pendosovka/on_mob_end_metabolize(mob/living/M)
	M.remove_client_colour(DRUGS_SOURCE)
	DIRECT_OUTPUT(M.client, sound(null))
	..()

/datum/client_colour/pendosovka
	color = list(rgb(255,15,15), rgb(15,225,15), rgb(15,15,255), rgb(0,0,0))
	priority = 6

/obj/item/reagent_containers/applicator/pill/pendosovka
	name = "Pendosovka"
	desc = "Не похоже на мазь."
	icon_state = "pill7"
	list_reagents = list(/datum/reagent/drug/pendosovka = 25)

/obj/item/storage/pill_bottle/pendosovka
	name = "Mazz Pendosovka"
	desc = "Может вызвать ожог глаз. По крайней мере в старой инструкции так было написано."

/obj/item/storage/pill_bottle/pendosovka/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/applicator/pill/pendosovka(src)

/datum/reagent/drug/labebium
	name = "Лабебиум"
	description = "Пахнет интересно."
	color = "#999922"
	// reagent_state = LIQUID
	taste_description = "piss"
	var/obj/effect/client_image_holder/hallucination/ovoshi/fruit
	var/obj/effect/client_image_holder/hallucination/water/flood
	var/obj/effect/client_image_holder/hallucination/ovoshi/statues/statuya
	var/list/trip_types = list("ovoshi", "statues")
	var/current_trip
	var/tripsoundstarted = FALSE
	var/list/shenanigans = list()
	var/list/sounds = list()

/datum/chemical_reaction/labebium
	results = list(/datum/reagent/drug/labebium = 1)
	required_reagents = list(/datum/reagent/consumable/ethanol = 4, /datum/reagent/drug/krokodil = 1)

/datum/reagent/drug/labebium/on_mob_end_metabolize(mob/living/L)
	stop_shit(L)
	..()

/datum/reagent/drug/labebium/proc/stop_shit(mob/living/carbon/human/C)
	if(C && C.hud_used)
		if(!HAS_TRAIT(C, TRAIT_DUMB))
			C.set_derpspeech(0)
		C.remove_status_effect(/datum/status_effect/speech/slurring/cult)
		C.hud_used.show_hud(HUD_STYLE_STANDARD)
		C.Paralyze(95)
		DIRECT_OUTPUT(C.client, sound(null))
		var/list/screens = list(C.hud_used.get_plane_master(FLOOR_PLANE), C.hud_used.get_plane_master(GAME_PLANE), C.hud_used.get_plane_master(LIGHTING_PLANE))
		for(var/atom/movable/screen/plane_master/whole_screen in screens)
			animate(whole_screen, transform = matrix(), pixel_x = 0, pixel_y = 0, color = "#ffffff", time = 200, easing = ELASTIC_EASING)
			addtimer(VARSET_CALLBACK(whole_screen, filters, list()), 200) //reset filters
		to_chat(C, "<b><big>Неужели отпустило...</big></b>")

//		if(C.client && current_cycle > 100)
//			if(C.client.get_metabalance() < 0)
//				to_chat(C, "<b><big>Эта терапия излечила мой аутизм.</big></b>")
//				C.client.set_metacoin_count(0)
//				return

		if(prob(50) && current_cycle > 50)
			spawn(30)
				to_chat(C, "<b><big>Или нет?!</big></b>")
				if(prob(50))
					spawn(50)
						to_chat(C, "<b><big>А-А-А-А-А-А-А-А-А-А-А-А-А-А!!!</big></b>")
						C.reagents.add_reagent_list(list(/datum/reagent/drug/labebium = 10))

/datum/reagent/drug/labebium/proc/create_flood(mob/living/carbon/C)
	for(var/turf/T in orange(14,C))
		if(prob(66))
			if(!(locate(flood) in T.contents))
				flood = new(T, C)

/datum/reagent/drug/labebium/proc/create_ovosh(mob/living/carbon/C)
	for(var/turf/T in orange(14,C))
		if(prob(23))
			if(!(locate(fruit) in T.contents))
				fruit = new(T, C, phrases = shenanigans)

/datum/reagent/drug/labebium/proc/create_statue(mob/living/carbon/C)
	for(var/turf/T in orange(14,C))
		if(prob(1))
			if(!(locate(statuya) in T.contents))
				statuya = new(T, C, phrases = shenanigans)

/datum/reagent/drug/labebium/on_mob_add(mob/living/L)
	. = ..()
	if (!current_trip)
		current_trip = pick(trip_types)
	var/json_file = file("data/npc_saves/Poly.json")
	if(!fexists(json_file))
		return
	var/list/json = json_decode(file2text(json_file))
	shenanigans = json["phrases"]
	return

/datum/reagent/drug/labebium/on_mob_life(mob/living/carbon/H)
	if(!H || !H.hud_used)
		return
	var/high_message
	var/list/screens = list(H.hud_used.get_plane_master(FLOOR_PLANE), H.hud_used.get_plane_master(GAME_PLANE), H.hud_used.get_plane_master(LIGHTING_PLANE))
	switch(current_trip)
		if("ovoshi")
			switch(current_cycle)
				if(1 to 20)
					high_message = "ТОЛЬКО НЕ ОВОЩИ!!!"
					if(prob(30))
						H.adjust_derpspeech(5 SECONDS)
						H.adjust_timed_status_effect(5 SECONDS, /datum/status_effect/speech/slurring/cult)
					if(!tripsoundstarted)
						var/sound/sound = sound('modular_zzz/sounds/cometodaddy.ogg', TRUE)
						sound.environment = 23
						sound.volume = 100
						SEND_SOUND(H.client, sound)
						create_ovosh(H)
						H.hud_used.show_hud(HUD_STYLE_NOHUD)
						H.emote("realagony")
						tripsoundstarted = TRUE
				if(31 to INFINITY)
					if(prob(80) && (H.mobility_flags & MOBILITY_MOVE) && !ismovable(H.loc))
						step(H, pick(GLOB.cardinals))
					if(H.client)
						INVOKE_ASYNC(src, .proc/handle_sounds, H)
					if(prob(85))
						H.adjust_jitter(35)
						var/rotation = max(min(round(current_cycle/4), 20),360)
						for(var/atom/movable/screen/plane_master/whole_screen in screens)
							if(prob(3))
								var/sound/sound = sound('modular_zzz/sounds/trip_blast.wav')
								sound.environment = 23
								sound.volume = 100
								SEND_SOUND(H.client, sound)
								H.emote("realagony")
								H.overlay_fullscreen("labebium", /atom/movable/screen/fullscreen/labeb, rand(1, 23))
								H.clear_fullscreen("labebium", rand(15, 60))
								H.client.toggle_fullscreen()
								H.cause_hallucination(/datum/hallucination/delusion, TRUE, duration = 150, skip_nearby = FALSE, custom_name = H.name)
								if(prob(50))
									spawn(30)
										H.overlay_fullscreen("labebium", /atom/movable/screen/fullscreen/labeb, rand(1, 23))
										H.clear_fullscreen("labebium", rand(15, 60))
										H.emote("realagony")
										if(prob(50))
											spawn(30)
												H.overlay_fullscreen("labebium", /atom/movable/screen/fullscreen/labeb, rand(1, 23))
												H.clear_fullscreen("labebium", rand(15, 60))
												H.emote("realagony")
							if(prob(40))
								H.adjust_stutter(9 SECONDS)
								animate(whole_screen, color = color_matrix_rotate_hue(rand(0, 360)), transform = turn(matrix(), rand(1,rotation)), time = 150, easing = CIRCULAR_EASING)
								animate(transform = turn(matrix(), -rotation), time = 100, easing = BACK_EASING)
							if(prob(13))
								H.adjust_jitter(100)
								whole_screen.filters += filter(type="wave", x=20*rand() - 20, y=20*rand() - 20, size=rand()*0.1, offset=rand()*0.5, flags = WAVE_BOUNDED)
								animate(whole_screen, transform = matrix()*2, time = 40, easing = BOUNCE_EASING)
								addtimer(VARSET_CALLBACK(whole_screen, filters, list()), 1200)
							addtimer(VARSET_CALLBACK(whole_screen, filters, list()), 600)
					high_message = "ГОСПОДИ, НЕТ!!!"
					create_flood(H)
					create_ovosh(H)
		if("statues")
			high_message = "Расслабон..."
			if(!tripsoundstarted)
				var/sound/sound = sound('modular_zzz/sounds/caves8.ogg', TRUE)
				sound.environment = 23
				sound.volume = 80
				SEND_SOUND(H.client, sound)
				H.hud_used.show_hud(HUD_STYLE_NOHUD)
				tripsoundstarted = TRUE
			if(prob(15))
				for(var/atom/movable/screen/plane_master/whole_screen in screens)
					animate(whole_screen, color = color_matrix_rotate_hue(rand(0, 360)), time = rand(5, 20))
			if(prob(15))
				if(H.client)
					INVOKE_ASYNC(src, .proc/handle_sounds, H)
				create_statue(H)
				if(prob(3))
					var/sound/sound = sound('modular_zzz/sounds/trip_blast.wav')
					sound.environment = 23
					sound.volume = 100
					SEND_SOUND(H.client, sound)
					H.overlay_fullscreen("labebium", /atom/movable/screen/fullscreen/labeb, rand(1, 23))
					H.clear_fullscreen("labebium", rand(15, 60))
	if(prob(10))
		to_chat(H, "\n")
	if(prob(5))
		to_chat(H, "<b><big> ... [readable_corrupted_text(high_message)] ... </big></b>")
	..()

/datum/reagent/drug/labebium/proc/handle_sounds(mob/living/carbon/H)
	if(!H || !H.client)
		return
	sounds = H.client.SoundQuery()
	for(var/sound/S in sounds)
		if(S.len <= 3)
			PlaySpook(H, S.file, 23)
			sounds = list()

/datum/reagent/drug/labebium/proc/PlaySpook(mob/living/carbon/C, soundfile, environment = 0, vary = TRUE)
	var/sound/sound = sound(soundfile)
	sound.environment = environment //druggy
	sound.volume = rand(25,100)
	if(vary)
		sound.frequency = rand(10000,70000)
	SEND_SOUND(C.client, sound)

/obj/effect/client_image_holder/hallucination/water
	name = "ыххыхыхыыы"
	desc = "<big>АААААААААААААААААААААААА!!!</big>"
	image_icon = 'modular_zzz/icons/water.dmi'
	image_state = "water0"
	var/triggered_shit = FALSE

/obj/effect/client_image_holder/hallucination/water/New(turf/location_who_cares_fuck, mob/living/carbon/C, forced = TRUE)
	image_state = "water[rand(0, 7)]"
	. = ..()
	color = pick("#ff00ff", "#ff0000", "#0000ff", "#00ff00", "#00ffff")
	animate(src, color = color_matrix_rotate_hue(rand(0, 360)), time = 200, easing = CIRCULAR_EASING)
	QDEL_IN(src, rand(40, 200))
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)


/obj/effect/client_image_holder/hallucination/water/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(!triggered_shit)
		if(ishuman(AM))
			animate(src, pixel_y = 600, pixel_x = rand(-4, 4), time = 30, easing = BOUNCE_EASING)
			if(prob(10) && AM == parent)
				var/mob/living/carbon/human/M = AM
				M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5, 170)
				to_chat(M, "<b>[readable_corrupted_text("ПШШШШШШШШШШШШШШШШШШШ!!!")]</b>")
				var/sound/sound = sound('modular_zzz/sounds/pshsh.ogg')
				sound.environment = 23
				sound.volume = 20
				SEND_SOUND(M, sound)
				M.Paralyze(25)
			triggered_shit = TRUE


/obj/effect/client_image_holder/hallucination/ovoshi
	name = "Овощ"
	desc = "М-М-М-М-М-М..!"
	image_icon = 'modular_zzz/icons/harvest.dmi'
	image_state = "berrypile"
	var/list/states = list("berrypile", "chilipepper", "eggplant", "soybeans", \
		"plumphelmet", "carrot", "corn", "corn2", "corn_cob", "tomato", "ambrosiavulgaris", \
		"watermelon", "apple", "applestub", "appleold", "lime", "lemon", "poisonberrypile", \
		"grapes", "cabbage", "greengrapes", "orange", "potato", "potato-peeled", "wheat", \
		"ashroom", "cshroom", "eshroom", "fshroom", "amanita", "gshroom", "bshroom", "dshroom", \
		"bezglaznik", "krovnik", "pumpkin", "rice", "goldenapple", "gryab", "curer", "otorvyannik", \
		"glig", "beet", "turnip")

/obj/effect/client_image_holder/hallucination/ovoshi/New(turf/location_who_cares_fuck, mob/living/carbon/C, forced = TRUE, list/phrases = list())
	image_state = pick(states)
	. = ..()
	SpinAnimation(rand(5, 40), TRUE, prob(50))
	pixel_x = (rand(-16, 16))
	pixel_y = (rand(-16, 16))
	if(prob(1) && C.client)
		if(!phrases.len)
			phrases = list("Мяу", "Кря")
		to_chat(C.client, "<b>[name]</b> <i>говорит</i>, <big>\"[readable_corrupted_text(pick(phrases))]\"</big>")
	animate(src, color = color_matrix_rotate_hue(rand(0, 360)), transform = matrix()*rand(1,3), time = 200, pixel_x = rand(-64,64), pixel_y = rand(-64,64), easing = CIRCULAR_EASING)
	QDEL_IN(src, rand(40, 200))

/obj/effect/client_image_holder/hallucination/ovoshi/attack_hand(mob/living/carbon/C)
	if(prob(10))
		to_chat(C, "<b>ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ!!!</b>")
	var/sound/sound = sound(pick('modular_zzz/sounds/wallhit.ogg', \
		'modular_zzz/sounds/wallhit2.ogg', 'modular_zzz/sounds/wallhit3.ogg'))
	sound.environment = 23
	sound.volume = rand(50, 100)
	SEND_SOUND(C.client, sound)
	C.Paralyze(5)
	to_chat(C, "<span class='rose bold'>[prob(50) ? "Получено" : "Потеряно"] [rand(1000, 500000)] кредитов!</span>")
	. = ..()
	qdel(src)

/obj/effect/client_image_holder/hallucination/ovoshi/statues
	name = "Мяу"
	desc = "Ого!"
	image_icon = 'modular_zzz/icons/crafts.dmi'
	image_state = "statue1"
	states = list("statue1", "statue2", "statue3", "statue4", \
		"statue6", "statue7", "seangel", "seangel2")

/atom/movable/screen/fullscreen/labeb
	icon = 'modular_zzz/icons/ruzone_went_up.dmi'
	plane = SPLASHSCREEN_PLANE
	screen_loc = "CENTER-7,SOUTH"
	icon_state = ""

/obj/item/reagent_containers/applicator/pill/labebium
	name = "Funny Pill"
	var/static/list/names = list("maintenance pill", "floor pill", "mystery pill", "suspicious pill", "strange pill", "lucky pill", "ominous pill", "eerie pill")
	desc = "Swallow me~.."
	var/static/list/descs = list("Your feeling is telling you no, but...","Drugs are expensive, you can't afford not to eat any pills that you find."\
	, "Surely, there's no way this could go bad.", "Winners don't do dr- oh what the heck!", "Free pills? At no cost, how could I lose?")
	icon_state = "pill5"
	list_reagents = list(/datum/reagent/drug/labebium = 25)

/obj/item/reagent_containers/applicator/pill/labebium/Initialize(mapload)
	. = ..()
	name = pick(names)
	if(prob(30))
		desc = pick(descs)

/obj/item/storage/pill_bottle/labebium
	name = "Лабебиум"
	desc = "Поглощение одной такой таблетки превратит тебя в овоща. Я не шучу."

/obj/item/storage/pill_bottle/labebium/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/applicator/pill/labebium(src)

#undef DRUGS_SOURCE
