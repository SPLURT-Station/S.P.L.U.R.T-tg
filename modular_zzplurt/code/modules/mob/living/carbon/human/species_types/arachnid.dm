/datum/species/arachnid
	name = "Arachnid"
	id = SPECIES_ARACHNID
	inherent_traits = list(
		TRAIT_NO_UNDERWEAR,
		TRAIT_WEB_SURFER,
		TRAIT_WEB_WEAVER,
	)
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/arachnid,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/arachnid,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/arachnid,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/arachnid,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/arachnid,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/arachnid
	)
	mutanteyes = /obj/item/organ/eyes/night_vision/arachnid
	mutanttongue = /obj/item/organ/tongue/arachnid
	changesource_flags = MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | WABBAJACK | MIRROR_BADMIN | SLIME_EXTRACT

	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	mutant_organs = list(
		/obj/item/organ/mandibles = "Plain",
		/obj/item/organ/spinneret = "Plain",
		/obj/item/organ/arachnid_legs = "Plain",
	)
	meat = /obj/item/food/meat/slab/spider
	species_language_holder = /datum/language_holder/arachnid

//this took WAYYYY too long to find
//i hate this place
/datum/species/arachnid/get_default_mutant_bodyparts()
	return list(
		"mandibles" = list("Plain", TRUE),
		"spinneret" = list("Plain", TRUE),
		"arachnid_legs" = list("Plain", TRUE),
	)

/datum/species/arachnid/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	RegisterSignal(human_who_gained_species, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, PROC_REF(damage_weakness))

/datum/species/arachnid/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(human, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS)

/datum/species/arachnid/proc/damage_weakness(datum/source, list/damage_mods, damage_amount, damagetype, def_zone, sharpness, attack_direction, obj/item/attacking_item)
	SIGNAL_HANDLER

	if(istype(attacking_item, /obj/item/melee/flyswatter))
		damage_mods += 10 // 10x damage modifier, little less than flypeople

/datum/species/arachnid/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons = TRUE)
	. = ..()
	var/datum/action/innate/arachnid/spin_web/spin_web = new
	var/datum/action/innate/arachnid/spin_cocoon/spin_cocoon = new
	spin_web.Grant(human_who_gained_species)
	spin_cocoon.Grant(human_who_gained_species)

/datum/species/arachnid/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	. = ..()
	var/datum/action/innate/arachnid/spin_web/spin_web = locate() in human.actions
	var/datum/action/innate/arachnid/spin_cocoon/spin_cocoon = locate() in human.actions
	spin_web?.Remove(human)
	spin_cocoon?.Remove(human)


#define WEB_SPIN_NUTRITION_LOSS 25
#define COCOON_NUTRITION_LOSS 100

/datum/action/innate/arachnid
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_INCAPACITATED|AB_CHECK_CONSCIOUS
	button_icon = 'icons/mob/actions/actions_animal.dmi'

/datum/action/innate/arachnid/IsAvailable(feedback)
	. = ..()
	if(!.)
		return

	if(owner.has_status_effect(/datum/status_effect/web_cooldown))
		if(feedback)
			to_chat(owner, span_warning("You need to wait a while to regenerate web fluid."))
		return FALSE


/datum/action/innate/arachnid/spin_web
	name = "Spin Web"
	button_icon_state = "spider_web"

/datum/action/innate/arachnid/spin_web/Activate()
	if(DOING_INTERACTION(owner, SPECIES_ARACHNID))
		return FALSE

	if(owner.nutrition < WEB_SPIN_NUTRITION_LOSS)
		to_chat(owner, span_warning("You're too hungry to spin web right now, eat something first!"))
		return FALSE

	var/turf/target_turf = get_turf(owner)
	if(!target_turf)
		to_chat(owner, span_warning("There's no room to spin your web here!"))
		return FALSE

	if(locate(/obj/structure/spider/stickyweb) in target_turf)
		to_chat(owner, span_warning("There's already a web here!"))
		return FALSE

	// Should have some minimum amount of food before trying to activate
	to_chat(owner, "<i>You begin spinning some web...</i>")
	if(!do_after(owner, 10 SECONDS, target_turf, interaction_key = SPECIES_ARACHNID))
		to_chat(owner, span_warning("Your web spinning was interrupted!"))
		return FALSE

	if(!IsAvailable(TRUE))
		return FALSE

	owner.adjust_nutrition(-WEB_SPIN_NUTRITION_LOSS)
	owner:apply_status_effect(/datum/status_effect/web_cooldown)
	to_chat(owner, "<i>You use up a fair amount of energy weaving a web on the ground with your spinneret!</i>")
	new /obj/structure/spider/stickyweb(target_turf, owner)
	return TRUE


/datum/action/innate/arachnid/spin_cocoon
	name = "Spin Cocoon"
	button_icon_state = "wrap_0"
	enable_text = "You pull out a strand from your spinneret, ready to wrap a target.."
	disable_text = "You discard the strand."
	click_action = TRUE

/datum/action/innate/arachnid/spin_cocoon/set_ranged_ability(mob/living/on_who, text_to_show)
	if(owner.nutrition < COCOON_NUTRITION_LOSS)
		to_chat(owner, span_warning("You're too hungry to spin web right now, eat something first!"))
		return FALSE

	owner.adjust_nutrition(-COCOON_NUTRITION_LOSS * 0.25)
	return ..()

/datum/action/innate/arachnid/spin_cocoon/do_ability(mob/living/clicker, atom/movable/clicked_on)
	if(!clicker.Adjacent(clicked_on) || !istype(clicked_on) || DOING_INTERACTION(clicker, SPECIES_ARACHNID))
		return FALSE

	. = TRUE
	var/static/list/blacklisted_types
	blacklisted_types ||= typecacheof(list(
		/obj/effect, //no
		/obj/structure/spider, //mmm double dips
		/atom/movable/screen //???
	))
	if(is_type_in_typecache(clicked_on, blacklisted_types))
		to_chat(clicker, span_warning("You cannot wrap this!"))
		return FALSE

	if(!isliving(clicked_on) && clicked_on.anchored)
		to_chat(clicker, span_warning("[clicked_on] is bolted to the floor!"))
		return FALSE

	if(clicked_on == clicker)
		clicker.visible_message(
			span_danger("[clicker] starts to wrap themselves into a cocoon!"),
			span_danger("You start to wrap yourself into a cocoon!")
		)
	else
		clicker.visible_message(
			span_danger("[clicker] starts to wrap [clicked_on] into a cocoon!"),
			span_warning("You start to wrap [clicked_on] into a cocoon.")
		)

	clicker.apply_status_effect(/datum/status_effect/web_cooldown)
	if(!do_after(clicker, 10 SECONDS, clicked_on, interaction_key = SPECIES_ARACHNID))
		to_chat(clicker, span_warning("Your web spinning was interrupted!"))
		return FALSE

	clicker.adjust_nutrition(-COCOON_NUTRITION_LOSS * 0.75)
	clicker.apply_status_effect(/datum/status_effect/web_cooldown)
	var/obj/structure/spider/cocoon/casing = new(clicked_on.loc)

	clicked_on.forceMove(casing)
	if(clicked_on.density || ismob(clicked_on))
		if(clicked_on == clicker)
			clicker.visible_message(span_danger("[clicker] wraps themselves into a large cocoon!"))
		else
			clicker.visible_message(span_danger("[clicker] wraps [clicked_on] into a large cocoon!"))
		casing.icon_state = pick("cocoon_large1", "cocoon_large2", "cocoon_large3")
	else
		clicker.visible_message(span_danger("[clicker] wraps [clicked_on] into a cocoon!"))


/datum/status_effect/web_cooldown
	id = "web_cooldown"
	duration = 20 SECONDS
	alert_type = null
	remove_on_fullheal = TRUE

#undef WEB_SPIN_NUTRITION_LOSS
