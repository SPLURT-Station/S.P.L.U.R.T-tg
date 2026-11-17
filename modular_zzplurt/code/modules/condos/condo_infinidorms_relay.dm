/// SPLURT infinidorm relay network.
///
/// The codebase keeps a single actual teleportation unit on the interlink; every other map
/// receives thin relay units through the modular automapper instead. Relays look and read
/// exactly like the actual unit, but they route their network identity (such as which side of
/// the ghost cafe network they belong to) into the primary unit, so all entries across the
/// codebase stay pointed at the same infinidorm network.

/datum/controller/subsystem/condos
	/// Every live condo teleporter unit, relays included. Used to resolve the network primary.
	var/list/splurt_registered_teleporters = list()
	/// The unit that relay entries route their configuration to.
	var/obj/machinery/cafe_condo_teleporter/splurt_primary_teleporter

/// Registers a teleporter unit with the relay network.
/datum/controller/subsystem/condos/proc/splurt_register_teleporter(obj/machinery/cafe_condo_teleporter/teleporter)
	if(QDELETED(teleporter) || (teleporter in splurt_registered_teleporters))
		return
	LAZYADD(splurt_registered_teleporters, teleporter)
	if(QDELETED(splurt_primary_teleporter) && splurt_is_primary_candidate(teleporter))
		splurt_primary_teleporter = teleporter

/// Removes a teleporter unit, promoting a replacement if the primary was lost.
/datum/controller/subsystem/condos/proc/splurt_unregister_teleporter(obj/machinery/cafe_condo_teleporter/teleporter)
	LAZYREMOVE(splurt_registered_teleporters, teleporter)
	if(splurt_primary_teleporter == teleporter)
		splurt_primary_teleporter = null
		splurt_get_primary_teleporter()

/// Returns TRUE when a unit is allowed to serve as the network's primary entry point.
/// Relays never qualify, and ghost cafe units only ever serve their own side of the network.
/datum/controller/subsystem/condos/proc/splurt_is_primary_candidate(obj/machinery/cafe_condo_teleporter/teleporter)
	if(QDELETED(teleporter) || teleporter.is_relay)
		return FALSE
	return !teleporter.get_ghost_cafe_side()

/// Resolves the network primary, lazily recovering from load order races and deletions.
/datum/controller/subsystem/condos/proc/splurt_get_primary_teleporter()
	if(!QDELETED(splurt_primary_teleporter))
		return splurt_primary_teleporter
	splurt_primary_teleporter = null
	for(var/obj/machinery/cafe_condo_teleporter/teleporter as anything in splurt_registered_teleporters)
		if(splurt_is_primary_candidate(teleporter))
			splurt_primary_teleporter = teleporter
			break
	return splurt_primary_teleporter

/obj/machinery/cafe_condo_teleporter
	/// Marks a unit as a thin relay that routes into the primary unit's configuration.
	var/is_relay = FALSE

/obj/machinery/cafe_condo_teleporter/Initialize(mapload)
	. = ..()
	SScondos.splurt_register_teleporter(src)

/obj/machinery/cafe_condo_teleporter/Destroy()
	if(!QDELETED(SScondos))
		SScondos.splurt_unregister_teleporter(src)
	return ..()

/// A relay entry unit: looks and reads exactly like the actual unit, but keeps the primary
/// unit's network identity while remaining the physical access point users enter from.
/obj/machinery/cafe_condo_teleporter/relay
	is_relay = TRUE

/obj/machinery/cafe_condo_teleporter/relay/examine(mob/user)
	. = ..()
	. += span_notice("A small tag on its casing reads: \"Relayed to the central hotel hub\".")

/obj/machinery/cafe_condo_teleporter/relay/get_ghost_cafe_side()
	var/obj/machinery/cafe_condo_teleporter/primary = SScondos.splurt_get_primary_teleporter()
	if(primary)
		return primary.get_ghost_cafe_side()
	return FALSE
