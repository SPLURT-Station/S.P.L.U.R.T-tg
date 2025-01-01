#define CUM_TARGET_MOUTH "mouth"
#define CUM_TARGET_THROAT "throat"
#define CUM_TARGET_VAGINA "vagina"
#define CUM_TARGET_ANUS "anus"
#define CUM_TARGET_HAND "hand"
#define CUM_TARGET_BREASTS "breasts"
#define CUM_TARGET_FEET "feet"
#define CUM_TARGET_PENIS "penis"
//Weird defines go here
#define CUM_TARGET_EARS "ears"
#define CUM_TARGET_EYES "eyes"
//
#define GRINDING_FACE_WITH_ANUS "faceanus"
#define GRINDING_FACE_WITH_FEET "facefeet"
#define GRINDING_MOUTH_WITH_FEET "mouthfeet"
#define THIGH_SMOTHERING "thigh_smother"
#define NUTS_TO_FACE "nut_face"

#define NORMAL_LUST 10
#define LOW_LUST 1

/// Exposed states, your friendly non-carbon returns
// TRUE
#define HAS_EXPOSED_GENITAL 2
#define HAS_UNEXPOSED_GENITAL 3

/// Interaction requirements
#define INTERACTION_REQUIRE_BOTTOMLESS (1<<0)
#define INTERACTION_REQUIRE_HANDS (1<<1)
#define INTERACTION_REQUIRE_MOUTH (1<<2)
#define INTERACTION_REQUIRE_TOPLESS (1<<3)

/// Interaction requirements -- Has require states
#define INTERACTION_REQUIRE_ANUS (1<<0)
#define INTERACTION_REQUIRE_BALLS (1<<1)
#define INTERACTION_REQUIRE_BREASTS (1<<2)
// Terrible stuff start here
#define INTERACTION_REQUIRE_EARS (1<<3)
#define INTERACTION_REQUIRE_EARSOCKETS (1<<4)
#define INTERACTION_REQUIRE_EYES (1<<5)
#define INTERACTION_REQUIRE_EYESOCKETS (1<<6)
// End here
#define INTERACTION_REQUIRE_FEET (1<<7)
#define INTERACTION_REQUIRE_PENIS (1<<8)
#define INTERACTION_REQUIRE_VAGINA (1<<9)

/// Interaction flags
#define INTERACTION_FLAG_ADJACENT (1<<0)
#define INTERACTION_FLAG_EXTREME_CONTENT (1<<1)
#define INTERACTION_FLAG_OOC_CONSENT (1<<2)
#define INTERACTION_FLAG_TARGET_NOT_TIRED (1<<3)
#define INTERACTION_FLAG_USER_IS_TARGET (1<<4)
#define INTERACTION_FLAG_USER_NOT_TIRED (1<<5)

/// Copy-paste prevention for additional details
#define INTERACTION_FILLS_CONTAINERS list( \
	"info" = "You can fill a container if you have it in your active hand or are pulling it", \
	"icon" = "flask", \
	"color" = "transparent" \
	)
