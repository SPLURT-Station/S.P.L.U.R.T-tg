/// Psychokinesis school
/// Имеет 6 спеллов.
/// Psy-lighter - spawns a lighter in hand
/// Psy-blade - creates a psy-blade in hand, damage scales with psyonics power
/// Psy-tool - spawns omnitool in hand
/// Tinker - repairs integrity of whatever we touch
/// Psyforce - grants jaws of life for prying doors open
/// Telekinesis - grants the telekinesis gene

// Adds in the psychokinesis school
/mob/living/carbon/human/proc/try_add_psychokinesis_school(tier = 0, additional_school = 0)
	if(tier >= 0)
		var/datum/action/new_action = new /datum/action/cooldown/spell/conjure_item/psyonic/psilighter(src.mind || src, tier, additional_school)
		new_action.Grant(src)
	if(tier >= 1)
		var/datum/action/new_action = new /datum/action/cooldown/spell/conjure_item/psyonic/psiblade(src.mind || src, tier, additional_school)
		new_action.Grant(src)
	if(tier >= 2)
		var/datum/action/new_action = new /datum/action/cooldown/spell/conjure_item/psyonic/psitool(src.mind || src, tier, additional_school)
		new_action.Grant(src)
		var/datum/action/new_action2 = new /datum/action/cooldown/spell/touch/psyonic/psyonic_tinker(src.mind || src, tier, additional_school)
		new_action2.Grant(src)
	if(tier >= 3)
		var/datum/action/new_action = new /datum/action/cooldown/spell/touch/psyonic/psyonic_force(src.mind || src, tier, additional_school)
		new_action.Grant(src)
	if(tier >= 4)
		var/datum/action/new_action = new /datum/action/cooldown/spell/psyonic/psionic_telekinesis(src.mind || src, tier, additional_school)
		new_action.Grant(src)

// Spawns a lighter, so handy
/datum/action/cooldown/spell/conjure_item/psyonic/psilighter
	name = "Psy-lighter"
	desc = "Concentrates psyonic energy to create a small flame in your hand."
	button_icon = 'icons/obj/cigarettes.dmi'
	button_icon_state = "match_lit"
	cooldown_time = 1.5 SECONDS
	item_type = /obj/item/psyonic_fire
	mana_cost = 5
	stamina_cost = 0

// Spawns a psyblade in the caster's hand, damage scales with the psy level
/datum/action/cooldown/spell/conjure_item/psyonic/psiblade
	name = "Psy-blade"
	desc = "Concentrates psyonic energy to create a sharp blade in your hand."
	button_icon = 'icons/obj/weapons/transforming_energy.dmi'
	button_icon_state = "blade"
	cooldown_time = 1.5 SECONDS
	item_type = /obj/item/melee/psyonic_blade
	mana_cost = 40
	stamina_cost = 0

// Spawns an abductor omnitool analogue in the caster's hand
/datum/action/cooldown/spell/conjure_item/psyonic/psitool
	name = "Psy-tool"
	desc = "Concentrates psyonic energy to create a universal tool."
	button_icon = 'icons/obj/antags/abductor.dmi'
	button_icon_state = "omnitool"
	cooldown_time = 1.5 SECONDS
	item_type = /obj/item/psyonic_omnitool
	mana_cost = 30
	stamina_cost = 0

/datum/action/cooldown/spell/conjure_item/psyonic/psiblade/New(Target)
	. = ..()
	if(secondary_school == "Psychokinesis")
		cast_power += 1

/datum/action/cooldown/spell/conjure_item/psyonic/psiblade/make_item(atom/caster)
	var/obj/item/made_item = new item_type(caster.loc, cast_power)
	LAZYADD(item_refs, WEAKREF(made_item))
	var/mob/living/carbon/human/caster_pawn = owner
	caster_pawn.emote_snap()
	return made_item

// jaws of life analogue
/datum/action/cooldown/spell/touch/psyonic/psyonic_force
	name = "Prying Psyonic Force"
	desc = "Concentrates psyonic energy to force a door open."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "knock"
	cooldown_time = 3 SECONDS
	mana_cost = 50
	stamina_cost = 50
	hand_path = /obj/item/melee/touch_attack/psyonic_mending
	draw_message = span_notice("You ready your hand to force a door open.")
	drop_message = span_notice("You lower your hand.")
	can_cast_on_self = FALSE

/datum/action/cooldown/spell/touch/psyonic/psyonic_force/is_valid_target(atom/cast_on)
	return istype(cast_on, /obj/machinery/door/airlock)

/datum/action/cooldown/spell/touch/psyonic/psyonic_force/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/mendicant)
	if(isatom(victim))
		if(istype(victim, /obj/machinery/door/airlock))
			var/obj/machinery/door/airlock/door_to_force = victim
			owner.visible_message(span_warning("[owner] targets their hands at [victim], like they are some kind of jedi."),
								span_notice("You psyonically grab [victim], trying to force it open."))
			if(do_after(mendicant, 5 SECONDS, victim, IGNORE_SLOWDOWNS, TRUE))
				force_door_open(door_to_force, mendicant)
				drain_mana()
			return TRUE
		else
			return FALSE
	else
		return FALSE

/datum/action/cooldown/spell/touch/psyonic/psyonic_force/proc/force_door_open(obj/machinery/door/airlock/door_to_force, mob/living/carbon/user)
	if(door_to_force.seal)
		to_chat(user, span_warning("Remove the seal first!"))
		return
	if(door_to_force.locked)
		to_chat(user, span_warning("The airlock's bolts prevent it from being forced!"))
		return
	if(door_to_force.welded)
		to_chat(user, span_warning("It's welded, it won't budge!"))
		return
	if(door_to_force.hasPower())
		if(!door_to_force.density)
			return
		if(!door_to_force.prying_so_hard)
			playsound(src, 'sound/machines/airlock/airlock_alien_prying.ogg', 100, TRUE)
			door_to_force.prying_so_hard = TRUE
			door_to_force.open(BYPASS_DOOR_CHECKS)
			door_to_force.take_damage(25, BRUTE, 0, 0)
			if(door_to_force.density && !door_to_force.open(BYPASS_DOOR_CHECKS))
				to_chat(user, span_warning("Despite your attempts, [src] refuses to open."))
			door_to_force.prying_so_hard = FALSE
			return

// Grants the telekinsesis mutation
/datum/action/cooldown/spell/psyonic/psionic_telekinesis
	name = "Telekinesis"
	desc = "Force yourself to recieve telekinesis mutation."
	cooldown_time = 60 SECONDS
	mana_cost = 80
	stamina_cost = 80

/datum/action/cooldown/spell/psyonic/psionic_telekinesis/is_valid_target(atom/cast_on)
	return !issynthetic(cast_on)

/datum/action/cooldown/spell/psyonic/psionic_telekinesis/cast(mob/living/cast_on)
	. = ..()
	if(!ishuman(cast_on))
		return FALSE
	var/mob/living/carbon/human/to_mutate = cast_on
	if(!to_mutate.can_mutate())
		return FALSE
	to_mutate.dna.add_mutation(/datum/mutation/telekinesis, MUTATION_SOURCE_MUTATOR)
	drain_mana()

// Restores atom's Integrity. Allows to restore things that would otherwise normally not be able to get fixed
/datum/action/cooldown/spell/touch/psyonic/psyonic_tinker
	name = "Psyonic Tinker"
	desc = "Restore somethings condition to its normal state."
	button_icon = 'icons/obj/tools.dmi'
	button_icon_state = "wrench"
	cooldown_time = 3 SECONDS
	mana_cost = 40
	stamina_cost = 50
	hand_path = /obj/item/melee/touch_attack/psyonic_mending
	draw_message = span_notice("You ready your hand to tinker.")
	drop_message = span_notice("You lower your hand.")
	can_cast_on_self = FALSE

/datum/action/cooldown/spell/touch/psyonic/psyonic_tinker/is_valid_target(atom/cast_on)
	return cast_on.uses_integrity

/datum/action/cooldown/spell/touch/psyonic/psyonic_tinker/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/mendicant)
	if(isatom(victim))
		var/atom/to_fix = victim
		if((to_fix.get_integrity() >= to_fix.max_integrity) || !to_fix.uses_integrity)
			return FALSE
		owner.visible_message(span_warning("[owner] presses their hands onto [victim]."),
							  span_notice("You grab [victim], trying to repair it."))
		if(do_after(mendicant, 6 SECONDS, victim, IGNORE_SLOWDOWNS, TRUE))
			to_fix.update_integrity(clamp(to_fix.get_integrity()+(50*cast_power), 1, to_fix.max_integrity))
			drain_mana()
		return TRUE
	else
		return FALSE

/obj/item/melee/psyonic_blade
	name = "psyonic blade"
	desc = "A concentrated collection of particles and energy that looks like a swords blade.."
	icon = 'icons/obj/weapons/transforming_energy.dmi'
	icon_state = "blade"
	inhand_icon_state = "blade"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	force = 10
	throwforce = 10
	hitsound = 'sound/items/weapons/blade1.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	sharpness = SHARP_EDGED
	block_chance = 0
	item_flags = DROPDEL | ABSTRACT | HAND_ITEM
	color = COLOR_BRIGHT_BLUE

/obj/item/melee/psyonic_blade/New(loc, power)
	. = ..()
	force = 10 + power*1.5
	block_chance = power*5

/obj/item/psyonic_fire
	name = "small psyonic fire"
	desc = "Small bluish fire, that jumps on your fingers and surprisigly doesn't burn them."
	icon = 'icons/obj/weapons/hand.dmi'
	icon_state = "greyscale"
	color = COLOR_BRIGHT_BLUE
	inhand_icon_state = "greyscale"
	light_range = 2
	light_power = 2
	light_color = LIGHT_COLOR_LIGHT_CYAN
	light_on = TRUE
	damtype = BURN
	force = 5
	attack_verb_continuous = list("burns", "singes")
	attack_verb_simple = list("burn", "singe")
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_HUGE
	light_system = OVERLAY_LIGHT
	toolspeed = 2
	tool_behaviour = TOOL_WELDER
	item_flags = DROPDEL | ABSTRACT | HAND_ITEM
	heat = HIGH_TEMPERATURE_REQUIRED - 100

// Copy of the abductor one
/obj/item/psyonic_omnitool
	name = "psyonic omnitool"
	desc = "Space Swiss Army Knife, able to shapeshift itself to fulfill psyonics needs."
	icon = 'icons/obj/antags/abductor.dmi'
	lefthand_file = 'icons/mob/inhands/antag/abductor_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/abductor_righthand.dmi'
	icon_state = "omnitool"
	inhand_icon_state = "silencer"
	toolspeed = 1
	tool_behaviour = TOOL_SCREWDRIVER
	color = COLOR_BRIGHT_BLUE
	usesound = 'sound/items/pshoom/pshoom.ogg'
	var/list/tool_list = list()
	item_flags = DROPDEL | ABSTRACT | HAND_ITEM

/obj/item/psyonic_omnitool/New(loc)
	. = ..()
	tool_list = list(
			"Crowbar" = image(icon = 'icons/obj/tools.dmi', icon_state = "crowbar"),
			"Multitool" = image(icon = 'icons/obj/devices/tool.dmi', icon_state = "multitool"),
			"Screwdriver" = image(icon = 'icons/obj/tools.dmi', icon_state = "screwdriver_map"),
			"Wirecutters" = image(icon = 'icons/obj/tools.dmi', icon_state = "cutters_map"),
			"Wrench" = image(icon = 'icons/obj/tools.dmi', icon_state = "wrench"),
		)

/obj/item/psyonic_omnitool/get_all_tool_behaviours()
	return list(
	TOOL_CROWBAR,
	TOOL_MULTITOOL,
	TOOL_SCREWDRIVER,
	TOOL_WIRECUTTER,
	TOOL_WRENCH,
	)

/obj/item/psyonic_omnitool/examine()
	. = ..()
	. += " The mode is: [tool_behaviour]"

/obj/item/psyonic_omnitool/attack_self(mob/user)
	if(!user)
		return

	var/tool_result = show_radial_menu(user, src, tool_list, custom_check = CALLBACK(src, PROC_REF(check_menu), user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user))
		return
	switch(tool_result)
		if("Crowbar")
			tool_behaviour = TOOL_CROWBAR
		if("Multitool")
			tool_behaviour = TOOL_MULTITOOL
		if("Screwdriver")
			tool_behaviour = TOOL_SCREWDRIVER
		if("Wirecutters")
			tool_behaviour = TOOL_WIRECUTTER
		if("Wrench")
			tool_behaviour = TOOL_WRENCH

/obj/item/psyonic_omnitool/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated || !user.Adjacent(src))
		return FALSE
	return TRUE

