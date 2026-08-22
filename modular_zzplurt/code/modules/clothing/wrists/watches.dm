/obj/item/clothing/wrists/clockwork_watch
	name = "steampunk watch"
	desc = "A stylish steampunk watch made out of thousands of tiny cogwheels."
	gender = MALE
	icon_state = "clockwork_slab"
	body_parts_covered = HAND_LEFT | ARM_LEFT
	attack_verb_simple = list("showed the time to")

/obj/item/clothing/wrists/clockwork_watch/examine(mob/user)
	. = ..()
	. += span_info("Station Time: [server_timestamp(ic_time = TRUE, twelve_hour_clock = user.client?.prefs.read_preference(/datum/preference/toggle/twelve_hour))]")
	if(user.is_literate())
		. += span_info("That means it is currently [round_timestamp()] into the shift.")

/obj/item/clothing/wrists/clockwork_watch/attack(mob/target, mob/user)
	. = ..()
	to_chat(target, span_info("Station Time: [server_timestamp(ic_time = TRUE, twelve_hour_clock = user.client?.prefs.read_preference(/datum/preference/toggle/twelve_hour))]"))
