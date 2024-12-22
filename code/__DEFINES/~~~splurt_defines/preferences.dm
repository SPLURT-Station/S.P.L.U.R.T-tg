#define LAZY_READ_PREF(target, pref) (!QDELETED(mob) && !isnull(mob.client) && mob.client.prefs.read_preference(pref))
