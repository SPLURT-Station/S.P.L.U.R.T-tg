SUBSYSTEM_DEF(interactions)
	name = "Interactions"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_INTERACTIONS
	var/list/datum/interaction/interactions
	var/list/genital_fluids_paths
	VAR_PROTECTED/list/blacklisted_mobs = list(
		/mob/dead,
		/mob/dview,
		/mob/eye/camera,
		/mob/living/basic/pet,
		/mob/living/basic/cockroach,
		/mob/living/basic/butterfly,
		/mob/living/basic/chick,
		/mob/living/basic/chicken,
		/mob/living/basic/cow,
		/mob/living/basic/crab,
		/mob/living/basic/kiwi,
		/mob/living/basic/parrot,
		/mob/living/basic/sloth,
		/mob/living/basic/goat
	)
	VAR_PROTECTED/initialized_blacklist

/datum/controller/subsystem/interactions/Initialize()
	prepare_interactions()
	prepare_blacklisted_mobs()
	prepare_genital_fluids()
	var/extra_info = "<font style='transform: translate(0%, -25%);'>↳</font> Loaded [LAZYLEN(interactions)] interactions!"
	to_chat(world, span_boldannounce(extra_info))
	log_config(extra_info)
	return SS_INIT_SUCCESS
	
/datum/controller/subsystem/interactions/stat_entry(msg)
	msg += "|🖐:[LAZYLEN(interactions)]|"
	msg += "🚫👨:[LAZYLEN(blacklisted_mobs)]"
	return ..()

/datum/controller/subsystem/interactions/proc/prepare_interactions()
	QDEL_LIST_ASSOC_VAL(interactions)
	QDEL_NULL(interactions)
	interactions = list()
	populate_interaction_instances()

/datum/controller/subsystem/interactions/proc/prepare_blacklisted_mobs()
	blacklisted_mobs = typecacheof(blacklisted_mobs)
	initialized_blacklist = TRUE

/datum/controller/subsystem/interactions/proc/is_blacklisted(mob/living/creature)
	if(!creature || !initialized_blacklist)
		return TRUE
	if(is_type_in_typecache(creature, blacklisted_mobs))
		return TRUE
	return FALSE

/datum/controller/subsystem/interactions/proc/prepare_genital_fluids()
	// Define disallowed reagents
	var/list/blacklisted = list(
		// Base ethanol
		/datum/reagent/consumable/ethanol,

		// Effect drinks
		/datum/reagent/consumable/ethanol/kahlua,
		/datum/reagent/consumable/ethanol/thirteenloko,
		/datum/reagent/consumable/ethanol/threemileisland,
		/datum/reagent/consumable/ethanol/absinthe,
		/datum/reagent/consumable/ethanol/hooch,
		/datum/reagent/consumable/ethanol/cuba_libre,
		/datum/reagent/consumable/ethanol/screwdrivercocktail,
		/datum/reagent/consumable/ethanol/bloody_mary,
		/datum/reagent/consumable/ethanol/tequila_sunrise,
		/datum/reagent/consumable/ethanol/toxins_special,
		/datum/reagent/consumable/ethanol/beepsky_smash,
		/datum/reagent/consumable/ethanol/manly_dorf,
		/datum/reagent/consumable/ethanol/manhattan_proj,
		/datum/reagent/consumable/ethanol/antifreeze,
		/datum/reagent/consumable/ethanol/barefoot,
		/datum/reagent/consumable/ethanol/sbiten,
		/datum/reagent/consumable/ethanol/iced_beer,
		/datum/reagent/consumable/ethanol/changelingsting,
		/datum/reagent/consumable/ethanol/syndicatebomb,
		/datum/reagent/consumable/ethanol/bananahonk,
		/datum/reagent/consumable/ethanol/silencer,
		/datum/reagent/consumable/ethanol/fetching_fizz,
		/datum/reagent/consumable/ethanol/hearty_punch,
		/datum/reagent/consumable/ethanol/atomicbomb,
		/datum/reagent/consumable/ethanol/gargle_blaster,
		/datum/reagent/consumable/ethanol/neurotoxin,
		/datum/reagent/consumable/ethanol/neurotoxin,
		/datum/reagent/consumable/ethanol/hippies_delight,
		/datum/reagent/consumable/ethanol/narsour,
		/* Not in this codebase
		/datum/reagent/consumable/ethanol/cogchamp,
		/datum/reagent/consumable/ethanol/pinotmort,
		*/
		/datum/reagent/consumable/ethanol/quadruple_sec,
		/datum/reagent/consumable/ethanol/quintuple_sec,
		/datum/reagent/consumable/ethanol/bastion_bourbon,
		/datum/reagent/consumable/ethanol/squirt_cider,
		/datum/reagent/consumable/ethanol/sugar_rush,
		/datum/reagent/consumable/ethanol/peppermint_patty,
		/datum/reagent/consumable/ethanol/alexander,
		/datum/reagent/consumable/ethanol/between_the_sheets,
		/datum/reagent/consumable/ethanol/fernet,
		/datum/reagent/consumable/ethanol/fernet_cola,
		/datum/reagent/consumable/ethanol/fanciulli,
		/datum/reagent/consumable/ethanol/branca_menta,
		/datum/reagent/consumable/ethanol/blank_paper,
		/datum/reagent/consumable/ethanol/wizz_fizz,
		/datum/reagent/consumable/ethanol/bug_spray,
		/datum/reagent/consumable/ethanol/turbo,
		/datum/reagent/consumable/ethanol/old_timer,
		/datum/reagent/consumable/ethanol/trappist,
		/datum/reagent/consumable/ethanol/blazaam,
		/datum/reagent/consumable/ethanol/mauna_loa,
		// /datum/reagent/consumable/ethanol/commander_and_chief,
		/datum/reagent/consumable/ethanol/hellfire,
		/datum/reagent/consumable/ethanol/hotlime_miami,
		/datum/reagent/consumable/ethanol/crevice_spike,
		/datum/reagent/consumable/ethanol/isloation_cell/morphine,
		/datum/reagent/consumable/ethanol/chemical_ex,
		/datum/reagent/consumable/ethanol/heart_of_gold,
		/datum/reagent/consumable/ethanol/moth_in_chief,
		/datum/reagent/consumable/ethanol/skullfucker_deluxe,
		/datum/reagent/consumable/ethanol/ionstorm,

		// Effect drink reagents
		/datum/reagent/consumable/poisonberryjuice,
		/datum/reagent/consumable/banana,
		/datum/reagent/consumable/nothing,
		/datum/reagent/consumable/laughter,
		/datum/reagent/consumable/superlaughter,
		/datum/reagent/consumable/doctor_delight,
		/datum/reagent/consumable/red_queen,
		/datum/reagent/consumable/catnip_tea,
		/datum/reagent/consumable/aloejuice,

		// Effect standard reagents
		/datum/reagent/consumable/nutriment/vitamin,
		/datum/reagent/consumable/sugar,
		/datum/reagent/consumable/capsaicin,
		/datum/reagent/consumable/frostoil,
		/datum/reagent/consumable/condensedcapsaicin,
		/datum/reagent/consumable/garlic,
		/datum/reagent/consumable/sprinkles,
		/datum/reagent/consumable/hot_ramen,
		/datum/reagent/consumable/hell_ramen,
		/datum/reagent/consumable/corn_syrup,
		/datum/reagent/consumable/honey,
		/datum/reagent/consumable/tearjuice,
		/datum/reagent/consumable/entpoly,
		/datum/reagent/consumable/vitfro,
		/datum/reagent/consumable/liquidelectricity,
		/datum/reagent/consumable/char,
		/datum/reagent/consumable/secretsauce,
		/datum/reagent/consumable/enzyme
	)

	// Define base list
	var/list/consumable_list = subtypesof(/datum/reagent/consumable)

	// Define additional allowed reagents
	var/list/whitelist_list = list(
		// Just water
		/datum/reagent/water,

		// Causes arousal
		// Allowed for ERP reasons
		/datum/reagent/drug/aphrodisiac/crocin,
		/datum/reagent/drug/aphrodisiac/crocin/hexacrocin,

		// Allowed for expansion reasons
		/datum/reagent/drug/aphrodisiac/belly_enlarger,
		/datum/reagent/drug/aphrodisiac/butt_enlarger,
		/datum/reagent/drug/aphrodisiac/incubus_draft,
		/datum/reagent/drug/aphrodisiac/succubus_milk,

		// Causes positive mood bonus
		// On overdose: Causes negative mood penalty and disgust
		/datum/reagent/drug/copium,

		// Restores blood volume
		/datum/reagent/blood
	)

	// Add whitelisted entries to main list
	LAZYADD(consumable_list, whitelist_list)

	// Define final list
	var/list/reagent_list_paths

	for(var/reagent in consumable_list)
		// Check if reagent is blacklisted
		if(reagent in blacklisted)
			// Ignore reagent
			continue

		// Add reagent to type list
		LAZYADD(reagent_list_paths, reagent)

	// Store paths list
	var/list/fluid_paths = list()

	for(var/reagent_path in reagent_list_paths)
		var/datum/reagent/R = reagent_path
		fluid_paths[initial(R.name)] = reagent_path

	genital_fluids_paths = fluid_paths
