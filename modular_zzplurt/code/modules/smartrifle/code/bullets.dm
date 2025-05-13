//smartrifle
/obj/item/ammo_casing/smartrifle
	name = "smartrifle rail frame"
	icon = 'modular_zzplurt/icons/obj/weapons/guns/smartriflerail.dmi'
	icon_state = "smartrifle"
	desc = "A rail that fits the SMARTrifle. Specially fitted to hold a taser bolt for those unruly assistants."
	caliber = "smartrifle"
	projectile_type = /obj/projectile/bullet/smartrifle
	can_be_printed = FALSE

/obj/projectile/bullet/smartrifle
	name = "smartrifle rail"
	icon_state = "gauss_silenced"
	embed_type = /datum/embedding/smartrail
	damage = 10
	stamina = 70
	armour_penetration = 30
	ricochets_max = 4 //Originally 6
	ricochet_incidence_leeway = 0
	ricochet_chance = 130
	ricochet_decay_damage = 0.75 // 70/10 -> ~53/~8 -> ~39/~6 -> ~30/~4 -> ~22/~3
	shrapnel_type = /obj/item/shrapnel/bullet/smartrifle
	hitsound = 'modular_zzplurt/code/modules/smartrifle/sound/rail.ogg'

/obj/projectile/bullet/smartrifle/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.emote("scream")
		H.add_mood_event("tased", /datum/mood_event/tased)
		if((H.status_flags & CANKNOCKDOWN) && !HAS_TRAIT(H, TRAIT_STUNIMMUNE))
			addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon, do_jitter_animation), jitter), 5)

/obj/item/shrapnel/bullet/smartrifle
	name = "smartrifle shredder"
	icon = 'icons/obj/weapons/guns/projectiles.dmi'
	icon_state = "gaussphase"
	embed_type = null

/datum/embedding/smartrail
	embed_chance = 100
	fall_chance = 2
	pain_stam_pct = 10
	pain_mult = 3
	jostle_chance = 0
	jostle_pain_mult = 0
	ignore_throwspeed_threshold = TRUE
	rip_time = 1 SECONDS
