/datum/supply_pack/security/armory/secdaisho
	name = "Reverbing Sword Crate"
	desc = "A three pack of the Ugora Orbit branded two handed sword and the sheath for them."
	cost = CARGO_CRATE_VALUE * 30
	contains = list(/obj/item/storage/belt/secdaisho = 3)
	crate_name = "sword and jitte"

/datum/supply_pack/security/sectanto
	name = "Tanto Crate"
	desc = "A three pack of the Ugora Orbit branded tanto. Thin sharp blade meant for last resort."
	cost = CARGO_CRATE_VALUE * 10
	contains = list(/obj/item/knife/oscu_tanto = 3)
	crate_name = "security knife"

/*===
Daisho (large and small)
Yes, If you're thinking of a certain other place, you're correct. And I also enjoy Arknights too.
The sprite is custom made by @Wolf751 for the purpose of this server.
Speaking of which, daisho are also fun :3
===*/

/obj/item/storage/belt/secdaisho
	name = "security saya"
	desc = "A modified scabbard intended to hold a sword and a specialized baton at the same time"
	icon = 'modular_zzplurt/master_files/icons/obj/clothing/job/belts.dmi'
	worn_icon = 'modular_zzplurt/master_files/icons/mob/clothing/job/belt.dmi'
	icon_state = "secdaisho"
	base_icon_state = "secdaisho"
	worn_icon_state = "secdaisho"
	w_class = WEIGHT_CLASS_BULKY
	interaction_flags_click = NEED_DEXTERITY

/obj/item/storage/belt/secdaisho/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_BULKY
	atom_storage.max_slots = 2
	atom_storage.max_total_storage = WEIGHT_CLASS_BULKY + WEIGHT_CLASS_NORMAL
	atom_storage.set_holdable(list(
// Uncomment when available		/obj/item/melee/oscula,
		/obj/item/melee/reverbing_blade,
		/obj/item/melee/baton/jitte,
		))

/obj/item/storage/belt/secdaisho/full/PopulateContents()
	new /obj/item/melee/reverbing_blade(src)
	new /obj/item/melee/baton/jitte(src)
	update_appearance()

/*
I couldn't careless if I'm right or wrong, I care that I didn't sit down and let someone make a godawful PR while all I did was complain
Some of us are bloody fucking awful innit? but that's the thing, people are disagreeable
And somewhere, somehow. you do need to try to do something you want to see. This project was always made for you, my dearest reader!

Paxil is aware of my stupid idea and said that all security naturally converge to paxil sec
He may be right afterall.
*/
/obj/item/storage/belt/secdaisho/examine(mob/user)
	. = ..()
	if(length(contents))
		. += span_notice("<b>Left Click</b> to draw a stored blade, <b>Right Click</b> to draw a stored baton while wearing.")

/obj/item/storage/belt/secdaisho/attack_hand(mob/user, list/modifiers)
	if(!(user.get_slot_by_item(src) & ITEM_SLOT_BELT) && !(user.get_slot_by_item(src) & ITEM_SLOT_BACK) && !(user.get_slot_by_item(src) & ITEM_SLOT_SUITSTORE))
		return ..()
	for(var/obj/item/melee/reverbing_blade/yato in contents)
		user.visible_message(span_notice("[user] draws [yato] from [src]."), span_notice("You draw [yato] from [src]."))
		user.put_in_hands(yato)
		playsound(user, 'sound/items/sheath.ogg', 50, TRUE)
		update_appearance()
		return
	return ..()

/obj/item/storage/belt/secdaisho/attack_hand_secondary(mob/user, list/modifiers)
	if(!(user.get_slot_by_item(src) & ITEM_SLOT_BELT) && !(user.get_slot_by_item(src) & ITEM_SLOT_BACK) && !(user.get_slot_by_item(src) & ITEM_SLOT_SUITSTORE))
		return ..()
	for(var/obj/item/melee/baton/jitte/stored in contents)
		user.visible_message(span_notice("[user] draws [stored] from [src]."), span_notice("You draw [stored] from [src]."))
		user.put_in_hands(stored)
		playsound(user, 'sound/items/sheath.ogg', 50, TRUE)
		update_appearance()
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return ..()

/obj/item/storage/belt/secdaisho/update_icon_state()
	var/has_sword = FALSE
	var/has_baton = FALSE
	for(var/obj/thing in contents)
		if(has_baton && has_sword)
			break
		if(istype(thing, /obj/item/melee/baton/jitte))
			has_baton = TRUE
		if(istype(thing, /obj/item/melee/reverbing_blade))
			has_sword = TRUE

	icon_state = initial(icon_state)
	worn_icon_state = initial(worn_icon_state)

	var/next_appendage
	if(has_sword && has_baton)
		next_appendage = "-full"
	else if(has_sword)
		next_appendage = "-sword"
	else if(has_baton)
		next_appendage = "-baton"

	if(next_appendage)
		icon_state += next_appendage
		worn_icon_state += next_appendage
	return ..()

//How fucking rich must kris be if he has an indoor kabuki?
// It's a gift from the holiday clan


//The Synthetik Reverbing Blade, I prestiged raider 6 time and did all challenge :)
/obj/item/melee/reverbing_blade
	name = "resonance blade"
	desc = "A long dull blade manufactured by Industrial District. Made from modified kinetic crusher part"
	desc_controls = "This sword is more effective the more injured your target is"

	icon_state = "secsword0"
	inhand_icon_state = "secsword0"

	icon_angle = -45

	icon = 'modular_zzplurt/modules/modular_weapons/icon/company_and_or_faction_based/ugora_orbit/sword32.dmi'
	lefthand_file = 'modular_zzplurt/modules/modular_weapons/icon/company_and_or_faction_based/ugora_orbit/sword_lefthand32.dmi'
	righthand_file = 'modular_zzplurt/modules/modular_weapons/icon/company_and_or_faction_based/ugora_orbit/sword_righthand32.dmi'

	block_chance = 33 //a 1 in 3 chance to block attack is ok.
	force = 15
	throwforce = 23 //Someone brought up that you could use it with TK but you already can fuckin TK a spear (which is also far easier to get en mass) so I dont see this as a problem
	wound_bonus = 5 //Low, because we increases in damages which will gradually increases the bonus too!
	exposed_wound_bonus = -40 //See the tanto for why we are having it in the negative instead

	attack_speed = 12 //Slower to swing, we have more damage per hit!

	damtype = BURN
	hitsound = 'sound/items/weapons/bladeslice.ogg'

	var/bonus_force = 0
	var/damage = 0
//What is degree of tolerance? essentially how much damage we want to divide the actual damage dealt!
	var/degree_of_tolerance = 5
	var/maximum_damage_bonus = 30

/obj/item/melee/reverbing_blade/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(attack_type == (PROJECTILE_ATTACK || OVERWHELMING_ATTACK))
		final_block_chance -= 33 //Don't bring a sword to a gunfight, Or a road roller, if one happened to hit you.
	if(attack_type == UNARMED_ATTACK || LEAP_ATTACK)//You underestimate my power!
		final_block_chance += 33 //Don't try it!
	return ..()

/obj/item/melee/reverbing_blade/pre_attack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!isliving(target))
		return ..()
	var/mob/living/living_target = target
	damage = (living_target.getBruteLoss() + living_target.getFireLoss())
	bonus_force = clamp(damage/degree_of_tolerance, 0, maximum_damage_bonus)
	MODIFY_ATTACK_FORCE(attack_modifiers, bonus_force)

//You said you didn't like astral projecting heretic, and I wasn't sure how to interpret it? We said we won't nerf heretic
//So, have it the way I had in mind

/obj/item/melee/reverbing_blade/oscula
	name = "oscillating sword"
	desc = "A long energy blade fielded by the Ugora regal guardian. These 'swords' lack sharp edges, that said, it is still extremely lightweight to swing and can burn target hit by it."
	desc_controls = "This sword inflicts bluespace scarring, occult target afflicted by this cannot jaunt or teleport!"
	icon = 'modular_zzplurt/modules/modular_weapons/icon/company_and_or_faction_based/ugora_orbit/sword.dmi'
	icon_state = "secsword0"
	inhand_icon_state = "secsword0"
	lefthand_file = 'modular_zzplurt/modules/modular_weapons/icon/company_and_or_faction_based/ugora_orbit/sword_lefthand.dmi'
	righthand_file = 'modular_zzplurt/modules/modular_weapons/icon/company_and_or_faction_based/ugora_orbit/sword_righthand.dmi'
	block_chance = 40
	armour_penetration = 20 //Yes we actually tested this. Even in best case scenario it still takes 6 hit to down. We have too low of a base damage to be an issue
	force = 13 //low base damage, high ramp up. You use this for support.

	wound_bonus = 5
	exposed_wound_bonus = -40
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	attack_speed = 4

	degree_of_tolerance = 4 //a ramp up weapon, let's have fun with it
	maximum_damage_bonus = 20 //Maximum of 33 damage overall. Since we are using this ontop of applying scarring

/*
 In regards to concern on the fact that there is a difference of 4 ticks between this and any standard melee cooldown
	/// | Refer to below for linear graph. Damage:TickRate
	/// | [1]    [2]  [3]    [4]     	This is assuming you are hitting in strafe			   |===|
	/// | 12:4, 25:8, 43:12, 77:16     													   	   |===|
	/// | 30:8, 60:16, 90:24, 120:32 														   |===|
	/// | It is incredibly unlikely the sword will single handedly win any combat scenario.    |===|
		As we can see, the energy sword will win within practically 5 seconds of combat if the blade wielder is not hitting every hit.

		There is a significantly lower tickrate, so each cyclic rate(Melee Damage Per Strafe) is significantly higher.
		If you're only getting hit in every time you walk by them, then energy sword would outdamage
		This means the energy sword (and similar weapons) has the upperhand because 3 hit is almost certainly going to slow you down to crawl

		The sword has a lower overall damage and does not deal brute wound (no bleed out)
		Yes, this sword is one of the more complicated one in term of balance and it may feel oppressive
		Due to how many feature it has and the system put in place. But it is the best thing we can come up with to keep the game exciting
*/

	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK

	attack_verb_continuous = list("attacks", "pokes", "jabs", "bludgeons", "hits", "bashes") //The sword is dull, not sharp
	attack_verb_simple = list("attack", "poke", "jab", "smack", "hit", "bludgeon")

/obj/item/melee/reverbing_blade/oscula/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(attack_type == (PROJECTILE_ATTACK || OVERWHELMING_ATTACK))
		final_block_chance -= 40 //Don't bring a sword to a gunfight, Or a road roller, if one happened to hit you.
	if(attack_type == UNARMED_ATTACK || LEAP_ATTACK)//You underestimate my power!
		final_block_chance += 33 //Don't try it!
	return ..()

/obj/item/melee/reverbing_blade/oscula/afterattack(atom/target, blocked, pierce_hit)
	if(!isliving(target))
		return
	var/mob/living/bluespace_scarred = target
	bluespace_scarred.apply_status_effect(/datum/status_effect/bluespace_scarred)

/obj/item/knife/oscu_tanto
	name = "\improper realta"
	desc = "A long thin blade commonly used by Kayian Janissary to finish off vulnerable opponent and in rarer case, for assasination. Stabbing a <b> proned </b> target will deal more damage"
	icon = 'modular_zzplurt/modules/modular_weapons/icon/company_and_or_faction_based/ugora_orbit/tanto.dmi'
	icon_state = "tanto"
	inhand_icon_state = "tantohand"
	lefthand_file = 'modular_zzplurt/modules/modular_weapons/icon/company_and_or_faction_based/ugora_orbit/tanto_lefthand.dmi'
	righthand_file = 'modular_zzplurt/modules/modular_weapons/icon/company_and_or_faction_based/ugora_orbit/tanto_righthand.dmi'
	worn_icon_state = "knife"
	force = 10 //This is more effective when the target is laying down, or facing away. We don't use stagger however.
	w_class = WEIGHT_CLASS_NORMAL //It's not exactly big but it's kind of long.
	throwforce = 20 //Long Slim Throwing Knives
	wound_bonus = 0 //We want to avoid this being too effective at wounding if its intended damage is not met
	exposed_wound_bonus = 25 //Exposed wound bonus work much more effectively with high AP, while regular wound bonus also works in liu of this. The important thing here is that raw wound bonus works regardless of armour and exposed wound bonus works when nothing is obscuring it.
	armour_penetration = 35 // You should be able to use it fairly often and effectively against most threat. A succesful backstab is rewarding
	attack_speed = 14 //This is so that you aren't constantly being spammed with high damage in the worst case scenario, otherwise act to punish players who miss

	damtype = BURN

/obj/item/knife/oscu_tanto/examine_more(mob/user)
	. = ..()
	. += span_info("This knife deals more damage when attacking from behind, hitting a target laying down or if they are incapacitated. Such as from succesful baton hit. \
		Mastery of this blade is imperative to any close quarter combatant.")


/obj/item/knife/oscu_tanto/pre_attack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!isliving(target))
		return ..()

	var/mob/living/living_target = target
	var/ritual_worthy = FALSE

	if(living_target.stat == DEAD) // We are using the code from the Iaito here and following what Anne suggested aswell, it'd be best to make it not do extra damage against dead body due to dismemberment
		return ..()

	if(check_behind(user, living_target))
		ritual_worthy = TRUE

	if(ritual_worthy)
		MODIFY_ATTACK_FORCE_MULTIPLIER(attack_modifiers, 3) ///This makes it do 30 damage, still a lot but its situational enough; see other weapon that do 30 damage
	return ..()

/datum/storage/security_belt
	max_slots = 6

/datum/storage/security_belt/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	set_holdable(list(
		/obj/item/ammo_box,
		/obj/item/ammo_casing/shotgun,
		/obj/item/assembly/flash/handheld,
		/obj/item/clothing/glasses,
		/obj/item/clothing/gloves,
		/obj/item/flashlight/seclite,
		/obj/item/food/donut,
		/obj/item/grenade,
		/obj/item/holosign_creator/security,
		/obj/item/knife/combat,
		/obj/item/melee/baton,
		/obj/item/radio,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/restraints/handcuffs,
		/obj/item/restraints/legcuffs/bola,
		/obj/item/knife/oscu_tanto,
	))

/obj/item/storage/belt/security/full/PopulateContents()
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/grenade/flashbang(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/knife/oscu_tanto(src)
	new /obj/item/melee/baton/security/loaded(src)
	update_appearance()

/datum/storage/security_belt/webbing
	max_slots = 7

//A baton not used for knocking down but beating people up. Or something.
//Lower hit delay and lower stamina damage. Reward certain playstyle.
/obj/item/melee/baton/jitte
	name = "constrictor baton"
	icon = 'modular_zzplurt/modules/modular_weapons/icon/company_and_or_faction_based/ugora_orbit/jitte.dmi'
	lefthand_file = 'modular_zzplurt/modules/modular_weapons/icon/company_and_or_faction_based/ugora_orbit/jitte_lefthand.dmi'
	righthand_file = 'modular_zzplurt/modules/modular_weapons/icon/company_and_or_faction_based/ugora_orbit/jitte_righthand.dmi'
	icon_state = "jitte"
	inhand_icon_state = "jitte"
	desc = "A hard plastic-metal jitte to be used in combination with your sword. Not as effective at knocking down target. But can knock weapon out of target hands if they are staggered or facing away"
	desc_controls = "Left click to stun, right click to harm."
	stamina_damage = 25 //It still is a baton, just a worse one. Possible to stamina crit, hard to do so otherwise
	cooldown = 1.4 SECONDS //Faster than a baton but still slow
	knockdown_time = 0 SECONDS //This does not knockdown. Doesn't need to.

/obj/item/melee/baton/jitte/additional_effects_non_cyborg(mob/living/target, mob/living/user)
	target.set_confusion_if_lower(2 SECONDS)
	target.set_staggered_if_lower(2 SECONDS) //A short 2 second window meant to allow for follow up, it's short enough you can legitimately miss it. but long enough its actually possible to follow up

/obj/item/melee/baton/jitte/pre_attack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!isliving(target))
		return ..()

	var/mob/living/living_target = target
	var/you_suck = FALSE

	if(living_target.get_timed_status_effect_duration(/datum/status_effect/staggered))
		you_suck= TRUE

	if(check_behind(user, living_target))
		you_suck = TRUE

	if(you_suck)
		living_target.drop_all_held_items()
		living_target.visible_message(span_danger("[user] disarms [living_target]!"), span_userdanger("[user] disarmed you!"))

	return ..()
