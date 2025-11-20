/obj/item/clothing/gloves/ring/custom
	name = "ring"
	desc = "A ring."
	icon_state = "ringsilver"
	worn_icon_state = "sring"
	obj_flags = UNIQUE_RENAME

/obj/item/clothing/gloves/ring/reagent_clothing/rutt
	name = "r.u.t.t. ring"
	desc = "A tiny ring, sized to wrap around a finger. Imbued in r.u.t.t. by default."

/obj/item/clothing/gloves/ring/reagent_clothing/rutt/Initialize(mapload)
	. = ..()
	var/datum/component/reagent_clothing/reagent_clothing = GetComponent(/datum/component/reagent_clothing)
	if(!reagent_clothing)
		return

	reagent_clothing.imbued_reagent += /datum/reagent/drug/aphrodisiac/rutt
	color = mix_color_from_reagents(reagent_clothing.imbued_reagent)
