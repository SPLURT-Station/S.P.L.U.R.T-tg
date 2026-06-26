GLOBAL_LIST_INIT(train_spwaner_themes, init_train_themes())
GLOBAL_LIST_EMPTY(train_object_spawners)

/proc/init_train_themes()
	var/list/themes = list()
	for (var/datum/train_object_spawner_theme/theme as anything in subtypesof(/datum/train_object_spawner_theme))
		themes[theme] = new theme()
	return themes

/datum/train_object_spawner_theme
	var/list/weighted_spawnlist

	var/general_spawn_chance = 50
	var/min_delay = 1 SECONDS
	var/max_delay = 3 SECONDS
	var/accuracy_min = 1
	var/accuracy_max = 1
	var/allow_selection = TRUE

	var/options = list()
	var/spawn_side = TRANSITION_BOTH

/datum/train_object_spawner_theme/New()
	. = ..()
	/*
	if(weighted_spawnlist && islist(weighted_spawnlist))
		for(var/object_type in weighted_spawnlist)
			POOL_REGISTER(object_type)
	*/

/datum/train_object_spawner_theme/proc/on_selected()
	return

/datum/train_object_spawner_theme/proc/on_deselected()
	return


/datum/train_object_spawner_theme/forest
	max_delay = 4 SECONDS
	options = list(
		SPAWNER_GROUP_NEAR_RAILS = list(
			GROUP_SPAWN_CHANCE = 80,
			GROUP_SPAWN_RANGE = 1,
			GROUP_WEIGHTED_SPAWNLIST = list(
				/obj/structure/flora/tree/pine/style_random = 80,
				/obj/structure/flora/tree/dead/style_random = 20,
			)
		),
		SPAWNER_GROUP_CENTER = list(
			GROUP_SPAWN_CHANCE = 50,
			GROUP_SPAWN_RANGE = 3,
			GROUP_WEIGHTED_SPAWNLIST = list(
				/obj/structure/flora/bush/snow/style_random = 20,
				/obj/structure/flora/grass/both/style_random = 20,
			)
		)
	)


/datum/train_object_spawner_theme/bridge
	max_delay = 3 SECONDS
	min_delay = 3 SECONDS
	options = list(
		SPAWNER_GROUP_NEAR_RAILS = list(
			GROUP_SPAWN_CHANCE = 100,
			GROUP_SPAWN_RANGE = 0,
			GROUP_WEIGHTED_SPAWNLIST = list(
				/obj/structure/prop/city/street_on = 100,
			)
		),
	)


/datum/train_object_spawner_theme/war
	weighted_spawnlist = list(
		/obj/structure/flora/tree/dead/style_random = 60,
		/obj/structure/flora/grass/both/style_random = 20,
		/obj/effect/decal/cleanable/blood/gibs/body = 15,
		/obj/effect/decal/cleanable/blood/gibs/down = 15,
		/obj/structure/mecha_wreckage/durand = 15,
		/obj/structure/mecha_wreckage/seraph = 15,
		/obj/structure/mecha_wreckage/marauder = 15,
		/obj/structure/prop/vehicle/tank/broken = 5,
	)
	accuracy_max = 2
	max_delay = 3 SECONDS
	allow_selection = FALSE

/datum/train_object_spawner_theme/they
	weighted_spawnlist = list(
		/obj/structure/flora/tree/dead/style_random = 70,
		/obj/structure/flora/grass/both/style_random = 25,
		/obj/structure/prop/special_they = 5,
	)
	accuracy_max = 2
	max_delay = 7 SECONDS
	allow_selection = FALSE



/obj/effect/landmark/trainstation/object_spawner
	name = "Object spawner"

	var/group = NONE
	VAR_PRIVATE/spawn_chance = 100
	VAR_PRIVATE/spawn_range = 0 //0 means on the same tile
	VAR_PRIVATE/spawn_list

	VAR_PRIVATE/datum/train_object_spawner_theme/theme
	VAR_PRIVATE/spawning = FALSE

	COOLDOWN_DECLARE(spawn_cd)


/obj/effect/landmark/trainstation/object_spawner/Initialize(mapload)
	. = ..()

	RegisterSignal(SStrain_controller, COMSIG_TRAIN_BEGIN_MOVING, PROC_REF(on_train_begin_moving))
	RegisterSignal(SStrain_controller, COMSIG_TRAIN_STOP_MOVING, PROC_REF(on_train_stop_moving))
	GLOB.train_object_spawners += src
	set_theme(SStrain_controller.selected_theme)
	if(SStrain_controller.is_moving())
		START_PROCESSING(SSobj, src)

/obj/effect/landmark/trainstation/object_spawner/Destroy()
	. = ..()
	GLOB.train_object_spawners -= src

/obj/effect/landmark/trainstation/object_spawner/proc/set_theme(datum/train_object_spawner_theme/new_theme)
	theme = new_theme

	var/list/group_options

	if(new_theme.options[TRANSITION_TOP_SIDE] || new_theme.options[TRANSITION_BOTTOM_SIDE])
		if(theme.spawn_side == TRANSITION_TOP_SIDE && is_top_side())
			group_options = new_theme.options[TRANSITION_TOP_SIDE][group]
		else if(theme.spawn_side == TRANSITION_BOTTOM_SIDE && !is_top_side())
			group_options = new_theme.options[TRANSITION_BOTTOM_SIDE][group]
		else if(theme.spawn_side == TRANSITION_BOTH)
			if(is_top_side() && new_theme.options[TRANSITION_TOP_SIDE])
				group_options = new_theme.options[TRANSITION_TOP_SIDE][group]
			else if(new_theme.options[TRANSITION_BOTTOM_SIDE])
				group_options = new_theme.options[TRANSITION_BOTTOM_SIDE][group]
	else
		group_options = new_theme.options[group]

	if(!group_options || !islist(group_options))
		spawn_chance = 0
		spawn_list = null
		spawn_range = 0
		return

	spawn_chance = group_options[GROUP_SPAWN_CHANCE] || new_theme.general_spawn_chance
	spawn_list = group_options[GROUP_WEIGHTED_SPAWNLIST] || null
	spawn_range = group_options[GROUP_SPAWN_RANGE] || 0


/obj/effect/landmark/trainstation/object_spawner/proc/on_train_begin_moving()
	SIGNAL_HANDLER
	START_PROCESSING(SSobj, src)

/obj/effect/landmark/trainstation/object_spawner/proc/on_train_stop_moving()
	SIGNAL_HANDLER
	STOP_PROCESSING(SSobj, src)

/obj/effect/landmark/trainstation/object_spawner/process(seconds_per_tick)
	if(spawning || !SStrain_controller.allow_spawning() || !theme || !spawn_chance)
		return
	if(spawn_chance < 100 && !ROUND_PROB(spawn_chance))
		return
	if(!COOLDOWN_FINISHED(src, spawn_cd))
		return
	COOLDOWN_START(src, spawn_cd, rand(theme.min_delay, theme.max_delay))
	INVOKE_ASYNC(src, PROC_REF(attempt_spawn))

/obj/effect/landmark/trainstation/object_spawner/proc/is_top_side()
	var/static/obj/effect/landmark/trainstation/train_spawnpoint/SP
	if(!SP)
		SP = locate() in GLOB.landmarks_list

	return x > SP.x

/obj/effect/landmark/trainstation/object_spawner/proc/attempt_spawn()
	if(!length(spawn_list))
		return
	spawning = TRUE
	var/turf/target_turf = get_turf(src)
	var/accuracy = rand(0, spawn_range)
	if(accuracy > 0)
		for(var/turf/T as anything in shuffle(RANGE_TURFS(accuracy, src)))
			if(!can_see(src, T, accuracy))
				continue
			if(isopenturf(T) || !T.density || T.type == target_turf.type)
				target_turf = T
				break
	var/selected = pick_weight(spawn_list)

	var/atom/movable/new_obj = POOL_TAKE(selected, src)
	new_obj.forceMove(src)
	if(new_obj)
		ASYNC
			new_obj.Move(target_turf, update_dir = FALSE)
	spawning = FALSE

/obj/effect/landmark/trainstation/object_spawner/backdrop
	group = SPAWNER_GROUP_BACKDROP

/obj/effect/landmark/trainstation/object_spawner/center
	group = SPAWNER_GROUP_CENTER

/obj/effect/landmark/trainstation/object_spawner/near_rails
	group = SPAWNER_GROUP_NEAR_RAILS

/obj/effect/landmark/trainstation/object_spawner/foreign
	group = SPAWNER_GROUP_FOREIGN

