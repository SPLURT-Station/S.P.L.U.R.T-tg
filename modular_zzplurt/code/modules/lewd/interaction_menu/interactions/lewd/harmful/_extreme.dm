/datum/interaction/lewd/extreme
	unsafe_types = INTERACTION_EXTREME
	color = "red"
	category = INTERACTION_CAT_EXTREME

/datum/interaction/lewd/extreme/harmful
	unsafe_types = INTERACTION_EXTREME | INTERACTION_HARMFUL
	category = INTERACTION_CAT_HARMFUL

/datum/interaction/lewd/extreme/harmful/choke
	name = "Choke"
	description = "Choke them. (Warning: Causes oxygen damage)"
	sound_possible = list('sound/items/weapons/thudswoosh.ogg')
	target_arousal = 6
	target_pleasure = 0
	target_pain = 6

/datum/interaction/lewd/extreme/harmful/choke/act(mob/living/user, mob/living/target)
	var/oxy_damage
	message = null

	switch(resolve_intent_name(user))
		if("harm")
			oxy_damage = rand(3, 6)
			message = list(
				"roughly wraps their arm around %TARGET%'s neck, trying to cut off their air supply.",
				"wrings their hands around %TARGET%'s neck and immediately begins to squeeze, blocking their airways.",
				"sharply tightens their wrists around %TARGET%'s neck, causing suffocation."
			)
		else
			oxy_damage = (target.get_oxy_loss() > 40) ? 0 : 3  // Prevent damage stacking - converts to pure RP when target already suffocating
			message = list(
				"grips %TARGET%'s throat, trying to block access to air.",
				"holds %TARGET%'s neck, squeezing it tighter and tighter.",
				"latches onto %TARGET%'s neck, holding and not letting them take a breath."
			)

	if(!HAS_TRAIT(target, TRAIT_NOBREATH) && oxy_damage)
		target.apply_damage(oxy_damage, OXY)

	if(HAS_TRAIT(target, TRAIT_CHOKE_SLUT))
		target_pleasure = 4
		target_arousal = 12
	else
		target_pleasure = 0
		target_arousal = 6

	..()
