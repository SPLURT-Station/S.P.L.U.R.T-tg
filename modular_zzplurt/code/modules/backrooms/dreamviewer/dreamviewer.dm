/obj/item/clothing/head/dreamviewer
	name = "Somnium Dreamviewer"
	desc = "A specialized neuro-interface designed to establish a controlled connection between a sleeping subject and the Dream Gate network. \
			The device allows the wearer to enter a stable, artificially maintained dream state while remaining connected to external monitoring equipment. \
			While active, the DreamViewer cannot be removed by conventional means and the wearer cannot be awakened through normal methods."

	icon = 'icons/obj/dreamviewer.dmi'
	icon_state = "dreamvewer"
	worn_icon = 'icons/obj/dreamviewer.dmi'
	worn_icon_state = "dreamviewer_onmob"
	clothing_flags = ANTI_TINFOIL_MANEUVER
	strip_delay = 3 SECONDS
	equip_delay_other = 60 SECONDS

	// Our  current user(reqruires wearer to fell asleep and be connected to the dream gate network)
	var/mob/living/carbon/human/user = null
	// How long the user has been asleep in dreamviewer
	var/sleep_time = 0
	// Last time  soneone scambled the dream crystals from user
	var/last_scramble_time = 0
	var/default_scramble_cooldown = 10 MINUTES
	// How long the user has been asleep in dreamviewer before the dream crystals are scrambled
	var/sleep_time_before_scramble = 10 MINUTES

	var/dreamgate_opened = FALSE

/obj/item/clothing/head/dreamviewer/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_COPY_IN_BACKROOMS, INNATE_TRAIT)

/obj/item/clothing/head/dreamviewer/examine(mob/user)
	. = ..()
	. += span_warning("<b>WARNING</b>: Do not attempt to remove the DreamViewer while the device is active. \
						Unauthorized interruption of the connection may result in severe neurological complications and permanent death.")

/obj/item/clothing/head/dreamviewer/equipped(mob/user, slot, initial = FALSE)
	. = ..()

	if(!(slot & ITEM_SLOT_HEAD) || !ishuman(user))
		return

	src.user = user
	RegisterSignal(user, COMSIG_LIVING_STATUS_SLEEP, PROC_REF(on_sleep_state_changed))
	strip_delay = 60 SECONDS

/obj/item/clothing/head/dreamviewer/dropped(mob/user, silent = FALSE)
	. = ..()

	if(user != src.user)
		return

	UnregisterSignal(user, COMSIG_LIVING_STATUS_SLEEP)

	if(dreamgate_opened)
		close_dreamgate(user)
		punish(user)

	src.user = null
	strip_delay = initial(strip_delay)

/obj/item/clothing/head/dreamviewer/proc/punish(mob/living/carbon/human/user)
	var/datum/component/dreamgate_visitor/comp = user.GetComponent(/datum/component/dreamgate_visitor)

	var/visited = comp ? comp.times_visited : 1
	var/deaths = comp ? comp.deaths_in_dream : 0

	var/penalty = visited * 5 + deaths * 5
	var/obj/item/organ/heart/heart = user.get_organ_slot(ORGAN_SLOT_HEART)
	var/obj/item/organ/brain/brain = user.get_organ_slot(ORGAN_SLOT_BRAIN)

	playsound(get_turf(src), 'sound/effects/alert.ogg', 50)

	if(penalty <= 10)
		user.visible_message(span_warning("[user] suddenly grabs [user.p_their()] head, staggering as the DreamViewer violently disconnects."))
		to_chat(user, span_warning("A violent jolt tears through your mind as the DreamViewer forcibly disconnects from your neural pathways."))
		to_chat(user, span_warning("For a moment, you cannot tell whether you are awake or still dreaming."))

		heart?.apply_organ_damage(rand(5, 10))
		brain?.apply_organ_damage(rand(5, 10))

		user.Stun(20)
		user.Paralyze(10)

	else if(penalty <= 30)
		user.visible_message(span_danger("[user] collapses to [user.p_their()] knees, violently trembling as the DreamViewer tears itself away."))
		to_chat(user, span_danger("A searing pain erupts behind your eyes as something forcibly tears you out of the dream."))
		to_chat(user, span_danger("Your thoughts become disordered. For several seconds, you cannot tell which sensations are real."))
		to_chat(user, span_warning("Your heart stutters violently as your body struggles to recover from the forced awakening."))

		heart?.apply_organ_damage(rand(25, 70))
		brain?.apply_organ_damage(rand(25, 50))
		heart?.Stop()

		user.Stun(40)
		user.Paralyze(20)

		user.Unconscious(30)

	else
		user.visible_message(span_userdanger("[user] suddenly convulses as the DreamViewer forcibly tears itself from [user.p_their()] nervous system!"))
		to_chat(user, span_userdanger("Something inside your mind snaps."))
		to_chat(user, span_userdanger("You feel your consciousness collapsing in on itself as the boundary between dream and reality violently tears apart."))
		to_chat(user, span_userdanger("Your heart loses its rhythm. Your body no longer feels like your own."))

		heart?.apply_organ_damage(500)
		brain?.apply_organ_damage(500)

		user.Stun(100)
		user.Paralyze(100)
		user.Unconscious(100)
		user.death()
		ADD_TRAIT(user, TRAIT_DNR, INNATE_TRAIT)

/obj/item/clothing/head/dreamviewer/proc/on_sleep_state_changed(mob/living/carbon/human/user, amount)
	SIGNAL_HANDLER

	if(amount <= 0 || dreamgate_opened)
		return

	try_fell_dream(user)

/obj/item/clothing/head/dreamviewer/proc/try_fell_dream(mob/living/carbon/human/user)
	playsound(get_turf(src), 'sound/effects/alert.ogg', 20)
	user.visible_message(span_notice("[src], secures itself to the [user] head, fitting tightly against [user.p_their()] skull."))
	to_chat(user, span_warning("The DreamViewer secures itself to your head, fitting tightly against your skull. You feel a strange pressure as the device activates."))
	addtimer(CALLBACK(src, PROC_REF(fell_into_dream), user), 2 SECONDS)

/obj/item/clothing/head/dreamviewer/proc/fell_into_dream(mob/living/carbon/human/user)
	if(!user)
		return
	if(!user.IsSleeping())
		return
	if(dreamgate_opened)
		return
	dreamgate_opened = TRUE
	user.visible_message(span_notice("[src] activates, and a strange sensation washes over [user]."))
	to_chat(user, span_warning("You feel a strange sensation as the DreamViewer activates. Your consciousness begins to drift into a dream state."))

	// Left to take the intro, same as the smite does. Dropping into the dream should shake and warn
	// the same way being thrown down there does - it is the same trip, whatever sent them on it.
	var/successful = user.AddComponent(/datum/component/backrooms_exile, exile_time = -1, instant = TRUE)
	if(!successful)
		user.visible_message(span_warning("The DreamViewer fails to establish a connection to the Dream Gate network."))
		to_chat(user, span_warning("The DreamViewer fails to establish a connection to the Dream Gate network. You feel your consciousness returning to the waking world."))
		dreamgate_opened = FALSE
		return

	var/datum/component/dreamgate_visitor/comp = user.GetComponent(/datum/component/dreamgate_visitor)
	if(!comp)
		comp = user.AddComponent(/datum/component/dreamgate_visitor)

	comp.last_visit_time = world.time
	comp.times_visited += 1
	last_scramble_time = world.time

	sleep_time = world.time


/obj/item/clothing/head/dreamviewer/proc/close_dreamgate(mob/living/carbon/human/user)
	if(!user)
		return
	if(!dreamgate_opened)
		return
	dreamgate_opened = FALSE
	user.visible_message(span_notice("[src] deactivates, and you feel your consciousness returning to the waking world."))
	to_chat(user, span_warning("You feel your consciousness returning to the waking world as the DreamViewer deactivates."))

	var/datum/component/dreamgate_visitor/comp = user.GetComponent(/datum/component/dreamgate_visitor)
	if(comp)
		comp.last_visit_time = world.time

	var/datum/component/backrooms_exile/exile = user.GetComponent(/datum/component/backrooms_exile)
	if(exile && !QDELETED(exile))
		qdel(exile)



/obj/item/clothing/head/dreamviewer/prototype
	name = "Dreamviewer Prototype"
	desc = "A prototype version of the Dreamviewer. It is designed to establish a controlled connection between a sleeping subject and the Dream Gate network. \
			The device allows the wearer to enter a stable, artificially maintained dream state while remaining connected to external monitoring equipment. \
			While active, the DreamViewer cannot be removed by conventional means and the wearer cannot be awakened through normal methods."

	icon_state = "dreamviewer_prototype"
	var/dreamcrystal_inserted = FALSE

/obj/item/clothing/head/dreamviewer/prototype/examine(mob/user)
	. = ..()
	if(!dreamcrystal_inserted)
		. += span_warning("<b>WARNING</b>: No Dream Crystal has been inserted into the device. The DreamViewer will not function without a Dream Crystal.")
	else
		. += span_green("A Dream Crystal has been inserted into the device. The DreamViewer is ready for use.")

/obj/item/clothing/head/dreamviewer/prototype/attacked_by(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!istype(attacking_item, /obj/item/stack/dreamcrystal))
		return ..()
	if(dreamcrystal_inserted)
		user.visible_message(span_warning("[src] already has a Dream Crystal inserted."))
		to_chat(user, span_warning("The DreamViewer already has a Dream Crystal inserted."))
		return ITEM_INTERACT_SUCCESS
	var/obj/item/stack/dreamcrystal/crystal = attacking_item
	if(crystal.use(1))
		dreamcrystal_inserted = TRUE
		user.visible_message(span_notice("[user] inserts a Dream Crystal into [src]."))
		to_chat(user, span_notice("You insert a Dream Crystal into the DreamViewer. The device is now ready for use."))
		return ITEM_INTERACT_SUCCESS

/obj/item/clothing/head/dreamviewer/prototype/try_fell_dream(mob/living/carbon/human/user)
	if(!dreamcrystal_inserted)
		user.visible_message(span_warning("[src] fails to activate, as no Dream Crystal has been inserted into the device."))
		to_chat(user, span_warning("The DreamViewer fails to activate, as no Dream Crystal has been inserted into the device."))
		return
	..()

/datum/component/dreamgate_visitor
	var/mob/living/visitor
	var/times_visited = 0
	var/last_visit_time = 0
	var/deaths_in_dream = 0



/obj/item/stack/dreamcrystal
	name = "Dream Crystal"
	desc = "An unusual crystalline material recovered from the Dream Gate system. \
			Despite its physical appearance, the crystal exhibits properties inconsistent with conventional matter. \
			Its internal structure appears to change when exposed to neural activity, producing faint electromagnetic and psionic fluctuations.\
			The material is currently classified as an experimental resource. Further processing is required before it can be safely used in Dream Gate technology."
	icon = 'icons/obj/dreamviewer.dmi'
	icon_state = "dreacmcrystal_raw"


/obj/item/stack/dreamcrystal_refined
	name = "Refined Dream Crystal"
	desc = "A highly concentrated form of Dream Crystal produced through direct interaction with a DreamViewer-equipped subject. \
			The refinement process causes the crystal to retain traces of the subject's dream-state activity.  \
			Each sample appears to contain unique patterns corresponding to the individual from which it was extracted. \
			The resulting material is considerably more stable and suitable for use in Dream Gate technology."
	icon = 'icons/obj/dreamviewer.dmi'
	icon_state = "dreamcrystal"


/obj/item/dream_reaper
	name = "Dream Reaper"
	desc = "A specialized neural extraction device designed to interface directly with an active DreamViewer. \
			The Dream Reaper extracts residual dream-state energy from a sleeping subject and crystallizes it into Refined Dream Crystal. \
			The subject must remain connected to an active DreamViewer throughout the extraction process. \
			The device is incapable of extracting from an awake or unconnected subject."
	icon = 'icons/obj/dreamviewer.dmi'
	icon_state = "dream_reaper"

/obj/item/dream_reaper/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ishuman(interacting_with))
		return ..()

	var/mob/living/carbon/human/target = interacting_with
	if(!target.canon_client)
		return ..()

	var/obj/item/clothing/head/dreamviewer/DV = target.head
	if(!DV || !istype(DV, /obj/item/clothing/head/dreamviewer))
		return ..()

	if(!target.IsSleeping() || !DV.dreamgate_opened)
		return ..()

	if((world.time - DV.last_scramble_time) < DV.default_scramble_cooldown)
		to_chat(user, span_warning("The DreamViewer is still stabilizing the dream crystal. Please wait before attempting to extract again."))
		return ..()

	if((world.time - DV.sleep_time) < DV.sleep_time_before_scramble)
		to_chat(user, span_warning("The DreamViewer has not been active long enough to extract a stable dream crystal. Please wait before attempting to extract."))
		return ..()

	addtimer(CALLBACK(src, PROC_REF(try_scramle), target, user, DV), 1)
	return ITEM_INTERACT_SUCCESS

/obj/item/dream_reaper/proc/try_scramle(mob/living/carbon/human/target, mob/living/carbon/human/user, obj/item/clothing/head/dreamviewer/DV)
	if(QDELETED(target) || QDELETED(user))
		return

	user.visible_message(span_notice("[user] inserts a long needle [src] into the eye [target], driving it into the skull and beginning to extract the dream crystal."))
	if(!do_after(user, 10 SECONDS, target, max_interact_count = 1))
		user.visible_message(span_warning("[user] fails to extract the dream crystal from [target]."))
		var/obj/item/organ/eyes/eyes = target.get_organ_slot(ORGAN_SLOT_EYES)
		eyes?.apply_organ_damage(rand(5, 15))
		return

	if(QDELETED(target) || QDELETED(user) || QDELETED(DV))
		return

	var/obj/item/stack/dreamcrystal_refined/new_crystal = new /obj/item/stack/dreamcrystal_refined(get_turf(src))
	user.put_in_inactive_hand(new_crystal)
	DV.last_scramble_time = world.time
