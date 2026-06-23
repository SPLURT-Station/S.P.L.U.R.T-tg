/datum/reagent/toxin/khara
	name = "Споры Кхара"
	description = "Микроскопические биоинженерные споры внеземного происхождения. Они агрессивно колонизируют \
					органические ткани, вызывая стремительный рост опухолеподобных образований, которые в итоге рождают новую хищную форму жизни."
	color = COLOR_MAROON
	taste_description = "горькое железо и гниль"
	taste_mult = 1.4
	chemical_flags = REAGENT_IGNORE_STASIS | REAGENT_INVISIBLE | REAGENT_DEAD_PROCESS
	metabolization_rate = REAGENTS_METABOLISM * 4
	toxpwr = 0
	liver_damage_multiplier = 0
	silent_toxin = TRUE
	penetrates_skin = VAPOR | INHALE

/datum/reagent/toxin/khara/expose_mob(mob/living/exposed_mob, methods, reac_volume, show_message, touch_protection)
	. = ..()
	if(!(exposed_mob.mob_biotypes & MOB_ORGANIC))
		return

	if(is_khara_creature(exposed_mob))
		exposed_mob.heal_overall_damage(2, 2, 2)
	else
		if(exposed_mob.get_brute_loss() >= 200)
			return

		if(ishuman(exposed_mob))
			var/mob/living/carbon/human/human = exposed_mob
			var/obj/item/clothing/suit = human.wear_suit
			var/obj/item/clothing/head = human.head

			if(suit && head)
				var/total_prot = (suit.get_armor_rating(BIO) + head.get_armor_rating(BIO))
				if(total_prot >= 80)
					return

		exposed_mob.take_overall_damage(2)

/datum/reagent/toxin/khara/metabolize_reagent(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()

	if(!(affected_mob.bodytype & BODYTYPE_ORGANIC))
		return

	if(is_khara_creature(affected_mob))
		var/heal = 3 * seconds_per_tick
		affected_mob.heal_overall_damage(heal, heal, heal)
		return

	if(SPT_PROB(10, seconds_per_tick))
		affected_mob.emote("cough")

	if(SPT_PROB(2, seconds_per_tick))
		affected_mob.vomit(MOB_VOMIT_MESSAGE)

	var/infect_chance = 7
	if(affected_mob.reagents.has_reagent(/datum/reagent/medicine/spaceacillin))
		infect_chance *= 0.5

	if(SPT_PROB(infect_chance, seconds_per_tick))
		affected_mob.ForceContractDisease(new /datum/disease/khara(), del_on_fail = TRUE)
