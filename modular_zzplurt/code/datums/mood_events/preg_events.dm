/datum/mood_event/pregnant_labor
	description = span_boldwarning("THE BABY WANTS OUT!!!")
	mood_change = -7

/datum/mood_event/pregnant_relief
	description = span_nicegreen("My baby came out... Phew!")
	mood_change = 3
	timeout = 3 MINUTES

/datum/mood_event/pregnant_relief/egg
	description = span_nicegreen("My egg came out... Phew!")
