/// Lewd Toys box
/obj/item/storage/box/lewd_toys/PopulateContents()
	. = ..()
	new /obj/item/storage/box/portal_fleshlight(src)

/// Start Plasmaman Envirosuit Boxes
/// Orange

/obj/item/storage/box/envirosuit
	name = "orange envirosuit kit"
	desc = "A box containing a complete plasmaman envirosuit in a garish orange. For the most average of bones."

/obj/item/storage/box/envirosuit/PopulateContents()
	new /obj/item/clothing/under/plasmaman(src)
	new /obj/item/clothing/head/helmet/space/plasmaman(src)
	new /obj/item/clothing/gloves/color/plasmaman(src)

/// Slacks

/obj/item/storage/box/envirosuit/slacks
	name = "enviroslacks kit"
	desc = "A box containing a complete set of plasmaman's formals. For the fanciest of bones."

/obj/item/storage/box/envirosuit/slacks/PopulateContents()
	new /obj/item/clothing/under/plasmaman/enviroslacks(src)
	new /obj/item/clothing/head/helmet/space/plasmaman/white(src)
	new /obj/item/clothing/gloves/color/plasmaman/white(src)

/// White

/obj/item/storage/box/envirosuit/white
	name = "white envirosuit kit"
	desc = "A box containing a complete plasmaman envirosuit in white. For the brightest of bones."

/obj/item/storage/box/envirosuit/white/PopulateContents()
	new /obj/item/clothing/under/plasmaman/white(src)
	new /obj/item/clothing/head/helmet/space/plasmaman/white(src)
	new /obj/item/clothing/gloves/color/plasmaman/white(src)

/// Black

/obj/item/storage/box/envirosuit/black
	name = "black envirosuit kit"
	desc = "A box containing a complete plasmaman envirosuit in black. For the edgiest of bones."

/obj/item/storage/box/envirosuit/black/PopulateContents()
	new /obj/item/clothing/under/plasmaman/black(src)
	new /obj/item/clothing/head/helmet/space/plasmaman/black(src)
	new /obj/item/clothing/gloves/color/plasmaman/black(src)

/// Khaki

/obj/item/storage/box/envirosuit/khaki
	name = "khaki envirosuit kit"
	desc = "A box containing a complete plasmaman envirosuit in a drab khaki. For the most adventurous of bones."

/obj/item/storage/box/envirosuit/khaki/PopulateContents()
	new /obj/item/clothing/under/plasmaman/khaki(src)
	new /obj/item/clothing/head/helmet/space/plasmaman/khaki(src)
	new /obj/item/clothing/gloves/color/plasmaman/explorer(src)

/// Prototype

/obj/item/storage/box/envirosuit/prototype
	name = "prototype envirosuit kit"
	desc = "A box containing a complete prototype plasmaman envirosuit. For the most nostalgic of bones."

/obj/item/storage/box/envirosuit/prototype/PopulateContents()
	new /obj/item/clothing/under/plasmaman/prototype(src)
	new /obj/item/clothing/head/helmet/space/plasmaman/prototype(src)
	new /obj/item/clothing/gloves/color/plasmaman/prototype(src)

/// End Plasmaman Envirosuit Boxes
