GLOBAL_LIST_EMPTY(sneak_pod_list)
#define TRAIT_CREVICE_CRAWLER "crevice_crawler"

/obj/structure/sneak_pod
	name = "узкая расщелина"
	desc = "Тесная щель в замёрзшей породе, едва достаточная, чтобы протиснуться ползком или боком. Движение требует осторожных манёвров."
	// icon = 'icons/obj/structures.dmi'
	icon_state = "crevice"
	density = TRUE
	opacity = TRUE

	anchored = TRUE
	max_integrity = 200
	armor_type = /datum/armor/none
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

	// Список мобов, которые сейчас ползут внутри
	var/list/crawlers = list()
	// Максимальное количество мелких мобов
	var/max_crawlers = 3
	// Ассоциативный список: моб → list(x, y, transform)
	var/list/crawler_pixel_offsets = list()
	var/datum/component/seethrough/filtered/seethrough

/obj/structure/sneak_pod/Initialize(mapload)
	. = ..()
	var/list/map = list(
		list(-1, 1, 0), list(0, 1, 0), list(1, 1, 0),
		list(-1, 0, 0), list(0, 0, 0), list(1, 0, 0),
		list(-1, -1, 0), list(0, -1, 0), list(1, -1, 0)
	)
	seethrough = AddComponent(__IMPLIED_TYPE__)
	seethrough.see_through_map = map
	seethrough.dismantle_perimeter()
	GLOB.sneak_pod_list += src

/obj/structure/sneak_pod/Destroy()
	GLOB.sneak_pod_list -= src
	for(var/mob/living/C in crawlers)
		end_crawl(C, forced = TRUE)
	return ..()

/obj/structure/sneak_pod/mouse_drop_receive(mob/living/M, mob/user, params)
	if(M != user)
		return
	if(!can_crawl_into(M, src))
		return
	if(!do_after(user, 5 SECONDS, src))
		user.balloon_alert(user, "Не удалось пролезть!")
		return
	begin_crawl(M)

/obj/structure/sneak_pod/proc/register_to_crawler(mob/living/crawler)
	RegisterSignal(crawler, COMSIG_MOVABLE_ATTEMPTED_MOVE, PROC_REF(on_crawler_pre_move))
	RegisterSignal(crawler, COMSIG_MOVABLE_MOVED, PROC_REF(on_crawler_moved))
	RegisterSignal(crawler, COMSIG_QDELETING, PROC_REF(on_crawler_qdel))
	RegisterSignal(crawler, COMSIG_LIVING_DEATH, PROC_REF(on_crawler_death))
	RegisterSignal(crawler, COMSIG_LIVING_RESTING, PROC_REF(on_crawler_rest_change))

	for(var/obj/structure/sneak_pod/sneaky as anything in GLOB.sneak_pod_list)
		sneaky.seethrough.add_valid_target(crawler)

/obj/structure/sneak_pod/proc/unregister_from_crawler(mob/living/crawler)
	UnregisterSignal(crawler, list(
		COMSIG_MOVABLE_ATTEMPTED_MOVE,
		COMSIG_MOVABLE_MOVED,
		COMSIG_QDELETING,
		COMSIG_LIVING_DEATH,
		COMSIG_LIVING_RESTING
	))
	for(var/obj/structure/sneak_pod/sneaky as anything in GLOB.sneak_pod_list)
		sneaky.seethrough.remove_valid_target(crawler)

/obj/structure/sneak_pod/proc/begin_crawl(mob/living/crawler, silent = FALSE)
	if(crawler in crawlers)
		return
	crawlers += crawler
	crawler.forceMove(loc)
	crawler.pass_flags |= PASSMOB | PASSTABLE
	crawler.add_traits(list(TRAIT_FLOORED, TRAIT_CREVICE_CRAWLER), REF(src))
	register_to_crawler(crawler)
	if(!silent)
		balloon_alert(crawler, "Вы протискиваетесь в расщелину, ползёте вперёд...")


/obj/structure/sneak_pod/proc/end_crawl(mob/living/crawler, forced = FALSE)
	if(!(crawler in crawlers))
		return
	crawlers -= crawler
	unregister_from_crawler(crawler)
	crawler.pass_flags &= ~(PASSMOB | PASSTABLE)
	crawler.remove_traits(list(TRAIT_FLOORED, TRAIT_CREVICE_CRAWLER), REF(src))
	if(!forced)
		balloon_alert(crawler, "Вы выбираетесь из расщелины.")


/obj/structure/sneak_pod/Bumped(atom/movable/bumped_atom)
	. = ..()
	if(!isliving(bumped_atom))
		return
	var/mob/living/M = bumped_atom
	if(HAS_TRAIT(M, TRAIT_CREVICE_CRAWLER))
		return
	if(!can_crawl_into(M, src))
		return
	if(!do_after(M, 5 SECONDS, src))
		M.balloon_alert(M, "Не удалось пролезть!")
		return
	begin_crawl(M)


/obj/structure/sneak_pod/proc/on_crawler_pre_move(datum/source, atom/newloc, direction)
	SIGNAL_HANDLER
	var/mob/living/C = source
	if(!(C in crawlers))
		return
	if(can_crawl_into(C, newloc))
		addtimer(CALLBACK(src, PROC_REF(attempt_move), C, newloc), 0)
	else
		end_crawl(C)
	return


/obj/structure/sneak_pod/proc/can_crawl_into(mob/living/C, atom/newloc)
	var/obj/structure/sneak_pod/next_pod
	if(!istype(newloc, /obj/structure/sneak_pod))
		next_pod = locate() in newloc
	else
		next_pod = newloc

	if(!next_pod)
		return FALSE
	if(C.stat != CONSCIOUS)
		return
	if(HAS_TRAIT(C, TRAIT_GIANT))
		C.balloon_alert(C, "Я слишком большой!")
		return
	var/body_size = 1
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		body_size = H.dna.features["body_size"] || 1
	if(body_size >= 1)
		for(var/mob/living/other in next_pod.crawlers)
			var/other_size = 1
			if(ishuman(other))
				var/mob/living/carbon/human/OH = other
				other_size = OH.dna.features["body_size"] || 1
			if(other_size >= 1)
				balloon_alert(C, "Следующая расщелина слишком забита!")
				return FALSE
	if(length(next_pod.crawlers) >= next_pod.max_crawlers)
		balloon_alert(C, "Расщелина заполнена!")
		return FALSE
	if(!C.resting)
		balloon_alert(C, "Нужно прилечь!")
		return FALSE
	return TRUE

/obj/structure/sneak_pod/proc/attempt_move(mob/living/C, atom/newloc)
	if(!(C in crawlers) || C.stat != CONSCIOUS || !C.resting)
		balloon_alert(C, "Движение прервано!")
		return
	if(!can_crawl_into(C, newloc))
		balloon_alert(C, "Путь заблокирован!")
		return
	if(!do_after(C, 1 SECONDS, src, IGNORE_USER_LOC_CHANGE | IGNORE_HELD_ITEM, max_interact_count = 1))
		balloon_alert(C, "Движение прервано!")
		return
	var/obj/structure/sneak_pod/next_pod = locate() in newloc
	if(isclosedturf(newloc))
		balloon_alert(C, "Путь перекрыт!")
		return
	if(next_pod)
		C.forceMove(newloc)
		end_crawl(C, TRUE)
		next_pod.begin_crawl(C, TRUE)
	else
		C.forceMove(newloc)
		end_crawl(C)

/obj/structure/sneak_pod/proc/on_crawler_moved(datum/source, atom/oldloc, dir, forced)
	SIGNAL_HANDLER
	var/mob/living/C = source
	if(!(C in crawlers))
		return
	var/obj/structure/sneak_pod/next_pod = locate() in C.loc
	if(next_pod && next_pod != src)
		end_crawl(C, TRUE)
		next_pod.begin_crawl(C, TRUE)

/obj/structure/sneak_pod/proc/on_crawler_qdel(datum/source)
	SIGNAL_HANDLER
	end_crawl(source, TRUE)

/obj/structure/sneak_pod/proc/on_crawler_death(datum/source)
	SIGNAL_HANDLER
	end_crawl(source, TRUE)

/obj/structure/sneak_pod/proc/on_crawler_rest_change(datum/source, resting)
	SIGNAL_HANDLER
	var/mob/living/C = source
	if(!resting && (C in crawlers))
		balloon_alert(C, "Здесь не встать!")
		C.set_resting(TRUE, TRUE, TRUE)

/obj/structure/sneak_pod/proc/is_still_crawling(mob/living/C)
	return (C in crawlers && C.resting)

#undef TRAIT_CREVICE_CRAWLER

/obj/structure/sneak_pod/iced
	name = "заледенелая расщелина"
	icon = 'fenysha_events/icons/structures/crevice.dmi'
	icon_state = "iced"

/obj/structure/sneak_pod/iced/enterence
	name = "заледенелая расщелина"
	icon = 'fenysha_events/icons/structures/crevice.dmi'
	icon_state = "iced_enterence"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sneak_pod/iced/enterence, 27)

/obj/structure/sneak_pod/rock
	name = "каменная расщелина"
	icon = 'fenysha_events/icons/structures/crevice.dmi'
	icon_state = "rock"

/obj/structure/sneak_pod/rock/enterence
	icon = 'fenysha_events/icons/structures/crevice.dmi'
	icon_state = "rock_enterence"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sneak_pod/rock/enterence, 27)
