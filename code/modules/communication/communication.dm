// This file is part of the S.P.L.U.R.T. Station codebase.
// For license information, see the LICENSE file at the root of the repository.

/datum/controller/communication
	var/muted_channels = list()
	var/muted_all = FALSE

	proc/toggle_all_comms(mob/user)
		muted_all = !muted_all
		if muted_all
			to_chat(user, "<span class='boldgood'>All communications have been muted.</span>")
		else
			to_chat(user, "<span class='boldgood'>All communications have been unmuted.</span>")

	proc/is_muted(channel)
		return muted_all || channel in muted_channels

	proc/mute_channel(channel, mob/user)
		if channel in muted_channels
			return
		muted_channels.Add(channel)
		to_chat(user, "<span class='boldgood'>Channel '[channel]' has been muted.</span>")

	proc/unmute_channel(channel, mob/user)
		if channel not in muted_channels
			return
		muted_channels.Remove(channel)
		to_chat(user, "<span class='boldgood'>Channel '[channel]' has been unmuted.</span>")

	proc/send_message(channel, message, sender, message_type)
		var/msg_format = "<span class='chat_channel_[channel]'>[sender]:</span> [message]"
		var/broadcast_message = TRUE

		// Check if the channel is muted for the sender
		if is_muted(channel)
			broadcast_message = FALSE

		// If the message is not muted, broadcast it
		if broadcast_message
			SSmessage.SendBroadcast(channel, msg_format, sender, message_type)


// Global communication controller instance
var/global/comm_controller = new /datum/controller/communication

// Command to toggle all comms
/client/command/toggle_comms(message)
	var/mob/user = usr
	// Ensure the user is a mob and has a connection
	if (!user || !user.client)
		return

	// Check if the user is alive to prevent abuse
	if (user.stat != CONSCIOUS)
		to_chat(user, "<span class='boldalert'>You must be conscious to toggle communications.</span>")
		return

	comm_controller.toggle_all_comms(user)
