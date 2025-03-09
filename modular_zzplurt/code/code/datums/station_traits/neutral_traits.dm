/datum/station_trait/announcement_intern
	name = "Announcement rat"
	report_message = "Don't forget to bring cheese!"

/datum/station_trait/announcement_intern/New()
	blacklist += list(/datum/station_trait/announcement_dagoth)
	. = ..()
	SSstation.announcer = /datum/centcom_announcer/intern/tibbets // it shouldn't cause any issues, right?

/datum/station_trait/announcement_medbot/New()
	blacklist += list(/datum/station_trait/announcement_dagoth)
	. = ..()

/datum/station_trait/announcement_dagoth
	name = "Announcement Sixth House"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 1
	show_in_report = TRUE
	report_message = "Come Nerevar, friend or traitor, come. Come and look upon the Heart, and Akulakhan."
	blacklist = list(/datum/station_trait/announcement_intern, /datum/station_trait/announcement_medbot, /datum/station_trait/birthday)

/datum/station_trait/announcement_dagoth/New()
	. = ..()
	SSstation.announcer = /datum/centcom_announcer/dagoth_ur
