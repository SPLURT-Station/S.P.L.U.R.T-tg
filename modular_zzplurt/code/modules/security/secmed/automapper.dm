/// This blacklist is used for preventing the automapper from spawning a secmed locker, used for stations that already have a locker in them.
/datum/area_spawn/secmed_locker/New()
	blacklisted_stations = list("Biodome", "Blueshift", "Box Station", "Delta Station", "Ice Box Station", "Kilo Station", "MetaStation", "Moon Station", "NebulaStation", "Ouroboros", "Tramstation", "Void Raptor")
	. = ..()
