//Pistol as in anything that is compact and fired one handed
/obj/item/gun/ballistic/revolver/protector_revolver
	desc = "The Protector was designed to be a compact backup gun for NT law enforcement. Features a built in light and carefully polished action to ensure functionality no matter the environment, chambered in the same NT issue 9mm Murphy to maintain ammo compatibility. Security pistol magazines can be notched onto the cylinder for easy reloading. Somehow, somewhy. You felt like you made a promise to someone important" //The Signalis Reference must remains untouched.
	icon = 'modular_zzplurt/icons/obj/weapons/guns/ballistic_40x32.dmi'
	fire_delay = 8 //Because with the rework its actually pretty dangerous now. This is equal to a shotgun fire delay, which is a pretty close analogue to what we're working with
	icon_state = "rhino" //Sorry Niim but the signalis reference must not be forgotten
	recoil = 1
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/romtech45
	fire_sound = 'modular_zzplurt/sound/items/weapons/gun/gunshot_strong.ogg'
//Taken from https://github.com/ParadiseSS13/Paradise/blob/51e176654c3d86d61707689c9ab218edd36153c3/sound/weapons/gunshots/gunshot_strong.ogg
//No attribution available for authorship

//Hey, so if you ever read this and wondered, Why this rework? Well, because I couldn't stand the idea of someone who can go on and crush other people's dreams.
// When me and anne worked together on all sorts of PR, primarily anything that involve sec balances. We remind ourselves who are we coding for
//I think there's nothing more harmful than the clique that lead to the murphy becoming a thing, even more so it was allowed to exist in this state for so long.
/obj/item/gun/ballistic/automatic/pistol/sec_glock
	name = "\improper 'Ladon' Security Pistol"
	desc = "A well built all rounder standard sidearm of NanoTrasen station security force chambered in 9x17mm. It comes with a revolutionary quick-reload system."
	icon = 'modular_zzplurt/icons/obj/weapons/guns/ballistic_40x32.dmi'
	icon_state = "ladon"
	accepted_magazine_type = /obj/item/ammo_box/magazine/security
	fire_sound = 'modular_zubbers/sound/weapons/gun/lock/shot.ogg'
	fire_delay = 2
	burst_delay = 0
	suppressor_x_offset = 5
	can_suppress = TRUE

//This is because we're already overriding other bits anyway,  so i'm not feeling like touching that unless cato does.
/obj/item/gun/ballistic/automatic/pistol/sec_glock/smart
	icon = 'modular_zzplurt/icons/obj/weapons/guns/ballistic_40x32.dmi'
	projectile_damage_multiplier = 1

/*
Kali Note
I should note that during testing the gun could honest to god have it's fire delay as low as 0
And it would still not be kinda eh. main issue is caused by server ticklag
The differences now is that this actually scales with the round tech
as opposed to "I literally do not have anything else and I cannot melee it" I don't like that
Because the majority of the antagonist ran on this server can be shoved down or stunned.
Which make the murphy paradoxically awful for security
Because it make them do things they shouldn't while also being a gun that is objectively worse than nothing.
This is netiher, this is actually better than nothing. While being balanced around mid to late round antagonist with the weaker starting ammo (That you switch out to HP or AP)
Less Damage, more Ammo. It keeps armour actually relevant for antagonist, HP ammo for simple mob and unarmoured target. AP Ammo for mid to late round against armoured thraet (But with notably less damage per hit)
This is fair and nice.
*/
