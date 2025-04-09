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

// Oviposition egg, logic is at the pregnancy component
/obj/item/food/egg/oviposition
	name = "peculiar egg"
	desc = "An egg, this one looks suspiciously large though."
	icon = 'modular_zzplurt/icons/obj/lewd/egg.dmi'
	icon_state = "egg"
	base_icon_state = "egg"
	w_class = WEIGHT_CLASS_HUGE
	obj_flags = parent_type::obj_flags | UNIQUE_RENAME

/obj/item/food/egg/oviposition/spawn_impact_chick(turf/spawn_turf)
	/* redo this with new epic pregnant component
	var/datum/component/pregnancy/pregnancy = GetComponent(/datum/component/pregnancy)
	if(!pregnancy)
		return
	var/baby_type_name
	if(ispath(pregnancy.baby_type, /mob/living/carbon/human))
		baby_type_name = LOWER_TEXT(pregnancy.mother_dna.species.name)
	baby_type_name ||= pregnancy.baby_type::name
	visible_message(span_notice("\A [baby_type_name] comes out of the cracked egg!"))
	pregnancy.give_birth(loc)
	*/
