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
	var/datum/component/reagent_imbued/clothing/reagent_clothing = GetComponent(/datum/component/reagent_imbued/clothing)
	if(!reagent_clothing)
		return

	var/datum/reagents/pre_imbue = new(reagent_clothing.imbued_reagent.maximum_volume, NO_REACT)
	pre_imbue.add_reagent(/datum/reagent/drug/aphrodisiac/rutt, pre_imbue.maximum_volume)
	reagent_clothing.set_reagent_imbue(pre_imbue)
	qdel(pre_imbue)
