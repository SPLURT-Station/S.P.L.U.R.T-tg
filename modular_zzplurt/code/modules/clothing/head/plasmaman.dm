/// Cosmetic Envirohelmets
/// Black Envirohelm, renamed Chaplain suit

/obj/item/clothing/head/helmet/space/plasmaman/black
	name = "black plasma envirosuit helmet"
	desc = "A special black containment helmet that allows plasma-based lifeforms to exist safely in an oxygenated environment. It is space-worthy, and may be worn in tandem with other EVA gear."
	icon = 'icons/obj/clothing/head/plasmaman_hats.dmi'
	icon_state = "chap_envirohelm"

/// Khaki Envirohelm, renamed Miner suit

/obj/item/clothing/head/helmet/space/plasmaman/khaki
	name = "khaki plasma envirosuit helmet"
	desc = "A special khaki containment helmet that allows plasma-based lifeforms to exist safely in an oxygenated environment. It is space-worthy, and may be worn in tandem with other EVA gear."
	icon = 'icons/obj/clothing/head/plasmaman_hats.dmi'
	icon_state = "explorer_envirohelm"

/// Prototype Envirohelm, renamed Curator suit

/obj/item/clothing/head/helmet/space/plasmaman/prototype
	name = "prototype plasma envirosuit helmet"
	desc = "A slight modification on a traditional voidsuit helmet, this helmet was Nanotrasen's first solution to the *logistical problems* that come with employing plasmamen. Despite their limitations, these helmets still see use by historians and old-skool plasmamen alike."
	icon = 'icons/obj/clothing/head/plasmaman_hats.dmi'
	icon_state = "prototype_envirohelm"
	actions_types = list(/datum/action/item_action/toggle_welding_screen) // removes flashlight functionality, as curator suit lacks one
