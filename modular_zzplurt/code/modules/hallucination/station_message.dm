/datum/hallucination/station_message/delta_alert

/datum/hallucination/station_message/delta_alert/start()
	priority_announce(
		sender_override = "Attention! Security level elevated to delta:",
		text = "Destruction of the station is imminent. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill.",
		sound = 'modular_skyrat/modules/alerts/sound/misc/alarm_delta.ogg',
		players = list(hallucinator),
		color_override = "pink",
		)
	return ..()

/datum/hallucination/station_message/gamma_alert

/datum/hallucination/station_message/gamma_alert/start()
	priority_announce(
		sender_override = "Attention! Security level elevated to gamma:",
		text = "The Terran Government has placed this system under Gamma Alert status. This galactic system is facing a ZK-Class Reality Failure Scenario. Security Personnel is authorized full access to lethal equipment to enforce Martial Law. Failure to follow emergency procedures is punishable by death. This is not a drill.",
		sound = 'modular_skyrat/modules/alerts/sound/security_levels/gamma_alert.ogg',
		players = list(hallucinator),
		color_override = "pink",
	)
	return ..()

/datum/hallucination/station_message/epsilon_alert

/datum/hallucination/station_message/epsilon_alert/start()
	priority_announce(
		sender_override = "Attention! Security level elevated to epsilon:",
		text = "Central Command has ordered the Epsilon security level on the station. Consider all contracts terminated.",
		sound = 'modular_skyrat/modules/alerts/sound/security_levels/epsilon.ogg',
		players = list(hallucinator),
		color_override = "grey",
	)
	return ..()
