#define LAZY_READ_PREF(target, pref) (CLIENT_FROM_VAR(target)?.prefs?.read_preference() || "Unset")
