// Port of the classic one-way turnstile from the old SPLURT base.
// NOTE: modern /tg/ (and our upstream Skyrat fork) replaced turnstiles with
// /obj/machinery/prisongate (see tools/UpdatePaths/Scripts_Skyrat/14650_replace_turnstiles.txt),
// so the old /obj/machinery/turnstile type no longer exists upstream.
// This port intentionally restores the classic object per issue #76.

///Rate limiting on bumping the turnstile, to avoid spamming messages and sounds.
#define TURNSTILE_BUMP_COOLDOWN 5

/obj/machinery/turnstile
	name = "turnstile"
	desc = "A mechanical door that permits one-way access and prevents tailgating."
	icon = 'modular_zzplurt/icons/obj/turnstile.dmi'
	icon_state = "turnstile_map"
	density = FALSE
	armor_type = /datum/armor/machinery_turnstile
	anchored = TRUE
	use_power = NO_POWER_USE
	idle_power_usage = 2
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = OPEN_DOOR_LAYER
	// Atmos is never blocked by the turnstile, matching the old CanAtmosPass() override.
	can_atmos_pass = ATMOS_PASS_YES

/datum/armor/machinery_turnstile
	melee = 50
	bullet = 50
	laser = 50
	energy = 50
	bomb = 10
	bio = 100
	rad = 100
	fire = 90
	acid = 70

/obj/machinery/turnstile/Initialize(mapload)
	. = ..()
	icon_state = "turnstile"
	var/static/list/loc_connections = list(
		COMSIG_ATOM_EXIT = PROC_REF(on_exit),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/// Returns TRUE if the mob (or whoever is pulling them) may pass the turnstile.
/// Access requirements are set through the standard req_access / req_one_access lists.
/obj/machinery/turnstile/proc/allowed_access(mob/passenger)
	if(passenger.pulledby)
		return allowed(passenger.pulledby) || allowed(passenger)
	return allowed(passenger)

// Only lets people through from behind, and only if they have access.
// Overrides CanPass directly (rather than CanAllowThrough) because the turnstile
// is not dense; its blocking is entirely proc-driven.
/obj/machinery/turnstile/CanPass(atom/movable/mover, border_dir)
	if(mover.movement_type & PHASING)
		return ..()
	if(istype(mover, /obj/projectile))
		return TRUE
	if(istype(mover, /obj/item))
		return TRUE
	if(!isliving(mover))
		return FALSE
	var/mob/living/walker = mover
	if(world.time - walker.last_bumped <= TURNSTILE_BUMP_COOLDOWN)
		return FALSE
	walker.last_bumped = world.time
	// The turnstile only operates when approached from the side it faces.
	if(border_dir != REVERSE_DIR(dir))
		to_chat(walker, span_notice("\the [src] resists your efforts."))
		return FALSE
	if(allowed_access(walker))
		flick("operate", src)
		playsound(src, 'sound/items/tools/ratchet.ogg', 50, FALSE, 3)
		return TRUE
	flick("deny", src)
	playsound(src, 'sound/machines/beep/deniedbeep.ogg', 50, FALSE)
	return FALSE

/// Prevents mobs from slipping out the sides of the turnstile once on its tile.
/obj/machinery/turnstile/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER

	if(istype(leaving, /obj/projectile) || istype(leaving, /obj/item))
		return
	if(!isliving(leaving))
		return
	var/mob/living/walker = leaving
	// People with access walk straight through; everyone else has to backtrack.
	var/exit_dir = allowed_access(walker) ? REVERSE_DIR(dir) : dir
	var/turf/exit_turf = get_step(src, exit_dir)
	var/turf/destination = get_step(src, direction)
	var/can_exit = (destination == src.loc) || (destination == exit_turf)
	if(!can_exit && world.time - walker.last_bumped <= TURNSTILE_BUMP_COOLDOWN)
		to_chat(walker, span_notice("\the [src] resists your efforts."))
	walker.last_bumped = world.time
	if(!can_exit)
		return COMPONENT_ATOM_BLOCK_EXIT

#undef TURNSTILE_BUMP_COOLDOWN
