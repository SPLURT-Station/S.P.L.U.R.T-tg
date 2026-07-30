/// Macro for getting the auxtools library file
#ifdef NO_EXTERNAL_LIBS
#define AUXLUA null
#else
#define AUXLUA (world.system_type == MS_WINDOWS ? "auxlua.dll" : __detect_auxtools("auxlua"))
#endif

/proc/__detect_auxtools(library)
#ifdef NO_EXTERNAL_LIBS
	return null
#else
	if(IsAdminAdvancedProcCall())
		return
	if (fexists("./lib[library].so"))
		return "./lib[library].so"
	else if (fexists("[world.GetConfig("env", "HOME")]/.byond/bin/lib[library].so"))
		return "[world.GetConfig("env", "HOME")]/.byond/bin/lib[library].so"
	else
		CRASH("Could not find lib[library].so")
#endif
