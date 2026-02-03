/*
I don't like making promises
Because if I change my mind about how I feel of that person
I might not want to fufill my promise anymore.

Ugora Orbit Hardlight Energy Bow
With help of an aussie catgirl
*/

/datum/supply_pack/security/armory/sechardbow
	name = "Hardlight Energy Bow"
	desc = "A three pack of hardlight energy bow, manually charged with by pulling back the string, virtually limitless ammunition."
	cost = CARGO_CRATE_VALUE * 30
	contains = list(/obj/item/gun/energy/laser/energy_bow = 3)
	crate_name = "hardlight energy bow"

/obj/item/gun/energy/laser/energy_bow
	name = "hardlight bow"
	desc = "A modern version of the Ugoran Bow used by the Citadel"
	icon = 'modular_zzplurt/modules/modular_weapons/icons/obj/company_and_or_faction_based/ugora_orbit/guns48x.dmi'

	shaded_charge = FALSE
	charge_sections = 1

	icon_state = "thisfuckingbow"
	inhand_icon_state = "yato"
	base_icon_state = "thisfuckingbow"

	lefthand_file = 'modular_zzplurt/modules/modular_weapons/icons/mob/company_and_or_faction_based/ugora_orbit/guns_lefthand.dmi'
	righthand_file = 'modular_zzplurt/modules/modular_weapons/icons/mob/company_and_or_faction_based/ugora_orbit/guns_righthand.dmi'
	worn_icon = 'modular_skyrat/modules/modular_weapons/icons/mob/company_and_or_faction_based/ugora_orbit/guns_worn.dmi'
	worn_icon_state = "yato"
	ammo_type = list(/obj/item/ammo_casing/energy/hardlight_bow)
	/// An ID for our drop discharge timer.
	var/drop_discharge_timerid

/obj/item/gun/energy/laser/energy_bow/equipped(mob/user, slot, initial)
    . = ..()
    if(slot != ITEM_SLOT_HANDS)
        discharge()

/obj/item/gun/energy/laser/energy_bow/examine_more(mob/user)
	. = ..()
	. += span_info("The Hardlight Energy bow can be actively drawn while you're on the move. \
		However, it will self-discharge if not actively being held and drawn, so you must always hold it out.")
	. += span_notice("This weapon was primarily used by the knights protecting the Y Ark. \
		These knights were both a form of military and policing force. \
		Before you is a weapon developed by a station that no longer exists and wielded by many faceless brave men and women, all of whom made a difference in the history of our galaxy \
		To this day, the shadow government of Ugora Orbit has yet to be contacted by any forces, Solarian or otherwise, and only through arms trade like these were we able to get insight into their culutres.")

//Please keep in mind when reading the value below
//The bow discharge when it is not being held in hand. This is a balance measure. To keep it fair
//As, afterall. This bow does actually embed target.
/obj/item/gun/energy/laser/energy_bow/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/crank_recharge, \
		charging_cell = get_cell(), \
		charge_amount = STANDARD_CELL_CHARGE, \
		cooldown_time = 1.6 SECONDS, \
		charge_sound = 'sound/items/weapons/gun/bow/bow_draw.ogg', \
		charge_sound_cooldown_time = 0.2 SECONDS, \
		charge_move = IGNORE_USER_LOC_CHANGE, \
	)
	discharge()

/obj/item/gun/energy/laser/energy_bow/equipped(mob/user, slot, initial)
	. = ..()
	if(slot != ITEM_SLOT_HANDS)
		discharge()

/obj/item/gun/energy/laser/energy_bow/dropped()
	. = ..()
	if(!QDELING(src))
		//borrowed from /obj/item/gun/energy/recharge/dropped, as explained there,
		//Put it on a delay because moving item from slot to hand. This is because people may do a quickpull out and swap for damage, that is something I am vehemently against.
		//It won't stop it, but it doesn't need to, it only needs to make it harder. Think: Pull MCR Lancer out and do instant 45 damage.
		// calls dropped().
		addtimer(CALLBACK(src, PROC_REF(discharge_if_not_held)), 0.1 SECONDS)

/obj/item/gun/energy/laser/energy_bow/proc/discharge_if_not_held()
	if(!ismob(loc))
		discharge()
		deltimer(drop_discharge_timerid)

/obj/item/gun/energy/laser/energy_bow/proc/discharge()
	if(cell)
		cell.use(cell.charge)
	update_appearance()

//I don't think we can do the energy pilum right now so we'll leave this here as the footer.
//We'll figure it out in a separate PR.
