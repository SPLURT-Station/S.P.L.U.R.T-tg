/datum/antagonist/werewolf
	name = "\improper Werewolf"
	roundend_category = "werewolves"
	antagpanel_category = ANTAG_GROUP_BIOHAZARDS
	pref_flag = ROLE_TRAITOR
	jobban_flag = ROLE_TRAITOR
	show_in_antagpanel = TRUE
	show_to_ghosts = TRUE
	/// Whether the werewolf is currently transformed into their Fighter Form
	var/in_fighter_form = FALSE
	/// Frenzy built up from combat and time spent in Fighter Form
	var/frenzy_points = 0
	/// Maximum Frenzy points the werewolf can store
	var/max_frenzy_points = 100
	/// Consumption points earned from devouring raw flesh, organs, and victims
	var/consumption_points = 1
	/// World time when the werewolf last ate raw meat or gore
	var/last_fed_time = 0
	/// Original species path before transforming into Fighter Form
	var/datum/species/saved_species_type
	/// Saved DNA features from Normal Form
	var/list/saved_dna_features
	/// Saved mutant bodyparts from Normal Form
	var/list/saved_mutant_bodyparts
	/// Saved body markings from Normal Form
	var/list/saved_body_markings
	/// Granted werewolf action datums
	var/list/granted_actions = list()

/datum/antagonist/werewolf/greet()
	. = ..()
	owner.announce_objectives()

/datum/antagonist/werewolf/give_objectives()
	var/datum/objective/survive/survive_objective = new
	survive_objective.owner = owner
	objectives += survive_objective

/datum/antagonist/werewolf/on_gain()
	. = ..()
	if(!ishuman(owner?.current))
		return

	var/mob/living/carbon/human/current_mob = owner.current
	if(!LAZYLEN(objectives))
		give_objectives()

	purge_cybernetics_and_mutations(current_mob)
	current_mob.AddElement(/datum/element/inorganic_rejection)

	current_mob.add_traits(list(
		TRAIT_LYCAN,
		TRAIT_VIRUSIMMUNE,
		TRAIT_FAST_METABOLISM,
		TRAIT_QUICKER_CARRY,
		TRAIT_GAIAN_PHYSIQUE,
	), REF(src))

	current_mob.dna?.add_mutation(/datum/mutation/olfaction, MUTATION_SOURCE_SPECIES)
	apply_normal_form_claws(current_mob, TRUE)

	grant_werewolf_actions(current_mob)
	register_werewolf_signals(current_mob)

/datum/antagonist/werewolf/on_removal()
	var/mob/living/carbon/human/current_mob = owner?.current
	if(ishuman(current_mob))
		if(in_fighter_form)
			leave_fighter_form(current_mob)
		unregister_werewolf_signals(current_mob)
		QDEL_LIST(granted_actions)
		apply_normal_form_claws(current_mob, FALSE)
		current_mob.remove_traits(list(
			TRAIT_LYCAN,
			TRAIT_VIRUSIMMUNE,
			TRAIT_FAST_METABOLISM,
			TRAIT_QUICKER_CARRY,
			TRAIT_GAIAN_PHYSIQUE,
		), REF(src))
		current_mob.dna?.remove_mutation(/datum/mutation/olfaction, MUTATION_SOURCE_SPECIES)
		if(!iscursekin(current_mob))
			current_mob.RemoveElement(/datum/element/inorganic_rejection)
	return ..()

/datum/antagonist/werewolf/proc/purge_cybernetics_and_mutations(mob/living/carbon/human/current_mob)
	for(var/obj/item/organ/organ as anything in current_mob.organs)
		if(organ.organ_flags & ORGAN_ROBOTIC)
			organ.Remove(current_mob)
			organ.forceMove(current_mob.drop_location())
			to_chat(current_mob, span_userdanger("Your body violently rejects [organ]!"))

	for(var/obj/item/implant/implanted in current_mob)
		qdel(implanted)

	if(current_mob.dna)
		for(var/datum/mutation/existing_mutation as anything in current_mob.dna.mutations)
			if(existing_mutation.type == /datum/mutation/olfaction)
				continue
			current_mob.dna.remove_mutation(existing_mutation.type, existing_mutation.sources)

/datum/antagonist/werewolf/proc/apply_normal_form_claws(mob/living/carbon/human/current_mob, enable)
	var/delta = enable ? 5 : -5
	for(var/arm_zone in list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		var/obj/item/bodypart/arm/arm_part = current_mob.get_bodypart(arm_zone)
		if(!istype(arm_part))
			continue
		arm_part.unarmed_damage_low = max(1, arm_part.unarmed_damage_low + delta)
		arm_part.unarmed_damage_high = max(1, arm_part.unarmed_damage_high + delta)

/datum/antagonist/werewolf/proc/grant_werewolf_actions(mob/living/carbon/human/current_mob)
	var/list/action_paths = list(
		/datum/action/cooldown/werewolf/fighter_form,
		/datum/action/cooldown/werewolf/consume_flesh,
		/datum/action/cooldown/werewolf/howl,
		/datum/action/cooldown/werewolf/berserker_rush,
		/datum/action/cooldown/werewolf/claw_barrage,
		/datum/action/cooldown/werewolf/pump_up,
	)
	for(var/action_path in action_paths)
		var/datum/action/cooldown/werewolf/new_action = new action_path(src)
		new_action.Grant(current_mob)
		granted_actions += new_action

/datum/antagonist/werewolf/proc/register_werewolf_signals(mob/living/carbon/human/current_mob)
	RegisterSignal(current_mob, COMSIG_CARBON_GAIN_MUTATION, PROC_REF(on_gain_mutation))
	RegisterSignal(current_mob, COMSIG_CARBON_ATTEMPT_EAT, PROC_REF(on_attempt_eat))
	RegisterSignal(current_mob, COMSIG_LIVING_EAT_FOOD, PROC_REF(on_eat_food))
	RegisterSignal(current_mob, COMSIG_LIVING_LIFE, PROC_REF(on_life))
	RegisterSignal(current_mob, COMSIG_LIVING_UNARMED_ATTACK, PROC_REF(on_unarmed_attack))
	RegisterSignal(current_mob, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/antagonist/werewolf/proc/unregister_werewolf_signals(mob/living/carbon/human/current_mob)
	UnregisterSignal(current_mob, list(
		COMSIG_CARBON_GAIN_MUTATION,
		COMSIG_CARBON_ATTEMPT_EAT,
		COMSIG_LIVING_EAT_FOOD,
		COMSIG_LIVING_LIFE,
		COMSIG_LIVING_UNARMED_ATTACK,
		COMSIG_ATOM_EXAMINE,
	))

/datum/antagonist/werewolf/proc/on_gain_mutation(mob/living/carbon/source, mutation_type, list/sources)
	SIGNAL_HANDLER
	if(mutation_type == /datum/mutation/olfaction || ispath(mutation_type, /datum/mutation/olfaction))
		return
	addtimer(CALLBACK(src, PROC_REF(reject_foreign_mutation), source, mutation_type, sources ? sources.Copy() : null), 0)

/datum/antagonist/werewolf/proc/reject_foreign_mutation(mob/living/carbon/source, mutation_type, list/sources)
	if(QDELETED(source) || !source.dna)
		return
	var/datum/mutation/found = source.dna.get_mutation(mutation_type)
	if(!found)
		return
	source.dna.remove_mutation(mutation_type, sources || found.sources)
	to_chat(source, span_warning("Your pure lupine genes reject the foreign mutation!"))

/datum/antagonist/werewolf/proc/is_edible_raw_flesh(obj/item/food_item)
	if(istype(food_item, /obj/item/organ) || istype(food_item, /obj/item/bodypart) || istype(food_item, /obj/item/food/meat/slab))
		return TRUE
	var/datum/component/edible/edible_comp = food_item.GetComponent(/datum/component/edible)
	if(!edible_comp)
		return TRUE
	if(edible_comp.foodtypes & GORE)
		return TRUE
	if((edible_comp.foodtypes & RAW) && (edible_comp.foodtypes & (MEAT | SEAFOOD)))
		return TRUE
	return FALSE

/datum/antagonist/werewolf/proc/on_attempt_eat(mob/living/carbon/source, obj/item/food_item)
	SIGNAL_HANDLER
	if(is_edible_raw_flesh(food_item))
		return NONE
	to_chat(source, span_warning("Your bestial stomach turns at [food_item] - you crave raw meat, organs, and fresh gore!"))
	return BLOCK_EAT_ATTEMPT

/datum/antagonist/werewolf/proc/on_eat_food(mob/living/source, obj/item/food_item, mob/feeder)
	SIGNAL_HANDLER
	last_fed_time = world.time
	if(istype(food_item, /obj/item/organ) || istype(food_item, /obj/item/bodypart))
		consumption_points++
		to_chat(source, span_notice("You devour [food_item], bolstering your stores. (Consumption Points: [consumption_points])"))

/datum/antagonist/werewolf/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(user == source)
		examine_list += span_notice("Frenzy: <b>[round(frenzy_points, 1)]/[max_frenzy_points]</b> | Consumption Points: <b>[consumption_points]</b>.")

/datum/antagonist/werewolf/proc/adjust_frenzy(amount)
	frenzy_points = clamp(frenzy_points + amount, 0, max_frenzy_points)

/datum/antagonist/werewolf/proc/on_life(mob/living/carbon/human/source, seconds_per_tick, times_fired)
	SIGNAL_HANDLER
	if(!ishuman(source) || source.stat == DEAD)
		return

	if(in_fighter_form)
		if(source.stat >= HARD_CRIT)
			leave_fighter_form(source)
			return

		adjust_frenzy(2 * seconds_per_tick)
		if(source.nutrition <= NUTRITION_LEVEL_STARVING)
			if(SPT_PROB(10, seconds_per_tick))
				to_chat(source, span_warning("You are starving! Your regeneration stalls until you feed on raw flesh!"))
			return

		var/healed = FALSE
		if(source.get_brute_loss() > 0)
			source.adjust_brute_loss(-4 * seconds_per_tick, updating_health = FALSE)
			healed = TRUE
		if(source.get_fire_loss() > 0)
			source.adjust_fire_loss(-2 * seconds_per_tick, updating_health = FALSE)
			healed = TRUE
		if(source.get_tox_loss() > 0)
			source.adjust_tox_loss(-2 * seconds_per_tick, updating_health = FALSE)
			healed = TRUE
		if(source.get_oxy_loss() > 0)
			source.adjust_oxy_loss(-4 * seconds_per_tick, updating_health = FALSE)
			healed = TRUE
		if(source.get_stamina_loss() > 0)
			source.adjust_stamina_loss(-8 * seconds_per_tick, updating_stamina = FALSE)
			healed = TRUE

		for(var/obj/item/organ/organ as anything in source.organs)
			if(organ.damage > 0)
				organ.apply_organ_damage(-3 * seconds_per_tick)
				healed = TRUE

		for(var/datum/wound/iter_wound as anything in source.all_wounds)
			if(SPT_PROB(25, seconds_per_tick))
				iter_wound.remove_wound()
				healed = TRUE

		if(healed)
			source.updatehealth()
			source.adjust_nutrition(-6 * seconds_per_tick)

		if(source.nutrition > NUTRITION_LEVEL_HUNGRY && SPT_PROB(25, seconds_per_tick))
			var/list/missing_limbs = source.get_missing_limbs()
			if(length(missing_limbs))
				var/zone_to_regrow = pick(missing_limbs)
				if(source.regenerate_limb(zone_to_regrow, FALSE))
					source.adjust_nutrition(-50)
					source.visible_message(
						span_danger("[source]'s severed [parse_zone(zone_to_regrow)] violently knits itself back together in a spray of blood!"),
						span_notice("Your [parse_zone(zone_to_regrow)] regrows from your hunger reserves!"),
					)
			else if(source.dna?.species)
				source.dna.species.regenerate_organs(source, replace_current = FALSE, replace_missing = TRUE)
	else
		if(frenzy_points > 0)
			adjust_frenzy(-1 * seconds_per_tick)

		var/recently_fed = (last_fed_time > 0) && ((world.time - last_fed_time) <= 30 SECONDS)
		if((source.body_position == LYING_DOWN || recently_fed) && source.nutrition > NUTRITION_LEVEL_STARVING)
			var/normal_healed = FALSE
			if(source.get_brute_loss() > 0)
				source.adjust_brute_loss(-1.5 * seconds_per_tick, updating_health = FALSE)
				normal_healed = TRUE
			if(source.get_fire_loss() > 0)
				source.adjust_fire_loss(-1 * seconds_per_tick, updating_health = FALSE)
				normal_healed = TRUE
			if(source.get_tox_loss() > 0)
				source.adjust_tox_loss(-1 * seconds_per_tick, updating_health = FALSE)
				normal_healed = TRUE
			if(source.get_oxy_loss() > 0)
				source.adjust_oxy_loss(-2 * seconds_per_tick, updating_health = FALSE)
				normal_healed = TRUE
			if(normal_healed)
				source.updatehealth()
				source.adjust_nutrition(-2 * seconds_per_tick)

/datum/antagonist/werewolf/proc/on_unarmed_attack(mob/living/carbon/human/source, atom/target, proximity, modifiers)
	SIGNAL_HANDLER
	if(!proximity || !in_fighter_form || LAZYACCESS(modifiers, RIGHT_CLICK))
		return

	if(iscarbon(target) && target != source)
		var/mob/living/carbon/carbon_target = target
		adjust_frenzy(5)
		var/obj/item/bodypart/hit_limb = carbon_target.get_bodypart(check_zone(source.zone_selected)) || pick(carbon_target.bodyparts)
		if(hit_limb)
			hit_limb.force_wound_upwards(/datum/wound/slash/flesh/moderate)
	else if(isobj(target))
		var/obj/target_obj = target
		if(!istype(target_obj, /obj/machinery/door/airlock))
			target_obj.take_damage(30, BRUTE, MELEE, TRUE, get_dir(source, target_obj))

/datum/antagonist/werewolf/proc/enter_fighter_form(mob/living/carbon/human/current_mob)
	if(in_fighter_form || !ishuman(current_mob))
		return FALSE

	saved_species_type = current_mob.dna.species.type
	saved_dna_features = current_mob.dna.features.Copy()
	saved_mutant_bodyparts = current_mob.dna.mutant_bodyparts.Copy()
	saved_body_markings = current_mob.dna.body_markings.Copy()

	current_mob.visible_message(
		span_bolddanger("[current_mob] throws [current_mob.p_their()] head back with a bone-chilling howl as [current_mob.p_their()] bones snap and twist into a towering werewolf!"),
		span_userdanger("Your bones snap and surge with lupine fury as you assume your Fighter Form!"),
	)

	current_mob.set_species(/datum/species/lycan, icon_update = TRUE, pref_load = FALSE, replace_missing = TRUE)
	current_mob.remove_movespeed_modifier(/datum/movespeed_modifier/cursekin_slowdown)

	var/datum/action/cooldown/spell/beast_form/duplicate_beast_action = locate() in current_mob.actions
	if(duplicate_beast_action)
		qdel(duplicate_beast_action)

	for(var/arm_zone in list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		var/obj/item/bodypart/arm/arm_part = current_mob.get_bodypart(arm_zone)
		if(!istype(arm_part))
			continue
		arm_part.unarmed_damage_low = 28
		arm_part.unarmed_damage_high = 32
		arm_part.unarmed_sharpness = SHARP_EDGED
		arm_part.unarmed_effectiveness = 80

	current_mob.AddElement(/datum/element/door_pryer, pry_time = 3 SECONDS, interaction_key = "werewolf_door_pry")
	playsound(current_mob, 'modular_zubbers/code/modules/customization/species/lycans/transform.ogg', 65, TRUE)
	in_fighter_form = TRUE
	return TRUE

/datum/antagonist/werewolf/proc/leave_fighter_form(mob/living/carbon/human/current_mob)
	if(!in_fighter_form || !ishuman(current_mob))
		return FALSE

	current_mob.RemoveElement(/datum/element/door_pryer, pry_time = 3 SECONDS, interaction_key = "werewolf_door_pry")

	var/datum/species/restore_species = saved_species_type || /datum/species/human
	current_mob.set_species(restore_species, icon_update = FALSE, pref_load = FALSE, replace_missing = FALSE)
	if(saved_dna_features)
		current_mob.dna.features = saved_dna_features.Copy()
	if(saved_mutant_bodyparts)
		current_mob.dna.mutant_bodyparts = saved_mutant_bodyparts.Copy()
	if(saved_body_markings)
		current_mob.dna.body_markings = saved_body_markings.Copy()
	current_mob.remove_movespeed_modifier(/datum/movespeed_modifier/cursekin_slowdown)
	current_mob.update_body(TRUE)

	apply_normal_form_claws(current_mob, TRUE)
	current_mob.visible_message(
		span_warning("[current_mob]'s monstrous frame shrinks back down into [current_mob.p_their()] normal form."),
		span_notice("You recede from your Fighter Form."),
	)
	playsound(current_mob, 'modular_zubbers/code/modules/customization/species/lycans/transform.ogg', 50, TRUE)
	in_fighter_form = FALSE

	for(var/datum/action/cooldown/werewolf/fighter_form/form_action in granted_actions)
		form_action.button_icon_state = "lycan_form"
		form_action.build_all_button_icons()
	return TRUE

/// Base action for Werewolf antagonist abilities
/datum/action/cooldown/werewolf
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED
	button_icon = 'icons/mob/actions/actions_changeling.dmi'
	/// Weakref to the owning werewolf antagonist datum
	var/datum/weakref/werewolf_ref
	/// Frenzy points required and spent when activating this ability
	var/frenzy_cost = 0

/datum/action/cooldown/werewolf/New(Target)
	if(istype(Target, /datum/antagonist/werewolf))
		werewolf_ref = WEAKREF(Target)
	return ..()

/datum/action/cooldown/werewolf/proc/get_werewolf()
	RETURN_TYPE(/datum/antagonist/werewolf)
	return werewolf_ref?.resolve()

/datum/action/cooldown/werewolf/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	var/datum/antagonist/werewolf/wolf = get_werewolf()
	if(!wolf)
		return FALSE
	if(wolf.frenzy_points < frenzy_cost)
		if(feedback && owner)
			to_chat(owner, span_warning("You need at least [frenzy_cost] Frenzy to use [name]! (Current: [round(wolf.frenzy_points, 1)])"))
		return FALSE
	return TRUE

/// Toggle between Normal Form and Fighter Form
/datum/action/cooldown/werewolf/fighter_form
	name = "Fighter Form"
	desc = "Transform between your Normal Form and your towering Werewolf Fighter Form. Fighter Form rapidly regenerates limbs and organs using your hunger and builds Frenzy."
	button_icon = 'modular_zubbers/code/modules/customization/species/lycans/lycan_verbs.dmi'
	button_icon_state = "lycan_form"
	cooldown_time = 15 SECONDS

/datum/action/cooldown/werewolf/fighter_form/Activate(atom/target)
	var/datum/antagonist/werewolf/wolf = get_werewolf()
	var/mob/living/carbon/human/human_owner = owner
	if(!wolf || !ishuman(human_owner))
		return FALSE

	if(HAS_TRAIT(human_owner, TRAIT_MANSUS_INHIBITION))
		human_owner.balloon_alert(human_owner, "inhibited!")
		return FALSE

	human_owner.visible_message(
		span_warning("[human_owner] snarls as [human_owner.p_their()] muscles tense and shift!"),
		span_danger("You begin shifting forms..."),
	)
	playsound(human_owner, 'sound/effects/wounds/crack1.ogg', 50, TRUE)
	if(!do_after(human_owner, 1.5 SECONDS, target = human_owner))
		return FALSE

	if(wolf.in_fighter_form)
		wolf.leave_fighter_form(human_owner)
		button_icon_state = "lycan_form"
	else
		wolf.enter_fighter_form(human_owner)
		button_icon_state = "human_form"

	build_all_button_icons()
	StartCooldown()
	return TRUE

/// Devour flesh from a grabbed victim or spend Consumption Points to restore hunger and Frenzy
/datum/action/cooldown/werewolf/consume_flesh
	name = "Consume Flesh"
	desc = "Tear into a grabbed victim to devour their raw flesh and earn a Consumption Point, or spend 1 Consumption Point to gorge yourself (+150 nutrition and +25 Frenzy)."
	button_icon_state = "absorb_dna"
	cooldown_time = 10 SECONDS

/datum/action/cooldown/werewolf/consume_flesh/Activate(atom/target)
	var/datum/antagonist/werewolf/wolf = get_werewolf()
	var/mob/living/carbon/human/human_owner = owner
	if(!wolf || !ishuman(human_owner))
		return FALSE

	if(iscarbon(human_owner.pulling) && human_owner.grab_state >= GRAB_AGGRESSIVE)
		var/mob/living/carbon/victim = human_owner.pulling
		human_owner.visible_message(
			span_bolddanger("[human_owner] sinks [human_owner.p_their()] fangs deep into [victim], tearing away a mouthful of raw flesh!"),
			span_userdanger("You tear a chunk of raw flesh from [victim]!"),
		)
		playsound(human_owner, 'sound/items/eatfood.ogg', 65, TRUE)
		if(!do_after(human_owner, 2.5 SECONDS, target = victim))
			return FALSE

		var/obj/item/bodypart/hit_limb = victim.get_bodypart(check_zone(human_owner.zone_selected)) || pick(victim.bodyparts)
		victim.apply_damage(25, BRUTE, hit_limb, sharpness = SHARP_EDGED)
		hit_limb?.force_wound_upwards(/datum/wound/slash/flesh/severe)
		human_owner.adjust_nutrition(120)
		wolf.last_fed_time = world.time
		wolf.consumption_points++
		wolf.adjust_frenzy(20)
		to_chat(human_owner, span_notice("You gorge on [victim]'s flesh! (Consumption Points: [wolf.consumption_points], Frenzy: [round(wolf.frenzy_points, 1)])"))
		StartCooldown()
		return TRUE

	if(wolf.consumption_points <= 0)
		to_chat(human_owner, span_warning("Grab a victim aggressively to devour their flesh, or earn Consumption Points by eating organs and limbs!"))
		return FALSE

	wolf.consumption_points--
	wolf.last_fed_time = world.time
	human_owner.adjust_nutrition(150)
	wolf.adjust_frenzy(25)
	playsound(human_owner, 'sound/items/eatfood.ogg', 50, TRUE)
	to_chat(human_owner, span_notice("You metabolize your stored flesh reserves, restoring hunger and surging with Frenzy! (Remaining Consumption Points: [wolf.consumption_points])"))
	StartCooldown()
	return TRUE

/// Terrifying howl that stuns and disorients nearby prey
/datum/action/cooldown/werewolf/howl
	name = "Terrifying Howl"
	desc = "Costs 20 Frenzy. Unleash an ear-shattering howl that disorients and knocks down nearby prey. Stronger while in Fighter Form."
	button_icon_state = "resonant_shriek"
	cooldown_time = 25 SECONDS
	frenzy_cost = 20

/datum/action/cooldown/werewolf/howl/Activate(atom/target)
	var/datum/antagonist/werewolf/wolf = get_werewolf()
	var/mob/living/carbon/human/human_owner = owner
	if(!wolf || !ishuman(human_owner))
		return FALSE

	wolf.adjust_frenzy(-frenzy_cost)
	playsound(human_owner, 'sound/effects/screech.ogg', 90, TRUE)
	human_owner.visible_message(
		span_bolddanger("[human_owner] unleashes a primal, ear-splitting howl!"),
		span_notice("You unleash a terrifying howl!"),
	)

	var/howl_range = wolf.in_fighter_form ? 6 : 4
	for(var/mob/living/carbon/listener in ohearers(howl_range, human_owner))
		if(listener == human_owner || HAS_TRAIT(listener, TRAIT_LYCAN))
			continue
		var/dist = max(1, get_dist(human_owner, listener))
		var/power = wolf.in_fighter_form ? SOUNDBANG_MASSIVE : SOUNDBANG_STRONG
		listener.soundbang_act(power - round(dist * 0.5), 10 SECONDS, 5 SECONDS)
		if(wolf.in_fighter_form && dist <= 2)
			listener.Knockdown(2 SECONDS)

	if(wolf.in_fighter_form)
		for(var/obj/machinery/light/nearby_light in view(5, human_owner))
			nearby_light.on = TRUE
			nearby_light.break_light_tube()

	StartCooldown()
	return TRUE

/// Ranged charge that slashes through prey and smashes standard walls in Fighter Form
/datum/action/cooldown/werewolf/berserker_rush
	name = "Berserker Rush"
	desc = "Costs 25 Frenzy. Click a target to charge forward up to 6 tiles, bowling over and slashing anyone in your path. In Fighter Form, smashing into standard walls tears them apart at the cost of recoil damage."
	button_icon_state = "strained_muscles"
	cooldown_time = 18 SECONDS
	frenzy_cost = 25
	click_to_activate = TRUE
	ranged_mousepointer = 'icons/effects/mouse_pointers/throw_target.dmi'

/datum/action/cooldown/werewolf/berserker_rush/Activate(atom/target)
	var/datum/antagonist/werewolf/wolf = get_werewolf()
	var/mob/living/carbon/human/human_owner = owner
	if(!wolf || !ishuman(human_owner) || !istype(target) || target == human_owner)
		return FALSE

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE

	wolf.adjust_frenzy(-frenzy_cost)
	human_owner.visible_message(
		span_bolddanger("[human_owner] lunges forward in a ferocious berserker rush!"),
		span_userdanger("You lunge forward in a berserker rush!"),
	)
	playsound(human_owner, 'sound/items/weapons/thudswoosh.ogg', 75, TRUE)

	var/slash_damage = wolf.in_fighter_form ? 30 : 18
	for(var/step_index in 1 to 6)
		var/turf/next_turf = get_step_towards(human_owner, target_turf)
		if(!next_turf)
			break

		if(iswallturf(next_turf))
			if(wolf.in_fighter_form && !istype(next_turf, /turf/closed/wall/r_wall))
				var/turf/closed/wall/normal_wall = next_turf
				normal_wall.visible_message(span_bolddanger("[human_owner] crashes straight through [normal_wall]!"))
				playsound(normal_wall, 'sound/effects/meteorimpact.ogg', 80, TRUE)
				normal_wall.dismantle_wall(devastated = TRUE)
				human_owner.apply_damage(15, BRUTE, BODY_ZONE_CHEST)
			else
				human_owner.visible_message(span_warning("[human_owner] slams headfirst into [next_turf]!"))
				playsound(next_turf, 'sound/effects/bang.ogg', 70, TRUE)
				human_owner.apply_damage(10, BRUTE, BODY_ZONE_HEAD)
			break

		var/hit_mob = FALSE
		for(var/mob/living/victim in next_turf)
			if(victim == human_owner)
				continue
			hit_mob = TRUE
			victim.visible_message(
				span_bolddanger("[human_owner] barrels through [victim], raking [victim.p_them()] with vicious claws!"),
				span_userdanger("[human_owner] barrels into you, raking you with vicious claws!"),
			)
			playsound(victim, 'sound/items/weapons/slash.ogg', 75, TRUE)
			victim.apply_damage(slash_damage, BRUTE, BODY_ZONE_CHEST, sharpness = SHARP_EDGED)
			victim.Knockdown(wolf.in_fighter_form ? 3 SECONDS : 1.5 SECONDS)
			if(iscarbon(victim))
				var/mob/living/carbon/carbon_victim = victim
				var/obj/item/bodypart/chest_limb = carbon_victim.get_bodypart(BODY_ZONE_CHEST)
				chest_limb?.force_wound_upwards(/datum/wound/slash/flesh/severe)

		if(!human_owner.Move(next_turf, get_dir(human_owner, next_turf)) && !hit_mob)
			break
		if(get_turf(human_owner) == target_turf)
			break

	StartCooldown()
	return TRUE

/// AoE spinning claw slash around the werewolf
/datum/action/cooldown/werewolf/claw_barrage
	name = "Claw Barrage"
	desc = "Costs 15 Frenzy. Spin in a circle and slash every adjacent target and structure around you."
	button_icon = 'modular_skyrat/modules/implants/icons/razorclaws.dmi'
	button_icon_state = "wolverine"
	cooldown_time = 12 SECONDS
	frenzy_cost = 15

/datum/action/cooldown/werewolf/claw_barrage/Activate(atom/target)
	var/datum/antagonist/werewolf/wolf = get_werewolf()
	var/mob/living/carbon/human/human_owner = owner
	if(!wolf || !ishuman(human_owner))
		return FALSE

	wolf.adjust_frenzy(-frenzy_cost)
	human_owner.spin(4, 1)
	playsound(human_owner, 'sound/items/weapons/slash.ogg', 80, TRUE)
	human_owner.visible_message(
		span_bolddanger("[human_owner] unleashes a whirling barrage of razor-sharp claws!"),
		span_danger("You whirl around, slashing everything within reach!"),
	)

	var/mob_damage = wolf.in_fighter_form ? 32 : 18
	var/obj_damage = wolf.in_fighter_form ? 45 : 20
	for(var/atom/adjacent_atom in orange(1, human_owner))
		if(isliving(adjacent_atom))
			var/mob/living/victim = adjacent_atom
			victim.apply_damage(mob_damage, BRUTE, BODY_ZONE_CHEST, sharpness = SHARP_EDGED)
			if(iscarbon(victim))
				var/mob/living/carbon/carbon_victim = victim
				var/obj/item/bodypart/hit_limb = carbon_victim.get_bodypart(BODY_ZONE_CHEST) || pick(carbon_victim.bodyparts)
				hit_limb?.force_wound_upwards(wolf.in_fighter_form ? /datum/wound/slash/flesh/severe : /datum/wound/slash/flesh/moderate)
		else if(isobj(adjacent_atom))
			var/obj/target_obj = adjacent_atom
			if(target_obj.density)
				target_obj.take_damage(obj_damage, BRUTE, MELEE, TRUE, get_dir(human_owner, target_obj))

	StartCooldown()
	return TRUE

/// Short burst of speed and attack rate at the cost of hunger and Frenzy
/datum/action/cooldown/werewolf/pump_up
	name = "Pump Up"
	desc = "Costs 10 Frenzy and 80 nutrition. Burn through your hunger reserves to surge with adrenaline, boosting movement and attack speed for 4 seconds."
	button_icon_state = "adrenaline"
	cooldown_time = 16 SECONDS
	frenzy_cost = 10

/datum/action/cooldown/werewolf/pump_up/Activate(atom/target)
	var/datum/antagonist/werewolf/wolf = get_werewolf()
	var/mob/living/carbon/human/human_owner = owner
	if(!wolf || !ishuman(human_owner))
		return FALSE

	if(human_owner.nutrition < 100)
		to_chat(human_owner, span_warning("You are too hungry to pump yourself up! Feed on raw meat first!"))
		return FALSE

	wolf.adjust_frenzy(-frenzy_cost)
	human_owner.adjust_nutrition(-80)
	human_owner.apply_status_effect(/datum/status_effect/werewolf_pump_up)
	playsound(human_owner, 'sound/effects/singlebeat.ogg', 70, TRUE)
	human_owner.visible_message(
		span_danger("Veins bulge across [human_owner]'s frame as [human_owner.p_they()] surge[human_owner.p_s()] with bestial adrenaline!"),
		span_boldnotice("Your heart hammers as you burn through your hunger for a burst of speed!"),
	)
	StartCooldown()
	return TRUE

/datum/movespeed_modifier/werewolf_pump_up
	multiplicative_slowdown = -0.5

/datum/status_effect/werewolf_pump_up
	id = "werewolf_pump_up"
	duration = 4 SECONDS
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = null

/datum/status_effect/werewolf_pump_up/on_apply()
	. = ..()
	if(!.)
		return FALSE
	owner.add_movespeed_modifier(/datum/movespeed_modifier/werewolf_pump_up)
	owner.next_move_modifier *= 0.5
	return TRUE

/datum/status_effect/werewolf_pump_up/on_remove()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/werewolf_pump_up)
	owner.next_move_modifier /= 0.5
	return ..()

