// An odd mix between the chainsaw and the dualsaber. So odd that I had to rewrite the code from scratch.
/obj/item/energychainsaw
	name = "energy chainsaw"
	desc = "An advanced Syndicate design, this chainsaw is powered by the same technology that runs their infamous energy swords. Equally capable of cutting through flesh, steel, and wood, making it a favorite of breachers and assault troopers alike. Specialized electrostatic technology allows this chainsaw to be attached to your back."
	icon = 'icons/obj/weapons/chainsaw.dmi'
	icon_state = "echainsaw"
	lefthand_file = 'icons/mob/inhands/weapons/chainsaw_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/chainsaw_righthand.dmi'
	inhand_icon_state = "echainsaw"
	obj_flags = CONDUCTS_ELECTRICITY
	icon_angle = -45
	attack_verb_continuous = list("saws", "tears", "lacerates", "cuts", "chops", "dices")
	attack_verb_simple = list("saw", "tear", "lacerate", "cut", "chop", "dice")
	hitsound = SFX_SWING_HIT
	// Well built, but not indestructible.
	max_integrity = 300
	armor_type = /datum/armor/item_dualsaber
	resistance_flags = FIRE_PROOF

	w_class = WEIGHT_CLASS_HUGE
	// Can fit in your backpack slot, or else it's way too cumbersome to use.
	slot_flags = ITEM_SLOT_BACK
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_SAW
	toolspeed = 2
	demolition_mod = 1.5
	// The amount of damage the chainsaw deals when not active. This chainsaw has no teeth, so it is not very effective when not powered.
	force = 8
	// Ditto.
	throwforce = 10
	// Armour penetration. Slightly higher than the desword.
	armour_penetration = 40
	bare_wound_bonus = 20

	actions_types = list(/datum/action/item_action/esaw)

	light_system = OVERLAY_LIGHT
	light_range = 6
	light_color = LIGHT_COLOR_FLARE
	light_on = FALSE

	// Amount of damage the chainsaw deals when active. Slightly more than the desword.
	var/force_on = 45
	// If you're willing to throw it, you can deal a bit more force than normal.
	var/throwforce_on = 50
	// Ditto.
	var/throw_speed_on = 3

	/// The looping sound for our chainsaw when running.
	var/datum/looping_sound/esaw/chainsaw_loop
	/// How long it takes to behead someone with this chainsaw. Slightly faster than a normal chainsaw.
	var/behead_time = 10 SECONDS

/obj/item/energychainsaw/Initialize(mapload)
	. = ..()
	chainsaw_loop = new(src)
	AddComponent(/datum/component/butchering, \
		speed = 3 SECONDS, \
		effectiveness = 100, \
		bonus_modifier = 0, \
		butcher_sound = 'sound/items/weapons/blade1.ogg', \
		disabled = TRUE, \
	)
	AddComponent(/datum/component/two_handed, require_twohands = TRUE)
	AddComponent( \
		/datum/component/transforming, \
		force_on = force_on, \
		throwforce_on = throwforce_on, \
		throw_speed_on = throw_speed_on, \
		sharpness_on = SHARP_EDGED, \
		hitsound_on = 'sound/items/weapons/blade1.ogg', \
		w_class_on = w_class, \
	)

	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/obj/item/energychainsaw/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	to_chat(user, span_notice("As you toggle the energy blade via the [src]'s control panel, [active ? "it begins to rev to life" : "the energy blade dissipates"]."))
	var/datum/component/butchering/butchering = GetComponent(/datum/component/butchering)
	butchering.butchering_enabled = active
	if (active)
		chainsaw_loop.start()
		set_light_on(TRUE)
	else
		chainsaw_loop.stop()
		set_light_on(FALSE)

	toolspeed = active ? 0.5 : initial(toolspeed)
	update_item_action_buttons()

	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/energychainsaw/attack(mob/living/target_mob, mob/living/user, params)
	if (target_mob.stat != DEAD)
		return ..()

	if (user.zone_selected != BODY_ZONE_HEAD)
		return ..()

	var/obj/item/bodypart/head = target_mob.get_bodypart(BODY_ZONE_HEAD)
	if (isnull(head))
		return ..()

	playsound(user, 'sound/items/weapons/blade1.ogg', vol = 80, vary = TRUE)

	target_mob.balloon_alert(user, "cutting off head...")
	if (!do_after(user, behead_time, target_mob, extra_checks = CALLBACK(src, PROC_REF(has_same_head), target_mob, head)))
		return TRUE

	head.dismember(silent = FALSE)
	user.put_in_hands(head)

	return TRUE

/obj/item/energychainsaw/proc/has_same_head(mob/living/target_mob, obj/item/bodypart/head)
	return target_mob.get_bodypart(BODY_ZONE_HEAD) == head

/datum/looping_sound/esaw
	start_sound = 'sound/machines/generator/generator_start.ogg'
	start_length = 0.4 SECONDS
	mid_sounds = list(
		'sound/machines/generator/generator_mid1.ogg',
		'sound/machines/generator/generator_mid2.ogg',
		'sound/machines/generator/generator_mid3.ogg',
	)
	mid_length = 0.4 SECONDS
	end_sound = 'sound/machines/generator/generator_end.ogg'
	end_volume = 35
	volume = 40
	ignore_walls = FALSE

/datum/action/item_action/startesaw
	name = "Toggle The Energy Blade"
