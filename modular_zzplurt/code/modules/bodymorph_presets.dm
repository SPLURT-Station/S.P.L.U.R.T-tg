// SPLURT ADDITION - Bodymorph Presets System
// Allows players to save, load, and manage body configuration presets
// Requirements:
// - Presets stored as part of the prefs/character file
// - Bodymorpher menu adds new "Presets" tab
// - Add, delete, and load various forms as presets
// - Un-modifiable "Base Character" preset (default saved form)
// - Named presets
// - Presets respect body-morpher abilities/restrictions
// - Bodymorphing logged per game.log (not ALogs)

/client
	var/datum/bodymorph_presets/bodymorph_presets

/client/proc/get_bodymorph_presets()
	if(!bodymorph_presets)
		bodymorph_presets = new(src)
	return bodymorph_presets

/proc/get_bodymorph_presets_savefolder(ckey)
	return "data/player_saves/[ckey[1]]/[ckey]"

/datum/bodymorph_presets
	var/client/owner
	var/datum/json_savefile/savefile
	var/list/presets = list()
	var/list/base_preset = list()

/datum/bodymorph_presets/New(client/C)
	owner = C
	load()

/datum/bodymorph_presets/proc/load()
	if(!owner)
		return
	var/savefolder = get_bodymorph_presets_savefolder(owner.ckey)
	savefile = new("[savefolder]/bodymorph_presets.json")
	presets = savefile.get_entry("presets", list())
	base_preset = savefile.get_entry("base", list())
	if(!islist(presets))
		presets = list()

/datum/bodymorph_presets/proc/save()
	if(!savefile)
		return
	savefile.set_entry("presets", presets)
	savefile.set_entry("base", base_preset)
	savefile.save()

/datum/bodymorph_presets/proc/set_base_preset(list/preset_data)
	base_preset = preset_data
	save()

/datum/bodymorph_presets/proc/get_base_preset()
	return base_preset

/datum/bodymorph_presets/proc/has_base_preset()
	return length(base_preset) > 0

/datum/bodymorph_presets/proc/add_preset(list/preset_data)
	if(!islist(preset_data) || !preset_data["name"])
		return FALSE
	if(length(presets) >= 20)
		return FALSE // max 20 user presets
	presets += list(preset_data)
	save()
	return TRUE

/datum/bodymorph_presets/proc/remove_preset(index)
	if(index < 1 || index > length(presets))
		return FALSE
	presets -= presets[index]
	save()
	return TRUE

/datum/bodymorph_presets/proc/update_preset(index, list/preset_data)
	if(index < 1 || index > length(presets))
		return FALSE
	if(!islist(preset_data) || !preset_data["name"])
		return FALSE
	presets[index] = preset_data
	save()
	return TRUE

/datum/bodymorph_presets/proc/get_preset(index)
	if(index < 1 || index > length(presets))
		return null
	return presets[index]

/datum/bodymorph_presets/proc/get_all_presets()
	return presets.Copy()

/datum/bodymorph_presets/proc/get_preset_count()
	return length(presets)

// Capture current body state as a preset
/proc/capture_bodymorph_preset(mob/living/carbon/human/H)
	if(!istype(H))
		return null

	var/list/preset = list()
	preset["name"] = "Unnamed Preset"
	// Colors
	preset["mutant_color"] = H.dna.features[FEATURE_MUTANT_COLOR]
	preset["mutant_color_two"] = H.dna.features[FEATURE_MUTANT_COLOR_TWO]
	preset["mutant_color_three"] = H.dna.features[FEATURE_MUTANT_COLOR_THREE]
	preset["hair_color"] = H.hair_color
	preset["facial_hair_color"] = H.facial_hair_color
	// Hair
	preset["hairstyle"] = H.hairstyle
	preset["facial_hairstyle"] = H.facial_hairstyle
	// Body
	preset["body_size"] = H.dna.features["body_size"]
	preset["gender"] = H.gender
	// Mutant parts
	preset["mutant_bodyparts"] = H.dna.mutant_bodyparts?.Copy()
	preset["species_mutant_bodyparts"] = H.dna.species?.mutant_bodyparts?.Copy()
	preset["body_markings"] = H.dna.species?.body_markings?.Copy()
	// Genitals / body features
	preset["belly_size"] = H.dna.features["belly_size"]
	preset["butt_size"] = H.dna.features["butt_size"]
	preset["breasts_size"] = H.dna.features["breasts_size"]
	preset["breasts_lactation"] = H.dna.features["breasts_lactation"]
	preset["penis_size"] = H.dna.features["penis_size"]
	preset["penis_girth"] = H.dna.features["penis_girth"]
	preset["penis_sheath"] = H.dna.features["penis_sheath"]
	preset["penis_taur_mode"] = H.dna.features["penis_taur_mode"]
	preset["balls_size"] = H.dna.features["balls_size"]
	return preset

// Apply a preset to a human mob
/proc/apply_bodymorph_preset(mob/living/carbon/human/H, list/preset, silent = FALSE)
	if(!istype(H) || !islist(preset))
		return FALSE

	if(!silent)
		log_game("BODYMORPH: [key_name(H)] loaded preset '[preset["name"] || "Unknown"]'")

	// Colors
	if("mutant_color" in preset)
		H.dna.features[FEATURE_MUTANT_COLOR] = preset["mutant_color"]
	if("mutant_color_two" in preset)
		H.dna.features[FEATURE_MUTANT_COLOR_TWO] = preset["mutant_color_two"]
	if("mutant_color_three" in preset)
		H.dna.features[FEATURE_MUTANT_COLOR_THREE] = preset["mutant_color_three"]
	if("hair_color" in preset)
		H.hair_color = preset["hair_color"]
	if("facial_hair_color" in preset)
		H.facial_hair_color = preset["facial_hair_color"]
	// Hair
	if("hairstyle" in preset)
		H.set_hairstyle(preset["hairstyle"], update = FALSE)
	if("facial_hairstyle" in preset)
		H.set_facial_hairstyle(preset["facial_hairstyle"], update = FALSE)
	// Body
	if("body_size" in preset)
		H.dna.features["body_size"] = preset["body_size"]
	if("gender" in preset)
		H.gender = preset["gender"]
		H.dna.update_ui_block(/datum/dna_block/identity/gender)
	// Mutant parts
	if("mutant_bodyparts" in preset && islist(preset["mutant_bodyparts"]))
		H.dna.mutant_bodyparts = preset["mutant_bodyparts"].Copy()
	if("species_mutant_bodyparts" in preset && islist(preset["species_mutant_bodyparts"]))
		H.dna.species.mutant_bodyparts = preset["species_mutant_bodyparts"].Copy()
	if("body_markings" in preset && islist(preset["body_markings"]))
		H.dna.species.body_markings = preset["body_markings"].Copy()
	// Genitals / body features
	if("belly_size" in preset)
		H.dna.features["belly_size"] = preset["belly_size"]
	if("butt_size" in preset)
		H.dna.features["butt_size"] = preset["butt_size"]
	if("breasts_size" in preset)
		H.dna.features["breasts_size"] = preset["breasts_size"]
	if("breasts_lactation" in preset)
		H.dna.features["breasts_lactation"] = preset["breasts_lactation"]
	if("penis_size" in preset)
		H.dna.features["penis_size"] = preset["penis_size"]
	if("penis_girth" in preset)
		H.dna.features["penis_girth"] = preset["penis_girth"]
	if("penis_sheath" in preset)
		H.dna.features["penis_sheath"] = preset["penis_sheath"]
	if("penis_taur_mode" in preset)
		H.dna.features["penis_taur_mode"] = preset["penis_taur_mode"]
	if("balls_size" in preset)
		H.dna.features["balls_size"] = preset["balls_size"]

	H.mutant_renderkey = ""
	H.update_body(is_creating = TRUE)
	H.update_mutations_overlay()
	H.update_clothing(ITEM_SLOT_ICLOTHING)
	H.update_body_parts()

	return TRUE
