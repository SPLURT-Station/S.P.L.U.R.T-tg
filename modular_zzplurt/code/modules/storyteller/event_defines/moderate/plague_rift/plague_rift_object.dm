//Straight ctrl+c -> ctrl+v of the clown rift and code, but with vermin
/obj/effect/countdown/plague_rift
	name = "Plague rift countdown"

/obj/effect/countdown/plague_rift/get_value()
	var/obj/effect/plague_rift/rift = attached_to
	if(!istype(rift))
		return
	var/seconds_left = max(0, (rift.death_time - world.time) / 10)
	return "[round(seconds_left)]"

/obj/effect/plague_rift
	name = "plague rift"
	desc = "A tear in the fabric of reality, leading to a dimension overflowing with dangerous vermin."
	icon = 'modular_zzplurt/icons/effects/plague_rift.dmi'
	icon_state = "rift_forming"
	density = FALSE
	anchored = TRUE
	/// Time it takes for the plague rift to fully form
	var/formation_time = 20 SECONDS
	/// Is the plague rift fully formed and active?
	var/formed = FALSE
	/// Time it takes for the rift to explode and despawn
	var/lifespan = 90 SECONDS
	var/form_time
	var/death_time
	/// countdown of the rift's inevitable doom
	var/obj/effect/countdown/plague_rift/countdown
	/// List of types we can throw out
	var/list/typelist = list(
		/mob/living/basic/cockroach = 100,
		/mob/living/basic/cockroach/sewer = 100,
		/mob/living/basic/cockroach/bloodroach = 100,
		/mob/living/basic/cockroach/hauberoach = 1000,
		/mob/living/basic/cockroach/hauberoach/imperial = 1000,
		/mob/living/basic/cockroach/glockroach = 1000,
		/mob/living/basic/cockroach/glockroach/gang = 1000,
		/mob/living/basic/cockroach/glockroach/mobroach = 1000,
		/mob/living/basic/cockroach/glockroach/mobroach/goon = 1000,
		/mob/living/basic/cockroach/laseroach = 1000,
		/mob/living/basic/cockroach/laseroach/space_police = 1000,
		/mob/living/basic/cockroach/laseroach/hellfire = 1000,
		/mob/living/basic/cockroach/laseroach/hellfire/space_police = 1000,
		/mob/living/basic/cockroach/laseroach/musket = 1000,
		/mob/living/basic/cockroach/laseroach/musket/space_police = 1000,
		/mob/living/basic/cockroach/disableroach = 1000,
		/mob/living/basic/cockroach/disableroach/space_police = 1000,
		/mob/living/basic/cockroach/hauberoach/responsoroach = 30,
		/mob/living/basic/cockroach/nuclear_operoach = 1,
		/mob/living/basic/frog/crazy = 100,
		/mob/living/basic/mouse/rat = 100,
		/mob/living/basic/snail/angry = 100,
		/mob/living/basic/spider/growing/spiderling/hunter = 100,
		/mob/living/basic/bee/toxin = 10000,
		/mob/living/basic/heretic_summon/fire_shark/wild = 500,
		/obj/item/organ/heart/roach = 100,
		/obj/item/organ/liver/roach = 100,
		/obj/item/organ/stomach/roach = 100,
		/obj/item/organ/appendix/roach = 100,
		/obj/item/grown/bananapeel = 100,
		/obj/item/fish/clownfish/lube = 3000,
	)

/obj/effect/plague_rift/Initialize(mapload)
	. = ..()
	if(!mapload)
		SSpoints_of_interest.make_point_of_interest(src)

	START_PROCESSING(SSobj, src)
	death_time = world.time + lifespan
	form_time = world.time + formation_time
	countdown = new(src)
	countdown.start()

/// Processes the plague rift fully activating
/obj/effect/plague_rift/proc/form()
	formed = TRUE
	icon_state = "rift_formed"
	playsound(src, 'sound/machines/gateway/gateway_open.ogg', 100, TRUE)

/obj/effect/plague_rift/process(seconds_per_tick)
	if(formed)
		pick_and_throw(seconds_per_tick)
		for(var/mob/living/carbon/victim in view(5, src))
			if(prob(33))
				throw_oil(get_turf(victim))
		if(death_time < world.time)
			explode()
		else if(prob(10))
			playsound(src, 'sound/effects/splat.ogg', 100, TRUE)
	else if(form_time < world.time)
		form()

/obj/effect/plague_rift/proc/pick_and_throw()
	var/typepath
	// Choose the category before choosing the individual spawn.
	if(prob(45))
		typepath = pick_weight_recursive(GLOB.trash_loot)
	else
		typepath = pick_weight_recursive(typelist)
	if(!typepath)
		return

	// Both items and mobs inherit from /atom/movable.
	var/atom/movable/to_throw = new typepath(get_turf(src))
	var/list/turf_targets = list()
	for(var/turf/target in oview(5, src))
		turf_targets += target

	if(length(turf_targets))
		to_throw.throw_at(pick(turf_targets), 5, 2)

/// Flying oil that becomes a slippery puddle on impact.
/obj/effect/plague_oil_glob
	name = "glob of oil"
	desc = "A flying blob of filthy motor oil."
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	color = "#2D2D2D"
	density = FALSE
	anchored = FALSE
	move_resist = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/plague_oil_glob/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	// Use our landing tile, so hitting a wall leaves oil beside it.
	var/turf/landing_turf = get_turf(src)
	if(isopenturf(landing_turf) && !isspaceturf(landing_turf))
		// Avoid repeatedly creating the same slick on one tile.
		if(!(locate(/obj/effect/decal/cleanable/blood/oil/slippery) in landing_turf))
			new /obj/effect/decal/cleanable/blood/oil/slippery(landing_turf)

	qdel(src)

/obj/effect/plague_rift/proc/throw_oil(atom/target)
	if(!target)
		return

	var/obj/effect/plague_oil_glob/oil = new(get_turf(src))
	if(!oil.throw_at(target, 7, 5, spin = FALSE))
		qdel(oil)
		return

	playsound(src, 'sound/effects/splat.ogg', 100)

/// create a last hail mary of filth and qdel self
/obj/effect/plague_rift/proc/explode()
	playsound(src, 'sound/machines/gateway/gateway_close.ogg', 100, TRUE)
	for(var/i=0, i<7, i++)
		pick_and_throw()
	for(var/mob/living/carbon/victim in view(7, src))
		throw_oil(get_turf(victim))
	sleep(1 SECONDS)

	var/turf/drop_turf = get_turf(src)

	// Pick a fresh random visible target for each piece of thrown trash.
	var/list/trash_targets = list()
	for(var/turf/target in oview(6, src))
		trash_targets += target

	// Five independent trash-tier maintenance loot rolls.
	for(var/trash_roll in 1 to 5)
		var/trash_type = pick_weight_recursive(GLOB.trash_loot)
		if(!trash_type)
			continue
		var/atom/movable/trash = new trash_type(drop_turf)
		if(length(trash_targets))
			trash.throw_at(
				pick(trash_targets),
				range = 9,
				speed = 4,
				force = MOVE_FORCE_STRONG,
			)

	// One guaranteed wild fireshark
	new /mob/living/basic/heretic_summon/fire_shark/wild(drop_turf)

	// Three independent uncommon maintenance loot rolls.
	for(var/loot_roll in 1 to 3)
		var/uncommon_type = pick_weight_recursive(GLOB.uncommon_loot)
		new uncommon_type(drop_turf)

	// One rare maintenance loot roll.
	var/rare_type = pick_weight_recursive(GLOB.rarity_loot)
	new rare_type(drop_turf)

	qdel(src)

/obj/effect/plague_rift/Destroy(force)
	. = ..()
	if(!isnull(countdown))
		qdel(countdown)
