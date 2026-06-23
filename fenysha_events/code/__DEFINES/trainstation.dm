#define TRAIN_STATION_DMM_DIR(_filename) ("_maps/modular_events/trainstation/" + _filename)

#define ZTRAIT_TRAINSTATION "Trainstation"
#define NO_TURF_MOVEMENT_1 (1<<32)

#define TRAIT_NO_STATION_UNLOAD "!no_unload"

/// Абстрактная станция, не будет отображаться в меню train_controll'ера, не будет связана с другими станциями
#define TRAINSTATION_ABSCTRACT (1 << 1)
#define TRAINSTATION_NO_FORKS (1 << 2)
#define TRAINSTATION_BLOCKING (1 << 3)
#define TRAINSTATION_NO_SELECTION (1 << 4)
#define TRAINSTATION_NO_NEARSTATION (1 << 5)
#define TRAINSTATION_NO_SPAWNING (1 << 6)
#define TRAINSTATION_LOCAL_CENTER (1 << 7)
#define TRAINSTATION_START_STATION (1 << 8)
#define TRAINSTATION_FINAL_STATION (1 << 9)

#define TRAINSTATION_REGION_THUNDRA "Thundra"
#define TRAINSTATION_REGION_TEMPERATE "Temperate"
#define TRAINSTATION_REGION_DESERT "Desert"

#define TRAINSTATION_TYPE_CARGO "Cargo"
#define TRAINSTATION_TYPE_EMERGENCY "Emergency"
#define TRAINSTATION_TYPE_MILITARY "Military"
#define TRAINSTATION_TYPE_CITY "City"

#define THREAT_LEVEL_SAFE "Safe"
#define THREAT_LEVEL_RISKY "Risky"
#define THREAT_LEVEL_DANGEROUS "Dangerous"
#define THREAT_LEVEL_HAZARDOUS "Hazardous"
#define THREAT_LEVEL_DEADLY "Deadly"


#define FACTION_CIVILIAN "civilian"
#define FACTION_POLICE "police"
#define FACTION_MILITARY "military"
#define FACTION_KHARA "khara"

#define TRAIT_KHARAMUTANT "khara_mutant"
#define TRAIT_GRANTEDKHARA_REBORN "granted_khara_reborn"
#define TRAIT_CURED_KHARA "khara_cured"
#define TRAIT_AREA_MORPENGINE "area_under_morhengine"
#define TRAIT_AREA_MORPENGINE_HAZARD "area_under_morhenginehazard"
#define TRAIT_ALWAYS_PENETRAIT_KHARA "always_penetrate_khara"

#define BB_MOB_ABILITY_BONESHARD "bb_ability_boneshard"
#define BB_MOB_ABILITY_LEAP "bb_ability_leap"
#define BB_MOB_ABILITY_MEAT_BALL "bb_ability_meatball"
#define BB_MOB_ABILITY_RUMBLE "bb_ability_rumble"
#define BB_MOB_AILITY_SLASH "bb_ability_slash"
#define BB_MOB_ABILITY_FAST_CHARGE "bb_ability_fast_charge"
#define BB_MOB_ABILITY_CRUSH_CHARGE "bb_ability_crush_charge"
#define BB_MOB_ABILITY_CRUSH_WAVE "bb_ability_crush_wave"
#define BB_MOB_ABILITY_CRUSH_MECH "bb_ability_crush_mech"
#define BB_MOB_ABILITY_CONSUME "bb_ability_consume"

#define BB_NPC_PATROL_POINT "bb_npc_patrol_point"
#define BB_BASIC_MOB_CUFF_TYPE "bb_cuff_type"
#define BB_BASIC_MOB_DEFAULT_CUFF_TYPE (/obj/item/restraints/handcuffs/cable/zipties/used)
#define BB_BASIC_MOB_BEGIN_CUFFING "bb_begin_cuffing"
#define BB_MEMORY_LAST_TARGET "bb_memo_last_target"
#define BB_MEMORY_LAST_TARGET_TIME "bb_memo_last_target_time"

#define BB_MEMORY_ENEMIES_LIST "enemies_list"

#define KHARA_CAST_LESSER "Низшие"
#define KHARA_CAST_ADAPTED "Адаптированные"
#define KHARA_CAST_ASSIMILATING "Ассмилирующие"

#define KHARA_POWER_WEAK 1
#define KHARA_POWER_STRONG 2
#define KHARA_POWER_VERY_STRONG 3


/proc/find_nearest_ally(atom/source, faction, range = 12)
	var/closest
	var/closest_dist = INFINITY
	for(var/mob/living/basic/M in view(range, source))
		if(M == source || !M.has_faction(faction))
			continue
		var/dist = get_dist(source, M)
		if(dist < closest_dist)
			closest = M
			closest_dist = dist
	return closest


#define LASER_SWEEP_PI 3.1415926535

/proc/get_farthest_turf_at_angle(turf/start, angle_deg, max_dist = 60)
	if(!start)
		return null
	var/rad = angle_deg * LASER_SWEEP_PI / 180
	var/dx = cos(rad)
	var/dy = sin(rad)
	var/turf/last_clear = start

	for(var/i in 1 to max_dist)
		var/next_x = start.x + (dx * i)
		var/next_y = start.y + (dy * i)
		var/turf/next = locate(ceil(next_x), ceil(next_y), start.z)
		if(!next || next.density)
			return last_clear
		last_clear = next
	return last_clear

/proc/get_ray_path(turf/start, angle_deg, max_dist = 60)
	if(!start)
		return list()
	var/rad = angle_deg * LASER_SWEEP_PI / 180
	var/dx = cos(rad)
	var/dy = sin(rad)
	var/list/path = list()


	for(var/i in 1 to max_dist)
		var/next_x = start.x + dx * i
		var/next_y = start.y + dy * i
		var/turf/next = locate(ceil(next_x), ceil(next_y), start.z)
		if(!next || next.density)
			break
		path += next
	return path

/proc/get_angle_between(turf/t1, turf/t2)
	if(!t1 || !t2 || t1.z != t2.z)
		return 0

	var/dx = t2.x - t1.x
	var/dy = t2.y - t1.y


	var/angle_rad = ATAN2(dy, dx)

	var/angle_deg = angle_rad * 180 / PI
	if(angle_deg < 0)
		angle_deg += 360

	return round(angle_deg)
