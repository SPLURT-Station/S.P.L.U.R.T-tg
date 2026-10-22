/datum/preference/choiced/eye_type
	priority = PREFERENCE_PRIORITY_BODYPARTS
	savefile_key = "eye_type"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_CHARACTER_BASICS
	relevant_head_flag = HEAD_EYECOLOR

/datum/preference/choiced/eye_type/init_possible_values()
	return list(
		"Default",
		"normal",
		"insect",
		"moth",
		"double",
		"double2",
		"double3",
		"spider",
		"cyclops",
		"third",
		"spectre",
		"shadekin",
		"teshari",
		"vox",
		"noodle",
		"none",
	)

/datum/preference/choiced/eye_type/create_default_value()
	return "Default"

/datum/preference/choiced/eye_type/compile_constant_data()
	var/list/data = ..()
	data[CHOICED_PREFERENCE_DISPLAY_NAMES] = list(
		"Default" = "Species Default",
		"normal" = "Normal",
		"insect" = "Insect",
		"moth" = "Moth",
		"double" = "Double",
		"double2" = "Double 2",
		"double3" = "Double 3",
		"spider" = "Spider",
		"cyclops" = "Cyclops",
		"third" = "Third Eye",
		"spectre" = "Spectre",
		"shadekin" = "Shadekin",
		"teshari" = "Teshari",
		"vox" = "Vox",
		"noodle" = "Noodle",
		"none" = "None",
	)
	return data

/datum/preference/choiced/eye_type/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/obj/item/organ/eyes/eyes_organ = target.get_organ_by_type(/obj/item/organ/eyes)
	if(!istype(eyes_organ))
		return

	if(!value || value == "Default")
		eyes_organ.eye_icon = initial(eyes_organ.eye_icon)
		eyes_organ.eye_icon_state = initial(eyes_organ.eye_icon_state)
	else
		eyes_organ.eye_icon = 'modular_zzplurt/icons/mob/human/eyes.dmi'
		eyes_organ.eye_icon_state = value

	if(eyes_organ.eyelid_left)
		eyes_organ.eyelid_left.icon = eyes_organ.eye_icon
		eyes_organ.eyelid_left.icon_state = "[eyes_organ.eye_icon_state]_l"
	if(eyes_organ.eyelid_right)
		eyes_organ.eyelid_right.icon = eyes_organ.eye_icon
		eyes_organ.eyelid_right.icon_state = "[eyes_organ.eye_icon_state]_r"

	eyes_organ.refresh()
