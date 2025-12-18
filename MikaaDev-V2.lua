-- ============================================
-- DAMAGE MULTIPLIER SCRIPT
-- Untuk game "Tinju Beta!" di Roblox
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local DamageMultiplier = 999 -- Ubah angka ini untuk mengatur perkalian damage (contoh: 10x)

-- Metode 1: Hook function damage yang ada di ReplicatedStorage/RemoteEvents
local oldFireServer
local damageRemote = game:GetService("ReplicatedStorage"):FindFirstChild("PunchEvent") 
                     or game:GetService("ReplicatedStorage"):FindFirstChild("DamageEvent")
                     or game:GetService("ReplicatedStorage"):FindFirstChild("HitEvent")

if damageRemote then
    oldFireServer = damageRemote.FireServer
    damageRemote.FireServer = function(self, ...)
        local args = {...}
        -- Modifikasi argumen damage jika terdeteksi
        if args[2] and type(args[2]) == "number" then  -- Jika argumen ke-2 adalah damage value
            args[2] = args[2] * DamageMultiplier
        elseif args[1] and type(args[1]) == "number" then  -- Jika argumen ke-1 adalah damage
            args[1] = args[1] * DamageMultiplier
        end
        return oldFireServer(self, unpack(args))
    end
    print("[SUCCESS] Damage multiplier activated (" .. DamageMultiplier .. "x)")
end

-- Metode 2: Memory editing untuk stat damage player
local function increasePlayerDamage()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Cari value damage di dalam player stats
            for _, v in pairs(character:GetChildren()) do
                if v.Name:lower():find("damage") or v.Name:lower():find("strength") or v.Name:lower():find("power") then
                    if v.Value then
                        v.Value = v.Value * DamageMultiplier
                    elseif v:IsA("NumberValue") then
                        v.Value = v.Value * DamageMultiplier
                    end
                end
            end
        end
    end
end

-- Metode 3: Hook tool damage (jika menggunakan tool seperti boxing glove)
local function modifyToolDamage()
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local handle = tool:FindFirstChild("Handle")
            if handle then
                local script = tool:FindFirstChildOfClass("Script")
                if script then
                    -- Override script damage secara runtime
                    local source = script.Source
                    source = string.gsub(source, "damage%s*=%s*%d+", "damage = " .. DamageMultiplier .. " * %0")
                    pcall(function()
                        script.Source = source
                    end)
                end
            end
        end
    end
end

-- Auto-execute dan auto-reapply
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    increasePlayerDamage()
    modifyToolDamage()
end)

-- Execute saat pertama kali
if LocalPlayer.Character then
    increasePlayerDamage()
    modifyToolDamage()
end

-- UI Notifikasi
local ScreenGui = Instance.new("ScreenGui")
local TextLabel = Instance.new("TextLabel")
ScreenGui.Parent = game.CoreGui
TextLabel.Parent = ScreenGui
TextLabel.Text = "DAMAGE x" .. DamageMultiplier .. " ACTIVE"
TextLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
TextLabel.Size = UDim2.new(0, 200, 0, 50)
TextLabel.Position = UDim2.new(0, 10, 0, 10)
TextLabel.BackgroundTransparency = 0.7

print("[INFO] Punch damage increased by " .. DamageMultiplier .. "x")
