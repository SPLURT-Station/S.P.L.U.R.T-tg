/obj/vore_belly/serialize()
	. = ..()
	.["autotransfer_enabled"] = autotransfer_enabled
	.["autotransfer_delay"] = autotransfer_delay
	// Note: autotransfer_target is not serialized, it's set by name/index after load

/obj/vore_belly/deserialize(list/data)
	. = ..()
	if(!.)
		return FALSE

	var/saved_autotransfer_enabled = data["autotransfer_enabled"]
	if(isnum(saved_autotransfer_enabled) && (saved_autotransfer_enabled == FALSE || saved_autotransfer_enabled == TRUE))
		autotransfer_enabled = saved_autotransfer_enabled
	else
		autotransfer_enabled = FALSE

	var/saved_autotransfer_delay = data["autotransfer_delay"]
	if(isnum(saved_autotransfer_delay))
		autotransfer_delay = clamp(saved_autotransfer_delay, 10, 3000)
	else
		autotransfer_delay = 600

	return TRUE
