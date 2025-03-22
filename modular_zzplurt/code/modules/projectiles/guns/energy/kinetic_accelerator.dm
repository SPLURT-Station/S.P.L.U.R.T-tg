/obj/item/borg/upgrade/modkit/chassis_mod
	chassis_icon = "_u"

/obj/item/borg/upgrade/modkit/chassis_mod/orange
	chassis_icon = "_h"

/obj/item/borg/upgrade/modkit/chassis_mod/install(obj/item/gun/energy/recharge/kinetic_accelerator/KA, mob/user)
	. = ..()
	if(.)
		KA.icon_state = initial(KA.icon_state) + chassis_icon
		KA.inhand_icon_state = initial(KA.inhand_icon_state) + chassis_icon
		if(iscarbon(KA.loc))
			var/mob/living/carbon/holder = KA.loc
			holder.update_held_items()
