/obj/item/food/donut/cum
	name = "Cum-glazed Donut"
	desc = "A freshly 'glazed' donut."
	icon = 'modular_zzplurt/icons/obj/food/donut.dmi'
	icon_state = "donut_cum"
	tastes = list("donut" = 1, "bitter" = 1, "salty" = 1)
	food_reagents = list(/datum/reagent/consumable/cum = 5)
	is_decorated = TRUE

/obj/item/food/donut/proc/in_box_sprite()
	return "donut_inbox"
