// Ported kegs from S.P.L.U.R.T-Station-13
/obj/structure/reagent_dispensers/keg/mead
	name = "keg of mead"
	desc = "A keg of mead."
	icon = 'modular_zzplurt/icons/obj/objects_kegs.dmi'
	icon_state = "orangekeg"
	reagent_id = /datum/reagent/consumable/ethanol/mead

/obj/structure/reagent_dispensers/keg/milk
	name = "keg of milk"
	desc = "A keg of pasteurised, homogenised, filtered and semi-skimmed space milk."
	icon = 'modular_zzplurt/icons/obj/objects_kegs.dmi'
	icon_state = "whitekeg"
	reagent_id = /datum/reagent/consumable/milk

/obj/structure/reagent_dispensers/keg/gargle
	name = "keg of pan galactic gargleblaster"
	desc = "A keg of... wow that's a long name."
	icon = 'modular_zzplurt/icons/obj/objects_kegs.dmi'
	icon_state = "bluekeg"
	reagent_id = /datum/reagent/consumable/ethanol/gargle_blaster
	tank_volume = 100

//kegs given by the travelling trader's bartender subtype

/obj/structure/reagent_dispensers/keg/quintuple_sec
	name = "keg of quintuple sec"
	desc = "A keg of pure justice."
	icon = 'modular_zzplurt/icons/obj/objects_kegs.dmi'
	icon_state = "redkeg"
	reagent_id = /datum/reagent/consumable/ethanol/quintuple_sec
	tank_volume = 250

/obj/structure/reagent_dispensers/keg/narsour
	name = "keg of narsour"
	desc = "A keg of eldritch terrors."
	icon = 'modular_zzplurt/icons/obj/objects_kegs.dmi'
	icon_state = "redkeg"
	reagent_id = /datum/reagent/consumable/ethanol/narsour
	tank_volume = 250

/obj/structure/reagent_dispensers/keg/red_queen
	name = "keg of red queen"
	desc = "A strange keg, filled with a kind of tea."
	icon = 'modular_zzplurt/icons/obj/objects_kegs.dmi'
	icon_state = "redkeg"
	reagent_id = /datum/reagent/consumable/red_queen
	tank_volume = 250

/obj/structure/reagent_dispensers/keg/hearty_punch
	name = "keg of hearty punch"
	desc = "A keg that will get you right back on your feet."
	icon = 'modular_zzplurt/icons/obj/objects_kegs.dmi'
	icon_state = "redkeg"
	reagent_id = /datum/reagent/consumable/ethanol/hearty_punch
	tank_volume = 100 //this usually has a 15:1 ratio when being made, so we provide less of it

/obj/structure/reagent_dispensers/keg/neurotoxin
	name = "keg of neurotoxin"
	desc = "A keg of the sickly substance known as 'neurotoxin'."
	icon = 'modular_zzplurt/icons/obj/objects_kegs.dmi'
	icon_state = "bluekeg"
	reagent_id = /datum/reagent/consumable/ethanol/neurotoxin
	tank_volume = 100 //2.5x less than the other kegs because it's harder to get

//Lewd kegs

/obj/structure/reagent_dispensers/keg/aphro
	name = "keg of aphrodisiac"
	desc = "A keg of aphrodisiac."
	icon = 'modular_zzplurt/icons/obj/objects_kegs.dmi'
	icon_state = "pinkkeg"
	reagent_id = /datum/reagent/drug/aphrodisiac/crocin
	tank_volume = 150

/obj/structure/reagent_dispensers/keg/aphro/strong
	name = "keg of strong aphrodisiac"
	desc = "A keg of strong and addictive aphrodisiac."
	reagent_id = /datum/reagent/drug/aphrodisiac/crocin/hexacrocin
	tank_volume = 120

/obj/structure/reagent_dispensers/keg/cum
	name = "keg of cum"
	desc = "Dear lord, where did this even come from?"
	icon = 'modular_zzplurt/icons/obj/objects_kegs.dmi'
	icon_state = "whitekeg"
	reagent_id = /datum/reagent/consumable/cum

/obj/structure/reagent_dispensers/keg/femcum
	name = "keg of femcum"
	desc = "... Let's just say it's a keg of squirt..."
	icon = 'modular_zzplurt/icons/obj/objects_kegs.dmi'
	icon_state = "whitekeg"
	reagent_id = /datum/reagent/consumable/femcum
