/datum/station_trait/announcement_intern
	name = "Announcement rat"
	report_message = "Don't forget to bring cheese!"

/datum/station_trait/announcement_intern/New()
	. = ..()
	SSstation.announcer = /datum/centcom_announcer/intern/tibbets // it shouldn't cause any issues, right?
