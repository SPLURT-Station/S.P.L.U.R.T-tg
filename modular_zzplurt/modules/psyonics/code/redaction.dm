#define HALFWAYCRITDEATH ((HEALTH_THRESHOLD_CRIT + HEALTH_THRESHOLD_DEAD) * 0.5)

/// Школа лечения
/// Имеет 5 спеллов в данный момент
/// Roentgen - обычный мед скан, работающий на дистанции
/// Меnding - лечит кровь, открытые раны и окси урон. Также удаляет импланты/ксеноморфов из тела при определённых условиях.
/// Ethanol Synthesis - если интент на харма, то "превращает" упитанность в алкоголь на дистанции. Любой другой - наоборот.
/// Cleansing - лечит токс урон
/// Revive - пытается оживить труп

// Выдать школу лечения
/mob/living/carbon/human/proc/try_add_redaction_school(tier = 0, additional_school = 0)
	if(tier >= 0)
		var/datum/action/new_action = new /datum/action/cooldown/spell/pointed/psyonic/psyonic_roentgen(src.mind || src, tier, additional_school)
		new_action.Grant(src)
	if(tier >= 1)
		var/datum/action/new_action = new /datum/action/cooldown/spell/touch/psyonic/psyonic_mending(src.mind || src, tier, additional_school)
		new_action.Grant(src)
	if(tier >= 2)
		var/datum/action/new_action2 = new /datum/action/cooldown/spell/pointed/psyonic/psyonic_drunkness(src.mind || src, tier, additional_school)
		new_action2.Grant(src)
	if(tier >= 3)
		var/datum/action/new_action = new /datum/action/cooldown/spell/touch/psyonic/psyonic_cleansing(src.mind || src, tier, additional_school)
		new_action.Grant(src)
	if(tier >= 4)
		var/datum/action/new_action = new /datum/action/cooldown/spell/touch/psyonic/psyonic_revival(src.mind || src, tier, additional_school)
		new_action.Grant(src)

// Мед сканер на расстоянии
/datum/action/cooldown/spell/pointed/psyonic/psyonic_roentgen
	name = "Roentgen"
	desc = "Try to read target's vital energy and determine their state."
	button_icon = 'modular_zzplurt/modules/psyonics/icons/actions.dmi'
	button_icon_state = "roentgen"

	cooldown_time = 1 SECONDS

	mana_cost = 10
	target_msg = "You feel like someone is looking deep into you."

	active_msg = "You prepare to scan a target..."

/datum/action/cooldown/spell/pointed/psyonic/psyonic_roentgen/New(Target)
	. = ..()
	if(secondary_school == "Redaction")
		cast_power += 1

/datum/action/cooldown/spell/pointed/psyonic/psyonic_roentgen/is_valid_target(atom/cast_on)
	if(!ishuman(cast_on))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/psyonic/psyonic_roentgen/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(cast_on.can_block_magic(antimagic_flags))
		to_chat(cast_on, span_notice("Your body is being read by a psyonic nearby."))
	else
		to_chat(cast_on, span_warning(target_msg))
	if(cast_power > 2)
		healthscan(owner, cast_on, SCANNER_VERBOSE, TRUE, tochat = TRUE)
	else
		healthscan(owner, cast_on, SCANNER_VERBOSE, FALSE, tochat = TRUE)
	drain_mana()
	return TRUE

/obj/item/melee/touch_attack/psyonic_mending
	name = "psyonic sparks"
	desc = "Concentrated psyonic energy in a hand."
	icon = 'icons/obj/weapons/hand.dmi'
	icon_state = "greyscale"
	color = COLOR_VERY_PALE_LIME_GREEN
	inhand_icon_state = "greyscale"
	light_range = 2
	light_power = 1
	light_color = LIGHT_COLOR_LIGHT_CYAN
	light_on = TRUE

// Восстанавливает кровь, окси урон, открытые травмы. Не лечит другие типы урона. Если вторичка - психокинетика, то вынимает импланты.
// Если уровень Эпсилон - удаляет лярвы ксеноморфов.
/datum/action/cooldown/spell/touch/psyonic/psyonic_mending
	name = "Psyonic Mending"
	desc = "You can try to restore patients bloodloss, bones, open wounds and partially oxygen level in blood. Does not heal brute, burn, \
			and toxic damage. With Psychokinesis as secondary school also can remove small implants. At Epsilon level can remove xenomorph larvae."
	button_icon = 'modular_zzplurt/modules/psyonics/icons/actions.dmi'
	button_icon_state = "mending_touch"
	cooldown_time = 3 SECONDS
	mana_cost = 25
	stamina_cost = 25
	target_msg = "You body numbs a little."
	hand_path = /obj/item/melee/touch_attack/psyonic_mending
	draw_message = span_notice("You ready your hand to mend a patient.")
	drop_message = span_notice("You lower your hand.")
	can_cast_on_self = TRUE

/datum/action/cooldown/spell/touch/psyonic/psyonic_mending/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/mendicant)
	if(ishuman(victim))
		var/mob/living/carbon/human/human_victim = victim
		if(issynthetic(human_victim) && secondary_school != "Psychokinesis")
			to_chat(owner, span_notice("I dont know how to work with synths."))
			return FALSE
		if(human_victim.can_block_magic(antimagic_flags))
			to_chat(human_victim, span_notice("Psionic nearby tries to mend you."))
		else
			to_chat(human_victim, span_warning(target_msg))
		if(!do_after(mendicant, 5 SECONDS, human_victim, IGNORE_SLOWDOWNS, TRUE))
			accident_harm(human_victim)
		else
			try_heal_all(human_victim)
		drain_mana()
		return TRUE
	else
		return FALSE

/datum/action/cooldown/spell/touch/psyonic/psyonic_mending/proc/accident_harm(mob/living/carbon/human/patient)
	patient.take_bodypart_damage(5, wound_bonus = 100)

/datum/action/cooldown/spell/touch/psyonic/psyonic_mending/proc/try_heal_all(mob/living/carbon/human/patient)
	if(patient.blood_volume < BLOOD_VOLUME_NORMAL)
		patient.blood_volume += ((BLOOD_VOLUME_NORMAL - patient.blood_volume) / 5) * cast_power // Эффективнее когда крови мало

	if(patient.all_wounds)
		var/datum/wound/wound2fix = patient.all_wounds[1]
		wound2fix.remove_wound()
		playsound(patient, 'sound/effects/wounds/crack2.ogg', 40, TRUE)

	if(patient.get_oxy_loss() >= OXYLOSS_PASSOUT_THRESHOLD-10)
		patient.adjust_oxy_loss(-cast_power*5, forced = TRUE)

	if(patient.implants && secondary_school == "Psychokinesis" && cast_power >= 2) // Невольно удаляет импланты, если есть
		var/obj/item/implant/imp_2_del = pick(patient.implants)
		var/atom/drop_loc = imp_2_del.drop_location()
		imp_2_del.removed(patient)
		if(drop_loc)
			imp_2_del.forceMove(drop_loc)
		patient.visible_message(
									span_warning("[patient]s skin rips open, [imp_2_del] flies out of it and then the wound suddenly heals."),
									span_danger("You feel implant inside you starts to move and rips itself out! The resulting wound quickly closes itself though."),
								)

	if(patient.get_organ_slot("parasite_egg") && cast_power >=4) // Удаляем ксеноморфов
		var/obj/item/organ/body_egg/parasite = patient.get_organ_slot("parasite_egg")
		parasite.owner.vomit(VOMIT_CATEGORY_BLOOD | MOB_VOMIT_KNOCKDOWN | MOB_VOMIT_HARM)
		parasite.owner.visible_message(
										span_warning("[patient] twitches, gags and vomits a living creqture with blood! Gross!"),
										span_bolddanger("Suddenly you feel sharp pain in your chest, then something starts moving up your throat. \
														Before you can react somethign slips past your lips with a mix of vomit and blood!"),
									  )
		var/atom/drop_loc = parasite.drop_location()
		parasite.Remove(parasite.owner)
		if(drop_loc)
			parasite.forceMove(drop_loc)

/datum/action/cooldown/spell/pointed/psyonic/psyonic_drunkness
	name = "Ethanol Body Synthesis"
	desc = "Convert fat masses to ethanol in combat mode, vice versa otherwise. Works with time on distance, but not on synthetics."
	button_icon = 'icons/obj/drinks/bottles.dmi'
	button_icon_state = "beer"
	cooldown_time = 1 SECONDS
	mana_cost = 30
	stamina_cost = 30
	active_msg = "You prepare to convert fat tissues..."

/datum/action/cooldown/spell/pointed/psyonic/psyonic_drunkness/is_valid_target(atom/cast_on)
	if(!ishuman(cast_on))
		return FALSE
	if(issynthetic(cast_on) )
		to_chat(owner, span_notice("It's a synth. What am I supposed to convert? Oil?"))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/pointed/psyonic/psyonic_drunkness/cast(mob/living/carbon/human/cast_on)
	. = ..()
	cast_on.apply_status_effect(/datum/status_effect/psyonic_fat_conversion, 5 * cast_power SECONDS, !cast_on.combat_mode)
	drain_mana()
	return TRUE

/// С каждым тиком конвертируем или жир в алкоголь, или алкоголь в жир
/datum/status_effect/psyonic_fat_conversion
	id = "psyonic_fat_conversion"
	alert_type = null
	remove_on_fullheal = TRUE
	var/eth2fat = TRUE

/datum/status_effect/psyonic_fat_conversion/on_creation(mob/living/new_owner, duration = 10 SECONDS, eth2fat = TRUE)
	src.duration = duration
	src.eth2fat = eth2fat
	return ..()

/datum/status_effect/psyonic_fat_conversion/tick(seconds_between_ticks)
	var/mob/living/carbon/human/human_owner = owner
	var/fat = human_owner.nutrition
	var/drunk = human_owner.get_drunk_amount()
	if(eth2fat && !drunk) // если нет алкашки, то и конвертировать нечего
		return
	if(eth2fat) // алкашку в жир
		human_owner.adjust_drunk_effect(-(drunk/6))
		human_owner.adjust_nutrition(drunk)
	if(!eth2fat && fat) // жир в алкашку. За 25 тиков полностью обезжирим человека!
		human_owner.adjust_drunk_effect(fat/125)
		human_owner.adjust_nutrition(-(fat/25))

// Лечит токс урон.
/datum/action/cooldown/spell/touch/psyonic/psyonic_cleansing
	name = "Psyonic Cleansing"
	desc = "Filters patient blood out of toxins and removes accumulated radiation."
	button_icon = 'modular_zzplurt/modules/psyonics/icons/actions.dmi'
	button_icon_state = "cleansing"
	cooldown_time = 3 SECONDS
	mana_cost = 35
	stamina_cost = 40
	target_msg = "Your insides itch."

	hand_path = /obj/item/melee/touch_attack/psyonic_mending
	draw_message = span_notice("You ready your hand to cleanse a patient.")
	drop_message = span_notice("You lower your hand.")
	can_cast_on_self = TRUE

/datum/action/cooldown/spell/touch/psyonic/psyonic_cleansing/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/mendicant)
	if(ishuman(victim))
		var/mob/living/carbon/human/human_victim = victim
		if(issynthetic(human_victim) && secondary_school != "Psychokinesis")
			to_chat(owner, span_notice("I dont know how to work with synths. Why would I even try to? They dont have toxins."))
			return FALSE
		if(human_victim.can_block_magic(antimagic_flags))
			to_chat(human_victim, span_notice("Psionic nearby tries to cleanse you."))
		else
			to_chat(human_victim, span_warning(target_msg))
		if(!do_after(mendicant, 5 SECONDS, human_victim, IGNORE_SLOWDOWNS, TRUE))
			accident_harm(human_victim)
		else
			try_heal_all(human_victim)
		drain_mana()
		return TRUE
	else
		return FALSE

/datum/action/cooldown/spell/touch/psyonic/psyonic_cleansing/proc/accident_harm(mob/living/carbon/human/patient)
	patient.apply_damage(25, TOX, BODY_ZONE_CHEST)

/datum/action/cooldown/spell/touch/psyonic/psyonic_cleansing/proc/try_heal_all(mob/living/carbon/human/patient)
	if(patient.get_tox_loss() > 0)
		patient.adjust_tox_loss(clamp(-(patient.get_tox_loss()/3)*cast_power, -35, 0), forced = TRUE)

/**
 * Пытается оживить труп
 *
 * Логика прока:
 * 1. Смотрит есть ли причина по которой нельзя дефибнуть, пытается её устранить
 * 2. Если не удалось устранить - не оживляет
 * 3. Если удалось устранить причину - проверяет можно ли дефибнуть снова. Если появилась другая - не оживляет. Всё ок - оживляет.
 */
/datum/action/cooldown/spell/touch/psyonic/psyonic_revival
	name = "Psyonic Revival"
	desc = "Ability to trick death itself. Call for the bodys soul in the other realm in attempt to restore its vessel condition to an... acceptable levels."
	button_icon = 'modular_zzplurt/modules/psyonics/icons/actions.dmi'
	button_icon_state = "revive"
	cooldown_time = 3 SECONDS
	mana_cost = 80
	stamina_cost = 160

	hand_path = /obj/item/melee/touch_attack/psyonic_mending
	draw_message = span_notice("You ready your hand to revive a patient.")
	drop_message = span_notice("You lower your hand.")
	can_cast_on_self = FALSE

/datum/action/cooldown/spell/touch/psyonic/psyonic_revival/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/mendicant)
	if(ishuman(victim))
		var/mob/living/carbon/human/human_victim = victim
		var/synth_check = (secondary_school == "Psychokinesis" || !issynthetic(human_victim))
		if(human_victim.stat == DEAD && synth_check)
			owner.visible_message(span_notice("[owner] kneels before the body of [victim], lowers their hands onto cadavers chest and begins... meditating?"),
								span_notice("You kneel before the cadaver, lower your hands onto their chest and start to concentrate energy. You better not \
								get disturbed, or else..."))
			var/obj/effect/abstract/particle_holder/particle_effect = new(human_victim, /particles/droplets/psyonic)
			if(!do_after(mendicant, 25 SECONDS, human_victim, IGNORE_SLOWDOWNS, TRUE))
				accident_harm(owner) // Ауч. Больно бьёт по псионику
			else
				try_heal_all(human_victim)
			if(particle_effect)
				QDEL_NULL(particle_effect)
			drain_mana()
			return TRUE
		else if(issynthetic(human_victim) && human_victim.stat == DEAD)
			to_chat(owner, span_warning("Your psyonic energy does not work very well with synths."))
			return FALSE
		else
			return FALSE
	else
		return FALSE

// 25 токса + 50 брута + 1 травма + позор роду псионическому
/datum/action/cooldown/spell/touch/psyonic/psyonic_revival/proc/accident_harm(mob/living/carbon/human/unlucky_guy)
	unlucky_guy.apply_damage(25, TOX, BODY_ZONE_CHEST)
	unlucky_guy.take_bodypart_damage(25, wound_bonus = 100)
	unlucky_guy.take_bodypart_damage(25, wound_bonus = 100, sharpness = SHARP_EDGED)
	unlucky_guy.visible_message(span_warning("Something inside of [unlucky_guy]s body cracks!"),
						  span_bolddanger("Your revival energy backfired at you, causing severe injuries!"),
						  blind_message = span_hear("You hear bones breaking."))

/datum/action/cooldown/spell/touch/psyonic/psyonic_revival/proc/can_defib_human(mob/living/carbon/human/patient)
	var/defib_result = patient.can_defib()
	var/fail_reason
	var/synth_check = (secondary_school == "Psychokinesis")
	switch (defib_result)
		if (DEFIB_FAIL_SUICIDE)
			fail_reason = "Patient has left this world on their terms. You can not restore them."
		if (DEFIB_FAIL_NO_HEART)
			fail_reason = "Patient's heart is missing and you are not Alpha tier to create it out of air."
		if (DEFIB_FAIL_FAILING_HEART)
			var/obj/item/organ/heart/target_heart = patient.get_organ_slot(ORGAN_SLOT_HEART)
			if(target_heart)
				target_heart.operated = TRUE
				if((target_heart.organ_flags & ORGAN_ORGANIC) || synth_check) // Only fix organic heart
					patient.set_organ_loss(ORGAN_SLOT_HEART, 60)
				else
					fail_reason = "Patient's heart is made out of metals and plastics. You cannot work with that."
		if (DEFIB_FAIL_TISSUE_DAMAGE)
			patient.adjust_brute_loss(patient.get_brute_loss()/2)
			patient.adjust_fire_loss(patient.get_fire_loss()/2)
			if ((patient.get_brute_loss() >= MAX_REVIVE_BRUTE_DAMAGE) || (patient.get_fire_loss() >= MAX_REVIVE_FIRE_DAMAGE))
				fail_reason = "Patient's body is too flimsy to support life, but your energy partially healed that. Maybe try again?"
		if (DEFIB_FAIL_HUSK)
			patient.cure_husk()
			if(HAS_TRAIT(patient, TRAIT_HUSK))
				fail_reason = "Patient's body is a mere husk, and you cannot cure them."
		if (DEFIB_FAIL_FAILING_BRAIN)
			var/obj/item/organ/brain/target_brain = patient.get_organ_slot(ORGAN_SLOT_BRAIN)
			if(target_brain)
				if((target_brain.organ_flags & ORGAN_ORGANIC) || synth_check) // Only fix organic heart
					patient.set_organ_loss(ORGAN_SLOT_BRAIN, 60)
				else
					fail_reason = "Patient's brain is made out of metals and plastics. You cannot work with that."
		if (DEFIB_FAIL_NO_INTELLIGENCE)
			fail_reason = "Patient is braindead. Your energy doesnt course through such body."
		if (DEFIB_FAIL_NO_BRAIN)
			fail_reason = "Patient's brain is missing. You cannot replicate such fine organ."
		if (DEFIB_FAIL_BLACKLISTED)
			fail_reason = "Patient soul is linked to the dead realm with death grip. You cannot restore him."
	return fail_reason

/datum/action/cooldown/spell/touch/psyonic/psyonic_revival/proc/try_heal_all(mob/living/carbon/human/patient)
	var/fail_reason = can_defib_human(patient) // first to possibly cure something
	fail_reason = can_defib_human(patient) // second to actually try revival
	if(fail_reason)
		owner.visible_message(span_warning(fail_reason))
	else
		var/defib_result = patient.can_defib()
		if (defib_result == DEFIB_POSSIBLE)
			var/total_brute = patient.get_brute_loss()
			var/total_burn = patient.get_fire_loss()

			var/need_mob_update = FALSE
			if (patient.health > HALFWAYCRITDEATH)
				need_mob_update += patient.adjust_oxy_loss(patient.health - HALFWAYCRITDEATH, updating_health = FALSE)
			else
				var/overall_damage = total_brute + total_burn + patient.get_tox_loss() + patient.get_oxy_loss()
				var/mobhealth = patient.health
				need_mob_update += patient.adjust_oxy_loss((mobhealth - HALFWAYCRITDEATH) * (patient.get_oxy_loss() / overall_damage), updating_health = FALSE)
				need_mob_update += patient.adjust_tox_loss((mobhealth - HALFWAYCRITDEATH) * (patient.get_tox_loss() / overall_damage), updating_health = FALSE, forced = TRUE) // force tox heal for toxin lovers too
				need_mob_update += patient.adjust_fire_loss((mobhealth - HALFWAYCRITDEATH) * (total_burn / overall_damage), updating_health = FALSE)
				need_mob_update += patient.adjust_brute_loss((mobhealth - HALFWAYCRITDEATH) * (total_brute / overall_damage), updating_health = FALSE)
			if(need_mob_update)
				patient.updatehealth()
			owner.visible_message(span_green("Revival successful."))
			playsound(src, 'sound/effects/ghost.ogg', 40, FALSE)
			patient.set_heartattack(FALSE)
			if(defib_result == DEFIB_POSSIBLE)
				patient.grab_ghost()
			patient.revive()
			patient.emote("gasp")
			patient.set_jitter_if_lower(200 SECONDS)
			to_chat(patient, "<span class='userdanger'>[CONFIG_GET(string/blackoutpolicy)]</span>")
			SEND_SIGNAL(patient, COMSIG_LIVING_MINOR_SHOCK)
			log_combat(owner, patient, "psyonically revived")

#undef HALFWAYCRITDEATH
