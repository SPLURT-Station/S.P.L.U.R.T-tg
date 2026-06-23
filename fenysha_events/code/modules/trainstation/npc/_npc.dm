/proc/is_npc(thing)
	return istype(thing, /mob/living/basic/npc)

/mob/living/basic/npc
	name = "Гражданский"
	desc = ""
	icon = 'icons/mob/simple/simple_human.dmi'
	health = 150
	maxHealth = 150
	speed = 1.5
	mob_biotypes = MOB_ORGANIC | MOB_HUMANOID
	basic_mob_flags = FLAMMABLE_MOB | SENDS_DEATH_MOODLETS
	sentience_type = SENTIENCE_HUMANOID
	attack_verb_continuous = "бьёт кулаком"
	attack_verb_simple = "ударить кулаком"
	attack_sound = 'sound/items/weapons/punch1.ogg'
	melee_damage_lower = 10
	melee_damage_upper = 10
	unsuitable_atmos_damage = 7.5
	unsuitable_cold_damage = 7.5
	unsuitable_heat_damage = 7.5
	max_stamina = 150
	stamina_recovery = 5
	max_stamina_slowdown = 12
	faction = list(FACTION_CIVILIAN, FACTION_NEUTRAL)

	ai_controller = /datum/ai_controller/basic_controller/civilian

	var/possible_outfits = list()
	var/outfit
	var/species = /datum/species/human
	var/mob_type = /obj/effect/mob_spawn/corpse/human
	var/item_l_hand
	var/item_r_hand
	var/call_for_help = TRUE
	var/make_random_name = TRUE
	var/ghost_controlable = TRUE
	var/join_text = "Вы NPC, соблюдайсте стандартвые правила RP, помните, что вы лишь часть истории - а не её центр."
	var/important_text = "Не гриферите игроков!"

	var/randomize_mutant_colors = FALSE
	var/add_hair = TRUE
	var/mutant_color_1 = COLOR_WHITE
	var/mutant_color_2 = COLOR_WHITE
	var/mutant_color_3 = COLOR_WHITE

	var/anchor_search_range = 5
	var/mapping_anchor = null

	var/innate_actions = list()

	var/ranged = FALSE
	var/casingtype = /obj/item/ammo_casing/c9mm
	var/projectilesound = 'sound/items/weapons/gun/pistol/shot.ogg'
	var/burst_shots
	var/ranged_cooldown = 1 SECONDS

	var/speech_chance = 20
	var/list/speech_phrases = list(
		"Тише… стены слушают.",
		"Сирены всю ночь напролёт… опять.",
		"Никогда не верь объявлениям.",
		"%MOBNAME%, ты тоже кашляешь?",
		"Говорят, скоро всё закончится…",
		"Я уже забыл, как пахнет чистый воздух.",
		"Прошлой ночью кого-то снова забрали.",
		"Не подходи к блокпосту без маски.",
		"Вчера был сосед… сегодня — пусто.",
		"Всё под контролем, да? Хех…",
		"Скоро опять локдаун, чувствую.",
		"Глаза болят… эта пыль опять.",
		"Кто-нибудь видел солнце без фильтров?",
		"Не спрашивай, откуда этот шрам.",
		"Просто держись подальше от новостей."
	)

	var/list/speech_emote_see = list(
		"нервно оглядывается по сторонам.",
		"прижимает руку ко рту и кашляет.",
		"вздрагивает от далёкой сирены.",
		"сжимает кулаки и смотрит в пустоту.",
		"быстро натягивает маску на нос.",
		"трёт покрасневшие глаза и морщится.",
		"замирает, напряжённо прислушиваясь.",
		"прячет руки в рукава и сутулится.",
		"бессознательно трогает горло."
	)

	var/list/speech_emote_hear = list(
		"шепчет почти неслышно: «они следят…»",
		"бормочет проклятия низким хриплым голосом.",
		"хрипло кашляет и сплёвывает в сторону.",
		"бормочет: «ещё один день… ещё один…»",
		"издаёт короткий сдавленный всхлип и замолкает.",
		"медленно выдыхает сквозь стиснутые зубы.",
		"шепчет трёхсловную молитву и умолкает.",
		"тихо повторяет: «не оглядывайся… не оглядывайся…»"
	)

	var/save_data = TRUE

	var/saved_skin_tone
	var/saved_physique
	var/saved_eye_color_left
	var/saved_eye_color_right
	var/saved_hairstyle
	var/saved_hair_color
	var/saved_facial_hairstyle
	var/saved_facial_hair_color
	var/list/saved_dna_features = list()


/mob/living/basic/npc/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/footstep, FOOTSTEP_MOB_SHOE)
	AddElement(/datum/element/basic_eating)
	AddElement(/datum/element/ai_retaliate)
	if(randomize_mutant_colors)
		randomize_colors()
	if(make_random_name)
		name = generate_name()
	if(!outfit)
		pick_outfit()
	else if(islist(outfit))
		outfit = pick(outfit)
	gender = pick(MALE, FEMALE)
	INVOKE_ASYNC(src, PROC_REF(generate_dynamic_appearance))
	generate_desc_based_on_species()
	if(ranged)
		AddComponent(/datum/component/ranged_attacks,\
			casing_type = casingtype,\
			projectile_sound = projectilesound,\
			cooldown_time = ranged_cooldown,\
			burst_shots = burst_shots,\
		)
		if(ranged_cooldown <= 1 SECONDS)
			AddComponent(/datum/component/ranged_mob_full_auto)
	return INITIALIZE_HINT_LATELOAD

/mob/living/basic/npc/LateInitialize()
	if(mapping_anchor)
		for(var/turf/T in view(anchor_search_range, src))
			var/point = locate(mapping_anchor) in T
			if(!point)
				continue
			ai_controller?.set_blackboard_key(BB_NPC_PATROL_POINT, point)
			break


/mob/living/basic/npc/examine(mob/user)
	. = ..()
	if(item_r_hand)
		var/obj/item/I = item_r_hand
		. += span_notice("В правой руке [p_their()] [I::name].")
	if(item_l_hand)
		var/obj/item/I = item_l_hand
		. += span_notice("В левой руке [p_their()] [I::name].")


/mob/living/basic/npc/attack_ghost(mob/dead/observer/user)
	. = ..()
	if(!user.client || key || !ghost_controlable)
		return
	var/ask = tgui_alert(user, "Вы хотите сыграть за [name] - это будет требовать от вас соблюдения особых правил.", \
	"Сыграть за NPC?", list("Да", "Никогда"), 15 SECONDS)
	if(!ask || ask != "Да")
		return
	take_control(user)

/mob/living/basic/npc/take_control(mob/user)
	key = user.key

	to_chat(src, span_boldnotice(join_text))
	to_chat(src, span_big(span_red(important_text)))
	log_game("[key_name(src)] took control of [name].")
	message_admins("[key_name(src)] too control of npc [ADMIN_LOOKUPFLW(src)]")


/mob/living/basic/npc/death(gibbed)
	if(gibbed)
		return ..()
	INVOKE_ASYNC(src, PROC_REF(spawn_real_corpse_and_destroy))
	return ..()


/mob/living/basic/npc/proc/spawn_real_corpse_and_destroy()
	if(!save_data)
		qdel(src)
		return
	var/mob/living/carbon/human/corpse = new(loc)
	corpse.gender = gender
	corpse.set_species(species)
	corpse.physique = saved_physique
	corpse.skin_tone = saved_skin_tone
	corpse.eye_color_left = saved_eye_color_left
	corpse.eye_color_right = saved_eye_color_right
	corpse.dna.features = saved_dna_features.Copy()
	corpse.dna.species.regenerate_organs(corpse, corpse.dna.species, visual_only = TRUE)
	if(saved_hairstyle)
		corpse.set_hairstyle(saved_hairstyle, update = FALSE)
	if(saved_hair_color)
		corpse.set_haircolor(saved_hair_color, update = FALSE)
	if(saved_facial_hairstyle)
		corpse.set_facial_hairstyle(saved_facial_hairstyle, update = FALSE)
	if(saved_facial_hair_color)
		corpse.set_facial_haircolor(saved_facial_hair_color, update = FALSE)
	corpse.underwear = "Nude"
	corpse.undershirt = "Nude"
	corpse.socks = "Nude"
	corpse.update_body(TRUE)
	var/drop_right = prob(50)
	var/drop_left = prob(50)

	if(outfit)
		var/datum/outfit/corpse_outfit = new outfit()
		if(!drop_right && item_r_hand != NO_REPLACE)
			corpse_outfit.r_hand = item_r_hand
		if(!drop_left && item_l_hand != NO_REPLACE)
			corpse_outfit.l_hand = item_l_hand
		corpse.equipOutfit(corpse_outfit)

	if(drop_right && item_r_hand && item_r_hand != NO_REPLACE)
		new item_r_hand(loc)
	if(drop_left && item_l_hand && item_l_hand != NO_REPLACE)
		new item_l_hand(loc)
	var/obj/item/clothing/under/sensor_clothes = corpse.w_uniform
	if(istype(sensor_clothes))
		sensor_clothes.set_sensor_mode(SENSOR_OFF)
	corpse.fully_replace_character_name(null, name)
	corpse.death(TRUE)
	qdel(src)


/mob/living/basic/npc/proc/pick_outfit()
	outfit = pick(possible_outfits)


/mob/living/basic/npc/proc/generate_desc_based_on_species()
	switch(species)
		if(/datum/species/human)
			desc = "Обычный человек-гражданский. Ничем особенно не выделяется."
		if(/datum/species/vulpkanin)
			desc = "Меховой вульпканин с выразительными ушами и пушистым хвостом. Этот похожий на собаку гражданский настороженно осматривается."
		if(/datum/species/tajaran)
			desc = "Кошачий таяран с мягкой шерстью, выразительными ушами и покачивающимся хвостом. Острые глаза внимательно сканируют окружение."
		if(/datum/species/lizard)
			desc = "Чешуйчатый ящер с гордой осанкой и подёргивающимся хвостом. Твёрдая шкура и резкие черты говорят о выносливости."
		else
			var/datum/species/path = species
			desc = "Гражданский необычной расы. [path ? "([path::name])" : "Неизвестная раса."]"
	if(prob(30))
		desc += pick(" Кажется немного потерянным.", " Выглядит уставшим после долгой смены.", " Тихо напевает что-то себе под нос.", " Вокруг витает слабый запах [pick("кофе","машинного масла","рыбы","мокрой шерсти")].")


/mob/living/basic/npc/proc/randomize_colors()
	var/preset = rand(1, 7)
	switch(preset)
		if(1)
			mutant_color_1 = pick("#2F2F2F", "#3D3D3D", "#505050", "#6B6B6B", "#8C8C8C")
			mutant_color_2 = "#C8C8C8"
			mutant_color_3 = "#1A1A1A"
		if(2)
			mutant_color_1 = pick("#C9B8A0", "#B89F7E", "#A67C52", "#D2B48C", "#E0C9A0")
			mutant_color_2 = "#F4E4C9"
			mutant_color_3 = "#5C4633"
		if(3)
			mutant_color_1 = pick("#3F2A1E", "#523B2A", "#664B38", "#8B6647", "#A37F5E")
			mutant_color_2 = "#C9A37A"
			mutant_color_3 = "#2C2118"
		if(4)
			mutant_color_1 = pick("#9F3A1F", "#BF4F22", "#E07035", "#FF9F4F", "#D96F1F")
			mutant_color_2 = "#FFCC99"
			mutant_color_3 = "#5C2F1A"
		if(5)
			mutant_color_1 = pick("#48689E", "#334C7A", "#263B5E", "#6A8A9E", "#7E9EB0")
			mutant_color_2 = "#B0CDE8"
			mutant_color_3 = "#1F2F4A"
		if(6)
			mutant_color_1 = pick("#1E3F2B", "#2A5A3C", "#3A7A52", "#6E9B6E", "#8FBC8F")
			mutant_color_2 = "#A8D4B5"
			mutant_color_3 = "#13261F"
		if(7)
			mutant_color_1 = pick("#3A2A5C", "#4A3A78", "#5F4A96", "#7E6EB8", "#9B79C4")
			mutant_color_2 = "#D4B8F0"
			mutant_color_3 = "#2A1F3F"
	if(prob(40))
		mutant_color_1 = color_interpolate(mutant_color_1, "#FFFFFF", 0.12)
	else if(prob(30))
		mutant_color_1 = color_interpolate(mutant_color_1, "#000000", 0.08)

/mob/living/basic/npc/proc/generate_name()
	return generate_random_name_species_based(gender, TRUE, species)


/mob/living/basic/npc/proc/get_mutant_colors()
	return list(mutant_color_1, mutant_color_2, mutant_color_3)


/mob/living/basic/npc/proc/get_default_features()
	return list()


#define ARGS_FEATURES "mut_features"
#define ARGS_COLORS "mut_colors"
#define ARG_FEATURE "mut_feature"
#define ARG_FEATURE_NAME "mut_feat_name"


/mob/living/basic/npc/proc/generate_dynamic_appearance()
	var/skin_tone = pick(GLOB.skin_tones)
	var/eye_color = random_eye_color()
	var/hair_color = random_hair_color()
	var/list/features = list(ARGS_FEATURES = get_default_features(), ARGS_COLORS = get_mutant_colors())
	var/dynamic_appearance

	var/mob/living/carbon/human/dummy = new()
	dummy.set_species(species)
	dummy.stat = DEAD
	dummy.underwear = "Nude"
	dummy.undershirt = "Nude"
	dummy.socks = "Nude"
	dummy.set_combat_mode(combat_mode)
	dummy.set_eye_color(eye_color)
	if(species == /datum/species/human)
		dummy.physique = gender
		dummy.skin_tone = skin_tone
	if(add_hair)
		var/datum/sprite_accessory/hairstyle = SSaccessories.hairstyles_list[random_hairstyle(gender)]
		if(hairstyle && hairstyle.natural_spawn && !hairstyle.locked)
			dummy.set_hairstyle(hairstyle.name, update = FALSE)
		dummy.set_haircolor(hair_color, update = FALSE)
		dummy.updateappearance(TRUE, FALSE, FALSE)
	if(outfit)
		var/datum/outfit/dummy_outfit = new outfit()
		if(item_r_hand != NO_REPLACE)
			dummy_outfit.r_hand = item_r_hand
		if(item_l_hand != NO_REPLACE)
			dummy_outfit.l_hand = item_l_hand
		dummy.equipOutfit(dummy_outfit, visuals_only = TRUE)
	else if(mob_type)
		var/obj/effect/mob_spawn/spawner = new mob_type(null, TRUE)
		spawner.outfit_override = list()
		if(item_r_hand != NO_REPLACE)
			spawner.outfit_override["r_hand"] = item_r_hand
		if(item_l_hand != NO_REPLACE)
			spawner.outfit_override["l_hand"] = item_l_hand
		spawner.special(dummy, dummy)
		spawner.equip(dummy)
	for(var/obj/item/carried_item in dummy)
		if(dummy.is_holding(carried_item))
			var/datum/component/two_handed/twohanded = carried_item.GetComponent(/datum/component/two_handed)
			if(twohanded)
				twohanded.wield(dummy)
			var/datum/component/transforming/transforming = carried_item.GetComponent(/datum/component/transforming)
			if(transforming)
				transforming.set_active(carried_item)
	if(length(features[ARGS_FEATURES]))
		for(var/list/special in features[ARGS_FEATURES])
			dummy.dna.features[special[ARG_FEATURE]] = list(
				MUTANT_INDEX_NAME = special[ARG_FEATURE_NAME],
				MUTANT_INDEX_COLOR_LIST = features[ARGS_COLORS],
			)
	dummy.dna.features[FEATURE_MUTANT_COLOR] = features[ARGS_COLORS][1]
	dummy.dna.species.regenerate_organs(dummy, dummy.dna.species, visual_only = TRUE)
	dummy.update_body(TRUE)
	dummy.update_held_items()
	dynamic_appearance = dummy.appearance
	icon = 'icons/mob/human/human.dmi'
	icon_state = ""
	appearance_flags |= KEEP_TOGETHER
	copy_overlays(dynamic_appearance, cut_old = TRUE)

	if(save_data)
		saved_skin_tone = dummy.skin_tone
		saved_physique = dummy.physique
		saved_eye_color_left = dummy.eye_color_left
		saved_eye_color_right = dummy.eye_color_right
		saved_hairstyle = dummy.hairstyle
		saved_hair_color = hair_color
		saved_facial_hairstyle = dummy.facial_hairstyle
		saved_facial_hair_color = hair_color
		saved_dna_features = dummy.dna.features.Copy()
	qdel(dummy)


/mob/living/basic/npc/civilian
	name = "Гражданский"
	possible_outfits = list(
		/datum/outfit/trainstation_civilian,
		/datum/outfit/trainstation_civilian/style_1,
		/datum/outfit/trainstation_civilian/style_2,
		/datum/outfit/trainstation_civilian/style_3,
		/datum/outfit/trainstation_civilian/style_4,
	)


/mob/living/basic/npc/civilian/human
	species = /datum/species/human

/mob/living/basic/npc/civilian/vulpkanin
	species = /datum/species/vulpkanin
	randomize_mutant_colors = TRUE

/mob/living/basic/npc/civilian/tajaran
	species = /datum/species/tajaran
	randomize_mutant_colors = TRUE

/mob/living/basic/npc/civilian/lizard
	species = /datum/species/lizard
	randomize_mutant_colors = TRUE


#undef ARGS_FEATURES
#undef ARGS_COLORS
#undef ARG_FEATURE
#undef ARG_FEATURE_NAME


/obj/effect/landmark/police_patrol_point
	name = "Police patrol point"

/mob/living/basic/npc/police
	name = "Офицер полиции"
	health = 250
	maxHealth = 250
	faction = list(FACTION_CIVILIAN, FACTION_POLICE, FACTION_NEUTRAL)
	join_text = "Вы - полицейский. Соблюдайте порядок в вашей зоне и защищайте гражданских."
	important_text = "Не атакуйте игроков просто так а так же не покидайте свой город!"
	melee_damage_lower = 15
	melee_damage_upper = 30
	melee_damage_type = STAMINA

	ai_controller = /datum/ai_controller/basic_controller/npc_police
	mapping_anchor = /obj/effect/landmark/police_patrol_point

	possible_outfits = list(
		/datum/outfit/trainstation_civilian/police,
		/datum/outfit/trainstation_civilian/police/alt,
	)

	speech_chance = 15
	speech_phrases = list(
		"Проходите, не задерживайтесь!",
		"Здесь всё под контролем.",
		"Руки держите на виду.",
		"Подозрительное поведение будет доложено.",
		"Будьте осторожны.",
	)
	speech_emote_see = list(
		"поправляет берет.",
		"осматривает окрестности.",
		"кладёт руку на дубинку.",
	)
	speech_emote_hear = list(
		"бормочет что-то в рацию.",
		"прочищает горло.",
	)


/mob/living/basic/npc/police/generate_name()
	var/static/ranks = list(
		"Офицер",
		"Капрал",
		"Сержант",
		"Лейтенант",
	)
	var/base = ..()
	return "[pick(ranks)] [base]"


/mob/living/basic/npc/police/baton
	attack_sound = 'sound/items/weapons/egloves.ogg'
	item_r_hand = /obj/item/melee/baton/security
	melee_damage_lower = 40
	melee_damage_upper = 40
	melee_attack_cooldown = 3 SECONDS

/mob/living/basic/npc/police/baton/melee_attack(atom/target, list/modifiers, ignore_cooldown)
	. = ..()
	do_sparks(1, TRUE, src)


/mob/living/basic/npc/police/disabler
	attack_sound = 'sound/items/weapons/egloves.ogg'
	melee_damage_lower = 40
	melee_damage_upper = 40
	melee_attack_cooldown = 3 SECONDS
	ai_controller = /datum/ai_controller/basic_controller/npc_police/ranged

	ranged = TRUE
	item_r_hand = /obj/item/gun/energy/disabler
	projectilesound = 'sound/items/weapons/taser2.ogg'
	casingtype = /obj/projectile/beam/disabler
	burst_shots = 2


/obj/effect/landmark/military_patrol_point
	name = "Точка патрулирования военных"


/mob/living/basic/npc/police/military
	health = 300
	maxHealth = 300
	faction = list(FACTION_POLICE, FACTION_NEUTRAL)
	join_text = "Вы - военный. Вы должны поддерживать порядок в вашей зоне а так же защищать гражданских."
	melee_damage_lower = 15
	melee_damage_upper = 30
	melee_damage_type = BRUTE
	ai_controller = /datum/ai_controller/basic_controller/npc_police/ranged
	mapping_anchor = /obj/effect/landmark/military_patrol_point
	lighting_cutoff_red = 22
	lighting_cutoff_green = 5
	lighting_cutoff_blue = 5


	ranged = TRUE
	item_r_hand = /obj/item/gun/ballistic/automatic/m90
	projectilesound = 'sound/items/weapons/gun/smg/shot_alt.ogg'
	casingtype = /obj/item/ammo_casing/c38
	burst_shots = 3

	speech_chance = 15
	speech_phrases = list(
		"Проходи.",
		"Двигайся дальше.",
		"Тебе здесь не место.",
		"Очисти территорию.",
		"Руки на виду.",
		"Зона ограниченного доступа.",
		"Расходитесь, живо.",
		"Не твоё дело.",
		"Отойди.",
		"Вали отсюда.",
		"Территория закрыта.",
		"Иди дальше.",
		"Посторонись.",
		"Без лоитеринга.",
		"Шевелись, гражданский."
	)

	speech_emote_see = list(
		"осматривает окрестности.",
		"слегка поднимает оружие.",
		"делает шаг вперёд.",
		"держит руку на винтовке.",
		"прищуривается, глядя на тебя.",
		"резко машет рукой — двигайся.",
		"становится поперёк пути.",
		"поворачивает голову, проверяя тыл.",
		"держит руку возле кобуры.",
		"смотрит не мигая."
	)

	speech_emote_hear = list(
		"бормочет в рацию.",
		"говорит тихо в гарнитуру.",
		"издаёт невнятный рык.",
		"лает короткий код.",
		"шепчет координаты.",
		"тихо докладывает: «один гражданский»",
		"бормочет: «ещё один бродяга»",
		"цокает языком и включает рацию.",
		"тяжело дышит в микрофон.",
		"повторяет короткий приказ под нос."
	)

	possible_outfits = list(/datum/outfit/trainstation_military)


/mob/living/basic/npc/police/military/sniper
	item_r_hand = /obj/item/gun/ballistic/rifle/sniper_rifle
	projectilesound = 'sound/items/weapons/gun/sniper/shot.ogg'
	casingtype = /obj/item/ammo_casing/p50
	burst_shots = 1
	ranged_cooldown = 7 SECONDS


/mob/living/basic/npc/police/military/bad_guys
	name = "Мародёр"

	faction = list(FACTION_HOSTILE)
	make_random_name = FALSE
	join_text = "Вы - мародёр. Защищайте зону, где вы находитесь а так же атакуйте посторонних. Постарайтесь при этом оставить их в живых."
	important_text = "Не атакуйте поезд, а так же не приследуйте игроков! Не выводите игроков из раунда целиком!"
	possible_outfits = list(
		/datum/outfit/trainstation_raider,
		/datum/outfit/trainstation_raider/alt,
		/datum/outfit/trainstation_raider/alt_2,
	)

	// item_r_hand = /obj/item/gun/ballistic/automatic/as32
	projectilesound = 'sound/items/weapons/gun/smg/shot_alt.ogg'
	casingtype = /obj/item/ammo_casing/c35sol
	ranged_cooldown = 3 SECONDS
	burst_shots = 3

/mob/living/basic/npc/police/military/bad_guys/meele

	melee_damage_lower = 30
	melee_damage_upper = 30
	ranged = FALSE
	item_r_hand = /obj/item/knife/combat
	item_l_hand = /obj/item/shield/riot
