/obj/item/ammo_casing/energy/hardlight_bow
	desc = "IF YOU CAN READ THIS PLEASE CONTACT KALI ON DISCORD"
	projectile_type = /obj/projectile/energy_arrow
	e_cost = LASER_SHOTS(1, STANDARD_CELL_CHARGE)

/obj/projectile/energy_arrow
	name = "energy arrow"
	desc = "IF YOU CAN READ THIS PLEASE CONTACT KALI ON DISCORD"
	icon = 'modular_zzplurt/modules/modular_weapons/icons/obj/company_and_or_faction_based/ugora_orbit/projectile.dmi'
	icon_state = "arrow_energy"
	damage = 35
	armour_penetration = 20 //So that it is less likely to be blocked.
	speed = 1.6
	range = 12

	embed_type = /datum/embedding/energy_arrow
	wound_bonus = 15

/datum/embedding/energy_arrow
	embed_chance = 30
	fall_chance = 35
	jostle_chance = 60
	ignore_throwspeed_threshold = TRUE
	pain_stam_pct = 1
	pain_mult = 2
	jostle_pain_mult = 0.6 //We don't want people to literally stunlock from walking.
	rip_time = 0.1 SECONDS //Takes no time at all to remove, it's not a physical projectile.
