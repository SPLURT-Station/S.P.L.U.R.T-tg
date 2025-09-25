// Masturbation interactions using own tail - inherits from base tail class
// Uses INTERACTION_SELF usage flag and CLIMAX_POSITION_USER targeting

/datum/interaction/lewd/tail/dick/self
	name = "Tail. Jerk Cock (self)"
	description = "Jerk yourself off with your tail."
	usage = INTERACTION_SELF
	target_required_parts = list()
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS)
	user_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY, ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	sound_possible = list('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg')
	help_text = list(
		"pleasures themselves, gliding their tail along their own cock.",
		"gently slides their tail up and down their cock, adapting to every movement.",
		"rhythmically caresses their cock with their tail, trying to bring themselves pleasure."
	)
	grab_text = list(
		"firmly grips their own cock with their tail, sliding along its full length.",
		"grips their cock with their tail without letting go, moving along it with increasing force.",
		"holds their cock in a tight ring of their tail and actively masturbates, not slowing the pace."
	)
	harm_text = list(
		"clearly wanting to cause themselves painful sensations, actively jerks their cock with their tail.",
		"intentionally squeezes their cock to the point of pain with their tail, masturbating with sharp movements.",
		"roughly works their tail on their cock, as if striving to experience pain and pleasure simultaneously."
	)
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list("covers their own tail with cum."))

/datum/interaction/lewd/tail/vagina/self
	name = "Tail. Penetrate Pussy (self)"
	description = "Penetrate yourself with your tail."
	usage = INTERACTION_SELF
	target_required_parts = list()
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_VAGINA)
	user_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY, ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED)
	help_text = list(
		"gently pushes their tail inside their own pussy.",
		"softly slides their tail in their own pussy.",
		"lovingly plays with their tail inside their pussy, moving smoothly and carefully."
	)

	grab_text = list(
		"insistently pounds into their own pussy, writhing from side to side.",
		"deeply inserts their tail into themselves, actively moving and moaning.",
		"pushes their tail deep into their pussy, not holding back thick thrusts and movements."
	)

	harm_text = list(
		"violates their own pussy with their tail, as if trying to thrust as deep as possible.",
		"forcefully drives their tail into themselves, as if deliberately causing themselves pain.",
		"roughly spreads their own pussy with their tail, acting sharply and without mercy."
	)
	sound_possible = list('modular_zzplurt/sound/interactions/champ1.ogg',
						'modular_zzplurt/sound/interactions/champ2.ogg')
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list("covers their own tail with juices."))

/datum/interaction/lewd/tail/vagina_rub/self
	name = "Tail. Rub Pussy (self)"
	description = "Rub yourself with your tail."
	usage = INTERACTION_SELF
	target_required_parts = list()
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_VAGINA)
	user_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY, ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED)
	help_text = list(
		"gently slides their tail around their own slit.",
		"tenderly moves near their own pussy, listening to their own feelings.",
		"rhythmically and softly pats their own cunt with their tail, trying to bring themselves maximum pleasure."
	)
	grab_text = list(
		"insistently presses into their own pussy with their tail, writhing from side to side.",
		"actively slaps their own pussy, forcefully pulling their own folds.",
		"pushes their tail into their own pussy and begins to move, as if about to enter inside."
	)
	harm_text = list(
		"mockingly rough slaps their own pussy with their tail, trying to leave pain from each strike.",
		"sharply slaps their own pussy with their tail using merciless force, as if trying to knock out their own strength.",
		"actively stretches their own folds with their tail, making themselves think about tearing their own body."
	)
	sound_possible = list('modular_zzplurt/sound/interactions/champ1.ogg',
						'modular_zzplurt/sound/interactions/champ2.ogg')
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list("covers their own tail with juices."))

/datum/interaction/lewd/tail/ass/self
	name = "Tail. Penetrate Ass (self)"
	description = "Penetrate yourself with your tail."
	usage = INTERACTION_SELF
	target_required_parts = list()
	user_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY, ORGAN_SLOT_ANUS = REQUIRE_GENITAL_EXPOSED)
	help_text = list(
		"slides inside their own bowels with their tail.",
		"carefully moves their tail in their own anus, enjoying the internal pressure.",
		"gently moves their tail inside themselves, massaging their rear passage."
	)
	grab_text = list(
		"actively rams their tail inside their own anus.",
		"sharply thrusts their tail into their own ring, moving with persistence and force.",
		"tightly fills their own ass with their tail, not stopping the movements."
	)
	harm_text = list(
		"violates their own ass with their tail, as if trying to pierce themselves through.",
		"mercilessly drives their tail into their own anus, not giving themselves the slightest rest.",
		"forcefully pushes their tail into their rear passage, as if striving to tear themselves apart from inside."
	)
	sound_possible = list('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg')
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list("tightly grips their own tail inside their ass."))

/datum/interaction/lewd/tail/ass_rub/self
	name = "Tail. Slide Between Cheeks (self)"
	description = "Stimulate yourself with your tail."
	usage = INTERACTION_SELF
	target_required_parts = list()
	user_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY, ORGAN_SLOT_ANUS = REQUIRE_GENITAL_EXPOSED)
	help_text = list(
		"slides between their own cheeks with their tail.",
		"gently moves their tail around their own anus, massaging it.",
		"teases their own ring with their tail, trying to bring pleasant sensations."
	)
	grab_text = list(
		"actively rubs their tail around their own anus, repeatedly trying to poke sensitive spots.",
		"presses their tail into their own anal opening, trying to open it by pulling their tail aside.",
		"rhythmically writhes between their own cheeks, writhing and pressing inward."
	)
	harm_text = list(
		"torments their own ass with their tail, as if trying to force their way inside.",
		"forcefully pulls at their own ass with their tail, causing painful sensations.",
		"roughly slaps their own ring, acting with force and without a drop of mercy to themselves."
	)
	sound_possible = list('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg')
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list("tightly grips their own tail."))

/datum/interaction/lewd/tail/urethra/self
	name = "Tail. Penetrate Urethra (self)"
	description = "Penetrate yourself with your tail."
	usage = INTERACTION_SELF
	target_required_parts = list()
	user_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY, ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	sound_possible = list('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg',
						'modular_zzplurt/sound/interactions/bang4.ogg',
						'modular_zzplurt/sound/interactions/bang5.ogg',
						'modular_zzplurt/sound/interactions/bang6.ogg',)
	help_text = list(
		"pushes and explores their own urethra with their tail.",
		"carefully moves their tail in their own urethra, feeling every curve and squeeze.",
		"slowly and smoothly advances their tail deep into their urethra, as if exploring from inside."
	)
	grab_text = list(
		"tries to reach their own groin through their urethra with their tail.",
		"stubbornly pushes their tail deep into their own urethra, striving to penetrate as far as possible.",
		"forcefully moves their tail through their urethra, as if wanting to touch the base of their body."
	)
	harm_text = list(
		"drives their tail into their own urethra, treating their body with obvious roughness.",
		"sharply and mercilessly pushes their tail inside their own urethra, ignoring the pain.",
		"harshly uses their urethra for tail penetration, causing themselves sharp, piercing sensations."
	)
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list("tightly grips their own tail with their urethra, covering it with cum."))

/datum/interaction/lewd/tail/breast/self
	name = "Tail. Slide Between Breasts (self)"
	description = "Stimulate yourself with your tail."
	usage = INTERACTION_SELF
	target_required_parts = list()
	user_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY, ORGAN_SLOT_BREASTS = REQUIRE_GENITAL_EXPOSED)
	help_text = list("gently slides between their own breasts with their tail.")
	grab_text = list("insistently presses their tail and writhes it between their own breasts.")
	harm_text = list("mockingly active writhes between their own breasts with their tail, almost slapping them.")

/datum/interaction/lewd/tail/self_oral
	name = "Mouth. Lick Tail (self)"
	description = "Lick your own tail."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_MOUTH)
	target_required_parts = list()
	user_required_parts = list(ORGAN_SLOT_TAIL = REQUIRE_GENITAL_ANY)
	help_text = list("licks the tip of their own tail.")
	grab_text = list("wraps their lips around the tip of their own tail.")
	harm_text = list("bites the tip of their own tail.")
	sound_possible = list('modular_zzplurt/sound/interactions/squelch1.ogg')
