#define ZTRAITS_BACKROOMS list(ZTRAIT_AWAY = TRUE, ZTRAIT_SECRET = TRUE, ZTRAIT_NOPHASE = TRUE, ZTRAIT_NOXRAY = TRUE, ZTRAIT_GRAVITY = 1, ZTRAIT_LINKAGE = UNAFFECTED)
GLOBAL_VAR_INIT(backrooms_loaded, FALSE)
GLOBAL_LIST_EMPTY(backrooms_exile_components)


ADMIN_VERB(load_backrooms, R_FUN, "Load the backrooms", "Loads the backrooms map on new secret zlevel", ADMIN_CATEGORY_EVENTS)

	if(GLOB.backrooms_loaded)
		to_chat(user, span_warning("The backrooms are already loaded!"))
		return FALSE

	message_admins("[key_name_admin(user)] is attempting to load the backrooms map. Hold onto your butts.")

	var/ask = tgui_alert(user, "Are you sure you want to load the backrooms map? \
						- it can cause freezing during loading.", "Backrooms loading", list("Indeed!", "Nevermind"), timeout = 30 SECONDS)

	var/double_confirm = tgui_alert(user, "ARE YOU SURE? If you don't know what you are doing - stop." \
						, "Backrooms loading", list("Indeed!", "Nevermind!"), timeout = 30 SECONDS)

	if(ask != "Indeed!" || double_confirm != "Indeed!")
		message_admins("[key_name_admin(user)] changed their mind about loading the backrooms map.")
		return FALSE

	load_backrooms()
	message_admins("[key_name_admin(user)] loaded the backrooms map!")

/obj/effect/mapping_helpers/ztrait_injector/backroom
	name = "Backrooms ztrait injector"
	traits_to_add = ZTRAITS_BACKROOMS

/proc/load_backrooms()
	if(IsAdminAdvancedProcCall())
		return

	if(load_new_z_level("_maps/RandomZLevels/backrooms.dmm", "Backrooms", TRUE))
		GLOB.backrooms_loaded = TRUE


/datum/component/backrooms_exile
	// Original /mob/living/carbon/human body of the exiled
	VAR_PRIVATE/mob/living/original_body

	// Current body of the exiled, can be original_body or replacement body
	VAR_PRIVATE/mob/living/current_body

	// Mind of the exiled, can be original_body.mind
	VAR_PRIVATE/datum/mind/saved_mind

	// How long the exiled spent in backrooms, in deciseconds
	VAR_PRIVATE/time_spend_in_backrooms = 0

	// How long the exiled should spend in backrooms, in deciseconds, -1 for infinite
	VAR_PRIVATE/time_to_spend_in_backrooms = 10 MINUTES

	// How long the exiled should wait before being exiled, in deciseconds
	VAR_PRIVATE/time_to_exile = 90 SECONDS

	// How long the exiled spent before being exiled, in deciseconds
	VAR_PRIVATE/time_spend_before_exile = 0

	// Next exile warning time, in deciseconds
	VAR_PRIVATE/next_exile_warning = 30 SECONDS

	// Is the exiled currently being exiled
	VAR_PRIVATE/exiling = FALSE

	// Is the exiled currently transferring mind
	VAR_PRIVATE/transfering_mind = FALSE

	// Is the exiled currently in backrooms
	VAR_PRIVATE/in_backrooms = FALSE

	// Items that should be spawned for the exiled in backrooms, if any. type = amount, will be spawned
	// at the same turf as the exiled body
	var/list/default_equipment = list(
		/obj/item/flashlight = 1,
		/obj/item/broadcast_camera = 1,
	)


	// Original muted state of the exiled, to restore after unmuting
	VAR_PRIVATE/original_muted = NONE

	// Sight flags each concealed body had before clamp_sight() took them over, keyed by REF(body)
	VAR_PRIVATE/list/pre_conceal_sight = list()

	COOLDOWN_DECLARE(say_hallucination_cd)

/datum/component/backrooms_exile/Initialize(exile_time, instant, pre_exile_time = 90 SECONDS)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	if(!GLOB.backrooms_loaded || !length(GLOB.backrooms_fall_points))
		return COMPONENT_INCOMPATIBLE

	original_body = parent
	current_body = parent

	time_to_spend_in_backrooms = exile_time
	time_to_exile = pre_exile_time

	if(instant)
		addtimer(CALLBACK(src, PROC_REF(exile)), 1)

	GLOB.backrooms_exile_components += src

/datum/component/backrooms_exile/Destroy(force)
	. = ..()
	original_body.SetSleeping(0)
	saved_mind.transfer_to(original_body, TRUE)

	GLOB.backrooms_exile_components -= src

/datum/component/backrooms_exile/RegisterWithParent()
	START_PROCESSING(SSprocessing, src)
	ADD_TRAIT(original_body, TRAIT_NO_CRYOSLEEP, REF(src))
	RegisterSignal(original_body, COMSIG_LIVING_DEATH, PROC_REF(on_original_body_death))


/datum/component/backrooms_exile/UnregisterFromParent()
	STOP_PROCESSING(SSprocessing, src)
	REMOVE_TRAIT(original_body, TRAIT_NO_CRYOSLEEP, REF(src))
	unmute_mob(original_body)

	UnregisterSignal(original_body, list(COMSIG_LIVING_DEATH))
	if(current_body && current_body != original_body)
		unsubscribe_from_body(current_body)


/datum/component/backrooms_exile/proc/subscribe_to_body(mob/living/body)
	PRIVATE_PROC(TRUE)

	if(QDELETED(body))
		return

	ADD_TRAIT(body, TRAIT_NO_GHOSTIZE, REF(src))
	RegisterSignal(body, COMSIG_LIVING_DEATH, PROC_REF(on_owner_death))
	RegisterSignal(body, COMSIG_MOVABLE_MOVED, PROC_REF(on_owner_move))
	RegisterSignal(body, COMSIG_MOVABLE_PRE_HEAR, PROC_REF(on_owner_pre_hear))
	RegisterSignal(body, COMSIG_MOB_SIGHT_CHANGE, PROC_REF(on_owner_sight_change))

/datum/component/backrooms_exile/proc/unsubscribe_from_body(mob/living/body)
	PRIVATE_PROC(TRUE)

	if(QDELETED(body))
		return

	REMOVE_TRAIT(body, TRAIT_NO_GHOSTIZE, REF(src))
	UnregisterSignal(body, list(COMSIG_LIVING_DEATH, COMSIG_MOVABLE_MOVED, COMSIG_MOVABLE_PRE_HEAR, COMSIG_MOB_SIGHT_CHANGE))
	reveal_body(body)

// Draws every mob in view no matter their invisibility, which would show the exiled the others.
#define BACKROOMS_BLOCKED_SIGHT (SEE_MOBS)
// Draws your own mob no matter your invisibility, which is how the exiled still see themselves.
#define BACKROOMS_GRANTED_SIGHT (SEE_SELF)
// Everything clamp_sight() is responsible for, and the only bits reveal_body() puts back.
#define BACKROOMS_MANAGED_SIGHT (BACKROOMS_BLOCKED_SIGHT|BACKROOMS_GRANTED_SIGHT)

/datum/component/backrooms_exile/proc/conceal_body(mob/living/body)
	PRIVATE_PROC(TRUE)

	if(QDELETED(body))
		return

	pre_conceal_sight[REF(body)] = body.sight
	body.SetInvisibility(INVISIBILITY_OBSERVER, id = REF(src))
	body.pass_flags |= PASSMOB
	clamp_sight(body)

/datum/component/backrooms_exile/proc/reveal_body(mob/living/body)
	PRIVATE_PROC(TRUE)

	if(QDELETED(body))
		return

	body.RemoveInvisibility(REF(src))
	body.pass_flags &= ~PASSMOB

	var/original_sight = pre_conceal_sight[REF(body)] || NONE
	pre_conceal_sight -= REF(body)
	body.set_sight((body.sight & ~BACKROOMS_MANAGED_SIGHT) | (original_sight & BACKROOMS_MANAGED_SIGHT))

/datum/component/backrooms_exile/process(seconds_per_tick)
	if(exiling || transfering_mind)
		return

	if(!in_backrooms)
		if(QDELETED(original_body) || original_body.stat == DEAD)
			qdel(src)
			return

		time_spend_before_exile += (1 SECONDS) * seconds_per_tick

		if(time_spend_before_exile >= next_exile_warning && time_spend_before_exile < time_to_exile)
			warn_before_exile()
			next_exile_warning += 30 SECONDS

		if(time_spend_before_exile >= time_to_exile)
			exile()
		return

	if(time_to_spend_in_backrooms <= -1)
		return

	time_spend_in_backrooms += (1 SECONDS) * seconds_per_tick
	if(time_spend_in_backrooms >= time_to_spend_in_backrooms)
		return_to_original()


/datum/component/backrooms_exile/proc/warn_before_exile()
	if(QDELETED(original_body))
		return

	switch(rand(1, 4))
		if(1)
			to_chat(original_body, span_warning("You feel a strange pressure in your head."))
		if(2)
			to_chat(original_body, span_warning("The air around you feels weird."))
		if(3)
			to_chat(original_body, span_warning("You feel like you're being watched."))
		if(4)
			to_chat(original_body, span_warning("Something brushes against your mind, but you can't see it."))


/datum/component/backrooms_exile/proc/exile()
	if(exiling || in_backrooms)
		return

	if(QDELETED(original_body) || original_body.stat == DEAD || !original_body.mind)
		qdel(src)
		return

	mute_mob(original_body)
	exiling = TRUE

	to_chat(original_body, span_userdanger("You feel as though the earth shakes under your feet, and you are being pulled into the void!"))
	original_body.Shake()
	shake_camera(original_body, 2 SECONDS, 1)
	sleep(2 SECONDS)

	if(QDELETED(src) || QDELETED(original_body))
		return

	original_body.SetSleeping(INFINITY)

	var/mob/living/new_body = create_body(original_body)
	if(QDELETED(new_body))
		exiling = FALSE
		qdel(src)
		return

	current_body = new_body
	in_backrooms = TRUE
	time_spend_in_backrooms = 0

	subscribe_to_body(new_body)

	shake_camera(original_body, 3 SECONDS, 1)
	sleep(3 SECONDS)

	if(QDELETED(src) || QDELETED(new_body))
		exiling = FALSE
		return

	transfering_mind = TRUE
	var/obj/effect/mapping_helpers/backrooms_fall_point/point = pick(GLOB.backrooms_fall_points)

	var/datum/mind/M = original_body.mind
	new_body.forceMove(get_turf(point))
	if(M)
		saved_mind = M
		saved_mind.transfer_to(new_body, TRUE)

	spawn_equipment(new_body)
	transfering_mind = FALSE

	shake_camera(new_body, 2 SECONDS, 1)
	sleep(2 SECONDS)

	exiling = FALSE
	message_admins("[ADMIN_LOOKUPFLW(new_body)] was transferred into the backrooms!")

/datum/component/backrooms_exile/proc/create_body(mob/living/original, copy_prefs = TRUE, copy_items = TRUE)
	if(QDELETED(original))
		return null

	var/mob/living/new_body = new original.type(null)

	if(ishuman(original) && copy_prefs && original.client)
		original.client.prefs.apply_prefs_to(new_body)
	else if(!ishuman(original))
		new_body.name = original.name
		new_body.desc = original.desc
		new_body.color = original.color

	if(ishuman(original) && copy_items)
		var/mob/living/carbon/human/H = new_body
		var/mob/living/carbon/human/OH = original

		copy_equipped_clothing(OH, H, OH.w_uniform, ITEM_SLOT_ICLOTHING)
		copy_equipped_clothing(OH, H, OH.wear_suit, ITEM_SLOT_OCLOTHING)
		copy_equipped_clothing(OH, H, OH.shoes, ITEM_SLOT_FEET)
		copy_equipped_clothing(OH, H, OH.gloves, ITEM_SLOT_GLOVES)
		copy_equipped_clothing(OH, H, OH.head, ITEM_SLOT_HEAD)
		copy_equipped_clothing(OH, H, OH.wear_mask, ITEM_SLOT_MASK)
		copy_equipped_clothing(OH, H, OH.wear_id, ITEM_SLOT_ID)
		copy_equipped_clothing(OH, H, OH.belt, ITEM_SLOT_BELT)
		copy_equipped_clothing(OH, H, OH.glasses, ITEM_SLOT_EYES)
		copy_equipped_clothing(OH, H, OH.ears, ITEM_SLOT_EARS)
		copy_equipped_clothing(OH, H, OH.back, ITEM_SLOT_BACK)

	// Done here, while the body is still in nullspace, so it never renders for anyone.
	conceal_body(new_body)

	return new_body


/datum/component/backrooms_exile/proc/copy_equipped_clothing(mob/living/carbon/human/source, mob/living/carbon/human/target, obj/item/I, slot)
	if(!I || QDELETED(I) || QDELETED(target))
		return

	var/obj/item/copy = new I.type(target)
	copy.name = I.name
	copy.desc = I.desc
	copy.icon_state = I.icon_state

	target.equip_to_slot_or_del(copy, slot, TRUE)

/datum/component/backrooms_exile/proc/spawn_equipment(mob/living/user, list/to_spawn = default_equipment)
	if(QDELETED(user) || !length(to_spawn))
		return

	for(var/item_path in to_spawn)
		for(var/i = 1 to to_spawn[item_path])
			new item_path(get_turf(user))

/datum/component/backrooms_exile/proc/return_to_original()
	if(transfering_mind)
		return

	if(QDELETED(current_body))
		qdel(src)
		return

	transfering_mind = TRUE

	unsubscribe_from_body(current_body)

	if(QDELETED(original_body) || !original_body.mind)
		qdel(current_body)
		current_body = null
		transfering_mind = FALSE
		qdel(src)
		return

	var/datum/mind/M = current_body.mind
	if(!M)
		qdel(current_body)
		current_body = null
		transfering_mind = FALSE
		qdel(src)
		return

	M.transfer_to(original_body, TRUE)

	qdel(current_body)
	current_body = original_body

	transfering_mind = FALSE
	qdel(src)


/datum/component/backrooms_exile/proc/spawn_replacement_body()
	PRIVATE_PROC(TRUE)

	if(transfering_mind || exiling)
		return

	if(QDELETED(original_body) || QDELETED(current_body))
		qdel(src)
		return

	var/old_body = current_body
	var/datum/mind/M = current_body.mind
	if(!M)
		qdel(src)
		return

	transfering_mind = TRUE

	var/mob/living/new_body = create_body(original_body)
	if(QDELETED(new_body))
		transfering_mind = FALSE
		qdel(src)
		return

	unsubscribe_from_body(current_body)
	current_body = new_body
	new_body.forceMove(get_turf(pick(GLOB.backrooms_fall_points)))
	subscribe_to_body(new_body)

	saved_mind.transfer_to(new_body, TRUE)
	spawn_equipment(new_body)

	transfering_mind = FALSE
	qdel(old_body)

/datum/component/backrooms_exile/proc/on_owner_death(mob/living/owner, gibbed)
	SIGNAL_HANDLER

	if(exiling || transfering_mind)
		return

	if(owner != current_body || !in_backrooms)
		return

	addtimer(CALLBACK(src, PROC_REF(spawn_replacement_body)), 1)


/datum/component/backrooms_exile/proc/on_owner_move(mob/living/owner, atom/old_loc, dir, forced, list/old_locs)
	SIGNAL_HANDLER

	if(exiling || transfering_mind)
		return

	if(owner != current_body || !in_backrooms)
		return

	var/area/A = get_area(owner)
	if(!istype(A, /area/awaymission/secret/powered/backrooms))
		return_to_original()

/datum/component/backrooms_exile/proc/on_owner_pre_hear(mob/living/owner, list/signal_args)
	SIGNAL_HANDLER

	if(exiling || transfering_mind || !in_backrooms)
		return
	var/atom/movable/speaker = signal_args[1]
	if(current_body == speaker)
		return
	if(!iscarbon(speaker))
		return

	if(COOLDOWN_FINISHED(src, say_hallucination_cd) && prob(5))
		SEND_SOUND(current_body, sound(pick(
			'modular_zzplurt/sound/effects/necro/ubermorph_shout_1.ogg',
			'modular_zzplurt/sound/effects/necro/ubermorph_shout_2.ogg',
			'modular_zzplurt/sound/effects/necro/ubermorph_shout_3.ogg',
			'modular_zzplurt/sound/effects/necro/ubermorph_shout_4.ogg',
			'modular_zzplurt/sound/effects/necro/ubermorph_shout_5.ogg',
			'modular_zzplurt/sound/effects/necro/ubermorph_shout_6.ogg',
			'modular_zzplurt/sound/effects/necro/ubermorph_shout_7.ogg',
			'modular_zzplurt/sound/effects/necro/ubermorph_shout_8.ogg',
			'modular_zzplurt/sound/effects/necro/ubermorph_shout_long_1.ogg',
			'modular_zzplurt/sound/effects/necro/ubermorph_shout_long_2.ogg',
			'modular_zzplurt/sound/effects/necro/ubermorph_shout_long_3.ogg',
			'modular_zzplurt/sound/effects/necro/ubermorph_shout_long_4.ogg',
		)))
		COOLDOWN_START(src, say_hallucination_cd, rand(10 SECONDS, 45 SECONDS))
	return COMSIG_MOVABLE_CANCEL_HEARING

/datum/component/backrooms_exile/proc/clamp_sight(mob/living/body)
	PRIVATE_PROC(TRUE)

	var/desired_sight = (body.sight & ~BACKROOMS_BLOCKED_SIGHT) | BACKROOMS_GRANTED_SIGHT
	if(body.sight == desired_sight)
		return

	body.set_sight(desired_sight)

/datum/component/backrooms_exile/proc/on_owner_sight_change(mob/living/owner, new_sight, old_sight)
	SIGNAL_HANDLER

	if(owner != current_body || !in_backrooms)
		return

	clamp_sight(owner)

#undef BACKROOMS_BLOCKED_SIGHT
#undef BACKROOMS_GRANTED_SIGHT
#undef BACKROOMS_MANAGED_SIGHT


/datum/component/backrooms_exile/proc/on_original_body_death(mob/living/body, gibbed)
	if(exiling || transfering_mind)
		return

	if(body != original_body)
		return

	if(time_to_spend_in_backrooms == -1)
		return

	if(!in_backrooms)
		qdel(src)
		return

	return_to_original()

/datum/component/backrooms_exile/proc/mute_mob(mob/living/living)
	if(living?.client && !living.client.holder)
		original_muted = living.client.prefs.muted

		living.client.prefs.muted |= MUTE_OOC | MUTE_LOOC

/datum/component/backrooms_exile/proc/unmute_mob(mob/living/living)
	if(living?.client)
		living.client.prefs.muted = original_muted


/datum/smite/send_into_backrooms
	name = "Send into backrooms"
	var/how_long = 10
	var/instant = FALSE

/datum/smite/send_into_backrooms/configure(client/user)
	if(!GLOB.backrooms_loaded)
		to_chat(user, span_warning("Backrooms are not loaded! Load the map via the verb first!"))
		return
	how_long = tgui_input_number(user, "How long should the victim stay in the backrooms? -1 = ETERNITY", "Send to backrooms", 10, 240, -1, 30 SECONDS)

	var/do_instant = tgui_alert(user, "Should the target be sent to the backrooms instantly, or with a delay? \
						On average, it takes about a minute with a delay.", "Send", list("Deport them to Brazil right now!", "Let them sweat first!"), timeout = 30 SECONDS)
	if(do_instant == "Deport them to Brazil right now!")
		instant = TRUE
	else
		instant = FALSE

/datum/smite/send_into_backrooms/effect(client/user, mob/living/target)
	if(!GLOB.backrooms_loaded)
		return
	var/actual_time = how_long <= -1 ? -1 : how_long MINUTES

	target.AddComponent(/datum/component/backrooms_exile, exile_time = actual_time, instant = src.instant)
	message_admins("[key_name_admin(user)] is sending [ADMIN_LOOKUPFLW(target)] into the backrooms!")
