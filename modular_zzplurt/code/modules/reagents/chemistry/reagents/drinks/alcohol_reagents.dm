/datum/reagent/consumable/ethanol/panty_dropper
	name = "Liquid Panty Dropper"
	description = "You feel it's not named like that for nothing."
	color = "#ce3b01" // rgb: 206, 59, 1
	boozepwr = 70
	quality = DRINK_VERYGOOD
	taste_description = "cloth ripping and tearing"

/datum/reagent/consumable/ethanol/panty_dropper/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(!drinker.client)
		return
	if(drinker.client.prefs.read_preference(/datum/preference/toggle/erp/aphro))
		return
	drinker.clothing_burst(TRUE)

/datum/reagent/consumable/ethanol/lean
	name = "Lean (Brainrot)"
	description = "The choice drink of space-pop stars, composed of soda, cough syrup and candies."
	color =  "#9109ba"
	boozepwr = 0
	metabolization_rate = 1 * REAGENTS_METABOLISM
	quality = DRINK_VERYGOOD
	taste_description = "cough syrup and space-pop music"

/datum/reagent/consumable/ethanol/lean/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	var/mob/living/carbon/human/H = drinker
	var/message = "I LOVE LEAN!!"
	drinker.set_dizzy(50)
	drinker.set_jitter(50)
	drinker.set_drugginess(50)
	switch(current_cycle)
		if(1)
			H.say(message)
		if(80 to 100)
			H.adjustOrganLoss(ORGAN_SLOT_LIVER, 1)
			H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1) // it's cough syrup what'd you expect?
		if(100 to INFINITY)
			H.adjustOrganLoss(ORGAN_SLOT_LIVER, 2)
			H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2)
			if(!H.undergoing_cardiac_arrest() && H.can_heartattack() && prob(1))
				H.set_heartattack(TRUE)
				if(H.stat == CONSCIOUS)
					H.visible_message(span_userdanger("[H] clutches at [H.p_their()] chest as if [H.p_their()] heart stopped!")) // too much lean :(
	..()

/datum/reagent/consumable/ethanol/cum_in_a_hot_tub
	name = "Cum in the Hot Tub"
	description = "Doesn't really leave it to the imagination, eh?"
	boozepwr = 80
	color = "#D2D7D9"
	quality = DRINK_VERYGOOD
	taste_description = "smooth cream"

/datum/reagent/consumable/ethanol/cum_in_a_hot_tub/semen
	name = "Actual Cum in the Hot Tub"
	boozepwr = 65
	taste_description = "viscous cream"
	description = "The name is probably exactly what it is."

/datum/reagent/consumable/ethanol/mech_rider
	name = "Mech Rider"
	description = "Who would even drink this?"
	boozepwr = 65
	color = rgb(111, 127, 63)
	quality = DRINK_GOOD
	taste_description = "the sweat of a certain Mauler pilot"

/datum/reagent/consumable/ethanol/isloation_cell
	name = "Isolation Cell"
	description = "Ice cubes in a padded Cell."
	color = "#b4b4b4"
	quality = DRINK_FANTASTIC
	taste_description = "cloth dissolved in sulphuric acid."

/datum/reagent/consumable/ethanol/isloation_cell/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(!(current_cycle % 10)) //Every 10 cycles
		drinker.reagents.add_reagent(/datum/reagent/drug/aphrodisiac, 2)

/datum/reagent/consumable/ethanol/isloation_cell/morphine
	name = "Isolation Cell (Morphine)"
	description = "It has a distinct, sour smell, much like morphine."
	taste_description = "cloth dissolved in sulphuric acid. Something feels off about it."

/datum/reagent/consumable/ethanol/isloation_cell/morphine/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(!(current_cycle % 10)) //Every 10 cycles
		drinker.reagents.add_reagent_list(list(/datum/reagent/medicine/morphine = 2, /datum/reagent/consumable/ethanol/hippies_delight = 1))

/datum/reagent/consumable/ethanol/chemical_ex
	name = "Chemical Ex"
	description = "Date rape in a glass, a mixture courtesy of the Chief Witchdoctor. The stench of cigar smoke permeates the air wherever it goes."
	color = rgb(14, 14, 14)
	quality = DRINK_FANTASTIC
	taste_description = "ghost peppers, carbonated water and oil. Burns your tongue."

/datum/reagent/consumable/ethanol/chemical_ex/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(!(current_cycle % 10)) //Every 10 cycles
		drinker.reagents.add_reagent_list(list(/datum/reagent/drug/aphrodisiac/crocin/hexacrocin = 2, /datum/reagent/medicine/morphine = 4, /datum/reagent/mkultra = 1))

/datum/reagent/consumable/ethanol/heart_of_gold
	name = "Heart Of Gold"
	description = "The Captain's Ambrosia. Something about it just feels divine."
	boozepwr = 15
	color = "#fc56e6"
	quality = DRINK_FANTASTIC
	taste_description = "a fruit punch-like blend with a little fruity kick at the back of your throat, with an aftertaste of pineapple."

/datum/reagent/consumable/ethanol/moth_in_chief
	name = "Moth in Chief"
	description = "A simple yet elegant drink, inspires confidence in even the most pessimistic of men. The mantle rests well upon your shoulders."
	boozepwr = 50
	color = "#0919be"
	quality = DRINK_FANTASTIC
	taste_description = "fuzz, warmth and comfort"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//This drink gives the combined benefits of Stimulants, Regenerative Jelly, and Commander and Chief, and a mood buff similar to Copium; at least to an extent.
/datum/reagent/consumable/ethanol/moth_in_chief/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(drinker.mind && HAS_TRAIT(drinker, TRAIT_ROYAL_METABOLISM))
		drinker.heal_bodypart_damage(2,2,2)
		drinker.adjustBruteLoss(-5,0)
		drinker.adjustOxyLoss(-5,0)
		drinker.adjustFireLoss(-5,0)
		drinker.adjustToxLoss(-5,0,TRUE) //Heals Toxin Lovers
		//drinker.adjustRadLoss(-25)
		. = 1
	else
		//Commander and Chief Effects, no need to be captain to receive the effect
		drinker.heal_bodypart_damage(2,2,2)
		drinker.adjustBruteLoss(-3.5,0)
		drinker.adjustOxyLoss(-3.5,0)
		drinker.adjustFireLoss(-3.5,0)
		drinker.adjustToxLoss(-3.5,0,TRUE) //Heals Toxin Lovers
		//drinker.adjustRadLoss(-25)

	//Stimulant Effects
	drinker.AdjustAllImmobility(-60, FALSE)
	drinker.AdjustUnconscious(-60, FALSE)
	drinker.adjustStaminaLoss(-20*REAGENTS_EFFECT_MULTIPLIER, FALSE)

/datum/reagent/consumable/ethanol/skullfucker_deluxe
	name = "Skullfucker Deluxe"
	description = "The Rosewater secret to becoming psychotically retarded. It has many warning labels."
	boozepwr = 75
	color = "#cb4d8b"
	quality = DRINK_VERYGOOD
	taste_description = "being violated by a tiny fish with crayons"
	overdose_threshold = 25

/datum/reagent/consumable/ethanol/skullfucker_deluxe/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	//Do nothing if they haven't metabolized enough
	if(!current_cycle >= 15)
		return
	//Make them giggle
	if(prob(40))
		drinker.emote("giggle")
	//Make them jitter
	if(prob(20))
		drinker.set_jitter(50)

/* Doesn't seem to exist
/datum/reagent/consumable/ethanol/skullfucker_deluxe/overdose_process(mob/living/M)
	. = ..()
	//Do nothing if they're already fwuffy OwO
	var/obj/item/organ/tongue/T = M.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(istype(T, /obj/item/organ/tongue/fluffy))
		return

	//Replace their tongue with a fwuffy one
	var/obj/item/organ/tongue/nT = new /obj/item/organ/tongue/fluffy
	T.Remove(M, special = TRUE)
	nT.Insert(M, special = TRUE)
	qdel(T)
	to_chat(M, span_big_warning("Your tongue feels... weally fwuffy!!"))
*/

/datum/reagent/consumable/ethanol/ionstorm
	name = "Ion Storm"
	description = "A highly chaotic mixture that looks like it may react violently at any moment, but is surprisingly stable"
	color = "#3fd2ff"
	taste_description = "a scorching taste of strong alcohol and good brew going down your throat, making you feel warm inside"
	ph = 6.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	boozepwr = 30
	quality = DRINK_FANTASTIC

/datum/reagent/consumable/ethanol/ionstorm/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.adjustBruteLoss(-0.5,0)
	drinker.adjustFireLoss(-0.5,0)
	if (drinker.reagents.has_reagent(/datum/reagent/medicine/epinephrine))
		drinker.adjustToxLoss(0.25)
	else
		drinker.adjustOxyLoss(0.25)

/datum/reagent/consumable/ethanol/twinkjuice
	name = "Twink Juice"
	description = "A long slender fruity drink with a green thick liquid inside. It smells nice and, and probably tastes fruity."
	color = "#3fd2ff"
	taste_description = "a concoction of dubious origins, and dubious purposes"
	ph = 6.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	boozepwr = 5
	quality = DRINK_FANTASTIC
	var/drinkerWasAlreadySubmissive = FALSE

/datum/reagent/consumable/ethanol/twinkjuice/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	if (ishuman(affected_mob))
		if(affected_mob.client?.prefs.read_preference(/datum/preference/toggle/erp/aphro))
			affected_mob.log_message("drank [src], but ignored it due to aphrodisiac preference.", LOG_EMOTE)
			return

		if(!affected_mob.has_quirk(/datum/quirk/well_trained))
			affected_mob.log_message("is now under the effect of [src].", LOG_EMOTE)
			affected_mob.add_quirk(/datum/quirk/well_trained)
		else
			drinkerWasAlreadySubmissive = TRUE

/datum/reagent/consumable/ethanol/twinkjuice/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	if (ishuman(affected_mob))
		var/mob/living/carbon/human/M = affected_mob
		if(M.has_quirk(/datum/quirk/well_trained) && !drinkerWasAlreadySubmissive)
			M.log_message("is no longer under the effect of [src].", LOG_EMOTE)
			M.remove_quirk(/datum/quirk/well_trained)

/datum/reagent/consumable/ethanol/midnight_tears
	name = "Midnight Tears"
	description = "A reflection of what your Heart feels a weak call for love.\n-Leo Oxto"
	color = "#005DE9"
	taste_description = "the warm feeling of a hug"

/datum/reagent/consumable/ethanol/midnight_tears/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(ishuman(drinker))
		var/mob/living/carbon/human/H = drinker
		if(!H.dna || !H.dna.species)
			return
		var/obj/item/organ/tail/tail = H.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
		if(tail?.wag_flags & WAG_ABLE)
			H.emote("wag")

/datum/reagent/consumable/ethanol/midnight_sky
	name = "Midnight Sky"
	description = "An escape from all your troubles, may it help you find love and joy.\n-Leo Oxto"
	color = "#060709"
	taste_description = "a calm taste like the calm night"

/datum/reagent/consumable/ethanol/midnight_sky/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.adjustBruteLoss(-0.5)
	drinker.adjustFireLoss(-0.5)
	. = TRUE

/datum/reagent/consumable/ethanol/midnight_joy
	name = "Midnight Joy"
	description = "Be sure to spread this feeling, for some lack it in their life, be the reason they have a smile on their face.\n-Leo Oxto"
	color = "#FFF393"
	taste_description = "sweet joy"

/datum/reagent/consumable/ethanol/midnight_joy/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if (prob(7))
		drinker.emote("giggle")

//Donator items
/datum/reagent/consumable/ethanol/gem_grape_juice
	name = "Gem Brand Grape Juice"
	description = "The Gem Emporium's take on grape juice, providing a very healthy alternative with a kick described as 'Energizes you like a short rest!'"
	color = "#290029"
	taste_description = "Cool refreshing grapes with a hint of fruit"
	boozepwr = 15
	quality = DRINK_FANTASTIC
	metabolization_rate = 2 * REAGENTS_METABOLISM //0.4u per second
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/gem_grape_juice/on_mob_metabolize(mob/living/affected_mob) //Update this if bastion_bourbon is changed.
	. = ..()
	var/heal_points = 10
	if(affected_mob.health <= 0)
		heal_points = 20 //heal more if we're in softcrit
	var/need_mob_update
	var/heal_amt = min(volume, heal_points) //only heals 1 point of damage per unit on add, for balance reasons
	need_mob_update = affected_mob.adjustBruteLoss(-heal_amt, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += affected_mob.adjustFireLoss(-heal_amt, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += affected_mob.adjustToxLoss(-heal_amt, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += affected_mob.adjustOxyLoss(-heal_amt, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	// heal stamina loss on first metabolization, but only to a max of 20
	need_mob_update += affected_mob.adjustStaminaLoss(max(-heal_amt * 5, -20), updating_stamina = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		affected_mob.updatehealth()
	affected_mob.visible_message(span_warning("[affected_mob] shivers with renewed vigor!"), span_notice("One taste of [LOWER_TEXT(name)] fills you with energy!"))
	if(!affected_mob.stat && heal_points == 20) //brought us out of softcrit
		affected_mob.visible_message(span_danger("[affected_mob] lurches to [affected_mob.p_their()] feet!"), span_boldnotice("Up and at 'em, kid."))

//Donator items
/datum/reagent/consumable/ethanol/gem_grape_soda
	name = "Gem Brand Grape Soda"
	description = "The Gem Emporium's take on grape juice, providing a very healthy alternative with a kick described as 'Energizes you like a short rest!' Now carbonated!"
	color = "#290029"
	taste_description = "Cool refreshing grapes with a hint of fruit"
	boozepwr = 15
	quality = DRINK_FANTASTIC
	metabolization_rate = 2 * REAGENTS_METABOLISM //0.4u per second
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/gem_grape_soda/on_mob_metabolize(mob/living/affected_mob) //Update this if bastion_bourbon is changed.
	. = ..()
	var/heal_points = 10
	if(affected_mob.health <= 0)
		heal_points = 20 //heal more if we're in softcrit
	var/need_mob_update
	var/heal_amt = min(volume, heal_points) //only heals 1 point of damage per unit on add, for balance reasons
	need_mob_update = affected_mob.adjustBruteLoss(-heal_amt, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += affected_mob.adjustFireLoss(-heal_amt, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += affected_mob.adjustToxLoss(-heal_amt, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += affected_mob.adjustOxyLoss(-heal_amt, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	// heal stamina loss on first metabolization, but only to a max of 20
	need_mob_update += affected_mob.adjustStaminaLoss(max(-heal_amt * 5, -20), updating_stamina = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		affected_mob.updatehealth()
	affected_mob.visible_message(span_warning("[affected_mob] shivers with renewed vigor!"), span_notice("One taste of [LOWER_TEXT(name)] fills you with energy!"))
	if(!affected_mob.stat && heal_points == 20) //brought us out of softcrit
		affected_mob.visible_message(span_danger("[affected_mob] lurches to [affected_mob.p_their()] feet!"), span_boldnotice("Up and at 'em, kid."))
