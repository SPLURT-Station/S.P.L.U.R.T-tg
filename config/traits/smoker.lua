-- [==[ S.P.L.U.R.T. Smoker Trait - Reworked Nicotine Addiction
   Rebalanced per issue #1306 / Suggestion #1277:
   - Reduced withdrawal knockdown duration (10s → 4s)
   - Reduced withdrawal frequency (every 5min → every 12min)
   - Reduced withdrawal tick rate penalty (−1 → −0.4)
   - Reduced nicotine tolerance build-up rate by 40%
   - Reduced withdrawal severity multiplier (1.0 → 0.6)
   - Increased "urge" threshold so cravings are less frequent
   - Added grace period before first withdrawal possible
]==]

local trait = {}
trait.Name = "Smoker"
trait.Description = "You are addicted to nicotine. Running out of cigarettes causes withdrawal."
trait.Icon = "smoking"
trait.Color = Color3.fromRGB(180, 130, 80)
trait.Rarity = "Common"

-- ===== CONFIG =====
trait.Config = {
    -- Cigarette usage
    CigsPerSmoke = 1,
    SmokeDuration = 30,                  -- seconds a cigarette keeps you satisfied
    SmokeCooldown = 5,                   -- seconds between smokes

    -- Withdrawal system
    WithdrawalGracePeriod = 600,         -- 10min before first withdrawal is possible
    WithdrawalIntervalBase = 720,        -- 12min between withdrawal checks (was 300 = 5min)
    WithdrawalIntervalVariance = 180,    -- ±3min randomisation

    -- Withdrawal effects
    KnockdownDuration = 4,               -- seconds knocked down (was 10)
    UrgeTickRatePenalty = 0.4,           -- reduction in urgetick rate (was 1.0)
    UrgeTickRateMinimum = 0.15,          -- minimum urgetick rate during withdrawal
    WithdrawalSeverityMultiplier = 0.6,  -- global severity reduction (was 1.0)

    -- Tolerance
    ToleranceBuildRate = 0.6,            -- tolerance gained per smoke (was 1.0)
    ToleranceDecayRate = 0.05,           -- tolerance lost per minute without smoking
    ToleranceCap = 100,

    -- Craving thresholds
    CravingThreshold = 0.3,             -- fraction of smoke duration remaining when craving starts (was 0.15)
    MajorCravingThreshold = 0.1,        -- fraction when major craving (visual/audio cues) triggers
}

-- ===== STATE =====
trait.DefaultState = function(player)
    return {
        Cigarettes = 3,
        NicotineTolerance = 0,
        LastSmokeTime = os.time(),
        LastWithdrawalCheck = os.time(),
        NextWithdrawalAt = os.time() + trait.Config.WithdrawalGracePeriod,
        WithdrawalActive = false,
        WithdrawalSeverity = 0,
    }
end

-- ===== HELPERS =====
local function getRemainingSmoke(state, currentTime)
    local elapsed = currentTime - state.LastSmokeTime
    local remaining = trait.Config.SmokeDuration - elapsed
    return math.max(0, remaining)
end

local function shouldCheckWithdrawal(state, currentTime)
    if state.WithdrawalActive then return false end
    return currentTime >= state.NextWithdrawalAt
end

local function scheduleNextWithdrawal(state)
    local interval = trait.Config.WithdrawalIntervalBase
        + math.random(-trait.Config.WithdrawalIntervalVariance, trait.Config.WithdrawalIntervalVariance)
    state.NextWithdrawalAt = os.time() + interval
end

-- ===== EVENTS =====
trait.Events = {
    OnCharacterAdded = function(player, character)
        -- Nothing extra needed; passive system
    end,

    OnUpdate = function(player, state, deltaTime)
        local currentTime = os.time()
        local remaining = getRemainingSmoke(state, currentTime)
        local config = trait.Config

        -- Tolerance decay
        if remaining <= 0 then
            state.NicotineTolerance = math.max(0,
                state.NicotineTolerance - config.ToleranceDecayRate * deltaTime / 60)
        end

        -- Withdrawal check
        if shouldCheckWithdrawal(state, currentTime) then
            if remaining <= 0 and state.NicotineTolerance < 20 then
                -- Trigger withdrawal
                state.WithdrawalActive = true
                state.WithdrawalSeverity = config.WithdrawalSeverityMultiplier
                state.LastWithdrawalCheck = currentTime
                scheduleNextWithdrawal(state)

                -- Apply knockdown
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = true
                    humanoid.WalkSpeed = 0
                    task.delay(config.KnockdownDuration, function()
                        if state and state.WithdrawalActive then
                            state.WithdrawalActive = false
                            state.WithdrawalSeverity = 0
                            if humanoid.Parent then
                                humanoid.PlatformStand = false
                                humanoid.WalkSpeed = 16
                            end
                        end
                    end)
                end

                -- Notify player
                local plrData = require(game.ReplicatedStorage.Modules.PlayerData)
                local info = plrData:GetPlayerData(player)
                if info then
                    info.Notifications:Send({
                        Type = "Withdrawal",
                        Message = "Você está passando por abstinência de nicotina...",
                        Severity = "Medium",
                    })
                end
            else
                scheduleNextWithdrawal(state)
            end
        end

        -- Craving tick rate adjustment
        if remaining > 0 and remaining <= config.SmokeDuration * config.CravingThreshold then
            -- Mild craving: slight urgetick slowdown
            local plrData = require(game.ReplicatedStorage.Modules.PlayerData)
            local info = plrData:GetPlayerData(player)
            if info and info.StatusEffects then
                info.StatusEffects:AddModifer("NicotineCraving", {
                    Meta = { Stackable = true },
                    Value = { UrgetickRateModifier = -config.UrgeTickRatePenalty * config.WithdrawalSeverityMultiplier }
                })
            end
        end
    end,

    OnCigaretteUsed = function(player, state, amount)
        local config = trait.Config
        local used = math.min(amount or config.CigsPerSmoke, state.Cigarettes)
        if used <= 0 then return 0 end

        state.Cigarettes -= used
        state.LastSmokeTime = os.time()
        state.NicotineTolerance = math.min(config.ToleranceCap,
            state.NicotineTolerance + config.ToleranceBuildRate * used)

        -- Reset withdrawal if smoker has cigs
        if state.WithdrawalActive then
            state.WithdrawalActive = false
            state.WithdrawalSeverity = 0
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
                humanoid.WalkSpeed = 16
            end
        end

        return used
    end,

    OnBuyCigarettes = function(player, state, amount)
        state.Cigarettes += amount
    end,

    OnDeath = function(player, state)
        -- Reset state on death
        state.LastSmokeTime = os.time()
        state.WithdrawalActive = false
    end,
}

-- ===== UI =====
trait.UI = {
    InventoryPanel = function(player, frame)
        local state = trait.DefaultState(player)
        local config = trait.Config

        local label = frame:FindFirstChild("SmokerInfo")
        if not label then
            label = Instance.new("TextLabel")
            label.Name = "SmokerInfo"
            label.Font = Enum.Font.GothamSemibold
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(200, 180, 150)
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 0, 20)
            label.Parent = frame
        end

        return function()
            local data = require(game.ReplicatedStorage.Modules.PlayerData):GetPlayerData(player)
            local traitData = data.Traits and data.Traits.Smoker
            if not traitData then return end

            local remaining = getRemainingSmoke(traitData, os.time())
            local pct = remaining / config.SmokeDuration
            local cravingText = ""
            if remaining <= 0 then
                cravingText = " ⚠️ ABSTINÊNCIA"
            elseif pct < config.CravingThreshold then
                cravingText = " 🚬 Sentindo vontade..."
            elseif pct < config.MajorCravingThreshold then
                cravingText = " 💨 Vontade forte!"
            end

            label.Text = string.format("🚬 Cigarrilhas: %d%s",
                traitData.Cigarettes, cravingText)
        end
    end,
}

return trait
