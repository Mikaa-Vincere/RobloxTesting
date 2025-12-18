-- ============================================
-- UNIVERSAL FIGHTING GAME EXPLOIT PACK
-- Untuk game dengan sistem: HEAL, DODGE, DAMAGE, BLOCK
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- CONFIGURASI
local Config = {
    DamageMultiplier = 999,          -- Perkalian damage (50x)
    GodMode = true,                 -- Tidak bisa mati
    InfiniteHeal = true,            -- Heal unlimited
    AutoDodge = true,               -- Auto hindar serangan
    NoCooldown = true,              -- No skill cooldown
    OneHitKO = false                -- Musuh mati 1 pukulan
}

-- UI NOTIFICATION
local function Notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 3
    })
end

Notify("FIGHTING PACK", "Loaded for Kheirpoji/Dodge Game")

-- ========================
-- 1. DAMAGE MULTIPLIER
-- ========================
local function HookDamageSystem()
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local name = obj.Name:lower()
            if name:find("damage") or name:find("hit") or name:find("punch") or name:find("attack") then
                local oldFire = obj.FireServer
                obj.FireServer = function(self, ...)
                    local args = {...}
                    for i, arg in pairs(args) do
                        if type(arg) == "number" then
                            -- Perkalian damage keluar
                            if arg > 0 and arg < 1000 then
                                args[i] = arg * Config.DamageMultiplier
                            end
                            -- Jika OneHitKO aktif
                            if Config.OneHitKO and arg > 0 then
                                args[i] = 999999
                            end
                        end
                    end
                    return oldFire(self, unpack(args))
                end
                print("[HOOKED] Damage Event:", obj.Name)
            end
        end
    end
end

-- ========================
-- 2. GOD MODE & INFINITE HEAL
-- ========================
local function SetupGodMode()
    LocalPlayer.CharacterAdded:Connect(function(char)
        wait(0.5)
        local humanoid = char:WaitForChild("Humanoid")
        
        if Config.GodMode then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            
            humanoid.Changed:Connect(function()
                if humanoid.Health < 1000 then
                    humanoid.Health = math.huge
                end
            end)
        end
        
        if Config.InfiniteHeal then
            -- Hook heal function
            spawn(function()
                while wait(0.1) do
                    if humanoid.Health < humanoid.MaxHealth then
                        humanoid.Health = humanoid.MaxHealth
                    end
                end
            end)
        end
    end)
end

-- ========================
-- 3. AUTO DODGE
-- ========================
local function AutoDodgeSystem()
    if not Config.AutoDodge then return end
    
    spawn(function()
        while wait() do
            pcall(function()
                -- Cari event/method dodge
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("DodgeEvent") 
                             or game:GetService("ReplicatedStorage"):FindFirstChild("AvoidEvent")
                
                if remote then
                    -- Trigger dodge secara konstan
                    remote:FireServer()
                else
                    -- Alternatif: modify dodge cooldown
                    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                        if v.Name:lower():find("dodge") and v:IsA("NumberValue") then
                            v.Value = 0  -- No cooldown
                        end
                    end
                end
            end)
        end
    end)
end

-- ========================
-- 4. NO COOLDOWN SYSTEM
-- ========================
local function RemoveCooldowns()
    if not Config.NoCooldown then return end
    
    spawn(function()
        while wait(0.5) do
            pcall(function()
                -- Hapus semua cooldown values
                for _, v in pairs(game:GetDescendants()) do
                    if v:IsA("NumberValue") or v:IsA("IntValue") then
                        local name = v.Name:lower()
                        if name:find("cool") or name:find("delay") or name:find("wait") or name:find("timer") then
                            v.Value = 0
                        end
                    end
                end
            end)
        end
    end)
end

-- ========================
-- 5. STATS BOOSTER (STRENGTH, POWER, ETC)
-- ========================
local function BoostStats()
    spawn(function()
        while wait(2) do
            pcall(function()
                if LocalPlayer.Character then
                    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("NumberValue") then
                            local name = v.Name:lower()
                            if name:find("str") or name:find("power") or name:find("attack") or name:find("damage") then
                                v.Value = v.Value * Config.DamageMultiplier
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- ========================
-- 6. ANTI-STUN / ANTI-KNOCKBACK
-- ========================
local function AntiStun()
    spawn(function()
        while wait() do
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local humanoid = char:FindFirstChild("Humanoid")
                    if humanoid then
                        -- Hilangkan stun state
                        for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                            if state.Name:find("Stun") or state.Name:find("Knock") or state.Name:find("Fall") then
                                humanoid:SetStateEnabled(state, false)
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- ========================
-- 7. AUTO WIN ROUND SYSTEM
-- ========================
local function AutoWinRound()
    spawn(function()
        while wait(5) do
            pcall(function()
                -- Cari round system
                for _, v in pairs(game:GetDescendants()) do
                    if v:IsA("IntValue") and (v.Name:find("round") or v.Name:find("bulat")) then
                        -- Set round ke final
                        v.Value = 10
                    end
                    if v:IsA("StringValue") and v.Name:find("winner") then
                        -- Set player sebagai winner
                        v.Value = LocalPlayer.Name
                    end
                end
            end)
        end
    end)
end

-- ========================
-- 8. VISUAL ESP (MUSUH HIGHLIGHT)
-- ========================
local function EnemyESP()
    spawn(function()
        while wait(0.5) do
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local char = player.Character
                        local highlight = char:FindFirstChild("ESP_Highlight") or Instance.new("Highlight")
                        highlight.Name = "ESP_Highlight"
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                        highlight.Parent = char
                    end
                end
            end)
        end
    end)
end

-- ========================
-- EXECUTE SEMUA SYSTEM
-- ========================
HookDamageSystem()
SetupGodMode()
AutoDodgeSystem()
RemoveCooldowns()
BoostStats()
AntiStun()
AutoWinRound()
EnemyESP()

-- UI CONTROL PANEL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local function CreateButton(text, position, toggleFunc)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 150, 0, 40)
    button.Position = position
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = ScreenGui
    
    button.MouseButton1Click:Connect(function()
        toggleFunc()
        Notify("SYSTEM", text .. " Toggled")
    end)
end

CreateButton(UDim2.new(0, 10, 0, 50), function()
    Config.DamageMultiplier = Config.DamageMultiplier * 2
    Notify("DAMAGE", "Now: " .. Config.DamageMultiplier .. "x")
end)

CreateButton(UDim2.new(0, 10, 0, 100), function()
    Config.GodMode = not Config.GodMode
    Notify("GOD MODE", Config.GodMode and "ON" or "OFF")
end)

CreateButton(UDim2.new(0, 10, 0, 150), function()
    Config.AutoDodge = not Config.AutoDodge
    Notify("AUTO DODGE", Config.AutoDodge and "ON" or "OFF")
end)

print("[SYSTEM LOADED] Fighting Game Exploit Pack Active")
print("Game Features Detected: Heal, Dodge, Damage, Block System")
print("Made for Delta Executor")
