/obj/projectile/meat_ball
	name = "Meat ball"
	icon_state = "mini_leaper"
	speed = 0.5
	range = 16
	layer = LARGE_MOB_LAYER
	can_hit_turfs = TRUE
	var/mob_type

/obj/projectile/meat_ball/on_hit(atom/target, blocked, pierce_hit)
	if(isliving(target))
		var/mob/living/living_target = target
		living_target.visible_message(span_danger("[living_target] is splattered with blood!"), span_userdanger("You're splattered with blood!"))
		living_target.add_blood_DNA(list("Non-human DNA" = random_human_blood_type()))
		living_target.Knockdown(2 SECONDS)
	for(var/turf/blood_turf in view(src, 1))
		new /obj/effect/decal/cleanable/blood(blood_turf)
	playsound(get_turf(src), 'sound/effects/splat.ogg', 50, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE)
	new mob_type(get_turf(src))
	. = ..()

/obj/projectile/meat_ball/huge
	speed = 0.4

/obj/projectile/meat_ball/huge/Initialize(mapload)
	. = ..()
	var/matrix/new_transform = matrix()
	new_transform.Scale(3, 3)
	animate(src, transform = new_transform, time = 3 SECONDS)

/datum/action/cooldown/mob_cooldown/throw_spider
	name = "Throw meat spider ball"
	button_icon_state = "berserk_mode"
	cooldown_time = 6 SECONDS
	shared_cooldown = NONE

	var/projectile_type = /obj/projectile/meat_ball/huge
	var/mob_type = /mob/living/basic/khara_mutant/flesh_spider/weaker

/datum/action/cooldown/mob_cooldown/throw_spider/Activate(atom/target)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(launch_thing), target)

/datum/action/cooldown/mob_cooldown/throw_spider/proc/launch_thing(atom/target)
	new /obj/effect/temp_visual/telegraphing/boss_hit(get_turf(target))
	sleep(1 SECONDS)

	var/obj/projectile/meat_ball/ball = new projectile_type(get_turf(owner))
	ball.mob_type = mob_type
	ball.aim_projectile(target, owner)
	playsound(get_turf(owner), 'sound/effects/splat.ogg', 30, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE)
	INVOKE_ASYNC(ball, TYPE_PROC_REF(/obj/projectile, fire))

#define RUMBLE_RADIUS 3
#define RUMBLE_WARNING_TIME (1.5 SECONDS)
#define RUMBLE_KNOCKDOWN_TIME (3 SECONDS)
#define RUMBLE_THROW_SPEED 1.5

/datum/action/cooldown/mob_cooldown/rumble
	name = "Rumble Earth"
	desc = "Violently shake the ground around you, knocking down and repelling nearby creatures."
	button_icon_state = "berserk_mode"
	cooldown_time = 8 SECONDS
	click_to_activate = FALSE
	shared_cooldown = NONE

	var/radius = RUMBLE_RADIUS


/datum/action/cooldown/mob_cooldown/rumble/Activate(atom/target)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(run_rumbling))

/datum/action/cooldown/mob_cooldown/rumble/proc/run_rumbling()
	owner.visible_message(
		span_danger("[owner] slams [owner.p_their()] limbs into the ground!"),
		span_userdanger("You slam the ground with tremendous force!")
	)

	playsound(owner, 'sound/effects/bang.ogg', 60, TRUE, frequency = 0.9, extrarange = SILENCED_SOUND_EXTRARANGE)
	var/turf/center = get_turf(owner)
	for(var/turf/T in range(radius, center))
		if(get_dist(center, T) > radius)
			continue
		new /obj/effect/temp_visual/telegraphing/boss_hit(T)
	sleep(RUMBLE_WARNING_TIME)

	rumble_wave(center)

/datum/action/cooldown/mob_cooldown/rumble/proc/rumble_wave(turf/epicenter)
	var/static/list/ripple_sounds = list(
		'sound/effects/bang.ogg',
	)

	var/max_wave_radius = radius + 2
	var/list/affected_mobs = list()

	for(var/current_radius in 1 to max_wave_radius)
		sleep(1.5 + (current_radius * 0.8))
		var/list/ring_turfs = list()
		for(var/turf/T in range(current_radius, epicenter))
			if(get_dist(epicenter, T) == current_radius)
				ring_turfs += T
		if(!length(ring_turfs))
			continue
		for(var/turf/T in ring_turfs)
			animate(T, pixel_x = rand(-3,3), pixel_y = rand(-3,3), time = 3, loop = 2, easing = JUMP_EASING)
			animate(pixel_x = 0, pixel_y = 0, time = 4)
		CHECK_TICK
		var/volume = clamp(90 - (current_radius * 12), 30, 90)
		playsound(epicenter, pick(ripple_sounds), volume, TRUE, frequency = 0.7 + (current_radius * 0.04))
		for(var/mob/living/L in range(current_radius + 1, epicenter))
			if(L in affected_mobs)
				continue
			if(L == owner)
				continue
			if(L.incorporeal_move)
				continue
			var/dist = get_dist(epicenter, L)
			if(dist < current_radius - 1 || dist > current_radius + 1.5)
				continue

			affected_mobs += L

			var/strength = clamp((max_wave_radius - dist + 1), 1, max_wave_radius)
			L.apply_damage(5 + strength * 2.5, BRUTE, BODY_ZONE_CHEST, wound_bonus = CANT_WOUND)
			L.Knockdown(2 SECONDS + strength * 1.2)
			L.Paralyze(0.4 SECONDS)

			if(!L.anchored)
				var/dir = get_dir(epicenter, L)
				if(!dir) dir = pick(GLOB.cardinals)

				var/throw_dist = clamp(strength, 1, 5)
				var/turf/target_turf = get_ranged_target_turf(L, dir, throw_dist)
				L.throw_at(target_turf, throw_dist, 1.6, src, spin = FALSE)
		CHECK_TICK
		for(var/mob/M in range(7, epicenter))
			if(current_radius <= 3)
				shake_camera(M, 4, 1.5 + (current_radius * 0.4))
			else
				shake_camera(M, 3, 1)

#undef RUMBLE_RADIUS
#undef RUMBLE_WARNING_TIME
#undef RUMBLE_KNOCKDOWN_TIME
#undef RUMBLE_THROW_SPEED

/datum/action/cooldown/mob_cooldown/aoe_slash
	name = "Rending Slash"
	desc = "Unleash a violent area-of-effect slash in front of you, cutting through flesh and matter."
	background_icon_state = "bg_alien"
	cooldown_time = 7 SECONDS
	shared_cooldown = NONE

	var/damage = 50
	var/obj_damage_mult = 4
	var/wound_bonus = 30
	var/armour_penetration = 50
	var/slash_color = "#ff3333"
	var/attack_sound = 'fenysha_events/sounds/mobs/slash_attack_sound.ogg'
	var/attack_cd = CLICK_CD_MELEE
	var/range = 1


/datum/action/cooldown/mob_cooldown/aoe_slash/Activate(atom/target)
	if(!target || get_dist(target, owner) > 1)
		owner.balloon_alert(owner, "To far!")
		return FALSE
	var/turf/target_turf = get_turf(target)
	if(isclosedturf(target_turf))
		return
	. = ..()

	owner.visible_message(
		span_danger("[owner] performs a ferocious sweeping slash!"),
		span_userdanger("You unleash a devastating area slash!")
	)
	new /obj/effect/temp_visual/telegraphing/boss_hit(get_turf(target_turf))
	addtimer(CALLBACK(src, PROC_REF(do_slash), target_turf), 1 SECONDS)
	return TRUE


/datum/action/cooldown/mob_cooldown/aoe_slash/proc/do_slash(turf/target)
	if(get_dist(target, owner) > 1)
		return
	owner.do_attack_animation(target, ATTACK_EFFECT_SLASH)
	new /obj/effect/temp_visual/huge_slash(target, target, world.icon_size / 2, world.icon_size / 2, slash_color)

	playsound(target, attack_sound, 50, vary = TRUE)

	perform_aoe_slash(target)
	owner.changeNext_move(attack_cd)


/datum/action/cooldown/mob_cooldown/aoe_slash/proc/perform_aoe_slash(turf/epicenter)
	var/list/affected = list()
	for(var/turf/T in range(range - 1, epicenter))
		if(get_dist(owner, T) > range)
			continue

		for(var/atom/A in T.contents)
			if(A in affected)
				continue

			if(isliving(A))
				var/mob/living/L = A
				if(L == owner)
					continue

				L.apply_damage(
					damage,
					BRUTE,
					owner.zone_selected,
					wound_bonus = wound_bonus,
					sharpness = SHARP_EDGED,
					attacking_item = src
				)

				log_combat(owner, L, "aoe slashed", src)
				affected += L

			else if(A.uses_integrity)
				A.take_damage(
					damage * obj_damage_mult,
					BRUTE,
					MELEE,
					TRUE,
					src,
					armour_penetration
				)


/obj/effect/temp_visual/huge_slash
	icon_state = "highfreq_slash"
	alpha = 170
	duration = 0.5 SECONDS
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE

/obj/effect/temp_visual/huge_slash/Initialize(mapload, atom/target, x_slashed, y_slashed, slash_color)
	. = ..()
	if(!target)
		return
	var/matrix/new_transform = matrix()
	new_transform.Turn(rand(1, 360))
	var/datum/decompose_matrix/decomp = target.transform.decompose()
	new_transform.Translate((x_slashed - ICON_SIZE_X/2) * decomp.scale_x, (y_slashed - ICON_SIZE_Y/2) * decomp.scale_y)


	new_transform.Turn(decomp.rotation)
	new_transform.Translate(decomp.shift_x, decomp.shift_y)
	new_transform.Translate(target.pixel_x, target.pixel_y)
	transform = new_transform

	var/matrix/scaled_transform = new_transform + matrix(new_transform.a, new_transform.b, 0, new_transform.d, new_transform.e, 0)
	scaled_transform.Scale(2, 2)
	animate(src, duration*0.5, color = slash_color, transform = scaled_transform, alpha = 255)

/datum/action/cooldown/mob_cooldown/boss_charge/weak
	max_range = 6
	charge_delay = 1 SECONDS

/datum/action/cooldown/mob_cooldown/aoe_slash/extreme
	damage = 100
	obj_damage_mult = 10
	wound_bonus = 100
	armour_penetration = 100

/datum/component/khara_hivemind
	VAR_PRIVATE/static/list/all_minds = list()
	var/datum/action/cooldown/khara_hivemind_talk/action
	var/cast = KHARA_CAST_LESSER

/datum/component/khara_hivemind/Initialize(cast = KHARA_CAST_LESSER)
	if(!is_khara_creature(parent))
		return COMPONENT_INCOMPATIBLE
	action = new()
	action.Grant(parent)
	action.component = src
	all_minds += parent
	src.cast = cast

/datum/component/khara_hivemind/Destroy(force)
	action.Remove(parent)
	QDEL_NULL(action)
	. = ..()

/datum/component/khara_hivemind/proc/get_minds()
	RETURN_TYPE(/list)
	var/list/to_return = list()
	for(var/mob/living/L in all_minds)
		if(QDELETED(L) || !L.client)
			continue
		to_return += L
	return to_return

/datum/action/cooldown/khara_hivemind_talk
	name = "Hivemind talk"
	desc = "Talk to other khara creatures!"
	button_icon = 'icons/mob/actions/actions_revenant.dmi'
	button_icon_state = "discordant_whisper"
	check_flags = NONE
	cooldown_time = 1 SECONDS
	text_cooldown = TRUE
	click_to_activate = FALSE

	var/datum/component/khara_hivemind/component = null

/datum/action/cooldown/khara_hivemind_talk/Activate(atom/target)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(talk_to_hivemind))

/datum/action/cooldown/khara_hivemind_talk/proc/talk_to_hivemind(say_msg = null)
	var/msg = say_msg
	if(!msg)
		msg = tgui_input_text(owner, "What you want to say", "Khara hivemind", multiline = FALSE)
	if(!msg || msg == "")
		return
	var/cast = component.cast
	var/list/listeners = component.get_minds()
	owner.log_sayverb_talk(msg, list(), tag = "khara hivemind")
	var/raw = span_blob("<b><font color=\"[COLOR_RED]\">Khara overmind: ...[msg]</font></b>")
	var/rendered = raw
	if(cast == KHARA_CAST_ADAPTED)
		rendered = span_big(raw)
	else if(cast == KHARA_CAST_ASSIMILATING)
		rendered = span_boldbig(raw)

	relay_to_list_and_observers(
		rendered,
		listeners,
		owner,
		MESSAGE_TYPE_RADIO,
	)
	StartCooldown()


/datum/action/cooldown/mob_cooldown/mech_crush
	name = "Destroy Mech"
	button_icon = 'icons/mob/rideables/mecha.dmi'
	button_icon_state = "seraph-broken"
	desc = "Attack a mech, tearing it apart and destroying the pilot."
	cooldown_time = 1 SECONDS

	var/rip_chance = 33
	var/continues_rip_chance = 10
	var/internal_damage_chance = 20
	var/slash_armor_penetration = 70
	var/damage_per_slash = 60
	var/crushing = FALSE
	var/maximum_distance = 1
	var/time_per_slash = 2.5 SECONDS
	var/time_to_grag = 3 SECONDS

/datum/action/cooldown/mob_cooldown/mech_crush/PreActivate(atom/target)
	if(crushing)
		return FALSE
	if(!ismecha(target))
		return FALSE
	. = ..()

/datum/action/cooldown/mob_cooldown/mech_crush/Activate(atom/target)
	if(get_dist(target, owner) > maximum_distance)
		owner.balloon_alert(owner, "Too far away")
		StartCooldown()
		return
	crushing = TRUE
	StartCooldown()
	owner.balloon_alert_to_viewers("Leaps at [target]")
	INVOKE_ASYNC(src, PROC_REF(crush_mech), target, owner)


/datum/action/cooldown/mob_cooldown/mech_crush/proc/check_continue(obj/vehicle/sealed/mecha/mech, mob/living/user)
	if(QDELETED(mech) \
		|| QDELETED(user) \
		|| user.stat == DEAD \
		|| get_dist(mech, user) > maximum_distance \
		|| !user.can_perform_action(mech, BYPASS_ADJACENCY|ALLOW_RESTING) \
	)
		return FALSE
	return TRUE

#define ACTION_IGNORES (IGNORE_USER_LOC_CHANGE|IGNORE_TARGET_LOC_CHANGE)

/datum/action/cooldown/mob_cooldown/mech_crush/proc/crush_mech(obj/vehicle/sealed/mecha/mech, mob/living/user, hits = 0)
	if(!check_continue(mech, user))
		user.balloon_alert_to_viewers("Stops mauling [mech ? mech : "the mech"]!")
		crushing = FALSE
		return

	var/next_delay = hits ? time_per_slash * max(0.4, (1 - hits)) : time_per_slash
	if(!do_after(user, next_delay, mech, ACTION_IGNORES, \
		extra_checks = CALLBACK(src, PROC_REF(check_continue), mech, user), \
		max_interact_count = 1))

		user.balloon_alert_to_viewers("Stops mauling [mech ? mech : "the mech"]!")
		crushing = FALSE
		return

	var/message = span_warning(pick(list(
		"[user] mercilessly gnaws into the armor of [mech]!",
		"[user] rips apart the armor segments of [mech] with a crunch!",
		"[user] gnaws between the joints of [mech]!",
		"[user] literally tears the armor of [mech] in two!",
		"Sparks and charred chunks fly out from under the armor of [mech]!",
		"[user]'s limb plunges into the hull of [mech] with a horrible grinding sound!",
		"[user] tears the armor plates of [mech] to shreds with savage force!",
		"[user] crunches through the outer layer of [mech]'s armor!",
		"The armor of [mech] cracks and bursts under [user]'s blow!",
		"Acrid smoke and sparks pour from the breach in [mech]!",
		"[user] cuts through the armor of [mech] with terrifying ease, like paper!",
		"The armor of [mech] flies apart from [user]'s powerful blow!"
	)))

	user.visible_message(message, span_warning("You maul the armor of [mech]!"), span_warning("You hear the sounds of clanging metal!"))
	do_sparks(rand(3, 4), TRUE, mech)
	user.do_attack_animation(mech)
	var/damage = mech.take_damage(damage_per_slash, BRUTE, attack_dir = get_dir(user, mech), armour_penetration = slash_armor_penetration)
	if(!damage)
		damage = mech.take_damage(damage_per_slash * 0.3, BRUTE, attack_dir = get_dir(user, mech), armour_penetration = 100)

	new /obj/effect/temp_visual/slash(get_turf(mech), mech, world.icon_size / 2, world.icon_size / 2, COLOR_RED)
	sleep(0.1 SECONDS)

	if(!check_continue(mech, user))
		user.balloon_alert_to_viewers("Stops mauling [mech ? mech : "the mech"]!")
		crushing = FALSE
		return

	if(damage && prob(rip_chance) && mech.flat_equipment)
		for(var/obj/item/mecha_parts/mecha_equipment/qeuipment in shuffle(mech.flat_equipment.Copy()))
			qeuipment.detach()
			do_sparks(rand(3, 4), TRUE, mech)
			user.visible_message(span_danger("[user] aggressively rips [qeuipment] out of [mech], breaking it!"),
								span_warning("You rip [qeuipment] out of [mech]!"))


			new /obj/effect/temp_visual/slash(get_turf(mech), mech, world.icon_size / 2, world.icon_size / 2, COLOR_RED)
			qdel(qeuipment)
			new /obj/effect/decal/cleanable/blood/gibs/robot_debris/up(pick(shuffle(get_adjacent_turfs(mech))))
			if(!prob(continues_rip_chance))
				break
			if(!check_continue(mech, user))
				crushing = FALSE
				return
			sleep(0.2 SECONDS)

	if(!check_continue(mech, user))
		user.balloon_alert_to_viewers("Stops mauling [mech ? mech : "the mech"]!")
		crushing = FALSE
		return

	if(damage && prob(internal_damage_chance))
		var/internal_damage_to_deal = mech.possible_int_damage
		internal_damage_to_deal &= ~mech.internal_damage

		if(internal_damage_to_deal)
			mech.set_internal_damage(pick(bitfield_to_list(internal_damage_to_deal)))

	hits += 1
	addtimer(CALLBACK(src, PROC_REF(crush_mech), mech, user, hits), 1)

#undef ACTION_IGNORES


/datum/action/cooldown/mob_cooldown/consume
	name = "Devour"
	desc = "Devour the target's body parts and innards, shredding them to pieces.."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "berserk_mode"

	var/base_amputation_chance = 30
	var/complicated_limb_amputation_chance = 20
	var/base_damage_min = 40
	var/base_damage_max = 60
	var/wound_bonus = 40
	var/do_after_delay = 4 SECONDS
	var/max_uses_on_down = 3

/datum/action/cooldown/mob_cooldown/consume/Activate(atom/target)
	if(!iscarbon(target))
		return FALSE
	var/mob/living/carbon/carbon_target = target
	if(get_dist(owner, carbon_target) > 1)
		owner.balloon_alert(owner, "too far!")
		return FALSE

	var/amputation_chance = base_amputation_chance
	if(carbon_target.stat != CONSCIOUS)
		amputation_chance += 100

	StartCooldown()
	INVOKE_ASYNC(src, PROC_REF(perform_decup), carbon_target, amputation_chance)

/datum/action/cooldown/mob_cooldown/consume/proc/perform_decup(mob/living/carbon/target, amputation_chance)
	if(!length(target.bodyparts))
		owner.balloon_alert(owner, "No limbs to consume!")
		return

	var/list/valid_limbs = list()
	var/list/complicated_limbs = list()
	for(var/obj/item/bodypart/limb in target.bodyparts)
		if(limb.body_zone == BODY_ZONE_CHEST || limb.body_zone == BODY_ZONE_HEAD)
			complicated_limbs += limb
		else
			valid_limbs += limb

	var/obj/item/bodypart/chosen_limb = length(valid_limbs) ? pick(valid_limbs) : pick(complicated_limbs)
	var/is_complicated_limb = (chosen_limb.body_zone == BODY_ZONE_CHEST || chosen_limb.body_zone == BODY_ZONE_HEAD)

	var/effective_amputation_chance = is_complicated_limb ? complicated_limb_amputation_chance : amputation_chance

	owner.visible_message(
		span_danger("[owner] lunges at [target]'s [chosen_limb.name], baring its teeth to tear it off!"),
		span_danger("You sink your teeth into [target]'s [chosen_limb.name]!"),
	)
	playsound(target, 'sound/effects/magic/demon_attack1.ogg', 50, TRUE)

	if(!do_after(owner, do_after_delay, target))
		owner.balloon_alert(owner, "Consumption interrupted!")
		return

	playsound(target, 'sound/effects/magic/demon_consume.ogg', 75, TRUE)
	owner.balloon_alert(owner, "Consumed [chosen_limb.name]!")

	if(effective_amputation_chance >= 100 || prob(effective_amputation_chance))
		if(!is_complicated_limb)
			chosen_limb.forced_removal(TRUE, TRUE, FALSE)
			target.spawn_gibs()
			owner.visible_message(
				span_danger("[owner] tears off [target]'s [chosen_limb.name] entirely with savage fury!"),
				span_danger("You tear off [target]'s [chosen_limb.name]!"),
			)
			qdel(chosen_limb)
		else
			var/obj/item/organ/to_remove = null
			if(chosen_limb.body_zone == BODY_ZONE_CHEST)
				to_remove = target.get_organ_slot(pick(ORGAN_SLOT_HEART, ORGAN_SLOT_LIVER, ORGAN_SLOT_LUNGS, ORGAN_SLOT_STOMACH))
			else
				to_remove = target.get_organ_slot(pick(ORGAN_SLOT_EARS, ORGAN_SLOT_EYES, ORGAN_SLOT_BRAIN))
			if(to_remove)
				to_remove.bodypart_remove(chosen_limb, target)
				owner.visible_message(
					span_danger("[owner] rips out [target]'s [to_remove.name] with a disgusting crunch!"),
					span_danger("You rip out [target]'s [to_remove.name]!"),
				)
				target.spawn_gibs()
			else
				target.apply_damage(rand(base_damage_min * 1.5, base_damage_max * 1.5), BRUTE, chosen_limb.body_zone, FALSE, wound_bonus = wound_bonus)
	else
		target.apply_damage(rand(base_damage_min, base_damage_max), BRUTE, chosen_limb.body_zone, FALSE, wound_bonus = wound_bonus)
		owner.visible_message(
			span_danger("[owner] brutally tears and shreds [target]'s [chosen_limb.name]!"),
			span_danger("You savagely tear apart [target]'s [chosen_limb.name]!"),
		)

	INVOKE_ASYNC(src, PROC_REF(perform_decup), target, amputation_chance)
