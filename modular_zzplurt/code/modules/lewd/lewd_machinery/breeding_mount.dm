/obj/item/storage/box/breeding_mount_kit
	name = "DIY breeding mount kit"
	desc = "Contains everything you need to assemble a stationary breeding mount with built-in biometric sensors!"

/obj/item/storage/box/breeding_mount_kit/Initialize(mapload)
	. = ..()
	if(CONFIG_GET(flag/disable_lewd_items))
		return INITIALIZE_HINT_QDEL

/obj/item/storage/box/breeding_mount_kit/PopulateContents()
	var/static/items_inside = list(
		/obj/item/construction_kit/bdsm/breeding_mount = 1,
	)
	generate_items_inside(items_inside, src)

/obj/item/construction_kit/bdsm/breeding_mount
	icon_state = "bdsm_bed_kit"
	resulting_structure = /obj/structure/chair/breeding_mount

/obj/structure/chair/breeding_mount
	name = "breeding mount"
	desc = "A padded, stationary silicone mount equipped with an internal sleeve, contoured grinding ridge, and biometric sensors that grade and compare riders' anatomy and performance."
	icon = 'modular_zzplurt/icons/obj/research_rack.dmi'
	icon_state = "rack"
	can_buckle = TRUE
	max_buckled_mobs = 1
	buckle_lying = 0
	item_chair = null
	max_integrity = 100
	/// Number of humps performed in the current mounting session
	var/session_thrusts = 0
	/// Cooldown between humping actions
	COOLDOWN_DECLARE(hump_cooldown)
	/// Name of the highest-scoring rider recorded on this mount
	var/best_rider_name
	/// Highest breeding score recorded on this mount
	var/best_score = 0
	/// Rank string of the highest score recorded
	var/best_rank
	/// Summary of the last rider evaluated by the mount
	var/last_readout

/obj/structure/chair/breeding_mount/Initialize(mapload)
	. = ..()
	if(CONFIG_GET(flag/disable_lewd_items))
		return INITIALIZE_HINT_QDEL
	register_context()

/obj/structure/chair/breeding_mount/Destroy()
	unbuckle_all_mobs(TRUE)
	return ..()

/obj/structure/chair/breeding_mount/wrench_act_secondary(mob/living/user, obj/item/weapon)
	return NONE

/obj/structure/chair/breeding_mount/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_LMB] = has_buckled_mobs() ? "Hump Mount" : "Mount"
		context[SCREENTIP_CONTEXT_RMB] = "Measure Stats / Unbuckle"
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Reset High Score"
		context[SCREENTIP_CONTEXT_CTRL_SHIFT_LMB] = "Disassemble"
		return CONTEXTUAL_SCREENTIP_SET
	return NONE

/obj/structure/chair/breeding_mount/examine(mob/user)
	. = ..()
	. += span_purple("Click while buckled to hump [src], or right-click to run a biometric breeding evaluation or dismount.")
	. += span_purple("[src] can be disassembled with <b>Ctrl+Shift+Click</b>, or have its leaderboard reset with <b>Alt+Click</b>.")
	if(best_rider_name)
		. += span_love("<b>Top Recorded Breeder:</b> [best_rider_name] ([best_score] pts, [best_rank])")
	if(last_readout)
		. += span_notice("<b>Last Evaluation:</b> [last_readout]")

/obj/structure/chair/breeding_mount/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if(!M.check_erp_prefs(/datum/preference/toggle/erp/sex_toy, user, src))
		to_chat(user, span_warning("Looks like [M] doesn't want to use [src]."))
		return FALSE
	return ..()

/obj/structure/chair/breeding_mount/post_buckle_mob(mob/living/affected_mob)
	. = ..()
	session_thrusts = 0
	affected_mob.add_offsets(type, y_add = 4)
	RegisterSignal(affected_mob, COMSIG_MOB_POST_CLIMAX, PROC_REF(on_rider_climax))

/obj/structure/chair/breeding_mount/post_unbuckle_mob(mob/living/affected_mob)
	. = ..()
	session_thrusts = 0
	affected_mob.remove_offsets(type)
	UnregisterSignal(affected_mob, COMSIG_MOB_POST_CLIMAX)

/obj/structure/chair/breeding_mount/attack_hand(mob/living/user, list/modifiers)
	if(!ishuman(user))
		return ..()

	if(has_buckled_mobs())
		var/mob/living/buckled_rider = buckled_mobs[1]
		if(user == buckled_rider)
			hump_mount(user, user)
			return TRUE
		if(Adjacent(user))
			hump_mount(buckled_rider, user)
			return TRUE
		return ..()

	if(get_turf(user) != get_turf(src) && Adjacent(user) && user.stat == STABLE)
		user.forceMove(get_turf(src))
	if(user_buckle_mob(user, user, check_loc = TRUE))
		user.visible_message(
			span_love("[user] straddles [src], settling onto its contoured padding!"),
			span_love("You straddle [src], settling your hips against the padded mount."),
		)
		return TRUE
	return ..()

/obj/structure/chair/breeding_mount/attack_hand_secondary(mob/living/user, list/modifiers)
	if(!has_buckled_mobs())
		return SECONDARY_ATTACK_CONTINUE_CHAIN

	var/mob/living/carbon/human/rider = buckled_mobs[1]
	if(!istype(rider))
		user_unbuckle_mob(buckled_mobs[1], user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/choice = tgui_alert(user, "What would you like to do with [src]?", name, list("Evaluate Stats", "Dismount"))
	if(choice == "Evaluate Stats" && (rider in buckled_mobs))
		evaluate_rider(rider, climax_bonus = FALSE)
	else if(choice == "Dismount" && (rider in buckled_mobs))
		user_unbuckle_mob(rider, user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/chair/breeding_mount/click_alt(mob/user)
	if(!best_rider_name && !last_readout)
		balloon_alert(user, "already cleared!")
		return CLICK_ACTION_BLOCKING
	best_rider_name = null
	best_score = 0
	best_rank = null
	last_readout = null
	balloon_alert(user, "records cleared")
	playsound(src, 'sound/machines/terminal/terminal_BEEP.ogg', 30, TRUE)
	return CLICK_ACTION_SUCCESS

/obj/structure/chair/breeding_mount/click_ctrl_shift(mob/user)
	add_fingerprint(user)
	to_chat(user, span_notice("You begin unfastening the frame and sensors of [src]..."))
	if(!do_after(user, 8 SECONDS, src))
		to_chat(user, span_warning("You fail to disassemble [src]."))
		return FALSE
	to_chat(user, span_notice("You disassemble [src]."))
	new /obj/item/construction_kit/bdsm/breeding_mount(loc)
	unbuckle_all_mobs(TRUE)
	qdel(src)
	return TRUE

/// Performs a single hump or thrust against the breeding mount
/obj/structure/chair/breeding_mount/proc/hump_mount(mob/living/carbon/human/rider, mob/living/actor)
	if(!istype(rider) || rider.stat != STABLE)
		return FALSE
	if(!rider.check_erp_prefs(/datum/preference/toggle/erp/sex_toy, actor, src))
		to_chat(actor, span_warning("Looks like [rider] doesn't want to do that."))
		return FALSE
	if(!COOLDOWN_FINISHED(src, hump_cooldown))
		return FALSE

	COOLDOWN_START(src, hump_cooldown, 1.2 SECONDS)
	session_thrusts++

	var/obj/item/organ/genital/penis/penis = rider.get_organ_slot(ORGAN_SLOT_PENIS)
	var/obj/item/organ/genital/vagina/vagina = rider.get_organ_slot(ORGAN_SLOT_VAGINA)
	var/has_exposed_penis = rider.has_penis(REQUIRE_GENITAL_EXPOSED) && penis
	var/has_exposed_vagina = rider.has_vagina(REQUIRE_GENITAL_EXPOSED) && vagina

	if(actor == rider)
		if(has_exposed_penis && has_exposed_vagina)
			rider.visible_message(
				span_love("[rider] ruts eagerly against [src], driving [rider.p_their()] [penis.genital_name] shaft into the sleeve while grinding [rider.p_their()] slit along the ridge!"),
				span_love("You rut eagerly against [src],hilting your shaft into the warm sleeve while grinding your slit across the ridge!"),
			)
		else if(has_exposed_penis)
			rider.visible_message(
				span_love("[rider] bucks [rider.p_their()] hips into [src], thrusting [rider.p_their()] [penis.genital_name] cock deep into the tight silicone sleeve!"),
				span_love("You buck your hips into [src], driving your cock deep into the warm, textured sleeve!"),
			)
		else if(has_exposed_vagina)
			rider.visible_message(
				span_love("[rider] grinds [rider.p_their()] hips down onto [src], rubbing [rider.p_their()] [vagina.genital_name] pussy along the contoured saddle!"),
				span_love("You grind your hips against [src], pressing your sensitive folds along the contoured saddle!"),
			)
		else
			rider.visible_message(
				span_love("[rider] humps rhythmically against [src]'s padded saddle!"),
				span_love("You hump rhythmically against [src]'s padded saddle!"),
			)
	else
		rider.visible_message(
			span_love("[actor] grabs [rider]'s hips and rocks [rider.p_them()] hard against [src]!"),
			span_love("[actor] grabs your hips and rocks you hard against [src]!"),
		)

	animate(rider, pixel_y = rider.base_pixel_y + 7, time = 2)
	animate(pixel_y = rider.base_pixel_y + 4, time = 2)

	conditional_pref_sound(
		get_turf(src),
		pick(
			'modular_zzplurt/sound/interactions/bang1.ogg',
			'modular_zzplurt/sound/interactions/bang2.ogg',
			'modular_zzplurt/sound/interactions/bang3.ogg',
		),
		50,
		TRUE,
		pref_to_check = /datum/preference/toggle/erp/sounds,
	)

	if(penis)
		rider.plug13_genital_emote(penis, PLUG13_STRENGTH_MEDIUM, PLUG13_DURATION_SHORT)
	if(vagina)
		rider.plug13_genital_emote(vagina, PLUG13_STRENGTH_MEDIUM, PLUG13_DURATION_SHORT)

	var/pleasure_before = rider.pleasure
	rider.adjust_arousal(15)
	rider.adjust_pleasure(20, rider)

	var/lust_tolerance = rider.dna?.features["lust_tolerance"] || 1
	if(pleasure_before >= (AROUSAL_AUTO_CLIMAX_THRESHOLD * lust_tolerance) && rider.pleasure >= (AROUSAL_AUTO_CLIMAX_THRESHOLD * lust_tolerance))
		rider.climax(manual = TRUE)

	return TRUE

/// Signal handler triggered when the buckled rider climaxes
/obj/structure/chair/breeding_mount/proc/on_rider_climax(mob/living/source, mob/living/partner, interaction_position, manual)
	SIGNAL_HANDLER

	if(!ishuman(source))
		return
	evaluate_rider(source, climax_bonus = TRUE)

/// Measures anatomical dimensions, traits, and session performance to compute a breeding score
/obj/structure/chair/breeding_mount/proc/evaluate_rider(mob/living/carbon/human/rider, climax_bonus = FALSE)
	var/score = 0
	var/list/stat_parts = list()

	var/obj/item/organ/genital/penis/penis = rider.get_organ_slot(ORGAN_SLOT_PENIS)
	if(penis)
		var/penis_pts = round((penis.genital_size * 4) + (penis.girth * 2.5))
		var/list/penis_tags = list("[penis.genital_size]\"x[penis.girth]\" [LOWER_TEXT(penis.genital_name)]")
		if(penis.knotted)
			penis_pts += 20
			penis_tags += "knotted"
		if(penis.sheath != SHEATH_NONE)
			penis_pts += 10
			penis_tags += "sheathed"
		score += penis_pts
		stat_parts += "Shaft: [jointext(penis_tags, ", ")] (+[penis_pts])"

	var/obj/item/organ/genital/testicles/testicles = rider.get_organ_slot(ORGAN_SLOT_TESTICLES)
	if(testicles)
		testicles.calculate_cumshot()
		var/balls_pts = round((testicles.genital_size * 8) + (testicles.cumshot_size * 1.5))
		score += balls_pts
		stat_parts += "Virility: size [testicles.genital_size], [round(testicles.cumshot_size, 0.1)]u load (+[balls_pts])"

	var/obj/item/organ/genital/vagina/vagina = rider.get_organ_slot(ORGAN_SLOT_VAGINA)
	if(vagina)
		var/wetness = vagina.reagents ? round(vagina.reagents.total_volume, 0.1) : 0
		var/vagina_pts = round(25 + (vagina.aroused * 10) + (wetness * 2))
		score += vagina_pts
		stat_parts += "Receptivity: [LOWER_TEXT(vagina.genital_name)], [wetness]u lubrication (+[vagina_pts])"

	var/obj/item/organ/genital/breasts/breasts = rider.get_organ_slot(ORGAN_SLOT_BREASTS)
	if(breasts && breasts.genital_size > 0)
		var/cup_label = breasts.breasts_size_to_cup(breasts.genital_size)
		var/milk_vol = breasts.reagents ? round(breasts.reagents.total_volume, 0.1) : 0
		var/breast_pts = round((breasts.genital_size * 5) + (breasts.lactates ? 15 : 0) + milk_vol)
		score += breast_pts
		stat_parts += "Bust: [cup_label]-cup[breasts.lactates ? " (lactating, [milk_vol]u)" : ""] (+[breast_pts])"

	var/trait_pts = 0
	var/list/trait_labels = list()
	if(HAS_TRAIT(rider, TRAIT_HYPERSEXUAL))
		trait_pts += 25
		trait_labels += "Hypersexual"
	if(HAS_TRAIT(rider, TRAIT_CONCUBUS))
		trait_pts += 25
		trait_labels += "Concubus"
	if(HAS_TRAIT(rider, TRAIT_DUMB_CUM))
		trait_pts += 20
		trait_labels += "Cum-Brained"
	if(HAS_TRAIT(rider, TRAIT_BIMBO))
		trait_pts += 20
		trait_labels += "Bimbo"
	if(HAS_TRAIT(rider, TRAIT_MASOCHISM))
		trait_pts += 15
		trait_labels += "Masochist"
	if(HAS_TRAIT(rider, TRAIT_SADISM))
		trait_pts += 15
		trait_labels += "Sadist"
	if(HAS_TRAIT(rider, TRAIT_JIGGLY_ASS) || HAS_TRAIT(rider, TRAIT_STEEL_ASS))
		trait_pts += 15
		trait_labels += "Gluteal Prodigy"
	if(rider.has_status_effect(/datum/status_effect/pregnancy))
		trait_pts += 30
		trait_labels += "Gravid"
	if(HAS_TRAIT(rider, TRAIT_INFERTILE))
		trait_pts -= 25
		trait_labels += "Infertile"

	if(length(trait_labels))
		score += trait_pts
		stat_parts += "Traits: [jointext(trait_labels, ", ")] ([trait_pts >= 0 ? "+[trait_pts]" : "[trait_pts]"])"

	var/stamina_pts = min(session_thrusts * 5, 75) + (climax_bonus ? 50 : 0)
	if(stamina_pts > 0)
		score += stamina_pts
		stat_parts += "Performance: [session_thrusts] thrust\s[climax_bonus ? " + Climax Finish" : ""] (+[stamina_pts])"

	score = max(score, 1)
	var/rank_title = get_breeding_rank(score)
	var/new_record = FALSE
	if(score > best_score)
		best_score = score
		best_rider_name = rider.real_name
		best_rank = rank_title
		new_record = TRUE

	last_readout = "[rider.real_name] - [score] pts ([rank_title]): [jointext(stat_parts, " | ")]"
	say("Biometric evaluation for [rider.real_name] complete: [score] points ([rank_title])[new_record ? " - NEW STATION RECORD!" : "!"]")
	to_chat(rider, span_love("<b>[src] Readout:</b> [last_readout]"))
	playsound(src, new_record ? 'sound/machines/ping.ogg' : 'sound/machines/twobeep_high.ogg', 40, TRUE)

/// Maps a numeric breeding score to a rank tier string
/obj/structure/chair/breeding_mount/proc/get_breeding_rank(score)
	switch(score)
		if(300 to INFINITY)
			return "SS-Rank Apex Breeder"
		if(220 to 299)
			return "S-Rank Prime Dynamo"
		if(150 to 219)
			return "A-Rank Certified Stud"
		if(90 to 149)
			return "B-Rank Eager Hopper"
		if(45 to 89)
			return "C-Rank Novice Hump"
		else
			return "D-Rank Warm-Up"
