/obj/item/choice_beacon/blueshield
	name = "Nanotrasen bodyguard gunset beacon"
	desc = "A single use beacon to deliver a gunset of your choice. Please only call this in your office."
	icon_state = "self_delivery"
	company_source = "Nanotrasen Corporation"
	company_message = span_bold("Understood, Guardsman. Supply pod incoming with your request, please stand by and avoid the drop zone.")

/obj/item/choice_beacon/blueshield/generate_display_names()
	var/static/list/selectable_gun_types = list(
		"NT-EG \"Defender\" Energy Rifle" = /obj/item/gun/energy/e_gun/stun/blueshield/balanced,
		"NT-SR4 \"Aegis\" Energy Revolver" = /obj/item/gun/energy/e_gun/blueshield/balanced,
		"M45A5 \"Goliath\" Heavy Service Pistol" = /obj/item/storage/toolbox/guncase/skyrat/pistol/m45a5
	)

	return selectable_gun_types
