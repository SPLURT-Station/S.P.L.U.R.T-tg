// Ported from S.P.L.U.R.T-Station-13 (sealed export bottles and the mini beer keg)
/obj/item/export/bottle
	name = "sealed bottle"
	desc = "A sealed bottle of alcohol, ready to be exported"
	icon = 'modular_zzplurt/icons/obj/drinks/drinks_oldbase.dmi'
	force = 0
	throwforce = 0
	throw_speed = 0
	throw_range = 0
	w_class = WEIGHT_CLASS_TINY
	attack_verb = list("boop", "thunked", "shown")

/obj/item/export/bottle/attack_self(mob/user)
	to_chat(user, span_danger("The seal seems fine. Best to not open it."))

/obj/item/export/bottle/minikeg
	name = "Mini-Beer Keg"
	icon_state = "keggy"
	desc = "A small wooden barrle with metal rings, untapped beer inside."

/datum/export/booze/bottledkeg
	cost = 250
	unit_name = "exotic brews"
	export_types = list(/obj/item/export/bottle/minikeg) //Its just beer
