//UNDERWEAR
#define OFFSET_UNDERWEAR "underwear"
#define	OFFSET_SOCKS "socks"
#define OFFSET_SHIRT "shirt"
#define OFFSET_BRA "bra"
#define OFFSET_WRISTS "wrist"
//

#define SPECIES_ARACHNID "arachnid"

/// Movespeed modifier ID for stomping
#define MOVESPEED_ID_STOMP "STEPPY"

// Genital layer offsets are defined upstream in ~~bubber_defines/mobs.dm

/// utillity function to check is both legs are missing from a mob
/proc/get_legs_missing(mob/living/target)
	return target.get_bodypart(BODY_ZONE_L_LEG) == null && target.get_bodypart(BODY_ZONE_R_LEG) == null

/// utillity function to check is both arms are missing from a mob
/proc/get_arms_missing(mob/living/target)
	return target.get_bodypart(BODY_ZONE_L_ARM) == null && target.get_bodypart(BODY_ZONE_R_ARM) == null
