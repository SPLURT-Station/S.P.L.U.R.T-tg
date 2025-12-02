///Upstream edits
//Sizecode
#undef BODY_SIZE_MAX
#undef BODY_SIZE_MIN

#ifdef BODY_SIZE_MAX_OVERRIDE
	#define BODY_SIZE_MAX BODY_SIZE_MAX_OVERRIDE
#else
	#define BODY_SIZE_MAX 2.0
#endif

#ifdef BODY_SIZE_MIN_OVERRIDE
	#define BODY_SIZE_MIN BODY_SIZE_MIN_OVERRIDE
#else
	#define BODY_SIZE_MIN 0.1
#endif

//genitals
#undef TESTICLES_MAX_SIZE
#define TESTICLES_MAX_SIZE 8

#undef PENIS_MAX_LENGTH
#define PENIS_MAX_LENGTH 128

//sex
#define ORGAN_SLOT_BUTT "butt"
#define ORGAN_SLOT_BELLY "belly"
//arachnid organ slots

///arachnid organ slots
#define ORGAN_SLOT_EXTERNAL_MANDIBLES "mandibles"
#define ORGAN_SLOT_EXTERNAL_SPINNERET "spinneret"
#define ORGAN_SLOT_EXTERNAL_SPIDER_LEGS "spider_legs"

#define BUTT_MIN_SIZE 0
#define BUTT_MAX_SIZE 8

#define BREASTS_MIN_SIZE 0
#define BREASTS_MAX_SIZE 19

#define BELLY_MIN_SIZE 0
#define BELLY_MAX_SIZE 10
