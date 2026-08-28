/obj/vore_belly/proc/HandleBellyReagents(seconds_per_tick)
	if(!reagent_belly_mode || !owner || !owner.parent || !reagents)
		return

	var/mob/living/pred = owner.parent

	// If we are at capacity, don't generate more
	if(reagents.total_volume >= reagent_custom_max_volume)
		// We still want to apply effects to prey
		HandleBellyReagentEffects(seconds_per_tick)
		return

	// Generate reagents based on pred's nutrition
	if(isrobot(pred))
		var/mob/living/silicon/robot/R = pred
		if(R.cell && R.cell.charge >= reagent_gen_cost * 10)
			R.use_energy(reagent_gen_cost * 10)
			reagents.add_reagent(reagent_type_id, reagent_gen_amount * seconds_per_tick)
	else
		if(pred.nutrition >= reagent_gen_cost)
			pred.adjust_nutrition(-reagent_gen_cost * seconds_per_tick)
			reagents.add_reagent(reagent_type_id, reagent_gen_amount * seconds_per_tick)
			
	HandleBellyReagentEffects(seconds_per_tick)

/obj/vore_belly/proc/HandleBellyReagentEffects(seconds_per_tick)
	if(!length(contents) || reagents.total_volume < reagent_splash_tick)
		return

	var/affecting_amt = min(reagents.total_volume / max(length(contents), 1), reagent_splash_tick * seconds_per_tick)

	for(var/mob/living/L in contents)
		if(L.stat == DEAD && digest_mode == GLOB.digest_modes[DIGEST_MODE_DIGEST])
			// Absorbing or dead things get dissolved slightly
			reagents.trans_to(L, affecting_amt, 1, FALSE)
			continue
		
		// Splash the living mob with our reagents
		reagents.splash_mob(L, affecting_amt, FALSE)
