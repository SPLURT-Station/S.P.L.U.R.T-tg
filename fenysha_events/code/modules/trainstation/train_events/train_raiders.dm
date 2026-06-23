/obj/item/tank/jump_jetpack
	name = "Реактивный ранец-прыгун"
	desc = "Баллон со сжатым газом для использования в качестве реактивного ранца в условиях невесомости. \
			Использовать с осторожностью — резкие манёвры могут закончиться плохо."
	icon_state = "jetpack-mini"
	inhand_icon_state = "jetpack-black"
	lefthand_file = 'icons/mob/inhands/equipment/jetpacks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/jetpacks_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
	actions_types = list(/datum/action/cooldown/jetpack_jump)

	// Максимальная дистанция прыжка (в тайлах)
	var/jump_range = 7
	// Время колдауна
	var/jump_cooldown = 10 SECONDS

	// Пропасть в которую мы падаем
	var/turf/open/chasm/felling_chasm = null
	// Спасаемся ли мы в данный момент
	var/attempting = FALSE

/obj/item/tank/jump_jetpack/examine(mob/user)
	. = ..()
	. += span_boldnicegreen("Ранец-прыгун, может спасти вас от падения в пропасть, \
							давая время на то, чтобы вылетить из неё в случае падения.")

/obj/item/tank/jump_jetpack/equipped(mob/living/user, slot, initial)
	. = ..()
	if(slot == ITEM_SLOT_BELT && isliving(user))
		RegisterSignal(user, COMSIG_MOVABLE_CHASM_DROPPED, PROC_REF(on_chasm_drop))

/obj/item/tank/jump_jetpack/dropped(mob/user, silent)
	. = ..()
	UnregisterSignal(user, COMSIG_MOVABLE_CHASM_DROPPED)

/obj/item/tank/jump_jetpack/proc/on_chasm_drop(mob/living/user, turf/chasm_turf)
	SIGNAL_HANDLER
	if(user.stat == DEAD || attempting)
		return
	attempting = TRUE
	felling_chasm = chasm_turf
	rescue_process(user, chasm_turf)
	RegisterSignal(user, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(on_user_pre_move))
	return COMPONENT_NO_CHASM_DROP

/obj/item/tank/jump_jetpack/proc/on_user_pre_move(mob/living/user, atom/new_loc)
	SIGNAL_HANDLER

	if(!attempting)
		UnregisterSignal(user, COMSIG_MOVABLE_PRE_MOVE)
		return

	if(felling_chasm || attempting)
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/obj/item/tank/jump_jetpack/proc/rescue_process(mob/living/user, turf/chasm_turf)
	var/datum/component/chasm/chasm = chasm_turf.GetComponent(/datum/component/chasm)
	chasm?.falling_atoms -= WEAKREF(user)

	var/matrix/drop_transfrom = matrix()
	drop_transfrom.Scale(0.1, 0.1)
	animate(user, alpha = 100, transform = drop_transfrom, time = 5 SECONDS)
	to_chat(user, span_userdanger("Ты падешь в безду, срочно найди цель, чтобы выпрыгнуть!"))
	addtimer(CALLBACK(src, PROC_REF(check_rescue), user), 5 SECONDS)

/obj/item/tank/jump_jetpack/proc/check_rescue(mob/living/user)
	if(!attempting || !felling_chasm)
		return // Мы спаслись

	UnregisterSignal(user, COMSIG_MOVABLE_PRE_MOVE)
	var/rescued = FALSE
	var/turf/user_turf = get_turf(user)

	if(!ischasm(user_turf))
		rescued = TRUE
	else if(HAS_TRAIT(user_turf, TRAIT_CHASM_STOPPED))
		rescued = FALSE

	if(rescued)
		attempting = FALSE
		felling_chasm = null
	else
		drop_back(user, user_turf)

/obj/item/tank/jump_jetpack/proc/drop_back(mob/living/user, turf/chasm_turf)
	var/datum/component/chasm/chasm = chasm_turf.GetComponent(/datum/component/chasm)
	chasm.drop(user)
	user.alpha = initial(user.alpha)
	user.transform = initial(user.transform)
	attempting = FALSE
	felling_chasm = null

/obj/item/tank/jump_jetpack/proc/jumped(mob/living/user, turf/jump_from)
	if(attempting && felling_chasm)
		UnregisterSignal(user, COMSIG_MOVABLE_PRE_MOVE)
		animate(user, alpha = 255, transform = initial(user.transform), time = 1 SECONDS)
		attempting = FALSE
		felling_chasm = null

/datum/action/cooldown/jetpack_jump
	name = "Прыжок с реактивным ранцем"
	desc = "Активируй и выбери це ль, чтобы совершить мощный прыжок к ней!"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "jetboot"
	background_icon = 'icons/mob/actions/actions_items.dmi'
	background_icon_state = "storage_gather_switch"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED
	cooldown_time = 10 SECONDS
	text_cooldown = TRUE
	click_to_activate = TRUE
	shared_cooldown = MOB_SHARED_COOLDOWN_1

/datum/action/cooldown/jetpack_jump/Activate(atom/target)
	if(!target)
		return FALSE

	var/mob/living/carbon/human/jumper = owner
	var/obj/item/tank/jump_jetpack/jetpack = locate() in owner.contents
	if(!jetpack)
		jumper.balloon_alert(jumper, "Ранец пропал!")
		return FALSE

	if(isclosedturf(target))
		jumper.balloon_alert(jumper, "Туда нельзя прыгнуть!")
		return FALSE

	var/turf/target_turf = target
	if(!can_see(target_turf, jumper, jetpack.jump_range))
		jumper.balloon_alert(jumper, "Слишком далеко!")
		return FALSE
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		if(human_owner.resting)
			human_owner.set_resting(FALSE, TRUE, TRUE)

	new /obj/effect/temp_visual/telegraphing/boss_hit(target_turf)

	var/ignores = IGNORE_SLOWDOWNS|IGNORE_TARGET_LOC_CHANGE|IGNORE_USER_LOC_CHANGE
	if(!do_after(jumper, 0.2 SECONDS, jumper, ignores, max_interact_count = 1))
		StartCooldown(2 SECONDS)
		jumper.balloon_alert(jumper, "Прыжок прерван!")
		return FALSE

	INVOKE_ASYNC(src, PROC_REF(perform_jump), jumper, target_turf, jetpack)
	StartCooldown(jetpack.jump_cooldown)

/datum/action/cooldown/jetpack_jump/proc/perform_jump(mob/living/carbon/human/jumper, turf/target_turf, obj/item/tank/jump_jetpack/jetpack)
	if(!jetpack)
		return

	jumper.movement_type = FLYING
	// Подготовка
	var/saved_passflags = jumper.pass_flags
	var/given_traits = list(TRAIT_CHASM_STOPPER, TRAIT_TURF_IGNORE_SLOWDOWN)
	jumper.pass_flags = PASSTABLE|PASSGRILLE|PASSBLOB|PASSMOB|LETPASSTHROW|PASSMACHINE|PASSSTRUCTURE|PASSVEHICLE|LETPASSCLICKS
	jumper.add_traits(given_traits, REF(jetpack))

	if(jumper.buckled)
		var/atom/movable/our_vehicle = jumper.buckled
		our_vehicle.unbuckle_mob(jumper, TRUE, FALSE)


	playsound(jumper, 'sound/items/weapons/resonator_blast.ogg', 100, TRUE)
	new /obj/effect/temp_visual/fire(get_turf(jumper))

	var/start_z = jumper.pixel_z
	var/start_y = jumper.pixel_y

	jumper.set_anchored(TRUE)

	var/dist_to_turf = get_dist(jumper, target_turf)
	var/steps = dist_to_turf * 4
	var/apex_height = 60 + dist_to_turf * 9  // Высота дуги прыжка

	jetpack.jumped(jumper, get_turf(jumper))

	for(var/i in 1 to steps)
		if(get_turf(jumper) == target_turf)
			break
		if(!jetpack)
			break

		var/t = i / steps
		var/height_mult = 1.0
		if(t < 0.15)
			height_mult = 1 + 2.5 * (1 - t/0.15)**2

		var/height = 4 * t * (1 - t)
		height *= 1 + 0.25 * sin(t * 180)

		var/current_z = start_z + apex_height * height * height_mult
		var/current_y = start_y + (apex_height * 0.55) * height
		var/lean = -sin(t * 180) * 25
		var/dx = target_turf.x - jumper.x
		lean += dx * 8

		jumper.transform = matrix(jumper.transform) * matrix(lean, MATRIX_ROTATE)
		jumper.pixel_z = current_z
		jumper.pixel_y = current_y

		new /obj/effect/temp_visual/decoy/fading/halfsecond(get_turf(jumper), jumper, 200)

		if(i % 4 == 0)
			var/turf/next_turf = get_step_towards(jumper, target_turf)

			var/pass = TRUE
			if(!next_turf.CanPass(jumper, jumper.dir))
				pass = FALSE
			if(pass)
				for(var/atom/thing in next_turf.contents)
					if(!thing.CanPass(jumper, jumper.dir))
						pass = FALSE
						break
			if(!pass)
				break

			jumper.forceMove(next_turf)
		sleep(2 TICKS)

	jumper.set_anchored(FALSE)
	jumper.movement_type = GROUND
	jumper.pass_flags = saved_passflags
	jumper.remove_traits(given_traits, REF(jetpack))

	jumper.pixel_z = start_z
	jumper.pixel_y = start_y
	jumper.transform = initial(jumper.transform)

	unset_click_ability(jumper, refund_cooldown = FALSE)
	playsound(jumper, 'sound/items/weapons/kinetic_accel.ogg', 100, TRUE)
	var/turf/jumper_turf = get_turf(jumper)
	jumper_turf.Entered(jumper)

	// Удар по приземлению
	for(var/mob/living/L in get_turf(jumper))
		if(L == jumper)
			continue
		L.Knockdown(2 SECONDS)

/obj/item/tank/jump_jetpack/fast
	jump_cooldown = 3 SECONDS
	jump_range = 10


/datum/outfit/train_raider
	name = "Рейдер поезда — базовый"

	uniform = /obj/item/clothing/under/rank/centcom/military
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/storage/backpack
	ears = /obj/item/radio/headset/syndicate/alt
	suit = /obj/item/clothing/suit/armor/vest/alt
	r_pocket = /obj/item/knife/combat
	l_pocket = /obj/item/ammo_box/magazine/c35sol_pistol
	id = /obj/item/card/id/advanced/chameleon/black
	belt = /obj/item/tank/jump_jetpack

	box = /obj/item/storage/box/survival/syndie
	id_trim = /datum/id_trim/chameleon/operative
	backpack_contents = list(
		/obj/item/gun/ballistic/automatic/pistol/aps = 1,
		/obj/item/ammo_box/magazine/m9mm_aps/ap = 1,
		/obj/item/storage/medkit/regular = 1,
	)

	var/winter_coat = /obj/item/clothing/suit/hooded/wintercoat

/datum/outfit/train_raider/post_equip(mob/living/carbon/human/user, visuals_only)
	. = ..()

	var/obj/item/radio/radio = user.ears
	radio.set_frequency(FREQ_SYNDICATE)
	radio.freqlock = RADIO_FREQENCY_LOCKED

	var/obj/item/implant/weapons_auth/weapons_implant = new/obj/item/implant/weapons_auth(user)
	weapons_implant.implant(user)

	var/obj/item/clothing/suit/coat = new winter_coat()
	if(istype(coat, /obj/item/clothing/suit))
		coat.slot_flags = ITEM_SLOT_NECK
		coat.cold_protection = null
		coat.heat_protection = null
		coat.slowdown = 0
		coat.set_armor(/datum/armor/none)
		user.equip_to_slot_or_del(coat, ITEM_SLOT_NECK)

	user.add_faction(ROLE_SYNDICATE)
	user.update_icons()


/datum/outfit/train_raider/shotgun
	name = "Рейдер поезда — дробовик"
	r_hand = /obj/item/gun/ballistic/shotgun/automatic/combat/compact

/datum/outfit/train_raider/shotgun/New()
	backpack_contents += list(
		/obj/item/storage/box/lethalshot = 1,
		/obj/item/grenade/c4 = 1,
	)
	. = ..()


/datum/outfit/train_raider/rifleman
	name = "Рейдер поезда — автоматчик"
	r_hand = /obj/item/gun/ballistic/automatic/mini_uzi

/datum/outfit/train_raider/rifleman/New()
	backpack_contents += list(
		/obj/item/ammo_box/magazine/uzim9mm = 3,
	)
	. = ..()


/datum/job/train_raider
	title = "Рейдер поезда"


/datum/antagonist/train_raider
	name = "Рейдер поезда"
	roundend_category = "рейдеры"
	antagpanel_category = ANTAG_GROUP_SYNDICATE
	pref_flag = ROLE_TRAITOR
	antag_hud_name = "synd"
	antag_moodlet = /datum/mood_event/focused
	show_to_ghosts = TRUE
	hijack_speed = 2
	suicide_cry = "ЗА СИНДИКАТ!!"

	var/static/list/possible_outfits = list(
		/datum/outfit/train_raider/rifleman,
		/datum/outfit/train_raider/shotgun,
	)

/datum/antagonist/train_raider/on_gain()
	forge_objectives()
	equip_raider()
	. = ..()

/datum/antagonist/train_raider/forge_objectives()
	var/datum/objective/custom/destroy_cargo = new()
	destroy_cargo.name = "Уничтожить груз"
	destroy_cargo.explanation_text = "Разрушь целостность перевозимого поезда груза и захвати ресурсы!"
	objectives += destroy_cargo


/datum/antagonist/train_raider/proc/equip_raider()
	var/outfit = pick(possible_outfits)
	if(!ishuman(owner.current))
		return

	var/mob/living/carbon/human/raider = owner.current
	ADD_TRAIT(raider, TRAIT_NOFEAR_HOLDUPS, INNATE_TRAIT)

	if(!outfit)
		return
	raider.equip_species_outfit(outfit)


/datum/round_event_control/train_raiders
	name = "Рейдеры поезда"
	category = EVENT_CATEGORY_INVASION
	description = "Группа рейдеров окружила поезд, чтобы ворваться внутрь и уничтожить груз."
	typepath = /datum/round_event/ghost_role/train_raiders
	weight = 0  // По умолчанию выключено, включается вручную или через админку

/datum/round_event/ghost_role/train_raiders
	minimum_required = 1

	var/static/list/possible_vehicles = list(
		/obj/vehicle/ridden/trainstation/bike,
		/obj/vehicle/ridden/trainstation/bike/red,
		/obj/vehicle/ridden/trainstation/bike/blue,
		/obj/vehicle/ridden/trainstation/bike/green,
	)
	announce_when = 20


/datum/round_event/ghost_role/train_raiders/spawn_role()
	var/list/chosen = SSpolling.poll_ghost_candidates(
		check_jobban = ROLE_TRAITOR,
		role = ROLE_TRAITOR,
		role_name_text = "Рейдер поезда",
		alert_pic = /obj/vehicle/ridden/trainstation,
		amount_to_pick = 4
	)

	if(!islist(chosen))
		chosen = list(chosen)

	if(isnull(chosen))
		return NOT_ENOUGH_PLAYERS

	var/list/spawn_points = null
	for(var/obj/effect/landmark/trainstation/raider_spawnpoint/spawn_point in GLOB.landmarks_list)
		LAZYADD(spawn_points, spawn_point)

	if(!length(spawn_points))
		return MAP_ERROR

	for(var/mob/mob in chosen)
		var/turf/spawn_location = get_turf(pick(spawn_points))
		spawn_bad_guy(spawn_location, mob.client)

	return SUCCESSFUL_SPAWN


/datum/round_event/ghost_role/train_raiders/proc/spawn_bad_guy(turf/spawn_turf, client/bad_guy)
	var/mob/living/carbon/human/raider = new(spawn_turf)
	raider.randomize_human_appearance(~RANDOMIZE_SPECIES)
	raider.dna.update_dna_identity()

	var/datum/mind/mind = new /datum/mind(bad_guy.key)
	mind.set_assigned_role(SSjob.get_job_type(/datum/job/train_raider))
	mind.active = TRUE
	mind.transfer_to(raider)

	if(!raider.client?.prefs.read_preference(/datum/preference/toggle/nuke_ops_species))
		var/species_type = raider.client.prefs.read_preference(/datum/preference/choiced/species)
		raider.set_species(species_type)

	mind.add_antag_datum(/datum/antagonist/train_raider)

	var/bike_type = pick(possible_vehicles)
	var/obj/vehicle/ridden/trainstation/raider_bike = new bike_type(spawn_turf)
	raider_bike.dir = SStrain_controller.abstract_moving_direction
	raider_bike.buckle_mob(raider)

	INVOKE_ASYNC(src, PROC_REF(strike_raider), raider, raider_bike)

	spawned_mobs += raider
	message_admins("[ADMIN_LOOKUPFLW(raider)] стал одиночным рейдером поезда через событие.")
	raider.log_message("был заспавнен как рейдер поезда через событие.", LOG_GAME)


/datum/round_event/ghost_role/train_raiders/proc/strike_raider(mob/living/raider, obj/vehicle/ridden/trainstation/raider_bike)
	if(!raider || !raider_bike)
		return

	if(raider.open_uis)
		for(var/datum/tgui/ui in raider.open_uis)
			ui.close(FALSE)

	var/turf/target_turf = get_ranged_target_turf(raider_bike, raider_bike.dir, 15)
	if(!target_turf)
		return

	for(var/i in 1 to 15)
		raider_bike.Shake()
		new /obj/effect/temp_visual/decoy/fading/halfsecond(get_turf(raider_bike), raider_bike, 200)
		new /obj/effect/temp_visual/decoy/fading/halfsecond(get_turf(raider_bike), raider, 200)
		raider_bike.forceMove(get_step_towards(raider_bike, target_turf))
		sleep(3 TICKS)
		CHECK_TICK

	if(station_time() > 18 HOURS)
		raider_bike.set_light_on(TRUE)
	raider_bike.last_real_move = world.time + 10 SECONDS

	var/reminder = span_big(span_boldnotice("Не забудь использовать свой прыжковый ранец! Иконка в левом верхнем углу!"))
	to_chat(raider, reminder)
