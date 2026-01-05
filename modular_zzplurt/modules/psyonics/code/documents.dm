/obj/item/card/psyonic_license
	name = "psyonic license"
	desc = "An official license given to psyonic users by the Nanotrasen Human Resources."
	icon = 'modular_zzplurt/modules/psyonics/icons/card.dmi'
	icon_state = "card_psy"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	pickup_sound = 'sound/items/handling/id_card/id_card_pickup1.ogg'
	drop_sound = 'sound/items/handling/id_card/id_card_drop1.ogg'
	sound_vary = TRUE
	resistance_flags = FIRE_PROOF
	var/datum/psyonic_licence_datum/owner_info

/obj/item/card/psyonic_license/New(mob/living/carbon/human/owner)
	. = ..()
	owner_info = new(owner)

/obj/item/card/psyonic_license/ui_interact(mob/user, datum/tgui/ui)
	if(!owner_info)
		balloon_alert(user, "The card isn't bound to anyone!")
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PsyonicLicense")
		ui.set_autoupdate(FALSE)
		ui.open()

/obj/item/card/psyonic_license/ui_static_data(mob/user)
	var/list/data = list()

	data["primary_school"] = owner_info.primary_school
	data["secondary_school"] = owner_info.secondary_school
	data["psyonic_level"] = owner_info.psyonic_level
	data["owner_name"] = owner_info.owner_name
	data["owner_age"] = owner_info.owner_age
	data["owner_preview"] = owner_info.owner_preview
	data["owner_species"] = owner_info.owner_species

	return data

/datum/psyonic_licence_datum
	var/datum/weakref/original_owner
	var/owner_name
	var/owner_age
	var/psyonic_level
	var/primary_school
	var/secondary_school
	var/owner_species
	var/icon/owner_preview

/datum/psyonic_licence_datum/New(mob/living/carbon/human/human_owner)
	. = ..()
	original_owner = WEAKREF(human_owner)
	if(original_owner && original_owner.resolve())
		var/mob/living/carbon/human/owner = original_owner.resolve()
		if(!istype(owner, /mob/living/carbon/human))
			return
		if(!owner.ispsyonic())
			return
		var/datum/quirk/psyonic/quirk_holder = owner.get_quirk(/datum/quirk/psyonic)
		psyonic_level = quirk_holder.psyonic_level_string
		primary_school = quirk_holder.school
		secondary_school = quirk_holder.secondary_school
		owner_name = owner.real_name
		owner_age = owner.age

		if (!owner.dna.species.lore_protected && owner.dna.features["custom_species"])
			owner_species = "[owner.dna.features["custom_species"]]"
		else
			owner_species = "[owner.dna.species.name]"

		owner_preview = icon2base64(getFlatIcon(owner, SOUTH, no_anim = TRUE))
