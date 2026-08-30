/datum/unit_test/splurt_custom_mobs

/datum/unit_test/splurt_custom_mobs/Run()
	var/list/custom_mob_types = list(
		/mob/living/basic/deathclaw,
		/mob/living/basic/deathclaw/hostile,
		/mob/living/basic/deathclaw/hostile/alphaclaw,
		/mob/living/basic/deathclaw/funclaw,
		/mob/living/basic/deathclaw/funclaw/femclaw,
		/mob/living/basic/deathclaw/funclaw/femclaw/mommyclaw,
		/mob/living/basic/werewolf,
		/mob/living/basic/werewolf/hostile,
		/mob/living/basic/werewolf/hostile/icewolf,
		/mob/living/basic/werewolf/hostile/alphawolf,
		/mob/living/basic/werewolf/funwolf,
		/mob/living/basic/werewolf/funwolf/alpha,
		/mob/living/basic/werewolf/funwolf/bitch,
		/mob/living/basic/werewolf/funwolf/mosley,
		/mob/living/basic/werewolf/funwolf/hellhound,
		/mob/living/basic/werewolf/funwolf/hellhound/loona,
		/mob/living/basic/wendigo,
		/mob/living/basic/wendigo/hostile
	)
	for(var/mob_type in custom_mob_types)
		var/icon_file = initial(mob_type:icon)
		var/list/available_states = icon_states(icon_file, 1)
		var/living_state = initial(mob_type:icon_living)
		if(!living_state)
			living_state = initial(mob_type:icon_state)
		var/dead_state = initial(mob_type:icon_dead)
		TEST_ASSERT(living_state in available_states, "[mob_type] has missing living icon state '[living_state]'.")
		if(dead_state)
			TEST_ASSERT(dead_state in available_states, "[mob_type] has missing dead icon state '[dead_state]'.")

	var/mob/living/basic/deathclaw/funclaw/funclaw = allocate(/mob/living/basic/deathclaw/funclaw)
	var/mob/living/basic/deathclaw/hostile/alphaclaw/alphaclaw = allocate(/mob/living/basic/deathclaw/hostile/alphaclaw)
	var/mob/living/basic/deathclaw/funclaw/femclaw/femclaw = allocate(/mob/living/basic/deathclaw/funclaw/femclaw)
	var/mob/living/basic/werewolf/funwolf/funwolf = allocate(/mob/living/basic/werewolf/funwolf)
	var/mob/living/basic/wendigo/wendigo = allocate(/mob/living/basic/wendigo)
	var/datum/interaction/lewd/knotting_check = allocate(/datum/interaction/lewd)

	TEST_ASSERT(funclaw.has_penis(), "The docile Funclaw should expose its simulated penis to interactions.")
	TEST_ASSERT(funwolf.has_penis(), "The docile werewolf should preserve its existing simulated penis.")
	TEST_ASSERT(wendigo.has_penis(), "The custom wendigo should expose its legacy simulated penis.")
	TEST_ASSERT(wendigo.has_anus(), "The custom wendigo should expose its legacy simulated anus.")
	TEST_ASSERT(wendigo.has_breasts(), "The custom wendigo should expose its legacy simulated breasts.")
	TEST_ASSERT(wendigo.has_belly(), "The custom wendigo should expose its legacy simulated belly.")
	TEST_ASSERT(!wendigo.has_vagina(), "The custom wendigo should not gain anatomy absent from the original mob.")
	TEST_ASSERT(wendigo.simulated_genitals[ORGAN_SLOT_BUTT], "The custom wendigo should expose its legacy simulated butt.")
	TEST_ASSERT(HAS_TRAIT(wendigo, TRAIT_SNOWSTORM_IMMUNE), "The custom wendigo should retain its cold-weather adaptation.")

	TEST_ASSERT(knotting_check.knot_penis_type(funclaw), "Funclaws should be eligible for knotting interactions.")
	TEST_ASSERT(knotting_check.knot_penis_type(alphaclaw), "Alpha Funclaws should be eligible for knotting interactions.")
	TEST_ASSERT(knotting_check.knot_penis_type(funwolf), "Werewolves should remain eligible for knotting interactions.")
	TEST_ASSERT(!knotting_check.knot_penis_type(femclaw), "Variants without a penis should not be eligible for knotting interactions.")

	funclaw.set_arousal(AROUSAL_LOW)
	TEST_ASSERT_EQUAL(funclaw.icon_state, "newclaw_cocked", "Arousal should unsheathe a Funclaw.")
	TEST_ASSERT_EQUAL(funclaw.icon_living, "newclaw_cocked", "A Funclaw should preserve its unsheathed sprite across appearance refreshes.")
	funclaw.set_arousal(AROUSAL_MINIMUM)
	TEST_ASSERT_EQUAL(funclaw.icon_state, "newclaw", "A Funclaw should resheathe at zero arousal.")
	TEST_ASSERT_EQUAL(funclaw.icon_living, "newclaw", "A Funclaw should preserve its sheathed sprite across appearance refreshes.")

	alphaclaw.set_arousal(AROUSAL_LOW)
	TEST_ASSERT_EQUAL(alphaclaw.icon_state, "alphaclaw_cocked", "Arousal should unsheathe an Alpha Funclaw.")
	alphaclaw.set_arousal(AROUSAL_MINIMUM)
	TEST_ASSERT_EQUAL(alphaclaw.icon_state, "alphaclaw", "An Alpha Funclaw should resheathe at zero arousal.")

	femclaw.set_arousal(AROUSAL_LOW)
	TEST_ASSERT_EQUAL(femclaw.icon_state, "femclaw", "Arousal should not replace a female Funclaw with a male sprite.")
