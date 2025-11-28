//Upstream defines that were undefined
#define ABSORB_NUTRITION_BARRIER 100
#define NUTRITION_PER_DAMAGE 2
#define NUTRITION_PER_KILL 50
#define VORE_SOUND_VOLUME 35
#define PREYLOOP_VOLUME 70
#define TRAIT_SOURCE_VORE "vore"


#define DIGEST_MODE_DRAIN "Drain"
#define DIGEST_MODE_HEAL "Heal"

GLOBAL_LIST_INIT(drain_messages_owner, list(
	"You feel %prey's energy flowing into you as your %belly drains them.",
	"Your %belly hungrily saps %prey's strength, feeding you their essence.",
	"You feel reinvigorated as your %belly draws sustenance from %prey without harming them.",
	"Your %belly gently pulls nutrition from %prey, leaving them tired but whole."
))

GLOBAL_LIST_INIT(drain_messages_prey, list(
	"You feel your energy flowing into %pred as their %belly drains you.",
	"%pred's %belly hungrily saps your strength, feeding them your essence.",
	"You feel tired as %pred's %belly draws sustenance from you without causing pain.",
	"%pred's %belly gently pulls nutrition from you, leaving you exhausted but unharmed."
))

GLOBAL_LIST_INIT(heal_messages_owner, list(
	"Your %belly gently surrounds %prey in soothing warmth, mending their wounds.",
	"You feel your %belly's comforting embrace healing %prey's injuries.",
	"Your %belly pulses with restorative energy, closing %prey's wounds.",
	"You sense your %belly working to repair the damage to %prey's body."
))

GLOBAL_LIST_INIT(heal_messages_prey, list(
	"%pred's %belly gently surrounds you in soothing warmth, mending your wounds.",
	"You feel %pred's %belly's comforting embrace healing your injuries.",
	"%pred's %belly pulses with restorative energy, closing your wounds.",
	"You sense %pred's %belly working to repair the damage to your body."
))
