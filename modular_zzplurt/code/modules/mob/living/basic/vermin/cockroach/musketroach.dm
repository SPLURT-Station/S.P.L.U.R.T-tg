/// A standard cockroach with a crank-reloaded miniature laser musket.
/mob/living/basic/cockroach/laseroach/musket
	name = "musket roach"
	desc = "A cockroach with a tiny hand-cranked laser musket. It reloads with alarming determination."
	icon = 'modular_zzplurt/icons/mob/living/basic/vermin/cockroach/musketroach.dmi'
	icon_state = "musketroach"
	icon_living = "musketroach"
	icon_dead = "musketroach_dead"
	laser_projectile_type = /obj/projectile/beam/laser/musket
	laser_fire_sound = 'modular_skyrat/modules/aesthetics/guns/sound/laser.ogg'
	minion_path = /mob/living/basic/cockroach/laseroach/musket/space_police
	/// The real laser musket's crank/reload sound, played once per fired shot.
	var/musket_reload_sound = 'sound/items/weapons/laser_crank.ogg'

/mob/living/basic/cockroach/laseroach/musket/Initialize(mapload)
	// SSsounds returns deciseconds, as used by the ranged component cooldown.
	ranged_cooldown = SSsounds.get_sound_length(musket_reload_sound) + 0.1 SECONDS
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return
	RegisterSignal(src, COMSIG_BASICMOB_POST_ATTACK_RANGED, PROC_REF(on_musket_fired))

/mob/living/basic/cockroach/laseroach/musket/proc/on_musket_fired(mob/living/basic/source, atom/target, modifiers)
	SIGNAL_HANDLER
	// Fixed playback speed keeps the cooldown aligned with the end of the sound.
	playsound(src, musket_reload_sound, 50, FALSE)

/mob/living/basic/cockroach/laseroach/musket/space_police
	name = "space police musket roach"
	desc = "A dark-shelled cockroach diligently cranking a tiny laser musket."
	health = 2
	maxHealth = 2
	icon_state = "musketroach_police"
	icon_living = "musketroach_police"
	icon_dead = "musketroach_police_dead"
	minion_path = null
