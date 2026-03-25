// SPLURT EDIT ADDITION BEGIN - CURSEKIN_BEAST_CLOTHING - Allow cursekin beast form to wear bags, ID, radio, harness, and similar utility items.
// The beast form previously blocked ALL clothing/inventory slots. This override restores
// access to non-cosmetic utility slots so werewolves can keep their radio, ID, bag, etc.

/datum/species/cursekin/beast
	// Override inventory slots to allow utility equipment in beast form.
	// Allows: back (bag/harness), belt, ID badge, ears (radio headset), neck, and suit storage.
	// Cosmetic clothing slots (head, uniform, suit, gloves, shoes, mask) remain blocked
	// since they wouldn't fit or make sense on a beast form visually.
	species_inventory_slots = list(
		/datum/inventory_slot/back,
		/datum/inventory_slot/belt,
		/datum/inventory_slot/id,
		/datum/inventory_slot/ears,
		/datum/inventory_slot/neck,
		/datum/inventory_slot/suit_storage,
	)

// SPLURT EDIT ADDITION END