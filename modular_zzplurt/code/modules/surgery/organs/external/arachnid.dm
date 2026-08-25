/obj/item/organ/mandibles
	name = "mandibles"
	desc = "Fancy lips for those who think they're above having lips."
	icon = 'modular_zzplurt/icons/obj/medical/organs/organs.dmi'
	icon_state = "mandibles"

	mutantpart_key = "spinneret" //this shit took me way too fucking long to find
	mutantpart_info = list(MUTANT_INDEX_NAME = "Plain", MUTANT_INDEX_COLOR_LIST = list("#FFFFFF")) //fuck azarak

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_MANDIBLES

	restyle_flags = EXTERNAL_RESTYLE_ENAMEL

	bodypart_overlay = /datum/bodypart_overlay/mutant/mandibles

/datum/bodypart_overlay/mutant/mandibles
	layers = list (EXTERNAL_FRONT = BODY_FRONT_LAYER, EXTERNAL_ADJACENT = BODY_ADJ_LAYER)
	feature_key = "mandibles"

/datum/bodypart_overlay/mutant/mandibles/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner, mob/living/carbon/owner, is_husked = FALSE)
	return ..() && !(owner?.obscured_slots & HIDESNOUT)

/datum/bodypart_overlay/mutant/mandibles/get_global_feature_list()
	return SSaccessories.sprite_accessories["mandibles"]


/obj/item/organ/spinneret
	name = "spinneret"
	desc = "This is where your icecream comes from."
	icon = 'modular_zzplurt/icons/obj/medical/organs/organs.dmi'
	icon_state = "spinneret"

	mutantpart_key = "spinneret"
	mutantpart_info = list(MUTANT_INDEX_NAME = "Plain", MUTANT_INDEX_COLOR_LIST = list("#FFFFFF"))

	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_EXTERNAL_SPINNERET

	restyle_flags = EXTERNAL_RESTYLE_FLESH

	bodypart_overlay = /datum/bodypart_overlay/mutant/spinneret

/datum/bodypart_overlay/mutant/spinneret
	layers = list(EXTERNAL_FRONT = BODY_FRONT_LAYER, EXTERNAL_ADJACENT = BODY_ADJ_LAYER, EXTERNAL_BEHIND = BODY_BEHIND_LAYER)
	feature_key = "spinneret"

/datum/bodypart_overlay/mutant/spinneret/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner, mob/living/carbon/owner, is_husked = FALSE)
	return ..() && !(owner?.obscured_slots & HIDEMUTWINGS)

/datum/bodypart_overlay/mutant/spinneret/get_global_feature_list()
	return SSaccessories.sprite_accessories["spinneret"]


/obj/item/organ/arachnid_legs
	name = "spider legs"
	desc = "Objectively inferior to regular legs." //idk i suck at descs
	icon = 'modular_zzplurt/icons/obj/medical/organs/organs.dmi'
	icon_state = "arachnid_legs"

	mutantpart_key = "spinneret"
	mutantpart_info = list(MUTANT_INDEX_NAME = "Plain", MUTANT_INDEX_COLOR_LIST = list("#FFFFFF"))

	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_EXTERNAL_SPIDER_LEGS

	restyle_flags = EXTERNAL_RESTYLE_FLESH

	bodypart_overlay = /datum/bodypart_overlay/mutant/arachnid_legs

/datum/bodypart_overlay/mutant/arachnid_legs
	layers = list(EXTERNAL_FRONT = BODY_FRONT_LAYER, EXTERNAL_ADJACENT = BODY_ADJ_LAYER, EXTERNAL_BEHIND = BODY_BEHIND_LAYER)
	feature_key = "arachnid_legs"

/datum/bodypart_overlay/mutant/arachnid_legs/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner, mob/living/carbon/owner, is_husked = FALSE)
	return ..() && !(owner?.obscured_slots & HIDEMUTWINGS)

/datum/bodypart_overlay/mutant/arachnid_legs/get_global_feature_list()
	return SSaccessories.sprite_accessories["arachnid_legs"]
