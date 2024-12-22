#define LAZY_READ_PREF_FROM_MOB(target, pref) target.client?.prefs.read_preference(pref)
#define LAZY_READ_PREF_FROM_CLIENT(target, pref) target.prefs.read_preference(pref)
