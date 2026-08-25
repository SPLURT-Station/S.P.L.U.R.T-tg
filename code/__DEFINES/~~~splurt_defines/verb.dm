/// Dynamically assigned verbs that target src in a view/range (GAME_VERB_PROC + set src in).
#define _GAME_VERB_PROC_SRC(owner_type, verb_path_name, src_value, verb_name, verb_desc, verb_category, show_in_context_menu, is_hidden, verb_args...) \
/datum/verb_metadata##owner_type/##verb_path_name \
{ \
	name = ##verb_name; \
	description = ##verb_desc; \
	category = ##verb_category; \
	verb_path = ##owner_type/proc/##verb_path_name; \
	body_path = ##owner_type/proc/__gvb_##verb_path_name; \
}; \
##owner_type/proc/##verb_path_name(##verb_args) \
{ \
	set name = ##verb_name; \
	set desc = ##verb_desc; \
	set hidden = ##is_hidden; \
	set popup_menu = ##show_in_context_menu; \
	set category = ##verb_category; \
	set src in src_value; \
	__gvb_##verb_path_name(arglist(args)); \
}; \
##owner_type/proc/__gvb_##verb_path_name(##verb_args)

#define GAME_VERB_PROC_SRC(owner_type, verb_path_name, src_value, verb_name, verb_category, verb_args...) \
_GAME_VERB_PROC_SRC(owner_type, verb_path_name, src_value, verb_name, "", verb_category, TRUE, FALSE, ##verb_args)

#define GAME_VERB_PROC_SRC_DESC(owner_type, verb_path_name, src_value, verb_name, verb_desc, verb_category, verb_args...) \
_GAME_VERB_PROC_SRC(owner_type, verb_path_name, src_value, verb_name, verb_desc, verb_category, TRUE, FALSE, ##verb_args)
