#define DONATOR_TOML_FILE "[global.config.directory]/splurt/donator.toml"

/datum/player_rank_controller/donator/load_from_query(datum/db_query/query)
	. = ..()
	load_from_toml()

/datum/player_rank_controller/donator/proc/load_from_toml()
	var/list/donators = rustg_read_toml_file(DONATOR_TOML_FILE)
	if(!donators)
		CRASH("Attempted to read toml donator file, but none was found!")

	for(var/tier in donators["donators"])
		var/tier_num = text2num(replacetext(tier, "tier_", ""))
		if(isnull(tier_num))
			CRASH("Invalid tier found in toml donator file: [tier]")

		for(var/ckey in donators["donators"][tier])
			GLOB.donator_list[ckey] = tier_num

