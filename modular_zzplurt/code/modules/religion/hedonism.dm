/// Minimum units of sexual fluid or aphrodisiac required for an altar offering
#define MINIMUM_HEDONISM_FLUID_OFFERING 5
/// Favor granted per unit of sexual fluid sacrificed
#define HEDONISM_FLUID_FAVOR_MULTIPLIER 2
/// Favor granted when sacrificing a sex toy
#define HEDONISM_SEXTOY_FAVOR 40
/// Favor granted when a follower climaxes solo
#define HEDONISM_SOLO_CLIMAX_FAVOR 25
/// Favor granted when a follower climaxes with a partner
#define HEDONISM_PARTNER_CLIMAX_FAVOR 60
/// Bonus favor when a follower climaxes with another holy follower
#define HEDONISM_HOLY_PARTNER_BONUS 15
/// Favor granted when blessing an aroused crewmember
#define HEDONISM_AROUSED_BLESS_FAVOR 20
/// Favor granted when initiating a new deacon of passion
#define HEDONISM_DEACONIZE_FAVOR 100

/**
 * # Hedonistic God
 *
 * A sex- and pleasure-based religious sect for chaplains.
 * Followers earn favor by climaxing (especially with partners), blessing aroused crewmembers,
 * or sacrificing sexual fluids, aphrodisiacs, and sex toys at the altar.
 */
/datum/religion_sect/hedonism
	name = "Hedonistic God"
	quote = "Indulge the flesh, for ecstasy is the truest prayer."
	desc = "Worship through passion, intimacy, and carnal devotion. Earn favor by climaxing (especially with a partner), \
		blessing aroused crewmembers, or sacrificing sexual fluids, aphrodisiacs, and sex toys at the altar."
	tgui_icon = "heart"
	alignment = ALIGNMENT_NEUT
	altar_icon_state = "convertaltar-red"
	smack_chance = 20
	max_favor = 2500
	desired_items = list(
		/obj/item/reagent_containers = "holding sexual fluids or aphrodisiacs",
		/obj/item/clothing/sextoy = "as an offering of pleasure",
	)
	rites_list = list(
		/datum/religion_rites/deaconize/hedonism,
		/datum/religion_rites/anoint_libido,
		/datum/religion_rites/carnal_boon,
		/datum/religion_rites/ecstatic_communion,
		/datum/religion_rites/sacred_endurance,
	)
	/// Whether the Sacred Endurance rite has been invoked
	VAR_FINAL/sacred_endurance = FALSE
	/// Number of deacons initiated thus far
	VAR_FINAL/deacon_count = 0
	/// Max number of deacons that can be initiated
	var/max_deacons = 3
	/// Lazylist of mobs that were blessed recently for favor
	VAR_PRIVATE/list/recent_bless_refs
	/// Lazylist of followers that recently earned climax favor
	VAR_PRIVATE/list/recent_climax_refs

/datum/religion_sect/hedonism/on_conversion(mob/living/chap)
	. = ..()
	RegisterSignal(chap, COMSIG_MOB_POST_CLIMAX, PROC_REF(on_follower_climax))

/datum/religion_sect/hedonism/on_deconversion(mob/living/chap)
	. = ..()
	UnregisterSignal(chap, COMSIG_MOB_POST_CLIMAX)

/// Triggered when a holy follower of the sect climaxes
/datum/religion_sect/hedonism/proc/on_follower_climax(mob/living/source, mob/living/partner, interaction_position, manual)
	SIGNAL_HANDLER

	var/has_partner = !isnull(partner) && (partner != source)
	var/heal_amount = sacred_endurance ? 15 : 8
	var/stamina_relief = sacred_endurance ? -40 : -20

	source.heal_overall_damage(heal_amount, heal_amount, required_bodytype = BODYTYPE_ORGANIC)
	source.adjust_stamina_loss(stamina_relief)
	if(sacred_endurance)
		source.adjust_tox_loss(-10)
		source.adjust_oxy_loss(-10)

	if(has_partner)
		partner.heal_overall_damage(heal_amount, heal_amount, required_bodytype = BODYTYPE_ORGANIC)
		partner.adjust_stamina_loss(stamina_relief)
		if(sacred_endurance)
			partner.adjust_tox_loss(-10)
			partner.adjust_oxy_loss(-10)
		partner.add_mood_event("blessing", /datum/mood_event/blessing)
		to_chat(partner, span_userlove("[GLOB.deity]'s warm embrace washes over you through [source]'s climax, soothing your body!"))

	var/sourceref = REF(source)
	if(!LAZYFIND(recent_climax_refs, sourceref))
		var/favor_gain = has_partner ? HEDONISM_PARTNER_CLIMAX_FAVOR : HEDONISM_SOLO_CLIMAX_FAVOR
		if(has_partner && partner.mind?.holy_role)
			favor_gain += HEDONISM_HOLY_PARTNER_BONUS
		adjust_favor(favor_gain, source)
		LAZYADD(recent_climax_refs, sourceref)
		addtimer(CALLBACK(src, PROC_REF(clear_climax_ref), sourceref), 1 MINUTES)
		to_chat(source, span_userlove("[GLOB.deity] revels in your [has_partner ? "shared passion with [partner]" : "ecstasy"], granting you [favor_gain] favor!"))

/datum/religion_sect/hedonism/proc/clear_climax_ref(sourceref)
	LAZYREMOVE(recent_climax_refs, sourceref)

/datum/religion_sect/hedonism/proc/clear_bless_ref(tarref)
	LAZYREMOVE(recent_bless_refs, tarref)

/datum/religion_sect/hedonism/sect_bless(mob/living/target, mob/living/chap)
	if(!ishuman(target))
		return BLESSING_FAILED

	var/mob/living/carbon/human/blessed = target
	var/was_aroused = (blessed.arousal >= AROUSAL_MEDIUM)
	var/result = standard_bless_healing(blessed, chap)

	blessed.adjust_arousal(25)
	blessed.adjust_pleasure(15)
	blessed.adjust_stamina_loss(-25)
	blessed.add_mood_event("blessing", /datum/mood_event/blessing)

	if(result == BLESSING_IGNORED)
		blessed.visible_message(span_notice("[chap] caresses [blessed] with the sensual blessing of [GLOB.deity]!"))
		to_chat(blessed, span_userlove("A warm wave of sensual bliss from [GLOB.deity] washes through your body!"))
		playsound(chap, SFX_PUNCH, 25, TRUE, -1)
		result = BLESSING_SUCCESS

	var/tarref = REF(blessed)
	if((was_aroused || blessed.arousal >= AROUSAL_MEDIUM) && !LAZYFIND(recent_bless_refs, tarref))
		var/favor_earned = round(HEDONISM_AROUSED_BLESS_FAVOR * (isnull(blessed.mind) ? 0.5 : 1))
		adjust_favor(favor_earned, chap)
		LAZYADD(recent_bless_refs, tarref)
		addtimer(CALLBACK(src, PROC_REF(clear_bless_ref), tarref), 3 MINUTES)
		to_chat(chap, span_userlove("[GLOB.deity] is pleased by [blessed]'s ardor and grants you [favor_earned] favor."))

	return result

/datum/religion_sect/hedonism/on_sacrifice(obj/item/offering, mob/living/user)
	if(istype(offering, /obj/item/clothing/sextoy))
		to_chat(user, span_userlove("You offer [offering] to [GLOB.deity], who accepts the instrument of pleasure with delight!"))
		adjust_favor(HEDONISM_SEXTOY_FAVOR, user)
		playsound(get_turf(offering), 'sound/effects/pray.ogg', 50, TRUE)
		qdel(offering)
		return TRUE

	if(istype(offering, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = offering
		if(!container.reagents)
			return FALSE

		var/fluid_volume = 0
		var/aphro_volume = 0
		for(var/datum/reagent/reagent as anything in container.reagents.reagent_list)
			if(istype(reagent, /datum/reagent/drug/aphrodisiac/camphor))
				to_chat(user, span_warning("[GLOB.deity] recoils from the libido-suppressing [reagent.name] in [container]!"))
				return FALSE
			if(istype(reagent, /datum/reagent/consumable/cum) || istype(reagent, /datum/reagent/consumable/femcum) || istype(reagent, /datum/reagent/consumable/breast_milk))
				fluid_volume += reagent.volume
			else if(istype(reagent, /datum/reagent/drug/aphrodisiac))
				aphro_volume += reagent.volume

		if((fluid_volume + aphro_volume) < MINIMUM_HEDONISM_FLUID_OFFERING)
			to_chat(user, span_warning("[container] does not contain enough intimate fluids or aphrodisiacs for [GLOB.deity] to savor."))
			return FALSE

		var/favor_earned = round((fluid_volume * HEDONISM_FLUID_FAVOR_MULTIPLIER) + aphro_volume)
		to_chat(user, span_userlove("[GLOB.deity] savors the essence within [container], granting you [favor_earned] favor!"))
		adjust_favor(favor_earned, user)
		playsound(get_turf(container), 'sound/items/drink.ogg', 50, TRUE)
		container.reagents.clear_reagents()
		return TRUE

	return FALSE

/datum/religion_rites/deaconize/hedonism
	name = "Initiate of Passion"
	desc = "Initiates a willing crewmember on the altar into your sect. \
		They will gain the same holy abilities as you and earn favor for the church through their climaxes. \
		You can initiate up to three followers, and each initiation grants a burst of favor!"
	ritual_length = 20 SECONDS
	ritual_invocations = list(
		"Cast aside your inhibitions and embrace the warmth of the flesh...",
		"Let every heartbeat and every breathless sigh become a hymn...",
		"Open your body and soul to the ecstasy of our devotion...",
	)
	invoke_msg = "Arise, Initiate of Passion, and spread our carnal gospel!"
	rite_flags = parent_type::rite_flags & ~RITE_ONE_TIME_USE

/datum/religion_rites/deaconize/hedonism/invite_deacon(mob/living/carbon/human/invited)
	var/ask = tgui_alert(invited, "Join [GLOB.deity]'s cult of passion? You will become an Initiate of Passion.", "Invitation", list("Yes", "No"), 60 SECONDS)
	if(ask != "Yes")
		return
	potential_deacon = invited

/datum/religion_rites/deaconize/hedonism/post_invoke_effects(mob/living/user, atom/religious_tool)
	. = ..()
	if(!istype(GLOB.religious_sect, /datum/religion_sect/hedonism))
		return

	var/datum/religion_sect/hedonism/sect = GLOB.religious_sect
	sect.adjust_favor(HEDONISM_DEACONIZE_FAVOR, user)
	sect.deacon_count += 1
	if(sect.deacon_count >= sect.max_deacons)
		sect.rites_list -= type

/datum/religion_rites/anoint_libido
	name = "Distill Elixir of Passion"
	desc = "Materializes a blessed bottle of your chosen aphrodisiac or transformative elixir upon the altar."
	favor_cost = 75
	ritual_length = 6 SECONDS
	ritual_invocations = list(
		"From the nectar of desire and the warmth of the flesh...",
		"... distill a draught to awaken every nerve!",
	)
	invoke_msg = "Drink deep of passion's elixir!"
	/// Chosen bottle typepath to materialize
	var/chosen_bottle_path

/datum/religion_rites/anoint_libido/perform_rite(mob/living/user, atom/religious_tool)
	var/static/list/elixir_choices = list(
		"Crocin (Mild Aphrodisiac)" = /obj/item/reagent_containers/cup/bottle/crocin,
		"Dopamine (Liquid Bliss)" = /obj/item/reagent_containers/cup/bottle/dopamine,
		"Succubus Milk (Feminizing Elixir)" = /obj/item/reagent_containers/cup/bottle/succubus_milk,
		"Incubus Draft (Masculinizing Elixir)" = /obj/item/reagent_containers/cup/bottle/incubus_draft,
		"Hexacrocin (Potent Aphrodisiac)" = /obj/item/reagent_containers/cup/bottle/hexacrocin,
	)
	var/selection = tgui_input_list(user, "Choose an elixir to materialize on the altar", "Elixir of Passion", elixir_choices)
	if(isnull(selection))
		return FALSE
	chosen_bottle_path = elixir_choices[selection]
	return ..()

/datum/religion_rites/anoint_libido/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	if(!chosen_bottle_path)
		return FALSE
	var/turf/altar_turf = get_turf(religious_tool)
	var/obj/item/spawned_bottle = new chosen_bottle_path(altar_turf)
	chosen_bottle_path = null
	spawned_bottle.visible_message(span_userlove("[spawned_bottle] materializes upon [religious_tool] in a fragrant pink mist!"))
	playsound(altar_turf, 'sound/effects/pray.ogg', 50, TRUE)
	return TRUE

/datum/religion_rites/carnal_boon
	name = "Boon of Carnal Delights"
	desc = "Summons a sacred gift of pleasure, bondage gear, or sanctuary furnishings from your deity."
	favor_cost = 150
	ritual_length = 8 SECONDS
	ritual_invocations = list(
		"Oh sovereign of desire, hear our fervent plea...",
		"... bestow upon your faithful the instruments of rapture!",
	)
	invoke_msg = "Let the gifts of pleasure be unveiled!"
	/// Chosen category of carnal boon
	var/chosen_category

/datum/religion_rites/carnal_boon/perform_rite(mob/living/user, atom/religious_tool)
	var/static/list/boon_categories = list(
		"Sacred Toys (Vibrator, Magic Wand, Dildo, Fleshlight)",
		"Bondage & Restraints (Lewd Cuffs, Shibari Rope, Whip, Candle)",
		"Safe Indulgence Care Package (Condom Box & Crocin Pills)",
		"Sanctuary Furniture Kit (BDSM Bed, Shibari Stand, Stripper Pole, or Milker)",
	)
	var/selection = tgui_input_list(user, "Choose what kind of carnal boon to beseech", "Boon of Carnal Delights", boon_categories)
	if(isnull(selection))
		return FALSE
	chosen_category = selection
	return ..()

/datum/religion_rites/carnal_boon/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	if(!chosen_category)
		return FALSE
	var/turf/altar_turf = get_turf(religious_tool)
	switch(chosen_category)
		if("Sacred Toys (Vibrator, Magic Wand, Dildo, Fleshlight)")
			var/toy_type = pick(
				/obj/item/clothing/sextoy/magic_wand,
				/obj/item/clothing/sextoy/vibrator,
				/obj/item/clothing/sextoy/dildo/custom_dildo,
				/obj/item/clothing/sextoy/fleshlight,
				/obj/item/clothing/sextoy/vibroring,
				/obj/item/clothing/sextoy/buttplug,
			)
			new toy_type(altar_turf)
			new /obj/item/condom_pack(altar_turf)
		if("Bondage & Restraints (Lewd Cuffs, Shibari Rope, Whip, Candle)")
			new /obj/item/restraints/handcuffs/lewd(altar_turf)
			new /obj/item/stack/shibari_rope/glow/full(altar_turf)
			var/extra_type = pick(
				/obj/item/clothing/mask/leatherwhip,
				/obj/item/bdsm_candle,
				/obj/item/spanking_pad,
				/obj/item/tickle_feather,
			)
			new extra_type(altar_turf)
		if("Safe Indulgence Care Package (Condom Box & Crocin Pills)")
			new /obj/item/storage/box/condoms(altar_turf)
			new /obj/item/reagent_containers/applicator/pill/crocin(altar_turf)
			new /obj/item/reagent_containers/applicator/pill/dopamine(altar_turf)
		if("Sanctuary Furniture Kit (BDSM Bed, Shibari Stand, Stripper Pole, or Milker)")
			var/kit_type = pick(
				/obj/item/storage/box/bdsmbed_kit,
				/obj/item/storage/box/shibari_stand,
				/obj/item/storage/box/strippole_kit,
				/obj/item/storage/box/milking_kit,
				/obj/item/storage/box/xstand_kit,
			)
			new kit_type(altar_turf)

	chosen_category = null
	religious_tool.visible_message(span_userlove("[GLOB.deity] bestows a carnal boon upon [religious_tool]!"))
	playsound(altar_turf, 'sound/effects/pray.ogg', 50, TRUE)
	return TRUE

/datum/religion_rites/ecstatic_communion
	name = "Ecstatic Communion"
	desc = "Unleashes a wave of divine passion around the altar, healing nearby organic crewmembers, \
		relieving their exhaustion, and filling them with euphoric arousal."
	favor_cost = 200
	ritual_length = 12 SECONDS

/datum/religion_rites/ecstatic_communion/New()
	. = ..()
	ritual_invocations = list(
		"Gather close, children of [GLOB.deity], and shed your pain...",
		"Let the pulse of divine ecstasy mend our weary flesh...",
		"May passion bind us together in rapture!",
	)
	invoke_msg = "Bask in [GLOB.deity]'s ecstatic communion!"

/datum/religion_rites/ecstatic_communion/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/turf/altar_turf = get_turf(religious_tool)
	var/affected_count = 0
	for(var/mob/living/carbon/human/participant in view(5, altar_turf))
		if(participant.stat == DEAD)
			continue
		var/is_follower = !isnull(participant.mind?.holy_role)
		var/heal_amt = is_follower ? 25 : 15
		participant.heal_overall_damage(heal_amt, heal_amt, required_bodytype = BODYTYPE_ORGANIC)
		participant.adjust_tox_loss(-10)
		participant.adjust_oxy_loss(-10)
		participant.adjust_stamina_loss(-50)
		participant.adjust_arousal(35)
		participant.adjust_pleasure(25)
		participant.reagents?.add_reagent(/datum/reagent/drug/aphrodisiac/dopamine, 3)
		participant.add_mood_event("blessing", /datum/mood_event/blessing)
		to_chat(participant, span_userlove("A euphoric wave of warmth from [GLOB.deity] surges through you, soothing your wounds and igniting your senses!"))
		affected_count++

	playsound(altar_turf, 'sound/effects/pray.ogg', 60, TRUE)
	return affected_count > 0

/datum/religion_rites/sacred_endurance
	name = "Sacred Endurance"
	desc = "Permanently blesses you and all followers of your sect with divine stamina, \
		doubling the healing and stamina recovery granted whenever a follower climaxes and purging toxins."
	favor_cost = 300
	rite_flags = RITE_ONE_TIME_USE | RITE_AUTO_DELETE
	ritual_length = 15 SECONDS

/datum/religion_rites/sacred_endurance/New()
	. = ..()
	ritual_invocations = list(
		"Great [GLOB.deity], make our bodies tireless temples of devotion...",
		"Let no exhaustion dull the edge of our passion...",
		"May every climax renew our vigor and purify our flesh!",
	)
	invoke_msg = "Our passion is eternal and unyielding!"

/datum/religion_rites/sacred_endurance/post_invoke_effects(mob/living/user, atom/religious_tool)
	. = ..()
	if(!istype(GLOB.religious_sect, /datum/religion_sect/hedonism))
		return

	var/datum/religion_sect/hedonism/sect = GLOB.religious_sect
	sect.sacred_endurance = TRUE
	for(var/mob/living/follower as anything in GLOB.mob_living_list)
		if(follower.mind?.holy_role)
			to_chat(follower, span_userlove("[GLOB.deity] blesses you with Sacred Endurance! Your climaxes now restore even greater vitality and purge toxins."))

#undef MINIMUM_HEDONISM_FLUID_OFFERING
#undef HEDONISM_FLUID_FAVOR_MULTIPLIER
#undef HEDONISM_SEXTOY_FAVOR
#undef HEDONISM_SOLO_CLIMAX_FAVOR
#undef HEDONISM_PARTNER_CLIMAX_FAVOR
#undef HEDONISM_HOLY_PARTNER_BONUS
#undef HEDONISM_AROUSED_BLESS_FAVOR
#undef HEDONISM_DEACONIZE_FAVOR
