/datum/action/cooldown/spell/conjure/flare
	name = "Summon Light Source"
	desc = "This spell creates a green flare."

	button_icon = 'modular_skyrat/modules/modular_weapons/icons/obj/company_and_or_faction_based/saibasan/projectiles.dmi'
	button_icon_state = "flare_burn-on"

	cooldown_time = 10 SECONDS
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	sound = 'sound/items/match_strike.ogg'
	summon_radius = 0
	summon_type = list(/obj/item/flashlight/flare/plasma_projectile)

/datum/action/cooldown/spell/death_loop
	name = "Death Loop"
	desc = "Makes the caster unable to die unwillingly via a forced memory leak delaying the death state assignation."

	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "bci_plus"
	sound = 'sound/effects/magic/staff_healing.ogg'
	cooldown_time = 10 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC|SPELL_REQUIRES_HUMAN

	invocation = "NullReferenceException: Object reference not set to an instance of an object at Necrosis.Start."
	invocation_type = INVOCATION_SHOUT

/datum/action/cooldown/spell/death_loop/is_valid_target(atom/cast_on)
	return isliving(cast_on)

/datum/action/cooldown/spell/death_loop/cast(mob/living/cast_on)
	. = ..()
	cast_on.visible_message(
		span_warning("Faintest glitches and binary code lines briefly cover [cast_on]!"),
		span_notice("You memory hack your digital mortality!"),
	)
	ADD_TRAIT(cast_on, TRAIT_NODEATH, REF(src))
	ADD_TRAIT(cast_on, TRAIT_SUCCUMB_OVERRIDE, REF(src))
	Remove(cast_on)

/datum/action/cooldown/spell/shapeshift/juggernaut
	name = "Juggernaut Form"
	desc = "Take on the form of a holy juggernaut."
	invocation = "KILL!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE

	possible_shapes = list(/mob/living/basic/construct/juggernaut/angelic/bitrunning)

/datum/action/cooldown/spell/shapeshift/wraith
	name = "Wraith Form"
	desc = "Take on the form of a holy wraith."
	invocation = "KILL!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE

	possible_shapes = list(/mob/living/basic/construct/wraith/angelic/bitrunning)

/datum/action/cooldown/spell/shapeshift/minor_illusion
	name = "Minor Illusion"
	desc = "Assume the form of a tree, a furniture or a plant, perfect for hiding."
	button_icon = 'icons/obj/fluff/beach.dmi'
	button_icon_state = "coconuts"
	invocation = "covers themselves in sticks and leaves."
	invocation_self_message = span_notice("You cover yourself in sticks and leaves.")
	invocation_type = INVOCATION_EMOTE
	spell_requirements = NONE
	sound = 'sound/effects/treechop/treechop1.ogg'

	possible_shapes = list(/mob/living/basic/tree/palm, /mob/living/basic/mimic/crate/minor_illusion, /mob/living/basic/mimic/watermelon)

/datum/action/cooldown/spell/shapeshift/minor_illusion/before_cast(atom/cast_on)
	. = ..()
	invocation = span_notice("<b>[cast_on]</b> covers themselves in sticks and leaves.")

/datum/action/cooldown/spell/conjure_item/fire
	name = "Produce Flame"
	desc = "Concentrates pyrokinetic forces to create a small fire, useful for lighting cigarettes or to spice up your punches, you guess."
	button_icon_state = "fireball0"
	cooldown_time = 5 SECONDS
	invocation = "lights a piece of fleece on fire."
	invocation_self_message = span_notice("You light a piece of fleece on fire.")
	invocation_type = INVOCATION_EMOTE
	spell_requirements = NONE
	sound = 'sound/items/match_strike.ogg'
	item_type = /obj/item/flashlight/flare/fire
	delete_old = FALSE
	delete_on_failure = TRUE

/datum/action/cooldown/spell/conjure_item/fire/before_cast(atom/cast_on)
	. = ..()
	invocation = span_notice("<b>[cast_on]</b> lights a piece of fleece on fire.")

/datum/action/cooldown/spell/conjure_item/water
	name = "Produce Water"
	desc = "Concentrates hydrokinetic forces to create a glass of water. Might help if you're parched."
	button_icon = 'icons/obj/drinks/drinks.dmi'
	button_icon_state = "water"
	cooldown_time = 5 SECONDS
	invocation = "gathers some ambient moisture."
	invocation_self_message = span_notice("You gather some ambient moisure.")
	invocation_type = INVOCATION_EMOTE
	spell_requirements = NONE
	sound = 'sound/effects/bubbles/bubbles.ogg'
	item_type = /obj/item/reagent_containers/cup/glass/drinkingglass/filled/half_full
	delete_old = FALSE
	delete_on_failure = FALSE

/datum/action/cooldown/spell/conjure_item/water/before_cast(atom/cast_on)
	. = ..()
	invocation = span_notice("<b>[cast_on]</b> gathers some ambient moisture.")

/obj/item/flashlight/flare/fire
	name = "cold fire"
	desc = "A flickering, room-temperature fire covered in a thin film of magic. Said film is known to rupture when items are pressed hard enough against it, or upon hard impacts; \
	setting things ablaze. Has a tendency to run out of fuel in around ten seconds."
	start_on = FALSE
	fuel = 12 SECONDS
	randomize_fuel = FALSE
	trash_type = /obj/item/stack/ore/glass/basalt
	light_range = 4
	icon = 'modular_zzplurt/icons/action/flare.dmi'
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/misc/flare_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/misc/flare_righthand.dmi'
	icon_state = "fire"
	inhand_icon_state = "fire"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = null
	trash_type = null

/obj/item/flashlight/flare/fire/Initialize(mapload)
	. = ..()
	if(randomize_fuel)
		fuel = rand(12 SECONDS, 20 SECONDS)
	ignition()

/obj/item/flashlight/flare/fire/turn_off()
	. = ..()
	qdel(src)

/obj/item/flashlight/flare/fire/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!.) //if we're not being caught
		ignite(hit_atom)

/obj/item/flashlight/flare/fire/proc/ignite(atom/movable/hit_atom)
	if(isliving(loc)) //someone caught us!
		return
	if(ishuman(hit_atom))
		var/mob/living/carbon/human/living_target_getting_hit = hit_atom
		living_target_getting_hit.visible_message(span_warning("[living_target_getting_hit] is set ablaze!"), span_userdanger("You've been set ablaze!"))
		living_target_getting_hit.adjust_fire_stacks(2)
		living_target_getting_hit.ignite_mob()
		playsound(living_target_getting_hit, SFX_SEAR, 50, TRUE)
	qdel(src)
