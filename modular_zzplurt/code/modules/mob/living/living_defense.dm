/mob/living/proc/create_splatter(splatter_dir)
	var/obj/effect/temp_visual/dir_setting/bloodsplatter/splatter = new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(src), splatter_dir)
	splatter.color = blood_DNA_to_color(splatter.color)
	splatter.icon = colored_blood_icon(splatter.icon)
