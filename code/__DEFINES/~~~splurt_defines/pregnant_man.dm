/// The divider for pregnancy duration, to allow for more or less precision
#define PREGNANCY_DURATION_MULTIPLIER (1 MINUTES)

/// Default duration of pregnancy, can be changed in preferences
#define PREGNANCY_DURATION_DEFAULT ((10 MINUTES) / PREGNANCY_DURATION_MULTIPLIER)
/// MINIMUM duration of pregnancy, set this to something reasonable or people are gonna pregnancymaxx to lag the server 🫄
#define PREGNANCY_DURATION_MINIMUM ((1 MINUTES) / PREGNANCY_DURATION_MULTIPLIER)
/// MAXIMUM duration of pregnancy, can be a ridiculous amount just fine but we shouldn't let players integer overflow 🫄
#define PREGNANCY_DURATION_MAXIMUM ((4 HOURS) / PREGNANCY_DURATION_MULTIPLIER)

/// Duration of the egg cycle for people who enabled oviposition, separate from the normal pregnancy cycle
#define PREGNANCY_EGG_DURATION ((5 MINUTES) / PREGNANCY_DURATION_MULTIPLIER)

/// Default chance to get pregnant when someone cums inside you, I'm not gonna add a menstrual cycle or anything, simple 1-100 stuff
#define PREGNANCY_CHANCE_DEFAULT 1
/// Minimum chance to get pregnant
#define PREGNANCY_CHANCE_MINIMUM 0
/// Maximum chance to get pregnant... Should probably be 100 obviously
#define PREGNANCY_CHANCE_MAXIMUM 100

/// Default genetic distribution of pregnancies, currently will heavily favor the mother by default
#define PREGNANCY_GENETIC_DISTRIBUTION_DEFAULT 10
/// Minimum genetic distribution of pregnancies
#define PREGNANCY_GENETIC_DISTRIBUTION_MINIMUM 0
/// Maximum genetic distribution of pregnancies
#define PREGNANCY_GENETIC_DISTRIBUTION_MAXIMUM 100

// Cool flags determining pregnancy behavior
/// Cryptic pregnancies are not detected by health analyzers
#define PREGNANCY_FLAG_CRYPTIC (1 << 0)
/// Pregnancy will inflate your belly
#define PREGNANCY_FLAG_BELLY_INFLATION (1 << 1)
/// Pregnancy will not create live eggs
#define PREGNANCY_FLAG_INERT (1 << 2)

#define PREGNANCY_FLAGS_DEFAULT (PREGNANCY_FLAG_BELLY_INFLATION)
