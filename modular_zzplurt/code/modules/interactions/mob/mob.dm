// Only Clients should have a panel for them, okay?
/mob/Login()
	. = ..()
	AddComponent(/datum/component/interaction)

/mob/Logout()
	qdel(GetComponent(/datum/component/interaction))
	. = ..()
