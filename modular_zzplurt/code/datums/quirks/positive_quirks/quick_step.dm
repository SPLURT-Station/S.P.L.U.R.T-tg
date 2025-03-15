/datum/quirk/quick_step
	name = "Quick Step"
	desc = "You walk with determined strides, and out-pace most people when walking."
	value = 2
	mob_trait = TRAIT_SPEEDY_STEP
	gain_text = span_notice("You feel determined. No time to lose.")
	lose_text = span_danger("You feel less determined. What's the rush, man?")
	medical_record_text = "Patient scored highly on racewalking tests."
	icon = FA_ICON_PERSON_RUNNING // ANOTHER FITTING QUIRK ICON???? WOW!!!!!!!!!!!!!!!!

/datum/quirk/quick_step/add(client/client_source)
	. = ..()
	quirk_holder.add_movespeed_modifier(/datum/movespeed_modifier/quick_step)

/datum/quirk/quick_step/remove()
	. = ..()
	quirk_holder.remove_movespeed_modifier(/datum/movespeed_modifier/quick_step)

/datum/movespeed_modifier/quick_step
	multiplicative_slowdown = -1.25
