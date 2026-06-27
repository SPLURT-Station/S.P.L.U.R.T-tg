// Silver banes werewolves
// Fun fact; Bubber already made this happen versus Bloodsuckers

// Also considered: Making silver items harm Lycanthropes when picked up. Had difficulty implementing, and after thought, decided against; you can literally bane them
// with a bar of the stuff, and I think it would be kind of unintuitive and really annoying if there was an item technically made WITH silver you couldn't carry.

/datum/material/silver/on_applied(atom/source, amount, material_flags)
	. = ..()
	if (!isitem(source)) // and what are we going to do, bane a fucking operating table?
		return

	source.AddElement(/datum/element/bane, target_type = /datum/species/lycan, damage_multiplier = 1) // high bane; making up for natural armor
	source.AddElement(/datum/element/bane, target_type = /datum/species/human/cursekin, damage_multiplier = 0.35)


/datum/material/silver/on_removed(atom/source, amount, material_flags)
	. = ..()

	if (!isitem(source)) // and what are we going to do, unbane a fucking operating table?
		return

	source.RemoveElement(/datum/element/bane, target_type = /datum/species/lycan, damage_multiplier = 1)
	source.RemoveElement(/datum/element/bane, target_type = /datum/species/human/cursekin, damage_multiplier = 0.35)
