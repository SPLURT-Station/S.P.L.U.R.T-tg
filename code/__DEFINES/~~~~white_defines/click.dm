/mob/proc/AltMiddleClickOn(atom/A)
	A.AltMiddleClick(src)
	return

/atom/proc/AltMiddleClick(mob/living/carbon/user)
	try_jump(src, user)
	return
