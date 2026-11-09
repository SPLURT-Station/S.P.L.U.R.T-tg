/// Normal roach body, plus a clown nose. Armed subtypes install their own cannon.
/mob/living/basic/cockroach/clownroach
	name = "clownroach"
	desc = "A cockroach with a tiny red clown nose."
	icon = 'modular_zzplurt/icons/mob/living/basic/vermin/cockroach/clownroach.dmi'
	icon_state = "clownroach"
	icon_living = "clownroach"
	icon_dead = "clownroach_dead"
	health = 1
	maxHealth = 1
	minion_path = null
	/// Super variants replace the original insect guts with confetti.
	var/confetti_death = FALSE
	/// Shared initialization also covers the armed super subtype.
	var/has_pie_cannon = FALSE

/mob/living/basic/cockroach/clownroach/Initialize(mapload)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return
	enable_clown_honking()
	if(confetti_death)
		RemoveElement(/datum/element/death_drops, /obj/effect/decal/cleanable/insectguts)
		AddElement(/datum/element/death_drops, /obj/effect/decal/cleanable/confetti)
		RegisterSignal(src, COMSIG_LIVING_DEATH, PROC_REF(play_confetti_death_sound))
	if(has_pie_cannon)
		AddComponent( \
			/datum/component/ranged_attacks, \
			projectile_type = /obj/projectile/clownroach_pie, \
			projectile_sound = 'sound/items/weapons/sonic_jackhammer.ogg', \
			cooldown_time = 2 SECONDS, \
		)

/mob/living/basic/cockroach/clownroach/proc/play_confetti_death_sound(mob/living/source, gibbed)
	SIGNAL_HANDLER

	var/static/list/whoopee_sounds = list(
		'sound/effects/brap/brap1.ogg',
		'sound/effects/brap/brap2.ogg',
		'sound/effects/brap/brap3.ogg',
		'sound/effects/brap/brap4.ogg',
	)
	playsound(source, pick(whoopee_sounds), 50, TRUE)

/mob/living/basic/cockroach/clownroach/armed
	name = "clownroach"
	desc = "A cockroach with a tiny red clown nose and an unnecessarily functional pie cannon."
	icon_state = "clownroach_armed"
	icon_living = "clownroach_armed"
	icon_dead = "clownroach_armed_dead"
	has_pie_cannon = TRUE
	gold_core_spawnable = HOSTILE_SPAWN
	ai_controller = /datum/ai_controller/basic_controller/cockroach/glockroach

/mob/living/basic/cockroach/clownroach/super
	name = "super clownroach"
	desc = "A rainbow-shelled cockroach with a tiny red clown nose. Surely this is the peak of comedy."
	icon_state = "super_clownroach"
	icon_living = "super_clownroach"
	icon_dead = "super_clownroach_dead"
	health = 2
	maxHealth = 2
	confetti_death = TRUE

/mob/living/basic/cockroach/clownroach/super/armed
	name = "super clownroach"
	desc = "A rainbow-shelled cockroach with a tiny red clown nose and a pie cannon. The joke is on you."
	icon_state = "super_clownroach_armed"
	icon_living = "super_clownroach_armed"
	icon_dead = "super_clownroach_armed_dead"
	has_pie_cannon = TRUE
	gold_core_spawnable = HOSTILE_SPAWN
	ai_controller = /datum/ai_controller/basic_controller/cockroach/glockroach

/// A casing-free pie projectile, using the same splat component as cream pies.
/obj/projectile/clownroach_pie
	name = "tiny cream pie"
	icon = 'icons/obj/food/piecake.dmi'
	icon_state = "pie"
	damage = 0
	impact_effect_type = null
	range = 15
	nondirectional_sprite = TRUE

/obj/projectile/clownroach_pie/Initialize(mapload)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return
	transform = matrix().Scale(0.5)
	AddComponent(/datum/component/splat, hit_callback = CALLBACK(src, PROC_REF(cream_target)))

/// Phase before any hit/splat callbacks, including if the shared roach guard is absent.
/obj/projectile/clownroach_pie/prehit_pierce(atom/target)
	if(istype(target, /mob/living/basic/cockroach))
		return PROJECTILE_PIERCE_PHASE
	return ..()

/// Matches the standard banana cream pie's stun, eye blur and impact sound.
/obj/projectile/clownroach_pie/proc/cream_target(mob/living/victim, can_splat_on)
	victim.Paralyze(2 SECONDS)
	if(can_splat_on)
		victim.adjust_eye_blur(2 SECONDS)
	victim.visible_message(span_warning("[victim] is creamed by [src]!"), span_userdanger("You've been creamed by [src]!"))
	playsound(victim, SFX_DESECRATION, 50, TRUE)

/// Shared by the clownroaches and the two clown-nosed luberoach variants only.
/// Replace the per-controller speech list instead of editing the inherited list.
/mob/living/basic/cockroach/proc/enable_clown_honking()
	verb_say = "honks"
	verb_ask = "honks inquisitively"
	verb_exclaim = "honks loudly"
	verb_yell = "honks loudly"
	speak_emote = list("honks")
	if(isnull(ai_controller))
		return
	ai_controller.override_blackboard_key(BB_BASIC_MOB_SPEAK_LINES, list(
		// Use the real emote: it owns both the horn sound and any bananium effect.
		BB_EMOTE_SAY = list("*honk"),
		BB_SPEAK_CHANCE = 5,
	))
	ai_controller.override_blackboard_key(BB_OWNER_SELF_HARM_RESPONSES, list(
		"*me waves its antennae in disapproval.",
		"*honk",
	))

/// Normal bike-horn honking, available only to the roaches that have clown noses.
/datum/emote/living/clown_nosed_roach_honk
	key = "honk"
	key_third_person = "honks"
	message = "honks."
	emote_type = EMOTE_AUDIBLE
	mob_type_allowed_typecache = list(
		/mob/living/basic/cockroach/clownroach,
		/mob/living/basic/cockroach/luberoach/super,
	)
	sound = 'sound/items/bikehorn.ogg'
	sound_volume = 80
	vary = TRUE
	// Match the golden horn's one-second limit, including player-controlled honks.
	cooldown = 1 SECONDS
	manual_general_emote_audio_cooldown = 1 SECONDS
	manual_specific_emote_audio_cooldown = 1 SECONDS
	forced_general_emote_audio_cooldown = 1 SECONDS
	forced_specific_emote_audio_cooldown = 1 SECONDS

/datum/emote/living/clown_nosed_roach_honk/run_emote(mob/user, params, type_override, intentional = FALSE)
	var/honk_is_audible = should_play_sound(user, intentional)
	. = ..()
	// The base emote returns null on success and FALSE when audio is on cooldown.
	if(!honk_is_audible || (!isnull(.) && !.))
		return
	if(!istype(user, /mob/living/basic/cockroach/clownroach/super) && !istype(user, /mob/living/basic/cockroach/luberoach/super/ultra))
		return
	var/turf/honk_turf = get_turf(user)
	if(isnull(honk_turf))
		return
	// Same listeners and deafness check as /obj/item/bikehorn/golden/flip_mobs().
	for(var/mob/living/carbon/listener in ohearers(7, honk_turf))
		if(!HAS_TRAIT(listener, TRAIT_DEAF))
			listener.emote("flip")
