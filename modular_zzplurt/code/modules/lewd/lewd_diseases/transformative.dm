// Male Deathclaw Version
/datum/disease/transformation/funclaw
	name = "Ravishing Deathclaw Transformation"
	cure_text = "That which kills arousal"
	cures = list(/datum/reagent/drug/aphrodisiac/camphor) // Only that which kills arousal will prevent this creature from
	cure_chance = 25
	stage_prob = 2.5
	agent = "Ravishing Forced Evolution"
	desc = "A terrible disease known to override the subjects inhibitions, curing is preferred, least the station ends up a breeding den."
	severity = DISEASE_SEVERITY_BIOHAZARD
	visibility_flags = NONE
	stage1 = list("You catch yourself tasting the air")
	stage2 = list("Your pants are growing a bit too tight as something is growing")
	stage3 = list(
		span_danger("Your eyes can't stop staring at people close by."),
		span_danger("Your libido is acting up."),
		span_danger("You catch yourself almost lunging for someone."),
	)
	stage4 = list(
		span_danger("Your pants are starting to rip."),
		span_danger("You feel the need to rut and breed.")
	)
	stage5 = list(span_danger("You roar as you claw your way from your former form, eager to BREED."))
	new_form = /mob/living/basic/deathclaw/funclaw

/datum/disease/transformation/funclaw/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("growl")
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/drug/aphrodisiac/crocin = 5))
		if(3)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("moan")
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/drug/aphrodisiac/crocin = 5))
		if(4)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("lewdmoan")
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/drug/aphrodisiac/crocin/hexacrocin = 0.5)) // Primarily to try and not overdose and bimbofy someone before the virus has finished converting them

// Female Deathclaw Version
/datum/disease/transformation/mommyclaw
	name = "Motherly Deathclaw Transformation"
	cure_text = "That which kills arousal"
	cures = list(/datum/reagent/drug/aphrodisiac/camphor) // Only that which kills arousal will prevent this creature from
	cure_chance = 25
	stage_prob = 2.5
	agent = "Forced Motherly Evolution"
	desc = "A terrible disease known to override the subjects inhibitions, slowly pushing them more and more into being motherly, curing is somewhat suggested, least you end up being seen as their spawn!"
	severity = DISEASE_SEVERITY_BIOHAZARD
	visibility_flags = NONE
	stage1 = list("You catch yourself tasting the air")
	stage2 = list("Your breasts are growing!")
	stage3 = list(
		span_danger("Your eyes can't stop staring at people with a desire to smother them."),
		span_danger("Your libido is acting up."),
		span_danger("You catch yourself almost lunging for someone to cuddle."),
	)
	stage4 = list(
		span_danger("Milk seems to be running from your breasts."),
		span_danger("You feel the need to be breed and mother people.")
	)
	stage5 = list(span_danger("You roar as you claw your way from your former form, eager to NURSE."))
	new_form = /mob/living/basic/deathclaw/funclaw/femclaw/mommyclaw

/datum/disease/transformation/mommyclaw/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("growl")
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/drug/aphrodisiac/crocin = 5))
		if(3)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("moan")
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/drug/aphrodisiac/crocin = 5))
		if(4)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("lewdmoan")
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/drug/aphrodisiac/crocin/hexacrocin = 0.5)) // Primarily to try and not overdose and bimbofy someone before the virus has finished converting them

// Male Werewolf Version
/datum/disease/transformation/funwolf
	name = "Ravishing Lycanthopy"
	cure_text = "That which kills arousal"
	cures = list(/datum/reagent/drug/aphrodisiac/camphor) // Only that which kills arousal will prevent this creature from
	cure_chance = 25
	stage_prob = 2.5
	agent = "Ravishing Lycanthopy"
	desc = "A terrible disease known to override the subjects inhibitions, curing is preferred, least the station ends up a breeding den."
	severity = DISEASE_SEVERITY_BIOHAZARD
	visibility_flags = NONE
	stage1 = list("You catch yourself tasting the air")
	stage2 = list("Your pants are growing a bit too tight as something is growing")
	stage3 = list(
		span_danger("Your eyes can't stop staring at people close by."),
		span_danger("Your libido is acting up."),
		span_danger("You catch yourself almost lunging for someone."),
	)
	stage4 = list(
		span_danger("Your pants are starting to rip."),
		span_danger("You feel the need to rut and breed.")
	)
	stage5 = list(span_danger("You roar as you claw your way from your former form, eager to hunt for the pack and to breed~"))
	new_form = /mob/living/basic/werewolf/funwolf/alpha

/datum/disease/transformation/funwolf/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("growl")
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/drug/aphrodisiac/crocin = 5))
		if(3)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("moan")
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/drug/aphrodisiac/crocin = 5))
		if(4)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("lewdmoan")
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/drug/aphrodisiac/crocin/hexacrocin = 0.5)) // Primarily to try and not overdose and bimbofy someone before the virus has finished converting them

// Female Werewolf Version
/datum/disease/transformation/bitchwolf
	name = "Motherly Lycanthopy"
	cure_text = "That which kills arousal"
	cures = list(/datum/reagent/drug/aphrodisiac/camphor) // Only that which kills arousal will prevent this creature from
	cure_chance = 25
	stage_prob = 2.5
	agent = "Motherly Lycanthopy"
	desc = "A terrible disease known to override the subjects inhibitions, slowly pushing them more and more into being motherly, curing is somewhat suggested, least you end up being seen as their spawn!"
	severity = DISEASE_SEVERITY_BIOHAZARD
	visibility_flags = NONE
	stage1 = list("You catch yourself tasting the air")
	stage2 = list("Your breasts are growing!")
	stage3 = list(
		span_danger("Your eyes can't stop staring at people with a desire to smother them."),
		span_danger("Your libido is acting up."),
		span_danger("You catch yourself almost lunging for someone to cuddle."),
	)
	stage4 = list(
		span_danger("Milk seems to be running from your breasts."),
		span_danger("You feel the need to bend over.")
	)
	stage5 = list(span_danger("You roar as you claw your way from your former form, eager to BREED."))
	new_form = /mob/living/basic/werewolf/funwolf/bitch

/datum/disease/transformation/bitchwolf/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("growl")
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/drug/aphrodisiac/crocin = 5))
		if(3)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("moan")
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/drug/aphrodisiac/crocin = 5))
		if(4)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("lewdmoan")
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/drug/aphrodisiac/crocin/hexacrocin = 0.5)) // Primarily to try and not overdose and bimbofy someone before the virus has finished converting them

