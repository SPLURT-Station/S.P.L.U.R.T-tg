-- Debug hack: makes clientless mobs pass `if(mob.canon_client)` checks, e.g. the dream reaper's.
--
-- The dreamviewer case is why this is a loop and not just a one-shot. Going under moves the mind to a
-- new body in the backrooms, so the sleeping station body Logout()s, become_uncliented() nulls its
-- canon_client, and the reaper refuses it. That body already existed, so hooking mob creation never
-- catches it - only a sweep does.
--
-- canon_client is typed /client and plenty of code dereferences it. Anything doing
-- canon_client?.something on a faked mob will runtime, since ?. guards null, not "is a number".
-- MODE = "dreamviewer" keeps it to the handful of bodies the reaper actually targets.
-- Turn it off again with STOP = true.

local SS13 = require("SS13")

-- Config ---------------------------------------------------------------------

local VALUE = 1
-- "dreamviewer": only humans wearing a dreamviewer. "all": every mob missing a canon_client.
local MODE = "dreamviewer"
-- Seconds between sweeps. Also how long after going under before the body becomes extractable.
local INTERVAL = 2
-- Also fake it the instant a mob is created, rather than waiting for the next sweep.
local WATCH_NEW_MOBS = true
-- true: stop the loop, unhook, clear the fake value back off, and stop. Nothing else runs.
local STOP = false

-- Constants ------------------------------------------------------------------

local COMSIG_GLOB_MOB_CREATED = "!mob_created"
local DREAMVIEWER = "/obj/item/clothing/head/dreamviewer"

-- Persists across runs in this state so STOP can find what a previous run started.
__fake_canon = __fake_canon or {}
__fake_canon.value = VALUE
__fake_canon.mode = MODE

-- Helpers --------------------------------------------------------------------

-- Only fills the gap. A mob with a real client already has canon_client set by Login(), so this
-- never overwrites one, and it is idempotent once faked.
local function fake_if_missing(mob)
	if mob.canon_client then
		return false
	end
	mob.canon_client = __fake_canon.value
	return true
end

local function sweep()
	if __fake_canon.mode == "all" then
		for _, mob in dm.global_vars.GLOB.mob_list do
			if SS13.is_valid(mob) then
				fake_if_missing(mob)
			end
		end
		return
	end

	-- human_list rather than mob_list: head only exists on carbons, and the reaper only ever
	-- targets humans anyway.
	for _, human in dm.global_vars.GLOB.human_list do
		if SS13.is_valid(human) and SS13.istype(human.head, DREAMVIEWER) then
			fake_if_missing(human)
		end
	end
end

if not __fake_canon.handler then
	-- Signal args match DM: (source, ...). SEND_GLOBAL_SIGNAL passes the new mob.
	__fake_canon.handler = function(_source, mob)
		if __fake_canon.mode == "all" then
			fake_if_missing(mob)
		end
	end
end

local function stop_everything()
	if __fake_canon.loop_id then
		SS13.end_loop(__fake_canon.loop_id)
		__fake_canon.loop_id = nil
	end
	if __fake_canon.hooked then
		SS13.unregister_signal(dm.global_vars.SSdcs, COMSIG_GLOB_MOB_CREATED, __fake_canon.handler)
		__fake_canon.hooked = false
	end
end

-- Main -----------------------------------------------------------------------

if STOP then
	stop_everything()
	local cleared = 0
	for _, mob in dm.global_vars.GLOB.mob_list do
		if SS13.is_valid(mob) and mob.canon_client == __fake_canon.value then
			mob.canon_client = nil
			cleared = cleared + 1
		end
	end
	print(("Stopped. Cleared the fake value off %d mob(s)."):format(cleared))
	return
end

-- A second run replaces the first rather than stacking another loop on top.
stop_everything()

sweep()
__fake_canon.loop_id = SS13.start_loop(INTERVAL, -1, sweep)

if WATCH_NEW_MOBS then
	SS13.register_signal(dm.global_vars.SSdcs, COMSIG_GLOB_MOB_CREATED, __fake_canon.handler)
	__fake_canon.hooked = true
end

print(("Faking canon_client every %ds, mode %q. Sweeping now."):format(INTERVAL, MODE))
