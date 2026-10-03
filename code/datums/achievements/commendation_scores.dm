/// Player-facing lifetime counts for physical commendation medals received.
/datum/award/score/medals
	category = "Medals"
	track_high_scores = FALSE
	icon_state = "basemisc"

/datum/award/score/medals/standard
	name = "Standard Medals Received"
	desc = "Commendation medals received from other crew members."
	database_id = MEDAL_STANDARD_SCORE

/datum/award/score/medals/silver
	name = "Silver Medals Received"
	desc = "Silver commendation medals received from other crew members."
	database_id = MEDAL_SILVER_SCORE

/datum/award/score/medals/gold
	name = "Gold Medals Received"
	desc = "Gold commendation medals received from other crew members."
	database_id = MEDAL_GOLD_SCORE

/datum/award/score/medals/plasma
	name = "Plasma Medals Received"
	desc = "Plasma commendation medals received from other crew members."
	database_id = MEDAL_PLASMA_SCORE
