//////////////////////////////////////
///////ENTHRAL VELVET CHORDS//////////
//////////////////////////////////////

//Heavily modified voice of god code
/obj/item/organ/vocal_cords/velvet
	name = "Velvet chords"
	desc = "The voice spoken from these just make you want to drift off, sleep and obey."
	icon = 'modular_zubbers/icons/obj/vocal_cords.dmi'
	icon_state = "velvet_chords"
	actions_types = list(/datum/action/item_action/organ_action/velvet)
	spans = list("velvet")

/datum/action/item_action/organ_action/velvet
	name = "Velvet chords"
	var/obj/item/organ/vocal_cords/velvet/cords = null

/datum/action/item_action/organ_action/velvet/New()
	..()
	cords = target

/datum/action/item_action/organ_action/velvet/IsAvailable(feedback = TRUE)
	return TRUE

/datum/action/item_action/organ_action/velvet/Trigger(trigger_flags)
	. = ..()
	var/command = input(owner, "Speak in a sultry tone", "Command")
	if(QDELETED(src) || QDELETED(owner))
		return
	if(!command)
		return
	owner.say(".x[command]")

/obj/item/organ/vocal_cords/velvet/can_speak_with()
	return TRUE

/obj/item/organ/vocal_cords/velvet/handle_speech(message) //actually say the message
	owner.say(message, spans = spans, sanitize = FALSE)
	velvetspeech(message, owner, 1)

//////////////////////////////////////
///////////FermiChem//////////////////
//////////////////////////////////////
//Removed span_list from input arguments.
/proc/velvetspeech(message, mob/living/user, base_multiplier = 1, message_admins = FALSE, debug = FALSE)
	//SPLURT: centralize command handling so Mk.2 chips use modular commands and originals keep their flow.
	return mkultra_handle_base_commands(message, user, base_multiplier, message_admins, debug)

