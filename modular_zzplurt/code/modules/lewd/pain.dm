/mob/living/carbon/human/adjust_pain(change_amount, mob/living/carbon/human/partner, datum/interaction/interaction, position)
	var/old_pain = pain
	. = ..()
	if(pain <= old_pain || !client?.prefs?.read_preference(/datum/preference/toggle/erp/autoemote))
		return

	var/timbre
	if(gender == FEMALE || gender == MALE)
		timbre = gender
	else
		// Nonbinary uses physique instead
		timbre = physique

	if(timbre == FEMALE)
		conditional_pref_sound(src, pick('modular_zzplurt/sound/voice/painmoanf (1).ogg',
						'modular_zzplurt/sound/voice/painmoanf (2).ogg',
						'modular_zzplurt/sound/voice/painmoanf (3).ogg',
						'modular_zzplurt/sound/voice/painmoanf (4).ogg',
						'modular_zzplurt/sound/voice/painmoanf (5).ogg',
						'modular_zzplurt/sound/voice/painmoanf (6).ogg',
						'modular_zzplurt/sound/voice/painmoanf (7).ogg',
						'modular_zzplurt/sound/voice/painmoanf (8).ogg'), 25, pref_to_check = /datum/preference/toggle/erp/sounds)
	else
		conditional_pref_sound(src, pick('modular_zzplurt/sound/voice/painmoanm (1).ogg',
						'modular_zzplurt/sound/voice/painmoanm (2).ogg',
						'modular_zzplurt/sound/voice/painmoanm (3).ogg',
						'modular_zzplurt/sound/voice/painmoanm (4).ogg',
						'modular_zzplurt/sound/voice/painmoanm (5).ogg'), 25, pref_to_check = /datum/preference/toggle/erp/sounds)
