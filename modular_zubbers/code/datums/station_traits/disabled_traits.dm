//Causes all lights on the station to be busted.
//Extremely annoying, especially with a lack of a janitor. Also laggy when it happens.
/datum/station_trait/blackout
	weight = 0

//Randomizes the language for all bots AND machines.
//Very annoying considering this affects the arrivals announcement system as well as the cryo announcement system.
/datum/station_trait/bot_languages
	weight = 0

//We have proper sec borgs now, and this would interfere with them, and their code. Don't re-enable this unless you rework how we check for secborgs.
/datum/station_trait/hos_ai
	weight = 0
