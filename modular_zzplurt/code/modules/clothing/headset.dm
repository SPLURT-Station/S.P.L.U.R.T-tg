/obj/item/radio/headset/headset_cent/alt/privsec
	name = "\proper the Nanotrasen private security bowman headset"
	desc = "A headset specifically for NTPS personnel, this one is for it's security personnel. Protects ears from flashbangs."
	icon = 'modular_zzplurt/icons/obj/clothing/headsets.dmi'
	icon_state = "nano_headset_alt"
	keyslot2 = /obj/item/encryptionkey/headset_sec

/obj/item/radio/headset/headset_cent/alt/privsec/empty
	name = "\proper the damaged Nanotrasen private security bowman headset"
	desc = "A headset specifically for NTPS personnel, this one is for it's security personnel. Protects ears from flashbangs, \
		or at least it used to, it's been damaged, and lost it's original keys."
	keyslot = null
	keyslot2 = null

/obj/item/radio/headset/headset_cent/alt/privsec/empty/Initialize(mapload)
	return

/obj/item/radio/headset/headset_cent/alt/privsec/medic
	desc = "A headset specifically for NTPS personnel, this one is for it's medical personnel. Protects ears from flashbangs."
	keyslot2 = /obj/item/encryptionkey/headset_medsec

/obj/item/radio/headset/headset_cent/alt/privsec/leader
	desc = "A headset specifically for NTPS personnel, this one is for it's commanding officers. Protects ears from flashbangs."
	keyslot2 = /obj/item/encryptionkey/heads/hos
	command = TRUE
