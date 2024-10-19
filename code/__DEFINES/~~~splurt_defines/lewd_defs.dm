//organ defines
#define BUTT_LAYER_INDEX		1
#define ANUS_LAYER_INDEX		2
#define VAGINA_LAYER_INDEX		3
#define TESTICLES_LAYER_INDEX	4
#define GENITAL_LAYER_INDEX		5
#define PENIS_LAYER_INDEX		6
#define BELLY_LAYER_INDEX		7
#define BREASTS_LAYER_INDEX		8

#define GENITAL_LAYER_INDEX_LENGTH 8 //keep it updated with each new index added, thanks.

//genital flags
#define GENITAL_BLACKLISTED		(1<<0) //for genitals that shouldn't be added to GLOB.genitals_list.
#define GENITAL_INTERNAL		(1<<1)
#define GENITAL_HIDDEN			(1<<2)
#define GENITAL_THROUGH_CLOTHES	(1<<3)
#define GENITAL_FUID_PRODUCTION	(1<<4)
#define CAN_MASTURBATE_WITH		(1<<5)
#define MASTURBATE_LINKED_ORGAN	(1<<6) //used to pass our mission to the linked organ
#define CAN_CLIMAX_WITH			(1<<7)
#define GENITAL_CAN_AROUSE		(1<<8)
#define GENITAL_UNDIES_HIDDEN	(1<<9)
#define UPDATE_OWNER_APPEARANCE	(1<<10)
#define GENITAL_CAN_TAUR		(1<<11)
#define CAN_CUM_INTO 			(1<<12) //Sandstorm change
#define HAS_EQUIPMENT			(1<<13) //nother sandstorm change
#define GENITAL_CAN_STUFF       (1<<14) //Splurt edit, used for pregnancy
#define GENITAL_CHASTENED		(1<<15) //SPLURT edit
#define GENITAL_IMPOTENT		(1<<16) //SPLURT edit
#define GENITAL_EDGINGONLY		(1<<17) //SPLURT edit
#define GENITAL_DISAPPOINTING	(1<<18)	//SPLURT edit
#define GENITAL_OVERSTIM		(1<<19) //SPLURT edit
#define GENITAL_HYPERSENS		(1<<20) //SPLURT edit

//Citadel toggles because bitflag memes
#define MEDIHOUND_SLEEPER	(1<<0)
#define EATING_NOISES		(1<<1)
#define DIGESTION_NOISES	(1<<2)
#define BREAST_ENLARGEMENT	(1<<3)
#define PENIS_ENLARGEMENT	(1<<4)
#define FORCED_FEM			(1<<5)
#define FORCED_MASC			(1<<6)
#define HYPNO				(1<<7)
#define NEVER_HYPNO			(1<<8)
#define NO_APHRO			(1<<9)
#define NO_ASS_SLAP			(1<<10)
#define BIMBOFICATION		(1<<11)
#define NO_AUTO_WAG			(1<<12)
#define GENITAL_EXAMINE		(1<<13)
#define VORE_EXAMINE		(1<<14)
#define TRASH_FORCEFEED		(1<<15)
#define BUTT_ENLARGEMENT	(1<<16)
#define BELLY_INFLATION		(1<<17)
#define CHASTITY			(1<<18)
#define STIMULATION			(1<<19)
#define EDGING				(1<<20)
#define CUM_ONTO			(1<<21)

// Chastity traits
#define TRAIT_CHASTENED_ANUS "chastened_anus"
#define TRAIT_IMPOTENT_ANUS "impotent_anus"
#define TRAIT_EDGINGONLY_ANUS "edgingonly_anus"
#define TRAIT_DISAPPOINTING_ANUS "disappointing_anus"
#define TRAIT_OVERSTIM_ANUS "overstim_anus"
#define TRAIT_HYPERSENS_ANUS "hypersens_anus"
