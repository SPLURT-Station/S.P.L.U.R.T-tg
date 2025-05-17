/obj/item/storage/box/syndicate/horse_box
	name = "A pony box"
	desc = "This is a set containing a syndicate pony cube and an apple, for the best cowboys in the wild station! Don't make an apple pie!"
	icon_state = "syndiebox"
	illustration = "writing_syndie"

/obj/item/storage/box/syndicate/horse_box/PopulateContents()
	new /obj/item/food/monkeycube/dangerous_horse(src)
	new /obj/item/slimepotion/slime/sentience/nuclear/dangerous_horse(src)
	new /obj/item/food/grown/apple(src)
