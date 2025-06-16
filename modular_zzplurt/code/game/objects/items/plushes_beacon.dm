/obj/item/choice_beacon/box/plushie
	name = "Choice Box (plushie)"
	desc = "Using the power of quantum entanglement, this box contains every plush, until the moment it is opened!"
	icon = 'modular_zzplurt/icons/obj/toys/plushes.dmi'
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/misc/plushes_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/misc/plushes_right.dmi'
	icon_state = "box"
	inhand_icon_state = "box"

/obj/item/choice_beacon/box/plushie/generate_display_names()
	var/static/list/plushie_list = list()
	if(!length(plushie_list))
		//plushie set 1: just subtypes of /obj/item/toy/plush
		var/list/plushies_set_one = subtypesof(/obj/item/toy/plush)
		plushies_set_one = remove_bad_plushies(plushies_set_one)
		for(var/V in plushies_set_one)
			var/atom/A = V
			plushie_list[initial(A.name)] = A
	return plushie_list

/obj/item/choice_beacon/box/plushie/proc/remove_bad_plushies(list/plushies)
	plushies -= list(
		/obj/item/toy/plush/awakenedplushie,
		/obj/item/toy/plush/narplush,
		/obj/item/toy/plush/ratplush
		)
	return plushies

/obj/item/choice_beacon/box/plushie/spawn_option(choice,mob/living/M)
	if(ispath(choice, /obj/item/toy/plush))
		..() //regular plush, spawn it naturally

/obj/item/choice_beacon/box/plushie/deluxe
	name = "Deluxe choice box (plushie)"
	desc =  "Using the power of quantum entanglement, this box contains five times every plush, until the moment it is opened!"
	uses = 5

/obj/item/choice_beacon/box/plushie/deluxe/spawn_option(choice, mob/living/M)
	//I don't wanna recode two different procs just for it to do the same as doing this
	if(uses > 1)
		var/obj/item/choice_beacon/box/plushie/deluxe/replace = new
		replace.uses = uses - 1
		M.put_in_hands(replace)
	. = ..()
