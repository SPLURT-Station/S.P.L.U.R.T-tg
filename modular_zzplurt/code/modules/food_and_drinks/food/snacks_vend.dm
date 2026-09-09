// Ported vending snacks from S.P.L.U.R.T-Station-13
/obj/item/food/jellybean
	name = "jelly bean"
	desc = "A rather large sized, colorful bean full of sugar."
	icon_state = "bean_template"
	icon = 'modular_zzplurt/icons/obj/food/food_splurt.dmi'
	bite_consumption = 4
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sugar = 3)
	junkiness = 25
	tastes = list("candy" = 1)
	foodtypes = JUNKFOOD | SUGAR
	/// Assoc list of flavor name to hex color the bean can randomly roll.
	var/list/possible_colors = list(
		"orange" = "#FF7B00",
		"black" = "#000000",
		"white" = "#FFFFFF",
		"yellow" = "#FFFF00",
		"purple" = "#822BFF",
		"green" = "#32CD32",
		"red" = "#FF0000",
		"blue" = "#0000FF",
		"capuccino" = "#663300",
		"plum" = "#00A2FF",
		"strawck" = "#ff88ff",
		"metallic" = "#454545",
		"crocin" = "#FF2BFF",
		"turd" = "#663300",
		"jizz" = "#FFFFFF",
		"margarita" = "#00aa00",
		"coconut" = "#CBB1CA",
		"raspberry" = "#7c1f1e",
		"blackberry" = "#3d1774",
		"cottonc" = "#D59998",
		"carmcorn" = "#FBFF23",
		"creamsoda" = "#b2b2b2",
		"watermelon" = "#008000",
		"chocop" = "#663300",
		"tutti" = "#FFFFFF",
		"scinnamon" = "#E4005B",
		"tmallow" = "#b2b2b2",
		)
	var/chosen_color

/obj/item/food/jellybean/Initialize(mapload)
	if(!chosen_color)
		chosen_color = pick(possible_colors)
		switch(chosen_color)
			if("orange")
				tastes = list("orange" = 1)
			if("white", "jizz")
				tastes = list("marshmallow" = 1)
			if("yellow")
				tastes = list(pick("lime", "pineapple", "banana") = 1)
			if("purple")
				tastes = list("grape" = 1)
			if("green", "margarita")
				tastes = list(pick("kiwi", "lemon") = 1)
			if("red")
				tastes = list(pick("apple", "cherry") = 1)
			if("capuccino")
				tastes = list("capuccino" = 1)
			if("crocin", "strawck")
				tastes = list("strawberry" = 1)
			if("turd", "chocop")
				tastes = list("chocolate" = 1)
			if("coconut")
				tastes = list("coconut" = 1)
			if("raspberry")
				tastes = list("raspberry" = 1)
			if("blackberry")
				tastes = list("blackberry" = 1)
			if("cottonc", "plum")
				tastes = list("cotton candy" = 1)
			if("carmcorn")
				tastes = list("corn" = 1)
			if("creamsoda")
				tastes = list("cream soda" = 1)
			if("watermelon")
				tastes = list("watermelon" = 1)
			if("tutti")
				tastes = list("fruits" = 1)
			if("scinnamon")
				tastes = list("cinnamon" = 1)
			if("tmallow")
				tastes = list("cinnamon" = 1, "marshmallow" = 1)
			else
				tastes = tastes
	. = ..()
	icon_state = replacetext(icon_state, "template", chosen_color)

/obj/item/food/jellybean/lewd
	desc = "A rather large sized, colorful bean full of sugar... or not...?"

/obj/item/food/jellybean/lewd/Initialize(mapload)
	if(!prob(50))
		return ..()

	chosen_color = pick(possible_colors)
	food_reagents = list(/datum/reagent/consumable/nutriment = 4)
	switch(chosen_color)
		if("white", "jizz", "tutti", "coconut")
			tastes = list("cum" = 1)
			food_reagents = list(/datum/reagent/consumable/nutriment = 1, pick(/datum/reagent/consumable/cum, /datum/reagent/consumable/femcum) = 3)
		if("black", "metallic", "creamsoda", "tmallow")
			tastes = list("dogborg balls" = 1)
			food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sodiumchloride = 3)
		if("orange", "yellow", "carmcorn")
			tastes = list(pick("piss", "smegma") = 1)
		if("purple", "blackberry")
			food_reagents = list(/datum/reagent/consumable/ethanol/lean = 4)
		if("green", "margarita", "watermelon")
			tastes = list(pick("sweat", "armpit", "feet") = 1)
			food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sodiumchloride = 3)
		if("red", "raspberry", "scinnamon")
			food_reagents = list(/datum/reagent/blood = 4)
		if("capuccino", "turd", "chocop")
			tastes = list(pick("shit", "shart", "fart") = 1)
		if("crocin", "strawck")
			food_reagents = list(/datum/reagent/drug/aphrodisiac/crocin/hexacrocin = 4)
		else
			tastes = list("musk" = 1)
			food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sodiumchloride = 3)
	. = ..()

/obj/item/storage/fancy/jellybean_bowl
	name = "jelly bean bowl"
	desc = "It says \"take three\""
	icon = 'modular_zzplurt/icons/obj/food/food_splurt.dmi'
	icon_state = "bowl_beans"
	base_icon_state = "bowl_beans"
	contents_tag = "jelly bean"
	spawn_type = /obj/item/food/jellybean
	storage_type = /datum/storage/jellybean_bowl

/obj/item/storage/fancy/jellybean_bowl/update_icon_state()
	. = ..()
	if(open_status)
		var/stage
		switch(contents.len)
			if(8 to 9)
				stage = 3
			if(4 to 7)
				stage = 2
			if(1 to 3)
				stage = 1
			if(0)
				stage = 0
			else
				stage = 4
		icon_state = "bowl_beans_[stage]"
	else
		icon_state = "bowl_beans"

/obj/item/storage/fancy/jellybean_bowl/Exited(atom/movable/gone, direction)
	. = ..()
	switch(contents.len)
		if(4 to 6)
			to_chat(usr, span_notice("You take another jelly bean. How disgusting..."))
		if(1 to 3)
			to_chat(usr, span_notice("You take another jelly bean. You feel like the scum of the earth."))
		if(0)
			to_chat(usr, span_notice("You took too much too fast. The jelly beans spill onto the floor."))
		else
			to_chat(usr, span_notice("You take a jelly bean from the bowl."))

/obj/item/storage/fancy/jellybean_bowl/examine(mob/user)
	. = ..()
	if(contents.len <= 0)
		. += "Look at what you've done."

/datum/storage/jellybean_bowl
	max_slots = 10
	rustle_sound = null

/datum/storage/jellybean_bowl/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	set_holdable(list(/obj/item/food/jellybean))

/obj/item/storage/fancy/jellybean_pack
	name = "Mystery Beans"
	desc = "A pack full of jelly beans! It says there's a 50/50 chance of finding candy or... something else."
	icon = 'modular_zzplurt/icons/obj/food/food_splurt.dmi'
	icon_state = "bean_bag"
	base_icon_state = "bean_bag"
	contents_tag = "jelly bean"
	spawn_type = /obj/item/food/jellybean/lewd
	storage_type = /datum/storage/jellybean_pack

/obj/item/storage/fancy/jellybean_pack/update_icon_state()
	. = ..()
	if(open_status)
		icon_state = "bean_bagopen"
	else
		icon_state = "bean_bag"

/datum/storage/jellybean_pack
	max_slots = 27
	rustle_sound = null

/datum/storage/jellybean_pack/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	set_holdable(list(/obj/item/food/jellybean/lewd))
