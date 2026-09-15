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

// CHOMPStation2 Shrink/Grow digest modes (issue #31, part 2)
#define DIGEST_MODE_SHRINK "Shrink"
#define DIGEST_MODE_GROW "Grow"

/// How much body size (as a multiplier) changes per second while in Shrink/Grow modes
#define VORE_RESIZE_RATE_PER_SECOND 0.01

GLOBAL_LIST_INIT(shrink_messages_owner, list(
	"Your %belly clenches down around %prey, and you feel them slowly shrink within you.",
	"You feel %prey dwindling smaller and smaller inside your %belly.",
	"Your %belly works over %prey, compressing them down to a more manageable size.",
	"You feel the pleasant weight of %prey lighten in your %belly as they shrink."
))

GLOBAL_LIST_INIT(shrink_messages_prey, list(
	"%pred's %belly clenches down around you, and you feel yourself slowly shrinking.",
	"You feel yourself dwindling smaller and smaller inside %pred's %belly.",
	"%pred's %belly works over your body, compressing you down to a more manageable size.",
	"You shrink ever smaller within %pred's %belly."
))

GLOBAL_LIST_INIT(grow_messages_owner, list(
	"Your %belly pulses warmly around %prey as you feel them growing larger inside you.",
	"You feel %prey's expanding form press outward against your %belly.",
	"Your %belly nourishes %prey's body, letting them swell to a grander size.",
	"You feel %prey grow bigger and fuller within your %belly."
))

GLOBAL_LIST_INIT(grow_messages_prey, list(
	"%pred's %belly pulses warmly around you as you feel yourself growing larger.",
	"You feel your expanding form press outward against %pred's %belly.",
	"%pred's %belly nourishes your body, letting you swell to a grander size.",
	"You grow bigger and fuller within %pred's %belly."
))
