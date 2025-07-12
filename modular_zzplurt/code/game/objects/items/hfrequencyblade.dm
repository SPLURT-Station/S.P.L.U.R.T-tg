/obj/item/highfrequencyblade
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	var/slice_hitsound = 'sound/items/weapons/zapbang.ogg'

/obj/item/highfrequencyblade/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	. = ..()
	if(!.)
		return
	var/owner_turf = get_turf(owner)
	new block_effect(owner_turf, COLOR_WHITE)
	playsound(src, block_sound, BLOCK_SOUND_VOLUME, vary = TRUE)
