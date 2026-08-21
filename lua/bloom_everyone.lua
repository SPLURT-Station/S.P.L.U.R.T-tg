-- Gives the backrooms bloom distortion to everyone with a client, for a set time.
-- The distortions take a custom duration through on_creation, so no follow-up edit is needed.

local SS13 = require("SS13")

-- Config ---------------------------------------------------------------------

local DURATION_SECONDS = 30
-- true: only the admin's marked datum, for debugging.
local MARKED_ONLY = false
-- true: strip it back off instead of applying. Ignores DURATION_SECONDS.
local REVERT = false

local EFFECT = "/datum/status_effect/backrooms_distortion/bloom"

-- Targets --------------------------------------------------------------------

local function gather_targets()
	if MARKED_ONLY then
		local runner = SS13.get_runner_client()
		local marked = runner and runner.holder and runner.holder.marked_datum
		if not marked then
			print("No marked datum. Use the Mark Datum verb on a mob first.")
			return {}
		end
		if not SS13.istype(marked, "/mob/living") then
			print("Marked datum is not a /mob/living.")
			return {}
		end
		return { marked }
	end

	-- player_list is mobs with a client attached. A clientless mob has no HUD to hang the filter on,
	-- so it would just sit there retrying.
	local found = {}
	for _, mob in dm.global_vars.GLOB.player_list do
		if SS13.istype(mob, "/mob/living") then
			table.insert(found, mob)
		end
	end
	return found
end

-- Main -----------------------------------------------------------------------

local targets = gather_targets()
if #targets == 0 then
	print("No targets, nothing to do.")
	return
end

local effect_type = SS13.type(EFFECT)
local applied = 0

for _, mob in ipairs(targets) do
	if SS13.is_valid(mob) then
		if REVERT then
			mob:remove_status_effect(effect_type)
		else
			-- Deciseconds.
			mob:apply_status_effect(effect_type, DURATION_SECONDS * 10)
		end
		applied = applied + 1
	end
end

if REVERT then
	print(("Removed bloom from %d mob(s)."):format(applied))
else
	print(("Bloom on %d mob(s) for %ds."):format(applied, DURATION_SECONDS))
end
