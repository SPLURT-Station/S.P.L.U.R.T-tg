// oh yeah baby we're voiding
/datum/action/cooldown/spell/pointed/unsettle

	cooldown_time = 10 SECONDS // SPLURT change, decreased to 10 seconds from 12 seconds
	cast_range = 10 // SPLURT change, increased to 10 from 7

	/// how long we need to stare at someone to unsettle them (woooooh)
	stare_time = 5 SECONDS // SPLURT change, decreased to 5 seconds from 6 seconds
	/// how long we stun someone on successful cast
	stun_time = 2.5 SECONDS // SPLURT change, increased to 2.5 seconds from 2 seconds
	/// stamina damage we doooo
	stamina_damage = 85 // SPLURT change, increased to 85 from 80

/datum/action/cooldown/mob_cooldown/charge/sunwalker

	cooldown_time = 12 SECONDS // SPLURT change, increased to 12 seconds from 8 seconds

/datum/action/cooldown/mob_cooldown/charge/voidwalker

	charge_damage = 22 // SPLURT change, increased to 22 from 20
