/datum/species/xeno
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/mutant/xenohybrid,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/mutant/xenohybrid,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/mutant/xenohybrid,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/mutant/xenohybrid,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/mutant/xenohybrid,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/mutant/xenohybrid
	)

/datum/species/xeno/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons = TRUE)
	. = ..()
	var/datum/action/innate/reconstitute_form/reconstitute_form = new(human_who_gained_species)
	var/datum/action/cooldown/sonar_ping/sonar_ping = new(human_who_gained_species)
	reconstitute_form.Grant(human_who_gained_species)
	sonar_ping.Grant(human_who_gained_species)
	human_who_gained_species.add_movespeed_modifier(/datum/movespeed_modifier/xenochimera)

/datum/species/xeno/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	var/datum/action/innate/reconstitute_form/reconstitute_form = locate() in C.actions // (for the record, "C" isnt better)
	qdel(reconstitute_form)
	C.remove_movespeed_modifier(/datum/movespeed_modifier/xenochimera)

/datum/movespeed_modifier/xenochimera
	multiplicative_slowdown = -0.1

#define ACTION_STATE_STANDBY 0
#define ACTION_STATE_PREPARING 1

/datum/action/innate/reconstitute_form
	name = "Reconstitute Form"
	button_icon = 'modular_zzplurt/icons/hud/actions.dmi'
	button_icon_state = "stasis"
	var/action_state = ACTION_STATE_STANDBY
	var/revive_timer = 0
	var/is_dead = FALSE
	COOLDOWN_DECLARE(revive_cd)

/datum/action/innate/reconstitute_form/Trigger(trigger_flags)
	if(!..())
		return FALSE

	var/mob/living/carbon/human/owner = src.owner
	switch(action_state)
		if(ACTION_STATE_STANDBY)
			if(!COOLDOWN_FINISHED(src, revive_cd))
				to_chat(owner, span_warning("You can't use that ability again so soon! It will be ready in [DisplayTimeText(COOLDOWN_TIMELEFT(src, revive_cd))]."))
				return FALSE

			is_dead = (owner.stat == DEAD)
			var/time = is_dead ? 5 MINUTES : 30 SECONDS
			var/alert = is_dead ? "Are you sure you want to regenerate? This will take 5 minutes to prepare, then automatically trigger." : "Are you sure you want to actualize your form? This will take 30 seconds to prepare, then automatically trigger."

			if(tgui_alert(owner, alert, "Confirm Reconstitution", list("Yes", "No")) != "Yes")
				return FALSE

			to_chat(owner, span_notice("You begin preparing to reconstitute your form. This will take [DisplayTimeText(time)]. You will not be able to move during this time. The reconstitution will automatically trigger when ready."))

			if(is_dead)
				RegisterSignal(owner, COMSIG_LIVING_REVIVE, PROC_REF(on_revive))
			else
				owner.Stun(time)

			revive_timer = addtimer(CALLBACK(src, PROC_REF(execute_reconstitution)), time, TIMER_UNIQUE | TIMER_STOPPABLE)

			action_state = ACTION_STATE_PREPARING
			button_icon_state = "regenerating"
			build_all_button_icons()
			return TRUE

		if(ACTION_STATE_PREPARING)
			to_chat(owner, span_warning("You are already preparing to reconstitute! The process will automatically complete in [DisplayTimeText(timeleft(revive_timer))]."))
			return FALSE

/datum/action/innate/reconstitute_form/proc/on_revive(mob/living/source, full_heal_flags)
	SIGNAL_HANDLER

	if(revive_timer)
		deltimer(revive_timer)
		revive_timer = 0

	to_chat(owner, span_notice("Your body has recovered from its ordeal, ready to regenerate itself again."))
	UnregisterSignal(owner, COMSIG_LIVING_REVIVE)
	action_state = ACTION_STATE_STANDBY
	button_icon_state = "stasis"
	build_all_button_icons()

/datum/action/innate/reconstitute_form/proc/execute_reconstitution()
	var/mob/living/carbon/human/owner = src.owner
	if(!owner)
		return

	revive_timer = 0

	// Apply the changes based on character preferences (like self-actualization device)
	owner.client?.prefs?.safe_transfer_prefs_to_with_damage(owner, visuals_only = TRUE)
	owner.dna.update_dna_identity()
	var/taur_mode = owner.get_taur_mode()
	if((taur_mode & STYLE_TAUR_SNAKE) && (owner.shoes))
		owner.dropItemToGround(owner.shoes, TRUE)
	owner.updateappearance()
	owner.wash(CLEAN_SCRUB)

	// Drop items and create viscera for the transformation
	for(var/obj/item/wielded in owner)
		owner.dropItemToGround(wielded, force = TRUE, silent = TRUE)

	new /obj/effect/gibspawner/human(get_turf(owner), owner)

	if(is_dead)
		to_chat(owner, span_notice("Your new body awakens, bursting free from your old skin."))
		owner.revive(HEAL_ALL)
		owner.visible_message(span_danger("<p><font size=4>The lifeless husk of [owner] bursts open, revealing a new, intact copy in the pool of viscera.</font></p>"))
		owner.visible_message("The former corpse staggers to its feet, all its former wounds having vanished...")

		UnregisterSignal(owner, COMSIG_LIVING_REVIVE)
		COOLDOWN_START(src, revive_cd, 5 MINUTES)
		is_dead = FALSE
	else
		to_chat(owner, span_notice("Your body shifts and tears, reconstituting into your ideal form."))
		owner.visible_message(span_danger("[owner]'s form violently shifts, bursting free from [owner.p_their()] old skin in a shower of viscera!"))
		COOLDOWN_START(src, revive_cd, 30 SECONDS)

	action_state = ACTION_STATE_STANDBY
	button_icon_state = "stasis"
	build_all_button_icons()

	if(isethereal(owner.dna.species))
		var/datum/species/ethereal/ethereal = owner.dna.species
		ethereal.refresh_light_color(owner)

	SSquirks.OverrideQuirks(owner, owner.client)

#undef ACTION_STATE_STANDBY
#undef ACTION_STATE_PREPARING
