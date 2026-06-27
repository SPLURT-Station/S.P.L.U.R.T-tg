/obj/item/clothing/accessory/pro_skub_pin
	name = "\improper Pro-Skub Pin"
	desc = "A pin to show off your pro-skub stance!"
	icon = 'modular_zzplurt/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/accessories.dmi'
	icon_state = "pin_yellow"
	inhand_icon_state = null

/obj/item/clothing/accessory/pro_skub_pin/can_attach_accessory(obj/item/clothing/under/attach_to, mob/living/user)
	. = ..()
	if(!.)
		return
	if(locate(/obj/item/clothing/accessory/anti_skub_pin) in attach_to.attached_accessories || locate(/obj/item/clothing/accessory/clown_enjoyer_pin) in attach_to.attached_accessories || locate(/obj/item/clothing/accessory/mime_fan_pin) in attach_to.attached_accessories)
		if(user)
			attach_to.balloon_alert(user, "can't pick both sides!")
		return FALSE
	return TRUE

/obj/item/clothing/accessory/pro_skub_pin/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	if(HAS_TRAIT(user, TRAIT_PRO_SKUB))
		user.add_mood_event("pro_skub_pin", /datum/mood_event/pro_skub_pin)
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.fan_hud_set_fandom()

/obj/item/clothing/accessory/pro_skub_pin/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	user.clear_mood_event("pro_skub_pin")
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.fan_hud_set_fandom()

/obj/item/clothing/accessory/anti_skub_pin
	name = "\improper Anti-Skub Pin"
	desc = "A pin to show off your anti-skub stance!"
	icon = 'icons/obj/clothing/accessories.dmi'
	worn_icon = 'icons/mob/clothing/accessories.dmi'
	icon_state = "anti_sec"
	inhand_icon_state = null

/obj/item/clothing/accessory/anti_skub_pin/can_attach_accessory(obj/item/clothing/under/attach_to, mob/living/user)
	. = ..()
	if(!.)
		return
	if(locate(/obj/item/clothing/accessory/pro_skub_pin) in attach_to.attached_accessories || locate(/obj/item/clothing/accessory/clown_enjoyer_pin) in attach_to.attached_accessories || locate(/obj/item/clothing/accessory/mime_fan_pin) in attach_to.attached_accessories)
		if(user)
			attach_to.balloon_alert(user, "can't pick both sides!")
		return FALSE
	return TRUE

/obj/item/clothing/accessory/anti_skub_pin/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	if(HAS_TRAIT(user, TRAIT_ANTI_SKUB))
		user.add_mood_event("anti_skub_pin", /datum/mood_event/anti_skub_pin)
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.fan_hud_set_fandom()

/obj/item/clothing/accessory/anti_skub_pin/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	user.clear_mood_event("anti_skub_pin")
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.fan_hud_set_fandom()
