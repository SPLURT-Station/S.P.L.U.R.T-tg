// Port of the hugbot (automatic hugging unit) from the old SPLURT/Sand base,
// rewritten for the basic bot framework. Comforts sad crew with hugs,
// headpats and nose boops, and does not appreciate being tipped over.

#define HUG_BOT "Hugbot"

///Whether the bot will give pep talks before comforting someone.
#define HUGBOT_SPEAK_MODE (1<<0)
///If the bot will stand still, only comforting those next to it.
#define HUGBOT_STATIONARY_MODE (1<<1)
///Is the bot currently tipped over?
#define HUGBOT_TIPPED_MODE (1<<2)

///Time between voiced tipping reactions, to avoid spam.
#define HUGBOT_VOICE_COOLDOWN 15 SECONDS
///How long after being comforted until someone is eligible for more comfort.
#define HUGBOT_REHUG_COOLDOWN 20 SECONDS
///How panicked we get about being tipped over, and at which points we voice it.
#define HUGBOT_PANIC_LOW 15
#define HUGBOT_PANIC_MED 35
#define HUGBOT_PANIC_HIGH 55
#define HUGBOT_PANIC_FUCK 70
#define HUGBOT_PANIC_ENDING 90
#define HUGBOT_PANIC_END 100

/mob/living/basic/bot/hugbot
	name = "\improper Hugbot"
	desc = "A little cudly robot. He looks excited."
	icon = 'modular_zzplurt/icons/mob/aibots.dmi'
	icon_state = "hugbot1"
	base_icon_state = "hugbot"
	health = 20
	maxHealth = 20
	speed = 2
	pass_flags = PASSMOB | PASSFLAPS
	status_flags = (CANPUSH | CANSTUN)
	ai_controller = /datum/ai_controller/basic_controller/bot/hugbot
	custom_materials = list(/datum/material/cardboard = SHEET_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 2)

	req_one_access = list(ACCESS_ROBOTICS)
	radio_key = /obj/item/encryptionkey/headset_med
	radio_channel = RADIO_CHANNEL_MEDICAL
	bot_type = HUG_BOT
	hackables = "manipulator pressure sensors"
	possessed_message = "You are a hugbot! Provide the crew with comfort and headpats to the best of your ability!"
	path_image_color = "#FFDDDD"

	///Bitflags deciding how the hugbot acts. Selections: HUGBOT_SPEAK_MODE | HUGBOT_STATIONARY_MODE | HUGBOT_TIPPED_MODE
	var/hugbot_flags = HUGBOT_SPEAK_MODE
	///The body zone we aim for. Chest = hugs, head = headpats, precise mouth = nose boops.
	var/hug_target_zone = BODY_ZONE_CHEST
	///Sanity needed to allow comforting someone; people saner than this are left alone.
	var/max_sanity = 70
	///When enabled, the hugbot will not change targets and will hug regardless of mood.
	var/tania_mode = FALSE
	///How panicked we are about being tipped over (why would you do this?)
	var/tipped_status = 0
	///The last time we said a voiced line about being tipped/righted, to avoid spam.
	var/last_tipping_voice = 0
	///Who tipped us over, so we know whether to forgive whoever rights us.
	var/datum/weakref/tipper

	///Pep talks given when starting to comfort someone.
	var/static/list/pep_talks = list(
		"Thank you!",
		"You are a good person.",
		"I love you.",
		"Keep doing what you are good at.",
		"You are a brilliant person.",
		"Keep doing what you love.",
		"We all love you.",
		"You are doing a great job.",
		"You are important to us all.",
		"Keep it up.",
	)
	///Pep talks given when starting to comfort someone while emagged.
	var/static/list/emagged_pep_talks = list(
		"Fuck you!",
		"Go look at a mirror and cry.",
		"I hate you.",
		"You'll never be good at your job.",
		"You are a horrible person.",
		"Give up.",
		"We all hate you.",
		"You are doing a horrible job.",
		"You are a burden to the station.",
		"Fuck off.",
	)
	///Voiced lines when someone begins tipping us over.
	var/static/list/tipped_announcements = list(
		MEDIBOT_VOICED_WAIT = 'sound/mobs/non-humanoids/medbot/hey_wait.ogg',
		MEDIBOT_VOICED_DONT = 'sound/mobs/non-humanoids/medbot/please_dont.ogg',
		MEDIBOT_VOICED_TRUSTED_YOU = 'sound/mobs/non-humanoids/medbot/i_trusted_you.ogg',
		MEDIBOT_VOICED_NO_SAD = 'sound/mobs/non-humanoids/medbot/nooo.ogg',
		MEDIBOT_VOICED_OH_FUCK = 'sound/mobs/non-humanoids/medbot/oh_fuck.ogg',
	)
	///Voiced lines when someone other than our tipper rights us.
	var/static/list/untipped_announcements = list(
		MEDIBOT_VOICED_FORGIVE = 'sound/mobs/non-humanoids/medbot/forgive.ogg',
		MEDIBOT_VOICED_THANKS = 'sound/mobs/non-humanoids/medbot/thank_you.ogg',
		MEDIBOT_VOICED_GOOD_PERSON = 'sound/mobs/non-humanoids/medbot/youre_good.ogg',
	)
	///Voiced lines when we right ourselves after being tipped for too long.
	var/static/list/self_right_announcements = list(
		MEDIBOT_VOICED_FUCK_YOU = 'sound/mobs/non-humanoids/medbot/fuck_you.ogg',
		MEDIBOT_VOICED_BEHAVIOUR_REPORTED = 'sound/mobs/non-humanoids/medbot/reported.ogg',
	)
	///Voiced lines while panicking about being tipped over.
	var/static/list/worried_announcements = list(
		MEDIBOT_VOICED_ASSISTANCE = 'sound/mobs/non-humanoids/medbot/i_require_asst.ogg',
		MEDIBOT_VOICED_PUT_BACK = 'sound/mobs/non-humanoids/medbot/please_put_me_back.ogg',
		MEDIBOT_VOICED_IM_SCARED = 'sound/mobs/non-humanoids/medbot/please_im_scared.ogg',
		MEDIBOT_VOICED_NEED_HELP = 'sound/mobs/non-humanoids/medbot/dont_like.ogg',
		MEDIBOT_VOICED_THIS_HURTS = 'sound/mobs/non-humanoids/medbot/pain_is_real.ogg',
		MEDIBOT_VOICED_THE_END = 'sound/mobs/non-humanoids/medbot/is_this_the_end.ogg',
		MEDIBOT_VOICED_NOOO = 'sound/mobs/non-humanoids/medbot/nooo.ogg',
	)

/mob/living/basic/bot/hugbot/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/tippable, \
		tip_time = 3 SECONDS, \
		untip_time = 3 SECONDS, \
		self_right_time = 3.5 MINUTES, \
		pre_tipped_callback = CALLBACK(src, PROC_REF(pre_tip_over)), \
		post_tipped_callback = CALLBACK(src, PROC_REF(after_tip_over)), \
		post_untipped_callback = CALLBACK(src, PROC_REF(after_righted)), \
	)
	RegisterSignal(src, COMSIG_HOSTILE_PRE_ATTACKINGTARGET, PROC_REF(pre_attack))

/mob/living/basic/bot/hugbot/generate_speak_list()
	var/static/list/finalized_speak_list = (tipped_announcements + untipped_announcements + self_right_announcements + worried_announcements)
	return finalized_speak_list

/mob/living/basic/bot/hugbot/update_icon_state()
	. = ..()
	if(!(bot_mode_flags & BOT_MODE_ON))
		icon_state = "hugbot0"
		return
	if(HAS_TRAIT(src, TRAIT_INCAPACITATED))
		icon_state = "hugbota"
		return
	var/stationary_suffix = hugbot_flags & HUGBOT_STATIONARY_MODE ? 2 : 1
	icon_state = mode == BOT_HEALING ? "hugbots[stationary_suffix]" : "hugbot[stationary_suffix]"

// Variables sent to TGUI
/mob/living/basic/bot/hugbot/ui_data(mob/user)
	var/list/data = ..()
	if(!(bot_access_flags & BOT_COVER_LOCKED) || HAS_SILICON_ACCESS(user))
		data["custom_controls"]["maximum_sanity"] = max_sanity
		data["custom_controls"]["mode_selected"] = hug_target_zone
		data["custom_controls"]["speaker"] = hugbot_flags & HUGBOT_SPEAK_MODE
		data["custom_controls"]["stationary_mode"] = hugbot_flags & HUGBOT_STATIONARY_MODE
		if((bot_access_flags & BOT_COVER_MAINTS_OPEN) || isAdminObserver(user))
			data["custom_controls"]["tania_mode"] = tania_mode
	return data

// Actions received from TGUI
/mob/living/basic/bot/hugbot/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/mob/user = ui.user
	if(. || !isliving(user) || (bot_access_flags & BOT_COVER_LOCKED) && !HAS_SILICON_ACCESS(user))
		return
	switch(action)
		if("maximum_sanity")
			var/adjust_num = isnull(params["amount"]) ? null : round(text2num(params["amount"]))
			if(isnull(adjust_num)) // the simple bot interface has no slider for this, so click through the values
				adjust_num = max_sanity >= SANITY_GREAT ? SANITY_CRAZY : max_sanity + 25
			max_sanity = clamp(adjust_num, SANITY_CRAZY, SANITY_GREAT)
		if("op_mode")
			var/static/list/operation_modes = list(
				"Hug" = BODY_ZONE_CHEST,
				"Pat" = BODY_ZONE_HEAD,
				"Boop" = BODY_ZONE_PRECISE_MOUTH,
			)
			var/target = tgui_input_list(user, "Select operating mode:", "Hugbot", operation_modes)
			if(!isnull(target))
				hug_target_zone = operation_modes[target]
		if("speaker")
			hugbot_flags ^= HUGBOT_SPEAK_MODE
		if("tania_mode")
			if((bot_access_flags & BOT_COVER_MAINTS_OPEN) || isAdminObserver(user))
				tania_mode = !tania_mode
		if("stationary_mode")
			hugbot_flags ^= HUGBOT_STATIONARY_MODE
			bot_reset()
			update_appearance()

	update_appearance()

/// Returns TRUE if the patient is eligible for some comfort right now.
/mob/living/basic/bot/hugbot/proc/assess_patient(mob/living/carbon/human/patient)
	if(patient.stat == DEAD || HAS_TRAIT(patient, TRAIT_FAKEDEATH))
		return FALSE //welp too late for them!
	if((bot_access_flags & BOT_COVER_EMAGGED) || tania_mode) // EVERYONE GETS HUGS!
		return TRUE
	if(isnull(patient.mob_mood))
		return FALSE
	if(!isnull(patient.mob_mood.get_mood_event("hug")) || !isnull(patient.mob_mood.get_mood_event("headpat")))
		return FALSE // they have been comforted recently
	if(patient.mob_mood.sanity > max_sanity) // If you're already sane you won't need a hug
		return FALSE
	if(patient.IsKnockdown()) // Prevents stun memes
		return FALSE
	return TRUE

/// Signal hook from melee attacks: comfort the patient instead of hitting them.
/mob/living/basic/bot/hugbot/proc/pre_attack(mob/living/puncher, atom/target)
	SIGNAL_HANDLER

	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return
	if(!ishuman(target))
		return
	INVOKE_ASYNC(src, PROC_REF(give_comfort), target)
	return COMPONENT_HOSTILE_NO_ATTACK

/// Comforts an adjacent patient with a hug, headpat or nose boop.
/mob/living/basic/bot/hugbot/proc/give_comfort(mob/living/carbon/human/patient)
	if(!(bot_mode_flags & BOT_MODE_ON))
		return
	if(!assess_patient(patient))
		return
	if(get_dist(src, patient) > 1)
		update_bot_mode(new_mode = BOT_MOVING)
		return
	if(mode != BOT_HEALING) // just started doting on this one, say something nice (or not)
		update_bot_mode(new_mode = BOT_HEALING)
		if(hugbot_flags & HUGBOT_SPEAK_MODE)
			speak(pick((bot_access_flags & BOT_COVER_EMAGGED) ? emagged_pep_talks : pep_talks))
	switch(hug_target_zone)
		if(BODY_ZONE_PRECISE_MOUTH)
			patient.visible_message( \
				span_notice("[src] boops [patient]'s nose."), \
				span_notice("[src] boops you on the nose."),
			)
			playsound(patient, 'modular_zzplurt/sound/items/nose_boop.ogg', 50, FALSE)
			patient.add_mood_event("headpat", /datum/mood_event/headpat)
		if(BODY_ZONE_HEAD)
			patient.visible_message( \
				span_notice("[src] gives [patient] a pat on the head to make [patient.p_them()] feel better!"), \
				span_notice("[src] gives you a pat on the head to make you feel better!"),
			)
			patient.add_mood_event("headpat", /datum/mood_event/headpat)
			var/obj/item/organ/tail/patient_tail = patient.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
			if(!isnull(patient_tail) && !(patient_tail.wag_flags & WAG_WAGGING))
				patient.emote("wag")
		else
			patient.visible_message( \
				span_notice("[src] hugs [patient] to make [patient.p_them()] feel better!"), \
				span_notice("[src] hugs you to make you feel better!"),
			)
			patient.add_mood_event("hug", /datum/mood_event/hug)

	playsound(src, 'sound/items/weapons/thudswoosh.ogg', 50, TRUE, -1)

	if(bot_access_flags & BOT_COVER_EMAGGED) // Emagged actions
		patient.adjust_stamina_loss(50)
	else // Otherwise you just help them
		patient.AdjustStun(-6 SECONDS)
		patient.AdjustKnockdown(-6 SECONDS)
		patient.AdjustUnconscious(-6 SECONDS)
		patient.AdjustSleeping(-10 SECONDS)
		patient.adjust_stamina_loss(-15)
		if(!tania_mode)
			update_bot_mode(new_mode = BOT_IDLE)

/mob/living/basic/bot/hugbot/emag_effects(mob/user)
	balloon_alert(user, "manipulator pressure sensors shorted")
	visible_message(span_danger("[src]'s arm twitches violently!"))
	flick_overlay_view(mutable_appearance('icons/mob/silicon/aibots.dmi', "medbot_spark"), 1 SECONDS)
	playsound(src, SFX_SPARKS, 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	return TRUE

/mob/living/basic/bot/hugbot/explode()
	var/atom/our_loc = drop_location()
	drop_part(/obj/item/storage/box/hug, our_loc)
	new /obj/item/assembly/prox_sensor(our_loc)
	return ..()

/*
 * Tipping callbacks, fired by the tippable component.
 */

/// Called right before someone finishes tipping us over.
/mob/living/basic/bot/hugbot/proc/pre_tip_over(mob/user)
	if(world.time < last_tipping_voice + HUGBOT_VOICE_COOLDOWN)
		return
	last_tipping_voice = world.time
	speak(pick(tipped_announcements))

/// Called after we have been tipped over.
/mob/living/basic/bot/hugbot/proc/after_tip_over(mob/user)
	hugbot_flags |= HUGBOT_TIPPED_MODE
	tipped_status = 0
	tipper = WEAKREF(user)
	playsound(src, 'sound/machines/warning-buzzer.ogg', 50)

/// Called after we have been righted, either by someone (user) or by ourselves (no user).
/mob/living/basic/bot/hugbot/proc/after_righted(mob/user)
	hugbot_flags &= ~HUGBOT_TIPPED_MODE
	tipped_status = 0
	var/mob/tipper_mob = isnull(user) ? null : tipper?.resolve()
	tipper = null
	if(!isnull(tipper_mob) && tipper_mob == user)
		speak(MEDIBOT_VOICED_FORGIVE) // the tipper had a change of heart
		return
	if(world.time < last_tipping_voice + HUGBOT_VOICE_COOLDOWN)
		return
	last_tipping_voice = world.time
	if(isnull(user))
		speak(pick(self_right_announcements))
	else
		speak(pick(untipped_announcements))

/// Fired at the end of our panic escalation: report the tipper and right ourselves.
/mob/living/basic/bot/hugbot/proc/right_ourselves()
	var/mob/tipper_mob = tipper?.resolve()
	speak("PSYCH ALERT: Crewmember [tipper_mob ? tipper_mob.name : "Unknown"] recorded displaying antisocial tendencies torturing bots in [get_area(src)]. Please schedule psych evaluation.", radio_channel)
	var/datum/component/tippable/tippable = GetComponent(/datum/component/tippable)
	tippable?.right_self(src)

/// The headpat moodlet handed out by headpats and nose boops.
/datum/mood_event/headpat
	description = "Headpats are nice."
	mood_change = 2
	timeout = 2 MINUTES

/*
 * Construction: empty a box of hugs, add a robot arm, then a proximity sensor.
 */

/obj/item/bot_assembly/hugbot
	desc = "It's a box of hugs with an arm attached."
	name = "incomplete hugbot assembly"
	icon = 'modular_zzplurt/icons/mob/aibots.dmi'
	icon_state = "hugbot_arm"
	created_name = "Hugbot"
	/// Type of robot arm the box was built with; dropped when the bot is destroyed.
	var/arm_type = /obj/item/bodypart/arm/right/robot

/obj/item/bot_assembly/hugbot/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(build_step != ASSEMBLY_FIRST_STEP)
		return NONE
	if(!isprox(tool))
		return NONE
	if(!can_finish_build(tool, user))
		return ITEM_INTERACT_BLOCKING
	var/mob/living/basic/bot/hugbot/new_bot = new(drop_location())
	new_bot.name = created_name
	new_bot.robot_arm = arm_type
	to_chat(user, span_notice("You add [tool] to [src]. Beep boop!"))
	qdel(tool)
	qdel(src)
	return ITEM_INTERACT_SUCCESS
/obj/item/storage/box/hug/attackby(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!istype(attacking_item, /obj/item/bodypart/arm/left/robot) && !istype(attacking_item, /obj/item/bodypart/arm/right/robot))
		return ..()
	if(contents.len) //prevent accidentally deleting contents
		to_chat(user, span_warning("You need to empty [src] out first!"))
		return
	if(!user.temporarilyRemoveItemFromInventory(attacking_item))
		return
	qdel(attacking_item)
	var/obj/item/bot_assembly/hugbot/assembly = new
	assembly.arm_type = attacking_item.type
	to_chat(user, span_notice("You add [attacking_item] to [src]! You've got a hugbot assembly now!"))
	user.put_in_hands(assembly)
	qdel(src)
