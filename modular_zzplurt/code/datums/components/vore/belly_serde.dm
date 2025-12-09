/obj/vore_belly/serialize()
	. = ..()
	.["autotransfer_enabled"] = autotransfer_enabled
	.["autotransfer_delay"] = autotransfer_delay
	// Note: autotransfer_target is not serialized, it's set by name/index after load

/obj/vore_belly/deserialize(list/data)
	. = ..()
	autotransfer_enabled = sanitize_integer(data["autotransfer_enabled"], FALSE, TRUE, FALSE)
	autotransfer_delay = sanitize_integer(data["autotransfer_delay"], 10, 3000, 600) // 1 second to 5 minutes, default 60 seconds
