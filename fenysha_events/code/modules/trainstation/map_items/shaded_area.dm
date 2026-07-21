/datum/component/shaded_area_tracker
	var/mob/living/host
	var/static/list/whitelisted_light_sources = list(
		/obj/item/flashlight/flare,
		/obj/item/flashlight/flare/candle,
		/obj/item/flashlight/glowstick,
	)

	var/static/list/bad_eyes = list(
		/obj/item/organ/eyes/night_vision,
		/obj/item/organ/eyes/robotic/glow,
		/obj/item/organ/eyes/robotic/flashlight,
		/obj/item/organ/eyes/robotic/thermals,
		/obj/item/organ/eyes/robotic/xray,
	)

/datum/component/shaded_area_tracker/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	host = parent

	START_PROCESSING(SSprocessing, src)

/datum/component/shaded_area_tracker/Destroy(force)
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/datum/component/shaded_area_tracker/process(seconds_per_tick)
	if(QDELETED(host))
		return
	if(host.stat == DEAD)
		return
	if(!istype(get_area(host), /area/trainstation/indoors/shaded_area))
		qdel(src)
		return

	if(iscarbon(host))
		shade_carbon(host)
		return

	if(issilicon(host))
		shade_silicon(host)
		return

/datum/component/shaded_area_tracker/proc/shade_silicon(mob/living/silicon/victim)
	if(!istype(victim, /mob/living/silicon/robot))
		return
	var/mob/living/silicon/robot/robot = victim
	robot.adjust_fire_loss(5)
	if(robot.cell)
		robot.cell.use(50 KILO WATTS)
	to_chat(robot, span_userdanger("Your cell burning up as unknown force blast your body! Leave this place!"))

/datum/component/shaded_area_tracker/proc/shade_carbon(mob/living/carbon/victim)
	for(var/obj/item/I in victim.contents)
		if(istype(I, /obj/item/flashlight))
			var/allowed = FALSE
			for(var/type in whitelisted_light_sources)
				if(istype(I, type))
					allowed = TRUE
			if(!allowed)
				to_chat(victim, span_warning("You [I] dust away sadenly..."))
				qdel(I)
			continue
		else if(I.light_on)
			I.set_light_on(FALSE)
	if(victim.glasses)
		var/obj/item/clothing/glasses/glasses = victim.glasses
		if(glasses.vision_flags || glasses.lighting_cutoff || glasses.color_cutoffs)
			to_chat(victim, span_userdanger("Your [glasses] blinds you and then dust away!"))
			victim.flash_act(2, override_blindness_check = TRUE)
			qdel(glasses)

	var/obj/item/organ/eyes/eyes = victim.get_organ_slot(ORGAN_SLOT_EYES)
	if(eyes)
		var/bad = FALSE
		for(var/type in bad_eyes)
			if(istype(eyes, type))
				bad = TRUE
		if(bad)
			eyes.apply_organ_damage(2)
			to_chat(victim, span_userdanger("Your eyes burn!"))
			victim.emote_scream()


/area/trainstation/indoors/shaded_area
	name = "???"

/area/trainstation/indoors/shaded_area/Entered(atom/movable/arrived, area/old_area)
	. = ..()
	if(isliving(arrived))
		arrived.AddComponent(/datum/component/shaded_area_tracker)

/area/trainstation/indoors/shaded_area/power
	requires_power = FALSE
	always_unpowered = FALSE
	power_environ = TRUE
	power_equip = TRUE
	power_light = TRUE
