// Lewd tail interactions with dynamic intent-based messaging and fluid collection mechanics
/datum/interaction/lewd/tail
	user_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY)
	cum_target = list(CLIMAX_POSITION_TARGET = null)
	sound_use = TRUE
	category = "Lewd (Tail)"
	var/try_milking = FALSE
	var/help_text
	var/grab_text
	var/harm_text

// Helper function to check if tail is large enough for smothering
/datum/interaction/lewd/tail/proc/can_tail_smother(mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE

	// Check all possible tail feature keys
	var/list/tail_features = list(FEATURE_TAIL_GENERIC, FEATURE_TAIL_CAT, FEATURE_TAIL_LIZARD, FEATURE_TAIL_FISH, FEATURE_TAIL_MONKEY, FEATURE_TAIL_XENO)
	var/tail_type = null

	for(var/feature in tail_features)
		var/list/mutant_bodyparts = user.dna?.mutant_bodyparts
		if(mutant_bodyparts)
			var/list/feature_data = mutant_bodyparts[feature]
			if(feature_data)
				tail_type = feature_data[MUTANT_INDEX_NAME]
				if(tail_type && tail_type != "None")
					break

	if(!tail_type || tail_type == "None")
		return FALSE

	// List of tail types that are large enough to smother
	var/list/large_tails = list(
		"Snake",
		"Leviathan",
		"Xeno",
		"Ash Drake",
		"Drake",
		"Serpent",
		"Hmph!",
		"Null",
		"Fish",
		"Shark",
		"Aquatic"
	)

	return tail_type in large_tails

/datum/interaction/lewd/tail/act(mob/living/user, mob/living/target)
	// Check for containers to collect fluids during interactions
	var/obj/item/reagent_containers/liquid_container
	if(try_milking)
		var/obj/item/cached_item = user.get_active_held_item()
		if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
			liquid_container = cached_item
		else
			cached_item = user.pulling
			if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
				liquid_container = cached_item

	// Initialize arousal/pleasure values and clear previous message state
	message = null
	target_arousal = 6
	target_pleasure = 4
	target_pain = 0
	user_arousal = 0
	user_pleasure = 4
	user_pain = 0

	// Select appropriate message text based on user's current intent
	switch(resolve_intent_name(user))
		if("help")
			message = islist(help_text) ? pick(help_text) : help_text
		if("grab", "disarm")
			message = islist(grab_text) ? pick(grab_text) : grab_text
			target_arousal += 3
			target_pleasure += 2
		if("harm")
			target_pain = 5
			message = islist(harm_text) ? pick(harm_text) : harm_text

	if(liquid_container)
		message += " Trying to catch the escaping fluids in [liquid_container]"
		fluid_transfer_objects = list(liquid_container)
	if(usage == INTERACTION_SELF)
		user_arousal = target_arousal
		user_pleasure = target_pleasure
		user_pain = target_pain

	message = list(message)
	..() // Execute parent interaction logic and send formatted message

// Standard lewd interactions targeting other players' body parts
// Includes penetration, rubbing, and stimulation actions

/datum/interaction/lewd/tail/dick
	name = "Tail. Jerk Cock"
	description = "Jerk off their cock with your tail."
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	additional_details = list(INTERACTION_FILLS_CONTAINERS)
	try_milking = TRUE
	sound_possible = list('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg')
	help_text = list(
		"pleasures %TARGET%'s cock, gliding their tail along it.",
		"runs the tip of their tail along %TARGET%'s shaft.",
		"moves their tail up and down %TARGET%'s cock, trying to bring pleasure."
	)
	grab_text = list(
		"firmly grips %TARGET%'s cock with their tail, sliding along its full length.",
		"predatorily wraps their tail around %TARGET%'s cock and moves along it, not letting them relax.",
		"holds %TARGET%'s cock in a tight ring of their tail, making insistent thrusting motions."
	)
	harm_text = list(
		"tormentingly rough with %TARGET%'s cock, clearly not caring about their partner's sensations.",
		"squeezes and pulls %TARGET%'s cock with their tail, as if enjoying the pain they cause.",
		"sharply grips and twists %TARGET%'s cock with their tail, acting without mercy and holding with force."
	)
	cum_message_text_overrides = list(CLIMAX_POSITION_TARGET = list("%CUMMING% covers %CAME_IN%'s tail with cum."))

/datum/interaction/lewd/tail/vagina
	name = "Tail. Penetrate Pussy"
	description = "Penetrate their pussy with your tail."
	target_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_VAGINA)
	try_milking = TRUE
	additional_details = list(INTERACTION_FILLS_CONTAINERS)
	help_text = list(
		"gently pushes their tail inside %TARGET%'s pussy.",
		"tenderly moves their tail deep into their core, listening to %TARGET%'s reaction.",
		"rhythmically slides their tail into %TARGET%'s pussy, trying to bring maximum pleasure."
	)
	grab_text = list(
		"insistently pounds into %TARGET%'s pussy with their tail, writhing from side to side.",
		"drives their tail deep into %TARGET%'s pussy, forcefully spreading their walls.",
		"presses their tail into %TARGET%'s pussy and begins to move, as if wanting to fill them completely."
	)
	harm_text = list(
		"brutally violates %TARGET%'s pussy with their tail, trying to reach the deepest parts.",
		"forcefully rams their tail into %TARGET%'s pussy with merciless power, giving no rest.",
		"roughly penetrates %TARGET%'s pussy with their tail, stretching and causing discomfort."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/WetPlap01.ogg',
		'modular_zzplurt/sound/interactions/WetPlap02.ogg',
		'modular_zzplurt/sound/interactions/WetPlap03.ogg',
		'modular_zzplurt/sound/interactions/WetPlap04.ogg',
		'modular_zzplurt/sound/interactions/WetPlap05.ogg',
		'modular_zzplurt/sound/interactions/WetPlap06.ogg',
		'modular_zzplurt/sound/interactions/WetPlap07.ogg',
		'modular_zzplurt/sound/interactions/WetPlap08.ogg',
		'modular_zzplurt/sound/interactions/WetPlap09.ogg',
		'modular_zzplurt/sound/interactions/WetPlap10.ogg'
	)
	cum_message_text_overrides = list(CLIMAX_POSITION_TARGET = list("%CUMMING% covers %CAME_IN%'s tail with juices."))

/datum/interaction/lewd/tail/vagina_rub
	name = "Tail. Rub Pussy"
	description = "Slide your tail against their pussy."
	target_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_VAGINA)
	try_milking = TRUE
	additional_details = list(INTERACTION_FILLS_CONTAINERS)
	help_text = list(
		"gently slides their tail around %TARGET%'s slit.",
		"tenderly moves near %TARGET%'s pussy, listening to their reaction.",
		"rhythmically and softly pats %TARGET%'s cunt with their tail, trying to bring maximum pleasure."
	)
	grab_text = list(
		"insistently presses into %TARGET%'s pussy with their tail, writhing from side to side.",
		"actively slaps %TARGET%'s pussy, forcefully pulling at their folds.",
		"pushes their tail into %TARGET%'s pussy and begins to move, as if about to enter inside."
	)
	harm_text = list(
		"brutally rough slaps %TARGET%'s pussy with their tail, trying to leave pain from each strike.",
		"sharply slaps %TARGET%'s pussy with their tail using merciless force, as if trying to knock out their strength.",
		"actively stretches %TARGET%'s folds with their tail, making them think about tearing their body."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/WetPlap01.ogg',
		'modular_zzplurt/sound/interactions/WetPlap02.ogg',
		'modular_zzplurt/sound/interactions/WetPlap03.ogg',
		'modular_zzplurt/sound/interactions/WetPlap04.ogg',
		'modular_zzplurt/sound/interactions/WetPlap05.ogg',
		'modular_zzplurt/sound/interactions/WetPlap06.ogg',
		'modular_zzplurt/sound/interactions/WetPlap07.ogg',
		'modular_zzplurt/sound/interactions/WetPlap08.ogg',
		'modular_zzplurt/sound/interactions/WetPlap09.ogg',
		'modular_zzplurt/sound/interactions/WetPlap10.ogg'
	)
	cum_message_text_overrides = list(CLIMAX_POSITION_TARGET = list("%CUMMING% covers %CAME_IN%'s tail with juices."))

/datum/interaction/lewd/tail/ass
	name = "Tail. Penetrate Ass"
	description = "Penetrate their ass with your tail."
	target_required_parts = list(ORGAN_SLOT_ANUS = REQUIRE_GENITAL_EXPOSED)
	help_text = list(
		"slides inside %TARGET%'s ass with their tail.",
		"gently moves their tail in %TARGET%'s anus, massaging them from inside.",
		"slowly penetrates %TARGET%'s ass with their tail, trying to bring pleasant sensations."
	)
	grab_text = list(
		"actively rams their tail inside %TARGET%'s anus, repeatedly trying to hit sensitive spots.",
		"pushes their tail into %TARGET%'s anal opening, moving confidently and quickly.",
		"rhythmically thrusts their tail into %TARGET%'s anus, writhing and pressing from inside."
	)
	harm_text = list(
		"violates %TARGET%'s ass with their tail, as if trying to pierce right through.",
		"forcefully penetrates %TARGET%'s anal opening with their tail, causing painful sensations.",
		"roughly rams their tail into %TARGET%'s rear passage, acting with force and without a drop of mercy."
	)
	sound_possible = list('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg')
	cum_message_text_overrides = list(CLIMAX_POSITION_TARGET = list("%CUMMING% tightly grips %CAME_IN%'s tail."))

/datum/interaction/lewd/tail/ass_rub
	name = "Tail. Slide Between Cheeks"
	description = "Slide your tail between their cheeks."
	target_required_parts = list(ORGAN_SLOT_ANUS = REQUIRE_GENITAL_EXPOSED)
	help_text = list(
		"slides between %TARGET%'s cheeks with their tail.",
		"gently moves their tail around %TARGET%'s anus, massaging it.",
		"teases %TARGET%'s ring with their tail, trying to bring pleasant sensations."
	)
	grab_text = list(
		"actively rubs their tail around %TARGET%'s anus, repeatedly trying to poke sensitive spots.",
		"presses their tail into %TARGET%'s anal opening, trying to open it by pulling their tail aside.",
		"rhythmically writhes between %TARGET%'s cheeks, writhing and pressing inward."
	)
	harm_text = list(
		"torments %TARGET%'s ass with their tail, as if trying to force their way inside.",
		"forcefully pulls at %TARGET%'s ass with their tail, causing painful sensations.",
		"roughly slaps %TARGET%'s ring, acting with force and without a drop of mercy."
	)
	sound_possible = list('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg')
	cum_message_text_overrides = list(CLIMAX_POSITION_TARGET = list("%CUMMING% tightly grips %CAME_IN%'s tail."))

/datum/interaction/lewd/slap/tail
	name = "Tail. Spank Ass"
	description = "Spank their ass with your tail."
	interaction_requires = list()
	user_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY)
	category = "Lewd (Tail)"
	message = list(
		"spanks %TARGET%'s ass with their tail!",
		"swats %TARGET%'s ass with their tail!",
		"gives %TARGET% a good spank on the ass with their tail!",
	)

/datum/interaction/lewd/tail/urethra
	name = "Tail. Penetrate Urethra"
	description = "Penetrate their urethra with your tail."
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	sound_possible = list('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg',
						'modular_zzplurt/sound/interactions/bang4.ogg',
						'modular_zzplurt/sound/interactions/bang5.ogg',
						'modular_zzplurt/sound/interactions/bang6.ogg',)
	help_text = list(
		"pushes and explores %TARGET%'s urethra with their tail.",
		"slowly moves their tail inside %TARGET%'s urethra, feeling every detail.",
		"gently thrusts their tail in %TARGET%'s urethra, trying to bring pleasure."
	)
	grab_text = list(
		"tries to reach %TARGET%'s groin through their urethra with their tail.",
		"actively pushes their tail deep into %TARGET%'s urethra, as if striving to reach the very base.",
		"forces their tail further down %TARGET%'s urethra, stubbornly making their way to their groin."
	)
	harm_text = list(
		"uses %TARGET%'s urethra like a toy, clearly not caring about their partner's sensations.",
		"mercilessly rams their tail into %TARGET%'s urethra, not reducing pressure for a second.",
		"brutally violates %TARGET%'s urethra with their tail, stretching it from inside."
	)
	cum_message_text_overrides = list(CLIMAX_POSITION_TARGET = list("%CUMMING% tightly grips %CAME_IN%'s tail, covering it with cum."))

/datum/interaction/lewd/tail/breast
	name = "Tail. Slide Between Breasts"
	description = "Slide between their breasts with your tail."
	target_required_parts = list(ORGAN_SLOT_BREASTS = REQUIRE_GENITAL_EXPOSED)
	help_text = list("gently slides between %TARGET%'s breasts with their tail.")
	grab_text = list("insistently presses their tail and writhes it between %TARGET%'s breasts.")
	harm_text = list("mockingly active writhes between %TARGET%'s breasts with their tail, almost slapping them.")
	sound_possible = list('modular_zzplurt/sound/interactions/squelch1.ogg')


// Interactions that target another player's tail
// Uses standard mouth/oral mechanics with tail-specific messaging

/datum/interaction/lewd/tail/someone
	user_required_parts = list()
	target_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY)

/datum/interaction/lewd/tail/someone/oral
	name = "Mouth. Lick Tail"
	description = "Lick their tail."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_MOUTH)
	help_text = list("licks the tip of %TARGET%'s tail.")
	grab_text = list("wraps their lips around the tip of %TARGET%'s tail.")
	harm_text = list("bites the tip of %TARGET%'s tail.")
	sound_possible = list('modular_zzplurt/sound/interactions/squelch1.ogg')

/datum/interaction/lewd/extreme/harmful/tail_choke
	name = "Tailchoke"
	description = "Choke them with your tail. (Warning: Causes oxygen damage)"
	user_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY)
	category = "Lewd (Tail)"
	sound_possible = list('sound/items/weapons/thudswoosh.ogg')
	target_arousal = 6
	target_pleasure = 0
	target_pain = 6

/datum/interaction/lewd/extreme/harmful/tail_choke/act(mob/living/user, mob/living/target)
	message = null
	var/oxy_damage = 3
	target_pleasure = 0
	target_arousal = 6
	if(target.get_oxy_loss() > 40) // Prevent damage stacking - converts to pure RP when target already suffocating
		oxy_damage = 0
	switch(resolve_intent_name(user))
		if("harm")
			oxy_damage = rand(3, 6)
			message = list(
				"roughly wraps their tail around %TARGET%'s neck, trying to cut off their air supply.",
				"coils their tail around %TARGET%'s neck and immediately begins to squeeze, blocking their airways.",
				"sharply tightens their tail around %TARGET%'s neck, causing suffocation."
			)
		else
			message = list(
				"grips %TARGET%'s throat with their tail, trying to block access to air.",
				"holds %TARGET%'s neck with their tail, squeezing it tighter and tighter.",
				"latches onto %TARGET%'s neck with their tail, holding and not letting them take a breath."
			)

	if(!HAS_TRAIT(target, TRAIT_NOBREATH) && oxy_damage)
		target.apply_damage(oxy_damage, OXY)
	if(HAS_TRAIT(target, TRAIT_CHOKE_SLUT))
		target_arousal = 12
		target_pleasure = 4
	..()

// Tail smothering interactions - smother target's face with tail
// Only available for large tails (snake, leviathan, xeno, etc.)

/datum/interaction/lewd/tail/tail_smother
	name = "Tail Smother"
	description = "Wrap your tail around their face. (Warning: Causes oxygen damage)"
	unsafe_types = INTERACTION_HARMFUL
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_MOUTH)
	user_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY)
	help_text = list(
		"carefully wraps their tail around %TARGET%'s face.",
		"gently encircles %TARGET%'s head with their tail.",
		"wraps their tail around %TARGET%'s face, a warm constricting hold.",
		"carefully wraps their tail completely around %TARGET%'s head.",
		"gently encircles %TARGET%'s entire head with their tail.",
		"wraps their tail multiple times around %TARGET%'s head, a warm secure hold.",
		"gently coils their tail around %TARGET%'s face.",
		"carefully wraps their tail over %TARGET%'s nose and mouth."
	)
	grab_text = list(
		"wraps their tail around %TARGET%'s face, covering nose and mouth.",
		"loops their tail over %TARGET%'s face, limiting air flow.",
		"coils their tail gently around %TARGET%'s head.",
		"wraps their tail multiple times around %TARGET%'s head, completely covering their face.",
		"loops their tail over and under %TARGET%'s head, holding them tight.",
		"coils their tail around %TARGET%'s head like a snake, cutting off all air.",
		"wraps their tail firmly around %TARGET%'s face.",
		"constricts their tail around %TARGET%'s head."
	)
	harm_text = list(
		"wraps their long tail tightly around %TARGET%'s face, cutting off all air.",
		"coils their tail around %TARGET%'s head, squeezing hard and blocking airways.",
		"constricts their tail around %TARGET%'s face, smothering them completely.",
		"wraps their long tail multiple times around %TARGET%'s head, completely enveloping their face.",
		"coils their tail tight around %TARGET%'s head, cutting off all air completely.",
		"constricts their powerful tail around %TARGET%'s head, squeezing with deadly force.",
		"wraps their tail around %TARGET%'s face and squeezes tightly.",
		"constricts their tail around %TARGET%'s head with crushing force."
	)
	message = null
	target_arousal = 6
	target_pleasure = 4
	target_pain = 0
	user_arousal = 4
	user_pleasure = 4
	user_pain = 0
	sound_possible = list(
		'modular_zzplurt/sound/interactions/squelch1.ogg',
		'modular_zzplurt/sound/interactions/squelch2.ogg'
	)
	sound_range = 1
	sound_use = TRUE

/datum/interaction/lewd/tail/tail_smother/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	// Check if user has a large enough tail
	if(!can_tail_smother(user))
		to_chat(user, span_warning("Your tail isn't large enough to smother someone!"))
		return FALSE

	// Check if smothering is enabled in preferences
	if(!user.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(user) && !user.client && !SSinteractions.is_blacklisted(user)))
		return FALSE
	if(!target.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target)))
		return FALSE

	return TRUE

/datum/interaction/lewd/tail/tail_smother/act(mob/living/user, mob/living/target)
	var/intent = resolve_intent_name(user)

	// Default values
	target_arousal = 6
	target_pleasure = 4
	target_pain = 0
	user_arousal = 4
	user_pleasure = 4
	user_pain = 0

	switch(intent)
		if("harm")
			// Deep/Intense smother
			target_pain = 6
			target_arousal = 10
			target_pleasure = 8
			user_arousal = 10
			user_pleasure = 8
		if("grab")
			// Moderate smother
			target_arousal = 10
			target_pleasure = 8
			user_arousal = 8
			user_pleasure = 6

	// Check for choke slut trait
	if(HAS_TRAIT(target, TRAIT_CHOKE_SLUT))
		if(intent == "harm")
			target_arousal += 10
			target_pleasure += 6
			to_chat(target, span_purple("You can't breathe at all! The pressure is intense... it's amazing!"))
		else
			target_arousal += 8
			target_pleasure += 4
			to_chat(target, span_purple("The pressure on your face is overwhelming... it's so tight!"))

	message = null
	. = ..()

/datum/interaction/lewd/tail/tail_smother/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	if(!istype(user))
		return
	var/stat_before = target.stat
	var/oxy_damage = 3

	// Set oxy damage based on intent
	switch(resolve_intent_name(user))
		if("harm")
			oxy_damage = 5
		if("grab")
			oxy_damage = 4
		else
			oxy_damage = 3

	// Always apply oxy damage up to 45
	if(target.get_oxy_loss() < 45)
		target.adjust_oxy_loss(oxy_damage)
	// Only apply additional damage if extmharm is enabled
	else if(user.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No" || target.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No")
		target.adjust_oxy_loss(oxy_damage)

	// Check if target just passed out
	if(target.stat == UNCONSCIOUS && stat_before != UNCONSCIOUS)
		if(resolve_intent_name(user) == "harm")
			message = list("%TARGET% passes out wrapped tightly in %USER%'s tail.")
		else
			message = list("%TARGET% passes out wrapped in %USER%'s tail.")
