GLOBAL_LIST_INIT(pregnancy_egg_skins, list( \
	"Xenomorph" = "xenomorph",\
	"Rotten" = "badrecipe",\
	"Chocolate" = "chocolate",\
	"Pellet" = "pellet",\
	"Rock" = "rock",\
	"Chicken" = "chicken",\
	"Slime" = "slimeglob",\
	"Toy" = "synthetic",\
	"Escape pod" = "escapepod",\
	"Cocoon" = "cocoon",\
	"Bug cocoon" = "bugcocoon",\
	"Yellow" = "yellow",\
	"Blue" = "blue",\
	"Green" = "green",\
	"Orange" = "orange",\
	"Purple" = "purple",\
	"Red" = "red",\
	"Rainbow" = "rainbow",\
	"Pink" = "pink",\
	"Honeycomb" = "honeycomb",\
	"Floppy" = "floppy",\
	"File" = "file",\
	"CD" = "cd",\
	"Spider cluster" = "spidercluster",\
	"Dragon" = "dragon",\
	"Corrupted" = "corrupteddemon",\
	"Holy" = "holy",\
	"Fish Cluster" = "fish",\
	"Insectoid" = "insectoid",\
	"Ashwalker" = "ashwalker",\
	"Void" = "void",\
	"Polychrome" = "polychrome",\
	"Ratvar" = "ratvar",\
	"Hybrid" = "hybrid",\
))

// Oviposition egg, most logic is at the pregnancy status effect and pregnant component
/obj/item/food/egg/oviposition
	name = "peculiar egg"
	desc = "An egg, this one looks suspiciously large though."
	icon = 'modular_zzplurt/icons/obj/lewd/egg.dmi'
	icon_state = "egg"
	base_icon_state = "egg"
	w_class = WEIGHT_CLASS_HUGE
	obj_flags = parent_type::obj_flags | UNIQUE_RENAME
	uses_integrity = TRUE
	integrity_failure = 0.5

/obj/item/food/egg/oviposition/update_icon_state()
	. = ..()
	icon_state = base_icon_state
	if(get_integrity_percentage() < integrity_failure)
		icon_state += "_broken"

/obj/item/food/egg/oviposition/atom_break(damage_flag)
	. = ..()
	update_appearance(UPDATE_ICON)
