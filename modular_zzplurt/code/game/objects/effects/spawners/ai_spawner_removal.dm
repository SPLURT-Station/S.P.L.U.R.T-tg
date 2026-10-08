/// Remove robocop from harmless AI module spawner
/obj/effect/spawner/random/aimodule/harmless/spawn_loot(lootcount_override)
	loot -= /obj/item/ai_module/law/core/full/robocop
	return ..()
