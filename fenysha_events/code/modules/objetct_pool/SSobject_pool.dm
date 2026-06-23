/*
   _____  _____   _                  _   _           _
  / ____|/ ____| | |                | | | |         | |
 | |  __| |      | | _____   _____  | |_| |__   __ _| |_
 | | |_ | |      | |/ _ \ \ / / _ \ | __| '_ \ / _` | __|
 | |__| | |____  | | (_) \ V /  __/ | |_| | | | (_| | |_
  \_____|\_____| |_|\___/ \_/ \___|  \__|_| |_|\__,_|\__|

*/
SUBSYSTEM_DEF(object_pool)
	name = "Object Pool"
	flags = SS_NO_FIRE | SS_INIT_NO_NEED

	/// type => list of pooled instances (stack: pop from end)
	var/list/pools = list()
	/// type => template instance
	var/list/templates = list()
	/// type => precomputed list of var keys to copy
	var/list/copy_vars = list()

	/// Максимальный размер пула по умолчанию
	var/static/pool_max_size = 500

	var/static/list/var_blacklist = list(
		"type", "parent_type", "vars",
		// GC и уничтожение
		"gc_destroyed", "harddel_deets_dumped",
		// Позиционирование и структура
		"x", "y", "z", "loc", "locs", "contents",
		// Ссылки и теги
		"tag", "weak_reference", "weakref",
		"_active_timers", "_datum_components", "_listen_lookup", "_signal_procs", "_status_traits",
		"datum_flags", "cooldowns",
		// UI
		"open_uis", "verbs",
		// Визуальные списки и специальные поля
		"appearance", "appearance_flags", "blend_mode",
		"overlays", "underlays", "vis_contents", "vis_locs", "filters",
		"render_source", "render_target", "override",
		// Дополнительные фильтры и кэши
		"filter_data", "filter_cache",
		// Прочие
		"layout_prefs_used", "abstract_type"
	)

/datum/controller/subsystem/object_pool/proc/RegisterType(datum/typepath)
	if(!ispath(typepath) || templates[typepath])
		return

	var/datum/template = new typepath()
	templates[typepath] = template

	var/list/keys = list()

	for(var/key in template.vars)

		if(key in var_blacklist)
			continue
		if(istext(key) && length(key) >= 2 && copytext(key, 1, 2) == "_")
			#ifdef TESTING
			log_world("ObjectPool: skipped potentially private/protected var '[key]' on type [typepath]")
			#endif
			continue
		if(findtext(key, "SpacemanDMM_") || findtext(key, "internal") || findtext(key, "private"))
			continue
		keys += key

	copy_vars[typepath] = keys

	if(istype(template, /obj/machinery))
		SSmachines.unregister_machine(template)

	INVOKE_ASYNC(src, PROC_REF(WarmupPool), typepath)

/datum/controller/subsystem/object_pool/proc/WarmupPool(typepath, target_size = 500)
    var/list/pool = pools[typepath] || (pools[typepath] = list())
    var/to_create = target_size - length(pool)
    if(to_create <= 0)
        return

    for(var/i in 1 to min(to_create, 50))
        var/datum/new_instance = new typepath()
        Release(new_instance)
        CHECK_TICK

    if(length(pool) < target_size)
        addtimer(CALLBACK(src, PROC_REF(WarmupPool), typepath, target_size), 1)


/datum/controller/subsystem/object_pool/proc/Take(datum/type, ...)
	if(!ispath(type))
		CRASH("Object pool Take called with non-path: [type]")

	RegisterType(type)

	var/list/pool = pools[type]
	var/datum/instance
	var/list/init_args = length(args) > 1 ? args.Copy(2) : list()

	if(LAZYLEN(pool))
		instance = pool[pool.len]
		pool.len--
		if(!LAZYLEN(pool))
			pools[type] = null

		if(isatom(instance))
			var/atom/A = instance
			if(A.flags_1 & INITIALIZED_1)
				A.flags_1 &= ~INITIALIZED_1 //На всякий случай
			A.Initialize(arglist(init_args))
	else
		instance = length(args) > 1 ? new type(arglist(args)) : new type()

	return instance

/datum/controller/subsystem/object_pool/proc/ReleaseAsync(datum/instance)
	INVOKE_ASYNC(src, PROC_REF(Release), instance)

/datum/controller/subsystem/object_pool/proc/Release(datum/instance)
	if(!istype(instance))
		return

	var/instance_type = instance.type
	if(!templates[instance_type])
		qdel(instance)
		return

	instance.Destroy(TRUE)

	if(istype(instance, /atom))
		var/atom/A = instance
		A.flags_1 &= ~INITIALIZED_1
		//A.cut_overlays()
		A.clear_filters()

	if(istype(instance, /atom/movable))
		var/atom/movable/AM = instance
		AM.moveToNullspace()

	instance.tag = null
	instance.weak_reference = null

	var/list/keys = copy_vars[instance_type]
	var/datum/template = templates[instance_type]
	for(var/key in keys)
		var/val = template.vars[key]
		if(islist(val))
			var/list/list_val = val
			instance.vars[key] = list_val.Copy()
		else if(isdatum(val))
			instance.vars[key] = null
		else
			instance.vars[key] = val

	var/list/pool = pools[instance_type] || (pools[instance_type] = list())
	if(length(pool) < pool_max_size)
		pool += instance
	else
		qdel(instance)


/datum/controller/subsystem/object_pool/proc/Delete(datum/instance)
	if(istype(instance))
		qdel(instance)
