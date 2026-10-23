/datum/reagent/drug/aphrodisiac/dopamine
	name = "Dopamine"
	description = "A benzene ring with two hydroxyl side groups, and one amine group attached via an ethyl chain. Moderates pleasure and reward-motivated behavior in mammals."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED | REAGENT_NO_RANDOM_RECIPE

/datum/chemical_reaction/dopamine
	results = list(/datum/reagent/drug/aphrodisiac/dopamine = 10)
	required_reagents = list(
		/datum/reagent/diethylamine = 1,
		/datum/reagent/medicine/ephedrine = 1,
		/datum/reagent/hydrogen = 2,
		/datum/reagent/phenol = 3
	)
	required_temp = 373
	mix_message = "The solution bubbles into a colorless liquid..."
	erp_reaction = TRUE
	reaction_tags = REACTION_TAG_CHEMICAL | REACTION_TAG_EASY | REACTION_TAG_DRUG
