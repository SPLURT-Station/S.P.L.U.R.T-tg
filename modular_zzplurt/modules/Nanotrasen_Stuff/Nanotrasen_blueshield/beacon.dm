/obj/item/choice_beacon/blueshield
	name = "Nanotrasen bodyguard gunset beacon"
	desc = "A single use beacon to deliver a gunset of your choice. Please only call this in your office"
	icon_state = "self_delivery"
	company_source = "Nanotrasen Corporation"
	company_message = span_bold("Understood, Guardsman. Supply pod incoming with your request, please stand by and avoid the drop zone.")

/obj/item/choice_beacon/blueshield/generate_display_names()
	var/static/list/selectable_gun_types = list(
		"Energy Revolver" = /obj/item/gun/energy/e_gun/blueshield,
		"Energy Carbine" = /obj/item/gun/energy/e_gun/stun/blueshield
	)

	return selectable_gun_types
