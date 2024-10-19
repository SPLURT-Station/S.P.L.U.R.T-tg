/datum/interaction/handshake
	description = "Shake their hand."
	simple_message = "USER shakes the hand of TARGET."
	required_from_user = INTERACTION_REQUIRE_HANDS
	required_from_target = INTERACTION_REQUIRE_HANDS

/datum/interaction/pat
	description = "Pat their shoulder."
	simple_message = "USER pats TARGET's shoulder."
	required_from_user = INTERACTION_REQUIRE_HANDS

/datum/interaction/cheer
	description = "Cheer them on."
	required_from_user = INTERACTION_REQUIRE_MOUTH
	simple_message = "USER cheers TARGET on!"
	interaction_flags = NONE

/datum/interaction/highfive
	description = "Give them a high-five."
	simple_message = "USER high fives TARGET!"
	interaction_sound = 'modular_zzplurt/sound/interactions/slap.ogg'
	required_from_user = INTERACTION_REQUIRE_HANDS
	required_from_target = INTERACTION_REQUIRE_HANDS

/datum/interaction/headpat
	description = "Pat their head. Aww..."
	simple_message = "USER headpats TARGET!"
	required_from_user = INTERACTION_REQUIRE_HANDS

/datum/interaction/salute
	description = "Give them a firm salute!"
	simple_message = "USER salutes TARGET sharply!"
	required_from_user = INTERACTION_REQUIRE_HANDS
	max_distance = 25
	interaction_flags = NONE

/datum/interaction/fistbump
	description = "Bump it!"
	simple_message = "USER fistbumps TARGET! Yeah!"
	required_from_user = INTERACTION_REQUIRE_HANDS
	required_from_target = INTERACTION_REQUIRE_HANDS

/datum/interaction/pinkypromise
	description = "Make a pinky promise with them!"
	simple_message = "USER hooks their pinky with TARGET's! Pinky Promise!"
	required_from_user = INTERACTION_REQUIRE_HANDS
	required_from_target = INTERACTION_REQUIRE_HANDS

/datum/interaction/bird
	description = "Flip them the bird!"
	simple_message = "USER gives TARGET the bird!"
	required_from_user = INTERACTION_REQUIRE_HANDS
	max_distance = 25
	interaction_flags = NONE

/datum/interaction/holdhand
	description = "Hold their hand."
	simple_message = "USER holds TARGET's hand."
	required_from_user = INTERACTION_REQUIRE_HANDS
	required_from_target = INTERACTION_REQUIRE_HANDS
