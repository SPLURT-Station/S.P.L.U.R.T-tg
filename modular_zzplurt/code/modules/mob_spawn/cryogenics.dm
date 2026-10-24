//CRYO CONSOLES
/obj/machinery/computer/cryopod/centcom
	radio = /obj/item/radio/headset/headset_cent
	announcement_channel = RADIO_CHANNEL_CENTCOM
	req_one_access = list("cent_general")

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/computer/cryopod/centcom, 32)

/obj/machinery/computer/cryopod/syndicate
	radio = /obj/item/radio/headset/syndicate/alt
	announcement_channel = RADIO_CHANNEL_SYNDICATE
	req_one_access = list("syndicate")

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/computer/cryopod/syndicate, 32)
