#define MAPTEXT_PIXELLARI_SIZED(text, size) {"<span style='font-family: \"Pix Cyrillic\"; font-size: [##size]pt; -dm-text-outline: 1px black'>[##text]</span>"}

/atom/movable/screen/boss_base
	icon = 'fenysha_events/icons/hud/bossbar.dmi'
	icon_state = "base"
	layer = SCREENTIP_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	maptext_height = 46
	maptext_width = 200
	maptext_x = 30
	maptext_y = 45
	maptext = ""

/atom/movable/screen/boss_fill
	icon = 'fenysha_events/icons/hud/bossbar.dmi'
	layer = SCREENTIP_LAYER + 0.05
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/boss_portrait
	layer = SCREENTIP_LAYER + 0.1
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/datum/component/bossbar
	/// Иконка и состояние для портрета
	var/icon/boss_portrait_icon = 'fenysha_events/icons/hud/boss_icons.dmi'
	var/boss_portrait_state
	/// Имя босса (можно оверрайдить)
	var/override_name
	/// Здоровье
	var/max_health
	var/current_health
	/// Кому сейчас показан бар
	var/list/client_to_screens = list()
	/// Радиус видимости
	var/view_range = 30

	var/text_size = 12
	var/bar_screen_loc = "EAST-5.5, SOUTH+3"
	var/portrait_screen_loc = "EAST-5.5:1, SOUTH+3:16"

/datum/component/bossbar/Initialize(icon/port_icon = 'fenysha_events/icons/hud/boss_icons.dmi', port_state, name_override, range = 30)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/boss = parent

	boss_portrait_icon = port_icon || boss.icon
	boss_portrait_state = port_state || boss.icon_state
	override_name = name_override || boss.name
	max_health = boss.maxHealth || 100
	current_health = boss.health
	view_range = range

	START_PROCESSING(SSdcs, src)


/datum/component/bossbar/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(on_damage))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/component/bossbar/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_MOB_APPLY_DAMAGE, COMSIG_LIVING_DEATH))

/datum/component/bossbar/Destroy(force)
	hide_all()
	STOP_PROCESSING(SSdcs, src)
	return ..()

/datum/component/bossbar/process(seconds_per_tick)
	var/mob/living/boss = parent
	if(QDELETED(boss) || boss.stat == DEAD || boss.health <= 0)
		hide_all()
		return

	current_health = boss.health
	update_all()

	var/list/should_see = list()
	for(var/mob/living/player in GLOB.player_list)
		if(!player.client || player.stat == DEAD || player.z != boss.z)
			continue
		if(get_dist(boss, player) <= view_range)
			should_see += player.client

	for(var/mob/dead/observer/ghost in GLOB.current_observers_list)
		if(ghost.z != boss.z)
			continue
		if(get_dir(boss, ghost) <= view_range)
			should_see += ghost

	for(var/client/C in should_see)
		if(!(C in client_to_screens))
			show_to(C)

	for(var/client/C in client_to_screens)
		if(!(C in should_see))
			hide_from(C)

/datum/component/bossbar/proc/on_damage()
	SIGNAL_HANDLER
	update_health()

/datum/component/bossbar/proc/on_death()
	SIGNAL_HANDLER
	hide_all()

/datum/component/bossbar/proc/update_health()
	var/mob/living/boss = parent
	current_health = boss.health
	if(current_health <= 0)
		hide_all()
	else
		update_all()

/datum/component/bossbar/proc/show_to(client/C)
	if(!C || (C in client_to_screens))
		return

	var/atom/movable/screen/base = new /atom/movable/screen/boss_base()
	base.screen_loc = bar_screen_loc
	base.maptext = get_maptext()

	var/atom/movable/screen/fill = new /atom/movable/screen/boss_fill()
	fill.screen_loc = base.screen_loc
	fill.icon_state = get_bar_state()

	var/atom/movable/screen/portrait = new /atom/movable/screen/boss_portrait()
	portrait.icon = boss_portrait_icon
	portrait.icon_state = boss_portrait_state
	portrait.screen_loc = portrait_screen_loc

	var/list/screens = list(base, fill, portrait)
	C.screen += screens
	client_to_screens[C] = screens

/datum/component/bossbar/proc/hide_from(client/C)
	var/list/screens = client_to_screens[C]
	if(!screens)
		return
	C.screen -= screens
	qdel(screens[1])
	qdel(screens[2])
	qdel(screens[3])
	client_to_screens -= C

/datum/component/bossbar/proc/hide_all()
	for(var/client/C in client_to_screens)
		hide_from(C)

/datum/component/bossbar/proc/update_all()
	if(!length(client_to_screens))
		return

	var/new_bar_state = get_bar_state()
	var/new_maptext = get_maptext()

	for(var/client/C in client_to_screens)
		var/list/screens = client_to_screens[C]
		var/atom/movable/screen/base = screens[1]
		var/atom/movable/screen/fill = screens[2]

		fill.icon_state = new_bar_state
		base.maptext = new_maptext


/datum/component/bossbar/proc/get_bar_state()
	if(current_health <= 0)
		return "bar_5"
	var/percent = max(5, round((current_health / max_health) * 100 / 5) * 5)
	return "bar_[percent]"

/datum/component/bossbar/proc/get_maptext()
	var/percent = round((current_health / max_health) * 100)
	return MAPTEXT_PIXELLARI_SIZED("<font color='#aa6000'>[override_name]</font><br><font color='#e28a26'>[percent]% ([round(current_health)]/[max_health])</font>", text_size)

#undef MAPTEXT_PIXELLARI_SIZED
