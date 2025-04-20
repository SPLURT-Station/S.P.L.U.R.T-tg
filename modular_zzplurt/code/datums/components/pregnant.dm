/datum/component/pregnant
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// Baby boy we are holding, if he dies or is moved bad things happen and the component is deleted
	var/mob/living/baby_boy

	/// Name of the mommy
	var/father_name
	/// Name of the daddy
	var/mother_name
	/// Name of the baby
	var/baby_name

/datum/component/pregnant/Initialize(mob/living/baby_boy, mother_name, father_name, baby_name)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

	if(!baby_boy)
		qdel(src)
		return

	src.baby_boy = baby_boy
	baby_boy.forceMove(parent)

/datum/component/pregnant/RegisterWithParent()
	RegisterSignal(parent, SIGNAL_ADDTRAIT(TRAIT_WAS_RENAMED), PROC_REF(on_renamed))
	RegisterSignal(parent, SIGNAL_REMOVETRAIT(TRAIT_WAS_RENAMED), PROC_REF(on_renamed_removed))
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_GHOST, PROC_REF(on_attack_ghost))
	RegisterSignal(parent, COMSIG_ATOM_BREAK, PROC_REF(still_birth))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	if(baby_boy)
		RegisterSignal(baby_boy, COMSIG_MOVABLE_MOVED, PROC_REF(still_birth))
		RegisterSignal(baby_boy, COMSIG_LIVING_DEATH, PROC_REF(still_birth))
		RegisterSignal(baby_boy, COMSIG_QDELETING, PROC_REF(still_birth))
		baby_boy.AddComponent(\
			/datum/component/ghost_direct_control,\
			ban_type = ROLE_SENTIENCE,\
			role_name = "Offspring of [mother_name || "someone"][father_name ? " and [father_name]" : ""]",\
			poll_question = "Do you want to play as [mother_name || "someone"]'s offspring?[baby_name ? " Your name will be [baby_name]" : ""]",\
			poll_candidates = TRUE,\
			poll_length = 1.5 MINUTES,\
			assumed_control_message = "You are the son (or daughter) of [mother_name || "someone"][father_name ? " and [father_name]" : ""]!",\
			poll_ignore_key = POLL_IGNORE_PREGNANCY,\
			after_assumed_control = CALLBACK(src, PROC_REF(ghost_assumed_control)),\
		)

/datum/component/pregnant/UnregisterFromParent()
	UnregisterSignal(parent, list(\
		SIGNAL_ADDTRAIT(TRAIT_WAS_RENAMED),\
		SIGNAL_REMOVETRAIT(TRAIT_WAS_RENAMED),\
		COMSIG_ATOM_ATTACK_GHOST,\
		COMSIG_ATOM_BREAK,\
		COMSIG_ATOM_EXAMINE,\
	))
	if(!QDELETED(baby_boy))
		UnregisterSignal(baby_boy, list(\
			COMSIG_MOVABLE_MOVED,\
			COMSIG_LIVING_DEATH,\
			COMSIG_QDELETING,\
		))
		qdel(baby_boy.GetComponent(/datum/component/ghost_direct_control))

/datum/component/pregnant/Destroy(force)
	baby_boy = null
	return ..()

/datum/component/pregnant/proc/on_attack_ghost(mob/source, mob/dead/observer/hopeful_ghost)
	SIGNAL_HANDLER

	//relay to the mob
	if(baby_boy)
		INVOKE_ASYNC(baby_boy, TYPE_PROC_REF(/atom, attack_ghost), hopeful_ghost)
		return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/pregnant/proc/on_renamed(atom/source)
	SIGNAL_HANDLER

	baby_name = reject_bad_name(source.name)

/datum/component/pregnant/proc/on_renamed_removed(atom/source)
	SIGNAL_HANDLER

	baby_name = null

/datum/component/pregnant/proc/on_examine(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	examine_list += span_notice("[source] [source.p_have()] something hatching inside of [source.p_them()]!")
	var/parents
	if(mother_name && father_name)
		parents = "<b>[mother_name]</b> and <b>[father_name]</b>"
	else if(mother_name)
		parents = "<b>[mother_name]</b>"
	else if(father_name)
		parents = "<b>[father_name]</b>"
	if(parents)
		examine_list += span_info("It is the offspring of [parents].")
	if(baby_name)
		examine_list += span_info("The offspring's name will be \"[baby_name]\".")

/datum/component/pregnant/proc/still_birth(atom/source)
	SIGNAL_HANDLER

	var/atom/atom_parent = parent
	if(QDELETED(baby_boy))
		baby_boy = null
	else
		QDEL_NULL(baby_boy)
	if(!QDELETED(atom_parent))
		new /obj/effect/gibspawner/generic(atom_parent.drop_location())
		if(atom_parent.uses_integrity)
			atom_parent.take_damage(atom_parent.max_integrity * (1-atom_parent.integrity_failure))
	if(!QDELING(src))
		qdel(src)

/datum/component/pregnant/proc/ghost_assumed_control(mob/living/a_living_soul)
	var/atom/atom_parent = parent
	if(!QDELING(src))
		qdel(src)
	playsound(atom_parent, 'sound/effects/splat.ogg', 80, vary = TRUE)
	a_living_soul.AdjustUnconscious(30 SECONDS)
	a_living_soul.forceMove(atom_parent.drop_location())
	if(atom_parent.uses_integrity)
		atom_parent.take_damage(atom_parent.max_integrity * (1-atom_parent.integrity_failure))
	if(ishuman(a_living_soul))
		INVOKE_ASYNC(src, PROC_REF(assumed_control_async), a_living_soul)

/datum/component/pregnant/proc/assumed_control_async(mob/living/carbon/human/a_living_soul)
	if(baby_name)
		return

	var/target_name = reject_bad_name(tgui_input_text(a_living_soul, "What will be your name?", "The miracle of birth", a_living_soul.real_name))
	if(!target_name)
		return

	a_living_soul.real_name = target_name
	a_living_soul.name = a_living_soul.real_name
	a_living_soul.updateappearance()
