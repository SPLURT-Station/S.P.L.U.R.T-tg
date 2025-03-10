/datum/preference/choiced/backpack/init_possible_values()
	. = ..()
	var/list/extra_backpacks = list(
		SNAIL_SHELL,
		SLOOG_SHELL,
	)
	LAZYADD(., extra_backpacks)

/datum/preference/choiced/backpack/icon_for(value)
	. = ..()
	switch (value)
		if (SNAIL_SHELL)
			return /obj/item/storage/backpack/snail_replica
		if (SLOOG_SHELL)
			return /obj/item/storage/backpack/sloogshell

/datum/preference/choiced/underwear
	priority = PREFERENCE_PRIORITY_DEFAULT

/datum/preference/choiced/undershirt
	priority = PREFERENCE_PRIORITY_DEFAULT

/datum/preference/choiced/socks
	priority = PREFERENCE_PRIORITY_DEFAULT

/datum/preference/choiced/bra
	priority = PREFERENCE_PRIORITY_DEFAULT
