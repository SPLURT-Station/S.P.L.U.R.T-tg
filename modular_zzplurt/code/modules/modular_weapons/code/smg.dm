/obj/item/gun/ballistic/automatic/mps5
	name = "\improper MP-S5 VIG"
	desc = "A Nanotrasen security submachine gun, the MP-S5 was manufactured by Nanotrasen specifically to be \
		a rugged workhorse for station security. Though long since surpassed by other manufacturers, the VIG \
		remains a reliable standby in auxiliary armories and is still favored by veteran officers who trust \
		its no-nonsense performance. Chambered in 9x17mm."
	icon = 'modular_zzplurt/icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "mp5"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = "arg"
	accepted_magazine_type = /obj/item/ammo_box/magazine/mps5
	fire_sound = 'modular_zzplurt/sound/items/weapons/gun/mp5_shot.ogg'
	burst_delay = 2
	can_suppress = FALSE
	burst_size = 1
	actions_types = list()
	mag_display = TRUE

/obj/item/gun/ballistic/automatic/mps5/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.21 SECONDS)

/obj/item/gun/ballistic/automatic/mps5/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)

/obj/item/gun/ballistic/automatic/mps5/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 18, \
		overlay_y = 12)

/obj/item/gun/ballistic/automatic/wt458
	name = "\improper WT-458 Bullpup Rifle"
	desc = "A 2-round burst rifle fielded by Nanotrasen Naval Infantry, taken out of service over time due to failing to meet EVA combat's rate of fire demands.\
		It is still incredibly useful for close range or tight quarters combat, such as on NT Station's infamous maintenance tunnels.<br>\
		Lightweight and can be fired one-handed. Uses 4.6x30mm rounds."
	icon = 'modular_zzplurt/icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "wt458"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = "arg"
	accepted_magazine_type = /obj/item/ammo_box/magazine/wt550m9
	burst_delay = 2
	can_suppress = FALSE
	burst_size = 2
	fire_delay = 5
	mag_display = TRUE
	mag_display_ammo = TRUE
	empty_indicator = TRUE
	spread = 10
	fire_sound = 'modular_zzplurt/sound/items/weapons/gun/wt458_shot.ogg'
	fire_sound_volume = 70
//Gunshot is taken from this  https://github.com/ParadiseSS13/Paradise/tree/master/sound/weapons/gunshots#gunshot_rifle.ogg
//However, I could not find who it was attributed to or where it comes from

/obj/item/gun/ballistic/automatic/wt458/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/examine_lore, \
		lore_hint = span_notice("You can [EXAMINE_HINT("examine closer")] to learn a little more about [src]."), \
		lore = "The WT-458 is a unique, select fire, 2 round burst firearm chambered in low power cartridges. Its burst mechanism was chosen for closer quarters station \
		combat, from back when the capture and occupation of space stations was militarily <i>en vogue</i> rather than destroying them with a nuclear device. \
		The weapon's small caliber makes it more of a carbine than any assault rifle, but long debates among the marketing team led to the name it holds today.\
		<br>\
		<br>\
		Originally under manufacture by Romulus Technology under the name 'PDW Mk-1', riding off the success of their CMG weapons platform, the weapon features \
		a straight blowback system which vertically ejects the round safetly behind the user, unlike the CMG Prototypes, which would eject their casings into a left-handed \
		user's shoulder. The production of the weapon was troubled, even in its early stages, with those in charge demanding tolerances from plastic moulding that \
		were only realistically achieveable by precisely carved steel; though this pales in comparison to the eventual systematic eradication of the company's workforce.\
		<br>\
		<br>\
		Nanotrasen's eventual adoption of the design came with its own problems, severely hampered by the company's struggle to come to terms with modern ballistic \
		mass-production. Precision parts of the Romulus Technology and the Solarian First Expedition Company (its predecessor) were machined by hand out of solid metal \
		with other parts carved out of wood, whereas modern firearms utilized stamping machines which would shape and weld thin sheets of steel into shape. \
		NT's RND have also been unable to mass-produce proper intermediate cartridges, with any rifle chambered in large caliber reserved only for its military branch. \
		Despite this, its continued existence is a testament to the creativity of the people working for the company." \
	)

//To whom it may concerns, Yes, this lore is essentially just me  venting out my frustration with working on the CMG for TG which was supposed to be done back in 2025
//However the design requirement vs what I actually want got really complicated and we could not finalise it.

/obj/item/gun/ballistic/automatic/wt458/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)

/obj/item/gun/ballistic/automatic/wt458/add_bayonet_point()
	AddComponent(/datum/component/bayonet_attachable, offset_x = 25, offset_y = 2)

/obj/item/gun/ballistic/automatic/wt458/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 10, \
		overlay_y = 19)
