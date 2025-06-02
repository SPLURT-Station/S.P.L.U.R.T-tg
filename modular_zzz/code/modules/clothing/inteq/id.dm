#define JOB_INTEQ_VANGUARD "InteQ Mercenary Vanguard"
#define JOB_INTEQ_MERCENARY "InteQ Mercenary"

// LEADER TRIM
/datum/id_trim/centcom/ert/security/inteq/leader
	assignment = "InteQ Vanguard"
	trim_state = "trim_deathcommando"
	department_color = COLOR_ORANGE_BROWN
	subdepartment_color = COLOR_ORANGE_BROWN
	sechud_icon_state = SECHUD_SCRAMBLED

// MERCENARY TRIM
/datum/id_trim/centcom/ert/security/inteq
	assignment = "InteQ Mercenary"
	trim_state = "trim_deathcommando"
	department_color = COLOR_ORANGE_BROWN
	subdepartment_color = COLOR_ORANGE_BROWN
	sechud_icon_state = SECHUD_SCRAMBLED

// LEADER CARD
/obj/item/card/id/advanced/centcom/ert/inteq/leader
	registered_name = JOB_INTEQ_VANGUARD
	icon_state = "card_black"
	trim = /datum/id_trim/centcom/ert/security/inteq/leader

// MERCENARY CARD
/obj/item/card/id/advanced/centcom/ert/inteq
	registered_name = JOB_INTEQ_MERCENARY
	icon_state = "card_black"
	trim = /datum/id_trim/centcom/ert/security/inteq
