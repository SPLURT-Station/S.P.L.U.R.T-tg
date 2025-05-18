/obj/structure/closet/crate/mail
	packable = TRUE
	packing_icon_state = "mailpacking"

/obj/structure/closet/crate/mail/populate(amount)
	if(!packing_overlay && packable)
		get_packed()
	return ..()
