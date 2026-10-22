#define MINIMUM_LUST_OFFERING 5

/datum/religion_sect/lust
	name = "Lust God"
	quote = "Indulge the flesh, and your spirit shall want for nothing."
	desc = "Earn favor by climaxing, blessing aroused crewmembers, or offering sexual fluids, aphrodisiacs, and sex toys at the altar. \
		Your blessings mend organic flesh, soothe stamina, and stoke desire."
	tgui_icon = FA_ICON_HEART
	alignment = ALIGNMENT_NEUT
	altar_icon_state = "convertaltar-red"
	desired_items = list(
		/obj/item/reagent_containers = "holding sexual fluids or aphrodisiacs",
		/obj/item/clothing/sextoy = "used condoms or sex toys",
	)
	rites_list = list(
		/datum/religion_rites/deaconize/lust,
		/datum/religion_rites/lust_communion,
		/datum/religion_rites/summon_lewd_kit,
		/datum/religion_rites/carnal_festival,
	)
	/// Number of deacons inducted into the sect
	VAR_FINAL/deacon_count = 0
	/// Maximum number of deacons allowed
	var/max_deacons = 3
	/// Lazylist of mobs blessed recently so favor cannot be farmed on a single target
	VAR_PRIVATE/list/recent_bless_refs

/datum/religion_sect/lust/on_conversion(mob/living/chap)
	. = ..()
	RegisterSignal(chap, COMSIG_MOB_POST_CLIMAX, PROC_REF(on_follower_climax))

/datum/religion_sect/lust/on_deconversion(mob/living/chap)
	. = ..()
	UnregisterSignal(chap, COMSIG_MOB_POST_CLIMAX)

/datum/religion_sect/lust/proc/on_follower_climax(mob/living/source, mob/living/partner, interaction_position, manual)
	SIGNAL_HANDLER

	var/favor_gained = 15
	if(isliving(partner) && partner != source)
		favor_gained = 35
		partner.add_mood_event("blessing", /datum/mood_event/blessing)
		to_chat(partner, span_love("You feel the warm embrace of [GLOB.deity] wash over you!"))

	to_chat(source, span_love("[GLOB.deity] revels in your release!"))
	adjust_favor(favor_gained, source)

/datum/religion_sect/lust/sect_bless(mob/living/target, mob/living/chap)
	if(!ishuman(target))
		return BLESSING_FAILED

	var/mob/living/carbon/human/blessed = target
	var/did_something = FALSE

	var/heal_result = standard_bless_healing(blessed, chap)
	if(heal_result == BLESSING_SUCCESS)
		did_something = TRUE

	if(blessed.get_stamina_loss() > 0)
		blessed.adjust_stamina_loss(-25)
		did_something = TRUE

	if(blessed.client?.prefs?.read_preference(/datum/preference/toggle/erp))
		if(blessed.arousal >= AROUSAL_MEDIUM)
			var/tarref = REF(blessed)
			if(!LAZYFIND(recent_bless_refs, tarref))
				adjust_favor(15 * (isnull(blessed.mind) ? 0.5 : 1), chap)
				LAZYADD(recent_bless_refs, tarref)
				addtimer(CALLBACK(src, PROC_REF(clear_bless_ref), tarref), 3 MINUTES)
				to_chat(chap, span_love("[GLOB.deity] delights in [blessed]'s ardor."))
				did_something = TRUE

		if(blessed.arousal < AROUSAL_LIMIT)
			blessed.adjust_arousal(20)
			did_something = TRUE

	if(!did_something)
		return BLESSING_IGNORED

	if(heal_result != BLESSING_SUCCESS)
		blessed.visible_message(span_love("[chap] caresses [blessed] with the sensual grace of [GLOB.deity]!"))
		to_chat(blessed, span_love("A warm wave of desire and vigor from [GLOB.deity] flows through you!"))
		playsound(chap, SFX_PUNCH, 25, TRUE, -1)
		blessed.add_mood_event("blessing", /datum/mood_event/blessing)

	return BLESSING_SUCCESS

/datum/religion_sect/lust/proc/clear_bless_ref(tarref)
	LAZYREMOVE(recent_bless_refs, tarref)

/datum/religion_sect/lust/on_sacrifice(obj/item/offering, mob/living/user)
	if(istype(offering, /obj/item/clothing/sextoy))
		if(istype(offering, /obj/item/clothing/sextoy/condom))
			var/obj/item/clothing/sextoy/condom/offered_condom = offering
			if(offered_condom.condom_state != "dirty")
				to_chat(user, span_warning("[offered_condom] needs to be filled before offering it to [GLOB.deity]!"))
				return FALSE
		to_chat(user, span_love("[GLOB.deity] accepts [offering] as a tribute of passion."))
		adjust_favor(25, user)
		playsound(get_turf(offering), 'sound/effects/pray.ogg', 50, TRUE)
		qdel(offering)
		return TRUE

	if(istype(offering, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = offering
		if(!container.reagents)
			return FALSE

		var/favor_earned = 0
		for(var/datum/reagent/reagent as anything in container.reagents.reagent_list)
			if(istype(reagent, /datum/reagent/consumable/cum) || istype(reagent, /datum/reagent/consumable/femcum) || istype(reagent, /datum/reagent/consumable/breast_milk))
				favor_earned += reagent.volume * 1.5
			else if(istype(reagent, /datum/reagent/drug/aphrodisiac))
				favor_earned += reagent.volume * 2

		if(favor_earned < MINIMUM_LUST_OFFERING)
			to_chat(user, span_warning("[container] does not contain enough sexual fluids or aphrodisiacs to please [GLOB.deity]."))
			return FALSE

		for(var/datum/reagent/reagent as anything in container.reagents.reagent_list.Copy())
			if(istype(reagent, /datum/reagent/consumable/cum) || istype(reagent, /datum/reagent/consumable/femcum) || istype(reagent, /datum/reagent/consumable/breast_milk) || istype(reagent, /datum/reagent/drug/aphrodisiac))
				container.reagents.del_reagent(reagent.type)

		to_chat(user, span_love("[GLOB.deity] drinks deeply of your offering."))
		adjust_favor(round(favor_earned), user)
		playsound(get_turf(container), 'sound/items/drink.ogg', 50, TRUE)
		return TRUE

	return FALSE

#undef MINIMUM_LUST_OFFERING

/datum/religion_rites/deaconize/lust
	name = "Initiate Acolyte of Lust"
	desc = "Inducts a willing crewmember on the altar into your sect. Up to three acolytes may be initiated, and their climaxes also grant favor."
	rite_flags = parent_type::rite_flags & ~RITE_ONE_TIME_USE

/datum/religion_rites/deaconize/lust/post_invoke_effects(mob/living/user, atom/religious_tool)
	. = ..()
	if(!istype(GLOB.religious_sect, /datum/religion_sect/lust))
		return

	var/datum/religion_sect/lust/sect = GLOB.religious_sect
	sect.deacon_count += 1
	if(sect.deacon_count >= sect.max_deacons)
		sect.rites_list -= type

/obj/item/reagent_containers/cup/glass/bottle/lust_communion
	name = "bottle of communion nectar"
	desc = "A velvet-labeled bottle of sweet, intoxicating wine infused with divine aphrodisiacs."
	icon = 'modular_zzplurt/icons/obj/drinks/drinks.dmi'
	icon_state = "bloodwine"
	volume = 100
	list_reagents = list(
		/datum/reagent/consumable/ethanol/wine = 50,
		/datum/reagent/drug/aphrodisiac/crocin = 30,
		/datum/reagent/drug/aphrodisiac/dopamine = 20,
	)

/datum/religion_rites/lust_communion
	name = "Distill Communion Nectar"
	desc = "Manifests a bottle of aphrodisiac-infused communion wine on the altar."
	ritual_length = 8 SECONDS
	ritual_invocations = list(
		"Let the fruit of the vine warm our blood...",
		"...and awaken every longing of the flesh...",
	)
	invoke_msg = "...Drink and be satisfied!"
	favor_cost = 50

/datum/religion_rites/lust_communion/invoke_effect(mob/living/user, atom/movable/religious_tool)
	. = ..()
	var/turf/altar_turf = get_turf(religious_tool)
	new /obj/item/reagent_containers/cup/glass/bottle/lust_communion(altar_turf)
	playsound(altar_turf, 'sound/effects/pray.ogg', 50, TRUE)
	return TRUE

/datum/religion_rites/summon_lewd_kit
	name = "Summon Carnal Boon"
	desc = "Beseeches your deity to manifest a sacred furnishing or pleasure kit upon the altar."
	ritual_length = 10 SECONDS
	ritual_invocations = list(
		"Prepare the sanctuary of pleasure...",
		"...grant us the instruments of devotion...",
	)
	invoke_msg = "...Let the rites of the flesh begin!"
	favor_cost = 120
	/// Selected kit typepath to spawn
	var/chosen_kit_path
	/// Static map of selectable kit names to typepaths
	var/static/list/carnal_boon_choices = list(
		"BDSM Bed Kit" = /obj/item/storage/box/bdsmbed_kit,
		"X-Stand Kit" = /obj/item/storage/box/xstand_kit,
		"Shibari Stand Kit" = /obj/item/storage/box/shibari_stand,
		"Milking Machine Kit" = /obj/item/storage/box/milking_kit,
		"Stripper Pole Kit" = /obj/item/storage/box/strippole_kit,
		"Portal Fleshlight and Panties" = /obj/item/storage/box/portal_fleshlight,
	)

/datum/religion_rites/summon_lewd_kit/perform_rite(mob/living/user, atom/religious_tool)
	if(!can_afford(user))
		return FALSE
	var/choice = tgui_input_list(user, "Choose a carnal boon to summon", "Summon Carnal Boon", carnal_boon_choices)
	if(isnull(choice))
		return FALSE
	chosen_kit_path = carnal_boon_choices[choice]
	if(!ispath(chosen_kit_path))
		return FALSE
	return ..()

/datum/religion_rites/summon_lewd_kit/invoke_effect(mob/living/user, atom/movable/religious_tool)
	. = ..()
	if(!ispath(chosen_kit_path))
		return FALSE
	var/turf/altar_turf = get_turf(religious_tool)
	new chosen_kit_path(altar_turf)
	chosen_kit_path = null
	playsound(altar_turf, 'sound/effects/pray.ogg', 50, TRUE)
	return TRUE

/datum/religion_rites/carnal_festival
	name = "Rite of Carnal Ecstasy"
	desc = "Sends a wave of sensual rejuvenation across everyone near the altar, clearing climax cooldowns, restoring stamina, mending organic wounds, and stoking arousal."
	ritual_length = 15 SECONDS
	ritual_invocations = list(
		"Cast aside exhaustion and restraint...",
		"...let every heartbeat quicken as one...",
		"...feel the touch of divine ecstasy...",
	)
	invoke_msg = "...Rejoice in the pleasures of the flesh!"
	favor_cost = 180

/datum/religion_rites/carnal_festival/invoke_effect(mob/living/user, atom/movable/religious_tool)
	. = ..()
	var/turf/altar_turf = get_turf(religious_tool)
	for(var/mob/living/carbon/human/participant in view(5, altar_turf))
		if(participant.stat == DEAD)
			continue
		participant.heal_overall_damage(15, 15, required_bodytype = BODYTYPE_ORGANIC)
		participant.adjust_stamina_loss(-50)
		participant.add_mood_event("blessing", /datum/mood_event/blessing)
		if(participant.client?.prefs?.read_preference(/datum/preference/toggle/erp))
			participant.remove_status_effect(/datum/status_effect/climax_cooldown)
			participant.refractory_period = 0
			participant.adjust_arousal(40)
			to_chat(participant, span_love("A wave of divine ecstasy washes over you, renewing your vigor and desire!"))
		else
			to_chat(participant, span_boldnotice("A warm wave of vitality from [GLOB.deity] restores your strength!"))

	playsound(altar_turf, 'sound/effects/pray.ogg', 60, TRUE)
	return TRUE
