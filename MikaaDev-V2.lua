-- ============================================
-- TINJU BETA! DAMAGE MULTIPLIER (DELTA OPTIMIZED)
-- ============================================

if not _G.DamageHooked then
    _G.DamageHooked = true
    
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local DamageMultiplier = 999 -- EDIT NILAI DISINI (50 = 50x damage)
    
    -- UI NOTIFICATION
    local function notify(msg)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "TINJU BETA EXPLOIT",
            Text = msg,
            Duration = 5
        })
    end
    
    notify("Damage x" .. DamageMultiplier .. " Activated")
    
    -- METHOD 1: REMOTE EVENT HOOKING
    local remoteNames = {"PunchEvent", "DamageEvent", "HitEvent", "CombatEvent", "AttackEvent"}
    local originalRemotes = {}
    
    for _, name in pairs(remoteNames) do
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild(name)
        if remote then
            originalRemotes[name] = remote.FireServer
            remote.FireServer = function(self, ...)
                local args = {...}
                -- Damage multiplier logic
                for i, arg in pairs(args) do
                    if type(arg) == "number" and arg > 0 and arg < 1000 then
                        args[i] = arg * DamageMultiplier
                        break
                    end
                end
                return originalRemotes[name](self, unpack(args))
            end
            print("[DELTA] Hooked RemoteEvent:", name)
        end
    end
    
    -- METHOD 2: PLAYER STATS MODIFICATION
    local function boostStats()
        if LocalPlayer.Character then
            for _, child in pairs(LocalPlayer.Character:GetDescendants()) do
                if child:IsA("NumberValue") then
                    local nameLower = child.Name:lower()
                    if nameLower:find("damage") or nameLower:find("strength") or nameLower:find("power") or nameLower:find("attack") then
                        child.Value = child.Value * DamageMultiplier
                    end
                end
            end
        end
    end
    
    -- METHOD 3: CONSTANT DAMAGE BOOST (LOOP)
    spawn(function()
        while wait(5) do
            boostStats()
        end
    end)
    
    -- AUTO REAPPLY ON RESPAWN
    LocalPlayer.CharacterAdded:Connect(function()
        wait(1)
        boostStats()
        notify("Damage Boost Reapplied")
    end)
    
    -- INITIAL BOOST
    boostStats()
    
    print("[DELTA] Tinju Beta Exploit Loaded | Multiplier:", DamageMultiplier)
    print("[DELTA] Made for Delta Executor")
end
