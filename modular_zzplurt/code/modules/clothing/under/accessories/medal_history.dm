/obj/item/clothing/accessory/medal
	/// A first award awaiting successful attachment; never a reference to either participant.
	var/datum/splurt_medal_entry/pending_medal_history

/// Keep the existing award behavior, but do not publish history until attach() actually succeeds.
/obj/item/clothing/accessory/medal/try_attach(obj/item/clothing/under/attach_to, mob/living/attacher)
	QDEL_NULL(pending_medal_history)
	var/was_awarded = awarded_to
	var/mob/living/distinguished = attach_to.loc
	. = ..()
	if(!. || was_awarded || !awarded_to || !istype(distinguished) || !attacher || distinguished == attacher)
		return .

	pending_medal_history = new(attacher, distinguished, name, commendation_message)
	// A player awarding another body belonging to the same account is still a self-award.
	if(pending_medal_history.giver_ckey && pending_medal_history.giver_ckey == pending_medal_history.recipient_ckey)
		QDEL_NULL(pending_medal_history)
	return .

/obj/item/clothing/accessory/medal/attach(obj/item/clothing/under/attached_to)
	. = ..()
	if(!pending_medal_history)
		return .

	if(loc == attached_to && (src in attached_to.attached_accessories))
		GLOB.splurt_medal_history.entries += pending_medal_history
		pending_medal_history = null
	else
		QDEL_NULL(pending_medal_history)
	return .

/obj/item/clothing/accessory/medal/Destroy()
	QDEL_NULL(pending_medal_history)
	return ..()

/// Prefer the current player; a disconnected or ghosted character retains its owner's mind key.
/proc/splurt_medal_owner(mob/living/person)
	if(!person)
		return null
	if(person.ckey)
		return person.ckey
	return ckey(person.mind?.key)

/// A round-local snapshot. Display names are never used to decide who may see this entry.
/datum/splurt_medal_entry
	var/giver_ckey
	var/recipient_ckey
	var/giver_name
	var/recipient_name
	var/medal_name
	var/reason

/datum/splurt_medal_entry/New(mob/living/giver, mob/living/recipient, medal_name, reason)
	. = ..()
	giver_ckey = splurt_medal_owner(giver)
	recipient_ckey = splurt_medal_owner(recipient)
	giver_name = giver.real_name
	recipient_name = recipient.real_name
	src.medal_name = medal_name
	src.reason = reason

/// Send only display text. React text children perform HTML escaping in the read-only TGUI.
/datum/splurt_medal_entry/proc/ui_record()
	return list(
		"medal" = medal_name,
		"giver" = giver_name,
		"recipient" = recipient_name,
		"reason" = reason,
	)
