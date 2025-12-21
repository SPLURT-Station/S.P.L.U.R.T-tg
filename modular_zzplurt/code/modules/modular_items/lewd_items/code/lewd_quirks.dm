
/datum/brain_trauma/very_special/bimbo

	///how much additional_minimum_arousal this trait has added, to prevent interfering with other sources
	var/added_arousal = 0

/datum/brain_trauma/very_special/bimbo/proc/try_unsatisfied()
	var/mob/living/carbon/human/human_owner = owner
	//we definitely need an owner; but if you are satisfied, just return
	if(satisfaction || !human_owner)
		return FALSE
	//we need to feel consequences for being unsatisfied
	//the message that will be sent to the owner at the end
	var/blur_time = 0
	var/jitter_time = 0
	var/lust_message = "You feel your body getting warmer as your arousal becomes visible to anyone around you..."
	//we are using if statements so that it slowly becomes more and more to the person
	human_owner.manual_emote(pick(lust_emotes))
	if(stress >= 60)
		blur_time = 5 SECONDS
		lust_message = "Lewd images and thoughts of sex flood your mind, making it hard to concentrate..."
	if(stress >= 120)
		blur_time = 10 SECONDS
		jitter_time = 10 SECONDS
		lust_message = "You find your arousal growing further as you feel an aching need for release..."
	if(stress >= 180)
		blur_time = 15 SECONDS
		jitter_time = 15 SECONDS
		human_owner.adjust_stamina_loss(5)
		lust_message = "Your sexual impulses rise even further as you feel your throbbing genitals leaking and/or growing fully hard..."
	if(stress >= 240)
		blur_time = 20 SECONDS
		jitter_time = 20 SECONDS
		human_owner.adjust_stamina_loss(10)
		lust_message = "It's almost impossible to focus your mind on anything other than sex as your carnal needs continue to grow even stronger!"
	if(stress >= 300)
		blur_time = 30 SECONDS
		jitter_time = 30 SECONDS
		human_owner.adjust_stamina_loss(15)
		lust_message = "You feel so desperately aroused that the almost painful aching, throbbing heat overwhelming your body has taken on a life of it's own. You NEED release!"
	if(blur_time)
		human_owner.set_eye_blur_if_lower(blur_time)
	if(jitter_time)
		human_owner.set_jitter_if_lower(jitter_time)

	to_chat(human_owner, span_purple(lust_message))
	if(!in_company())
		to_chat(human_owner, span_purple("You find yourself groping your genitals, seeking any kind of relief"))
		human_owner.adjust_pleasure(5)

	var/overflow = 0
	switch(stress)
		if(-INFINITY to 59)
			if(added_arousal < 10) //Matches observable minimum.
				added_arousal += 10
				overflow = owner.adjust_minimum_arousal(10)
		if(60 to 119)
			if(added_arousal < 30) //Matches Low Arousal.
				added_arousal += 20
				overflow = owner.adjust_minimum_arousal(20)
		if(120 to 179)
			if(added_arousal < 50) //Free Space! No arousal level matches this value.
				added_arousal += 20
				overflow = owner.adjust_minimum_arousal(20)
		if(180 to 239)
			if(added_arousal < 70) //Matches Medium arousal level. No idea why it's set so high...
				added_arousal += 20
				overflow = owner.adjust_minimum_arousal(20)
		if(240 to 298)
			if(added_arousal < 85) //Matches High Arousal.
				added_arousal += 15
				overflow = owner.adjust_minimum_arousal(15)
		if(299 to INFINITY)
			if(added_arousal < 100) //Matches Maximum Arousal, the subject CANNOT get any hornier.
				added_arousal += 15
				overflow = owner.adjust_minimum_arousal(15)
	if(overflow)
		added_arousal -= overflow
	// At this point we are basicly using the new minimum arousal as arousal that dosen't decrease over time
	// Not sure if I agree with that, but the suggester was very specific
	return TRUE

/**
 * If we have climaxed, return true
 */
/datum/brain_trauma/very_special/bimbo/check_climaxed()
	. = ..()
	if(.)
		owner.adjust_minimum_arousal(-added_arousal)
		added_arousal = 0
	return(.)
