// Adicionando o novo quirk
/datum/quirk/powered_wheelchair
	name = "Motorized Mobility"
	desc = "You spawn with a powered wheelchair instead of a standard one."
	gain_text = "You feel ready to roll with power."
	lose_text = "You feel less mobile."
	value = 0 // Ajustar conforme balanceamento

/datum/quirk/powered_wheelchair/on_spawn(mob/living/carbon/human/H)
	var/obj/item/wheelchair/W = locate(/obj/item/wheelchair) in H.contents
	if(W)
		qdel(W)
		var/obj/item/wheelchair/powered/P = new /obj/item/wheelchair/powered(H)
		H.put_in_hands(P)
