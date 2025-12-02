/*
MARKINGS - HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT
*/

/datum/body_marking/other/splurt
	icon = 'modular_zzplurt/icons/mob/sprite_accessories/markings_primary.dmi'
	default_color = DEFAULT_PRIMARY

/datum/body_marking/secondary/splurt
	icon = 'modular_zzplurt/icons/mob/sprite_accessories/markings_secondary.dmi'
	default_color = DEFAULT_SECONDARY

/datum/body_marking/tertiary/splurt
	icon = 'modular_zzplurt/icons/mob/sprite_accessories/markings_tertiary.dmi'
	default_color = DEFAULT_TERTIARY

/// ABS
/datum/body_marking_set/abs
	name = "Abs"
	body_marking_list = list("Abs")

/datum/body_marking/other/splurt/abs
	name = "Abs"
	icon_state = "abs"
	affected_bodyparts = CHEST | HEAD

/// ABS Belly
/datum/body_marking_set/abs_belly
	name = "Abs Belly"
	body_marking_list = list("Abs Belly", "Abs Belly 2 Layer")

//
/datum/body_marking/other/splurt/abs_belly
	name = "Abs Belly"
	icon_state = "absbelly"
	affected_bodyparts = CHEST | HEAD

/datum/body_marking/secondary/splurt/abs_belly
	name = "Abs Belly 2 Layer"
	icon_state = "absbelly"
	affected_bodyparts = CHEST

/// ABS Arms
/datum/body_marking_set/abs_arms
	name = "Abs Arms"
	body_marking_list = list("Abs Arms", "Abs Arms 2 Layer", "Abs Arms 3 Layer")

/datum/body_marking/other/splurt/abs_arms
	name = "Abs Arms"
	icon_state = "absarms"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT

/datum/body_marking/secondary/splurt/abs_arms
	name = "Abs Arms 2 Layer"
	icon_state = "absarms"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT

/datum/body_marking/tertiary/splurt/abs_arms
	name = "Abs Arms 3 Layer"
	icon_state = "absarms"
	affected_bodyparts = HAND_RIGHT | HAND_LEFT | ARM_RIGHT | ARM_LEFT

/// Pigeon
/datum/body_marking_set/pigeon
	name = "Pigeon"
	body_marking_list = list("Pigeon", "Pigeon 2 Layer", "Pigeon 3 Layer")

/datum/body_marking/other/splurt/pigeon
	name = "Pigeon"
	icon_state = "pigeon"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT

/datum/body_marking/secondary/splurt/pigeon
	name = "Pigeon 2 Layer"
	icon_state = "pigeon"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT

/datum/body_marking/tertiary/splurt/pigeon
	name = "Pigeon 3 Layer"
	icon_state = "pigeon"
	affected_bodyparts = ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT

/// Shrike
/datum/body_marking_set/shrike
	name = "Shrike"
	body_marking_list = list("Shrike", "Shrike 2 Layer", "Shrike 3 Layer")

/datum/body_marking/other/splurt/shrike
	name = "Shrike"
	icon_state = "shrike"
	affected_bodyparts = ARM_LEFT | ARM_RIGHT

/datum/body_marking/secondary/splurt/shrike
	name = "Shrike 2 Layer"
	icon_state = "shrike"
	affected_bodyparts = ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT

/datum/body_marking/tertiary/splurt/shrike
	name = "Shrike 3 Layer"
	icon_state = "shrike"
	affected_bodyparts = CHEST | HEAD

/// Moth
/datum/body_marking_set/moth
	name = "Moth"
	body_marking_list = list("Moth", "Moth 2 Layer", "Moth 3 Layer")

/datum/body_marking/other/splurt/moth
	name = "Moth"
	icon_state = "moth"
	affected_bodyparts = CHEST

/datum/body_marking/secondary/splurt/moth
	name = "Moth 2 Layer"
	icon_state = "moth"
	affected_bodyparts = CHEST

/datum/body_marking/tertiary/splurt/moth
	name = "Moth 3 Layer"
	icon_state = "moth"
	affected_bodyparts = HEAD

/// Bee
/datum/body_marking_set/bee
	name = "Bee"
	body_marking_list = list("Bee", "Bee 2 Layer", "Bee 3 Layer")

/datum/body_marking/other/splurt/bee
	name = "Bee"
	icon_state = "bee"
	affected_bodyparts = CHEST

/datum/body_marking/secondary/splurt/bee
	name = "Bee 2 Layer"
	icon_state = "bee"
	affected_bodyparts = CHEST

/datum/body_marking/tertiary/splurt/bee
	name = "Bee 3 Layer"
	icon_state = "bee"
	affected_bodyparts = CHEST

/// Bee Fluff
/datum/body_marking_set/bee_fluff
	name = "Bee Fluff"
	body_marking_list = list("Bee Fluff", "Bee Fluff 2 Layer", "Bee Fluff 3 Layer")

/datum/body_marking/other/splurt/bee_fluff
	name = "Bee Fluff"
	icon_state = "bee_fluff"
	affected_bodyparts = CHEST

/datum/body_marking/secondary/splurt/bee_fluff
	name = "Bee Fluff 2 Layer"
	icon_state = "bee_fluff"
	affected_bodyparts = CHEST

/datum/body_marking/tertiary/splurt/bee_fluff
	name = "Bee Fluff 3 Layer"
	icon_state = "bee_fluff"
	affected_bodyparts = CHEST

/// Bug 3 Tone
/datum/body_marking_set/bug3tone
	name = "Bug 3 Tone"
	body_marking_list = list("Bug 3 Tone", "Bug 3 Tone 2 Layer", "Bug 3 Tone 3 Layer")

/datum/body_marking/other/splurt/bug3tone
	name = "Bug 3 Tone"
	icon_state = "bug3tone"
	affected_bodyparts = CHEST

/datum/body_marking/secondary/splurt/bug3tone
	name = "Bug 3 Tone 2 Layer"
	icon_state = "bug3tone"
	affected_bodyparts = CHEST

/datum/body_marking/tertiary/splurt/bug3tone
	name = "Bug 3 Tone 3 Layer"
	icon_state = "bug3tone"
	affected_bodyparts = CHEST

/// Gloss
/datum/body_marking_set/gloss
	name = "Gloss"
	body_marking_list = list("Gloss", "Gloss 2 Layer", "Gloss 3 Layer")

/datum/body_marking/other/splurt/gloss
	name = "Gloss"
	icon_state = "gloss"
	affected_bodyparts = HEAD | CHEST

/datum/body_marking/secondary/splurt/gloss
	name = "Gloss 2 Layer"
	icon_state = "gloss"
	affected_bodyparts = CHEST | HEAD

/datum/body_marking/tertiary/splurt/gloss
	name = "Gloss 3 Layer"
	icon_state = "gloss"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

//
/datum/body_marking_set/chemlight
	name = "Chemlight"
	body_marking_list = list("Chemlight", "Chemlight 2 Layer", "Chemlight 3 Layer")

/datum/body_marking/other/splurt/chemlight
	name = "Chemlight"
	icon_state = "chemlight"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/splurt/chemlight
	name = "Chemlight 2 Layer"
	icon_state = "chemlight"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/splurt/chemlight
	name = "Chemlight 3 Layer"
	icon_state = "chemlight"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/// Easternd
/datum/body_marking_set/easternd
	name = "Eastern Dragon"
	body_marking_list = list("Eastern Dragon", "Eastern Dragon 2 Layer", "Eastern Dragon 3 Layer")

/datum/body_marking/other/splurt/easternd
	name = "Eastern Dragon"
	icon_state = "easternd"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/splurt/easternd
	name = "Eastern Dragon 2 Layer"
	icon_state = "easternd"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT

/datum/body_marking/tertiary/splurt/easternd
	name = "Eastern Dragon 3 Layer"
	icon_state = "easternd"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/// Raccoon (Alt)
/datum/body_marking_set/raccalt
	name = "Raccoon"
	body_marking_list = list("Raccoon", "Raccoon 2 Layer", "Raccoon 3 Layer")

/datum/body_marking/other/splurt/raccalt
	name = "Raccoon"
	icon_state = "raccalt"
	affected_bodyparts = HEAD | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/splurt/raccalt
	name = "Raccoon 2 Layer"
	icon_state = "raccalt"
	affected_bodyparts = HEAD

/datum/body_marking/tertiary/splurt/raccalt
	name = "Raccoon 3 Layer"
	icon_state = "raccalt"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/// Floof
/datum/body_marking_set/floof
	name = "Floof"
	body_marking_list = list("Floof", "Floof 2 Layer", "Floof 3 Layer")

/datum/body_marking/other/splurt/floof
	name = "Floof"
	icon_state = "floof"
	affected_bodyparts = CHEST

/datum/body_marking/secondary/splurt/floof
	name = "Floof 2 Layer"
	icon_state = "floof"
	affected_bodyparts = CHEST

/datum/body_marking/tertiary/splurt/floof
	name = "Floof 3 Layer"
	icon_state = "floof"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/// Noodle Dragon
/datum/body_marking_set/noodledragon
	name = "Noodle Dragon"
	body_marking_list = list("Noodle Dragon", "Noodle Dragon 2 Layer", "Noodle Dragon 3 Layer")

/datum/body_marking/other/splurt/noodledragon
	name = "Noodle Dragon"
	icon_state = "noodledragon"
	affected_bodyparts = CHEST

/datum/body_marking/secondary/splurt/noodledragon
	name = "Noodle Dragon 2 Layer"
	icon_state = "noodledragon"
	affected_bodyparts = CHEST

/datum/body_marking/tertiary/splurt/noodledragon
	name = "Noodle Dragon 3 Layer"
	icon_state = "noodledragon"
	affected_bodyparts = CHEST

/// Owl Barn
/datum/body_marking_set/owlbarn
	name = "Owl Barn"
	body_marking_list = list("Owl Barn", "Owl Barn 2 Layer", "Owl Barn 3 Layer")

/datum/body_marking/other/splurt/owlbarn
	name = "Owl Barn"
	icon_state = "owlbarn"
	affected_bodyparts = HEAD

/datum/body_marking/secondary/splurt/owlbarn
	name = "Owl Barn 2 Layer"
	icon_state = "owlbarn"
	affected_bodyparts = HEAD

/datum/body_marking/tertiary/splurt/owlbarn
	name = "Owl Barn 3 Layer"
	icon_state = "owlbarn"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/// Owl Horned
/datum/body_marking_set/owlhorned
	name = "Owl Horned"
	body_marking_list = list("Owl Horned", "Owl Horned 2 Layer", "Owl Horned 3 Layer")

/datum/body_marking/other/splurt/owlhorned
	name = "Owl Horned"
	icon_state = "owlhorned"
	affected_bodyparts = HEAD

/datum/body_marking/secondary/splurt/owlhorned
	name = "Owl Horned 2 Layer"
	icon_state = "owlhorned"
	affected_bodyparts = HEAD

/datum/body_marking/tertiary/splurt/owlhorned
	name = "Owl Horned 3 Layer"
	icon_state = "owlhorned"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/// Toe Claws
/datum/body_marking_set/toeclaws
	name = "Toe Claws"
	body_marking_list = list("Toe Claws", "Toe Claws 2 Layer", "Toe Claws 3 Layer")

/datum/body_marking/other/splurt/toeclaws
	name = "Toe Claws"
	icon_state = "toeclaws"
	affected_bodyparts = LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/splurt/toeclaws
	name = "Toe Claws 2 Layer"
	icon_state = "toeclaws"
	affected_bodyparts = LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/splurt/toeclaws
	name = "Toe Claws 3 Layer"
	icon_state = "toeclaws"
	affected_bodyparts = LEG_RIGHT | LEG_LEFT

/// Deoxys
/datum/body_marking_set/deoxys
	name = "Deoxys"
	body_marking_list = list("Deoxys", "Deoxys 2 Layer", "Deoxys 3 Layer")

/datum/body_marking/other/splurt/deoxys
	name = "Deoxys"
	icon_state = "deoxys"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT

/datum/body_marking/secondary/splurt/deoxys
	name = "Deoxys 2 Layer"
	icon_state = "deoxys"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT

/datum/body_marking/tertiary/splurt/deoxys
	name = "Deoxys 3 Layer"
	icon_state = "deoxys"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT
/// Sloog
/datum/body_marking_set/sloog
	name = "Sloog"
	body_marking_list = list("Sloog", "Sloog 2 Layer", "Sloog 3 Layer")

/datum/body_marking/other/splurt/sloog
	name = "Sloog"
	icon_state = "sloog"
	affected_bodyparts = CHEST

/datum/body_marking/secondary/splurt/sloog
	name = "Sloog 2 Layer"
	icon_state = "sloog"
	affected_bodyparts = CHEST

/datum/body_marking/tertiary/splurt/sloog
	name = "Sloog 3 Layer"
	icon_state = "sloog"
	affected_bodyparts = CHEST

/// Pilot Jaw
/datum/body_marking_set/pilot_jaw
	name = "Pilot Jaw"
	body_marking_list = list("Pilot Jaw", "Pilot Jaw 2 Layer", "Pilot Jaw 3 Layer")

/datum/body_marking/other/splurt/pilot_jaw
	name = "Pilot Jaw"
	icon_state = "pilot_jaw"
	affected_bodyparts = HEAD

/datum/body_marking/secondary/splurt/pilot_jaw
	name = "Pilot Jaw 2 Layer"
	icon_state = "pilot_jaw"
	affected_bodyparts = HEAD

/datum/body_marking/tertiary/splurt/pilot_jaw
	name = "Pilot Jaw 3 Layer"
	icon_state = "pilot_jaw"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/// Pilot
/datum/body_marking_set/pilot
	name = "Pilot"
	body_marking_list = list("Pilot", "Pilot 2 Layer", "Pilot 3 Layer")

/datum/body_marking/other/splurt/pilot
	name = "Pilot"
	icon_state = "pilot"
	affected_bodyparts = HEAD

/datum/body_marking/secondary/splurt/pilot
	name = "Pilot 2 Layer"
	icon_state = "pilot"
	affected_bodyparts = HEAD

/datum/body_marking/tertiary/splurt/pilot
	name = "Pilot 3 Layer"
	icon_state = "pilot"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/// Renamon
/datum/body_marking_set/renamon
	name = "Renamon"
	body_marking_list = list("Renamon", "Renamon 2 Layer", "Renamon 3 Layer")

/datum/body_marking/other/splurt/renamon
	name = "Renamon"
	icon_state = "renamon"
	affected_bodyparts = HEAD | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/splurt/renamon
	name = "Renamon 2 Layer"
	icon_state = "renamon"
	affected_bodyparts = HEAD

/datum/body_marking/tertiary/splurt/renamon
	name = "Renamon 3 Layer"
	icon_state = "renamon"
	affected_bodyparts = HEAD | LEG_RIGHT | LEG_LEFT

/// Succubus Tattoo
/datum/body_marking_set/succubustattoo
	name = "Succubus Tattoo"
	body_marking_list = list("Succubus Tattoo", "Succubus Tattoo 2 Layer", "Succubus Tattoo 3 Layer")

/datum/body_marking/other/splurt/succubustattoo
	name = "Succubus Tattoo"
	icon_state = "succubustattoo"
	affected_bodyparts = CHEST

/datum/body_marking/secondary/splurt/succubustattoo
	name = "Succubus Tattoo 2 Layer"
	icon_state = "succubustattoo"
	affected_bodyparts = CHEST

/datum/body_marking/tertiary/splurt/succubustattoo
	name = "Succubus Tattoo 3 Layer"
	icon_state = "succubustattoo"
	affected_bodyparts = CHEST

/// Coloured Lips
/datum/body_marking_set/colouredlips
	name = "Coloured Lips"
	body_marking_list = list("Coloured Lips", "Coloured Lips 2 Layer", "Coloured Lips 3 Layer")

/datum/body_marking/other/splurt/colouredlips
	name = "Coloured Lips"
	icon_state = "colouredlips"
	affected_bodyparts = HEAD

/datum/body_marking/secondary/splurt/colouredlips
	name = "Coloured Lips 2 Layer"
	icon_state = "colouredlips"
	affected_bodyparts = HEAD

/datum/body_marking/tertiary/splurt/colouredlips
	name = "Coloured Lips 3 Layer"
	icon_state = "colouredlips"
	affected_bodyparts = HEAD

/// Coloured Nose
/datum/body_marking_set/colourednose
	name = "Coloured Nose"
	body_marking_list = list("Coloured Nose", "Coloured Nose 2 Layer", "Coloured Nose 3 Layer")

/datum/body_marking/other/splurt/colourednose
	name = "Coloured Nose"
	icon_state = "colourednose"
	affected_bodyparts = HEAD

/datum/body_marking/secondary/splurt/colourednose
	name = "Coloured Nose 2 Layer"
	icon_state = "colourednose"
	affected_bodyparts = HEAD

/datum/body_marking/tertiary/splurt/colourednose
	name = "Coloured Nose 3 Layer"
	icon_state = "colourednose"
	affected_bodyparts = HEAD

/// Forehead Mark
/datum/body_marking_set/foreheadmark
	name = "Forehead Mark"
	body_marking_list = list("Forehead Mark", "Forehead Mark 2 Layer", "Forehead Mark 3 Layer")

/datum/body_marking/other/splurt/foreheadmark
	name = "Forehead Mark"
	icon_state = "foreheadmark"
	affected_bodyparts = HEAD

/datum/body_marking/secondary/splurt/foreheadmark
	name = "Forehead Mark 2 Layer"
	icon_state = "foreheadmark"
	affected_bodyparts = HEAD

/datum/body_marking/tertiary/splurt/foreheadmark
	name = "Forehead Mark 3 Layer"
	icon_state = "foreheadmark"
	affected_bodyparts = HEAD

/// Blush Normal
/datum/body_marking_set/blushnormal
	name = "Blush Normal"
	body_marking_list = list("Blush Normal", "Blush Normal 2 Layer", "Blush Normal 3 Layer")

/datum/body_marking/other/splurt/blushnormal
	name = "Blush Normal"
	icon_state = "blushnormal"
	affected_bodyparts = HEAD

/datum/body_marking/secondary/splurt/blushnormal
	name = "Blush Normal 2 Layer"
	icon_state = "blushnormal"
	affected_bodyparts = HEAD

/datum/body_marking/tertiary/splurt/blushnormal
	name = "Blush Normal 3 Layer"
	icon_state = "blushnormal"
	affected_bodyparts = HEAD

/// Blush Small
/datum/body_marking_set/blushsmall
	name = "Blush Small"
	body_marking_list = list("Blush Small", "Blush Small 2 Layer", "Blush Small 3 Layer")

/datum/body_marking/other/splurt/blushsmall
	name = "Blush Small"
	icon_state = "blushsmall"
	affected_bodyparts = HEAD

/datum/body_marking/secondary/splurt/blushsmall
	name = "Blush Small 2 Layer"
	icon_state = "blushsmall"
	affected_bodyparts = HEAD

/datum/body_marking/tertiary/splurt/blushsmall
	name = "Blush Small 3 Layer"
	icon_state = "blushsmall"
	affected_bodyparts = HEAD

/// Blush Small (Alt)
/datum/body_marking_set/blushsmall_alt
	name = "Blush Small (Alt)"
	body_marking_list = list("Blush Small (Alt)", "Blush Small (Alt) 2 Layer", "Blush Small (Alt) 3 Layer")

/datum/body_marking/other/splurt/blushsmall_alt
	name = "Blush Small (Alt)"
	icon_state = "blushsmallALT"
	affected_bodyparts = HEAD

/datum/body_marking/secondary/splurt/blushsmall_alt
	name = "Blush Small (Alt) 2 Layer"
	icon_state = "blushsmallALT"
	affected_bodyparts = HEAD

/datum/body_marking/tertiary/splurt/blushsmall_alt
	name = "Blush Small (Alt) 3 Layer"
	icon_state = "blushsmallALT"
	affected_bodyparts = HEAD

/// Wide Eyes
/datum/body_marking_set/wideeyes
	name = "Wide Eyes"
	body_marking_list = list("Wide Eyes", "Wide Eyes 2 Layer", "Wide Eyes 3 Layer")

/datum/body_marking/other/splurt/wideeyes
	name = "Wide Eyes"
	icon_state = "animeeyes"
	affected_bodyparts = HEAD

/datum/body_marking/secondary/splurt/wideeyes
	name = "Wide Eyes 2 Layer"
	icon_state = "animeeyes"
	affected_bodyparts = HEAD

/datum/body_marking/tertiary/splurt/wideeyes
	name = "Wide Eyes 3 Layer"
	icon_state = "animeeyes"
	affected_bodyparts = HEAD

//Cryptid

/datum/body_marking/secondary/splurt/cryptid
	name = "Cryptid Ribs"
	icon_state = "cryptid"
	affected_bodyparts = CHEST

/datum/body_marking/secondary/splurt/cryptidfluff
	name = "Cryptid Fur"
	icon_state = "cryptid_marking"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT
