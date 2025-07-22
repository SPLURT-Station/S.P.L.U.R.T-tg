/obj/item/gun/energy/event_horizon
	name = "\improper Pulsar hyper-resonance beam rifle"
	desc = "While the masterminds of the Event Horizon chased oblivion, the team behind the Pulsar sought control. Developed in the wake of anti-existential deployment backlash, this weapon represents a more measured apocalypse. This weapon melts everything in its path with the precision of a scalpel and the elegance of a dying star."
	icon = 'modular_zzplurt/icons/obj/weapons/guns/energy.dmi'
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_righthand.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/back.dmi'

/obj/item/ammo_casing/energy/event_horizon
	select_name = "hyper-resonant"

/obj/projectile/beam/event_horizon
	name = "hyper-resonant beam"
	damage = 100
	projectile_piercing = PASSMOB|PASSVEHICLE
	max_pierces = 3
	armour_penetration = 30
	jitter = 5 SECONDS
	hitscan_light_intensity = 3
	hitscan_light_range = 0.75
	hitscan_light_color_override = COLOR_BLUE_LIGHT

/obj/projectile/beam/event_horizon/generate_hitscan_tracers(impact_point = TRUE, impact_visual = TRUE, duration = 2.4 SECONDS) // Duration customization was generalized in the projectile.dm file.
	. = ..()

/obj/effect/projectile/tracer/tracer/beam_rifle
	icon = 'modular_zzplurt/icons/obj/weapons/guns/projectiles_tracer.dmi'
	icon_state = "pulsar_beam"

/obj/projectile/beam/event_horizon/on_hit(atom/target, blocked, pierce_hit)
	. = ..()

	if(. == BULLET_ACT_HIT)
		explosion(src, heavy_impact_range = 1, light_impact_range = 2, flame_range = 2, flash_range = 2, adminlog = FALSE)

/datum/crafting_recipe/beam_rifle
	name = "Pulsar hyper-resonance beam rifle"
	reqs = list(
		/obj/item/assembly/signaler/anomaly/flux = 1,
		/obj/item/assembly/signaler/anomaly/grav = 1,
		/obj/item/assembly/signaler/anomaly/bluespace = 1,
		/obj/item/weaponcrafting/gunkit/beam_rifle = 1,
		/obj/item/gun/energy/e_gun = 1,
	)

/obj/item/weaponcrafting/gunkit/beam_rifle
	name = "\improper Pulsar hyper-resonance beam rifle part kit"
	desc = "A lattice of advanced alloys and stubborn physics, forged not to contain power, but to politely ask it to stay put. A lesson in humility, written in plasma."

/datum/design/beamrifle
	name = "Pulsar Hyper-Resonance Beam Rifle Part Kit"
	desc = "A tidy box of parts engineered to vaporize problems at the speed of light. Comes with instructions, regrets, and a small sticker that says 'Handle With Awe.'"
