/// Our New Objective:

/datum/objective/gimmick
	name = "Dastardly Act"
	explanation_text = "Be dastardly as hell!"

/datum/objective/gimmick/New()
	if(isnull(gimmick_list))
		gimmick_list = list(
			"Обвиняйте невинных членов экипажа в различных преступлениях, которых они не совершали.",
			"Добейтесь ареста, а затем устройте массовый побег из тюрьмы.",
			"Спасите всех, кого поймала и арестовала служба безопасности.",
			"Заблокируйте проходы в коридорах на станции.",
			"Ведите личную войну с Ассистентами, заставляя их устроиться на настоящую работу.",
			"Устраивайте все более опасные розыгрыши на станции.",
			"Совершайте как можно больше мелких и/или средних преступлений.",
			"Затевайте как можно больше драк на станции. Чем больше драк, тем лучше.",
			"Начните конкурирующий теневой бизнес, который сделает выбранный отдел ненужным.",
			"Найдите на станции всех Антагонистов, не связанных с Службой Безопасностью, и не позволяйте им охотиться на других.",
			"Попытайтесь стать суперзлодеем, используя костюмы, предательство, много хвастовства и бравады.",
			"Похитите питомца или члена экипажа и держите их с целью получения выкупа.",
			"Преобразуйте безопасную зону, например, мостик, в нечто более \"развлекательное\" для экипажа.",
			"Сделать как можно большую часть станции доступной для широкой публики.",
			"Создать рабочий профсоюз и призвать своих коллег прекратить работу и объявить забастовку.",
			"Украсть вещи у членов экипажа и попытаться продать их с аукциона ради прибыли.",
			"Украсть ценные предметы со станции и попытаться продать их обратно экипажу.",
			"Попытаться монетизировать основные услуги, предоставляемые станцией.",
			"Начать успешный переворот и сместить капитана или выбранного начальника станции.",
			"Совершить грандиозное ограбление хранилища.",
			"Захватить часть станции, затем медленно и постепенно расширяться в другие области.",
			"Нанести как можно больше мелких травм членам экипажа."
		)

	explanation_text = pick(gimmick_list)

/datum/objective/gimmick/check_completion()
	return TRUE

/// Translate Other Objectives Below:

// Assassinate
/datum/objective/assassinate/update_explanation_text()
	..()
	if(target?.current)
		explanation_text = "Убейте [target.name], в должности [!target_role_type ? target.assigned_role.title : target.special_role] ОДИН РАЗ." //NOVA EDIT CHANGE
	else
		explanation_text = "Свободное задание."

// Mutiny
/datum/objective/mutiny/update_explanation_text()
	..()
	if(target?.current)
		explanation_text = "Убейте или изгоните [target.name], в должности [!target_role_type ? target.assigned_role.title : target.special_role]."
	else
		explanation_text = "Свободное задание."

// Maroon
/datum/objective/maroon/update_explanation_text()
	if(target?.current)
		explanation_text = "Не дайте [target.name], в должности [!target_role_type ? target.assigned_role.title : target.special_role] уйти со станции живым."
	else
		explanation_text = "Свободное задание."

// Debrain
/datum/objective/debrain/update_explanation_text()
	..()
	if(target?.current)
		explanation_text = "Украдите мозг [target.name], в должности [!target_role_type ? target.assigned_role.title : target.special_role]."
	else
		explanation_text = "Свободное задание."

// Protect
/datum/objective/protect/update_explanation_text()
	..()
	if(target?.current)
		explanation_text = "Защищайте [target.name], в должности [!target_role_type ? target.assigned_role.title : target.special_role]."
	else
		explanation_text = "Свободное задание."

// Jailbreak
/datum/objective/jailbreak/update_explanation_text()
	..()
	if(target?.current)
		explanation_text = "Убедитесь что [target.name], в должности [!target_role_type ? target.assigned_role.title : target.special_role] покинет станцию живым и свободным."
	else
		explanation_text = "Свободное задание."

// Jailbreak - Detain
/datum/objective/jailbreak/detain/update_explanation_text()
	..()
	if(target?.current)
		explanation_text = "Убедитесь что [target.name], в должности [!target_role_type ? target.assigned_role.title : target.special_role] будет доставлен на аванпост ЦА живым и под стражей."
	else
		explanation_text = "Свободное задание."

// Hijack
/datum/objective/hijack
	name = "hijack"
	explanation_text = "Захватить эвакуационный шаттл, взломав его навигационные протоколы через консоль управления (ALT+ЛКМ пон консоли аварийного шаттла)."
	team_explanation_text = "Захватить эвакуационный шаттл, взломав его навигационные протоколы через консоль управления (ALT+ЛКМ пон консоли аварийного шаттла). Не оставьте ни одного члена вашей команды позади."

// Elimination
/datum/objective/elimination
	name = "elimination"
	explanation_text = "Вырежьте весь лоялистский экипаж на борту шаттла. Вы и любые единомышленники должны быть единственными оставшимися людьми на шаттле."
	team_explanation_text = "Вырежьте весь лоялистский экипаж на борту шаттла. Вы и любые единомышленники должны быть единственными оставшимися людьми на шаттле. Не оставьте ни одного члена вашей команды позади."

// Highlander
/datum/objective/elimination/highlander
	name="highlander elimination"
	explanation_text = "Сбегите на шаттле в одиночку. Убедитесь, что больше никто не выберется."

// Block
/datum/objective/block
	name = "no organics on shuttle"
	explanation_text = "Не позволяйте ни одной разумной органической форме жизни проникнуть на шаттл живыми."

// Purge
/datum/objective/purge
	name = "no mutants on shuttle"
	explanation_text = "Убедитесь, что на борту эвакуационного шаттла нет представителей разумных гуманоидных видов, не являющихся людьми."

// Robot Army
/datum/objective/robot_army
	name = "robot army"
	explanation_text = "Синхронизируйте с собой не менее восьми активных киборгов."

// Escape
/datum/objective/escape
	name = "escape"
	explanation_text = "Сбегите на шаттле или спасательной капсуле живым и не будучи арестованным."
	team_explanation_text = "Помогите всем членам вашей команды сбежать на шаттле или капсуле живыми, не находясь под стражей."

// Escape - Changeling
/datum/objective/escape/escape_with_identity/update_explanation_text()
	if(target?.current)
		target_real_name = target.current.real_name
		explanation_text = "Сбегите на шаттле эвакуации или в спасательной капсуле, под личиной [target_real_name], в должности [target.assigned_role.title]"
		var/mob/living/carbon/human/H
		if(ishuman(target.current))
			H = target.current
		if(H && H.get_id_name() != target_real_name)
			target_missing_id = 1
		else
			explanation_text += ", имея при себе айди карту жертвы"
		explanation_text += "."

	else
		explanation_text = "Сбегите на шаттле или в спасательной капсуле живым и не подвергаясь аресту."

// Survive
/datum/objective/survive
	name = "survive"
	explanation_text = "Оставайся в живых до конца."

// Malf
/datum/objective/survive/malf
	name = "survive AI"
	explanation_text = "Не допустите собственную деактивацию."

// Exile
/datum/objective/exile
	name = "exile"
	explanation_text = "Оставайтесь в живых за пределами станции. Не летите на аванпост ЦК."

// Martyr
/datum/objective/martyr
	name = "martyr"
	explanation_text = "Умри грандиозной смертью!"

// Nuke
/datum/objective/nuclear
	name = "nuclear"
	explanation_text = "Уничтожьте станцию ​​ядерным взрывом."

// Steal
/datum/objective/steal/set_target(datum/objective_item/item)
	if(item)
		targetinfo = item
		steal_target = targetinfo.targetitem
		explanation_text = "Укради [targetinfo.name]"
		give_special_equipment(targetinfo.special_equipment)
		return steal_target
	else
		explanation_text = "Свободное задание."
		return

/datum/objective/steal/admin_edit(mob/admin)
	var/list/possible_items_all = GLOB.possible_items
	var/new_target = input(admin,"Select target:", "Objective target", steal_target) as null|anything in sort_names(possible_items_all)+"custom"
	if (!new_target)
		return

	if (new_target == "custom")
		var/custom_path = input(admin,"Search for target item type:","Type") as null|text
		if (!custom_path)
			return
		var/obj/item/custom_target = pick_closest_path(custom_path, make_types_fancy(subtypesof(/obj/item)))
		var/custom_name = initial(custom_target.name)
		custom_name = stripped_input(admin,"Enter target name:", "Objective target", custom_name)
		if (!custom_name)
			return
		steal_target = custom_target
		explanation_text = "Укради [custom_name]."

	else
		set_target(new_target)

// Capture
/datum/objective/capture/update_explanation_text()
	. = ..()
	explanation_text = "Захватите [target_amount] форм жизни с помощью энергетической сети. Живые редкие экземпляры стоят дороже."

// Protect
/datum/objective/protect_object/update_explanation_text()
	. = ..()
	if(protect_target)
		explanation_text = "Защитите \the [protect_target] любой ценой."
	else
		explanation_text = "Свободное задание."

// Absorb - Changeling
/datum/objective/absorb/update_explanation_text()
	. = ..()
	explanation_text = "Извлечь [target_amount] совместимых геномов\s."

/datum/objective/absorb_most
	name = "absorb most"
	explanation_text = "Извлечь больше совместимых геномов, чем любой другой Генокрад."

/datum/objective/absorb_changeling
	name = "absorb changeling"
	explanation_text = "Поглотите другого Генокрада."

// Destroy AI
/datum/objective/destroy/update_explanation_text()
	..()
	if(target?.current)
		explanation_text = "Уничтожьте [target.name], эксперементальный ИИ."
	else
		explanation_text = "Свободное задание."

/// Steal Five
/datum/objective/steal_n_of_type
	name = "steal five of"
	explanation_text = "Украдите некоторые предметы!"

// Guns
/datum/objective/steal_n_of_type/summon_guns
	name = "steal guns"
	explanation_text = "Украдите не менее пяти единиц оружия!"

// Magic
/datum/objective/steal_n_of_type/summon_magic
	name = "steal magic"
	explanation_text = "Украдите не менее пяти магических артефактов.!"

// Organs
/datum/objective/steal_n_of_type/organs
	name = "steal organs"
	explanation_text = "Украдите не менее 5 органических органов! Они должны быть здоровыми."

/// Blood Cult
// Sacrifice
/datum/objective/sacrifice/update_explanation_text()
	if(target)
		explanation_text = "Пожертвуйте [target], в должности [target.assigned_role.title] посредством вызова руны предложения с [target.p_them()] в центре и тремя Аколитами вокруг."
	else
		explanation_text = "Завеса здесь уже ослаблена, переходим к финальной цели."

/datum/objective/minor_sacrifice/update_explanation_text()
	. = ..()
	explanation_text = "Пожертвуйте по меньшей мере [target_amount] членов экипажа."

/datum/objective/major_sacrifice
	name = "major sacrifice"
	explanation_text = "Пожертвуйте 1 станционного главу."

// Nar'Sie
/datum/objective/eldergod/update_explanation_text()
	explanation_text = "Призовите Нар'Си, вызвав руну «Призыв Нар'Си». Призыв может быть выполнен только в [english_list(summon_spots)] - где завеса достаточно слаба для начала ритуала."

/// Heretic
// Research
/datum/objective/heretic_research/update_explanation_text()
	. = ..()
	explanation_text = "Познайте минимум [target_amount] знаний из Мансуса. Вы стартуете с [length(GLOB.heretic_start_knowledge)] познаными."

// Summon
/datum/objective/heretic_summon
	name = "summon monsters"
	explanation_text = "Призовите 2 отродья Мансуса в текущую реальность."

// Lunatic
/datum/objective/lunatic
	explanation_text = "Помогите своему главарю. Если вы видите это, прокрутите чат вверх, чтобы узнать, кто это, и сообщите об этом"

/datum/objective/lunatic/update_explanation_text()
	. = ..()
	if(is_master)
		explanation_text = "Ведите своих лунатиков к достижению собственных целей.!"
		return
	explanation_text = "Помогайте своему главарю [master], не причиняйте вреда другим лунатикам."

/datum/objective/heretic_trapped
	name = "soultrapped failure"
	explanation_text = "Помоги культу. Убей культ. Помоги команде. Убей команду. Помоги своему владельцу. Убей своего владельца. Убей всех. Грохочи своими цепями."

/// Nightmare
/datum/objective/nightmare_fluff/New()
	..()
	var/list/explanation_texts = list(
		"Поглоти последний проблеск света с этой космической станции",
		"Принеси суд дневным отродьям",
		"Погаси пламя этого адского места",
		"Раскрой истинную природу теней",
		"От теней все погибнет",
		"Призови ночь клинком или пламенем",
		"Принеси тьму на свет"
	)
	explanation_text = pick(explanation_texts)

/// Overwatch
/datum/objective/overwatch
	explanation_text = "Обеспечьте разведывательную поддержку и наблюдение за вашей оперативной группой!"

/// Obsessed
// Murder
/datum/objective/assassinate/obsessed/update_explanation_text()
	..()
	if(target?.current)
		explanation_text = "Убей [target.name], в должности [!target_role_type ? target.assigned_role.title : target.special_role]."
	else
		message_admins("WARNING! [ADMIN_LOOKUPFLW(owner)] obsessed objectives forged without an obsession!")
		explanation_text = "Свободное задание"

/datum/objective/assassinate/jealous/update_explanation_text()
	..()
	old = find_coworker(target)
	if(target?.current && old)
		explanation_text = "Убей [target.name], коллега [old]."
	else
		explanation_text = "Свободное задание"

// Spend Time
/datum/objective/spendtime/update_explanation_text()
	if(timer == initial(timer))//just so admins can mess with it
		timer += pick(-600, 0)
	var/datum/antagonist/obsessed/creeper = owner.has_antag_datum(/datum/antagonist/obsessed)
	if(target?.current && creeper)
		creeper.trauma.attachedobsessedobj = src
		explanation_text = "Проведи [DisplayTimeText(timer)] вокруг [target.name], пока он жив."
	else
		explanation_text = "Свободное задание"

/datum/objective/spendtime/check_completion()
	return timer <= 0 || explanation_text == "Свободное задание"

// Hugs
/datum/objective/hug/update_explanation_text()
	..()
	if(!hugs_needed)//just so admins can mess with it
		hugs_needed = rand(4,6)
	var/datum/antagonist/obsessed/creeper = owner.has_antag_datum(/datum/antagonist/obsessed)
	if(target?.current && creeper)
		explanation_text = "Обними [target.name] [hugs_needed] раз, пока он жив."
	else
		explanation_text = "Свободное задание"

// Photo
/datum/objective/polaroid/update_explanation_text()
	..()
	if(target?.current)
		explanation_text = "Сфотографируй [target.name], пока он жив, и держи фотографию при себе."
	else
		explanation_text = "Свободное задание"

// Heirloom Thief
/datum/objective/steal/heirloom_thief/update_explanation_text()
	..()
	if(steal_target)
		explanation_text = "Укради семейную ценность [target.name] - [steal_target]."
	else
		explanation_text = "Свободное задание"

/// Loot
/datum/objective/loot
	explanation_text = "Собирайте ценную добычу и храните ее в отведенном месте."

/datum/objective/loot/update_explanation_text()
	if(cargo_hold)
		var/area/storage_area = get_area(cargo_hold)
		explanation_text = "Соберите добычу и поместите [target_value] кредитов в грузовой отсек [storage_area.name]."

/// Pyro Slime
/datum/objective/pyro_slime
	explanation_text = "Все, что я знаю, это огонь. Я говорю на языках пламени. Почему все такие холодные?"

/// Nations
/datum/objective/destroy_nation
	name = "nation destruction"
	explanation_text = "Сделайте так, чтобы ни один представитель вражеской нации не ушел живым!"
	team_explanation_text = "Сделайте так, чтобы ни один представитель вражеской нации не ушел живым!"

/datum/objective/destroy_nation/update_explanation_text()
	. = ..()
	if(target_team)
		explanation_text = "Сделай так, чтобы ни один представитель [target_team] ([target_team.department.department_name]) не ушел живым!"
	else
		explanation_text = "Свободное задание"

/datum/objective/separatist_fluff/New(text, nation_name)
	..()
	explanation_text = pick(list(
		"Остальная часть станции должна быть обложена налогом за использование услуг [nation_name].",
		"Создайте повсюду статуи вашего славного лидера [nation_name]. Если у вас никого нет, коронуйте одного из вас!",
		"[nation_name] должен быть абсолютно шикарным.",
		"Повредите как можно больше станции, поддерживайте ее в запустении. [nation_name] должен быть нетронутым образцом!",
		"Мощно укрепите [nation_name] против опасностей внешнего мира.",
		"Убедитесь, что [nation_name] полностью отключен от сети, не требуя электроэнергии или каких-либо других услуг от других департаментов!",
		"Используйте неправильно настроенный телепорт, чтобы вы и ваши сограждане [nation_name] стали летающими людьми. Принесите лекарство от токсинов!",
		"Спасите станцию, когда она больше всего в вас нуждается. [nation_name] будут помнить как защитников.",
		"Вооружайтесь. Граждане [nation_name] имеют право нести оружие.",
	))

/datum/objective/united_nations
	explanation_text = "Поддерживайте мир на станции. Убедитесь, что к концу раунда у каждой страны есть живой делегат."
	team_explanation_text = "Поддерживайте мир на станции. Убедитесь, что к концу раунда у каждой страны есть живой делегат."

/// Space Carp
/datum/objective/space_carp
	explanation_text = "Защищайте разлом, чтобы привлечь больше карпов."

/// Ninja
// Cyborg Hijack
/datum/objective/cyborg_hijack
	explanation_text = "Используйте перчатки, чтобы превратить хотя бы одного киборга в помощника по саботажу станции."

// Sec Statuses
/datum/objective/security_scramble
	explanation_text = "Используйте перчатки на мониторе заметок Службы Безопасности, чтобы арестовать всех хотя бы один раз. Обратите внимание, что ИИ будет предупрежден, как только вы начнете!"

// Terror Message - New Danger
/datum/objective/terror_message
	explanation_text = "Используйте перчатки на Консоли Связи, чтобы привлечь на станцию еще одну угрозу. Обратите внимание, что ИИ будет предупрежден, как только вы начнете!"

// R&D
/datum/objective/research_secrets
	explanation_text = "Используйте перчатки на сервере РНД, чтобы саботировать исследовательские работы. Обратите внимание, что ИИ будет предупрежден, как только вы начнете!"

/datum/antagonist/ninja/addObjectives()
	//Cyborg Hijack: Flag set to complete in the DrainAct in ninjaDrainAct.dm
	var/datum/objective/hijack = new /datum/objective/cyborg_hijack()
	objectives += hijack

	// Break into science and mess up their research. Only add this objective if the similar steal objective is possible.
	var/datum/objective/research_secrets/sabotage_research = new /datum/objective/research_secrets()
	objectives += sabotage_research

	//Door jacks, flag will be set to complete on when the last door is hijacked
	var/datum/objective/door_jack/doorobjective = new /datum/objective/door_jack()
	doorobjective.doors_required = rand(15,40)
	doorobjective.explanation_text = "Используйте свои перчатки чтобы взломать [doorobjective.doors_required] шлюзов на станции."
	objectives += doorobjective
	if(length(get_crewmember_minds()) >= BOMB_POP_REQUIREMENT)
		//Explosive plant, the bomb will register its completion on priming
		var/datum/objective/plant_explosive/bombobjective = new /datum/objective/plant_explosive()
		for(var/sanity in 1 to 100) // 100 checks at most.
			var/area/selected_area = pick(GLOB.areas)
			if(!is_station_level(selected_area.z) || !(selected_area.area_flags & VALID_TERRITORY))
				continue
			bombobjective.detonation_location = selected_area
			break
		if(bombobjective.detonation_location)
			bombobjective.explanation_text = "Взорвите свою бомбу в [bombobjective.detonation_location].  Обратите внимание, что бомба не сработает нигде больше!"
			objectives += bombobjective

/// Spiders
/datum/objective/spider
	explanation_text = "Распространить улей."

/datum/objective/spider/New(directive)
	..()
	if(directive)
		explanation_text = "Ваша королева дала вам цель! Следуйте ей любой ценой: [directive]"

/datum/antagonist/spider/flesh/forge_objectives()
	var/datum/objective/custom/destroy = new()
	destroy.owner = owner
	destroy.explanation_text = "Сейте хаос и пожирайте живую плоть."
	objectives += destroy

	var/datum/objective/survive/dont_die = new()
	dont_die.owner = owner
	objectives += dont_die

/// Blood Brothers
/datum/objective/convert_brother
	name = "convert brother"
	explanation_text = "Переманите на свою сторону человека, поддающегося промыванию мозгов, используя ваш Флешер на нём. Любой подручный Флешер будет работать, если вы потеряете или сломаете свой стартовый Флешер."
