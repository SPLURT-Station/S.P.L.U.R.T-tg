/// The last scanned atom, without keeping deleted canisters or other targets alive.
/obj/item/analyzer
	var/datum/weakref/last_atmos_target

/// TGUI already polls ui_data; refresh only while the user can still scan the target.
/obj/item/analyzer/ui_data(mob/user)
	var/atom/target = last_atmos_target?.resolve()
	if(!QDELETED(target) && can_see(user, target, ranged_scan_distance))
		on_analyze(src, target)
	return ..()

/obj/item/analyzer/on_analyze(datum/source, atom/target)
	SIGNAL_HANDLER
	. = ..()
	if(target.return_analyzable_air() && last_atmos_target?.resolve() != target)
		last_atmos_target = WEAKREF(target)

/// Use the existing gas UI instead of printing the full gas report to chat.
/obj/item/analyzer/proc/scan_gases(mob/user, atom/target)
	if(QDELETED(target))
		return FALSE
	if(IS_UNCONSCIOUS_OR_CRIT(user) || !user.can_read(src) || user.is_blind())
		return FALSE
	if(!target.return_analyzable_air())
		return FALSE
	on_analyze(src, target)
	ui_interact(user)
	return TRUE

/obj/item/analyzer/attack_self(mob/user, modifiers)
	scan_gases(user, get_turf(src))

/obj/item/analyzer/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!HAS_TRAIT(interacting_with, TRAIT_COMBAT_MODE_SKIP_INTERACTION) && can_see(user, interacting_with, ranged_scan_distance))
		scan_gases(user, interacting_with.return_analyzable_air() ? interacting_with : get_turf(interacting_with))
	return NONE // Preserve the non-blocking interaction for non-atmospheric objects.

/// Objects handle tool_act before the item's interact_with_atom (notably canisters).
/// Keep the original handler for other analyzer tools and special diagnostics.
/obj/analyzer_act(mob/living/user, obj/item/analyzer/tool)
	if(istype(tool, /obj/item/analyzer) && return_analyzable_air())
		tool.scan_gases(user, src)
		return TRUE
	return ..()
