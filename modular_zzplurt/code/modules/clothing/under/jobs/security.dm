// SKYRAT, BUT REDSEC UNIFORMS INSTEAD.

/*
// BASE
*/
/obj/item/clothing/under/rank/security/splurt
	icon = 'modular_zzplurt/icons/obj/clothing/under/security.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/under/security.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/under/security_digi.dmi'
	inhand_icon_state = "r_suit"
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/*
// SECURITY OFFICER
*/
/obj/item/clothing/under/rank/security/splurt/officer
	name = "security uniform"
	desc = "A tactical security jumpsuit for officers complete with Nanotrasen belt buckle."
	icon_state = "security"
	can_adjust = TRUE

/obj/item/clothing/under/rank/security/splurt/officer/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/security_uniform)

/datum/atom_skin/security_uniform
	abstract_type = /datum/atom_skin/security_uniform

/datum/atom_skin/security_uniform/default
	preview_name = "Default Variant"
	new_icon_state = "security"

/datum/atom_skin/security_uniform/alt
	preview_name = "Black Pants Variant"
	new_icon_state = "security_alt"

/obj/item/clothing/under/rank/security/splurt/officer/skirt
	name = "security skirt"
	desc = "A \"tactical\" security uniform with the legs replaced by a skirt."
	icon_state = "security_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/security/splurt/officer/skirt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)
	var/list/reskin_components = GetComponents(/datum/component/reskinable_item)
	for(var/datum/component/reskinable_item/reskin_component as anything in reskin_components)
		qdel(reskin_component)

/obj/item/clothing/under/rank/security/splurt/officer/suit
	name = "security suit"
	desc = "A sleek, formal three-piece suit with a red suit jacket dawned with security insignia, not guaranteed to be good to run in!"
	icon_state = "security_suit"
	can_adjust = TRUE

/obj/item/clothing/under/rank/security/splurt/officer/suit/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)
	var/list/reskin_components = GetComponents(/datum/component/reskinable_item)
	for(var/datum/component/reskinable_item/reskin_component as anything in reskin_components)
		qdel(reskin_component)

/obj/item/clothing/under/rank/security/splurt/officer/casual
	name = "security casual suit"
	desc = "A sleek, formal suit with a white dress shirt dawned with security insignia, not guaranteed to be good to run in!"
	icon_state = "security_casual"
	can_adjust = TRUE

/obj/item/clothing/under/rank/security/splurt/officer/casual/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)
	var/list/reskin_components = GetComponents(/datum/component/reskinable_item)
	for(var/datum/component/reskinable_item/reskin_component as anything in reskin_components)
		qdel(reskin_component)

/obj/item/clothing/under/rank/security/splurt/officer/turtleneck
	name = "security turtleneck suit"
	desc = "A comfortable turtleneck in the classic security red, dawned with security insignia. Paired with black cargo pants to look tactical!"
	icon_state = "turtleneck"
	can_adjust = TRUE

/obj/item/clothing/under/rank/security/splurt/officer/turtleneck/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)
	var/list/reskin_components = GetComponents(/datum/component/reskinable_item)
	for(var/datum/component/reskinable_item/reskin_component as anything in reskin_components)
		qdel(reskin_component)

/obj/item/clothing/under/rank/security/splurt/officer/turtleneck/skirt
	name = "security turtleneck skirt"
	desc = "A comfortable turtleneck in the classic security red, dawned with security insignia. Paired with a black skirt to look tactical!"
	icon_state = "turtleneck_skirt"

/obj/item/clothing/under/rank/security/splurt/officer/trousers
	name = "security trousers"
	desc = "Some security combat trousers. Probably should pair it with a vest for safety."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/under/security.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/under/security.dmi'
	worn_icon_digi = 'modular_skyrat/master_files/icons/mob/clothing/under/security_digi.dmi'
	icon_state = "workpants_red"
	body_parts_covered = GROIN|LEGS
	can_adjust = FALSE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	female_sprite_flags = FEMALE_UNIFORM_NO_BREASTS

/obj/item/clothing/under/rank/security/splurt/officer/trousers/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)
	var/list/reskin_components = GetComponents(/datum/component/reskinable_item)
	for(var/datum/component/reskinable_item/reskin_component as anything in reskin_components)
		qdel(reskin_component)

/obj/item/clothing/under/rank/security/splurt/officer/trousers/shorts
	name = "security shorts"
	desc = "Some security combat shorts. Definitely should pair it with a vest for safety."
	icon_state = "workshorts_red"

/obj/item/clothing/under/rank/security/splurt/officer/miniskirt
	name = "security miniskirt"
	desc = "This miniskirt was originally featured in a gag calendar, but entered official use once they realized its potential for arid climates."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/under/security.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/under/security.dmi'
	worn_icon_digi = 'modular_skyrat/master_files/icons/mob/clothing/under/security_digi.dmi'
	icon_state = "miniskirt_red"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	gets_cropped_on_taurs = FALSE
	can_adjust = TRUE
	body_parts_covered = GROIN | LEGS

/obj/item/clothing/under/rank/security/splurt/officer/miniskirt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)
	var/list/reskin_components = GetComponents(/datum/component/reskinable_item)
	for(var/datum/component/reskinable_item/reskin_component as anything in reskin_components)
		qdel(reskin_component)

/obj/item/clothing/under/rank/security/splurt/officer/battledress
	name = "security battle dress"
	desc = "An asymmetrical, unisex uniform with the legs replaced by a utility skirt. Now in security red!"
	icon_state = "battledress_security"
	can_adjust = TRUE
	alt_covers_chest = FALSE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/clothing/under/rank/security/splurt/officer/battledress/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)
	var/list/reskin_components = GetComponents(/datum/component/reskinable_item)
	for(var/datum/component/reskinable_item/reskin_component as anything in reskin_components)
		qdel(reskin_component)

/obj/item/clothing/under/rank/security/officer/formal
	icon = 'icons/obj/clothing/under/security.dmi'
	worn_icon = 'icons/mob/clothing/under/security.dmi'

/*
// WARDEN
*/
/obj/item/clothing/under/rank/security/splurt/warden
	name = "warden's uniform"
	desc = "A formal security suit for officers complete with Nanotrasen belt buckle."
	icon_state = "warden"
	can_adjust = TRUE

/obj/item/clothing/under/rank/security/splurt/warden/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/warden_uniform)

/datum/atom_skin/warden_uniform
	abstract_type = /datum/atom_skin/warden_uniform

/datum/atom_skin/warden_uniform/default
	preview_name = "Default Variant"
	new_icon_state = "warden"

/datum/atom_skin/warden_uniform/alt
	preview_name = "Black Pants Variant"
	new_icon_state = "warden_alt"

/obj/item/clothing/under/rank/security/splurt/warden/skirt
	name = "warden's suitskirt"
	desc = "A formal security suitskirt for officers complete with Nanotrasen belt buckle."
	icon_state = "warden_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/security/splurt/warden/skirt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)
	var/list/reskin_components = GetComponents(/datum/component/reskinable_item)
	for(var/datum/component/reskinable_item/reskin_component as anything in reskin_components)
		qdel(reskin_component)

/obj/item/clothing/under/rank/security/splurt/warden/suit
	name = "warden's suit"
	desc = "A sleek, formal three-piece suit with a red suit jacket dawned with silver security insignia, not guaranteed to be good to run in!"
	icon_state = "warden_suit"
	can_adjust = TRUE

/obj/item/clothing/under/rank/security/splurt/warden/suit/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)
	var/list/reskin_components = GetComponents(/datum/component/reskinable_item)
	for(var/datum/component/reskinable_item/reskin_component as anything in reskin_components)
		qdel(reskin_component)

/obj/item/clothing/under/rank/security/splurt/warden/turtleneck
	name = "warden's turtleneck suit"
	desc = "A comfortable turtleneck in the classic security red, dawned with silver security insignia. Paired with black cargo pants to look tactical!"
	icon_state = "turtleneck_warden"
	can_adjust = TRUE

/obj/item/clothing/under/rank/security/splurt/warden/turtleneck/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)
	var/list/reskin_components = GetComponents(/datum/component/reskinable_item)
	for(var/datum/component/reskinable_item/reskin_component as anything in reskin_components)
		qdel(reskin_component)

/obj/item/clothing/under/rank/security/splurt/warden/turtleneck/skirt
	name = "warden's turtleneck skirt"
	desc = "A comfortable turtleneck in the classic security red, dawned with silver security insignia. Paired with a black skirt to look tactical!"
	icon_state = "turtleneck_warden_skirt"
	can_adjust = TRUE

/obj/item/clothing/under/rank/security/splurt/warden/battledress
	name = "warden's battle dress"
	desc = "An asymmetrical, unisex uniform with the legs replaced by a utility skirt. This version is specifically designed for the warden!"
	icon_state = "battledress_warden"
	can_adjust = TRUE
	alt_covers_chest = FALSE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/clothing/under/rank/security/splurt/warden/battledress/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)
	var/list/reskin_components = GetComponents(/datum/component/reskinable_item)
	for(var/datum/component/reskinable_item/reskin_component as anything in reskin_components)
		qdel(reskin_component)

/obj/item/clothing/under/rank/security/warden/formal
	icon = 'icons/obj/clothing/under/security.dmi'
	worn_icon = 'icons/mob/clothing/under/security.dmi'

/*
// HEAD OF SECURITY
*/
/obj/item/clothing/under/rank/security/splurt/head_of_security
	name = "head of security's uniform"
	desc = "A security jumpsuit decorated for those few with the dedication to achieve the position of Head of Security."
	icon_state = "hos"
	armor_type = /datum/armor/clothing_under/security_head_of_security
	strip_delay = 6 SECONDS
	can_adjust = TRUE

/obj/item/clothing/under/rank/security/splurt/head_of_security/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hos_uniform)

/datum/atom_skin/hos_uniform
	abstract_type = /datum/atom_skin/hos_uniform

/datum/atom_skin/hos_uniform/default
	preview_name = "Default Variant"
	new_icon_state = "hos"

/datum/atom_skin/hos_uniform/alt
	preview_name = "Black Pants Variant"
	new_icon_state = "hos_alt"

/obj/item/clothing/under/rank/security/splurt/head_of_security/skirt
	name = "head of security's skirt"
	desc = "A security jumpskirt decorated for those few with the dedication to achieve the position of Head of Security."
	icon_state = "hos_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/security/splurt/head_of_security/skirt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)
	var/list/reskin_components = GetComponents(/datum/component/reskinable_item)
	for(var/datum/component/reskinable_item/reskin_component as anything in reskin_components)
		qdel(reskin_component)

/obj/item/clothing/under/rank/security/splurt/head_of_security/suit
	name = "head of security's suit"
	desc = "A sleek, formal three-piece suit with a red suit jacket dawned with golden security insignia, not guaranteed to be good to run in!"
	icon_state = "hos_suit"
	can_adjust = TRUE

/obj/item/clothing/under/rank/security/splurt/head_of_security/suit/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)
	var/list/reskin_components = GetComponents(/datum/component/reskinable_item)
	for(var/datum/component/reskinable_item/reskin_component as anything in reskin_components)
		qdel(reskin_component)

/obj/item/clothing/under/rank/security/splurt/head_of_security/casual
	name = "head of security's casual suit"
	desc = "A sleek, formal suit with a white dress shirt dawned with golden security insignia, not guaranteed to be good to run in!"
	icon_state = "security_casual_hos"
	can_adjust = TRUE

/obj/item/clothing/under/rank/security/splurt/head_of_security/casual/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)
	var/list/reskin_components = GetComponents(/datum/component/reskinable_item)
	for(var/datum/component/reskinable_item/reskin_component as anything in reskin_components)
		qdel(reskin_component)

/obj/item/clothing/under/rank/security/splurt/head_of_security/turtleneck
	name = "head of security's turtleneck suit"
	desc = "A comfortable turtleneck in the classic security red, dawned with golden security insignia. Paired with black cargo pants to look tactical!"
	icon_state = "turtleneck_hos"
	can_adjust = TRUE

/obj/item/clothing/under/rank/security/splurt/head_of_security/turtleneck/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hos_turtleneck)

/datum/atom_skin/hos_turtleneck
	abstract_type = /datum/atom_skin/hos_turtleneck

/datum/atom_skin/hos_turtleneck/default
	preview_name = "Default Variant"
	new_icon_state = "turtleneck_hos"

/datum/atom_skin/hos_turtleneck/alt
	preview_name = "Black Variant"
	new_icon_state = "turtleneck_hos_alt"

/obj/item/clothing/under/rank/security/splurt/head_of_security/turtleneck/skirt
	name = "head of security's turtleneck skirt"
	desc = "A comfortable turtleneck in the classic security red, dawned with golden security insignia. Paired with a black skirt to look tactical!"
	icon_state = "turtleneck_hos_skirt"
	can_adjust = TRUE

/obj/item/clothing/under/rank/security/splurt/head_of_security/turtleneck/skirt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hos_skirtleneck)

/datum/atom_skin/hos_skirtleneck
	abstract_type = /datum/atom_skin/hos_skirtleneck

/datum/atom_skin/hos_skirtleneck/default
	preview_name = "Default Variant"
	new_icon_state = "turtleneck_hos_skirt"

/datum/atom_skin/hos_skirtleneck/alt
	preview_name = "Black Variant"
	new_icon_state = "turtleneck_hos_skirt_alt"

/obj/item/clothing/under/rank/security/splurt/head_of_security/battledress
	name = "head of security's battle dress"
	desc = "An asymmetrical, unisex uniform with the legs replaced by a utility skirt. This version is specifically designed for the head of security!"
	icon_state = "battledress_hos"
	can_adjust = TRUE
	alt_covers_chest = FALSE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/clothing/under/rank/security/splurt/head_of_security/battledress/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)
	var/list/reskin_components = GetComponents(/datum/component/reskinable_item)
	for(var/datum/component/reskinable_item/reskin_component as anything in reskin_components)
		qdel(reskin_component)

/obj/item/clothing/under/rank/security/head_of_security/formal
	icon = 'icons/obj/clothing/under/security.dmi'
	worn_icon = 'icons/mob/clothing/under/security.dmi'
/obj/item/clothing/under/rank/security/splurt
	icon = 'modular_zzplurt/icons/obj/clothing/under/security.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/under/security.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/under/security_digi.dmi'

/obj/item/clothing/under/rank/security/splurt/ntps
	name = "\improper Nanotrasen private security suit"
	desc = "A gray Nanotrasen security-esc uniform with the classic security red on the shoulders and front, usually worn by Nanotrasen's \
		Private Security. It has a pair of black trousers with the security red stripes on the sides that are buckled on by a silver belt \
		buckle with the nanotrasen logo etched into it. You feel incredibly cheap wearing this, but at least the armor is good.. Right? The \
		rank that is designated on the uniform is \"Private\"."
	icon_state = "ntps_jumpsuit"
	inhand_icon_state = "gy_suit"
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/security/splurt/ntps/turtleneck
	name = "\improper Nanotrasen private security turtleneck suit"
	desc = "A gray Nanotrasen turtleneck with the classic security red on the shoulder and wrists, usually worn by Nanotrasen's Private \
		Security. It has a pair of black trousers with the security red stripes on the sides that are buckled on by a silver belt buckle \
		with the nanotrasen logo etched into it. You feel incredibly cheap and comfortable wearing this, but at least the armor is good.. \
		Right? The rank that is designated on the uniform is \"Private\"."
	icon_state = "ntps_turtleneck"

/obj/item/clothing/under/rank/security/splurt/ntps/fatigues
	name = "\improper Nanotrasen private security fatigues"
	desc = "A gray Nanotrasen full-body fatigues with the classic security red patch on the shoulder, usually worn by Nanotrasen's Private \
		Security. It feels incredibly manueverable. You feel incredibly cheap and comfortable wearing this, but at least the armor is good.. \
		Right? The rank that is designated on the uniform is \"Private\"."
	icon_state = "ntps_fatigues"

/obj/item/clothing/under/rank/security/splurt/ntps/corporal
	name = "\improper Nanotrasen private security corporal suit"
	desc = "A gray Nanotrasen security-esc uniform with the classic security red on the shoulders and front, now dawned with silver too, usually \
		worn by Nanotrasen's Private Security. It has a pair of black trousers with the security red stripes on the sides that are buckled on \
		by a silver belt buckle with the nanotrasen logo etched into it. You feel incredibly cheap wearing this, but at least the armor is \
		good.. Right? The rank that is designated on the uniform is \"Corporal\"."
	icon_state = "ntps_corporal"

/obj/item/clothing/under/rank/security/splurt/ntps/corporal/turtleneck
	name = "\improper Nanotrasen private security corporal turtleneck suit"
	desc = "A gray Nanotrasen turtleneck with the classic security red on the shoulder and wrists, now dawned with silver too, usually worn by \
		Nanotrasen's Private Security. It has a pair of black trousers with the security red stripes on the sides that are buckled on by a silver \
		belt buckle with the nanotrasen logo etched into it. You feel incredibly cheap and comfortable wearing this, but at least the armor is \
		good.. Right? The rank that is designated on the uniform is \"Corporal\"."
	icon_state = "ntps_cpl_turtleneck"

/obj/item/clothing/under/rank/security/splurt/ntps/sergeant
	name = "\improper Nanotrasen private security sergeant suit"
	desc = "A gray Nanotrasen security-esc uniform with the classic security red on the shoulders and front, now dawned with gold too, usually \
		worn by Nanotrasen's Private Security. It has a pair of black trousers with the security red stripes on the sides that are buckled on \
		by a golden belt buckle with the nanotrasen logo etched into it. You feel incredibly cheap wearing this, but at least the armor is \
		good.. Right? The rank that is designated on the uniform is \"Sergeant\"."
	icon_state = "ntps_sergeant"

/obj/item/clothing/under/rank/security/splurt/ntps/sergeant/turtleneck
	name = "\improper Nanotrasen private security sergeant turtleneck suit"
	desc = "A gray Nanotrasen turtleneck with the classic security red on the shoulder and wrists, now dawned with gold too, usually worn by \
		Nanotrasen's Private Security. It has a pair of black trousers with the security red stripes on the sides that are buckled on by a golden \
		belt buckle with the nanotrasen logo etched into it. You feel incredibly cheap and comfortable wearing this, but at least the armor is \
		good.. Right? The rank that is designated on the uniform is \"Sergeant\"."
	icon_state = "ntps_sgt_turtleneck"

/obj/item/clothing/under/rank/security/splurt/ntps/captain
	name = "\improper Nanotrasen private security captain turtleneck suit"
	desc = "A gray Nanotrasen turtleneck with the golden shoulder insignia and wrists, usually worn by the finest of Nanotrasen's Private \
		Security. It has a pair of black trousers with the golden stripes on the sides that are buckled on by a golden belt buckle with the \
		nanotrasen logo etched into it. You feel incredibly expensive and comfortable wearing this, you're on top of the world! The rank that \
		is designated on the uniform is \"Captain\"."
	icon_state = "ntps_captain"
