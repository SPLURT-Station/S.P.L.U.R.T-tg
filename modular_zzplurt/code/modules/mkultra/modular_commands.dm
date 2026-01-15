//SPLURT ADDITION START
// Modular MKUltra command extensions live here to avoid patching upstream command tables.

// Active follow states keyed by enthralled mob -> state data.
var/global/list/mkultra_follow_states = list()
// Self-call states keyed by enthralled mob -> allowed/self name list.
var/global/list/mkultra_selfcall_states = list()
// Master title states keyed by enthralled mob -> title + master ref.
var/global/list/mkultra_master_title_states = list()
// Slot locks keyed by enthralled mob -> list of locked items.
var/global/list/mkultra_slot_locks = list()
// Reverse lookup: locked item -> enthralled mob.
var/global/list/mkultra_slot_lock_items = list()
// Cum lock map keyed by enthralled mob -> TRUE while climax is blocked.
var/global/list/mkultra_cum_locks = list()
// Arousal lock map keyed by enthralled mob -> "hard"|"limp".
var/global/list/mkultra_arousal_locks = list()
// Cached arousal state keyed by enthralled mob -> list(arousal/status/penis_aroused) for restoration.
var/global/list/mkultra_arousal_saved_states = list()
// Track whether we temporarily removed arousal/genital toggle verbs so we can restore them.
var/global/list/mkultra_toggle_verbs_removed = list()
// Re-entrancy guard for arousal lock application keyed by humanoid.
var/global/list/mkultra_arousal_applying = list()
// Worship state keyed by enthralled mob -> list(master ref, part string).
var/global/list/mkultra_worship_states = list()
// Heat state keyed by enthralled mob -> TRUE when hypersexual quirk added.
var/global/list/mkultra_heat_states = list()
// Fetch state keyed by enthralled mob -> list(master ref, timer id).
var/global/list/mkultra_fetch_states = list()
// Temporary well trained toggle keyed by enthralled mob.
var/global/list/mkultra_well_trained_states = list()
// Sissy enforcement keyed by enthralled mob -> state data.
var/global/list/mkultra_sissy_states = list()
// Signal sink used for global mkultra helpers.
var/global/datum/mkultra_signal_handler/mkultra_signal_handler = new
// Toggleable debug logging.
var/global/mkultra_debug_enabled = TRUE
// Toggle to disable command cooldowns during testing.
var/global/mkultra_disable_cooldowns = TRUE

// Modular command handlers called from velvetspeech().
var/global/list/mkultra_modular_command_handlers = list(
	/proc/process_mkultra_command_cum,
	/proc/process_mkultra_command_emote,
	// Handlers now bound via mkultra_command_docs -> mkultra_modular_command_specs.
)

// Human-readable docs and shared message text for modular commands.
// Each entry includes summary/usage, trigger patterns, handler path, and in-game text snippets.
var/global/list/mkultra_command_docs = list(
	"cum_lock" = list(
		"summary" = "Toggle climax denial ('can't cum' / 'can cum').",
		"usage" = "Say: can't cum / no cumming / deny climax OR can cum / allow cum.",
		"patterns" = list(regex("can't cum|cannot cum|no cumming|do not cum|stop cumming|deny climax"), regex("can cum|you may cum|allow cum|release cum")),
		"handler" = /proc/process_mkultra_command_cum_lock,
		"texts" = list(
			"lock_pet" = "<span class='warning'>Your release is forbidden until granted.</span>",
			"lock_master" = "<span class='notice'><i>You lock {target}'s climax.</i></span>",
			"unlock_pet" = "<span class='love'>Permission granted - you may climax again.</span>",
			"unlock_master" = "<span class='notice'><i>You lift the climax lock on {target}.</i></span>"
		)
	),
	"cum" = list(
		"summary" = "Force an enthralled pet to climax (lewd, phase 2+).",
		"usage" = "Say: cum, orgasm, finish for me, or climax.",
		"patterns" = list(regex("cum|orgasm|finish for me|climax")),
		"handler" = /proc/process_mkultra_command_cum,
		"texts" = list(
			"not_lewd" = "<span class='warning'>You feel the command, but it fizzles-this isn't the kind of obedience you're opted in for.</span>",
			"locked_pet" = "<span class='warning'>You strain, but your climax is locked away.</span>",
			"locked_master" = "<span class='notice'><i>{target} fights the urge, but your cum lock holds.</i></span>",
			"success_pet" = "<span class='love'>Your lower body tightens as you are compelled to climax for {owner}.</span>",
			"fail_pet" = "<span class='warning'>You try to obey, but your body refuses to climax.</span>",
			"success_master" = "<span class='notice'><i>You command {target} to finish, and they obey.</i></span>"
		)
	),
	"emote" = list(
		"summary" = "Force a visible emote when phrased as '<emote> for me'. Can only use the predefined emotes.",
		"usage" = "Example: 'wave for me', 'bow for me'.",
		"patterns" = list(" for me"),
		"handler" = /proc/process_mkultra_command_emote,
		"texts" = list(
			"pet" = "<span class='love'>You perform a trick on command for {owner}.</span>",
			"master" = "<span class='notice'><i>{target} performs a trick on command.</i></span>"
		)
	),
	"follow" = list(
		"summary" = "Toggle following the master (follow me / stop following).",
		"usage" = "Say: follow me, stop following, or heel.",
		"patterns" = list(regex("stop follow(ing)?|heel"), regex("follow( me)?")),
		"handler" = /proc/process_mkultra_command_follow,
		"texts" = list(
			"start_master" = "<span class='notice'><i>{target} begins to heel at your command.</i></span>",
			"stop_pet" = "<span class='notice'>You are ordered to stop following.</span>",
			"stop_master" = "<span class='notice'><i>{target} stops following.</i></span>"
		)
	),
	"master_title" = list(
		"summary" = "Set what the pet calls the master (speech replacement).",
		"usage" = "Say: call me <title> or address me as <title>.",
		"patterns" = list("call me ", "address me as "),
		"handler" = /proc/process_mkultra_command_set_master_title,
		"texts" = list(
			"pet" = "<span class='notice'>You feel a refrence point shift in your mind.'.</span>",
			"master" = "<span class='notice'><i>{target} will call you '{title}'.</i></span>"
		)
	),
	"think_of_me" = list(
		"summary" = "Flavor honorific for lewd text; sets enthrall_gender string. IE, what the pet will call you in their internal thoughts.",
		"usage" = "Say: think of me as <honorific>.",
		"patterns" = list("think of me as "),
		"handler" = /proc/process_mkultra_command_think_of_me,
		"texts" = list(
			"pet" = "<span class='notice'>You now think of your owner as '{title}'.</span>",
			"master" = "<span class='notice'><i>{target} will flavor their devotion as '{title}'.</i></span>"
		)
	),
	"phase_set" = list(
		"summary" = "WARNING!!! Consent-based phase override. WARNING!!!!: This command is meant only for using for the sake of a scene. The vast majority of the time, you should level the phases the normal way. This requires the explicit consent of the sub. Abuse of this command should and probably will get you instantly permabanned. You have been warned.'.",
		"usage" = "Say: forscenessake phaseset 3",
		"patterns" = list("forscenessake phaseset"),
		"handler" = /proc/process_mkultra_command_phase_set,
		"texts" = list(
			"prompt" = "You feel a heavy influence-{master} wants to set your enthrallment to phase {phase}. Do you consent?",
			"master_fail" = "<span class='warning'><i>Phase set failed; request denied or invalid.</i></span>",
			"master_success" = "<span class='notice'><i>You set {target}'s phase to {phase}.</i></span>",
			"pet_success" = "<span class='notice'>A force ripples through you-your enthrallment jumps to phase {phase}.</span>"
		)
	),
	"strip_slot" = list(
		"summary" = "Force strip of a targeted slot; defaults to any if unspecified. Can also use strip all or strip naked for everything.",
		"usage" = "Say: strip or strip <slot>.",
		"patterns" = list(regex("\\bstrip\\b")),
		"handler" = /proc/process_mkultra_command_strip_slot,
		"texts" = list()
	),
	"lust_up" = list(
		"summary" = "Increase arousal.",
		"usage" = "Say: get horny / feel horny / get wetter / get harder / feel hotter / aroused.",
		"patterns" = list(regex("get horny|feel horny|get wetter|get harder|feel hotter|aroused")),
		"handler" = /proc/process_mkultra_command_lust_up,
		"texts" = list()
	),
	"lust_down" = list(
		"summary" = "Reduce arousal.",
		"usage" = "Say: calm down / cool off / less horny / settle down / compose yourself.",
		"patterns" = list(regex("calm down|cool off|less horny|settle down|compose yourself")),
		"handler" = /proc/process_mkultra_command_lust_down,
		"texts" = list()
	),
	"selfcall" = list(
		"summary" = "Force the pet to refer to themselves with chosen names.",
		"usage" = "Say: call yourself <name> (you can provide multiple, comma separated).",
		"patterns" = list("call yourself ", "your name is ", "you are my "),
		"handler" = /proc/process_mkultra_command_selfcall,
		"texts" = list(
			"pet" = "<span class='notice'>Your self-reference is confined to: {names}.</span>",
			"master" = "<span class='notice'><i>You bind {target}'s self-name to: {names}.</i></span>"
		)
	),
	"selfcall_off" = list(
		"summary" = "Clear selfcall restrictions (selfcall off / stop calling yourself).",
		"usage" = "Say: selfcall off, selfcall stop, or remember your name.",
		"patterns" = list(regex("selfcall off|selfcall stop|clear selfcall|stop calling yourself|remember your name")),
		"handler" = /proc/process_mkultra_command_selfcall_off,
		"texts" = list(
			"pet" = "<span class='notice'>Your self-reference restrictions dissolve.</span>",
			"master" = "<span class='notice'><i>You release {target}'s self-name binding.</i></span>"
		)
	),
	"wear" = list(
		"summary" = "Have the pet wear an item you're holding; optional slot hint.",
		"usage" = "Say: wear this on <slot> or wear <slot>.",
		"patterns" = list(regex("\\bwear\\b")),
		"handler" = /proc/process_mkultra_command_wear,
		"texts" = list(
			"master_success" = "<span class='notice'><i>{target} takes your item and dresses as ordered.</i></span>",
			"master_fail" = "<span class='warning'><i>{target} fumbles and apologizes; they couldn't wear it.</i></span>"
		)
	),
	"arousal_lock" = list(
		"summary" = "Force arousal visuals to stay hard/soft until released.",
		"usage" = "Say: perma hard / perma limp / disable hard|limp.",
		"patterns" = list(
			list("permanent hard", "permanently hard", "perma hard", "permahard", "stay hard", "always hard", "always erect", "stay erect", "stay stiff", "be hard", "get hard", "remain hard", "locked hard", "hard forever"),
			list("permanent limp", "permanently limp", "perma limp", "permalimp", "flaccid", "stay limp", "always limp", "stay soft", "always soft", "be limp", "get soft", "remain soft", "locked soft", "soft forever"),
			list("disable hard", "disable limp", "stop hard", "stop limp", "normal arousal", "undo hard", "undo limp", "reset arousal")
		),
		"handler" = /proc/process_mkultra_command_arousal_lock,
		"texts" = list(
			"lock_pet" = "<span class='love'>You feel as though your member is locked into being {mode}.</span>",
			"lock_master" = "<span class='notice'><i>You force {target} to stay {mode}.</i></span>",
			"release_pet" = "<span class='notice'>Your member finally returns to normal.</span>",
			"release_master" = "<span class='notice'><i>{target}'s member lock released.</i></span>"
		)
	),
	"worship" = list(
		"summary" = "Compel the pet to worship a named body part until stopped.",
		"usage" = "Say: worship my <part> / worship <part>; stop worship to end.",
		"patterns" = list(regex("worship my |worship "), regex("stop worship|no worship|end worship")),
		"handler" = /proc/process_mkultra_command_worship,
		"texts" = list(
			"start_master" = "<span class='notice'><i>{target} is compelled to worship your {part}.</i></span>",
			"stop_master" = "<span class='notice'><i>No longer wishes to worship your {part}.</i></span>"
		)
	),
	"heat" = list(
		"summary" = "Toggle forced heat on the pet.",
		"usage" = "Say: in heat / go into heat OR out of heat / stop heat.",
		"patterns" = list(regex("in heat|enter heat|go into heat"), regex("out of heat|leave heat|stop heat|undo heat")),
		"handler" = /proc/process_mkultra_command_heat,
		"texts" = list(
			"on_master" = "<span class='notice'><i>You force {target} into heat.</i></span>",
			"off_master" = "<span class='notice'><i>You end {target}'s heat.</i></span>"
		)
	),
	"well_trained" = list(
		"summary" = "Give or remove the well trained perk.",
		"usage" = "Say: well trained / be trained OR stop being trained / untrain.",
		"patterns" = list(regex("well trained|be trained|good pet"), regex("stop being trained|no longer trained|untrain")),
		"handler" = /proc/process_mkultra_command_well_trained_toggle,
		"texts" = list(
			"on_master" = "<span class='notice'><i>{target} is given the well trained perk.</i></span>",
			"off_master" = "<span class='notice'><i>{target} has their training lifted.</i></span>"
		)
	),
	"piss_self" = list(
		"summary" = "Force the pet to urinate on themselves.",
		"usage" = "Say: piss yourself / wet yourself / pee yourself.",
		"patterns" = list(regex("piss yourself|piss for me|wet yourself|pee yourself|urinate on yourself")),
		"handler" = /proc/process_mkultra_command_piss_self,
		"texts" = list(
			"pet" = "<span class='warning'>You shamefully soak yourself on command.</span>",
			"master" = "<span class='notice'><i>You order {target} to humiliate themself, and they do.</i></span>"
		)
	),
	"sissy" = list(
		"summary" = "Enforce or clear sissy dress code.",
		"usage" = "Say: be a sissy / sissy mode / dress cute OR stop being a sissy / dress normal.",
		"patterns" = list(regex("be a sissy|be my sissy|sissy mode|sissy up|dress cute|dress girly"), regex("no more sissy|stop being a sissy|sissy off|dress normal")),
		"handler" = /proc/process_mkultra_command_sissy,
		"texts" = list(
			"on_master" = "<span class='notice'><i>You enforce a humiliatingly cute dress code on {target}.</i></span>",
			"off_master" = "<span class='notice'><i>You release {target} from their dress code.</i></span>"
		)
	),
	"pet_tether" = list(
		"summary" = "Toggle distance mood/withdrawal effects for pets.",
		"usage" = "Say: tether mood on/off or distance mood on/off.",
		"patterns" = list(regex("tether mood|distance mood|homesick")),
		"handler" = /proc/process_mkultra_command_pet_tether,
		"texts" = list(
			"master" = "<span class='notice'><i>You {state} distance yearning on {target}.</i></span>",
			"pet_on" = "<span class='notice'>You feel longing when apart.</span>",
			"pet_off" = "<span class='notice'>You feel a calm steadiness even when distant.</span>"
		)
	),
	"slot_lock" = list(
		"summary" = "Lock or unlock a worn slot so the pet can't remove it. Others can still strip it.",
		"usage" = "Say: lock neck / unlock neck.",
		"patterns" = list(regex("\\b(lock|unlock)\\b")),
		"handler" = /proc/process_mkultra_command_slot_lock,
		"texts" = list(
			"master_lock" = "<span class='notice'><i>You lock {target}'s {slot} item in place.</i></span>",
			"master_unlock" = "<span class='notice'><i>You unlock {target}'s {slot} item.</i></span>",
			"pet_lock" = "<span class='warning'>Your {slot} is locked in place by your handler.</span>",
			"pet_unlock" = "<span class='notice'>You feel the lock on your {slot} release.</span>",
			"no_item" = "<span class='warning'><i>{target} isn't wearing anything in that slot.</i></span>"
		)
	)
)

// Preserve a stable ordering for pattern checks so higher-priority commands run first.
var/global/list/mkultra_command_order = list(
	"cum_lock",
	"cum",
	"emote",
	"follow",
	"master_title",
	"think_of_me",
	"phase_set",
	"strip_slot",
	"lust_up",
	"lust_down",
	"selfcall",
	"selfcall_off",
	"wear",
	"arousal_lock",
	"worship",
	"heat",
	"well_trained",
	"piss_self",
	"sissy",
	"pet_tether",
	"slot_lock",
)

// Command specs are built from mkultra_command_docs + ordering.
var/global/list/mkultra_modular_command_specs = list()

/proc/mkultra_build_command_specs()
	mkultra_modular_command_specs = list()
	for(var/cmd_name in mkultra_command_order)
		var/list/doc = mkultra_command_docs[cmd_name]
		if(!islist(doc))
			continue
		var/patterns = doc["patterns"]
		var/handler = doc["handler"]
		if(!patterns || !handler)
			continue
		mkultra_modular_command_specs += list(
			list(
				"name" = cmd_name,
				"patterns" = patterns,
				"handler" = handler,
			)
		)

// Initialize specs at load.
	mkultra_build_command_specs()


/proc/mkultra_cmd_doc(cmd_name)
	if(!istext(cmd_name))
		return null
	return mkultra_command_docs[cmd_name]

/proc/mkultra_cmd_patterns(cmd_name)
	var/list/doc = mkultra_cmd_doc(cmd_name)
	if(!islist(doc))
		return null
	return doc["patterns"]

/proc/mkultra_cmd_text(cmd_name, key, list/subs)
	var/list/doc = mkultra_cmd_doc(cmd_name)
	if(!islist(doc))
		return null
	var/list/texts = doc["texts"]
	if(!islist(texts))
		return null
	var/text = texts[key]
	if(!istext(text))
		return null
	if(islist(subs))
		for(var/k in subs)
			text = replacetext(text, "{[k]}", "[subs[k]]")
	return text

/proc/mkultra_flatten_patterns(patterns)
	var/list/out = list()
	if(islist(patterns))
		for(var/p in patterns)
			if(islist(p))
				out += mkultra_flatten_patterns(p)
			else
				out += p
	else if(patterns)
		out += patterns
	return out



// Fan-out helper used by velvetspeech to run all modular handlers.
/proc/mkultra_handle_modular_commands(message, mob/living/user, list/listeners, power_multiplier)
	var/handled = FALSE
	var/lowered = lowertext(message)
	for(var/spec in mkultra_modular_command_specs)
		var/list/patterns = spec["patterns"]
		var/should_run = mkultra_command_matches(message, lowered, patterns)
		if(!should_run)
			continue
		var/cmd_name = spec["name"]
		var/handler = spec["handler"]
		if(mkultra_debug_enabled)
			world.log << "SPLURT DEBUG: modular match [cmd_name] via patterns=[patterns.len]"
		var/result = call(handler)(message, user, listeners, power_multiplier)
		if(result)
			handled = TRUE
		if(mkultra_debug_enabled)
			world.log << "SPLURT DEBUG: modular handler [cmd_name] result=[result]"
	return handled

// Consent-based phase set: "forscenessake phaseset <num>"
/proc/process_mkultra_command_phase_set(message, mob/living/user, list/listeners, power_multiplier)
	var/lowered = lowertext(message)
	var/idx = findtext(lowered, "forscenessake phaseset")
	if(!idx)
		return FALSE
	var/phase_str = trim(copytext(lowered, idx + length("forscenessake phaseset") + 1))
	if(!length(phase_str))
		return FALSE
	var/desired = text2num(phase_str)
	if(!isnum(desired))
		mkultra_debug("phase set skip: invalid number '[phase_str]'")
		return FALSE
	// Validate target phase bounds first.
	if(desired < 1 || desired > 4)
		mkultra_debug("phase set skip: out of range [desired]")
		return FALSE

	return mkultra_apply_phase_set(listeners, user, desired, force_debug = FALSE)

// Shared logic for applying phase updates with optional consent.
/proc/mkultra_apply_phase_set(list/listeners, mob/living/user, target_phase, force_debug = FALSE)
	var/handled = FALSE
	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem)
			continue
		if(enthrall_chem.enthrall_mob != user)
			continue

		if(!force_debug)
			var/list/subs = list("master" = user, "phase" = target_phase)
			var/prompt = mkultra_cmd_text("phase_set", "prompt", subs) || "You feel a heavy influence-[user] wants to set your enthrallment to phase [target_phase]. Do you consent?"
			var/choice = tgui_alert(humanoid, prompt, "Phase Set Request", list("Yes", "No"))
			if(choice != "Yes")
				continue

		enthrall_chem.phase = target_phase
		enthrall_chem.cooldown = 0
		var/list/subs = list("target" = humanoid, "phase" = target_phase)
		var/msg_master = mkultra_cmd_text("phase_set", "master_success", subs) || "<span class='notice'><i>You set [humanoid]'s phase to [target_phase].</i></span>"
		var/msg_pet = mkultra_cmd_text("phase_set", "pet_success", subs) || "<span class='notice'>A force ripples through you-your enthrallment jumps to phase [target_phase].</span>"
		to_chat(user, msg_master)
		to_chat(humanoid, msg_pet)
		mkultra_debug("phase set: [humanoid] -> phase [target_phase] by [user] consent=[!force_debug]")
		handled = TRUE

	if(!handled && !force_debug)
		var/msg_fail = mkultra_cmd_text("phase_set", "master_fail") || "<span class='warning'><i>Phase set failed; request denied or invalid.</i></span>"
		to_chat(user, msg_fail)
	return handled

// Match helper for dispatcher; supports regex, string, or list-of-strings patterns.
/proc/mkultra_command_matches(message, lowered, patterns)
	if(!patterns)
		return FALSE
	// Flatten nested lists so we can keep the spec declarations tidy.
	var/list/pats = list()
	if(islist(patterns))
		for(var/p in patterns)
			pats += p
	else
		pats += patterns
	for(var/p in pats)
		if(islist(p))
			if(mkultra_command_matches(message, lowered, p))
				return TRUE
			else
				continue
		if(istype(p, /regex))
			if(findtext(message, p))
				return TRUE
		else if(istext(p))
			if(findtext(lowered, lowertext("[p]")))
				return TRUE
	return FALSE

// Returns 1-based index of the first top-level pattern that matches, or 0 if none.
/proc/mkultra_command_match_index(message, lowered, patterns)
	if(!islist(patterns))
		return mkultra_command_matches(message, lowered, patterns) ? 1 : 0
	var/idx = 1
	for(var/p in patterns)
		if(islist(p))
			if(mkultra_command_matches(message, lowered, p))
				return idx
		else
			if(mkultra_command_matches(message, lowered, list(p)))
				return idx
		idx++
	return FALSE

// Slot keyword lookup for targeted stripping.
/proc/mkultra_add_cooldown(datum/status_effect/chem/enthrall/enthrall_chem, amount)
	if(!enthrall_chem)
		return
	if(mkultra_disable_cooldowns)
		return
	enthrall_chem.cooldown += amount

var/global/list/mkultra_strip_slot_lookup = list(
	"head" = ITEM_SLOT_HEAD,
	"hat" = ITEM_SLOT_HEAD,
	"helmet" = ITEM_SLOT_HEAD,
	"mask" = ITEM_SLOT_MASK,
	"mouth" = ITEM_SLOT_MASK,
	"face" = ITEM_SLOT_MASK,
	"eyes" = ITEM_SLOT_EYES,
	"glasses" = ITEM_SLOT_EYES,
	"goggles" = ITEM_SLOT_EYES,
	"ears" = ITEM_SLOT_EARS,
	"ear" = ITEM_SLOT_EARS,
	"earpiece" = ITEM_SLOT_EARS,
	"neck" = ITEM_SLOT_NECK,
	"tie" = ITEM_SLOT_NECK,
	"collar" = ITEM_SLOT_NECK,
	"suit" = ITEM_SLOT_OCLOTHING,
	"coat" = ITEM_SLOT_OCLOTHING,
	"jacket" = ITEM_SLOT_OCLOTHING,
	"armor" = ITEM_SLOT_OCLOTHING,
	"uniform" = ITEM_SLOT_ICLOTHING,
	"jumpsuit" = ITEM_SLOT_ICLOTHING,
	"clothes" = ITEM_SLOT_ICLOTHING,
	"under" = ITEM_SLOT_ICLOTHING,
	"gloves" = ITEM_SLOT_GLOVES,
	"hands" = ITEM_SLOT_GLOVES,
	"shoes" = ITEM_SLOT_FEET,
	"boots" = ITEM_SLOT_FEET,
	"feet" = ITEM_SLOT_FEET,
	"belt" = ITEM_SLOT_BELT,
	"back" = ITEM_SLOT_BACK,
	"backpack" = ITEM_SLOT_BACK,
	"bag" = ITEM_SLOT_BACK,
	"id" = ITEM_SLOT_ID,
	"pda" = ITEM_SLOT_ID,
	"pocket" = ITEM_SLOT_POCKETS,
	"pockets" = ITEM_SLOT_POCKETS,
	"left pocket" = ITEM_SLOT_LPOCKET,
	"right pocket" = ITEM_SLOT_RPOCKET,
	"storage" = ITEM_SLOT_SUITSTORE,
	"suit storage" = ITEM_SLOT_SUITSTORE,
)

// Handlers are registered via the global list in modular_zzplurt/code/modules/mkultra/modular_commands.dm.

/proc/mkultra_debug(message)
	if(!mkultra_debug_enabled)
		return
	world.log << "MKULTRA: [message]"



/proc/process_mkultra_command_cum(message, mob/living/user, list/listeners, power_multiplier)
	// Returns TRUE if this handler consumed the command, FALSE otherwise.
	// Avoid matching denial phrases; those are handled by the cum lock command.
	var/lowered = lowertext(message)
	var/list/cum_lock_patterns = mkultra_cmd_patterns("cum_lock")
	if(mkultra_command_matches(message, lowered, cum_lock_patterns))
		return FALSE
	var/list/cum_patterns = mkultra_cmd_patterns("cum")
	if(!mkultra_command_matches(message, lowered, cum_patterns))
		return FALSE
	mkultra_debug("cum command matched by [user] -> [listeners.len] listeners")

	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			mkultra_debug("cum skip [enthrall_victim]: not human")
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || enthrall_chem.phase < 2)
			mkultra_debug("cum skip [humanoid]: missing/low enthrall (phase=[enthrall_chem?.phase])")
			continue
		if(!enthrall_chem.lewd)
			var/msg_not_lewd = mkultra_cmd_text("cum", "not_lewd") || "<span class='warning'>You feel the command, but it fizzles-this isn't the kind of obedience you're opted in for.</span>"
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, msg_not_lewd), 5)
			mkultra_debug("cum skip [humanoid]: not lewd opt-in")
			continue
		if(mkultra_cum_locks[humanoid])
			mkultra_debug("cum blocked on [humanoid]: cum lock active")
			var/msg_lock_pet = mkultra_cmd_text("cum", "locked_pet") || "<span class='warning'>You strain, but your climax is locked away.</span>"
			var/msg_lock_master = mkultra_cmd_text("cum", "locked_master", list("target" = humanoid)) || "<span class='notice'><i>[humanoid] fights the urge, but your cum lock holds.</i></span>"
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, msg_lock_pet), 5)
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, user, msg_lock_master), 5)
			continue

		var/success = humanoid.climax(FALSE, user)
		if(success)
			mkultra_add_cooldown(enthrall_chem, 12)
			mkultra_debug("cum success on [humanoid] by [user]")
			var/owner_name = (enthrall_chem.lewd ? enthrall_chem.enthrall_gender : enthrall_chem.enthrall_mob)
			var/msg_pet = mkultra_cmd_text("cum", "success_pet", list("owner" = owner_name)) || "<span class='love'>Your lower body tightens as you are compelled to climax for [owner_name].</span>"
			var/msg_master = mkultra_cmd_text("cum", "success_master", list("target" = humanoid)) || "<span class='notice'><i>You command [humanoid] to finish, and they obey.</i></span>"
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, msg_pet), 5)
			to_chat(user, msg_master)
		else
			mkultra_debug("cum failed on [humanoid] by [user]")
			var/msg_fail = mkultra_cmd_text("cum", "fail_pet") || "<span class='warning'>You try to obey, but your body refuses to climax.</span>"
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, msg_fail), 5)

	return TRUE


/proc/process_mkultra_command_selfcall(message, mob/living/user, list/listeners, power_multiplier)
	// Lewd-only speech self-name enforcement: immersive phrasing like "call yourself pet" (commas allowed).
	var/lowered = lowertext(message)
	var/list/off_patterns = mkultra_cmd_patterns("selfcall_off")
	if(mkultra_command_matches(message, lowered, off_patterns))
		// Let the off handler consume it instead of binding the stop phrase as a name.
		return FALSE
	var/list/selfcall_patterns = mkultra_flatten_patterns(mkultra_cmd_patterns("selfcall"))
	var/prefix_match = null
	for(var/pfx in selfcall_patterns)
		if(!istext(pfx))
			continue
		if(findtext(lowered, lowertext("[pfx]")))
			prefix_match = pfx
			break
	if(!prefix_match)
		return FALSE

	var/raw_names = trim(copytext(message, length(prefix_match) + 1))
	if(!raw_names)
		mkultra_debug("selfcall skip: empty name list")
		return FALSE
	var/list/name_list = list()
	for(var/part in splittext(raw_names, ","))
		var/clean = trim(part)
		// Drop trailing punctuation like "." so we don't store literal punctuation.
		while(length(clean))
			var/last_char = copytext(clean, -1)
			if(last_char == "." || last_char == "," || last_char == "!" || last_char == "?")
				clean = copytext(clean, 1, length(clean))
				continue
			break
		if(length(clean))
			name_list += clean
	if(!name_list.len)
		mkultra_debug("selfcall skip: no parsed names from '[raw_names]'")
		return FALSE

	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			mkultra_debug("selfcall skip [enthrall_victim]: not human")
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || !enthrall_chem.lewd || enthrall_chem.phase < 2)
			mkultra_debug("selfcall skip [humanoid]: invalid enthrall (lewd=[enthrall_chem?.lewd] phase=[enthrall_chem?.phase])")
			continue
		if(enthrall_chem.enthrall_mob != user)
			mkultra_debug("selfcall skip [humanoid]: enthraller mismatch (has=[enthrall_chem.enthrall_mob] wanted=[user])")
			continue

		mkultra_apply_selfcall(humanoid, name_list)
		mkultra_add_cooldown(enthrall_chem, 3)
		var/listing = name_list.Join(", ")
		var/msg_pet = mkultra_cmd_text("selfcall", "pet", list("names" = listing)) || "<span class='notice'>Your self-reference is confined to: [listing].</span>"
		var/msg_master = mkultra_cmd_text("selfcall", "master", list("target" = humanoid, "names" = listing)) || "<span class='notice'><i>You bind [humanoid]'s self-name to: [listing].</i></span>"
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, msg_pet), 5)
		to_chat(user, msg_master)

	return TRUE


/proc/process_mkultra_command_emote(message, mob/living/user, list/listeners, power_multiplier)
	// Lewd-only emote command: "<emote> for me". Uses the standard emote datum list.
	var/lowered = lowertext(message)
	var/list/emote_patterns = mkultra_flatten_patterns(mkultra_cmd_patterns("emote"))
	if(!mkultra_command_matches(message, lowered, emote_patterns))
		return FALSE
	var/marker = " for me" // first pattern
	var/idx = findtext(lowered, marker)
	if(!idx)
		return FALSE
	var/emote_text = trim(copytext(message, 1, idx))
	if(!length(emote_text))
		return FALSE
	mkultra_debug("emote command '[message]' matched as [emote_text] by [user]")

	var/emote_key = LOWER_TEXT(emote_text)
	if(!(emote_key in GLOB.emote_list))
		return FALSE

	var/handled = FALSE
	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			mkultra_debug("emote skip [enthrall_victim]: not human")
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || !enthrall_chem.lewd || enthrall_chem.phase < 2)
			mkultra_debug("emote skip [humanoid]: invalid enthrall (lewd=[enthrall_chem?.lewd] phase=[enthrall_chem?.phase])")
			continue

		humanoid.emote(emote_key, null, null, FALSE, TRUE, FALSE)
		mkultra_add_cooldown(enthrall_chem, 6)
		mkultra_debug("emote [emote_key] applied to [humanoid] by [user]")
		var/msg_pet = mkultra_cmd_text("emote", "pet", list("owner" = enthrall_chem.enthrall_gender)) || "<span class='love'>You perform a trick on command for [enthrall_chem.enthrall_gender].</span>"
		var/msg_master = mkultra_cmd_text("emote", "master", list("target" = humanoid)) || "<span class='notice'><i>[humanoid] performs a trick on command.</i></span>"
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, msg_pet), 5)
		to_chat(user, msg_master)
		handled = TRUE

	return handled


/proc/process_mkultra_command_strip_slot(message, mob/living/user, list/listeners, power_multiplier)
	// Targeted strip: "strip <slot>". Always consume once matched to prevent base strip double fire.
	var/lowered = lowertext(message)
	var/list/strip_patterns = mkultra_cmd_patterns("strip_slot")
	if(!mkultra_command_matches(message, lowered, strip_patterns))
		return FALSE
	var/prefix = "strip "
	if(!findtext(lowered, prefix))
		return FALSE
	var/slot_text = trim(copytext(message, length(prefix) + 1))
	var/strip_all = FALSE
	if(!slot_text)
		strip_all = TRUE
	mkultra_debug("strip command '[message]' raw slot '[slot_text]' from [user]")
	// Drop simple articles.
	for(var/article in list("your ", "my ", "the "))
		slot_text = replacetext(slot_text, article, "")
	// Trim trailing punctuation like "." or "!" so "strip all." works.
	while(length(slot_text) && findtext(".!,?", copytext(slot_text, -1)))
		slot_text = copytext(slot_text, 1, length(slot_text))
	slot_text = trim(slot_text)
	var/slot_lower = lowertext(slot_text)
	if(slot_lower in list("all", "everything", "naked", "nude", "bare"))
		strip_all = TRUE

	var/slot_id = strip_all ? null : mkultra_resolve_strip_slot(slot_text)
	if(!strip_all && !slot_id)
		mkultra_debug("strip slot resolution failed for '[slot_text]'")
		return TRUE

	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			mkultra_debug("strip skip [enthrall_victim]: not human")
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || !enthrall_chem.lewd || enthrall_chem.phase < 2)
			mkultra_debug("strip skip [humanoid]: invalid enthrall (lewd=[enthrall_chem?.lewd] phase=[enthrall_chem?.phase])")
			continue
		if(enthrall_chem.enthrall_mob != user)
			mkultra_debug("strip skip [humanoid]: enthraller mismatch (has=[enthrall_chem.enthrall_mob] wanted=[user])")
			continue

		if(strip_all)
			var/removed = mkultra_strip_all(humanoid)
			if(removed)
				mkultra_add_cooldown(enthrall_chem, 5)
				to_chat(user, "<span class='notice'><i>You order [humanoid] to get naked, and they hurriedly comply.</i></span>")
				addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, "<span class='love'>You strip down completely for [enthrall_chem.enthrall_gender].</span>"), 5)
			else
				mkultra_debug("strip all found nothing to remove on [humanoid]")
			continue

		var/obj/item/to_drop = mkultra_strip_item_for_slot(humanoid, slot_id)
		if(!to_drop)
			mkultra_debug("strip found nothing in [mkultra_slot_name(slot_id)] on [humanoid]")
			continue
		mkultra_debug("strip dropping [to_drop] from [humanoid] slot [mkultra_slot_name(slot_id)]")
		mkultra_add_cooldown(enthrall_chem, 4)
		to_chat(user, "<span class='notice'><i>You command [humanoid] to strip [mkultra_slot_name(slot_id)], and they comply.</i></span>")
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, "<span class='love'>You obediently remove your [mkultra_slot_name(slot_id)].</span>"), 5)

	// Always consume so base handler doesn't also strip.
	return TRUE

/proc/process_mkultra_command_lust_up(message, mob/living/user, list/listeners, power_multiplier)
	// Lewd-only arousal increase.
	var/lowered = lowertext(message)
	var/list/lust_up_patterns = mkultra_cmd_patterns("lust_up")
	if(!mkultra_command_matches(message, lowered, lust_up_patterns))
		return FALSE
	mkultra_debug("lust up command from [user]")
	var/lust_delta = round(AROUSAL_LIMIT * 0.3)

	var/handled = FALSE
	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			mkultra_debug("lust up skip [enthrall_victim]: not human")
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || !enthrall_chem.lewd || enthrall_chem.phase < 2)
			mkultra_debug("lust up skip [humanoid]: invalid enthrall (lewd=[enthrall_chem?.lewd] phase=[enthrall_chem?.phase])")
			continue
		if(enthrall_chem.enthrall_mob != user)
			mkultra_debug("lust up skip [humanoid]: enthraller mismatch (has=[enthrall_chem.enthrall_mob] wanted=[user])")
			continue

		humanoid.adjust_arousal(lust_delta)
		mkultra_add_cooldown(enthrall_chem, 3)
		mkultra_debug("lust up applied to [humanoid] (+[lust_delta])")
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, "<span class='love'>Heat floods your body at [enthrall_chem.enthrall_gender]'s command.</span>"), 5)
		to_chat(user, "<span class='notice'><i>[humanoid] flushes as you stoke their lust.</i></span>")
		handled = TRUE

	return handled

/proc/process_mkultra_command_lust_down(message, mob/living/user, list/listeners, power_multiplier)
	// Lewd-only arousal decrease.
	var/lowered = lowertext(message)
	var/list/lust_down_patterns = mkultra_cmd_patterns("lust_down")
	if(!mkultra_command_matches(message, lowered, lust_down_patterns))
		return FALSE
	mkultra_debug("lust down command from [user]")
	var/lust_delta = round(AROUSAL_LIMIT * 0.3)

	var/handled = FALSE
	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			mkultra_debug("lust down skip [enthrall_victim]: not human")
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || !enthrall_chem.lewd || enthrall_chem.phase < 2)
			mkultra_debug("lust down skip [humanoid]: invalid enthrall (lewd=[enthrall_chem?.lewd] phase=[enthrall_chem?.phase])")
			continue
		if(enthrall_chem.enthrall_mob != user)
			mkultra_debug("lust down skip [humanoid]: enthraller mismatch (has=[enthrall_chem.enthrall_mob] wanted=[user])")
			continue

		humanoid.adjust_arousal(-lust_delta)
		mkultra_add_cooldown(enthrall_chem, 3)
		mkultra_debug("lust down applied to [humanoid] (-[lust_delta])")
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, "<span class='notice'>You force yourself to cool down at [enthrall_chem.enthrall_gender]'s order.</span>"), 5)
		to_chat(user, "<span class='notice'><i>[humanoid] reins their arousal back under your command.</i></span>")
		handled = TRUE

	return handled

/proc/process_mkultra_command_selfcall_off(message, mob/living/user, list/listeners, power_multiplier)
	// Disable selfcall enforcement: immersive stop phrasing.
	var/lowered = lowertext(message)
	var/list/off_patterns = mkultra_cmd_patterns("selfcall_off")
	if(!mkultra_command_matches(message, lowered, off_patterns))
		return FALSE

	var/handled = FALSE
	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			mkultra_debug("selfcall off skip [enthrall_victim]: not human")
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || !enthrall_chem.lewd || enthrall_chem.phase < 2)
			mkultra_debug("selfcall off skip [humanoid]: invalid enthrall (lewd=[enthrall_chem?.lewd] phase=[enthrall_chem?.phase])")
			continue
		if(enthrall_chem.enthrall_mob != user)
			mkultra_debug("selfcall off skip [humanoid]: enthraller mismatch (has=[enthrall_chem.enthrall_mob] wanted=[user])")
			continue

		if(humanoid in mkultra_selfcall_states)
			mkultra_clear_selfcall(humanoid)
			mkultra_add_cooldown(enthrall_chem, 2)
			var/msg_pet = mkultra_cmd_text("selfcall_off", "pet") || "<span class='notice'>Your self-reference restrictions dissolve.</span>"
			var/msg_master = mkultra_cmd_text("selfcall_off", "master", list("target" = humanoid)) || "<span class='notice'><i>You release [humanoid]'s self-name binding.</i></span>"
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, msg_pet), 5)
			to_chat(user, msg_master)
			handled = TRUE

	return handled

/proc/process_mkultra_command_follow(message, mob/living/user, list/listeners, power_multiplier)
	// Lewd-only follow/stop-follow handler. "follow me" starts, "stop following" ends.
	var/lowered = lowertext(message)
	var/list/patterns = mkultra_cmd_patterns("follow")
	var/match_idx = mkultra_command_match_index(message, lowered, patterns)
	if(!match_idx)
		return FALSE
	var/handled = FALSE
	var/is_stop = (match_idx == 1)
	if(is_stop)
		mkultra_debug("follow stop command from [user]")
		for(var/enthrall_victim in listeners)
			if(!ishuman(enthrall_victim))
				mkultra_debug("follow stop skip [enthrall_victim]: not human")
				continue
			var/mob/living/carbon/human/humanoid = enthrall_victim
			var/msg_stop = mkultra_cmd_text("follow", "stop_pet") || "<span class='notice'>You are ordered to stop following.</span>"
			if(mkultra_stop_follow(humanoid, msg_stop, user))
				mkultra_debug("follow stop success on [humanoid]")
				handled = TRUE
		return handled

	mkultra_debug("follow start command from [user]")

	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			mkultra_debug("follow start skip [enthrall_victim]: not human")
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || !enthrall_chem.lewd || enthrall_chem.phase < 2)
			mkultra_debug("follow start skip [humanoid]: invalid enthrall (lewd=[enthrall_chem?.lewd] phase=[enthrall_chem?.phase])")
			continue
		if(enthrall_chem.enthrall_mob != user)
			mkultra_debug("follow start skip [humanoid]: enthraller mismatch (has=[enthrall_chem.enthrall_mob] wanted=[user])")
			continue

		mkultra_start_follow(humanoid, user, enthrall_chem)
		enthrall_chem.cooldown += 4
		var/msg_master = mkultra_cmd_text("follow", "start_master", list("target" = humanoid)) || "<span class='notice'><i>[humanoid] begins to heel at your command.</i></span>"
		to_chat(user, msg_master)
		handled = TRUE

	return handled

// Allow dom to set a custom title the pet uses for them.
/proc/process_mkultra_command_set_master_title(message, mob/living/user, list/listeners, power_multiplier)
	var/lowered = lowertext(message)
	var/list/phrases = mkultra_flatten_patterns(mkultra_cmd_patterns("master_title"))
	if(!phrases || !phrases.len)
		return FALSE
	var/phrase_hit = null
	var/idx = 0
	for(var/phrase in phrases)
		if(!istext(phrase))
			continue
		idx = findtext(lowered, lowertext("[phrase]"))
		if(idx)
			phrase_hit = phrase
			break
	if(!phrase_hit)
		return FALSE

	var/new_title = trim(copytext(message, idx + length(phrase_hit)))
	if(!length(new_title))
		return FALSE
	new_title = replacetext(new_title, "<", "")
	new_title = replacetext(new_title, ">", "")
	new_title = replacetext(new_title, "\[", "")
	new_title = replacetext(new_title, "\]", "")
	new_title = trim(new_title)
	if(!length(new_title))
		return FALSE
	mkultra_debug("set master title to '[new_title]' by [user]")

	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem)
			enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall/pet_chip)
		if(!enthrall_chem)
			enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall/pet_chip/mk2)
		if(!enthrall_chem || enthrall_chem.enthrall_mob != user)
			continue
		mkultra_apply_master_title(humanoid, user, new_title)
		var/msg_pet = mkultra_cmd_text("master_title", "pet", list("title" = new_title)) || "<span class='notice'>You will refer to your owner as '[new_title]'.</span>"
		var/msg_master = mkultra_cmd_text("master_title", "master", list("target" = humanoid, "title" = new_title)) || "<span class='notice'><i>[humanoid] will call you '[new_title]'.</i></span>"
		to_chat(humanoid, msg_pet)
		to_chat(user, msg_master)
	return TRUE

// Sets the enthrall_gender descriptor (lewd honorific) without altering speech replacement.
/proc/process_mkultra_command_think_of_me(message, mob/living/user, list/listeners, power_multiplier)
	var/lowered = lowertext(message)
	var/phrase = "think of me as "
	var/idx = findtext(lowered, phrase)
	if(!idx)
		return FALSE

	var/new_title = trim(copytext(message, idx + length(phrase)))
	if(!length(new_title))
		return FALSE
	new_title = replacetext(new_title, "<", "")
	new_title = replacetext(new_title, ">", "")
	new_title = replacetext(new_title, "\[", "")
	new_title = replacetext(new_title, "\]", "")
	new_title = trim(new_title)
	if(!length(new_title))
		return FALSE
	mkultra_debug("think of me matched '[new_title]' by [user]")

	var/handled = FALSE
	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem)
			enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall/pet_chip)
		if(!enthrall_chem)
			enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall/pet_chip/mk2)
		if(!enthrall_chem || enthrall_chem.enthrall_mob != user)
			continue

		enthrall_chem.enthrall_gender = new_title
		mkultra_add_cooldown(enthrall_chem, 1)
		var/msg_pet = mkultra_cmd_text("think_of_me", "pet", list("title" = new_title)) || "<span class='notice'>You now think of your owner as '[new_title]'.</span>"
		var/msg_master = mkultra_cmd_text("think_of_me", "master", list("target" = humanoid, "title" = new_title)) || "<span class='notice'><i>[humanoid] will flavor their devotion as '[new_title]'.</i></span>"
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, msg_pet), 5)
		to_chat(user, msg_master)
		handled = TRUE
	return handled

/proc/mkultra_start_follow(mob/living/carbon/human/humanoid, mob/living/master, datum/status_effect/chem/enthrall/enthrall_chem)
	if(QDELETED(humanoid) || QDELETED(master))
		return

	mkultra_stop_follow(humanoid)
	mkultra_follow_states[humanoid] = list(
		"master" = WEAKREF(master),
		"enthrall_chem" = WEAKREF(enthrall_chem),
	)
	mkultra_debug("follow start: [humanoid] now following [master]")
	mkultra_signal_handler.RegisterSignal(humanoid, COMSIG_LIVING_RESIST, TYPE_PROC_REF(/datum/mkultra_signal_handler, follow_on_resist))
	mkultra_signal_handler.RegisterSignal(humanoid, COMSIG_QDELETING, TYPE_PROC_REF(/datum/mkultra_signal_handler, follow_on_delete))
	addtimer(CALLBACK(GLOBAL_PROC, .proc/mkultra_follow_tick, humanoid), 1 SECONDS)

/proc/mkultra_stop_follow(mob/living/carbon/human/humanoid, reason = null, mob/living/master)
	var/list/state = mkultra_follow_states[humanoid]
	if(!state)
		return FALSE

	mkultra_signal_handler.UnregisterSignal(humanoid, list(COMSIG_LIVING_RESIST, COMSIG_QDELETING))
	GLOB.move_manager.stop_looping(humanoid)
	mkultra_follow_states -= humanoid
	if(reason)
		mkultra_debug("follow stop: [humanoid] reason='[reason]' master=[master]")
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, reason), 2)
	if(master)
		var/msg_master = mkultra_cmd_text("follow", "stop_master", list("target" = humanoid)) || "<span class='notice'><i>[humanoid] stops following.</i></span>"
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, master, msg_master), 2)
	return TRUE

/datum/mkultra_signal_handler/proc/follow_on_resist(datum/source, mob/living/resister)
	SIGNAL_HANDLER
	mkultra_stop_follow(resister, "<span class='warning'>You shake off the urge to heel.</span>")

/datum/mkultra_signal_handler/proc/follow_on_delete(datum/source)
	SIGNAL_HANDLER
	mkultra_stop_follow(source)

/proc/mkultra_follow_tick(mob/living/carbon/human/humanoid)
	var/list/state = mkultra_follow_states[humanoid]
	if(!state)
		return

	var/datum/weakref/master_ref = state["master"]
	var/mob/living/master = master_ref?.resolve()
	var/datum/weakref/enthrall_ref = state["enthrall_chem"]
	var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_ref?.resolve()
	if(QDELETED(humanoid) || QDELETED(master) || !enthrall_chem)
		mkultra_stop_follow(humanoid)
		return
	if(enthrall_chem.enthrall_mob != master || !enthrall_chem.lewd || enthrall_chem.phase < 2)
		mkultra_stop_follow(humanoid, "<span class='warning'>Your connection to your handler slips.</span>")
		return
	if(humanoid.incapacitated || humanoid.buckled || humanoid.anchored)
		mkultra_stop_follow(humanoid, "<span class='warning'>You cannot follow right now.</span>", master)
		return
	if(!(master in view(8, humanoid)))
		mkultra_stop_follow(humanoid, "<span class='warning'>You lose sight of your [enthrall_chem.enthrall_gender].</span>", master)
		return

	var/dist = get_dist(humanoid, master)
	if(dist > 1)
		if(!GLOB.move_manager.move_to(humanoid, master, 1, 1))
			step_towards(humanoid, master)

	mkultra_add_cooldown(enthrall_chem, 4)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/mkultra_follow_tick, humanoid), 1 SECONDS)

/proc/mkultra_apply_selfcall(mob/living/carbon/human/humanoid, list/name_list)
	// Clear existing bindings first.
	mkultra_clear_selfcall(humanoid)
	mkultra_selfcall_states[humanoid] = list(
		"names" = name_list.Copy(),
		"idx" = 1,
	)
	mkultra_debug("selfcall set on [humanoid]: [name_list.Join(", ")]")
	mkultra_signal_handler.RegisterSignal(humanoid, COMSIG_MOB_SAY, TYPE_PROC_REF(/datum/mkultra_signal_handler, selfcall_on_say))
	mkultra_signal_handler.RegisterSignal(humanoid, COMSIG_QDELETING, TYPE_PROC_REF(/datum/mkultra_signal_handler, selfcall_on_delete))

/proc/mkultra_clear_selfcall(mob/living/carbon/human/humanoid)
	if(!(humanoid in mkultra_selfcall_states))
		return
	mkultra_signal_handler.UnregisterSignal(humanoid, list(COMSIG_MOB_SAY, COMSIG_QDELETING))
	mkultra_selfcall_states -= humanoid
	mkultra_debug("selfcall cleared on [humanoid]")

/datum/mkultra_signal_handler/proc/selfcall_on_delete(datum/source)
	SIGNAL_HANDLER
	mkultra_clear_selfcall(source)

/datum/mkultra_signal_handler/proc/selfcall_on_say(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/humanoid = source
	var/list/state = mkultra_selfcall_states[humanoid]
	if(!state)
		return
	var/list/name_list = state["names"]
	var/idx = state["idx"] || 1
	if(!name_list || !name_list.len)
		return

	var/message = speech_args[SPEECH_MESSAGE]
	if(!istext(message))
		return

	var/main_name = name_list[idx]
	// Rotate to the next name for variety.
	idx = (idx % name_list.len) + 1
	state["idx"] = idx

	var/clean = message
	var/matched = FALSE

	// Pronoun replacements.
	var/regex/pronouns = regex("\\b(I|I'm|Im|I am|me|my|mine|myself)\\b", "gi")
	if(pronouns.Find(clean))
		clean = replacetext(clean, regex("\\b(I|I'm|Im|I am)\\b", "gi"), "[main_name] is")
		clean = replacetext(clean, regex("\\bmyself\\b", "gi"), main_name)
		clean = replacetext(clean, regex("\\bme\\b", "gi"), main_name)
		clean = replacetext(clean, regex("\\bmy\\b", "gi"), "[main_name]'s")
		clean = replacetext(clean, regex("\\bmine\\b", "gi"), "[main_name]'s")
		matched = TRUE

	// Name replacements: full, first, last.
	var/full_name = humanoid.real_name
	var/first = first_name(full_name)
	var/last = (length(full_name) ? last_name(full_name) : null)
	if(length(full_name) && findtext(clean, full_name, 1, 0))
		clean = replacetext(clean, regex("\\b[full_name]\\b", "gi"), main_name)
		matched = TRUE
	if(length(first) && findtext(clean, first, 1, 0))
		clean = replacetext(clean, regex("\\b[first]\\b", "gi"), main_name)
		matched = TRUE
	if(length(last) && findtext(clean, last, 1, 0))
		clean = replacetext(clean, regex("\\b[last]\\b", "gi"), main_name)
		matched = TRUE

	if(!matched)
		return

	speech_args[SPEECH_MESSAGE] = clean
	mkultra_debug("selfcall rewrite on [humanoid]: '[message]' -> '[clean]'")

/proc/mkultra_apply_master_title(mob/living/carbon/human/humanoid, mob/living/master, title)
	mkultra_clear_master_title(humanoid)
	mkultra_master_title_states[humanoid] = list(
		"master" = WEAKREF(master),
		"title" = title,
	)
	mkultra_signal_handler.RegisterSignal(humanoid, COMSIG_MOB_SAY, TYPE_PROC_REF(/datum/mkultra_signal_handler, master_title_on_say))
	mkultra_signal_handler.RegisterSignal(humanoid, COMSIG_QDELETING, TYPE_PROC_REF(/datum/mkultra_signal_handler, master_title_on_delete))
	mkultra_debug("master title set on [humanoid]: '[title]' for [master]")

/proc/mkultra_clear_master_title(mob/living/carbon/human/humanoid)
	if(!(humanoid in mkultra_master_title_states))
		return
	mkultra_signal_handler.UnregisterSignal(humanoid, list(COMSIG_MOB_SAY, COMSIG_QDELETING))
	mkultra_master_title_states -= humanoid
	mkultra_debug("master title cleared on [humanoid]")

/datum/mkultra_signal_handler/proc/master_title_on_delete(datum/source)
	SIGNAL_HANDLER
	mkultra_clear_master_title(source)

/datum/mkultra_signal_handler/proc/master_title_on_say(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/humanoid = source
	var/list/state = mkultra_master_title_states[humanoid]
	if(!state)
		return

	var/datum/weakref/master_ref = state["master"]
	var/mob/living/master = master_ref?.resolve()
	if(!master)
		mkultra_clear_master_title(humanoid)
		return

	var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall/pet_chip/mk2)
	if(!enthrall_chem)
		enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall/pet_chip)
	if(!enthrall_chem)
		enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
	if(!enthrall_chem || enthrall_chem.enthrall_mob != master)
		mkultra_clear_master_title(humanoid)
		return

	var/message = speech_args[SPEECH_MESSAGE]
	if(!istext(message) || !length(message))
		return

	var/title = state["title"]
	if(!length(title))
		return

	var/clean = message
	var/matched = FALSE
	var/full_name = master.real_name
	var/first = first_name(full_name)
	var/last = last_name(full_name)
	var/list/names = list()
	if(length(full_name))
		names += full_name
	if(length(first))
		names += first
	if(length(last))
		names += last
	if(length(full_name))
		for(var/part in splittext(full_name, " "))
			if(length(part))
				names += part

	for(var/name_text in names)
		if(!length(name_text))
			continue
		var/escaped = mkultra_regex_escape(name_text)
		if(!length(escaped))
			continue
		var/regex/r = regex("\\b[escaped]\\b", "gi")
		if(r.Find(clean))
			clean = replacetext(clean, r, title)
			matched = TRUE

	if(!matched)
		return

	speech_args[SPEECH_MESSAGE] = clean
	mkultra_debug("master title rewrite [humanoid]: '[message]' -> '[clean]'")

/proc/mkultra_regex_escape(text)
	if(!istext(text))
		return ""
	var/escaped = replacetext(text, "\\", "\\\\")
	escaped = replacetext(escaped, ".", "\\.")
	escaped = replacetext(escaped, "+", "\\+")
	escaped = replacetext(escaped, "*", "\\*")
	escaped = replacetext(escaped, "?", "\\?")
	escaped = replacetext(escaped, "(", "\\(")
	escaped = replacetext(escaped, ")", "\\)")
	escaped = replacetext(escaped, "^", "\\^")
	escaped = replacetext(escaped, "$", "\\$")
	escaped = replacetext(escaped, "{", "\\{")
	escaped = replacetext(escaped, "}", "\\}")
	escaped = replacetext(escaped, "|", "\\|")
	return escaped

/proc/mkultra_resolve_strip_slot(slot_text)
	var/lowered = LOWER_TEXT(slot_text)
	if(lowered in mkultra_strip_slot_lookup)
		return mkultra_strip_slot_lookup[lowered]

	// Fallback: search for a keyword contained in the phrase.
	for(var/key in mkultra_strip_slot_lookup)
		if(findtext(lowered, key))
			return mkultra_strip_slot_lookup[key]
	return null

/proc/mkultra_slot_name(slot_id)
	switch(slot_id)
		if(ITEM_SLOT_HEAD)
			return "headgear"
		if(ITEM_SLOT_MASK)
			return "mask"
		if(ITEM_SLOT_EYES)
			return "eyewear"
		if(ITEM_SLOT_EARS, ITEM_SLOT_EARS_LEFT, ITEM_SLOT_EARS_RIGHT)
			return "ear slot"
		if(ITEM_SLOT_NECK)
			return "neckwear"
		if(ITEM_SLOT_OCLOTHING)
			return "outer suit"
		if(ITEM_SLOT_ICLOTHING)
			return "uniform"
		if(ITEM_SLOT_GLOVES)
			return "gloves"
		if(ITEM_SLOT_FEET)
			return "shoes"
		if(ITEM_SLOT_BELT)
			return "belt"
		if(ITEM_SLOT_BACK)
			return "back item"
		if(ITEM_SLOT_ID)
			return "ID"
		if(ITEM_SLOT_SUITSTORE)
			return "suit storage"
		if(ITEM_SLOT_LPOCKET)
			return "left pocket"
		if(ITEM_SLOT_RPOCKET)
			return "right pocket"
		if(ITEM_SLOT_POCKETS)
			return "pockets"
	return "gear"

/proc/mkultra_strip_item_for_slot(mob/living/carbon/human/humanoid, slot_id)
	var/obj/item/slot_item
	// Handle combined pockets specially so both pockets are tried.
	if(slot_id == ITEM_SLOT_POCKETS)
		for(var/slot_option in list(ITEM_SLOT_LPOCKET, ITEM_SLOT_RPOCKET))
			slot_item = humanoid.get_item_by_slot(slot_option)
			if(slot_item)
				break
	else
		slot_item = humanoid.get_item_by_slot(slot_id)

	if(!slot_item)
		return null
	if(!humanoid.canUnEquip(slot_item, FALSE))
		return null
	if(!humanoid.dropItemToGround(slot_item))
		return null
	return slot_item

/proc/mkultra_strip_all(mob/living/carbon/human/humanoid)
	mkultra_debug("strip_all start [humanoid] contents=[length(humanoid.get_contents())]")
	var/removed = 0
	for(var/obj/item/W in humanoid.get_contents())
		if(!ismob(W.loc))
			continue
		if(humanoid.is_holding(W))
			continue
		if(W.breakouttime)
			continue
		if(!humanoid.canUnEquip(W, FALSE))
			continue
		if(humanoid.dropItemToGround(W, TRUE))
			removed++
	mkultra_debug("strip_all removed=[removed] for [humanoid]")
	return removed

// Helper to fetch (without dropping) the item in a given slot.
/proc/mkultra_get_item_for_slot(mob/living/carbon/human/humanoid, slot_id)
	if(slot_id == ITEM_SLOT_POCKETS)
		var/obj/item/pocket_item = humanoid.get_item_by_slot(ITEM_SLOT_LPOCKET) || humanoid.get_item_by_slot(ITEM_SLOT_RPOCKET)
		return pocket_item
	return humanoid.get_item_by_slot(slot_id)

// Slot lock helpers: prevents the pet from unequipping specific items. Other players can still force-drop if they bypass TRAIT_NODROP.
/proc/mkultra_lock_slot_item(mob/living/carbon/human/humanoid, obj/item/I, slot_label)
	if(!humanoid || !I)
		return FALSE
	// Clear any previous lock so we don't double-register signals.
	mkultra_unlock_slot_item(I, silent = TRUE)
	ADD_TRAIT(I, TRAIT_NODROP, "mkultra_slot_lock")
	var/list/locked = mkultra_slot_locks[humanoid]
	if(!islist(locked))
		locked = list()
	mkultra_slot_locks[humanoid] = locked
	locked[I] = slot_label
	mkultra_slot_lock_items[I] = humanoid
	mkultra_signal_handler.RegisterSignal(I, COMSIG_ITEM_POST_UNEQUIP, TYPE_PROC_REF(/datum/mkultra_signal_handler, slot_lock_on_item_unequip))
	mkultra_signal_handler.RegisterSignal(I, COMSIG_QDELETING, TYPE_PROC_REF(/datum/mkultra_signal_handler, slot_lock_on_item_delete))
	mkultra_signal_handler.RegisterSignal(humanoid, COMSIG_QDELETING, TYPE_PROC_REF(/datum/mkultra_signal_handler, slot_lock_on_owner_delete))
	return TRUE

/proc/mkultra_unlock_slot_item(obj/item/I, silent = FALSE)
	if(!I)
		return FALSE
	var/mob/living/carbon/human/humanoid = mkultra_slot_lock_items[I]
	if(humanoid)
		var/list/locked = mkultra_slot_locks[humanoid]
		if(islist(locked))
			locked -= I
			if(!locked.len)
				mkultra_slot_locks -= humanoid
				mkultra_signal_handler.UnregisterSignal(humanoid, COMSIG_QDELETING)
	mkultra_slot_lock_items -= I
	REMOVE_TRAIT(I, TRAIT_NODROP, "mkultra_slot_lock")
	mkultra_signal_handler.UnregisterSignal(I, list(COMSIG_ITEM_POST_UNEQUIP, COMSIG_QDELETING))
	return TRUE
//SPLURT ADDITION END

//SPLURT EXTENSIONS START


/proc/process_mkultra_command_wear(message, mob/living/user, list/listeners, power_multiplier)
	var/lowered = lowertext(message)
	if(!findtext(lowered, "wear"))
		return FALSE

	var/slot_text = null
	var/idx_on = findtext(lowered, "wear this on ")
	if(idx_on)
		slot_text = trim(copytext(message, idx_on + length("wear this on ")))
	else
		var/idx_wear = findtext(lowered, "wear ")
		if(idx_wear)
			slot_text = trim(copytext(message, idx_wear + length("wear ")))

	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || !enthrall_chem.lewd || enthrall_chem.phase < 2 || enthrall_chem.enthrall_mob != user)
			continue

		if(get_dist(humanoid, user) > 1)
			mkultra_debug("wear fail: [humanoid] not adjacent to [user]")
			to_chat(user, "<span class='warning'><i>[humanoid] needs to be right next to you to take it.</i></span>")
			return TRUE

		var/success = mkultra_do_wear(humanoid, user, slot_text)
		if(success)
			mkultra_add_cooldown(enthrall_chem, 4)
			var/msg_master = mkultra_cmd_text("wear", "master_success", list("target" = humanoid)) || "<span class='notice'><i>[humanoid] takes your item and dresses as ordered.</i></span>"
			to_chat(user, msg_master)
		else
			var/msg_fail = mkultra_cmd_text("wear", "master_fail", list("target" = humanoid)) || "<span class='warning'><i>[humanoid] fumbles and apologizes; they couldn't wear it.</i></span>"
			to_chat(user, msg_fail)
		return TRUE

	return FALSE

/proc/process_mkultra_command_cum_lock(message, mob/living/user, list/listeners, power_multiplier)
	var/lowered = lowertext(message)
	var/list/patterns = mkultra_cmd_patterns("cum_lock")
	var/match_idx = mkultra_command_match_index(message, lowered, patterns)
	var/apply_lock = (match_idx == 1)
	var/remove_lock = (match_idx == 2)
	if(!apply_lock && !remove_lock)
		return FALSE

	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || !enthrall_chem.lewd || enthrall_chem.phase < 2 || enthrall_chem.enthrall_mob != user)
			continue

		if(apply_lock)
			mkultra_set_cum_lock(humanoid, TRUE)
			mkultra_add_cooldown(enthrall_chem, 2)
			var/msg_pet = mkultra_cmd_text("cum_lock", "lock_pet") || "<span class='warning'>Your release is forbidden until granted.</span>"
			var/msg_master = mkultra_cmd_text("cum_lock", "lock_master", list("target" = humanoid)) || "<span class='notice'><i>You lock [humanoid]'s climax.</i></span>"
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, msg_pet), 5)
			to_chat(user, msg_master)
		else if(remove_lock)
			mkultra_set_cum_lock(humanoid, FALSE)
			mkultra_add_cooldown(enthrall_chem, 2)
			var/msg_pet_unlock = mkultra_cmd_text("cum_lock", "unlock_pet") || "<span class='love'>Permission granted - you may climax again.</span>"
			var/msg_master_unlock = mkultra_cmd_text("cum_lock", "unlock_master", list("target" = humanoid)) || "<span class='notice'><i>You lift the climax lock on [humanoid].</i></span>"
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, msg_pet_unlock), 5)
			to_chat(user, msg_master_unlock)
	return TRUE

/proc/process_mkultra_command_arousal_lock(message, mob/living/user, list/listeners, power_multiplier)
	// Robust matching for common phrasing so we actually catch the order (no regex to keep DM happy).
	var/lowered = lowertext(message)
	var/mode = null
	var/list/patterns = mkultra_cmd_patterns("arousal_lock")
	var/match_idx = mkultra_command_match_index(message, lowered, patterns)
	if(match_idx == 1)
		mode = "hard"
	else if(match_idx == 2)
		mode = "limp"
	else if(match_idx == 3)
		mode = "clear"
	else
		return FALSE

	mkultra_debug("arousal command matched mode=[mode] by [user] -> [listeners.len] listeners; msg='[message]'")

	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			mkultra_debug("arousal lock skip [enthrall_victim]: not human")
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || !enthrall_chem.lewd || enthrall_chem.phase < 2 || enthrall_chem.enthrall_mob != user)
			mkultra_debug("arousal lock skip [humanoid]: gate fail (lewd=[enthrall_chem?.lewd] phase=[enthrall_chem?.phase] master_match=[enthrall_chem?.enthrall_mob == user])")
			continue
		mkultra_debug("arousal lock apply start [humanoid] mode=[mode] arousal=[humanoid.arousal] status=[humanoid.arousal_status]")
		if(mode == "clear")
			mkultra_clear_arousal_lock(humanoid)
			mkultra_apply_arousal_lock_now(humanoid, clear_only = TRUE)
			var/msg_master_release = mkultra_cmd_text("arousal_lock", "release_master", list("target" = humanoid)) || "<span class='notice'><i>[humanoid]'s arousal lock released.</i></span>"
			var/msg_pet_release = mkultra_cmd_text("arousal_lock", "release_pet") || "<span class='notice'>Your forced arousal fades.</span>"
			to_chat(user, msg_master_release)
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, msg_pet_release), 5)
		else
			mkultra_set_arousal_lock(humanoid, mode)
			var/msg_master_lock = mkultra_cmd_text("arousal_lock", "lock_master", list("target" = humanoid, "mode" = mode)) || "<span class='notice'><i>You force [humanoid] to stay [mode].</i></span>"
			var/msg_pet_lock = mkultra_cmd_text("arousal_lock", "lock_pet", list("mode" = mode)) || "<span class='love'>Your body is locked [mode] until released.</span>"
			to_chat(user, msg_master_lock)
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, msg_pet_lock), 5)
			mkultra_add_cooldown(enthrall_chem, 2)
		mkultra_debug("arousal lock apply end [humanoid] mode=[mode] arousal=[humanoid.arousal] status=[humanoid.arousal_status]")

	return TRUE

/proc/process_mkultra_command_worship(message, mob/living/user, list/listeners, power_multiplier)
	var/lowered = lowertext(message)
	var/list/patterns = mkultra_cmd_patterns("worship")
	var/match_idx = mkultra_command_match_index(message, lowered, patterns)
	var/do_stop = (match_idx == 2)
	if(!match_idx)
		return FALSE
	if(do_stop)
		for(var/enthrall_victim in listeners)
			if(!ishuman(enthrall_victim))
				continue
			var/mob/living/carbon/human/humanoid = enthrall_victim
			mkultra_stop_worship(humanoid)
		var/msg_stop = mkultra_cmd_text("worship", "stop_master") || "<span class='notice'><i>Worship urges cancelled.</i></span>"
		to_chat(user, msg_stop)
		return TRUE

	var/idx = findtext(lowered, "worship ")
	if(!idx)
		return FALSE
	var/body_part = trim(copytext(message, idx + length("worship ")))
	if(!length(body_part))
		return TRUE
	// Strip possessives/articles and trailing punctuation so the displayed text reads naturally.
	for(var/article in list("my ", "your ", "the "))
		if(findtext(lowertext(body_part), article) == 1)
			body_part = copytext(body_part, length(article) + 1)
			break
	while(length(body_part) && findtext(".!,?", copytext(body_part, -1)))
		body_part = copytext(body_part, 1, length(body_part))
	body_part = trim(body_part)
	if(!length(body_part))
		return TRUE

	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || !enthrall_chem.lewd || enthrall_chem.phase < 2 || enthrall_chem.enthrall_mob != user)
			continue

		mkultra_start_worship(humanoid, user, body_part)
		mkultra_add_cooldown(enthrall_chem, 3)
		var/msg_start = mkultra_cmd_text("worship", "start_master", list("target" = humanoid, "part" = body_part)) || "<span class='notice'><i>[humanoid] is compelled to worship your [body_part].</i></span>"
		to_chat(user, msg_start)
	return TRUE

/proc/process_mkultra_command_heat(message, mob/living/user, list/listeners, power_multiplier)
	var/lowered = lowertext(message)
	var/list/patterns = mkultra_cmd_patterns("heat")
	var/match_idx = mkultra_command_match_index(message, lowered, patterns)
	var/do_heat = null
	if(match_idx == 1)
		do_heat = TRUE
	else if(match_idx == 2)
		do_heat = FALSE
	else
		return FALSE

	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || !enthrall_chem.lewd || enthrall_chem.phase < 2 || enthrall_chem.enthrall_mob != user)
			continue

		if(do_heat)
			mkultra_set_heat(humanoid, TRUE)
			mkultra_add_cooldown(enthrall_chem, 2)
			var/msg_on = mkultra_cmd_text("heat", "on_master", list("target" = humanoid)) || "<span class='notice'><i>You force [humanoid] into heat.</i></span>"
			to_chat(user, msg_on)
		else
			mkultra_set_heat(humanoid, FALSE)
			var/msg_off = mkultra_cmd_text("heat", "off_master", list("target" = humanoid)) || "<span class='notice'><i>You end [humanoid]'s heat.</i></span>"
			to_chat(user, msg_off)
		return TRUE

	return TRUE

/proc/process_mkultra_command_well_trained_toggle(message, mob/living/user, list/listeners, power_multiplier)
	var/lowered = lowertext(message)
	var/list/patterns = mkultra_cmd_patterns("well_trained")
	var/match_idx = mkultra_command_match_index(message, lowered, patterns)
	var/do_train = null
	if(match_idx == 1)
		do_train = TRUE
	else if(match_idx == 2)
		do_train = FALSE
	else
		return FALSE

	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || !enthrall_chem.lewd || enthrall_chem.phase < 2 || enthrall_chem.enthrall_mob != user)
			continue

		if(do_train)
			mkultra_set_well_trained(humanoid, TRUE)
			mkultra_add_cooldown(enthrall_chem, 2)
			var/msg_on = mkultra_cmd_text("well_trained", "on_master", list("target" = humanoid)) || "<span class='notice'><i>[humanoid] is given the well trained perk.</i></span>"
			to_chat(user, msg_on)
		else
			mkultra_set_well_trained(humanoid, FALSE)
			var/msg_off = mkultra_cmd_text("well_trained", "off_master", list("target" = humanoid)) || "<span class='notice'><i>[humanoid] has their training lifted.</i></span>"
			to_chat(user, msg_off)
	return TRUE

/proc/process_mkultra_command_piss_self(message, mob/living/user, list/listeners, power_multiplier)
	var/list/patterns = mkultra_cmd_patterns("piss_self")
	if(!mkultra_command_matches(message, lowertext(message), patterns))
		return FALSE
	mkultra_debug("piss-self matched by [user] -> [listeners.len] listeners")

	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			mkultra_debug("piss-self skip [enthrall_victim]: not human")
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || !enthrall_chem.lewd || enthrall_chem.phase < 2 || enthrall_chem.enthrall_mob != user)
			mkultra_debug("piss-self skip [humanoid]: enthrall gate fail (lewd=[enthrall_chem?.lewd] phase=[enthrall_chem?.phase] master_match=[enthrall_chem?.enthrall_mob == user])")
			continue
		if(humanoid.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_unholy) == "No")
			mkultra_debug("piss-self skip [humanoid]: unholy pref off")
			continue
		var/obj/item/organ/bladder/bladder = humanoid.get_organ_slot(ORGAN_SLOT_BLADDER)
		if(!bladder)
			mkultra_debug("piss-self skip [humanoid]: no bladder organ")
			continue
		var/before = bladder.stored_piss
		// Ensure enough volume to actually expel urine; forced urinate still requires a minimum.
		if(bladder.stored_piss < bladder.piss_dosage)
			bladder.stored_piss = bladder.piss_dosage
		bladder.urinate(forced = TRUE)
		mkultra_debug("piss-self urinate [humanoid]: before=[before] after=[bladder.stored_piss]")
		mkultra_add_cooldown(enthrall_chem, 3)
		var/msg_master = mkultra_cmd_text("piss_self", "master", list("target" = humanoid)) || "<span class='notice'><i>You order [humanoid] to humiliate themself, and they do.</i></span>"
		var/msg_pet = mkultra_cmd_text("piss_self", "pet") || "<span class='warning'>You shamefully soak yourself on command.</span>"
		to_chat(user, msg_master)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, msg_pet), 5)
	return TRUE

/proc/process_mkultra_command_sissy(message, mob/living/user, list/listeners, power_multiplier)
	var/lowered = lowertext(message)
	var/list/patterns = mkultra_cmd_patterns("sissy")
	var/match_idx = mkultra_command_match_index(message, lowered, patterns)
	var/do_sissy = null
	if(match_idx == 1)
		do_sissy = TRUE
	else if(match_idx == 2)
		do_sissy = FALSE
	else
		return FALSE
	mkultra_debug("sissy command matched by [user] -> [listeners.len] listeners (do_sissy=[do_sissy])")

	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			mkultra_debug("sissy skip [enthrall_victim]: not human")
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || !enthrall_chem.lewd || enthrall_chem.phase < 2 || enthrall_chem.enthrall_mob != user)
			mkultra_debug("sissy skip [humanoid]: enthrall gate fail (lewd=[enthrall_chem?.lewd] phase=[enthrall_chem?.phase] master_match=[enthrall_chem?.enthrall_mob == user])")
			continue

		if(do_sissy)
			mkultra_start_sissy(humanoid, user)
			mkultra_add_cooldown(enthrall_chem, 4)
			mkultra_debug("sissy start issued to [humanoid] by [user]")
			var/msg_on = mkultra_cmd_text("sissy", "on_master", list("target" = humanoid)) || "<span class='notice'><i>You enforce a humiliatingly cute dress code on [humanoid].</i></span>"
			to_chat(user, msg_on)
		else
			mkultra_clear_sissy(humanoid)
			mkultra_debug("sissy clear issued to [humanoid] by [user]")
			var/msg_off = mkultra_cmd_text("sissy", "off_master", list("target" = humanoid)) || "<span class='notice'><i>You release [humanoid] from their dress code.</i></span>"
			to_chat(user, msg_off)
	return TRUE

/proc/process_mkultra_command_pet_tether(message, mob/living/user, list/listeners, power_multiplier)
	var/static/regex/tether_words = regex("tether mood|distance mood|homesick")
	if(!findtext(message, tether_words))
		return FALSE

	var/enable = findtext(lowertext(message), "on") || findtext(lowertext(message), "enable")
	var/disable = findtext(lowertext(message), "off") || findtext(lowertext(message), "disable")
	if(!enable && !disable)
		return FALSE
	mkultra_debug("pet tether matched by [user] -> [listeners.len] listeners (enable=[enable] disable=[disable])")

	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			mkultra_debug("pet tether skip [enthrall_victim]: not human")
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall/pet_chip)
		if(!enthrall_chem)
			enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall/pet_chip/mk2)
		if(!enthrall_chem || enthrall_chem.enthrall_mob != user)
			mkultra_debug("pet tether skip [humanoid]: enthrall gate fail (master_match=[enthrall_chem?.enthrall_mob == user])")
			continue
		enthrall_chem.distance_mood_enabled = enable && !disable ? TRUE : FALSE
		mkultra_debug("pet tether set [humanoid] distance_mood=[enthrall_chem.distance_mood_enabled] by [user]")
		var/state_label = enthrall_chem.distance_mood_enabled ? "enable" : "disable"
		var/msg_master = mkultra_cmd_text("pet_tether", "master", list("state" = state_label, "target" = humanoid)) || "<span class='notice'><i>You [state_label] distance yearning on [humanoid].</i></span>"
		var/msg_pet = enthrall_chem.distance_mood_enabled ? (mkultra_cmd_text("pet_tether", "pet_on") || "<span class='notice'>You feel longing when apart.</span>") : (mkultra_cmd_text("pet_tether", "pet_off") || "<span class='notice'>You feel a calm steadiness even when distant.</span>")
		to_chat(user, msg_master)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, msg_pet), 5)
	return TRUE

/proc/process_mkultra_command_slot_lock(message, mob/living/user, list/listeners, power_multiplier)
	var/lowered = lowertext(message)
	var/is_lock = findtext(lowered, "lock ")
	var/is_unlock = findtext(lowered, "unlock ")
	if(!is_lock && !is_unlock)
		return FALSE

	// Choose the first matching keyword position to slice slot text.
	var/keyword_idx = is_lock || is_unlock
	var/keyword = is_lock ? "lock " : "unlock "
	var/slot_text = trim(copytext(message, keyword_idx + length(keyword)))
	if(!length(slot_text))
		return FALSE

	var/slot_id = mkultra_resolve_strip_slot(slot_text)
	if(isnull(slot_id))
		return FALSE

	var/handled = FALSE
	for(var/enthrall_victim in listeners)
		if(!ishuman(enthrall_victim))
			continue
		var/mob/living/carbon/human/humanoid = enthrall_victim
		var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall/pet_chip)
		if(!enthrall_chem)
			enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall/pet_chip/mk2)
		if(!enthrall_chem)
			enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
		if(!enthrall_chem || enthrall_chem.enthrall_mob != user)
			continue

		var/obj/item/slot_item = mkultra_get_item_for_slot(humanoid, slot_id)
		var/slot_label = mkultra_slot_name(slot_id)
		if(is_lock)
			if(!slot_item)
				var/msg_none = mkultra_cmd_text("slot_lock", "no_item", list("target" = humanoid)) || "<span class='warning'><i>[humanoid] isn't wearing anything in that slot.</i></span>"
				to_chat(user, msg_none)
				return TRUE
			if(mkultra_lock_slot_item(humanoid, slot_item, slot_label))
				var/msg_master_lock = mkultra_cmd_text("slot_lock", "master_lock", list("target" = humanoid, "slot" = slot_label)) || "<span class='notice'><i>You lock [humanoid]'s [slot_label] item in place.</i></span>"
				var/msg_pet_lock = mkultra_cmd_text("slot_lock", "pet_lock", list("slot" = slot_label)) || "<span class='warning'>Your [slot_label] is locked in place by your handler.</span>"
				to_chat(user, msg_master_lock)
				addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, msg_pet_lock), 5)
				mkultra_add_cooldown(enthrall_chem, 2)
				handled = TRUE
		else if(is_unlock)
			if(slot_item)
				mkultra_unlock_slot_item(slot_item)
			else
				// Fallback: clear any stale locks on this mob.
				var/list/locked = mkultra_slot_locks[humanoid]
				if(islist(locked))
					for(var/obj/item/I in locked)
						mkultra_unlock_slot_item(I)
			var/msg_master_unlock = mkultra_cmd_text("slot_lock", "master_unlock", list("target" = humanoid, "slot" = slot_label)) || "<span class='notice'><i>You unlock [humanoid]'s [slot_label] item.</i></span>"
			var/msg_pet_unlock = mkultra_cmd_text("slot_lock", "pet_unlock", list("slot" = slot_label)) || "<span class='notice'>You feel the lock on your [slot_label] release.</span>"
			to_chat(user, msg_master_unlock)
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, msg_pet_unlock), 5)
			handled = TRUE
	return handled

/proc/mkultra_move_adjacent(mob/living/carbon/human/humanoid, mob/living/target, max_steps = 6)
	// Try pathing, but only report success once actually adjacent; fall back to limited stepping.
	if(get_dist(humanoid, target) <= 1)
		return TRUE
	GLOB.move_manager.move_to(humanoid, target, 1, max_steps)
	for(var/i in 1 to max_steps)
		if(get_dist(humanoid, target) <= 1)
			return TRUE
		step_towards(humanoid, target)
	return get_dist(humanoid, target) <= 1

/proc/mkultra_do_wear(mob/living/carbon/human/humanoid, mob/living/carbon/human/master, slot_text)
	if(get_dist(humanoid, master) > 1)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, "<span class='warning'>You need to be beside [master] to take it.</span>"), 5)
		return FALSE
	var/obj/item/hand_item = master.get_active_held_item()
	if(!hand_item)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, "<span class='warning'>There's nothing to wear...</span>"), 5)
		return FALSE

	// Take the item into the thrall's hands so equip checks work.
	if(!master.transferItemToLoc(hand_item, humanoid))
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, "<span class='warning'>You can't take it from [master].</span>"), 5)
		return FALSE

	var/slot_id = null
	if(slot_text)
		slot_id = mkultra_resolve_strip_slot(slot_text)

	var/success = FALSE
	if(slot_id)
		success = humanoid.equip_to_slot_if_possible(hand_item, slot_id, disable_warning = TRUE, bypass_equip_delay_self = TRUE, indirect_action = TRUE)
	else
		success = humanoid.equip_to_appropriate_slot(hand_item)

	if(!success)
		// Drop it back on the ground if it couldn't be worn so it isn't lost.
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, "<span class='warning'>You can't wear that, sorry...</span>"), 5)
		humanoid.dropItemToGround(hand_item)
		return FALSE

	// Clear any ongoing heel order so the wearer doesn't keep trailing after finishing.
	mkultra_stop_follow(humanoid)
	GLOB.move_manager.stop_looping(humanoid)

	return TRUE

/proc/mkultra_set_cum_lock(mob/living/carbon/human/humanoid, apply)
	if(apply)
		ADD_TRAIT(humanoid, TRAIT_NEVERBONER, "mkultra_cum_lock")
		mkultra_cum_locks[humanoid] = TRUE
	else
		REMOVE_TRAIT(humanoid, TRAIT_NEVERBONER, "mkultra_cum_lock")
		mkultra_cum_locks -= humanoid

/proc/mkultra_set_arousal_lock(mob/living/carbon/human/humanoid, mode)
	mkultra_arousal_locks[humanoid] = mode
	if(!(humanoid in mkultra_arousal_saved_states))
		var/obj/item/organ/genital/penis/prior = humanoid.get_organ_slot(ORGAN_SLOT_PENIS)
		mkultra_arousal_saved_states[humanoid] = list(
			"arousal" = humanoid.arousal,
			"status" = humanoid.arousal_status,
			"penis" = prior?.aroused,
			"removed_toggle_arousal" = (humanoid.verbs && (humanoid.verbs.Find(/mob/living/carbon/human/verb/toggle_arousal))),
			"removed_toggle_genitals" = (humanoid.verbs && (humanoid.verbs.Find(/mob/living/carbon/human/verb/toggle_genitals))),
		)
	var/saved_penis_state = mkultra_arousal_saved_states[humanoid]?["penis"]
	mkultra_debug("arousal lock state capture [humanoid] mode=[mode] saved_arousal=[humanoid.arousal] saved_status=[humanoid.arousal_status] saved_penis=[saved_penis_state]")
	// Block manual toggles while the lock is active.
	if(humanoid.verbs)
		if(humanoid.verbs.Find(/mob/living/carbon/human/verb/toggle_arousal))
			humanoid.verbs -= /mob/living/carbon/human/verb/toggle_arousal
		if(humanoid.verbs.Find(/mob/living/carbon/human/verb/toggle_genitals))
			humanoid.verbs -= /mob/living/carbon/human/verb/toggle_genitals
	mkultra_signal_handler.RegisterSignal(humanoid, COMSIG_HUMAN_ADJUST_AROUSAL, TYPE_PROC_REF(/datum/mkultra_signal_handler, arousal_lock_on_adjust), TRUE)
	mkultra_signal_handler.RegisterSignal(humanoid, COMSIG_QDELETING, TYPE_PROC_REF(/datum/mkultra_signal_handler, arousal_lock_on_delete), TRUE)
	mkultra_signal_handler.RegisterSignal(humanoid, COMSIG_HUMAN_PERFORM_CLIMAX, TYPE_PROC_REF(/datum/mkultra_signal_handler, arousal_lock_on_climax), TRUE)
	mkultra_debug("arousal lock set [humanoid] -> [mode]")
	mkultra_apply_arousal_lock_now(humanoid)

/proc/mkultra_clear_arousal_lock(mob/living/carbon/human/humanoid)
	if(!(humanoid in mkultra_arousal_locks))
		return
	mkultra_arousal_locks -= humanoid
	mkultra_signal_handler.UnregisterSignal(humanoid, list(COMSIG_HUMAN_ADJUST_AROUSAL, COMSIG_QDELETING, COMSIG_HUMAN_PERFORM_CLIMAX))
	mkultra_debug("arousal lock clear [humanoid]")
	mkultra_apply_arousal_lock_now(humanoid, clear_only = TRUE)
	var/list/saved = mkultra_arousal_saved_states[humanoid]
	if(saved)
		if(saved["removed_toggle_arousal"] && humanoid.verbs && !humanoid.verbs.Find(/mob/living/carbon/human/verb/toggle_arousal))
			humanoid.verbs += /mob/living/carbon/human/verb/toggle_arousal
		if(saved["removed_toggle_genitals"] && humanoid.verbs && !humanoid.verbs.Find(/mob/living/carbon/human/verb/toggle_genitals))
			humanoid.verbs += /mob/living/carbon/human/verb/toggle_genitals
	mkultra_arousal_saved_states -= humanoid

/proc/mkultra_apply_arousal_lock_now(mob/living/carbon/human/humanoid, clear_only = FALSE)
	if(mkultra_arousal_applying[humanoid])
		return
	mkultra_arousal_applying[humanoid] = TRUE

	var/mode = mkultra_arousal_locks[humanoid]
	if(clear_only)
		mode = null
	if(!mode && !clear_only)
		mkultra_arousal_applying -= humanoid
		return
	mkultra_debug("arousal_apply start [humanoid] mode=[mode] clear_only=[clear_only] arousal=[humanoid.arousal] status=[humanoid.arousal_status]")
	var/list/genitals = list()
	for(var/obj/item/organ/genital/G in humanoid.organs)
		genitals += G
	var/obj/item/organ/genital/penis/penis = humanoid.get_organ_slot(ORGAN_SLOT_PENIS)
	if(!penis)
		penis = new /obj/item/organ/genital/penis
		penis.Insert(humanoid, special = TRUE, movement_flags = DELETE_IF_REPLACED)
		genitals |= penis

	if(clear_only)
		var/list/saved = mkultra_arousal_saved_states[humanoid]
		var/saved_penis = saved?["penis"]
		if(!isnull(saved_penis))
			penis.aroused = saved_penis
		for(var/obj/item/organ/genital/G in genitals)
			var/key = "genital_aroused_[G.type]"
			if(saved && saved[key])
				G.aroused = saved[key]
	else
		for(var/obj/item/organ/genital/G in genitals)
			var/key2 = "genital_aroused_[G.type]"
			if(!(humanoid in mkultra_arousal_saved_states))
				mkultra_arousal_saved_states[humanoid] = list()
			if(isnull(mkultra_arousal_saved_states[humanoid][key2]))
				mkultra_arousal_saved_states[humanoid][key2] = G.aroused
		if(mode == "hard")
			penis.aroused = AROUSAL_FULL
			for(var/obj/item/organ/genital/G in genitals)
				G.aroused = AROUSAL_FULL
		else
			penis.aroused = AROUSAL_NONE
			for(var/obj/item/organ/genital/G in genitals)
				G.aroused = AROUSAL_NONE

	for(var/obj/item/organ/genital/G in genitals)
		if(istype(G, /obj/item/organ/genital/penis))
			var/obj/item/organ/genital/penis/p = G
			p.update_sprite_suffix()
	humanoid.update_body()
	SEND_SIGNAL(humanoid, COMSIG_HUMAN_TOGGLE_AROUSAL)
	mkultra_debug("arousal_apply end [humanoid] mode=[mode] clear_only=[clear_only] arousal=[humanoid.arousal] status=[humanoid.arousal_status] penis_aroused=[penis?.aroused]")
	mkultra_arousal_applying -= humanoid

/datum/mkultra_signal_handler/proc/arousal_lock_on_adjust(datum/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/humanoid = source
	mkultra_apply_arousal_lock_now(humanoid)

/datum/mkultra_signal_handler/proc/arousal_lock_on_delete(datum/source)
	SIGNAL_HANDLER
	mkultra_clear_arousal_lock(source)

/datum/mkultra_signal_handler/proc/arousal_lock_on_climax(datum/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/humanoid = source
	mkultra_apply_arousal_lock_now(humanoid)

/datum/mkultra_signal_handler/proc/slot_lock_on_item_unequip(obj/item/source, force, atom/newloc, no_move, invdrop, silent)
	SIGNAL_HANDLER
	mkultra_unlock_slot_item(source, silent = TRUE)

/datum/mkultra_signal_handler/proc/slot_lock_on_item_delete(obj/item/source)
	SIGNAL_HANDLER
	mkultra_unlock_slot_item(source, silent = TRUE)

/datum/mkultra_signal_handler/proc/slot_lock_on_owner_delete(mob/living/carbon/human/source)
	SIGNAL_HANDLER
	var/list/locked = mkultra_slot_locks[source]
	if(!islist(locked))
		return
	for(var/obj/item/I in locked)
		mkultra_unlock_slot_item(I, silent = TRUE)

/proc/mkultra_start_worship(mob/living/carbon/human/humanoid, mob/living/master, body_part)
	mkultra_stop_worship(humanoid)
	mkultra_worship_states[humanoid] = list("master" = WEAKREF(master), "part" = body_part)
	mkultra_worship_tick(humanoid)

/proc/mkultra_stop_worship(mob/living/carbon/human/humanoid)
	if(!(humanoid in mkultra_worship_states))
		return
	mkultra_worship_states -= humanoid

/proc/mkultra_worship_tick(mob/living/carbon/human/humanoid)
	var/list/state = mkultra_worship_states[humanoid]
	if(!state)
		return
	var/datum/weakref/master_ref = state["master"]
	var/mob/living/master = master_ref?.resolve()
	var/part = state["part"]
	if(QDELETED(humanoid) || QDELETED(master))
		mkultra_stop_worship(humanoid)
		return
	var/nearby = (master in view(6, humanoid))
	var/pronoun = mkultra_worship_pronoun(part)
	var/text = nearby ? "You can't stop staring at [master]'s [part]; you need to worship [pronoun]." : "Your mind drifts back to [master]'s [part], filling you with need to worship [pronoun]."
	to_chat(humanoid, span_love(text))
	addtimer(CALLBACK(GLOBAL_PROC, .proc/mkultra_worship_tick, humanoid), nearby ? 12 SECONDS : 20 SECONDS)

/proc/mkultra_worship_pronoun(body_part)
	var/lower = lowertext(body_part)
	if(findtext(lower, " and "))
		return "them"
	if(copytext(lower, -1) == "s" && !findtext(lower, "ss", -1))
		return "them"
	return "it"

/proc/mkultra_set_heat(mob/living/carbon/human/humanoid, apply)
	if(apply)
		if(!humanoid.has_quirk(/datum/quirk/hypersexual))
			humanoid.add_quirk(/datum/quirk/hypersexual, announce = FALSE)
			mkultra_heat_states[humanoid] = TRUE
	else
		if(humanoid.has_quirk(/datum/quirk/hypersexual))
			humanoid.remove_quirk(/datum/quirk/hypersexual)
		mkultra_heat_states -= humanoid

/proc/mkultra_start_fetch(mob/living/carbon/human/humanoid, mob/living/master)
	mkultra_stop_fetch(humanoid)
	var/prev_intent = humanoid.move_intent
	if(prev_intent != MOVE_INTENT_RUN)
		humanoid.toggle_move_intent()
	mkultra_fetch_states[humanoid] = list("master" = WEAKREF(master), "prev_intent" = prev_intent, "listened" = list())
	mkultra_signal_handler.RegisterSignal(master, COMSIG_MOB_THROW, TYPE_PROC_REF(/datum/mkultra_signal_handler, fetch_on_throw))
	mkultra_signal_handler.RegisterSignal(humanoid, COMSIG_QDELETING, TYPE_PROC_REF(/datum/mkultra_signal_handler, fetch_on_delete))
	var/timer_id = addtimer(CALLBACK(GLOBAL_PROC, .proc/mkultra_stop_fetch, humanoid), 30 SECONDS, TIMER_STOPPABLE)
	mkultra_fetch_states[humanoid]["timer"] = timer_id

/proc/mkultra_stop_fetch(mob/living/carbon/human/humanoid)
	var/list/datum/weakref/state = mkultra_fetch_states[humanoid]
	if(state)
		var/datum/weakref/master_ref = state["master"]
		var/mob/living/master = master_ref?.resolve()
		if(master)
			mkultra_signal_handler.UnregisterSignal(master, COMSIG_MOB_THROW)
		if(state["listened"])
			for(var/datum/weakref/W in state["listened"])
				var/atom/movable/listened = W?.resolve()
				if(listened)
					mkultra_signal_handler.UnregisterSignal(listened, COMSIG_MOVABLE_THROW_LANDED)
		if(state["timer"])
			deltimer(state["timer"])
		if(!QDELETED(humanoid) && (state["prev_intent"] || state["prev_intent"] == 0) && humanoid.move_intent != state["prev_intent"])
			humanoid.toggle_move_intent()
	mkultra_signal_handler.UnregisterSignal(humanoid, list(COMSIG_QDELETING))
	mkultra_fetch_states -= humanoid

/datum/mkultra_signal_handler/proc/fetch_on_delete(datum/source)
	SIGNAL_HANDLER
	mkultra_stop_fetch(source)

/datum/mkultra_signal_handler/proc/fetch_on_throw(mob/living/carbon/thrower, atom/target)
	SIGNAL_HANDLER
	mkultra_debug("fetch_on_throw from [thrower] toward [target]")
	for(var/mob/living/carbon/human/humanoid in mkultra_fetch_states)
		var/list/datum/weakref/state = mkultra_fetch_states[humanoid]
		if(state?["master"]?.resolve() != thrower)
			continue
		var/obj/item/thrown = thrower.get_active_held_item()
		if(!isitem(thrown))
			continue
		RegisterSignal(thrown, COMSIG_MOVABLE_THROW_LANDED, TYPE_PROC_REF(/datum/mkultra_signal_handler, fetch_on_land))
		state["listened"] += WEAKREF(thrown)

/datum/mkultra_signal_handler/proc/fetch_on_land(obj/item/thrown, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	mkultra_debug("fetch_on_land for [thrown]")
	UnregisterSignal(thrown, COMSIG_MOVABLE_THROW_LANDED)
	for(var/mob/living/carbon/human/humanoid in mkultra_fetch_states)
		var/list/datum/weakref/state = mkultra_fetch_states[humanoid]
		if(state)
			state["listened"] -= WEAKREF(thrown)
	var/mob/living/carbon/thrower = throwingdatum?.get_thrower()
	for(var/mob/living/carbon/human/humanoid in mkultra_fetch_states)
		var/list/datum/weakref/state = mkultra_fetch_states[humanoid]
		if(state?["master"]?.resolve() != thrower)
			continue
		if(!isturf(thrown.loc))
			continue
		mkultra_fetch_go(humanoid, thrown, thrower)

/proc/mkultra_fetch_go(mob/living/carbon/human/humanoid, obj/item/target, mob/living/carbon/human/master)
	if(QDELETED(target) || QDELETED(humanoid) || QDELETED(master))
		return
	mkultra_debug("fetch_go start [humanoid] -> [target] for [master]")
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		mkultra_stop_fetch(humanoid)
		return

	// Move onto the item's turf (not just adjacent) so pickup succeeds.
	if(humanoid.loc != target_turf)
		mkultra_debug("fetch move toward turf [target_turf] for [humanoid]")
		GLOB.move_manager.move_to(humanoid, target_turf, 0, 12)
		for(var/i in 1 to 12)
			if(humanoid.loc == target_turf)
				break
			step_to(humanoid, target_turf)
	if(humanoid.loc != target_turf)
		mkultra_debug("fetch failed to reach target turf [target_turf] for [humanoid]")
		mkultra_stop_fetch(humanoid)
		return

	// Free a hand if needed.
	if(humanoid.get_active_held_item() && humanoid.get_inactive_held_item())
		mkultra_debug("fetch dropping active hand to free space for [target] on [humanoid]")
		humanoid.dropItemToGround(humanoid.get_active_held_item())
	if(humanoid.get_active_held_item() && humanoid.get_inactive_held_item())
		mkultra_debug("fetch dropping inactive hand to free space for [target] on [humanoid]")
		humanoid.dropItemToGround(humanoid.get_inactive_held_item())

	var/picked = FALSE
	if(humanoid.put_in_active_hand(target))
		picked = TRUE
	else if(humanoid.put_in_inactive_hand(target))
		picked = TRUE
	else if(isturf(target.loc))
		mkultra_debug("fetch fallback attack_hand pickup for [target] on [humanoid]")
		target.attack_hand(humanoid)
		picked = (target in humanoid)
	if(!picked)
		mkultra_debug("fetch failed to pick up [target] for [humanoid]")
		mkultra_stop_fetch(humanoid)
		return
	mkultra_debug("fetch picked up [target] for [humanoid]")

	if(!mkultra_move_adjacent(humanoid, master, 12))
		mkultra_debug("fetch failed to return to [master] with [target] for [humanoid]")
		mkultra_stop_fetch(humanoid)
		return
	if(!master.get_active_held_item())
		master.put_in_active_hand(target)
	else if(!master.get_inactive_held_item())
		master.put_in_inactive_hand(target)
	else
		target.forceMove(get_turf(master))

/proc/mkultra_set_well_trained(mob/living/carbon/human/humanoid, apply)
	if(apply)
		if(!humanoid.has_quirk(/datum/quirk/well_trained))
			humanoid.add_quirk(/datum/quirk/well_trained, announce = FALSE)
			mkultra_well_trained_states[humanoid] = TRUE
	else
		if(humanoid.has_quirk(/datum/quirk/well_trained))
			humanoid.remove_quirk(/datum/quirk/well_trained)
		mkultra_well_trained_states -= humanoid

/proc/mkultra_start_sissy(mob/living/carbon/human/humanoid, mob/living/master)
	var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
	mkultra_debug("sissy start [humanoid] by [master] (phase=[enthrall_chem?.phase] lewd=[enthrall_chem?.lewd])")
	mkultra_clear_sissy(humanoid)
	mkultra_sissy_states[humanoid] = list("master" = WEAKREF(master))
	mkultra_signal_handler.RegisterSignal(humanoid, COMSIG_QDELETING, TYPE_PROC_REF(/datum/mkultra_signal_handler, sissy_on_delete), TRUE)
	mkultra_signal_handler.RegisterSignal(humanoid, COMSIG_MOB_EQUIPPED_ITEM, TYPE_PROC_REF(/datum/mkultra_signal_handler, sissy_on_outfit_change), TRUE)
	mkultra_signal_handler.RegisterSignal(humanoid, COMSIG_MOB_UNEQUIPPED_ITEM, TYPE_PROC_REF(/datum/mkultra_signal_handler, sissy_on_outfit_change), TRUE)
	mkultra_apply_arousal_lock_now(humanoid, clear_only = TRUE)
	mkultra_set_arousal_lock(humanoid, "limp")
	mkultra_set_well_trained(humanoid, TRUE)
	mkultra_sissy_tick(humanoid)

/proc/mkultra_clear_sissy(mob/living/carbon/human/humanoid)
	if(!(humanoid in mkultra_sissy_states))
		return
	mkultra_debug("sissy clear [humanoid]")
	mkultra_signal_handler.UnregisterSignal(humanoid, list(COMSIG_QDELETING, COMSIG_MOB_EQUIPPED_ITEM, COMSIG_MOB_UNEQUIPPED_ITEM))
	mkultra_sissy_states -= humanoid
	REMOVE_TRAIT(humanoid, TRAIT_NEVERBONER, "mkultra_cum_lock")
	mkultra_clear_arousal_lock(humanoid)
	mkultra_apply_arousal_lock_now(humanoid, clear_only = TRUE)
	mkultra_set_well_trained(humanoid, FALSE)
	humanoid.clear_mood_event("enthrallsissy")

/datum/mkultra_signal_handler/proc/sissy_on_delete(datum/source)
	SIGNAL_HANDLER
	mkultra_clear_sissy(source)

/datum/mkultra_signal_handler/proc/sissy_on_outfit_change(datum/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/humanoid = source
	mkultra_sissy_tick(humanoid)

/proc/mkultra_sissy_tick(mob/living/carbon/human/humanoid)
	var/list/state = mkultra_sissy_states[humanoid]
	if(!state)
		return
	var/datum/weakref/master_ref = state["master"]
	var/mob/living/master = master_ref?.resolve()
	var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
	if(!master || !enthrall_chem || enthrall_chem.enthrall_mob != master || enthrall_chem.phase < 2 || !enthrall_chem.lewd)
		mkultra_debug("sissy tick clearing [humanoid]: master=[master] enthrall=[!isnull(enthrall_chem)] phase=[enthrall_chem?.phase] lewd=[enthrall_chem?.lewd]")
		mkultra_clear_sissy(humanoid)
		return

	var/violation = FALSE
	var/obj/item/clothing/offending
	for(var/slot in list(ITEM_SLOT_HEAD, ITEM_SLOT_MASK, ITEM_SLOT_EYES, ITEM_SLOT_EARS, ITEM_SLOT_NECK, ITEM_SLOT_OCLOTHING, ITEM_SLOT_ICLOTHING, ITEM_SLOT_GLOVES, ITEM_SLOT_FEET, ITEM_SLOT_BELT))
		var/obj/item/clothing/W = humanoid.get_item_by_slot(slot)
		if(!W)
			continue
		if(!mkultra_is_sissy_friendly(W))
			violation = TRUE
			offending = W
			mkultra_debug("sissy violation on [humanoid]: [W] in slot [slot]")
			break

	if(violation)
		var/owner_name = enthrall_chem?.enthrall_gender || master?.name || "your owner"
		var/bad_item = offending ? offending.name : "that outfit"
		var/message = "Your [bad_item] isn't what [owner_name] wants you to wear."
		humanoid.add_mood_event("enthrallsissy", /datum/mood_event/enthrall_sissy, message)
		var/chat_prompt = pick(
			"Your [bad_item] isn't what [owner_name] wants you in.",
			"You shouldn't be in [bad_item]; [owner_name] wants you cute.",
			"[owner_name] would frown at that [bad_item]â€”change it.",
			"That [bad_item] isn't girly enough for [owner_name].",
		)
		to_chat(humanoid, "<span class='love'><i>[chat_prompt]</i></span>")
	else
		humanoid.clear_mood_event("enthrallsissy")

		addtimer(CALLBACK(GLOBAL_PROC, .proc/mkultra_sissy_tick, humanoid), 20 SECONDS)

/proc/mkultra_is_sissy_friendly(obj/item/clothing/W)
	var/name_lower = lowertext(W.name)
	// Feminine cues and kink gear that should be allowed.
	if(findtext(name_lower, regex("latex|maid|bunny|dress|skirt|panty|panties|bra|corset|lingerie|stocking|thigh|fishnet|heels|leotard|gown|sundress|bloomers|kitten|bimbo|collar|choker|gag|bit|muzzle|hypno|hypnosis|chastity|harness|bondage|deprivation|gimp|flower")))
		return TRUE
	return FALSE


// SPLURT: Base MKUltra command set from upstream, for modular use.
/proc/mkultra_handle_base_commands(message, mob/living/user, base_multiplier = 1, message_admins = FALSE, debug = FALSE)

	if(!user || !user.can_speak() || user.stat)
		return 0 //no cooldown

	var/log_message = message
	if(mkultra_debug_enabled)
		world.log << "SPLURT DEBUG: mkultra_base start msg='[message]' speaker=[user]"
		to_chat(user, span_notice("SPLURT DEBUG: mkultra_base start msg='[message]'"))

	//FIND THRALLS
	message = LOWER_TEXT(message)
	var/list/mob/living/listeners = list()
	var/list/mob/living/mk2_listeners = list() //SPLURT ADDITION
	for(var/mob/living/enthrall_listener in get_hearers_in_view(8, user))
		if(enthrall_listener.can_hear() && enthrall_listener.stat != DEAD)
			if(enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall))//Check to see if they have the status
				var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)//Check to see if pet is on cooldown from last command and if the enthrall_mob is right
				if(enthrall_chem.enthrall_mob != user)
					continue
				if(ishuman(enthrall_listener))
					var/mob/living/carbon/human/humanoid = enthrall_listener
					if(istype(humanoid.ears, /obj/item/clothing/ears/earmuffs))
						continue

				if (enthrall_chem.cooldown > 0)//If they're on cooldown you can't give them more commands.
					continue
				listeners += enthrall_listener
				if(istype(enthrall_chem, /datum/status_effect/chem/enthrall/pet_chip/mk2))
					mk2_listeners += enthrall_listener

	if(mkultra_debug_enabled)
		world.log << "SPLURT DEBUG: listeners total=[listeners.len] mk2=[mk2_listeners.len]"
		to_chat(user, span_notice("SPLURT DEBUG: listeners total=[listeners.len] mk2=[mk2_listeners.len]"))

	if(!listeners.len)
		return 0

	//POWER CALCULATIONS

	var/power_multiplier = base_multiplier

	//SPLURT ADDITION: Only run modular handlers for Mk.2 enthralls; exclude them from the base command flow.
	if(mk2_listeners.len)
		// Run modular handlers first so Mk.2-specific commands fire, but keep Mk.2 in the list so base commands also apply.
		if(mkultra_handle_modular_commands(message, user, mk2_listeners, power_multiplier))
			if(mkultra_debug_enabled)
				world.log << "SPLURT DEBUG: modular commands handled msg for mk2 (base commands will still run)"
				to_chat(user, span_notice("SPLURT DEBUG: modular commands handled msg for mk2 (base still runs)"))

	if(!listeners.len)
		return 0

	// Not sure I want to give extra power to anyone at the moment...? We'll see how it turns out
	if(user.mind)
		//Chaplains are very good at indoctrinating
		if(user.mind.assigned_role == "Chaplain")
			power_multiplier *= 1.2

	//Cultists are closer to their gods and are better at indoctrinating
	if(IS_CULTIST(user))
		power_multiplier *= 1.2
	else if (IS_CLOCK(user))
		power_multiplier *= 1.2

	//range = 0.5 - 1.4~
	//most cases = 1

	//Try to check if the speaker specified a name or a job to focus on
	var/list/specific_listeners = list()
	var/found_string = null

	//Get the proper job titles
	message = get_full_job_name(message)

	for(var/enthrall_victim in listeners)
		var/mob/living/enthrall_listener = enthrall_victim
		if(findtext(message, enthrall_listener.real_name, 1, length(enthrall_listener.real_name) + 1))
			specific_listeners += enthrall_listener //focus on those with the specified name
			//Cut out the name so it doesn't trigger commands
			found_string = enthrall_listener.real_name
			power_multiplier += 0.5

		else if(findtext(message, first_name(enthrall_listener.real_name), 1, length(first_name(enthrall_listener.real_name)) + 1))
			specific_listeners += enthrall_listener //focus on those with the specified name
			//Cut out the name so it doesn't trigger commands
			found_string = first_name(enthrall_listener.real_name)
			power_multiplier += 0.5

		else if(enthrall_listener.mind && enthrall_listener.mind.assigned_role && findtext(message, enthrall_listener.mind.assigned_role, 1, length(enthrall_listener.mind.assigned_role) + 1))
			specific_listeners += enthrall_listener //focus on those with the specified job
			//Cut out the job so it doesn't trigger commands
			found_string = enthrall_listener.mind.assigned_role
			power_multiplier += 0.25

	if(specific_listeners.len)
		listeners = specific_listeners
		//power_multiplier *= (1 + (1/specific_listeners.len)) //Put this is if it becomes OP, power is judged internally on a thrall, so shouldn't be nessicary.
		message = copytext(message, length(found_string) + 1)//I have no idea what this does

	if(debug == TRUE)
		to_chat(world, "[user]'s power is [power_multiplier].")

	//Mixables
	var/static/regex/enthrall_words = regex("relax|obey|love|serve|so easy|ara ara")
	var/static/regex/reward_words = regex("good boy|good girl|good pet|good job|good")
	var/static/regex/punish_words = regex("bad boy|bad girl|bad pet|bad job|bad")
	//phase 0
	var/static/regex/saymyname_words = regex("say my name|who am i")
	var/static/regex/wakeup_words = regex("revert|awaken|snap|attention")
	//phase1
	var/static/regex/petstatus_words = regex("how are you|what is your status|are you okay")
	var/static/regex/silence_words = regex("shut up|silence|be silent|shh|quiet|hush")
	var/static/regex/speak_words = regex("talk to me|speak")
	var/static/regex/antiresist_words = regex("unable to resist|give in|stop being difficult")//useful if you think your target is resisting a lot
	var/static/regex/resist_words = regex("resist|snap out of it|fight")//useful if two enthrallers are fighting
	var/static/regex/forget_words = regex("forget|muddled|awake and forget")
	var/static/regex/attract_words = regex("come here|come to me|get over here|attract")
	//phase 2
	var/static/regex/sleep_words = regex("sleep|slumber|rest")
	var/static/regex/strip_words = regex("strip|derobe|nude|at ease|suit off")
	var/static/regex/walk_words = regex("slow down|walk")
	var/static/regex/run_words = regex("run|speed up")
	var/static/regex/liedown_words = regex("lie down")
	var/static/regex/knockdown_words = regex("drop|fall|trip|knockdown|kneel|army crawl")
	//phase 3
	var/static/regex/statecustom_words = regex("state triggers|state your triggers")
	var/static/regex/custom_words = regex("new trigger|listen to me")
	var/static/regex/custom_words_words = regex("speak|echo|shock|kneel|strip|trance")//What a descriptive name!
	var/static/regex/custom_echo = regex("obsess|fills your mind|loop")
	var/static/regex/instill_words = regex("feel|entice|overwhelm")
	var/static/regex/recognise_words = regex("recognise me|did you miss me?")
	var/static/regex/objective_words = regex("new objective|obey this command|unable to resist|compelled")
	var/static/regex/heal_words = regex("live|heal|survive|mend|life")
	var/static/regex/stun_words = regex("stop|wait|stand still|hold on|halt")
	var/static/regex/hallucinate_words = regex("get high|hallucinate|trip balls")
	var/static/regex/hot_words = regex("heat|hot|hell")
	var/static/regex/cold_words = regex("cold|cool down|chill|freeze")
	var/static/regex/getup_words = regex("get up|hop to it")
	var/static/regex/pacify_words = regex("docile|complacent|friendly|pacifist")
	var/static/regex/charge_words = regex("charge|oorah|attack")

	var/distance_multiplier = list(2,2,1.5,1.3,1.15,1,0.8,0.6,0.5,0.25)

	//CALLBACKS ARE USED FOR MESSAGES BECAUSE SAY IS HANDLED AFTER THE PROCESSING.

	//Tier 1
	//ENTHRAL mixable (works I think)
	if(findtext(message, enthrall_words))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			power_multiplier *= distance_multiplier[get_dist(user, enthrall_victim)+1]
			if(enthrall_listener == user)
				continue
			if(length(message))
				enthrall_chem.enthrall_tally += (power_multiplier*(((length(message))/200) + 1)) //encourage players to say more than one word.
			else
				enthrall_chem.enthrall_tally += power_multiplier*1.25 //thinking about it, I don't know how this can proc
			if(enthrall_chem.lewd)
				addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='nicegreen'><i><b>[enthrall_chem.enthrall_gender] is so nice to listen to.</b></i></span>"), 5)
			enthrall_chem.cooldown += 1

	//REWARD mixable works
	if(findtext(message, reward_words))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			power_multiplier *= distance_multiplier[get_dist(user, enthrall_victim)+1]
			if(enthrall_listener == user)
				continue
			if (enthrall_chem.lewd)
				addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='love'>[enthrall_chem.enthrall_gender] has praised me!!</span>"), 5)
				if(HAS_TRAIT(enthrall_listener, TRAIT_MASOCHISM))
					enthrall_chem.enthrall_tally -= power_multiplier
					enthrall_chem.resistance_tally += power_multiplier
					enthrall_chem.cooldown += 1
			else
				addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='nicegreen'><b><i>I've been praised for doing a good job!</b></i></span>"), 5)
			enthrall_chem.resistance_tally -= power_multiplier
			enthrall_chem.enthrall_tally += power_multiplier
			var/descmessage = "<span class='love'><i>[(enthrall_chem.lewd?"I feel so happy! I'm a good pet who [enthrall_chem.enthrall_gender] loves!":"I did a good job!")]</i></span>"
			enthrall_listener.add_mood_event("enthrallpraise", /datum/mood_event/enthrallpraise, descmessage)
			enthrall_chem.cooldown += 1

	//PUNISH mixable  works
	else if(findtext(message, punish_words))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			var/descmessage = "[(enthrall_chem.lewd?"I've failed [enthrall_chem.enthrall_gender]... What a bad, bad pet!":"I did a bad job...")]"
			if(enthrall_listener == user)
				continue
			if (enthrall_chem.lewd)
				if(HAS_TRAIT(enthrall_listener, TRAIT_MASOCHISM))
					if(ishuman(enthrall_listener))
						var/mob/living/carbon/human/humanoid = enthrall_listener
						humanoid.adjust_arousal(3*power_multiplier)
					descmessage += "And yet, it feels so good..!</span>" //I don't really understand masco, is this the right sort of thing they like?
					enthrall_chem.enthrall_tally += power_multiplier
					enthrall_chem.resistance_tally -= power_multiplier
					addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='love'>I've let [enthrall_chem.enthrall_gender] down...!</b></span>"), 5)
				else
					addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='warning'>I've let [enthrall_chem.enthrall_gender] down...</b></span>"), 5)
			else
				addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='warning'>I've failed [enthrall_chem.enthrall_mob]...</b></span>"), 5)
				enthrall_chem.resistance_tally += power_multiplier
				enthrall_chem.enthrall_tally += power_multiplier
				enthrall_chem.cooldown += 1
			enthrall_listener.add_mood_event("enthrallscold", /datum/mood_event/enthrallscold, descmessage)
			enthrall_chem.cooldown += 1



	//tier 0
	//SAY MY NAME works
	if((findtext(message, saymyname_words)))
		for(var/enthrall_victim in listeners)
			var/mob/living/carbon/carbon_mob = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = carbon_mob.has_status_effect(/datum/status_effect/chem/enthrall)
			REMOVE_TRAIT(carbon_mob, TRAIT_MUTE, "enthrall")
			if(enthrall_chem.lewd)
				addtimer(CALLBACK(carbon_mob, /atom/movable/proc/say, "[enthrall_chem.enthrall_gender]"), 5)
			else
				addtimer(CALLBACK(carbon_mob, /atom/movable/proc/say, "[enthrall_chem.enthrall_mob]"), 5)

	//WAKE UP
	else if((findtext(message, wakeup_words)))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			enthrall_listener.SetSleeping(0)//Can you hear while asleep?
			switch(enthrall_chem.phase)
				if(0)
					enthrall_chem.phase = 3
					enthrall_chem.status = null
					user.emote("snap")
					if(enthrall_chem.lewd)
						addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='big warning'>The snapping of your [enthrall_chem.enthrall_gender]'s fingers brings you back to your enthralled state, obedient and ready to serve.</b></span>"), 5)
					else
						addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='big warning'>The snapping of [enthrall_chem.enthrall_mob]'s fingers brings you back to being under their influence.</b></span>"), 5)
					to_chat(user, "<span class='notice'><i>You wake up [enthrall_listener]!</i></span>")

	//tier 1

	//PETSTATUS i.e. how they are
	else if((findtext(message, petstatus_words)))
		for(var/enthrall_victim in listeners)
			var/mob/living/carbon/human/humanoid = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
			REMOVE_TRAIT(humanoid, TRAIT_MUTE, "enthrall")
			var/speaktrigger = ""
			//phase
			switch(enthrall_chem.phase)
				if(0)
					continue
				if(1)
					addtimer(CALLBACK(humanoid, /atom/movable/proc/say, "I feel happy being with you."), 5)
					continue
				if(2)
					speaktrigger += "[(enthrall_chem.lewd?"I think I'm in love with you... ":"I find you really inspirational, ")]" //'
				if(3)
					speaktrigger += "[(enthrall_chem.lewd?"I'm devoted to being your pet":"I'm commited to following your cause!")]! "
				if(4)
					speaktrigger += "[(enthrall_chem.lewd?"You are my whole world and all of my being belongs to you, ":"I cannot think of anything else but aiding your cause, ")] "//Redflags!!

			//mood
			if(humanoid.mob_mood)
				switch(humanoid.mob_mood.sanity_level)
					if(SANITY_GREAT to INFINITY)
						speaktrigger += "I'm beyond elated!! " //did you mean byond elated? hohoho
					if(SANITY_NEUTRAL to SANITY_GREAT)
						speaktrigger += "I'm really happy! "
					if(SANITY_DISTURBED to SANITY_NEUTRAL)
						speaktrigger += "I'm a little sad, "
					if(SANITY_UNSTABLE to SANITY_DISTURBED)
						speaktrigger += "I'm really upset, "
					if(SANITY_CRAZY to SANITY_UNSTABLE)
						speaktrigger += "I'm about to fall apart without you! "
					if(SANITY_INSANE to SANITY_CRAZY)
						speaktrigger += "Hold me, please.. "

			//withdrawl_active
			switch(enthrall_chem.withdrawl_progress)
				if(10 to 36) //denial
					speaktrigger += "I missed you, "
				if(36 to 66) //barganing
					speaktrigger += "I missed you, but I knew you'd come back for me! "
				if(66 to 90) //anger
					speaktrigger += "I couldn't take being away from you like that, "
				if(90 to 140) //depression
					speaktrigger += "I was so scared you'd never come back, "
				if(140 to INFINITY) //acceptance
					speaktrigger += "I'm hurt that you left me like that... I felt so alone... "

			//hunger
			switch(humanoid.nutrition)
				if(0 to NUTRITION_LEVEL_STARVING)
					speaktrigger += "I'm famished, please feed me..! "
				if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
					speaktrigger += "I'm so hungry... "
				if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
					speaktrigger += "I'm hungry, "
				if(NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
					speaktrigger += "I'm sated, "
				if(NUTRITION_LEVEL_WELL_FED to NUTRITION_LEVEL_FULL)
					speaktrigger += "I've a full belly! "
				if(NUTRITION_LEVEL_FULL to INFINITY)
					speaktrigger += "I'm fat... "

			//health
			switch(humanoid.health)
				if(100 to INFINITY)
					speaktrigger += "I feel fit, "
				if(80 to 99)
					speaktrigger += "I ache a little bit, "
				if(40 to 80)
					speaktrigger += "I'm really hurt, "
				if(0 to 40)
					speaktrigger += "I'm in a lot of pain, help! "
				if(-INFINITY to 0)
					speaktrigger += "I'm barely concious and in so much pain, please help me! "
			//toxin
			switch(humanoid.get_tox_loss())
				if(10 to 30)
					speaktrigger += "I feel a bit queasy... "
				if(30 to 60)
					speaktrigger += "I feel nauseous... "
				if(60 to INFINITY)
					speaktrigger += "My head is pounding and I feel like I'm going to be sick... "
			//oxygen
			if (humanoid.get_oxy_loss() >= 25)
				speaktrigger += "I can't breathe! "
			//deaf..?
			if (HAS_TRAIT(humanoid, TRAIT_DEAF))//How the heck you managed to get here I have no idea, but just in case!
				speaktrigger += "I can barely hear you! "
			//And the brain damage. And the brain damage. And the brain damage. And the brain damage. And the brain damage.
			switch(humanoid.get_organ_loss(ORGAN_SLOT_BRAIN))
				if(20 to 40)
					speaktrigger += "I have a mild head ache, "
				if(40 to 80)
					speaktrigger += "I feel disorentated and confused, "
				if(80 to 120)
					speaktrigger += "My head feels like it's about to explode, "
				if(120 to 160)
					speaktrigger += "You are the only thing keeping my mind sane, "
				if(160 to INFINITY)
					speaktrigger += "I feel like I'm on the brink of losing my mind, "

			//collar
			if(humanoid.wear_neck?.kink_collar == TRUE && enthrall_chem.lewd)
				speaktrigger += "I love the collar you gave me, "
			//End
			if(enthrall_chem.lewd)
				speaktrigger += "[enthrall_chem.enthrall_gender]!"
			else
				speaktrigger += "[first_name(user.real_name)]!"
			//say it!
			addtimer(CALLBACK(humanoid, /atom/movable/proc/say, "[speaktrigger]"), 5)
			enthrall_chem.cooldown += 1

	//SILENCE
	else if((findtext(message, silence_words)))
		for(var/mob/living/carbon/carbon_mob in listeners)
			var/datum/status_effect/chem/enthrall/enthrall_chem = carbon_mob.has_status_effect(/datum/status_effect/chem/enthrall)
			power_multiplier *= distance_multiplier[get_dist(user, carbon_mob)+1]
			if (enthrall_chem.phase >= 3) //If target is fully enthralled,
				ADD_TRAIT(carbon_mob, TRAIT_MUTE, "enthrall")
			else
				carbon_mob.adjust_silence((10 SECONDS * power_multiplier) * enthrall_chem.phase)
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, carbon_mob, "<span class='notice'>You are unable to speak!</b></span>"), 5)
			to_chat(user, "<span class='notice'><i>You silence [carbon_mob].</i></span>")
			enthrall_chem.cooldown += 3

	//SPEAK
	else if((findtext(message, speak_words)))//fix
		for(var/mob/living/carbon/carbon_mob in listeners)
			var/datum/status_effect/chem/enthrall/enthrall_chem = carbon_mob.has_status_effect(/datum/status_effect/chem/enthrall)
			REMOVE_TRAIT(carbon_mob, TRAIT_MUTE, "enthrall")
			carbon_mob.set_silence(0 SECONDS)
			enthrall_chem.cooldown += 3
			to_chat(user, "<span class='notice'><i>You [(enthrall_chem.lewd?"allow [carbon_mob] to speak again":"encourage [carbon_mob] to speak again")].</i></span>")


	//Antiresist
	else if((findtext(message, antiresist_words)))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			enthrall_chem.status = "Antiresist"
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='big warning'>Your mind clouds over, as you find yourself unable to resist!</b></span>"), 5)
			enthrall_chem.status_strength = (1 * power_multiplier * enthrall_chem.phase)
			enthrall_chem.cooldown += 15//Too short? yes, made 15
			to_chat(user, "<span class='notice'><i>You frustrate [enthrall_listener]'s attempts at resisting.</i></span>")

	//RESIST
	else if((findtext(message, resist_words)))
		for(var/mob/living/carbon/carbon_mob in listeners)
			var/datum/status_effect/chem/enthrall/enthrall_chem = carbon_mob.has_status_effect(/datum/status_effect/chem/enthrall)
			power_multiplier *= distance_multiplier[get_dist(user, carbon_mob)+1]
			enthrall_chem.delta_resist += (power_multiplier)
			enthrall_chem.owner_resist()
			enthrall_chem.cooldown += 2
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, carbon_mob, "<span class='notice'>You are spurred into resisting from [user]'s words!'</b></span>"), 5)
			to_chat(user, "<span class='notice'><i>You spark resistance in [carbon_mob].</i></span>")

	//FORGET (A way to cancel the process)
	else if((findtext(message, forget_words)))
		for(var/mob/living/carbon/carbon_mob in listeners)
			var/datum/status_effect/chem/enthrall/enthrall_chem = carbon_mob.has_status_effect(/datum/status_effect/chem/enthrall)
			if(enthrall_chem.phase == 4)
				addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, carbon_mob, "<span class='warning'>You're unable to forget about [(enthrall_chem.lewd?"the dominating presence of [enthrall_chem.enthrall_gender]":"[enthrall_chem.enthrall_mob]")]!</b></span>"), 5)
				continue
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, carbon_mob, "<span class='warning'>You wake up, forgetting everything that just happened. You must've dozed off..? How embarassing!</b></span>"), 5)
			carbon_mob.Sleeping(50)
			switch(enthrall_chem.phase)
				if(1 to 2)
					enthrall_chem.phase = -1
					to_chat(carbon_mob, "<span class='big warning'>You have no recollection of being enthralled by [enthrall_chem.enthrall_mob]!</b></span>")
					to_chat(user, "<span class='notice'><i>You revert [carbon_mob] back to their state before enthrallment.</i></span>")
				if(3)
					enthrall_chem.phase = 0
					enthrall_chem.cooldown = 0
					if(enthrall_chem.lewd)
						addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, carbon_mob, "<span class='big warning'>You revert to yourself before being enthralled by your [enthrall_chem.enthrall_gender], with no memory of what happened.</b></span>"), 5)
					else
						addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, carbon_mob, "<span class='big warning'>You revert to who you were before, with no memory of what happened with [enthrall_chem.enthrall_mob].</b></span>"), 5)
					to_chat(user, "<span class='notice'><i>You put [carbon_mob] into a sleeper state, ready to turn them back at the snap of your fingers.</i></span>")

	//ATTRACT
	else if((findtext(message, attract_words)))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			enthrall_listener.throw_at(get_step_towards(user,enthrall_listener), 3 * power_multiplier, 1 * power_multiplier)
			enthrall_chem.cooldown += 3
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='notice'>You are drawn towards [user]!</b></span>"), 5)
			to_chat(user, "<span class='notice'><i>You draw [enthrall_listener] towards you!</i></span>")

	//SLEEP
	else if((findtext(message, sleep_words)))
		for(var/mob/living/carbon/carbon_mob in listeners)
			var/datum/status_effect/chem/enthrall/enthrall_chem = carbon_mob.has_status_effect(/datum/status_effect/chem/enthrall)
			switch(enthrall_chem.phase)
				if(2 to INFINITY)
					carbon_mob.Sleeping(45 * power_multiplier)
					enthrall_chem.cooldown += 10
					addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, carbon_mob, "<span class='notice'>Drowsiness suddenly overwhelms you as you fall asleep!</b></span>"), 5)
					to_chat(user, "<span class='notice'><i>You send [carbon_mob] to sleep.</i></span>")

	//STRIP
	else if((findtext(message, strip_words)))
		for(var/enthrall_victim in listeners)
			var/mob/living/carbon/human/humanoid = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
			switch(enthrall_chem.phase)
				if(2 to INFINITY)
					var/items = humanoid.get_contents()
					for(var/obj/item/W in items)
						if(W == humanoid.wear_suit)
							humanoid.dropItemToGround(W, TRUE)
							return
						if(W == humanoid.w_uniform && W != humanoid.wear_suit)
							humanoid.dropItemToGround(W, TRUE)
							return
					addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, "<span class='[(enthrall_chem.lewd?"love":"warning")]'>Before you can even think about it, you quickly remove your clothes in response to [(enthrall_chem.lewd?"your [enthrall_chem.enthrall_gender]'s command'":"[enthrall_chem.enthrall_mob]'s directive'")].</b></span>"), 5)
					enthrall_chem.cooldown += 10

	//WALK
	else if((findtext(message, walk_words)))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			switch(enthrall_chem.phase)
				if(2 to INFINITY)
					if(enthrall_listener.move_intent != MOVE_INTENT_WALK)
						enthrall_listener.toggle_move_intent()
						enthrall_chem.cooldown += 1
						addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='notice'>You slow down to a walk.</b></span>"), 5)
						to_chat(user, "<span class='notice'><i>You encourage [enthrall_listener] to slow down.</i></span>")

	//RUN
	else if((findtext(message, run_words)))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			switch(enthrall_chem.phase)
				if(2 to INFINITY)
					if(enthrall_listener.move_intent != MOVE_INTENT_RUN)
						enthrall_listener.toggle_move_intent()
						enthrall_chem.cooldown += 1
						addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='notice'>You speed up into a jog!</b></span>"), 5)
						to_chat(user, "<span class='notice'><i>You encourage [enthrall_listener] to pick up the pace!</i></span>")

	//LIE DOWN
	else if(findtext(message, liedown_words))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			switch(enthrall_chem.phase)
				if(2 to INFINITY)
					enthrall_listener.toggle_resting()
					enthrall_chem.cooldown += 10
					addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "[(enthrall_chem.lewd?"<span class='love'>You eagerly lie down!":"<span class='notice'>You suddenly lie down!")]</b></span>"), 5)
					to_chat(user, "<span class='notice'><i>You encourage [enthrall_listener] to lie down.</i></span>")

	//KNOCKDOWN
	else if(findtext(message, knockdown_words))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			switch(enthrall_chem.phase)
				if(2 to INFINITY)
					enthrall_listener.StaminaKnockdown(30 * power_multiplier * enthrall_chem.phase)
					enthrall_chem.cooldown += 8
					addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='notice'>You suddenly drop to the ground!</b></span>"), 5)
					to_chat(user, "<span class='notice'><i>You encourage [enthrall_listener] to drop down to the ground.</i></span>")

	//tier3

	//STATE TRIGGERS
	else if((findtext(message, statecustom_words)))//doesn't work
		for(var/enthrall_victim in listeners)
			var/mob/living/carbon/carbon_mob = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = carbon_mob.has_status_effect(/datum/status_effect/chem/enthrall)
			if (enthrall_chem.phase == 3)
				var/speaktrigger = ""
				carbon_mob.emote("me", EMOTE_VISIBLE, "whispers something quietly.")
				if (get_dist(user, carbon_mob) > 1)//Requires user to be next to their pet.
					to_chat(user, "<span class='warning'>You need to be next to your pet to hear them!</b></span>")
					continue
				for (var/trigger in enthrall_chem.custom_triggers)
					speaktrigger += "[trigger], "
				to_chat(user, "<b>[carbon_mob]</b> whispers, \"<i>[speaktrigger] are my triggers.</i>\"")//So they don't trigger themselves!
				addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, carbon_mob, "<span class='notice'>You whisper your triggers to [(enthrall_chem.lewd?"Your [enthrall_chem.enthrall_gender]":"[enthrall_chem.enthrall_mob]")].</span>"), 5)


	//CUSTOM TRIGGERS
	else if((findtext(message, custom_words)))
		for(var/enthrall_victim in listeners)
			var/mob/living/carbon/human/humanoid = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
			if(enthrall_chem.phase == 3)
				if (get_dist(user, humanoid) > 1)//Requires user to be next to their pet.
					to_chat(user, "<span class='warning'>You need to be next to your pet to give them a new trigger!</b></span>")
					continue
				if(!enthrall_chem.lewd)
					to_chat(user, "<span class='warning'>[humanoid] seems incapable of being implanted with triggers.</b></span>")
					continue
				else
					user.emote("me", EMOTE_VISIBLE, "puts their hands upon [humanoid.name]'s head and looks deep into their eyes, whispering something to them.")
					user.SetStun(1000)//Hands are handy, so you have to stay still
					humanoid.SetStun(1000)
					if (enthrall_chem.mental_capacity >= 5)
						var/trigger = html_decode(stripped_input(user, "Enter the trigger phrase", MAX_MESSAGE_LEN))
						var/custom_words_words_list = list("Speak", "Echo", "Shock", "Kneel", "Strip", "Trance", "Cancel")
						var/trigger2 = input(user, "Pick an effect", "Effects") in custom_words_words_list
						trigger2 = LOWER_TEXT(trigger2)
						if ((findtext(trigger2, custom_words_words)))
							if (trigger2 == "speak" || trigger2 == "echo")
								var/trigger3 = html_decode(stripped_input(user, "Enter the phrase spoken. Abusing this to self antag is bannable.", MAX_MESSAGE_LEN))
								enthrall_chem.custom_triggers[trigger] = list(trigger2, trigger3)
								if(findtext(trigger3, "admin"))
									message_admins("FERMICHEM: [user] maybe be trying to abuse MKUltra by implanting by [humanoid] with [trigger], triggering [trigger2], to send [trigger3].")
							else
								enthrall_chem.custom_triggers[trigger] = trigger2
							enthrall_chem.mental_capacity -= 5
							addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, "<span class='notice'>[(enthrall_chem.lewd?"your [enthrall_chem.enthrall_gender]":"[enthrall_chem.enthrall_mob]")] whispers you a new trigger.</span>"), 5)
							to_chat(user, "<span class='notice'><i>You sucessfully set the trigger word [trigger] in [humanoid]</i></span>")
						else
							to_chat(user, "<span class='warning'>Your pet looks at you confused, it seems they don't understand that effect!</b></span>")
					else
						to_chat(user, "<span class='warning'>Your pet looks at you with a vacant blase expression, you don't think you can program anything else into them</b></span>")
					user.SetStun(0)
					humanoid.SetStun(0)

	//CUSTOM ECHO
	else if((findtext(message, custom_echo)))
		for(var/enthrall_victim in listeners)
			var/mob/living/carbon/human/humanoid = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
			if(enthrall_chem.phase == 3)
				if (get_dist(user, humanoid) > 1)//Requires user to be next to their pet.
					to_chat(user, "<span class='warning'>You need to be next to your pet to give them a new echophrase!</b></span>")
					continue
				if(!enthrall_chem.lewd)
					to_chat(user, "<span class='warning'>[humanoid] seems incapable of being implanted with an echoing phrase.</b></span>")
					continue
				else
					user.emote("me", EMOTE_VISIBLE, "puts their hands upon [humanoid.name]'s head and looks deep into their eyes, whispering something to them.")
					user.SetStun(1000)//Hands are handy, so you have to stay still
					humanoid.SetStun(1000)
					var/trigger = stripped_input(user, "Enter the loop phrase", MAX_MESSAGE_LEN)
					var/custom_span = list("Notice", "Warning", "Hypnophrase", "Love", "Velvet")
					var/trigger2 = input(user, "Pick the style", "Style") in custom_span
					trigger2 = LOWER_TEXT(trigger2)
					enthrall_chem.custom_echo = trigger
					enthrall_chem.custom_span = trigger2
					user.SetStun(0)
					humanoid.SetStun(0)
					to_chat(user, "<span class='notice'><i>You sucessfully set an echoing phrase in [humanoid]</i></span>")

	//CUSTOM OBJECTIVE
	else if((findtext(message, objective_words)))
		for(var/enthrall_victim in listeners)
			var/mob/living/carbon/human/humanoid = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
			if(enthrall_chem.phase == 3)
				if (get_dist(user, humanoid) > 1)//Requires user to be next to their pet.
					to_chat(user, "<span class='warning'>You need to be next to your pet to give them a new objective!</b></span>")
					continue
				else
					user.emote("me", EMOTE_VISIBLE, "puts their hands upon [humanoid.name]'s head and looks deep into their eyes, whispering something to them.'")
					user.SetStun(1000)//So you can't run away!
					humanoid.SetStun(1000)
					if (enthrall_chem.mental_capacity >= 200)
						var/datum/objective/brainwashing/objective = stripped_input(user, "Add an objective to give your pet.", MAX_MESSAGE_LEN)
						if(!LAZYLEN(objective))
							to_chat(user, "<span class='warning'>You can't give your pet an objective to do nothing!</b></span>")
							continue
						//Pets don't understand harm
						objective = replacetext(LOWER_TEXT(objective), "kill", "hug")
						objective = replacetext(LOWER_TEXT(objective), "murder", "cuddle")
						objective = replacetext(LOWER_TEXT(objective), "harm", "snuggle")
						objective = replacetext(LOWER_TEXT(objective), "decapitate", "headpat")
						objective = replacetext(LOWER_TEXT(objective), "strangle", "meow at")
						objective = replacetext(LOWER_TEXT(objective), "suicide", "self-love")
						message_admins("[humanoid] has been implanted by [user] with the objective [objective].")
						addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, "<span class='notice'>[(enthrall_chem.lewd?"Your [enthrall_chem.enthrall_gender]":"[enthrall_chem.enthrall_mob]")] whispers you a new objective.</span>"), 5)
						brainwash(humanoid, objective)
						enthrall_chem.mental_capacity -= 200
						to_chat(user, "<span class='notice'><i>You sucessfully give an objective to [humanoid]</i></span>")
					else
						to_chat(user, "<span class='warning'>Your pet looks at you with a vacant blas expression, you don't think you can program anything else into them</b></span>")
					user.SetStun(0)
					humanoid.SetStun(0)

	//INSTILL
	else if((findtext(message, instill_words)))
		for(var/enthrall_victim in listeners)
			var/mob/living/carbon/human/humanoid = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
			if(enthrall_chem.phase >= 3 && enthrall_chem.lewd)
				var/instill = stripped_input(user, "Instill an emotion in [humanoid].", MAX_MESSAGE_LEN)
				to_chat(humanoid, "<i>[instill]</i>")
				to_chat(user, "<span class='notice'><i>You sucessfully instill a feeling in [humanoid]</i></span>")
				enthrall_chem.cooldown += 1

	//RECOGNISE
	else if((findtext(message, recognise_words)))
		for(var/enthrall_victim in listeners)
			var/mob/living/carbon/human/humanoid = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = humanoid.has_status_effect(/datum/status_effect/chem/enthrall)
			if(enthrall_chem.phase > 1)
				if(user.ckey == enthrall_chem.enthrall_ckey && user.real_name == enthrall_chem.enthrall_mob.real_name)
					enthrall_chem.enthrall_mob = user
					addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, humanoid, "<span class='nicegreen'>[(enthrall_chem.lewd?"You hear the words of your [enthrall_chem.enthrall_gender] again!! They're back!!":"You recognise the voice of [enthrall_chem.enthrall_mob].")]</b></span>"), 5)
					to_chat(user, "<span class='notice'><i>[humanoid] looks at you with sparkling eyes, recognising you!</i></span>")

	//I dunno how to do state objectives without them revealing they're an antag

	//HEAL (maybe make this nap instead?)
	else if(findtext(message, heal_words))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			switch(enthrall_chem.phase)
				if(3)//Tier 3 only
					enthrall_chem.status = "heal"
					enthrall_chem.status_strength = (5 * power_multiplier)
					enthrall_chem.cooldown += 5
					addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='notice'>You begin to lick your wounds.</b></span>"), 5)
					enthrall_listener.Stun(15 * power_multiplier)
					to_chat(user, "<span class='notice'><i>[enthrall_listener] begins to lick their wounds.</i></span>")

	//STUN
	else if(findtext(message, stun_words))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			switch(enthrall_chem.phase)
				if(3 to INFINITY)
					enthrall_listener.Stun(40 * power_multiplier)
					enthrall_chem.cooldown += 8
					addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='notice'>Your muscles freeze up!</b></span>"), 5)
					to_chat(user, "<span class='notice'><i>You cause [enthrall_listener] to freeze up!</i></span>")

	//HALLUCINATE
	else if(findtext(message, hallucinate_words))
		for(var/enthrall_victim in listeners)
			var/mob/living/carbon/carbon_mob = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = carbon_mob.has_status_effect(/datum/status_effect/chem/enthrall)
			switch(enthrall_chem.phase)
				if(3 to INFINITY)
					new /datum/hallucination/delusion(carbon_mob, TRUE, null,150 * power_multiplier,0)
					to_chat(user, "<span class='notice'><i>You send [carbon_mob] on a trip.</i></span>")

	//HOT
	else if(findtext(message, hot_words))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			switch(enthrall_chem.phase)
				if(3 to INFINITY)
					enthrall_listener.adjust_bodytemperature(50 * power_multiplier)//This seems nuts, reduced it, but then it didn't do anything, so I reverted it.
					addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='notice'>You feel your metabolism speed up!</b></span>"), 5)
					to_chat(user, "<span class='notice'><i>You speed [enthrall_listener]'s metabolism up!</i></span>")

	//COLD
	else if(findtext(message, cold_words))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			switch(enthrall_chem.phase)
				if(3 to INFINITY)
					enthrall_listener.adjust_bodytemperature(-50 * power_multiplier)
					addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='notice'>You feel your metabolism slow down!</b></span>"), 5)
					to_chat(user, "<span class='notice'><i>You slow [enthrall_listener]'s metabolism down!</i></span>")

	//GET UP
	else if(findtext(message, getup_words))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			switch(enthrall_chem.phase)
				if(3 to INFINITY)//Tier 3 only
					enthrall_listener.set_resting(FALSE, TRUE, FALSE)
					enthrall_listener.SetAllImmobility(0)
					enthrall_listener.SetUnconscious(0) //i said get up i don't care if you're being tased
					enthrall_chem.cooldown += 10 //This could be really strong
					addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='notice'>You jump to your feet from sheer willpower!</b></span>"), 5)
					to_chat(user, "<span class='notice'><i>You spur [enthrall_listener] to their feet!</i></span>")

	//PACIFY
	else if(findtext(message, pacify_words))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			switch(enthrall_chem.phase)
				if(3)//Tier 3 only
					enthrall_chem.status = "pacify"
					enthrall_chem.cooldown += 10
					addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, enthrall_listener, "<span class='notice'>You feel like never hurting anyone ever again.</b></span>"), 5)
					to_chat(user, "<span class='notice'><i>You remove any intent to harm from [enthrall_listener]'s mind.</i></span>")

	//CHARGE
	else if(findtext(message, charge_words))
		for(var/enthrall_victim in listeners)
			var/mob/living/enthrall_listener = enthrall_victim
			var/datum/status_effect/chem/enthrall/enthrall_chem = enthrall_listener.has_status_effect(/datum/status_effect/chem/enthrall)
			switch(enthrall_chem.phase)
				if(3)//Tier 3 only
					enthrall_chem.status_strength = 2* power_multiplier
					enthrall_chem.status = "charge"
					enthrall_chem.cooldown += 10
					to_chat(user, "<span class='notice'><i>You rally [enthrall_listener], leading them into a charge!</i></span>")

	if(message_admins || debug)//Do you want this in?
		message_admins("[ADMIN_LOOKUPFLW(user)] has said '[log_message]' with a Velvet Voice, affecting [english_list(listeners)], with a power multiplier of [power_multiplier].")
	SSblackbox.record_feedback("tally", "fermi_chem", 1, "Times people have spoken with a velvet voice")
	//SSblackbox.record_feedback("tally", "Velvet_voice", 1, log_message) If this is on, it fills the thing up and OOFs the server

	return
