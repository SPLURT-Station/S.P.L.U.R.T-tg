/datum/quirk/trashcan
	name = "Trashcan"
	desc = "You are able to consume and digest trash."
	value = 0
	gain_text = span_notice("You feel like munching on a can of soda.")
	lose_text = span_notice("You no longer feel like you should be eating trash.")
	medical_record_text = "Patient has a strange craving for trash."
	mob_trait = TRAIT_TRASHCAN
	icon = FA_ICON_TRASH_ALT

/datum/quirk/trashcan/add(client/client_source)
	. = ..()
	var/mob/living/carbon/human/H = quirk_holder
	RegisterSignal(H, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))

/datum/quirk/trashcan/remove()
	. = ..()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		UnregisterSignal(H, COMSIG_ATOM_ATTACKBY)

/datum/quirk/trashcan/proc/on_attackby(datum/source, obj/item/I, mob/living/attacker, params)
	SIGNAL_HANDLER

	if(!istype(I, /obj/item/trash) && !istype(I, /obj/item/cigbutt))
		return

	var/mob/living/carbon/human/H = quirk_holder
	var/datum/component/vore/vore_component = H.GetComponent(/datum/component/vore)

	if(!vore_component)
		return

	H.visible_message(attacker == H ? span_notice("[H] starts to eat the [I.name].") : span_notice("[attacker] starts to feed [H] the [I.name].") )

	/* Might need to refractor it into the items themselves again
	if(!do_after(H, 1 SECONDS))
		return
	*/

	playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
	if(vore_component?.selected_belly)
		H.visible_message(span_notice("[H] [vore_component.selected_belly.insert_verb]s the [I.name] into their [vore_component.selected_belly.name]"),
			span_notice("You [vore_component.selected_belly.insert_verb] the [I.name] into your [vore_component.selected_belly.name]"))
	else
		H.visible_message(span_notice("[H] consumes the [I.name]."))

	qdel(I) // This is easier than adding snowflake code to vore stuff

	return COMPONENT_NO_AFTERATTACK


