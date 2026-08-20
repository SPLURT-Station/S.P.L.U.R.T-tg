-- Gives the backrooms arrival visuals to living mobs without moving or hiding them:
-- sleep, camera push in, hold, pull back out, plus FOV and the seven distortion effects.
-- No invisibility, no body swap, no z-level change.

local SS13 = require("SS13")

-- Config ---------------------------------------------------------------------

-- true: only the admin's marked datum. false: every living mob on a station z-level.
local MARKED_ONLY = true
-- true: strip the distortions and FOV back off the targets and stop. Nothing else runs.
local REVERT = false
-- true: take the distortions and FOV off again once the sequence ends.
local CLEAN_UP_AFTER = false

local ZOOM = 3
local ZOOM_SECONDS = 1.5
local ZOOM_STEPS = 15
-- How long they stay under at full zoom.
local HOLD_SECONDS = 5

-- Constants ------------------------------------------------------------------

local RENDER_PLANE_GAME = 40
local FOV_180_DEGREES = 180
local FOV_SOURCE = "lua_backrooms_sim"

-- Order matters: each apply_status_effect rebuilds the plane's filter list and cuts any animation
-- already running, so the two animated ones go last.
local DISTORTIONS = {
	"/datum/status_effect/backrooms_distortion/bloom",
	"/datum/status_effect/backrooms_distortion/colour_shift",
	"/datum/status_effect/backrooms_distortion/blur",
	"/datum/status_effect/backrooms_distortion/scanlines",
	"/datum/status_effect/backrooms_distortion/crt_border",
	"/datum/status_effect/backrooms_distortion/fisheye",
	"/datum/status_effect/backrooms_distortion/rolling_bar",
}

-- Helpers --------------------------------------------------------------------

local function station_z_levels()
	local found = {}
	for _, z in dm.global_vars.SSmapping:levels_by_trait("Station") do
		found[z] = true
	end
	return found
end

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

	local station = station_z_levels()
	local found = {}
	for _, mob in dm.global_vars.GLOB.player_list do
		if SS13.istype(mob, "/mob/living") then
			local turf = SS13.get_turf(mob)
			if turf and station[turf.z] then
				table.insert(found, mob)
			end
		end
	end
	return found
end

-- Scales the game plane masters, which reads as the camera pushing in. Assignment goes through
-- vv_edit_var, same as editing transform by hand in VV.
local function zoom(mob, scale)
	local hud = mob.hud_used
	if not hud then
		return
	end
	for _, plane in hud:get_true_plane_masters(RENDER_PLANE_GAME) do
		local scaled = dm.new("/matrix")
		scaled:Scale(scale)
		plane.transform = scaled
	end
end

local function zoom_all(targets, scale)
	for _, mob in ipairs(targets) do
		if SS13.is_valid(mob) then
			zoom(mob, scale)
		end
	end
end

-- Walks every target from one scale to the other together, so one slow mob does not stall the rest.
local function zoom_all_over_time(targets, from, to)
	for step = 1, ZOOM_STEPS do
		zoom_all(targets, from + (to - from) * (step / ZOOM_STEPS))
		SS13.wait(ZOOM_SECONDS / ZOOM_STEPS)
	end
end

local function apply_effects(mob)
	mob:add_fov_trait(FOV_SOURCE, FOV_180_DEGREES)
	for _, path in ipairs(DISTORTIONS) do
		mob:apply_status_effect(SS13.type(path))
	end
end

local function clear_effects(mob)
	mob:remove_fov_trait(FOV_SOURCE, FOV_180_DEGREES)
	for _, path in ipairs(DISTORTIONS) do
		mob:remove_status_effect(SS13.type(path))
	end
end

-- Main -----------------------------------------------------------------------

local targets = gather_targets()
if #targets == 0 then
	print("No targets, nothing to do.")
	return
end

if REVERT then
	for _, mob in ipairs(targets) do
		if SS13.is_valid(mob) then
			clear_effects(mob)
			zoom(mob, 1)
			mob:SetSleeping(0)
		end
	end
	print(("Reverted %d mob(s)."):format(#targets))
	return
end

print(("Running the backrooms arrival on %d mob(s)."):format(#targets))

for _, mob in ipairs(targets) do
	apply_effects(mob)
	-- Long enough to cover the whole sequence; woken explicitly at the end.
	mob:SetSleeping((ZOOM_SECONDS * 2 + HOLD_SECONDS + 10) * 10)
end

zoom_all_over_time(targets, 1, ZOOM)
SS13.wait(HOLD_SECONDS)
zoom_all_over_time(targets, ZOOM, 1)

for _, mob in ipairs(targets) do
	if SS13.is_valid(mob) then
		mob:SetSleeping(0)
		if CLEAN_UP_AFTER then
			clear_effects(mob)
		end
	end
end

print("Done.")
