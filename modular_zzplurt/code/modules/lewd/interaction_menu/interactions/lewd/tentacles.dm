// Slime tentacle lewd interactions with intent-based messaging and fluid milking mechanics
/datum/interaction/lewd/tentacles
	cum_target = list(CLIMAX_POSITION_TARGET = null)
	sound_use = TRUE
	category = "Lewd (Tentacles)"
	var/try_milking = FALSE
	var/milk_breasts = FALSE
	var/help_text
	var/grab_text
	var/harm_text

/datum/interaction/lewd/tentacles/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	return user?.has_slime_tentacles()

/datum/interaction/lewd/tentacles/proc/find_liquid_container(mob/living/holder)
	if(!istype(holder))
		return null
	var/obj/item/reagent_containers/cached_item = holder.get_active_held_item()
	if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
		return cached_item
	cached_item = holder.pulling
	if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
		return cached_item
	return null

/datum/interaction/lewd/tentacles/proc/transfer_breast_milk(mob/living/carbon/human/milk_source, obj/item/reagent_containers/liquid_container, mob/living/transferrer)
	if(!istype(milk_source) || !istype(liquid_container))
		return
	var/obj/item/organ/genital/breasts/breasts = milk_source.get_organ_slot(ORGAN_SLOT_BREASTS)
	if(!breasts?.internal_fluid_datum || !breasts.reagents?.total_volume)
		return
	var/milk_multiplier = 0.5
	if(breasts.internal_fluid_maximum > 0)
		milk_multiplier = 0.5 + (1.5 * (breasts.reagents.total_volume / breasts.internal_fluid_maximum))
	var/transfer_amount = rand(1, 3 * milk_multiplier)
	var/datum/reagents/temp_reagents = new(breasts.internal_fluid_maximum)
	breasts.reagents.trans_to(temp_reagents, transfer_amount)
	temp_reagents.trans_to(liquid_container, temp_reagents.total_volume, transferred_by = transferrer)
	qdel(temp_reagents)

/datum/interaction/lewd/tentacles/act(mob/living/user, mob/living/target)
	var/obj/item/reagent_containers/liquid_container
	if(try_milking)
		liquid_container = find_liquid_container(user)

	message = null
	target_arousal = 6
	target_pleasure = 4
	target_pain = 0
	user_arousal = 2
	user_pleasure = 4
	user_pain = 0

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

	var/mob/living/climax_holder = (usage == INTERACTION_SELF) ? user : target
	if(liquid_container)
		message += " Trying to catch the escaping fluids in [liquid_container]"
		if(climax_holder)
			LAZYADD(fluid_transfer_objects, list("[REF(climax_holder)]" = liquid_container))

	if(usage == INTERACTION_SELF)
		user_arousal = target_arousal
		user_pleasure = target_pleasure
		user_pain = target_pain

	message = list(message)
	. = ..()

	if(liquid_container && climax_holder)
		LAZYREMOVE(fluid_transfer_objects, REF(climax_holder))

/datum/interaction/lewd/tentacles/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	if(!milk_breasts)
		return
	var/obj/item/reagent_containers/liquid_container = find_liquid_container(user)
	if(!liquid_container)
		return
	var/mob/living/carbon/human/milk_source = (usage == INTERACTION_SELF) ? user : target
	transfer_breast_milk(milk_source, liquid_container, user)

/datum/interaction/lewd/tentacles/dick
	name = "Tentacles. Milk Cock"
	description = "Coil your slime tentacles around their cock to stroke and milk it."
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	additional_details = list(INTERACTION_FILLS_CONTAINERS)
	try_milking = TRUE
	sound_possible = list(
		'modular_zzplurt/sound/interactions/squelch1.ogg',
		'modular_zzplurt/sound/interactions/squelch2.ogg',
		'modular_zzplurt/sound/interactions/squelch3.ogg'
	)
	help_text = list(
		"coils slick slime tentacles around %TARGET%'s cock, gently stroking up and down the shaft.",
		"glides warm, malleable tentacles along %TARGET%'s length, teasing the tip with rhythmic pulses.",
		"wraps soft slime tendrils around %TARGET%'s shaft, milking it with smooth, undulating motions."
	)
	grab_text = list(
		"tightly spirals multiple slime tentacles around %TARGET%'s cock, milking the shaft with insistent, rhythmic squeezes.",
		"locks %TARGET%'s cock in a slick sleeve of writhing tentacles, pumping from base to tip without letting up.",
		"coils firm slime tendrils around %TARGET%'s shaft and balls, relentlessly working them toward climax."
	)
	harm_text = list(
		"vise-grips %TARGET%'s cock in a constricting knot of slime tentacles, milking it with rough, unforgiving pressure.",
		"furiously pumps and squeezes %TARGET%'s shaft with writhing tentacles, forcing pleasure through sheer intensity.",
		"twists slick tentacles tightly around %TARGET%'s cock, tugging and milking without mercy."
	)
	cum_message_text_overrides = list(CLIMAX_POSITION_TARGET = list("%CUMMING% shoots a thick load over %CAME_IN%'s writhing slime tentacles."))

/datum/interaction/lewd/tentacles/vagina
	name = "Tentacles. Penetrate Pussy"
	description = "Slide your slime tentacles inside their pussy."
	target_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_VAGINA)
	try_milking = TRUE
	additional_details = list(INTERACTION_FILLS_CONTAINERS)
	help_text = list(
		"gently slips a slick slime tentacle inside %TARGET%'s pussy, curling softly against their inner walls.",
		"slides a warm, malleable tentacle into %TARGET%'s slit, pulsing rhythmically inside them.",
		"coaxes a pair of smooth slime tendrils into %TARGET%'s pussy, moving with slow, sensual waves."
	)
	grab_text = list(
		"drives thick slime tentacles deep into %TARGET%'s pussy, writhing and churning inside them.",
		"packs %TARGET%'s pussy full of slick, pulsing tentacles that stroke every sensitive spot at once.",
		"thrusts multiple slime tendrils into %TARGET%'s slit, pumping in and out with insistent force."
	)
	harm_text = list(
		"rams a thick bundle of slime tentacles deep into %TARGET%'s pussy, stretching their walls relentlessly.",
		"forcefully churns writhing tentacles inside %TARGET%'s slit, giving them no chance to catch their breath.",
		"violently pounds %TARGET%'s pussy with slick, unyielding tentacles."
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
	cum_message_text_overrides = list(CLIMAX_POSITION_TARGET = list("%CUMMING% drenches %CAME_IN%'s slime tentacles in juices."))

/datum/interaction/lewd/tentacles/vagina_rub
	name = "Tentacles. Tease Pussy"
	description = "Rub and milk their pussy with your slime tentacles."
	target_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_VAGINA)
	try_milking = TRUE
	additional_details = list(INTERACTION_FILLS_CONTAINERS)
	help_text = list(
		"glides slick slime tentacles across %TARGET%'s folds, gently teasing their clit.",
		"traces warm, quivering tendrils along %TARGET%'s slit, coaxing out soft shivers.",
		"curls a smooth tentacle tip against %TARGET%'s pussy, rubbing in slow circles."
	)
	grab_text = list(
		"presses writhing slime tentacles firmly against %TARGET%'s pussy, rubbing and milking their folds.",
		"coils slick tendrils around %TARGET%'s clit and labia, vibrating and stroking without pause.",
		"relentlessly works %TARGET%'s slit with multiple slime tentacles, drawing out their fluids."
	)
	harm_text = list(
		"slaps and grinds thick slime tentacles roughly against %TARGET%'s pussy.",
		"pinches and tugs at %TARGET%'s folds with slick tentacles, overstimulating them mercilessly.",
		"lashed %TARGET%'s sensitive slit with writhing tentacles, forcing sharp gasps."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/squelch1.ogg',
		'modular_zzplurt/sound/interactions/squelch2.ogg',
		'modular_zzplurt/sound/interactions/squelch3.ogg'
	)
	cum_message_text_overrides = list(CLIMAX_POSITION_TARGET = list("%CUMMING% squirts all over %CAME_IN%'s slime tentacles."))

/datum/interaction/lewd/tentacles/breasts
	name = "Tentacles. Milk Breasts"
	description = "Wrap your slime tentacles around their breasts to knead and milk them."
	target_required_parts = list(ORGAN_SLOT_BREASTS = REQUIRE_GENITAL_EXPOSED)
	additional_details = list(INTERACTION_FILLS_CONTAINERS)
	try_milking = TRUE
	milk_breasts = TRUE
	sound_possible = list(
		'modular_zzplurt/sound/interactions/squelch1.ogg',
		'modular_zzplurt/sound/interactions/squelch2.ogg',
		'modular_zzplurt/sound/interactions/squelch3.ogg'
	)
	help_text = list(
		"coils warm slime tentacles around %TARGET%'s breasts, gently kneading and teasing their nipples.",
		"cups %TARGET%'s chest with slick tendrils, softly squeezing and massaging their breasts.",
		"wraps malleable slime tentacles around %TARGET%'s nipples, pulsing with a gentle milking rhythm."
	)
	grab_text = list(
		"binds %TARGET%'s breasts in coils of slick slime tentacles, squeezing rhythmically to milk them.",
		"latches hollow-tipped slime tendrils onto %TARGET%'s nipples while kneading their breasts firmly.",
		"works %TARGET%'s chest with writhing tentacles, tightly squeezing and drawing from their nipples."
	)
	harm_text = list(
		"constricts %TARGET%'s breasts in tight rings of slime tentacles, squeezing hard and tugging at their nipples.",
		"roughly kneads and wrings %TARGET%'s breasts with relentless tentacle coils.",
		"pinches and pulls %TARGET%'s nipples with slick tentacles while crushing their breasts together."
	)

/datum/interaction/lewd/tentacles/ass
	name = "Tentacles. Penetrate Ass"
	description = "Penetrate their ass with your slime tentacles."
	target_required_parts = list(ORGAN_SLOT_ANUS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_BOTH)
	try_milking = TRUE
	additional_details = list(INTERACTION_FILLS_CONTAINERS)
	help_text = list(
		"gently eases a slick slime tentacle past %TARGET%'s ring, massaging them from within.",
		"slides a warm, naturally lubricated tentacle into %TARGET%'s ass, curling softly inside.",
		"slowly works a malleable slime tendril into %TARGET%'s rear, pulsing with gentle rhythm."
	)
	grab_text = list(
		"drives thick slime tentacles deep into %TARGET%'s ass, writhing and pressing against their sensitive spots.",
		"pushes multiple slick tendrils into %TARGET%'s rear, stretching and filling them completely.",
		"rhythmically pistons slime tentacles in and out of %TARGET%'s anus."
	)
	harm_text = list(
		"forcefully rams thick slime tentacles deep into %TARGET%'s ass, stretching their ring without mercy.",
		"violently churns knotted slime tendrils inside %TARGET%'s rear passage.",
		"packs %TARGET%'s ass to the limit with writhing tentacles, pounding them relentlessly."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	cum_message_text_overrides = list(CLIMAX_POSITION_TARGET = list("%CUMMING% clenches tightly around %CAME_IN%'s slime tentacles as they climax."))

/datum/interaction/lewd/tentacles/urethra
	name = "Tentacles. Penetrate Urethra"
	description = "Thread a thin slime tentacle into their urethra to stimulate and milk them."
	target_required_parts = list()
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	try_milking = TRUE
	additional_details = list(INTERACTION_FILLS_CONTAINERS)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/squelch1.ogg',
		'modular_zzplurt/sound/interactions/squelch2.ogg'
	)
	help_text = list(
		"carefully threads a slender, slick slime tentacle into %TARGET%'s urethra, pulsing gently inside.",
		"glides a thin, malleable tendril down %TARGET%'s urethra, teasing every sensitive inch.",
		"eases a smooth slime feeler into %TARGET%'s urethra, undulating softly."
	)
	grab_text = list(
		"pushes a writhing slime tentacle deep into %TARGET%'s urethra, milking them from the inside out.",
		"works a slick tendril steadily deeper down %TARGET%'s urethra, thickening slightly as it pulses.",
		"thrusts a firm slime feeler through %TARGET%'s urethra, stimulating them relentlessly."
	)
	harm_text = list(
		"forces a thick slime tentacle deep down %TARGET%'s urethra, stretching it from within.",
		"mercilessly churns a pulsing slime tendril inside %TARGET%'s urethra.",
		"rams an expanding slime tentacle into %TARGET%'s urethra, ignoring their gasps."
	)
	cum_message_text_overrides = list(CLIMAX_POSITION_TARGET = list("%CUMMING% shudders and cums around the slime tentacle threaded inside their urethra."))

/datum/interaction/lewd/tentacles/mouth
	name = "Tentacles. Feed Tentacles"
	description = "Push your slime tentacles into their mouth."
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_MOUTH)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/oral1.ogg',
		'modular_zzplurt/sound/interactions/oral2.ogg'
	)
	help_text = list(
		"gently slips a slick slime tentacle between %TARGET%'s lips, letting them suck on the tip.",
		"coaxes a warm, malleable tendril into %TARGET%'s mouth, curling playfully against their tongue.",
		"slides a smooth slime tentacle over %TARGET%'s tongue."
	)
	grab_text = list(
		"pushes thick slime tentacles deep into %TARGET%'s mouth, filling their throat.",
		"thrusts writhing slime tendrils past %TARGET%'s lips, making them gag softly.",
		"coils a tentacle around %TARGET%'s head while feeding another deep into their mouth."
	)
	harm_text = list(
		"forces multiple thick slime tentacles down %TARGET%'s throat, muffling their sounds completely.",
		"relentlessly facefucks %TARGET% with a bundle of writhing slime tentacles.",
		"shoves slick tentacles deep into %TARGET%'s gullet, bulging their throat."
	)

// Interactions targeting a slimeperson who has active tentacles extended
/datum/interaction/lewd/tentacles/someone
	user_required_parts = list()
	target_required_parts = list()

/datum/interaction/lewd/tentacles/someone/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target == user && usage == INTERACTION_OTHER)
		return FALSE
	if(!target?.has_slime_tentacles())
		return FALSE
	return ..(/datum/interaction/lewd/tentacles)

/datum/interaction/lewd/tentacles/someone/oral
	name = "Mouth. Suck Tentacles"
	description = "Lick and suck on their slime tentacles."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_MOUTH)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/oral1.ogg',
		'modular_zzplurt/sound/interactions/oral2.ogg'
	)
	help_text = list(
		"licks and sucks gently on the tip of %TARGET%'s slime tentacle.",
		"wraps their lips around one of %TARGET%'s slick tentacles, sucking softly.",
		"runs their tongue along %TARGET%'s writhing slime tendrils."
	)
	grab_text = list(
		"eagerly takes %TARGET%'s slime tentacle deep into their mouth, sucking hard.",
		"bobs their head along %TARGET%'s slick tentacle, slurping noisily.",
		"sucks intently on %TARGET%'s pulsing slime tendrils."
	)
	harm_text = list(
		"bites and chews roughly on %TARGET%'s slime tentacle.",
		"aggressively deepthroats %TARGET%'s writhing tentacle.",
		"nips sharply at %TARGET%'s sensitive slime tendrils."
	)

/datum/interaction/lewd/tentacles/someone/get_milked
	name = "Tentacles. Get Milked"
	description = "Let their slime tentacles coil around you and milk your body."
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_BOTH)
	cum_target = list(CLIMAX_POSITION_USER = null)
	additional_details = list(INTERACTION_FILLS_CONTAINERS)
	try_milking = TRUE
	sound_possible = list(
		'modular_zzplurt/sound/interactions/squelch1.ogg',
		'modular_zzplurt/sound/interactions/squelch2.ogg',
		'modular_zzplurt/sound/interactions/squelch3.ogg'
	)
	help_text = list(
		"presses against %TARGET%, letting slick slime tentacles coil over their body and gently milk them.",
		"surrenders to %TARGET%'s warm tentacles as they wrap around their sensitive parts and stroke rhythmically.",
		"gasps softly as %TARGET%'s malleable slime tendrils caress and milk their body."
	)
	grab_text = list(
		"writhes in %TARGET%'s grasp as multiple slime tentacles coil tightly around them, milking them insistently.",
		"lets %TARGET%'s pulsing tentacles wrap around their chest and groin, pumping and milking them nonstop.",
		"moans as %TARGET%'s slick tendrils bind and milk every sensitive spot on their body."
	)
	harm_text = list(
		"thrash helplessly in %TARGET%'s constricting slime tentacles as they relentlessly milk their body.",
		"shudders as %TARGET%'s tentacles squeeze and overstimulate them in a rough, unyielding milking grip.",
		"gasps for air as %TARGET%'s writhing tendrils mercilessly milk them to the limit."
	)
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list("%CUMMING% climaxes hard as %CAME_IN%'s slime tentacles milk them dry."))

/datum/interaction/lewd/tentacles/someone/get_milked/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!..())
		return FALSE
	if(!ishuman(user))
		return FALSE
	return user.has_genital(REQUIRE_GENITAL_EXPOSED, ORGAN_SLOT_PENIS) || user.has_genital(REQUIRE_GENITAL_EXPOSED, ORGAN_SLOT_VAGINA) || user.has_genital(REQUIRE_GENITAL_EXPOSED, ORGAN_SLOT_BREASTS)

/datum/interaction/lewd/tentacles/someone/get_milked/act(mob/living/user, mob/living/target)
	var/obj/item/reagent_containers/liquid_container = find_liquid_container(user) || find_liquid_container(target)
	message = null
	user_arousal = 8
	user_pleasure = 6
	user_pain = 0
	target_arousal = 4
	target_pleasure = 4
	target_pain = 0

	switch(resolve_intent_name(user))
		if("help")
			message = islist(help_text) ? pick(help_text) : help_text
		if("grab", "disarm")
			message = islist(grab_text) ? pick(grab_text) : grab_text
			user_arousal += 3
			user_pleasure += 2
		if("harm")
			user_pain = 5
			message = islist(harm_text) ? pick(harm_text) : harm_text

	if(liquid_container)
		message += " Trying to catch the escaping fluids in [liquid_container]"
		LAZYADD(fluid_transfer_objects, list("[REF(user)]" = liquid_container))

	message = list(message)
	. = ..(/datum/interaction/lewd)

	if(liquid_container)
		LAZYREMOVE(fluid_transfer_objects, REF(user))
		if(ishuman(user))
			transfer_breast_milk(user, liquid_container, target)

// Tentacle smothering interaction
/datum/interaction/lewd/tentacles/smother
	name = "Tentacles. Smother"
	description = "Wrap your slime tentacles around their face. (Warning: Causes oxygen damage)"
	unsafe_types = INTERACTION_HARMFUL
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_MOUTH)
	help_text = list(
		"gently coils warm slime tentacles around %TARGET%'s face.",
		"wraps slick, translucent tendrils softly over %TARGET%'s nose and mouth.",
		"cradles %TARGET%'s head in a warm web of malleable slime tentacles."
	)
	grab_text = list(
		"wraps thick slime tentacles firmly over %TARGET%'s face, restricting their breathing.",
		"coils slick tendrils around %TARGET%'s head, sealing their mouth and nose.",
		"binds %TARGET%'s face in a tight mask of writhing slime tentacles."
	)
	harm_text = list(
		"constricts a heavy mass of slime tentacles tightly around %TARGET%'s face, cutting off all air.",
		"smothers %TARGET% completely beneath coiling, unyielding slime tentacles.",
		"seals %TARGET%'s airways under a crushing layer of writhing slime tendrils."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/squelch1.ogg',
		'modular_zzplurt/sound/interactions/squelch2.ogg'
	)
	sound_range = 1
	sound_use = TRUE

/datum/interaction/lewd/tentacles/smother/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	if(!user.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(user) && !user.client && !SSinteractions.is_blacklisted(user)))
		return FALSE
	if(!target.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target)))
		return FALSE

	return TRUE

/datum/interaction/lewd/tentacles/smother/act(mob/living/user, mob/living/target)
	var/intent = resolve_intent_name(user)
	if(HAS_TRAIT(target, TRAIT_CHOKE_SLUT))
		if(intent == "harm")
			to_chat(target, span_purple("You can't breathe at all through the slick tentacles! The pressure is intense... it's amazing!"))
		else
			to_chat(target, span_purple("The warm slime tentacles sealing your face feel overwhelming... it's so tight!"))
	. = ..()
	if(HAS_TRAIT(target, TRAIT_CHOKE_SLUT))
		target.adjust_arousal(8)
		target.adjust_pleasure(4)

/datum/interaction/lewd/tentacles/smother/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	if(!istype(user))
		return
	var/stat_before = target.stat
	var/oxy_damage = 3

	switch(resolve_intent_name(user))
		if("harm")
			oxy_damage = 5
		if("grab")
			oxy_damage = 4
		else
			oxy_damage = 3

	if(target.get_oxy_loss() < 45)
		target.adjust_oxy_loss(oxy_damage)
	else if(user.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No" || target.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No")
		target.adjust_oxy_loss(oxy_damage)

	if(target.stat == HARD_CRIT && stat_before != HARD_CRIT)
		target.visible_message(span_lewd("[target] passes out wrapped in [user]'s slime tentacles."))

