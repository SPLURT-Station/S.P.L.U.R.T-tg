GLOBAL_VAR_INIT(DNR_trait_overlay, generate_DNR_trait_overlay())

/// Instantiates GLOB.DNR_trait_overlay by creating a new mutable_appearance instance of the overlay.
/proc/generate_DNR_trait_overlay()
	RETURN_TYPE(/mutable_appearance)

	var/mutable_appearance/DNR_trait_overlay = mutable_appearance('modular_skyrat/modules/indicators/icons/DNR_trait_overlay.dmi', "DNR", FLY_LAYER)
	DNR_trait_overlay.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	return DNR_trait_overlay


// SKYRAT NEUTRAL TRAITS
/datum/quirk/excitable
	name = "Excitable!"
	desc = "Head patting makes your tail wag! You're very excitable! WAG WAG."
	gain_text = span_notice("You crave for some headpats!")
	lose_text = span_notice("You no longer care for headpats all that much.")
	medical_record_text = "Patient seems to get excited easily."
	value = 0
	mob_trait = TRAIT_EXCITABLE
	icon = FA_ICON_LAUGH_BEAM

/datum/quirk/affectionaversion
	name = "Affection Aversion"
	desc = "You refuse to be licked or nosed by quadruped cyborgs."
	gain_text = span_notice("You've been added to the Do Not Lick and No Nosing registries.")
	lose_text = span_notice("You've been removed from the Do Not Lick and No Nosing registries.")
	medical_record_text = "Patient is in the Do Not Lick and No Nosing registries."
	value = 0
	mob_trait = TRAIT_AFFECTION_AVERSION
	icon = FA_ICON_CIRCLE_EXCLAMATION

/datum/quirk/personalspace
	name = "Personal Space"
	desc = "You'd rather people keep their hands off your rear end."
	gain_text = span_notice("You'd like it if people kept their hands off your butt.")
	lose_text = span_notice("You're less concerned about people touching your butt.")
	medical_record_text = "Patient demonstrates negative reactions to their posterior being touched."
	value = 0
	mob_trait = TRAIT_PERSONALSPACE
	icon = FA_ICON_HAND_PAPER

/datum/quirk/felinid_aspect
	name = "Felinid Traits"
	desc = "You happen to act like a felinid, for whatever reason. This will replace other tongue-based quirks."
	gain_text = span_notice("Nya could go for some catnip right about now...")
	lose_text = span_notice("You feel less attracted to lasers.")
	medical_record_text = "Patient seems to possess behavior much like a felinid."
	mob_trait = TRAIT_FELINID
	icon = FA_ICON_CAT

/datum/quirk/felinid_aspect/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/organ/tongue/cat/new_tongue = new(get_turf(human_holder))

	new_tongue.copy_traits_from(human_holder.get_organ_slot(ORGAN_SLOT_TONGUE))
	new_tongue.Insert(human_holder, special = TRUE, movement_flags = DELETE_IF_REPLACED)

/datum/quirk/item_quirk/canine
	name = "Canidae Traits"
	desc = "Bark. You seem to act like a canine for whatever reason. This will replace most other tongue-based speech quirks."
	mob_trait = TRAIT_CANINE
	icon = FA_ICON_DOG
	value = 0
	medical_record_text = "Patient was seen digging through the trash can. Keep an eye on them."

/datum/quirk/item_quirk/canine/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/organ/tongue/dog/new_tongue = new(get_turf(human_holder))

	new_tongue.copy_traits_from(human_holder.get_organ_slot(ORGAN_SLOT_TONGUE))
	new_tongue.Insert(human_holder, special = TRUE, movement_flags = DELETE_IF_REPLACED)

/datum/quirk/item_quirk/avian
	name = "Avian Traits"
	desc = "You're a birdbrain, or you've got a bird's brain. This will replace most other tongue-based speech quirks."
	mob_trait = TRAIT_AVIAN
	icon = FA_ICON_KIWI_BIRD
	value = 0
	medical_record_text = "Patient exhibits avian-adjacent mannerisms."

/datum/quirk/item_quirk/avian/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/organ/tongue/avian/new_tongue = new(get_turf(human_holder))

	new_tongue.copy_traits_from(human_holder.get_organ_slot(ORGAN_SLOT_TONGUE))
	new_tongue.Insert(human_holder, special = TRUE, movement_flags = DELETE_IF_REPLACED)

/datum/quirk/item_quirk/bovine
	name = "Bovine Traits"
	desc = "Moo. You seem to act like a bovine for whatever reason. This will replace most other tongue-based speech quirks."
	mob_trait = TRAIT_BOVINE
	icon = FA_ICON_COW
	value = 0
	medical_record_text = "Patient exhibits bovine-adjacent mannerisms."

/datum/quirk/item_quirk/bovine/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/organ/tongue/bovine/new_tongue = new(get_turf(human_holder))

	new_tongue.copy_traits_from(human_holder.get_organ_slot(ORGAN_SLOT_TONGUE))
	new_tongue.Insert(human_holder, special = TRUE, movement_flags = DELETE_IF_REPLACED)

///Start of Mouse Traits
/datum/quirk/item_quirk/mouse
	name = "Muridae Traits"
	desc = "You always thought those jokes were cheesy. This will replace most other tongue-based speech quirks."
	mob_trait = TRAIT_MURIDAE
	icon = FA_ICON_CHEESE
	value = 0
	medical_record_text = "Patient has an insatiable love for dairy and terrible puns."
	var/datum/action/cooldown/spell/sniff/sniff_food

/datum/quirk/item_quirk/mouse/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/organ/tongue/mouse/new_tongue = new(get_turf(human_holder))
	human_holder.faction |= FACTION_RAT

	new_tongue.copy_traits_from(human_holder.get_organ_slot(ORGAN_SLOT_TONGUE))
	new_tongue.Insert(human_holder, special = TRUE, movement_flags = DELETE_IF_REPLACED)

/datum/quirk/item_quirk/mouse/add(client/client_source)
	. = ..()

	sniff_food = new()
	sniff_food.Grant(quirk_holder)

/datum/quirk/item_quirk/mouse/remove()
	. = ..()

	if(QDELETED(quirk_holder))
		return

	QDEL_NULL(sniff_food)

/datum/action/cooldown/spell/sniff
	name = "Sniff Food"
	desc = "Anyone can cook!"
	button_icon_state = "food_french"
	button_icon = 'icons/hud/screen_alert.dmi'
	cooldown_time = 10 SECONDS
	spell_requirements = NONE
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_INCAPACITATED

/datum/action/cooldown/spell/sniff/cast(mob/living/caster)
	. = ..()
	try_sniff_item(caster)

// tries to check if the obj is valid to sniff
/datum/action/cooldown/spell/sniff/proc/can_sniff(obj/item/food/potential_food, mob/living/caster)
	if(potential_food.food_flags & ABSTRACT)
		return FALSE
	return TRUE

// tries to sniff item in hand
/datum/action/cooldown/spell/sniff/proc/try_sniff_item(mob/living/caster)
	var/obj/item/food/potential_food = caster.get_active_held_item()
	if(!istype(potential_food))
		if(caster.get_inactive_held_item())
			to_chat(caster, span_warning("You must be holding food!"))
		else
			to_chat(caster, span_warning("You aren't holding anything that can be used as an ingredient!"))
		return FALSE
	if(!can_sniff(potential_food, caster))
		return FALSE
	caster.balloon_alert_to_viewers("sniffing...")
	to_chat(caster, span_notice("You start judging [potential_food] for its culinary potential..."))
	if(!do_after(caster, 5 SECONDS, potential_food))
		to_chat(caster, span_notice("You didn't get a good enough whiff of [potential_food]."))
		return FALSE
	check_recipes(potential_food)
	return TRUE

// checks recipes related to held item
/datum/action/cooldown/spell/sniff/proc/check_recipes(obj/item/food/potential_food)
	var/list/type_recipe_list = list()
	var/food_type = potential_food.type
	for(var/datum/crafting_recipe/recipe as anything in GLOB.cooking_recipes)
		if(food_type in recipe.reqs)
			type_recipe_list += recipe.result
	if(length(type_recipe_list) == 0)
		to_chat(owner, span_notice("Nothing more can be made from this."))
		return FALSE
	var/datum/crafting_recipe/chosen = pick(type_recipe_list)
	to_chat(owner, span_notice("[potential_food] could probably be used to make [chosen::name]"))
///End of Mouse Traits

/datum/quirk/sluggish
	name = "Sluggish
	desc = "For whatever reason, you're just slower than everyone else. Maybe you just take life one day at a time." // SPLURT reflavor, former overweight quirk
	gain_text = span_notice("Your body feels heavy.")
	lose_text = span_notice("You suddenly feel lighter!")
	value = 0
	icon = FA_ICON_HAMBURGER // I'm very hungry. Give me the burger!
	medical_record_text = "Patient weighs higher than average."
	mob_trait = TRAIT_FAT

/datum/quirk/sluggish/add(client/client_source)
	quirk_holder.add_movespeed_modifier(/datum/movespeed_modifier/sluggish)

/datum/quirk/sluggish/remove()
	quirk_holder.remove_movespeed_modifier(/datum/movespeed_modifier/sluggish)

/datum/movespeed_modifier/sluggish
	multiplicative_slowdown = 0.5 //Around that of a dufflebag, enough to be impactful but not debilitating.

/datum/mood_event/fat/can_effect_mob(datum/mood/home, mob/living/target, ...)
	. = ..()

	if(HAS_TRAIT_FROM(target, TRAIT_FAT, QUIRK_TRAIT))
		mood_change = 0 // They are probably used to it, no reason to be viscerally upset about it.
		description = "<b>I'm slow.</b>"
	return TRUE

/datum/quirk/water_aspect
	name = "Water aspect (Emotes)"
	desc = "(Aquatic innate) Underwater societies are home to you, space ain't much different. (Say *turf to cast)"
	value = 0
	mob_trait = TRAIT_WATER_ASPECT
	gain_text = span_notice("You feel like you can control water.")
	lose_text = span_danger("Somehow, you've lost your ability to control water!")
	medical_record_text = "Patient holds a collection of nanobots designed to synthesize H2O."
	icon = FA_ICON_WATER

/datum/quirk/webbing_aspect
	name = "Webbing aspect (Emotes)"
	desc = "(Insect innate) Insect folk capable of weaving aren't unfamiliar with receiving envy from those lacking a natural 3D printer. (Say *turf to cast)"
	value = 0
	mob_trait = TRAIT_WEBBING_ASPECT
	gain_text = span_notice("You could easily spin a web.")
	lose_text = span_danger("Somehow, you've lost your ability to weave.")
	medical_record_text = "Patient has the ability to weave webs with naturally synthesized silk."
	icon = FA_ICON_STICKY_NOTE

/datum/quirk/floral_aspect
	name = "Floral aspect (Emotes)"
	desc = "(Podperson innate) Kudzu research isn't pointless, rapid photosynthesis technology is here! (Say *turf to cast)"
	value = 0
	mob_trait = TRAIT_FLORAL_ASPECT
	gain_text = span_notice("You feel like you can grow vines.")
	lose_text = span_danger("Somehow, you've lost your ability to rapidly photosynthesize.")
	medical_record_text = "Patient can rapidly photosynthesize to grow vines."
	icon = FA_ICON_PLANT_WILT

/datum/quirk/ash_aspect
	name = "Ash aspect (Emotes)"
	desc = "(Lizard innate) The ability to forge ash and flame, a mighty power - yet mostly used for theatrics. (Say *turf to cast)"
	value = 0
	mob_trait = TRAIT_ASH_ASPECT
	gain_text = span_notice("There is a forge smouldering inside of you.")
	lose_text = span_danger("Somehow, you've lost your ability to breathe fire.")
	medical_record_text = "Patients possess a fire breathing gland commonly found in lizard folk."
	icon = FA_ICON_FIRE

/datum/quirk/sparkle_aspect
	name = "Sparkle aspect (Emotes)"
	desc = "(Moth innate) Sparkle like the dust off of a moth's wing, or like a cheap red-light hook-up. (Say *turf to cast)"
	value = 0
	mob_trait = TRAIT_SPARKLE_ASPECT
	gain_text = span_notice("You're covered in sparkling dust!")
	lose_text = span_danger("Somehow, you've completely cleaned yourself of glitter..")
	medical_record_text = "Patient seems to be looking fabulous."
	icon = FA_ICON_HAND_SPARKLES
