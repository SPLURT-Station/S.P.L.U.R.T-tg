/datum/unit_test/defined_inhand_icon_states
	/// additional_inhands_location is for downstream modularity support. as an example, for skyrat's usage, set additional_inhands_location = "modular_skyrat/master_files/icons/mob/inhands/"
	/// Make sure this location is also present in tools/deploy.sh
	/// If you need additional paths ontop of this second one, you can add another generate_possible_icon_states_list("your/folder/path/inhands/") below the if(additional_inhands_location) block in Run(), and make sure to add that path to tools/deploy.sh as well.
	additional_inhands_location = "modular_zzplurt/events/"

/datum/unit_test/missing_icons
	/// additional_icon_location is for downstream modularity support.
	/// Make sure this location is also present in tools/deploy.sh
	/// If you need additional paths ontop of this second one, you can add another generate_possible_icon_states_list("your/folder/path/") below the if(additional_icon_location) block in Run(), and make sure to add that path to tools/deploy.sh as well.
	additional_icon_location = "modular_zzplurt/events/"

/datum/unit_test/worn_icons
	/// additional_icon_location is for downstream modularity support for finding missing sprites in additonal DMI file locations.
	/// Make sure this location is also present in tools/deploy.sh
	/// If you need additional paths ontop of this second one, you can add another generate_possible_icon_states_list("your/folder/path/") below the if(additional_icon_location) block in Run(), and make sure to add that path to tools/deploy.sh as well.
	additional_icon_location = "modular_zzplurt/events/"
