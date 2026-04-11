// This file contains robot model definitions and sprite configurations

/obj/item/robot_model
	var/name = "robot model"
	var/basic_modules = list()
	var/emag_modules = list()
	var/cyborg_base_icon = "robot"
	var/cyborg_icon_override
	var/model_select_icon = "standard"
	var/hat_offset = 0
	var/special_light_key
	var/canDispose = 0
	var/allowed_items = list()
	var/list/cyborg_belly_sprites = list() // New variable for belly sprites

/obj/item/robot_model/dog
	name = "dog"
	cyborg_base_icon = "dog"
	model_select_icon = "dog"
	hat_offset = -4
	cyborg_belly_sprites = list("belly_dog" = "icons/mob/cyborgs/belly_dog.dmi") // Add belly sprite support
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/robot_tongue,
		/obj/item/crowbar/cyborg,
		/obj/item/extinguisher/mini,
		/obj/item/hand_labeler/cyborg,
		/obj/item/wrench/cyborg,
		/obj/item/multitool/cyborg,
		/obj/item/radio/cyborg,
		/obj/item/dogborg/jaws,
		/obj/item/dogborg/pounce,
		/obj/item/dogborg/sleeper
	)

/obj/item/robot_model/proc/get_belly_sprite(sprite_name)
	if(sprite_name in cyborg_belly_sprites)
		return cyborg_belly_sprites[sprite_name]
	return null
