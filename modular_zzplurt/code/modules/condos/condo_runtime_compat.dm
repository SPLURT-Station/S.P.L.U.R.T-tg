/// Runtime compatibility for legacy SPLURT condo templates loaded through the
/// upstream condo reservation system.

/turf/open/lava/fake/Initialize(mapload)
	for(var/turf_trait in give_turf_traits)
		ADD_TRAIT(src, turf_trait, INNATE_TRAIT)
	. = ..()

/turf/open/water/hot_spring/enter_hot_spring(atom/movable/movable)
	if(is_type_in_typecache(movable, GLOB.immerse_ignored_movable))
		return FALSE
	RegisterSignal(movable, SIGNAL_ADDTRAIT(TRAIT_IMMERSED), PROC_REF(dip_in), TRUE)
	if(isliving(movable))
		RegisterSignal(movable, SIGNAL_REMOVETRAIT(TRAIT_IMMERSED), PROC_REF(dip_out), TRUE)

	if(HAS_TRAIT(movable, TRAIT_IMMERSED))
		dip_in(movable)

/turf/closed/wall/register_context()
	flags_1 |= HAS_CONTEXTUAL_SCREENTIPS_1
	RegisterSignal(src, COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM, "add_context", TRUE)
