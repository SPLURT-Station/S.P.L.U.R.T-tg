GLOBAL_LIST_INIT(lust_modifiers, list("[GENITAL_HYPERSENS]" = 3, "[GENITAL_OVERSTIM]" = 1.8, "[GENITAL_DISAPPOINTING]" = 0.75, "[GENITAL_EDGINGONLY]" = 0.5, "[GENITAL_IMPOTENT]" = 0))
GLOBAL_LIST_INIT(anus_traits, list("[TRAIT_HYPERSENS_ANUS]" = 3, "[TRAIT_OVERSTIM_ANUS]" = 1.8, "[TRAIT_DISAPPOINTING_ANUS]" = 0.75, "[TRAIT_EDGINGONLY_ANUS]" = 0.5, "[TRAIT_IMPOTENT_ANUS]" = 0))

/mob/living/proc/lustcap(amt)
	var/lust_cap = (get_lust_tolerance() * 3) * 0.8 // 80% of the mob's orgasm arousal (lust_tolerance * 3)
	if((get_lust() + amt) >= lust_cap)
		set_lust(lust_cap - 1)

/**
  * Returns a lust value depending if the genital has a lust modifier.
  *
  * Arguments:
  * * amount: Amount of lust given.
  * * genital: Genital to check for any lust modifiers.
  * TODO - TURN THE TRAITS INTO COMPONENTS
*/
/mob/living/carbon/proc/check_stimulation(amount, genital)
	var/list/common_flags = list()

	// Check if the given genital is an "anus"
	if(genital == "anus")
		if(!dna.features["has_anus"])
			for(var/anus_trait in GLOB.anus_traits)
				if(HAS_TRAIT(src, anus_trait))
					LAZYADD(common_flags, anus_trait)

			if(!isemptylist(common_flags))
				var/new_amount = amount * GLOB.anus_traits[common_flags[1]]  // Multiply the arousal amount by the first trait added

				if(CHECK_BITFIELD(text2num(common_flags[1]), TRAIT_EDGINGONLY_ANUS))
					lustcap(new_amount)

				return new_amount

			return amount


	// Set a G variable to a proper genital instead of a string if it's one.
	var/obj/item/organ/genital/G = istype(genital, /obj/item/organ/genital) ? genital : getorganslot(genital)

	for(var/stim_mod in GLOB.lust_modifiers)
		if(CHECK_BITFIELD(G.genital_flags, text2num(stim_mod)))
			LAZYADD(common_flags, stim_mod)

	if(G && !isemptylist(common_flags))
		var/new_amount = amount * GLOB.lust_modifiers[common_flags[1]] // Multiply the arousal amount by the first stimulation flag added

		if(CHECK_BITFIELD(text2num(common_flags[1]), GENITAL_EDGINGONLY))
			lustcap(new_amount)

		return new_amount

	return amount

/**
  * Returns the fluid modifier if the genital has one.
  *
  * Arguments:
  * * amount: Amount of fluid to be released.
  * * genital: Genital to check for any fluid modifiers.
*/
/mob/living/proc/get_fluid_mod(obj/item/organ/genital/G)
	if(CHECK_BITFIELD(G?.genital_flags, GENITAL_DISAPPOINTING))
		return 0.5
	return 1

/**
  * Acts properly if the given genital has orgasm modifiers
  *
  * Arguments:
  * * genital: Genital to check for any orgasm modifiers.
*/
/mob/living/proc/check_orgasm(datum/source, R, target, obj/item/organ/genital/sender, receiver, spill)
	SIGNAL_HANDLER

	if(CHECK_BITFIELD(sender.genital_flags, GENITAL_IMPOTENT) || CHECK_BITFIELD(sender.genital_flags, GENITAL_DISAPPOINTING))
		emote("sigh")
		to_chat(src, "<span class='hypnophrase'>[pick("Ugh, that was embarassing...", "I could've done it better...")]</span>")
		return TRUE
	return FALSE

/mob/living/carbon/handle_post_sex(amount, orifice, mob/living/partner, organ = null, cum_inside = FALSE, anonymous = FALSE)
	if(organ)
		amount = check_stimulation(amount, organ)

	. = ..()
