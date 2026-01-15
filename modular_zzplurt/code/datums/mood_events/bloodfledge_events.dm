// Bloodfledge quirk mood events

//
// Events for drinking blood
//

/// Base event for Bloodfledge drinking blood
/datum/mood_event/bloodfledge/drankblood
	mood_change = -4
	timeout = 5 MINUTES

/// Matching exotic blood
/datum/mood_event/bloodfledge/drankblood/exotic_matched
	description = "I tasted familiarity from the blood I drank."
	mood_change = 2

/// Insect blood - Currently unused
/datum/mood_event/bloodfledge/drankblood/insect
	description = "I drank an insect's hemolymph."

/// Vampire and Hemophage blood
/datum/mood_event/bloodfledge/drankblood/vampire
	description = "I drank the forbidden blood of a true sanguine."

/// Ethreal blood
/datum/mood_event/bloodfledge/drankblood/ethereal
	description = "I drank the liquid electricity of an ethereal."

/// Synthetic blood
/datum/mood_event/bloodfledge/drankblood/synth
	description = "I tried to drink oil from a synth..."

/// Slime blood
/datum/mood_event/bloodfledge/drankblood/slime
	description = "I drank the toxic jelly of a slime."
	mood_change = -6

/// Podperson blood
/datum/mood_event/bloodfledge/drankblood/podperson
	description = "I drank... water?"
	mood_change = 0

/// Snail blood
/datum/mood_event/bloodfledge/drankblood/snail
	description = "I tried to drink space lube..."

/// Skrell blood
/datum/mood_event/bloodfledge/drankblood/skrell
	description = "I tried to drink liquid copper."

/// Xenomorph Hybrid blood
/datum/mood_event/bloodfledge/drankblood/xeno
	description = "I drank sulfuric acid from a xeno."
	mood_change = -6

/// Dead creature
/datum/mood_event/bloodfledge/drankblood/dead
	description = "I drank dead blood. I am better than this."
	mood_change = -8
	timeout = 10 MINUTES

/// Killed from feeding
/datum/mood_event/bloodfledge/drankblood/killed
	description = "I drank from my victim until they died. I feel...lesser."
	mood_change = -12
	timeout = 25 MINUTES

/// Cursed blood matched
/datum/mood_event/bloodfledge/drankblood/cursed_good
	description = "I've tasted sympathy from a fellow curse bearer."
	mood_change = 1

/// Cursed blood non-matched
/datum/mood_event/bloodfledge/drankblood/cursed_bad
	description = "I can feel a pale curse from the blood I drank."
	mood_change = -1

/// Drinking own blood
/datum/mood_event/bloodfledge/drankblood/blood_self
	description = "I drink my own blood. Why would I do that?"

/// Drinking fake blood (no DNA)
/datum/mood_event/bloodfledge/drankblood/blood_fake
	description = "I drink artifical blood. I should know better."

/// Bite was interrupted
/datum/mood_event/bloodfledge/drankblood/bite_failed
	description = "I lost control while feeding and hurt my target."

/// Bite was interrupted, evil edition
/datum/mood_event/bloodfledge/drankblood/bite_failed/evil
	description = "I lost precious blood from my victim's incompetence."

//
// Events for desperation system
//

/// Mood penalty for desperation
/datum/mood_event/bloodfledge/blood_craving
	description = span_warning("The sanguine thirst calls to me. I need blood!")
	mood_change = -4 // Half of D4C

/// Mood bonus for satisfying the desperation
/datum/mood_event/bloodfledge/blood_satisfied
	description = span_nicegreen("My sanguine urges have been sated for now.")
	mood_change = 2 // Half of D4C
	timeout = 2 MINUTES
