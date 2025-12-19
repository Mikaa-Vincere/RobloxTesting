-- DUELING GROUNDS HACK SCRIPT
-- By DARK VERSE v1 | Owner: MikaaDev - V0.1
-- Special for Dueling Grounds PVP Game

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Backpack = Player.Backpack
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("[DARK VERSE] Game Detected: DUELING GROUNDS")
print("[DARK VERSE] Game Type: PVP Fighting/Duel")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DuelingHack"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.2, 0, 0.3, 0)
MainFrame.Position = UDim2.new(0.78, 0, 0.68, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 0.2
MainFrame.Parent = ScreenGui

local Logo = Instance.new("ImageLabel")
Logo.Image = "rbxassetid://100166477433523"
Logo.Size = UDim2.new(0.9, 0, 0.15, 0)
Logo.Position = UDim2.new(0.05, 0, 0.05, 0)
Logo.BackgroundTransparency = 1
Logo.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "DUELING GROUNDS HACK"
Title.Size = UDim2.new(0.9, 0, 0.08, 0)
Title.Position = UDim2.new(0.05, 0, 0.22, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

local OwnerLabel = Instance.new("TextLabel")
OwnerLabel.Text = "@MikaaDev - V0.1"
OwnerLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
OwnerLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
OwnerLabel.BackgroundTransparency = 1
OwnerLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
OwnerLabel.Font = Enum.Font.Gotham
OwnerLabel.TextSize = 11
OwnerLabel.Parent = MainFrame

-- FITUR UTAMA PVP GAME
local features = {
    ["OneHitKill"] = false,      -- 1 hit kill musuh
    ["GodMode"] = false,         -- Tidak bisa mati
    ["DamageBoost"] = false,     -- Damage multiplier
    ["SpeedHack"] = false,       -- Speed movement
    ["AntiStun"] = false,        -- Tidak bisa di-stun
    ["AutoBlock"] = false,       -- Auto block attack
    ["AutoDodge"] = false,       -- Auto dodge
    ["RangeExtend"] = false,     -- Serangan jangkauan jauh
    ["InfiniteCombo"] = false,   -- Combo tidak terputus
    ["CoinsHack"] = false        -- Auto coin/rewards
}

-- ONE HIT KILL SYSTEM
local function oneHitKillSystem()
    while features["OneHitKill"] do
        pcall(function()
            -- Cari semua player musuh
            for _, targetPlayer in pairs(Players:GetPlayers()) do
                if targetPlayer ~= Player then
                    local targetChar = targetPlayer.Character
                    if targetChar and targetChar:FindFirstChild("Humanoid") then
                        -- Direct kill
                        targetChar.Humanoid.Health = 0
                        
                        -- Lewat remote jika ada
                        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                        if remotes then
                            local damageRemote = remotes:FindFirstChild("Damage") or remotes:FindFirstChild("Hit") or remotes:FindFirstChild("TakeDamage")
                            if damageRemote then
                                damageRemote:FireServer(targetPlayer, 99999)
                            end
                        end
                    end
                end
            end
        end)
        wait(0.3)
    end
end

-- GOD MODE SYSTEM
local function godModeSystem()
    while features["GodMode"] do
        pcall(function()
            if Character and Character:FindFirstChild("Humanoid") then
                local humanoid = Character.Humanoid
                
                -- Set health sangat tinggi
                humanoid.MaxHealth = 99999
                humanoid.Health = 99999
                
                -- Invincibility
                humanoid:SetAttribute("Invincible", true)
                
                -- Cancel semua damage
                for _, connection in pairs(getconnections(humanoid.Touched)) do
                    connection:Disable()
                end
            end
        end)
        wait(0.5)
    end
end

-- DAMAGE BOOST SYSTEM (9999 DAMAGE)
local function damageBoostSystem()
    while features["DamageBoost"] do
        pcall(function()
            -- Modifikasi semua weapon/tool
            for _, tool in pairs(Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    -- Set damage attribute
                    tool:SetAttribute("Damage", 9999)
                    tool:SetAttribute("BaseDamage", 9999)
                    
                    -- Modifikasi script damage
                    local script = tool:FindFirstChildWhichIsA("Script")
                    if script then
                        local src = script.Source
                        src = src:gsub("damage = %d+", "damage = 9999")
                        src = src:gsub("Damage = %d+", "Damage = 9999")
                        src = src:gsub("%.Damage = %d+", ".Damage = 9999")
                        script.Source = src
                    end
                    
                    -- Modifikasi configuration
                    local config = tool:FindFirstChild("Configuration")
                    if config then
                        local dmg = config:FindFirstChild("Damage") or config:FindFirstChild("damage")
                        if dmg then
                            dmg.Value = 9999
                        end
                    end
                    
                    -- Tambah damage modifier
                    tool:SetAttribute("DamageMultiplier", 100)
                end
            end
            
            -- Juga untuk weapon di character
            if Character then
                for _, tool in pairs(Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        tool:SetAttribute("Damage", 9999)
                    end
                end
            end
        end)
        wait(0.2)
    end
end

-- SPEED HACK SYSTEM
local function speedHackSystem()
    while features["SpeedHack"] do
        pcall(function()
            if Character and Character:FindFirstChild("Humanoid") then
                Character.Humanoid.WalkSpeed = 50
                Character.Humanoid.JumpPower = 100
            end
        end)
        wait(0.5)
    end
end

-- ANTI STUN SYSTEM
local function antiStunSystem()
    while features["AntiStun"] do
        pcall(function()
            if Character then
                -- Remove stun effects
                for _, part in pairs(Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        -- Hilangkan semua constraint/effect stun
                        for _, constraint in pairs(part:GetChildren()) do
                            if constraint.Name:lower():find("stun") or constraint.Name:lower():find("freeze") then
                                constraint:Destroy()
                            end
                        end
                    end
                end
                
                -- Cancel stun animations
                local humanoid = Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:SetAttribute("Stunned", false)
                    humanoid:SetAttribute("Frozen", false)
                end
            end
        end)
        wait(0.3)
    end
end

-- AUTO BLOCK SYSTEM
local function autoBlockSystem()
    while features["AutoBlock"] do
        pcall(function()
            -- Deteksi serangan datang
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Player then
                    local enemyChar = player.Character
                    if enemyChar and enemyChar:FindFirstChild("HumanoidRootPart") then
                        local distance = (Character.HumanoidRootPart.Position - enemyChar.HumanoidRootPart.Position).Magnitude
                        
                        if distance < 10 then -- Jika musuh dekat
                            -- Trigger block animation/state
                            local humanoid = Character:FindFirstChild("Humanoid")
                            if humanoid then
                                -- Set blocking state
                                humanoid:SetAttribute("Blocking", true)
                                
                                -- Cari remote block
                                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                                if remotes then
                                    local blockRemote = remotes:FindFirstChild("Block") or remotes:FindFirstChild("Defend")
                                    if blockRemote then
                                        blockRemote:FireServer(true)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        wait(0.1)
    end
end

-- COIN HACK SYSTEM
local function coinHackSystem()
    while features["CoinsHack"] do
        pcall(function()
            -- Method 1: Leaderstats
            local leaderstats = Player:FindFirstChild("leaderstats")
            if leaderstats then
                for _, stat in pairs(leaderstats:GetChildren()) do
                    if stat.Name:lower():find("coin") or stat.Name:lower():find("money") or stat.Name:lower():find("gold") then
                        stat.Value = 9999
                    end
                end
            end
            
            -- Method 2: Remote events
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                for _, remote in pairs(remotes:GetChildren()) do
                    if remote.Name:lower():find("coin") or remote.Name:lower():find("reward") or remote.Name:lower():find("currency") then
                        remote:FireServer(9999, "Win")
                    end
                end
            end
            
            -- Method 3: Game passes/shop
            Player:SetAttribute("Coins", 9999)
            Player:SetAttribute("Money", 9999)
        end)
        wait(2)
    end
end

-- CREATE TOGGLE BUTTONS
local buttonY = 0.38
local buttonHeight = 0.07

local function createPVPToggle(text, featureName, func)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, buttonHeight, 0)
    button.Position = UDim2.new(0.05, 0, buttonY, 0)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text .. " [OFF]"
    button.Font = Enum.Font.Gotham
    button.TextSize = 10
    button.Parent = MainFrame
    
    button.MouseButton1Click:Connect(function()
        features[featureName] = not features[featureName]
        
        if features[featureName] then
            button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            button.Text = text .. " [ON]"
            spawn(func)
        else
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            button.Text = text .. " [OFF]"
            
            -- Reset jika perlu
            if featureName == "SpeedHack" and Character and Character:FindFirstChild("Humanoid") then
                Character.Humanoid.WalkSpeed = 16
                Character.Humanoid.JumpPower = 50
            end
        end
    end)
    
    buttonY = buttonY + buttonHeight + 0.01
    return button
end

-- BUAT TOGGLE UNTUK DUELING GROUNDS
createPVPToggle("ONE HIT KILL", "OneHitKill", oneHitKillSystem)
createPVPToggle("GOD MODE", "GodMode", godModeSystem)
createPVPToggle("DAMAGE 9999", "DamageBoost", damageBoostSystem)
createPVPToggle("SPEED BOOST", "SpeedHack", speedHackSystem)
createPVPToggle("ANTI STUN", "AntiStun", antiStunSystem)
createPVPToggle("AUTO BLOCK", "AutoBlock", autoBlockSystem)
createPVPToggle("COIN 9999", "CoinsHack", coinHackSystem)

-- CHARACTER RECONNECT
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    wait(1)
    
    -- Re-apply active features
    if features["GodMode"] then
        pcall(function()
            local humanoid = Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 99999
                humanoid.Health = 99999
            end
        end)
    end
    
    if features["SpeedHack"] then
        pcall(function()
            local humanoid = Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 50
                humanoid.JumpPower = 100
            end
        end)
    end
end)

-- AUTO UPDATE LOOP
RunService.Heartbeat:Connect(function()
    pcall(function()
        -- Maintain active features
        if features["GodMode"] and Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.Health = 99999
        end
        
        if features["DamageBoost"] then
            for _, tool in pairs(Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool:SetAttribute("Damage", 9999)
                end
            end
        end
    end)
end)

print("[DARK VERSE] Dueling Grounds Hack LOADED!")
print("[DARK VERSE] Features: 1 Hit Kill, God Mode, Damage 9999, Speed, Anti-Stun, Auto Block, Coin Hack")
