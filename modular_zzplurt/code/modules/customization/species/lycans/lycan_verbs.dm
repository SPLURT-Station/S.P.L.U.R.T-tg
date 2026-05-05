// cursekins can't transform if they have holy resistance (read: are thrown into silver handcuffs)
/datum/action/cooldown/spell/beast_form
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	antimagic_flags = MAGIC_RESISTANCE_HOLY
