/// Tests that no new simple_animal subtypes are added.
/datum/unit_test/simple_animal_freeze
	// !!! DO NOT ADD NEW ENTRIES TO THIS LIST !!!
	// NO new simple animals are allowed.
	// Use the new basic mobs system instead.
	// If you are refactoring a simple_animal, REMOVE it from this list
	var/list/allowed_types = list(
		/mob/living/simple_animal/bot,
		/mob/living/simple_animal/bot/mulebot,
		/mob/living/simple_animal/bot/mulebot/paranormal,
		/mob/living/simple_animal/bot/secbot,
		/mob/living/simple_animal/bot/secbot/beepsky,
		/mob/living/simple_animal/bot/secbot/beepsky/armsky,
		/mob/living/simple_animal/bot/secbot/beepsky/jr,
		/mob/living/simple_animal/bot/secbot/beepsky/officer,
		/mob/living/simple_animal/bot/secbot/beepsky/ofitser,
		/mob/living/simple_animal/bot/secbot/ed209,
		/mob/living/simple_animal/bot/secbot/genesky,
		/mob/living/simple_animal/bot/secbot/grievous,
		/mob/living/simple_animal/bot/secbot/grievous/toy,
		/mob/living/simple_animal/bot/secbot/pingsky,
		/mob/living/simple_animal/hostile,
		/mob/living/simple_animal/hostile/asteroid,
		/mob/living/simple_animal/hostile/asteroid/elite,
		/mob/living/simple_animal/hostile/asteroid/elite/broodmother,
		/mob/living/simple_animal/hostile/asteroid/elite/broodmother_child,
		/mob/living/simple_animal/hostile/asteroid/elite/herald,
		/mob/living/simple_animal/hostile/asteroid/elite/herald/mirror,
		/mob/living/simple_animal/hostile/asteroid/elite/legionnaire,
		/mob/living/simple_animal/hostile/asteroid/elite/legionnairehead,
		/mob/living/simple_animal/hostile/asteroid/elite/pandora,
		/mob/living/simple_animal/hostile/asteroid/polarbear,
		/mob/living/simple_animal/hostile/asteroid/polarbear/lesser,
		/mob/living/simple_animal/hostile/illusion,
		/mob/living/simple_animal/hostile/illusion/escape,
		/mob/living/simple_animal/hostile/illusion/mirage,
		/mob/living/simple_animal/hostile/megafauna,
		/mob/living/simple_animal/hostile/megafauna/blood_drunk_miner,
		/mob/living/simple_animal/hostile/megafauna/blood_drunk_miner/doom,
		/mob/living/simple_animal/hostile/megafauna/blood_drunk_miner/guidance,
		/mob/living/simple_animal/hostile/megafauna/blood_drunk_miner/hunter,
		/mob/living/simple_animal/hostile/megafauna/bubblegum,
		/mob/living/simple_animal/hostile/megafauna/bubblegum/hallucination,
		/mob/living/simple_animal/hostile/megafauna/clockwork_defender,
		/mob/living/simple_animal/hostile/megafauna/colossus,
		/mob/living/simple_animal/hostile/megafauna/demonic_frost_miner,
		/mob/living/simple_animal/hostile/megafauna/dragon,
		/mob/living/simple_animal/hostile/megafauna/dragon/lesser,
		/mob/living/simple_animal/hostile/megafauna/hierophant,
		/mob/living/simple_animal/hostile/megafauna/legion,
		/mob/living/simple_animal/hostile/megafauna/legion/medium,
		/mob/living/simple_animal/hostile/megafauna/legion/medium/eye,
		/mob/living/simple_animal/hostile/megafauna/legion/medium/left,
		/mob/living/simple_animal/hostile/megafauna/legion/medium/right,
		/mob/living/simple_animal/hostile/megafauna/legion/small,
		/mob/living/simple_animal/hostile/megafauna/wendigo,
		/mob/living/simple_animal/hostile/megafauna/wendigo/noportal,
		/mob/living/simple_animal/hostile/ooze,
		/mob/living/simple_animal/hostile/ooze/gelatinous,
		/mob/living/simple_animal/hostile/ooze/grapes,

		// MODULAR SKYRAT ENTRIES
		// PLEASE REFACTOR THESE AS YOU CAN
		/mob/living/simple_animal/hostile/bigcrab,
		/mob/living/simple_animal/hostile/blackmesa,
		/mob/living/simple_animal/hostile/blackmesa/blackops,
		/mob/living/simple_animal/hostile/blackmesa/blackops/ranged,
		/mob/living/simple_animal/hostile/blackmesa/hecu,
		/mob/living/simple_animal/hostile/blackmesa/hecu/ranged,
		/mob/living/simple_animal/hostile/blackmesa/hecu/ranged/smg,
		/mob/living/simple_animal/hostile/blackmesa/sec,
		/mob/living/simple_animal/hostile/blackmesa/sec/ranged,
		/mob/living/simple_animal/hostile/blackmesa/xen,
		/mob/living/simple_animal/hostile/blackmesa/xen/bullsquid,
		/mob/living/simple_animal/hostile/blackmesa/xen/headcrab,
		/mob/living/simple_animal/hostile/blackmesa/xen/headcrab/fast,
		/mob/living/simple_animal/hostile/blackmesa/xen/headcrab_zombie,
		/mob/living/simple_animal/hostile/blackmesa/xen/headcrab_zombie/gordon_freeman,
		/mob/living/simple_animal/hostile/blackmesa/xen/headcrab_zombie/guard,
		/mob/living/simple_animal/hostile/blackmesa/xen/headcrab_zombie/hecu,
		/mob/living/simple_animal/hostile/blackmesa/xen/headcrab_zombie/hev,
		/mob/living/simple_animal/hostile/blackmesa/xen/headcrab_zombie/scientist,
		/mob/living/simple_animal/hostile/blackmesa/xen/houndeye,
		/mob/living/simple_animal/hostile/blackmesa/xen/nihilanth,
		/mob/living/simple_animal/hostile/blackmesa/xen/vortigaunt,
		/mob/living/simple_animal/hostile/blackmesa/xen/vortigaunt/slave,
		/mob/living/simple_animal/hostile/cazador,
		/mob/living/simple_animal/hostile/cult,
		/mob/living/simple_animal/hostile/cult/assassin,
		/mob/living/simple_animal/hostile/cult/ghost,
		/mob/living/simple_animal/hostile/cult/horror,
		/mob/living/simple_animal/hostile/cult/magic,
		/mob/living/simple_animal/hostile/cult/magic/elite,
		/mob/living/simple_animal/hostile/cult/mannequin,
		/mob/living/simple_animal/hostile/cult/spear,
		/mob/living/simple_animal/hostile/cult/warrior,
		/mob/living/simple_animal/hostile/devourdem,
		/mob/living/simple_animal/hostile/engorge,
		/mob/living/simple_animal/hostile/evilborg,
		/mob/living/simple_animal/hostile/evilborg/bigguy,
		/mob/living/simple_animal/hostile/evilborg/dog,
		/mob/living/simple_animal/hostile/evilborg/dogstrong,
		/mob/living/simple_animal/hostile/evilborg/engi,
		/mob/living/simple_animal/hostile/evilborg/heavy,
		/mob/living/simple_animal/hostile/evilborg/peace,
		/mob/living/simple_animal/hostile/evilborg/protect,
		/mob/living/simple_animal/hostile/evilborg/roomba,
		/mob/living/simple_animal/hostile/evilborg/sec,
		/mob/living/simple_animal/hostile/looter,
		/mob/living/simple_animal/hostile/looter/big,
		/mob/living/simple_animal/hostile/looter/crusher,
		/mob/living/simple_animal/hostile/looter/ranged,
		/mob/living/simple_animal/hostile/looter/ranged/space,
		/mob/living/simple_animal/hostile/looter/ranged/space/laser,
		/mob/living/simple_animal/hostile/megafauna/bubblegum/no_gps,
		/mob/living/simple_animal/hostile/megafauna/gladiator,
		/mob/living/simple_animal/hostile/megafauna/hierophant/astrum,
		/mob/living/simple_animal/hostile/mutantliz,
		/mob/living/simple_animal/hostile/plantmutant,
		/mob/living/simple_animal/hostile/scorpion,
		/mob/living/simple_animal/hostile/syndimouse,
		/mob/living/simple_animal/hostile/trog,
		/mob/living/simple_animal/hostile/true_changeling,
		/mob/living/simple_animal/hostile/vox,
		/mob/living/simple_animal/hostile/vox/melee,
		/mob/living/simple_animal/hostile/vox/ranged,
		/mob/living/simple_animal/hostile/vox/ranged/laser,
		/mob/living/simple_animal/hostile/vox/ranged/space,
		/mob/living/simple_animal/hostile/vox/ranged/space/laser,

		// DO NOT ADD NEW ENTRIES TO THIS LIST
		// READ THE COMMENT ABOVE
	)

/datum/unit_test/simple_animal_freeze/Run()
	var/list/seen = list()

	// Sanity check, to prevent people from just doing a mass find and replace
	for (var/allowed_type in allowed_types)
		if (allowed_type in seen)
			TEST_FAIL("[allowed_type] is in the allowlist more than once")
		else
			seen[allowed_type] = TRUE

		TEST_ASSERT(ispath(allowed_type, /mob/living/simple_animal), "[allowed_type] is not a simple_animal. Remove it from the list.")

	for (var/subtype in subtypesof(/mob/living/simple_animal))
		if (!(subtype in allowed_types))
			TEST_FAIL("No new simple_animal subtypes are allowed. Please refactor [subtype] into a basic mob.")
