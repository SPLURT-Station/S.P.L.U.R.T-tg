/// Gas analyzer scans go to its UI window, which keeps refreshing the last scanned air instead of printing to chat.
/obj/item/analyzer
	/// Weakref to the atom whose air the UI is tracking. Pointing at the analyzer itself tracks the air around it.
	var/datum/weakref/tracked_scan_target

/obj/item/analyzer/attack_self(mob/user, modifiers)
	if(IS_UNCONSCIOUS_OR_CRIT(user) || !user.can_read(src) || user.is_blind())
		return
	scan_to_ui(user, src)

/obj/item/analyzer/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(HAS_TRAIT(interacting_with, TRAIT_COMBAT_MODE_SKIP_INTERACTION) || !can_see(user, interacting_with, ranged_scan_distance))
		return NONE
	scan_to_ui(user, interacting_with.return_analyzable_air() ? interacting_with : get_turf(interacting_with))
	return NONE // Non-blocking

/obj/analyzer_act(mob/living/user, obj/item/analyzer/tool)
	if(istype(tool) && tool.scan_to_ui(user, src))
		return TRUE
	return ..()

/obj/item/analyzer/process(seconds_per_tick)
	if(!LAZYLEN(open_uis) || !refresh_tracked_scan())
		tracked_scan_target = null
		return PROCESS_KILL

/// Rescans the tracked target into the UI data. Returns FALSE once the target is gone or out of range.
/obj/item/analyzer/proc/refresh_tracked_scan()
	var/atom/target = tracked_scan_target?.resolve()
	var/atom/air_source = get_air_source(target)
	if(QDELETED(target) || !air_source || !ismob(loc) || get_dist(get_turf(src), get_turf(air_source)) > ranged_scan_distance)
		return FALSE
	on_analyze(src, air_source)
	return TRUE

/// Returns the atom whose air should be read for a tracked target. The analyzer itself stands for its surroundings.
/obj/item/analyzer/proc/get_air_source(atom/target)
	return target == src ? get_turf(src) : target

/// Scans the target into the UI, opens it, and keeps it refreshing while the target stays in range.
/obj/item/analyzer/proc/scan_to_ui(mob/user, atom/target)
	var/atom/air_source = get_air_source(target)
	if(!air_source?.return_analyzable_air())
		return FALSE
	if(isliving(user))
		playsound(user, SFX_INDUSTRIAL_SCAN, 20, TRUE, -2, TRUE, FALSE)
		user.visible_message(span_notice("[user] uses the analyzer on [icon2html(air_source, viewers(user))] [air_source]."), ignored_mobs = user)
	tracked_scan_target = WEAKREF(target)
	on_analyze(src, air_source)
	START_PROCESSING(SSobj, src)
	ui_interact(user)
	return TRUE
