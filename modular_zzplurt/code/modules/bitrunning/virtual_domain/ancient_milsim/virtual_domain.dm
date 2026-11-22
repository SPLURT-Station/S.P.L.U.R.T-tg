// modular override for some balance changes
// Placing the disk in a cache was *cool* but led to runs that ended without a disk drop *or* getting the disk w/o a victory
/datum/lazy_template/virtual_domain/ancient_milsim
	completion_loot = list(/obj/item/stack/spacecash/c200 = 3, /obj/item/disk/bitrunning/item/ancient_milsim = 1)
	secondary_loot = list(
		/obj/item/stack/spacecash/c100 = 12,
	)
