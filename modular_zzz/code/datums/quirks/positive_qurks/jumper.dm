/datum/quirk/jumper
	name = "Jumper"
	desc = "You've dedicated your life to jumping, or you've been lucky enough to be born agile. Your jump ability increases slightly."
	icon = FA_ICON_FROG
	value = 6
	mob_trait = TRAIT_JUMPER
	gain_text = span_notice("You feel a surge of strength in your legs.")
	lose_text = span_danger("You felt a slight cramp in your leg.")
	medical_record_text = "The patient experiences some leg cramps."
	mail_goodies = list(/obj/item/reagent_containers/cup/soda_cans/grey_bull)

/datum/quirk/jumper/add(client/client_source)
	if(isdummy(quirk_holder))
		return
	. = ..()

/datum/quirk/jumper/remove()
	. = ..()



