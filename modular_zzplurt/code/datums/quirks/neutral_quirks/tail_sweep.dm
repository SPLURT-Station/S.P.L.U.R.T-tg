/// Maximum amount of items that tail sweep can throw at once
#define TAILSWEEP_MAX_OBJECTS 4

/// The amount of seconds between being able to tail sweep again- in seconds
#define TAILSWEEP_DELAY 10

/// % chance out of 100 that a tail sweep will occur when turning
#define TAILSWEEP_CHANCE 25

/datum/quirk/tail_sweep
	name = "Clumsy Tail"
	desc = "For as long as you can remember, you've had a habit of knocking things off tables with your tail when turning. It's a bit embarrassing, but you can't seem to help it."
	value = 0
	gain_text = span_notice("You feel an urge to sweep things off tables with your tail.")
	lose_text = span_notice("You feel less inclined to sweep things off tables with your tail.")
	medical_record_text = "Patient has a habit of clumsily knocking things off tables with their tail when turning."
	icon = FA_ICON_ARROWS_H
	COOLDOWN_DECLARE(swipe_cooldown)

/datum/quirk/tail_sweep/add(client/client_source)
	RegisterSignal(quirk_holder, COMSIG_ATOM_POST_DIR_CHANGE, PROC_REF(on_dir_change))

/datum/quirk/tail_sweep/remove()
	UnregisterSignal(quirk_holder, COMSIG_ATOM_POST_DIR_CHANGE)

/datum/quirk/tail_sweep/proc/on_dir_change(mob/living/carbon/affected_mob, old_dir, new_dir)

	SIGNAL_HANDLER
	if(affected_mob.stat == DEAD)
		return
	if(old_dir == new_dir)
		return
	if(affected_mob.resting)
		return
	var/obj/item/organ/tail/tail = affected_mob.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
	if(isnull(tail))
		return
	if(!prob(TAILSWEEP_CHANCE))
		return
	if(!COOLDOWN_FINISHED(src, swipe_cooldown))
		return
	var/turf/pos_to_check = get_step(affected_mob, REVERSE_DIR(affected_mob.dir))
	var/obj/structure/table/tabled = locate(/obj/structure/table, pos_to_check)
	if(isnull(tabled))
		return
	// And one final check, to stop it from triggering through windoors and railings.
	if(!affected_mob.Adjacent(pos_to_check))
		return

	var/list/items_to_move = list()
	for(var/obj/item/possible_move in pos_to_check.contents)
		if(possible_move.anchored)
			continue
		items_to_move += possible_move

	// Nothing to move? No problem. Shouldn't bother.
	if(!length(items_to_move))
		return

	for(var/i in 1 to TAILSWEEP_MAX_OBJECTS)
		if(!items_to_move.len)
			break
		var/obj/sweeped = pick_n_take(items_to_move)
		sweeped.throw_at(get_ranged_target_turf(sweeped, pick(GLOB.cardinals-new_dir), range = 1), range = 1, speed = 1)

	playsound(pos_to_check, SFX_RUSTLE, 50, TRUE, -5)
	affected_mob.visible_message(span_danger("[affected_mob] turns, sweeping their tail across \the [tabled]!"), span_notice("You turn, sweeping your tail across \the [tabled]."))

	COOLDOWN_START(src, swipe_cooldown, TAILSWEEP_DELAY SECONDS)

#undef TAILSWEEP_MAX_OBJECTS
#undef TAILSWEEP_DELAY
#undef TAILSWEEP_CHANCE
