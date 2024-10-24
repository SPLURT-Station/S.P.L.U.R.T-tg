#define GET_SHIFT_X(dir) ((dir == EAST && 4) || (dir == WEST && -4))
#define GET_SHIFT_Y(dir) ((dir == NORTH && 4) || (dir == SOUTH && -4))

/// This component handles active blocking. I'd say "a shamelessly ripped version of kevinz's work" but the amount of refactoring this needed was insane.
/datum/component/active_block
	/// Same as src.parent, except typecast.
	var/mob/living/living_parent

	/// The ref to the relevant active_defense_data datum.
	var/datum/active_defense_data/block_data
	/// The ref to the item we're blocking with.
	var/obj/item/blocking_item
	/// Is this a passive, or an active block?
	var/passive_block = FALSE


/datum/component/active_block/Initialize(passive_block = FALSE)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	living_parent = parent

	var/obj/item/held_item = living_parent.get_active_held_item()
	if(!held_item?.active_defense_data) //cmon man
		return COMPONENT_INCOMPATIBLE

	blocking_item = held_item

	block_data = held_item.active_defense_data
	block_data = ispath(block_data, /datum/active_defense_data) ? GLOB.active_defense_data[block_data] : block_data
	if(!istype(block_data))
		return COMPONENT_INCOMPATIBLE

	// successfully attached
	for(var/trait in block_data.block_traits)
		ADD_TRAIT(parent, trait, type)
	ADD_TRAIT(parent, TRAIT_ACTIVE_BLOCKING, type)

	RegisterSignal(parent, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(on_check_block))
	RegisterSignal(parent, COMSIG_MOB_SWAPPING_HANDS, PROC_REF(on_swapping_hands))
	RegisterSignal(parent, COMSIG_ATOM_POST_DIR_CHANGE, PROC_REF(on_dir_change))

	RegisterSignal(parent, COMSIG_MOB_DROPPING_ITEM, PROC_REF(end_block))
	RegisterSignal(blocking_item, COMSIG_QDELETING, PROC_REF(end_block))

	//visual effects, wowie
	src.passive_block = passive_block
	if(!passive_block)
		living_parent.visible_message(span_warning("[living_parent] raises their [blocking_item], dropping into a defensive stance!"))
		var/px = living_parent.pixel_x + GET_SHIFT_X(living_parent.dir)
		var/py = living_parent.pixel_y + GET_SHIFT_Y(living_parent.dir)
		animate(living_parent, pixel_x = px, pixel_y = py, time = 2.5, FALSE, SINE_EASING | EASE_OUT)

/datum/component/active_block/Destroy(force)
	block_data = null
	blocking_item = null
	living_parent = null
	return ..()

/datum/component/active_block/proc/end_block()
	SIGNAL_HANDLER

	if(!passive_block)
		living_parent.visible_message(span_warning("[living_parent] lowers their [blocking_item]."))
		var/px = living_parent.pixel_x - GET_SHIFT_X(living_parent.dir)
		var/py = living_parent.pixel_y - GET_SHIFT_Y(living_parent.dir)
		animate(living_parent, pixel_x = px, pixel_y = py, time = 2.5, FALSE, SINE_EASING | EASE_IN)

	qdel(src)


/datum/component/active_block/proc/on_swapping_hands(mob/living/source, obj/item/held_item)
	SIGNAL_HANDLER

	source.balloon_alert(source, "can't swap while blocking!")
	return COMPONENT_BLOCK_SWAP //nah lol

// hit_by is atom/movable because it can be either a mob or a held item. sigh.
/datum/component/active_block/proc/on_check_block(mob/living/source, atom/movable/hit_by, damage, attack_text, attack_type, armour_penetration, damage_type)
	SIGNAL_HANDLER

	var/hit_direction
	if(isprojectile(source))
		var/obj/projectile/projectile = source
		hit_direction = angle2dir(projectile.Angle)
	else
		var/turf/source_turf = get_turf(hit_by) //please tg dont move items to nullspace pleaaaase
		hit_direction = get_dir(source, hit_by)

	var/normalized_hit_dir = turn(hit_direction, -dir2angle(source.dir))
	if(dir_to_junction(normalized_hit_dir) | block_data.allowed_block_dirs == NONE)
		return NONE // :3


	var/total_blocked_damage = 0
	// first the damage limit
	total_blocked_damage += max(damage - block_data.block_damage_limit, 0)
	damage -= blocked_damage
	// then absorption
	var/absorbed_damage = max(damage - block_data.block_damage_absorption, 0)
	damage -= absorbed_damage
	// then multiply the remainder
	var/diff = (damage * block_data.block_efficiency * (passive_block ? 3 : 1))
	blocked_damage += diff
	damage -= diff



/datum/component/active_block/proc/on_dir_change(mob/living/source, old_dir, new_dir)
	SIGNAL_HANDLER

	source.pixel_x = source.pixel_x - GET_SHIFT_X(old_dir) + GET_SHIFT_X(new_dir)
	source.pixel_y = source.pixel_y - GET_SHIFT_Y(old_dir) + GET_SHIFT_Y(new_dir)
