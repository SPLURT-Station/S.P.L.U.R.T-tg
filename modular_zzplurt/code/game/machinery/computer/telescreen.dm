/obj/machinery/computer/security/telescreen/entertainment
	var/obj/item/radio/radio

/obj/machinery/computer/security/telescreen/entertainment/Initialize(mapload)
	. = ..()
	radio = new /obj/item/radio(src)
	radio.keyslot = new /obj/item/encryptionkey/broadcast_only
	radio.set_broadcasting(FALSE)
	radio.set_frequency(FREQ_BROADCAST)
	if(!network.len)
		radio.set_listening(FALSE)
	radio.recalculateChannels()

/obj/machinery/computer/security/telescreen/entertainment/Destroy()
	if(radio)
		QDEL_NULL(radio)
	return ..()

/obj/machinery/computer/security/telescreen/entertainment/on_network_broadcast_updated(datum/source, tv_show_id, is_show_active, announcement)
	. = ..()
	if(!network.len || !is_show_active)
		radio.set_listening(FALSE)
	else if(is_show_active)
		radio.set_listening(TRUE)
