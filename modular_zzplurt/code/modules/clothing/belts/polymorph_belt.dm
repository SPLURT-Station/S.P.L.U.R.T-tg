
/obj/item/polymorph_belt/proc/check_mob_type(mob/living/target_mob)
	if(istype(target_mob, /mob/living/basic/raptor))
		var/mob/living/basic/raptor/raptor_mob = target_mob
		switch(raptor_mob.growth_stage)
			if(RAPTOR_BABY)
				switch(raptor_mob.raptor_color.type)
					if(/datum/raptor_color/red) return /mob/living/basic/raptor/baby/red
					if(/datum/raptor_color/purple) return /mob/living/basic/raptor/baby/purple
					if(/datum/raptor_color/green) return /mob/living/basic/raptor/baby/green
					if(/datum/raptor_color/white) return /mob/living/basic/raptor/baby/white
					if(/datum/raptor_color/black) return /mob/living/basic/raptor/baby/black
					if(/datum/raptor_color/yellow) return /mob/living/basic/raptor/baby/yellow
					if(/datum/raptor_color/blue) return /mob/living/basic/raptor/baby/blue
			if(RAPTOR_YOUNG)
				switch(raptor_mob.raptor_color.type)
					if(/datum/raptor_color/red) return /mob/living/basic/raptor/young/red
					if(/datum/raptor_color/purple) return /mob/living/basic/raptor/young/purple
					if(/datum/raptor_color/green) return /mob/living/basic/raptor/young/green
					if(/datum/raptor_color/white) return /mob/living/basic/raptor/young/white
					if(/datum/raptor_color/black) return /mob/living/basic/raptor/young/black
					if(/datum/raptor_color/yellow) return /mob/living/basic/raptor/young/yellow
					if(/datum/raptor_color/blue) return /mob/living/basic/raptor/young/blue
			if(RAPTOR_ADULT)
				switch(raptor_mob.raptor_color.type)
					if(/datum/raptor_color/red) return /mob/living/basic/raptor/red
					if(/datum/raptor_color/purple) return /mob/living/basic/raptor/purple
					if(/datum/raptor_color/green) return /mob/living/basic/raptor/green
					if(/datum/raptor_color/white) return /mob/living/basic/raptor/white
					if(/datum/raptor_color/black) return /mob/living/basic/raptor/black
					if(/datum/raptor_color/yellow) return /mob/living/basic/raptor/yellow
					if(/datum/raptor_color/blue) return /mob/living/basic/raptor/blue

	return target_mob.type
