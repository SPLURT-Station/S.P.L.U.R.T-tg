#ifndef TRAIT_PRO_SKUB
#define TRAIT_PRO_SKUB "pro_skub"
#endif

#ifndef TRAIT_ANTI_SKUB
#define TRAIT_ANTI_SKUB "anti_skub"
#endif

GLOBAL_LIST_INIT(skub_fan_traits_modular, list(
	"TRAIT_ANTI_SKUB" = TRAIT_ANTI_SKUB,
	"TRAIT_PRO_SKUB" = TRAIT_PRO_SKUB,
))

/hook/startup/proc/register_skub_fan_traits()
	if(isnull(GLOB.traits_by_type[/mob]))
		GLOB.traits_by_type[/mob] = list()

	for(var/trait_name in GLOB.skub_fan_traits_modular)
		GLOB.traits_by_type[/mob][trait_name] = GLOB.skub_fan_traits_modular[trait_name]

	if(isnull(GLOB.admin_visible_traits[/mob]))
		GLOB.admin_visible_traits[/mob] = list()

	for(var/trait_name in GLOB.skub_fan_traits_modular)
		GLOB.admin_visible_traits[/mob][trait_name] = GLOB.skub_fan_traits_modular[trait_name]
