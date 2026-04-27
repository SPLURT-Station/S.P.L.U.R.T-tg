// defines a number of additional respiration types and their associated lungs for the purposes of the exotic respiration quirk
// see code/modules/surgery/organs/internal/lungs/_lungs.dm for a more exhaustive explanation of the code being repurposed here

#define RESPIRATION_BZ (1 << 3)
#define RESPIRATION_NITROUS (1 << 4)
#define RESPIRATION_CARBON (1 << 5)

// it's on some coconut shit and complains if i don't define these vars on the parent type
/obj/item/organ/lungs
	var/safe_bz_min
	var/safe_n2o_min
	var/safe_co2_min

/obj/item/organ/lungs/Initialize(mapload)
	. = ..()
	if(safe_bz_min)
		respiration_type |= RESPIRATION_BZ
		add_gas_reaction(/datum/gas/bz, always = PROC_REF(breathe_bz))
	if(safe_n2o_min)
		respiration_type |= RESPIRATION_NITROUS
		add_gas_reaction(/datum/gas/nitrous_oxide, always = PROC_REF(breathe_n2o))
	if(safe_co2_min)
		respiration_type |= RESPIRATION_CARBON
		add_gas_reaction(/datum/gas/carbon_dioxide, always = PROC_REF(breathe_co2))

// BZ is exchanged with CO2 just like oxygen
/obj/item/organ/lungs/proc/breathe_bz(mob/living/carbon/breather, datum/gas_mixture/breath, bz_pp, old_bz_pp)
	if(bz_pp < safe_bz_min && !HAS_TRAIT(breather, TRAIT_NO_BREATHLESS_DAMAGE))
		if(!HAS_TRAIT(breather, TRAIT_ANOSMIA))
			breather.throw_alert(ALERT_NOT_ENOUGH_BZ, /atom/movable/screen/alert/not_enough_bz)
		var/gas_breathed = handle_suffocation(breather, bz_pp, safe_bz_min, breath.gases[/datum/gas/bz][MOLES])
		if(bz_pp)
			breathe_gas_volume(breath, /datum/gas/bz, /datum/gas/carbon_dioxide, volume = gas_breathed)
		return
	if(old_bz_pp < safe_bz_min)
		breather.failed_last_breath = FALSE
		breather.clear_alert(ALERT_NOT_ENOUGH_BZ)
	breathe_gas_volume(breath, /datum/gas/bz, /datum/gas/carbon_dioxide)
	if(breather.health >= breather.crit_threshold && breather.oxyloss)
		breather.adjust_oxy_loss(-5)

// ditto line 26 but for N2O
// i'd love to do this without repeating myself but until someone refactors tg's dogshit breathing code this is the best i've got
/obj/item/organ/lungs/proc/breathe_n2o(mob/living/carbon/breather, datum/gas_mixture/breath, n2o_pp, old_n2o_pp)
	if(n2o_pp < safe_n2o_min && !HAS_TRAIT(breather, TRAIT_NO_BREATHLESS_DAMAGE))
		if(!HAS_TRAIT(breather, TRAIT_ANOSMIA))
			breather.throw_alert(ALERT_NOT_ENOUGH_N2O, /atom/movable/screen/alert/not_enough_n2o)
		var/gas_breathed = handle_suffocation(breather, n2o_pp, safe_n2o_min, breath.gases[/datum/gas/nitrous_oxide][MOLES])
		if(n2o_pp)
			breathe_gas_volume(breath, /datum/gas/nitrous_oxide, /datum/gas/carbon_dioxide, volume = gas_breathed)
		return
	if(old_n2o_pp < safe_n2o_min)
		breather.failed_last_breath = FALSE
		breather.clear_alert(ALERT_NOT_ENOUGH_N2O)
	breathe_gas_volume(breath, /datum/gas/nitrous_oxide, /datum/gas/carbon_dioxide)
	if(breather.health >= breather.crit_threshold && breather.oxyloss)
		breather.adjust_oxy_loss(-5)

// CO2 is exchanged for... OXYGEN?! how can this be
/obj/item/organ/lungs/proc/breathe_co2(mob/living/carbon/breather, datum/gas_mixture/breath, co2_pp, old_co2_pp)
	if(co2_pp < safe_co2_min && !HAS_TRAIT(breather, TRAIT_NO_BREATHLESS_DAMAGE))
		if(!HAS_TRAIT(breather, TRAIT_ANOSMIA))
			breather.throw_alert(ALERT_NOT_ENOUGH_CO2, /atom/movable/screen/alert/not_enough_co2)
		var/gas_breathed = handle_suffocation(breather, co2_pp, safe_co2_min, breath.gases[/datum/gas/carbon_dioxide][MOLES])
		if(co2_pp)
			breathe_gas_volume(breath, /datum/gas/carbon_dioxide, /datum/gas/oxygen, volume = gas_breathed)
		return
	if(old_co2_pp < safe_co2_min)
		breather.failed_last_breath = FALSE
		breather.clear_alert(ALERT_NOT_ENOUGH_CO2)
	breathe_gas_volume(breath, /datum/gas/carbon_dioxide, /datum/gas/oxygen)
	if(breather.health >= breather.crit_threshold && breather.oxyloss)
		breather.adjust_oxy_loss(-5)
// no need to define n2 and plasma breathing because they already exist

/obj/item/organ/lungs/exotic // parent type for exotic lungs
	var/breathgas = "absolutely nothing. This vexes me!<br>You should report this on GitHub"
	desc = "These ones look weird."
	special_desc_requirement = EXAMINE_CHECK_JOB
	special_desc_jobs = list(JOB_MEDICAL_DOCTOR, JOB_CHIEF_MEDICAL_OFFICER, JOB_CHEMIST, JOB_PARAMEDIC, JOB_SECURITY_MEDIC, JOB_CORONER) // orderlies didn't go to med school
	safe_oxygen_min = 0
	safe_oxygen_max = 2
	oxy_damage_type = TOX // you take toxin damage rather than oxyloss, same as n2 breathers
	oxy_breath_dam_min = 6
	oxy_breath_dam_max = 20
/obj/item/organ/lungs/exotic/Initialize(mapload)
	. = ..()
	special_desc = "Upon closer inspection, you note a characteristic [pick("tint", "shape", "smell", "taste", "texture", "structure")] to the [pick("alveoli", "pleura", "bronchi", "capillaries")] of these lungs. They appear to be adapted to breathe <b>[breathgas].</b>"

/obj/item/organ/lungs/exotic/bz
	safe_bz_min = 6 // bz is hard to get and this is a -4 quirk, let's toss a lifeline bz breathers' way
	BZ_trip_balls_min = 1e30 // i don't like "set it to a big fucking number" any more than you do but here we are
	BZ_brain_damage_min = 1e30 // if you're breathing one nonillion kpa of bz you have bigger problems than the brain damage
	breathgas = "BZ"

/obj/item/organ/lungs/exotic/n2o
	safe_n2o_min = 16
	n2o_detect_min = 1e30 // it would suck if your breathing gas put up a constant warning in the alert box
	n2o_para_min = 1e30 // or paralyzed you
	n2o_sleep_min = 1e30 // or knocked you out
	breathgas = "nitrous oxide"

/obj/item/organ/lungs/exotic/co2
	safe_co2_min = 16
	safe_co2_max = 0
	breathgas = "carbon dioxide"

/obj/item/organ/lungs/exotic/n2 // different from vox lungs, they only need 4kpa of n2 to breathe, these need the full 16 kpa
	safe_nitro_min = 16
	breathgas = "nitrogen"

/obj/item/organ/lungs/exotic/plasma // ditto 108 but for plasmamen lungs
	safe_plasma_min = 16
	safe_plasma_max = 0
	breathgas = "plasma"
