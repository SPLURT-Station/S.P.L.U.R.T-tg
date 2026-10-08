//enchanted cutlass item for the galloway pirate ship ruin. I'm gonna over-explain some things for my memory and study alone

/obj/item/claymore/cutlass_enchanted
	name = "Mavarian Threat"
	desc = "A cutlass with a blackened blade and a hilt wrapped in red leather. The blade is engraved with runes that glow faintly in the dark."
	icon = 'modular_zzplurt/icons/obj/items_and_weapons.dmi'
	lefthand_file = 'modular_zzplurt/icons/obj/weapons/guns/inhands/right32x32.dmi'
	righthand_file = 'modular_zzplurt/icons/obj/weapons/guns/inhands/left32x32.dmi'
	icon_state = "enchanted_cutlass"
	inhand_icon_state = "enchanted_cutlass"
	worn_icon_state = "cutlass"
	slot_flags = ITEM_SLOT_BACK
	force = 15
	throwforce = 15
	throw_speed = 3
	throw_range = 5
	armour_penetration = 30

/datum/mood_event/enchant_hypnotized
	description = "That blade's touch was strangely compelling..."
	mood_change = 10
	timeout = 4 MINUTES

/obj/item/claymore/cutlass_enchanted/attack_secondary(mob/living/victim, mob/living/user, list/modifiers, list/attack_modifiers) // Checks to see if target is a mob and is alive
	if(!isliving(victim))
		return SECONDARY_ATTACK_CALL_NORMAL

	if(!victim.client?.prefs?.read_preference(/datum/preference/toggle/erp/hypnosis)) // Checks their hypno pref, if it's set to off, it fails!
		to_chat(user, span_notice("You attempt to caress [victim] with the enchanted cutlass, but they resist the hypnotic influence!"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	user.visible_message(span_notice("[user] begins to draw the blade close to [victim]...")) // prepping the action....

	if(!do_after(user, 3 SECONDS, target = victim, // Adds a 3 second action bar, if the move away the action fails
		extra_checks = CALLBACK(src, PROC_REF(still_adjacent), user, victim),
		interaction_key = "mavarian_hypnosis"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	apply_hypnotic_effect(user, victim) // Applies the effect, adds a mood event to the target, and sends messages to both parties
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/claymore/cutlass_enchanted/proc/still_adjacent(mob/living/user, mob/living/victim)
	return !QDELETED(user) && !QDELETED(victim) && Adjacent(user, victim) //cancels the effect if the user or target gets deleted for whatever reason lol

/obj/item/claymore/cutlass_enchanted/proc/apply_hypnotic_effect(mob/living/user, mob/living/victim) //the effect itself, only applies if the timer, pref, etc was met
	user.visible_message(span_warning("[user] caresses [victim] with the warm steel of their cutlass!"))
	to_chat(victim, span_hypnophrase(pick(list( //cool hypno phrases for the target to read
		"The warmth of the blackened steel washes over you, and you feel your will slipping away...",
		"The blade's enchantment whispers secrets of the deep, drawing you into its shadowy embrace...",
		"You feel a strange compulsion to obey as the cutlass's dark aura envelops you...",
		"The runes on the blade pulse with a hypnotic rhythm, clouding your thoughts and bending your will...",
	))))
	playsound(get_turf(user), 'sound/effects/magic/voidblink.ogg', 50, TRUE, 7) //plays a sound on successful effect
	to_chat(user, span_notice("You caress [victim] with the enchanted cutlass, hopefully weakening their resolve!")) // on success,  it sends a message to the user
	victim.add_mood_event("mavarian_hypnosis", /datum/mood_event/enchant_hypnotized) // the moodlet is added to the victim on success

/obj/item/claymore/cutlass_enchanted/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/cuffable_item) //closed sword guard
