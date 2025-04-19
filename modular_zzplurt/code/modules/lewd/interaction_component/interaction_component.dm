/**
 * Handles the inflation of genitalia during climax
 *
 * partner - The partner who is cumming and providing the fluid source
 * source_genital - The slot name of the genitalia that is being used as fluid source (text)
 * slot - The slot of the genitalia being inflated on self
 */
/datum/component/interactable/proc/climax_inflate_genital(mob/living/carbon/human/partner, source_genital, slot)
	if(!ishuman(partner) || !ishuman(self))
		return

	if(!partner.client?.prefs.read_preference(/datum/preference/toggle/erp/cumflates_partners) || !self.client?.prefs.read_preference(/datum/preference/toggle/erp/cumflation))
		return

	var/mob/living/carbon/human/human_self = self // Necessary for the soon to be merged refactor
	var/list/obj/item/organ/genital/to_update = list()

	// Get fluid amount from source genital
	var/obj/item/organ/genital/fluid_source = partner.get_organ_slot(source_genital)
	if(!fluid_source || !fluid_source.internal_fluid_count)
		return

	// Calculate growth based on fluid amount relative to max capacity
	var/growth_amount = ROUND_UP(fluid_source.internal_fluid_count / (fluid_source.internal_fluid_maximum * GENITAL_INFLATION_THRESHOLD))
	if(!growth_amount)
		return

	// Handle belly inflation for oral, vaginal and anal
	if(slot in list("mouth", ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS, ORGAN_SLOT_BELLY))
		var/obj/item/organ/genital/belly/mob_belly = human_self.get_organ_slot(ORGAN_SLOT_BELLY)
		if(!mob_belly && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/new_genitalia_growth))
			mob_belly = new
			mob_belly.build_from_dna(human_self.dna, ORGAN_SLOT_BELLY)
			mob_belly.Insert(human_self, 0, FALSE)
			mob_belly.genital_size = BELLY_MIN_SIZE

		if(mob_belly && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/belly_enlargement))
			var/prev_size = mob_belly.genital_size
			mob_belly.genital_size = min(mob_belly.genital_size + growth_amount, BELLY_MAX_SIZE)
			to_update += mob_belly
			if(mob_belly.genital_size > prev_size)
				human_self.visible_message(span_lewd("\The <b>[human_self]</b>'s belly bloats outwards as it gets pumped full of [LOWER_TEXT(initial(fluid_source.internal_fluid_datum:name))]!"))

		// Handle butt inflation when belly gets big enough from anal
		if(slot == ORGAN_SLOT_ANUS && mob_belly.genital_size >= 3)
			var/obj/item/organ/genital/butt/mob_butt = human_self.get_organ_slot(ORGAN_SLOT_BUTT)
			if(!mob_butt && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/new_genitalia_growth))
				mob_butt = new
				mob_butt.build_from_dna(human_self.dna, ORGAN_SLOT_BUTT)
				mob_butt.Insert(human_self, 0, FALSE)
				mob_butt.genital_size = BUTT_MIN_SIZE

			if(mob_butt && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/butt_enlargement))
				var/prev_size = mob_butt.genital_size
				mob_butt.genital_size = min(mob_butt.genital_size + growth_amount, BUTT_MAX_SIZE)
				to_update += mob_butt
				if(mob_butt.genital_size > prev_size)
					human_self.visible_message(span_lewd("\The <b>[human_self]</b>'s ass swells outwards as it gets pumped full of [LOWER_TEXT(initial(fluid_source.internal_fluid_datum:name))]!"))

	// Handle penis and testicles inflation
	else if(slot == ORGAN_SLOT_PENIS)
		var/obj/item/organ/genital/penis/mob_penis = human_self.get_organ_slot(ORGAN_SLOT_PENIS)
		if(!mob_penis && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/new_genitalia_growth))
			// If the user has not defined their own prefs for their penis type, try to assign a default based on their species
			var/list/species_to_penis = list(
				SPECIES_HUMAN = list(
					"sheath" = SHEATH_NONE,
					"mutant_index" = "Human",
					"balls" = "Pair"
				),
				SPECIES_LIZARD = list(
					"sheath" = SHEATH_SLIT,
					"color" = "#FFB6C1",
					"mutant_index" = "Flared",
					"balls" = "Internal"
				),
				SPECIES_LIZARD_ASH = list(
					"sheath" = SHEATH_SLIT,
					"color" = "#FFB6C1",
					"mutant_index" = "Flared",
					"balls" = "Internal"
				)
			)

			var/list/data = species_to_penis[human_self.dna.species.id]
			if(!data)
				data = species_to_penis[SPECIES_HUMAN]

			if(human_self.dna.features["penis_sheath"] == "None")
				human_self.dna.features["penis_sheath"] = data["sheath"]

			if(human_self.dna.mutant_bodyparts[ORGAN_SLOT_PENIS][MUTANT_INDEX_NAME] == "None")
				human_self.dna.mutant_bodyparts[ORGAN_SLOT_PENIS][MUTANT_INDEX_NAME] = data["mutant_index"]

			if(human_self.dna.mutant_bodyparts[ORGAN_SLOT_TESTICLES][MUTANT_INDEX_NAME] == "None")
				human_self.dna.mutant_bodyparts[ORGAN_SLOT_TESTICLES][MUTANT_INDEX_NAME] = data["balls"]

			var/colour = data["colour"]
			if(colour)
				human_self.dna.mutant_bodyparts[ORGAN_SLOT_PENIS][MUTANT_INDEX_COLOR_LIST] = list(colour)

			mob_penis = new
			mob_penis.build_from_dna(human_self.dna, ORGAN_SLOT_PENIS)
			mob_penis.Insert(human_self, 0, FALSE)
			mob_penis.genital_size = 4
			mob_penis.girth = 3
			human_self.visible_message(span_lewd("\The <b>[human_self]</b>'s crotch feels warm as something suddenly sprouts between their legs."))

		if(mob_penis && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/penis_enlargement))
			var/prev_size = mob_penis.genital_size
			var/prev_girth = mob_penis.girth
			mob_penis.genital_size = min(mob_penis.genital_size + growth_amount, PENIS_MAX_LENGTH)
			mob_penis.girth = min(mob_penis.girth + (growth_amount * 0.5), PENIS_MAX_GIRTH)
			to_update += mob_penis
			if(mob_penis.genital_size > prev_size || mob_penis.girth > prev_girth)
				human_self.visible_message(span_lewd("\The <b>[human_self]</b>'s penis swells larger as it gets pumped full of [LOWER_TEXT(initial(fluid_source.internal_fluid_datum:name))]!"))

		var/obj/item/organ/genital/testicles/mob_testicles = human_self.get_organ_slot(ORGAN_SLOT_TESTICLES)
		if(!mob_testicles && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/new_genitalia_growth))
			mob_testicles = new
			mob_testicles.build_from_dna(human_self.dna, ORGAN_SLOT_TESTICLES)
			mob_testicles.Insert(human_self, 0, FALSE)
			mob_testicles.genital_size = TESTICLES_MIN_SIZE

		if(mob_testicles && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/penis_enlargement))
			var/prev_size = mob_testicles.genital_size
			mob_testicles.genital_size = min(mob_testicles.genital_size + (growth_amount * 0.5), TESTICLES_MAX_SIZE)
			to_update += mob_testicles
			if(mob_testicles.genital_size > prev_size)
				human_self.visible_message(span_lewd("\The <b>[human_self]</b>'s balls grow heavier as they get pumped full of [LOWER_TEXT(initial(fluid_source.internal_fluid_datum:name))]!"))

	// Handle breast inflation
	else if(slot == ORGAN_SLOT_BREASTS)
		var/obj/item/organ/genital/breasts/mob_breasts = human_self.get_organ_slot(ORGAN_SLOT_BREASTS)
		if(!mob_breasts && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/new_genitalia_growth))
			// If the user has not defined their own prefs for their breast type, default to two breasts
			if (human_self.dna.mutant_bodyparts[ORGAN_SLOT_BREASTS][MUTANT_INDEX_NAME] == "None")
				human_self.dna.mutant_bodyparts[ORGAN_SLOT_BREASTS][MUTANT_INDEX_NAME] = "Pair"

			mob_breasts = new
			mob_breasts.build_from_dna(human_self.dna, ORGAN_SLOT_BREASTS)
			mob_breasts.Insert(human_self, 0, FALSE)
			mob_breasts.genital_size = BREASTS_MIN_SIZE

			if(mob_breasts.visibility_preference == GENITAL_ALWAYS_SHOW || human_self.is_topless())
				human_self.visible_message(span_notice("[human_self]'s bust suddenly expands!"))
				to_chat(human_self, span_purple("Your chest feels warm, tingling with sensitivity as it expands outward."))
			else
				human_self.visible_message(span_notice("The area around [human_self]'s chest suddenly bounces a bit."))
				to_chat(human_self, span_purple("Your chest feels warm, tingling with sensitivity as it strains against your clothes."))

		if(mob_breasts && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/breast_enlargement))
			var/prev_size = mob_breasts.genital_size
			mob_breasts.genital_size = min(mob_breasts.genital_size + growth_amount, BREASTS_MAX_SIZE)
			to_update += mob_breasts
			if(mob_breasts.genital_size > prev_size)
				if(mob_breasts.visibility_preference == GENITAL_ALWAYS_SHOW || human_self.is_topless())
					human_self.visible_message(span_lewd("\The <b>[human_self]</b>'s breasts swell larger as they get pumped full of [LOWER_TEXT(initial(fluid_source.internal_fluid_datum:name))]!"))
				else
					human_self.visible_message(span_lewd("\The area around [human_self]'s chest suddenly bounces a bit."))

	for(var/obj/item/organ/genital/genital in to_update)
		call(/datum/reagent/drug/aphrodisiac::update_appearance())(human_self, genital)
