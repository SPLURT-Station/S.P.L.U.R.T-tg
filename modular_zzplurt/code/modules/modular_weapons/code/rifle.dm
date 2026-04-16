/obj/item/gun/ballistic/automatic/bulwark
	name = "\improper NTS-24 \"Bulwark\" Assault Rifle"
	desc = "A rare command-grade rifle issued only to Nanotrasen Private Security Captains, seldom seen in the field. \
		Its deployment signals immediate escalation beyond routine operations. Featuring a polished wooden grip and a large \
		Nanotrasen logo emblazoned on the stock, the Bulwark blends legacy styling with modern design. More than a weapon, \
		it's a clear mark of authority. Chambered in 6.8mm Caseless."
	icon = 'modular_zzplurt/icons/obj/weapons/guns/ballistic_64x32.dmi'
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_righthand.dmi'
	icon_state = "bulwark"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = "bulwark"
	accepted_magazine_type = /obj/item/ammo_box/magazine/c68
	fire_sound = 'modular_zzplurt/sound/items/weapons/gun/bulwark_shot.ogg'
	rack_sound = 'modular_zzplurt/sound/items/weapons/gun/bulwark_rack.ogg'
	bolt_drop_sound = 'sound/items/weapons/gun/general/bolt_drop.ogg'
	eject_sound = 'modular_zzplurt/sound/items/weapons/gun/bulwark_eject.ogg'
	eject_empty_sound = 'modular_zzplurt/sound/items/weapons/gun/bulwark_eject.ogg'
	load_sound = 'modular_zzplurt/sound/items/weapons/gun/bulwark_insert.ogg'
	burst_delay = 2
	can_suppress = TRUE
	empty_indicator = TRUE
	burst_size = 1
	actions_types = list()
	mag_display = TRUE

/obj/item/gun/ballistic/automatic/bulwark/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.25 SECONDS)

/obj/item/gun/ballistic/automatic/bulwark/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)

/obj/item/gun/ballistic/automatic/bulwark/examine_more(mob/user)
	. = ..()

	. += "Nanotrasen deliberately modeled the Bulwark after legacy ballistic rifles like the M16 platform, \
	citing \"combat familiarity'\" as a key factor in high-stress situations. By preserving a centuries-proven \
	layout while integrating modern materials and smart systems, they ensured that any trained officer could \
	instinctively operate it. Unlike experimental energy weapons, the Bulwark represents reliability over \
	innovation, a weapon that works the same way every time, whether planetside or in vacuum. For Private \
	Security Captains, it serves as both a practical tool and a psychological anchor: something familiar in \
	environments where very little is."

	return .

/obj/item/gun/ballistic/automatic/bulwark/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 28, \
		overlay_y = 12)

/obj/item/gun/energy/taser/underbarrel
	name = "\improper NT underbarrel taser"
	desc = "A compact Nanotrasen taser module designed for rifle mounting."
	use_cyborg_cell = FALSE
	cell_type = /obj/item/stock_parts/power_store/cell/crap

	var/recharge_cooldown_end = 0
	var/active = FALSE

/obj/item/gun/energy/taser/underbarrel/Initialize(mapload)
	. = ..()
	if(!cell)
		cell = new cell_type(src)
	START_PROCESSING(SSobj, src)

/obj/item/gun/energy/taser/underbarrel/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/energy/taser/underbarrel/give_gun_safeties()
	return

/obj/item/gun/energy/taser/underbarrel/process()
	if(active)
		return

	if(world.time < recharge_cooldown_end)
		return

	if(cell && cell.charge < cell.maxcharge)
		cell.give(500)

	var/obj/item/gun/ballistic/automatic/bulwark/taser/parent = loc
	if(parent)
		parent.update_taser_overlay()


/obj/item/gun/energy/taser/underbarrel/try_fire_gun(atom/target, mob/living/user, params)
	if(!cell || cell.charge <= 0)
		to_chat(user, span_warning("The underbarrel taser is out of charge!"))
		return FALSE

	if(active)
		to_chat(user, span_warning("The taser is already deployed!"))
		return FALSE

	active = TRUE

	var/result = ..()

	if(!result)
		active = FALSE
		return FALSE

	// Update AFTER shot (important)
	var/obj/item/gun/ballistic/automatic/bulwark/taser/parent = loc
	if(parent)
		parent.update_taser_overlay()

	// If we just drained the battery → apply punishment
	if(cell && cell.charge <= 0)
		recharge_cooldown_end = world.time + 100  // 10 seconds
		to_chat(user, span_warning("The taser battery is fully depleted!"))

	addtimer(CALLBACK(src, PROC_REF(reset_active), user), 100)

	return TRUE

/obj/item/gun/energy/taser/underbarrel/proc/reset_active(mob/user)
	if(!active)
		return

	active = FALSE

	// Only apply normal cooldown if we are NOT already in a harsher one
	if(world.time >= recharge_cooldown_end)
		recharge_cooldown_end = world.time + 150

	var/obj/item/gun/ballistic/automatic/bulwark/taser/parent = loc
	if(parent)
		// Apply 3s weapon lock
		parent.fire_lock_until = world.time + 30

		// Notify when recovered
		addtimer(CALLBACK(parent, "notify_recovered", user), 30)

		parent.update_taser_overlay()

/obj/item/gun/ballistic/automatic/bulwark/taser
	name = "\improper NTS-24-T \"Bulwark\" Assault Rifle"
	desc = "A rare command-grade rifle issued only to Nanotrasen Private Security Captains, seldom seen in the field. \
	Its deployment signals immediate escalation beyond routine operations. Featuring a polished wooden grip and a large \
	Nanotrasen logo emblazoned on the stock, the Bulwark blends legacy styling with modern design. More than a weapon, \
	it's a clear mark of authority. This variant includes an underslung taser. Chambered in 6.8mm Caseless."

	var/obj/item/gun/energy/taser/underbarrel/underbarrel
	var/mutable_appearance/taser_overlay
	var/fire_lock_until = 0
	var/last_warning = 0

/obj/item/gun/ballistic/automatic/bulwark/taser/Initialize(mapload)
	. = ..()
	underbarrel = new /obj/item/gun/energy/taser/underbarrel(src)
	update_taser_overlay()

/obj/item/gun/ballistic/automatic/bulwark/taser/Destroy()
	QDEL_NULL(underbarrel)
	return ..()

/obj/item/gun/ballistic/automatic/bulwark/taser/proc/is_tasing()
	return underbarrel && underbarrel.active

/obj/item/gun/ballistic/automatic/bulwark/taser/proc/notify_recovered(mob/user)
	if(user)
		to_chat(user, span_notice("The weapon has recovered from taser discharge."))

/obj/item/gun/ballistic/automatic/bulwark/taser/try_fire_gun(atom/target, mob/living/user, params)

	// Active taser block
	if(is_tasing())
		to_chat(user, span_warning("You can't fire the rifle while the taser is deployed!"))
		return FALSE

	// Recovery lock
	if(world.time < fire_lock_until)
		var/time_left = round((fire_lock_until - world.time) / 10)
		to_chat(user, span_warning("Weapon recovering: [time_left]s"))
		return FALSE

	// RIGHT CLICK → taser
	if(LAZYACCESS(params2list(params), RIGHT_CLICK))
		if(underbarrel)
			var/result = underbarrel.try_fire_gun(target, user, params)
			update_taser_overlay()
			return result

	return ..()

/obj/item/gun/ballistic/automatic/bulwark/taser/process_fire(atom/target, mob/living/user, params)

	// Taser active block
	if(is_tasing())
		if(world.time > last_warning + 10)
			last_warning = world.time
			to_chat(user, span_warning("You can't fire the rifle while the taser is deployed!"))
		return FALSE

	// Recovery lock block
	if(world.time < fire_lock_until)
		if(world.time > last_warning + 10)
			last_warning = world.time
			var/time_left = round((fire_lock_until - world.time) / 10)
			to_chat(user, span_warning("Weapon recovering: [time_left]s"))
		return FALSE

	return ..()

/obj/item/gun/ballistic/automatic/bulwark/taser/proc/update_taser_overlay()
	if(taser_overlay)
		cut_overlay(taser_overlay)
		taser_overlay = null

	if(underbarrel && underbarrel.cell)
		if(underbarrel.cell.charge > 0)
			taser_overlay = mutable_appearance(icon, "bulwark_taser_loaded")
		else
			taser_overlay = mutable_appearance(icon, "bulwark_taser_empty")

	if(taser_overlay)
		add_overlay(taser_overlay)

/obj/item/gun/ballistic/automatic/bulwark/taser/examine(mob/user)
	. = ..()

	if(underbarrel && underbarrel.cell)
		var/percent = round((underbarrel.cell.charge / underbarrel.cell.maxcharge) * 100)

		. += "The underbarrel taser is at [percent]% charge."

		if(world.time < underbarrel.recharge_cooldown_end)
			var/time_left = round((underbarrel.recharge_cooldown_end - world.time) / 10)
			. += " It will begin recharging in [time_left] seconds."
	else
		. += "The underbarrel taser is not responding."

/obj/item/gun/ballistic/automatic/bulwark/taser/add_seclight_point()
	return
