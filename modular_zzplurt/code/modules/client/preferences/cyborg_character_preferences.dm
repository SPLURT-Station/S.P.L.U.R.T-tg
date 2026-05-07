/datum/preferences
	var/atom/movable/screen/map_view/cyborg_character_preview/cyborg_character_preview_view

	var/cyborg_character_preview_model
	var/cyborg_character_preview_department
	var/cyborg_character_preview_state = "idle"
	var/cyborg_character_preview_dir = "south"
	var/cyborg_character_play_animation = FALSE
	/// Preview-only cyborg genital arousal overrides, keyed by organ slot.
	var/list/cyborg_character_preview_arousal_states
	/// Draft state for cyborg character genital layout edits.
	var/list/cyborg_character_layout_draft_store
	/// Whether the current cyborg layout draft needs to be persisted.
	var/cyborg_character_layout_draft_dirty = FALSE
	/// Timer handle used to debounce cyborg layout saves.
	var/cyborg_character_layout_commit_timer

/datum/preferences/proc/create_cyborg_character_preview_view(mob/user)
	cyborg_character_preview_view = new(null, src)
	cyborg_character_preview_view.generate_view("cyborg_character_preview_[REF(cyborg_character_preview_view)]")
	cyborg_character_preview_view.update_body()
	return cyborg_character_preview_view

/datum/preferences/proc/commit_middleware_ui_state(mob/user)
	for(var/datum/preference_middleware/preference_middleware as anything in middleware)
		preference_middleware.flush_ui_state(user)

/datum/preferences/proc/cyborg_character_cleanup_state()
	QDEL_NULL(cyborg_character_preview_view)
	cyborg_character_preview_arousal_states = null
	cyborg_character_layout_draft_store = null
	cyborg_character_layout_draft_dirty = FALSE
	if(cyborg_character_layout_commit_timer)
		deltimer(cyborg_character_layout_commit_timer)
		cyborg_character_layout_commit_timer = null
