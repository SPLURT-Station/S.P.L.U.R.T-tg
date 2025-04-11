/datum/asset/changelog_item/New(date)
	. = ..()
	item_filename = SANITIZE_FILENAME("[date].yml")
	SSassets.transport.register_asset("splurt_[item_filename]", file("html/changelogs/splurt_archive/" + item_filename)) // SPLURT EDIT ADDITION: Changelog 3

/datum/asset/changelog_item/send(client)
	. = ..()
	if(!.)
		return
	. = SSassets.transport.send_assets(client, "splurt_[item_filename]")

/datum/asset/changelog_item/get_url_mappings()
	. = ..()
	LAZYADD(., list("splurt_[item_filename]" = SSassets.transport.get_asset_url("splurt_[item_filename]")))

/datum/asset/changelog_item/unregister()
	. = ..()
	if(!item_filename)
		return
	SSassets.transport.unregister_asset("splurt_[item_filename]")
