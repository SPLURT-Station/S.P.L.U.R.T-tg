/obj/item/reagent_containers/cup/glass/bottle/
	var/bottle_game_cd = 0 // кулдаун для верба

// Применяет входящий трансформ через время и воспроизводит звук дропа
/obj/item/reagent_containers/cup/glass/bottle/proc/bottle_game_stay(matrix/O)
	sleep(15)
	transform = O	// возвращаем оригинальный
	playsound(src, drop_sound, DROP_SOUND_VOLUME, ignore_walls = FALSE)	// воспроизвоим звук дропа айтема
	visible_message("<span class='notice'>[usr] подхватывает бутылочку и ставит на место</span>")

// Игра в бутылочку
/obj/item/reagent_containers/cup/glass/bottle/verb/verb_spin()
	set src in view(1)
	set category = "Object"
	set name = "Игра - Бутылочка"

	// проверяем кулдаун
	if(bottle_game_cd > world.time)
		return

	// проверям может ли юзер использовать верб
	if(usr.incapacitated || !Adjacent(usr) || isobserver(usr) || isdead(usr)) //  || usr.lying
		return

	bottle_game_cd = world.time + 30	// задаем кулдаун 30 = 3 секунды
	var/matrix/O = transform	// запоминаем трансформ бутылки
	var/matrix/M = matrix(transform)	// создаем свой трансформ

	// Если реагент не полный и не пустой, не даем вращать. Ф - Физика.
	var/datum/reagents/r = src.reagents	// получаем реагенты
	if(r.total_volume < r.maximum_volume && r.total_volume > 0)
		M.Turn(rand(-160,160))	// роняем на случайный угол
		transform = M	// применяем наш трансформ
		visible_message("<span class='notice'>[usr] закручивает бутылочку, но жидкость внутри не дает ей вращаться.</span>")
		bottle_game_stay(O)	// вызываем восстановление трансформа
		return

	var/list/names = list()	// лист участников
	names += "пустоту"	// бутылочка может указать и мимо всех
	for(var/mob/living/m in oview(1,src))	// заполняем лист участниками
		if(ishuman(m) || issilicon(m))	// теперь и с боргами
			names += m.name
	visible_message("<span class='notice'><b>[usr]</b> тянется к бутылочке и закручивает ее...</span>")
	src.SpinAnimation(2,9)	// проигрываем анимацию вращения
	M.Turn(rand(-160,160))	// роняем на случайный угол
	transform = M	// применяем наш трансформ
	playsound(src, 'modularz_arkstation/modules/bottle_game/rollingbottle.ogg', 30, TRUE, ignore_walls = FALSE)	// воспроизводим звук вращения
	sleep(15)
	visible_message("<span class='notice'>Бутылочка указывает на <b>[pick(names)]</b>.</span>")
	bottle_game_stay(O)	// вызываем восстановление трансформа
